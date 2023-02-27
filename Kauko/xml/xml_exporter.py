import logging
from collections import defaultdict
from datetime import datetime
from psycopg2.extras import DateRange, DictRow
from typing import Dict, List, Union
from xml.etree.ElementTree import dump, Element, ElementTree, fromstring, SubElement, tostring

#from qgis.core import QgsProject

from ..database.database import Database
from ..database.database_handler import (
    get_code_list,
    get_describing_texts,
    get_describing_lines,
    get_group_regulations,
    get_participation_and_evaluation_plans,
    get_planned_spaces,
    get_planners,
    get_plan_commentaries,
    get_plan_detail_lines,
    get_plan_regulations,
    get_regulation_groups,
    get_spatial_plan,
    get_supplementary_information,
    get_values,
    get_zoning_elements,
    set_spatial_plan_reference_id,
    set_spatial_plan_identity_id,
    set_spatial_plan_storage_time,
)

LOGGER = logging.getLogger("kauko")

CORE_NS = "lud-core"
SPLAN_NS = "splan"
NAMESPACES = {
    "xsi": "http://www.w3.org/2001/XMLSchema-instance",
    "xlink": "http://www.w3.org/1999/xlink",
    "gml": "http://www.opengis.net/gml/3.2",
    "gmlexr": "http://www.opengis.net/gml/3.3/exr",
    "lsp": "http://tietomallit.ymparisto.fi/ry-yhteiset/kielituki/xml/1.0",
    CORE_NS: "http://tietomallit.ymparisto.fi/mkp-ydin/xml/1.2",
    SPLAN_NS: "http://tietomallit.ymparisto.fi/kaavatiedot/xml/1.2",
}
FEATURECOLLECTION = CORE_NS + ":LandUseFeatureCollection"
FEATURECOLLECTION_ATTRIBUTES = {"xmlns:" + namespace: uri for namespace, uri in NAMESPACES.items()}
FEATURECOLLECTION_ATTRIBUTES["xsi:schemaLocation"] = "http://tietomallit.ymparisto.fi/kaavatiedot/xml/1.2 https://tietomallit.ymparisto.fi/kehitys/kaatio/xml/spatialplan-1.2.xsd"

# lud-core tags
FEATUREMEMBER = CORE_NS + ":featureMember"
PRODUCER_SPECIFIC_IDENTIFIER = CORE_NS + ":producerSpecificIdentifier"
OBJECT_IDENTIFIER = CORE_NS + ":objectIdentifier"
LATEST_CHANGE = CORE_NS + ":latestChange"
NAME = CORE_NS + ":loc_name"
BOUNDARY = CORE_NS + ":boundary"
LEGAL_EFFECTIVENESS = CORE_NS + ":legalEffectiveness"
RESPONSIBLE_ORGANIZATION = CORE_NS + ":responsibleOrganization"
VALIDITY_TIME = CORE_NS + ":validityTime"
CODE_SPACE = "http://uri.suomi.fi/object/rytj/kaava"

# splan tags
SPATIAL_PLAN = SPLAN_NS + ":SpatialPlan"
SPATIAL_PLAN_BUT_WITH_SMALL_INITIAL_JUST_FOR_FUN = SPLAN_NS + ":spatialPlan"
VALIDITY_TIME_INSIDE_SPLAN = SPLAN_NS + ":validityTime"
NAME_INSIDE_SPLAN = SPLAN_NS + ":loc_name"
PLAN_OBJECT = SPLAN_NS + ":PlanObject"
PLAN_ORDER = SPLAN_NS + ":PlanOrder"
PLAN_RECOMMENDATION = SPLAN_NS + ":PlanRecommendation"
PLAN_ORDER_GROUP = SPLAN_NS + ":PlanOrderGroup"
SUPPLEMENTARY_INFO = SPLAN_NS + ":supplementaryInfo"
SUPPLEMENTARY_INFORMATION = SPLAN_NS + ":SupplementaryInformation"
TARGET = SPLAN_NS + ":target"
MEMBER = SPLAN_NS + ":member"
GROUP_NUMBER = SPLAN_NS + ":groupNumber"
GEOMETRY = SPLAN_NS + ":geometry"
GROUND_RELATIVE_POSITION = SPLAN_NS + ":groundRelativePosition"
BINDINGNESS_OF_LOCATION = SPLAN_NS + ":bindingnessOfLocation"
TYPE = SPLAN_NS + ":type"
LIFECYCLE_STATUS = SPLAN_NS + ":lifecycleStatus"
COMMENTARY = SPLAN_NS + ":SpatialPlanCommentary"
PARTICIPATION_AND_EVALUATION_PLAN = SPLAN_NS + ":ParticipationAndEvaluationPlan"
PLANNER = SPLAN_NS + ":Planner"
PERSON_NAME = SPLAN_NS + ":personName"
PROFESSION_TITLE = SPLAN_NS + ":professionTitle"
ROLE = SPLAN_NS + ":role"

# GML tags
GML_POINT = "gml:Point"
GML_LINESTRING = "gml:LineString"
GML_POLYGON = "gml:Polygon"
GML_EXTERIOR = "gml:exterior"
GML_LINEAR_RING = "gml:LinearRing"
POS = "pos"
POS_LIST = "posList"
TIME_INSTANT = "gml:TimeInstant"
TIME_POSITION = "gml:timePosition"
TIME_PERIOD = "gml:TimePeriod"
BEGIN_POSITION = "gml:beginPosition"
END_POSITION = "gml:endPosition"
REFERENCE_IDENTIFIER = "gml:identifier"


def get_gml_id(entry: Union[DictRow, Dict]) -> Union[str, None]:
    """
    Return unique gml id for an entry in the database.
    """
    # XML is really particular about accepted identity strings. Notably, an identity string
    # cannot start with a number, since it will not fulfill the \\\\i-[:]][\\\\c-[:]]* XSD regex,
    # as reported by the Kaatio API.
    #
    # This means we cannot use the bare local id here. The id will be thrown
    # away by the API when POSTing, but it still has to pass validation. We are
    # free to use local_id for gml id at each save.
    local_id = entry["local_id"]
    return "id-" + local_id if local_id else None


def add_time_period(parent: Element, period: DateRange) -> Element:
    """
    Create GML time period element with given time period.

    :param parent: Element under which time period should be added
    :param period: Time period to add
    :return: Created GML element
    """
    time_period = SubElement(parent, TIME_PERIOD)
    begin_position = SubElement(time_period, BEGIN_POSITION)
    if period.lower:
        begin_position.text = period.lower.isoformat()
    else:
        begin_position.set("indeterminatePosition", "unknown")
    end_position = SubElement(time_period, END_POSITION)
    if period.upper:
        end_position.text = period.upper.isoformat()
    else:
        end_position.set("indeterminatePosition", "unknown")
    return time_period


def add_time_position(parent: Element, position: datetime, attrib: Dict = None) -> Element:
    """
    Create GML time instant element with given time position and extra tags.

    :param parent: Element under which time instant should be added
    :param position: Time instant to add
    :param attrib: Extra attributes to add to the time instant
    :return: Created GML element
    """
    time_instant = SubElement(parent, TIME_INSTANT, attrib if attrib else {})
    time_position = SubElement(time_instant, TIME_POSITION)
    time_position.text = position.isoformat()
    return time_instant


def add_point(parent: Element, gml: str, id: str) -> Element:
    """
    Create GML point element with given GML and GML id.

    :param parent: Element under which point should be added
    :param gml: Geometry GML from ST_asGML
    :param str: Valid gml id for point
    :return: Created element
    """
    gml_element = fromstring(gml)
    srs_name = gml_element.get("srsName")
    point = SubElement(parent, GML_POINT, {"srsName": srs_name, "gml:id": id})
    position = SubElement(point, f"gml:{POS}")

    # TODO: only support single points for now
    incoming_pos = gml_element.findall(f'.//{POS}')[0]
    position.text = incoming_pos.text
    return point


def add_linestring(parent: Element, gml: str, id: str) -> Element:
    """
    Create GML line element with given GML and GML id.

    :param parent: Element under which line should be added
    :param gml: Geometry GML from ST_asGML
    :param str: Valid gml id for line
    :return: Created element
    """
    # PostGIS creates linestring inside multicurve and curve member by default. Add element
    # to simple linestring instead.
    gml_element = fromstring(gml)
    srs_name = gml_element.get("srsName")
    linestring = SubElement(parent, GML_LINESTRING, {"srsName": srs_name, "gml:id": id, "srsDimension": "2"})
    pos_list = SubElement(linestring, f"gml:{POS_LIST}")

    # TODO: only support single linestrings for now
    incoming_pos_list = gml_element.findall(f'.//{POS_LIST}')[0]
    pos_list.text = incoming_pos_list.text

    return linestring


def add_polygon(parent: Element, gml: str, id: str) -> Element:
    """
    Create GML polygon element with given GML and GML id.

    :param parent: Element under which polygon should be added
    :param gml: Geometry GML from ST_asGML
    :param str: Valid gml id for polygon
    :return: Created element
    """
    # PostGIS creates polygon inside multisurface and surface member by default. Add element
    # to simple polygon instead.
    gml_element = fromstring(gml)
    srs_name = gml_element.get("srsName")
    polygon = SubElement(parent, GML_POLYGON, {"srsName": srs_name, "gml:id": id})
    exterior = SubElement(polygon, GML_EXTERIOR)
    linear_ring = SubElement(exterior, GML_LINEAR_RING)
    pos_list = SubElement(linear_ring, f"gml:{POS_LIST}")

    # TODO: only support polygons without holes for now
    incoming_pos_list = gml_element.findall(f'.//{POS_LIST}')[0]
    pos_list.text = incoming_pos_list.text
    return polygon


def add_language_string_elements(parent: Element, tag: str, strings: Dict[str, str]) -> List[Element]:
    """
    Create XML language string elements for all languages in strings.

    :param parent: Element under which language strings should be added
    :param tag: Tag to use for the elements
    :param strings: Dict of language codes and strings
    :return: Created elements
    """
    elements = []
    for language, text in strings.items():
        element = SubElement(parent, tag, {"xml:lang": language})
        element.text = text
        elements.append(element)
    return elements


def add_code_element(
        parent: Element,
        tag: str,
        code_list: Dict[int, DictRow],
        code_value: str,
        title_field: str = "preflabel_fi"
    ) -> Element:
    """
    Create code element under specified element from code value and code list.

    :param feature: Element under which code should be added
    :param tag: Tag to use for the code element
    :param code_list: Code list to use to look up code value
    :param code_value: Code value to use
    :param label_field: Field to use for xlink:title tag, if not the default "preflabel_fi".
    :return: Created element
    """
    code_data = code_list[code_value]
    return SubElement(parent, tag, {
        "xlink:href": code_data.get("uri", ""),
        "xlink:title": code_data.get(title_field, "")
    })


def add_value_element(parent: Element, value_type: str, value: DictRow) -> Element:
    """
    Create value element under specified element.

    :param feature: Element under which value should be added
    :param tag: Value type string
    :param value: Value contents to add
    :return: Created element
    """
    VALUE = SPLAN_NS + ":value"
    VALUE_TYPE_MAP = {
        "code_value": SPLAN_NS + ":CodeValue",
        "geometry_area_value": SPLAN_NS + ":GeometryValue",
        "geometry_line_value": SPLAN_NS + ":GeometryValue",
        "geometry_point_value": SPLAN_NS + ":GeometryValue",
        "identifier_value": SPLAN_NS + ":IdentityValue",
        "numeric_double_value": SPLAN_NS + ":NumericValue",
        "numeric_range": SPLAN_NS + ":NumericRange",
        "text_value": SPLAN_NS + ":TextValue",
        "time_instant_value": SPLAN_NS + ":TimeInstantValue",
        "time_period_value": SPLAN_NS + ":TimePeriodValue",
    }
    UNIT_OF_MEASURE = SPLAN_NS + ":unitOfMeasure"
    container_element = SubElement(parent, VALUE)
    type_element = SubElement(container_element, VALUE_TYPE_MAP[value_type])
    if value_type == "text_value":
        add_language_string_elements(type_element, VALUE, value["value"])
    elif value_type == "code_value":
        CODE_LIST_IDENTIFIER = SPLAN_NS + ":codelistIdentifier"
        LABEL = SPLAN_NS + ":label"
        value_element = SubElement(type_element, VALUE)
        value_element.text = value["value"]
        code_list_element = SubElement(type_element, CODE_LIST_IDENTIFIER)
        code_list_element.text = value["code_list"]
        add_language_string_elements(type_element, LABEL, value["title"])
    elif value_type == "identifier_value":
        SYSTEM_IDENTIFIER = SPLAN_NS + ":systemIdentifier"
        SYSTEM_NAME = SPLAN_NS + ":systemValue"
        value_element = SubElement(type_element, VALUE)
        value_element.text = value["value"]
        system_identifier_element = SubElement(type_element, SYSTEM_IDENTIFIER)
        system_identifier_element.text = value["register_id"]
        add_language_string_elements(type_element, SYSTEM_NAME, value["register_name"])
    elif value_type == "numeric_double_value":
        value_element = SubElement(type_element, VALUE)
        value_element.text = str(value["value"])
        unit_element = SubElement(type_element, UNIT_OF_MEASURE)
        unit_element.text = value["unit_of_measure"]
    elif value_type == "numeric_range":
        MINIMUM_VALUE = SPLAN_NS + ":minimumValue"
        MAXIMUM_VALUE = SPLAN_NS + ":maximumValue"
        minimum_element = SubElement(type_element, MINIMUM_VALUE)
        minimum_element.text = str(value["minimum_value"])
        maximum_element = SubElement(type_element, MAXIMUM_VALUE)
        maximum_element.text = str(value["maximum_value"])
        unit_element = SubElement(type_element, UNIT_OF_MEASURE)
        unit_element.text = value["unit_of_measure"]
    elif value_type == "time_instant_value":
        value_element = SubElement(type_element, VALUE)
        add_time_position(value_element, value["value"])
    elif value_type == "time_period_value":
        value_element = SubElement(type_element, VALUE)
        add_time_period(value_element, value["value"])
    elif value_type == "geometry_area_value":
        value_element = SubElement(type_element, VALUE)
        add_polygon(value_element, value["gml"], "id-" + value["geometry_area_value_uuid"])
    elif value_type == "geometry_line_value":
        value_element = SubElement(type_element, VALUE)
        add_linestring(value_element, value["gml"], "id-" + value["geometry_line_value_uuid"])
    elif value_type == "geometry_point_value":
        value_element = SubElement(type_element, VALUE)
        add_point(value_element, value["gml"], "id-" + value["geometry_point_value_uuid"])
    return container_element


class XMLExporter:
    def __init__(self, db: Database, schema: str) -> None:
        self.db = db
        self.schema = schema
        self.root = Element(FEATURECOLLECTION, {**FEATURECOLLECTION_ATTRIBUTES, "gml:id": "foobar"})
        self.plan_id = ""
        self.lifecycle_status = 0

        self.legal_effectiveness_kinds = get_code_list("legal_effectiveness_kind", db)
        # TODO: poistettava "code"-parametri kunhan finnish_municipality_codes-taulu on
        # standardimuodossa (codevalue, uri, preflabel_fi):
        self.finnish_municipality_codes = get_code_list("finnish_municipality_codes", db, "code")
        self.spatial_plan_kinds = get_code_list("spatial_plan_kind", db)
        self.lifecycle_statuses = get_code_list("spatial_plan_lifecycle_status", db)
        self.ground_relativeness_kinds = get_code_list("ground_relativeness_kind", db)
        self.digital_origin_kinds = get_code_list("digital_origin_kind", db)
        self.bindingness_kinds = get_code_list("bindingness_kind", db)
        self.detail_plan_regulation_kinds = get_code_list("detail_plan_regulation_kind", db)
        self.master_plan_regulation_kinds = get_code_list("master_plan_regulation_kind", db)
        self.detail_plan_addition_information_kinds = get_code_list("detail_plan_addition_information_kind", db)

    def add_lud_core_element(self, entry: DictRow, tag: str) -> Element:
        """
        Add feature member and containing XML element with lud-core fields, if present in entry.

        :param entry: Row entry from Kauko database
        :param tag: Splan tag to use for the created element
        :return: Element created inside lud-core:featureMember
        """
        feature = SubElement(self.root, FEATUREMEMBER)
        # The gml:id will have to be unique, because it is used to link objects in the XML to each other.
        # We may use placeholder gml ids generated from local ids. The API will always respond by
        # generating a new gml id, which will be saved as reference id.
        element = SubElement(feature, tag, {"gml:id": get_gml_id(entry)})

        # lud-core fields
        producer_specific_identifier = SubElement(element, PRODUCER_SPECIFIC_IDENTIFIER)
        producer_specific_identifier.text = entry["producer_specific_id"]
        # TODO: Looks like Kaatio API currently does not accept lud-core:objectIdentifier.
        # if entry["identity_id"]:
        #     object_identifier = SubElement(element, OBJECT_IDENTIFIER)
        #     object_identifier.text = entry["identity_id"]
        if entry["reference_id"]:
            # TODO: Don't know if this is even needed. This is id for the old version, not the new
            # version, anyway. Identity id should tell the API what our object is.
            reference_identifier = SubElement(element, REFERENCE_IDENTIFIER, {"codeSpace": CODE_SPACE})
            tag_without_ns = tag.split("splan:")[1]
            reference_identifier.text = f'{tag_without_ns}/id-{entry["reference_id"]}'

        if "latest_change" in entry:
            latest_change = SubElement(element, LATEST_CHANGE)
            add_time_position(latest_change, entry["latest_change"])
        # NOTE: Lud-core name refers to plan name only. Therefore, it should not be present in other objects.
        # Other objects will have identical splan name field instead.
        if tag == SPATIAL_PLAN and "name" in entry and entry["name"]:
            add_language_string_elements(element, NAME, entry["name"])
        # NOTE: Lud-core boundary refers to plan boundary only. Therefore, it should not be present in other
        # objects. Other objects will have splan geometry instead.
        if tag == SPATIAL_PLAN and "gml" in entry:
            boundary = SubElement(element, BOUNDARY)
            add_polygon(boundary, entry["gml"], f"{get_gml_id(entry)}.geom.0")
        if "legal_effectiveness" in entry:
            add_code_element(element, LEGAL_EFFECTIVENESS, self.legal_effectiveness_kinds, entry["legal_effectiveness"])
        # NOTE: Lud-core validity time refers to plan validity time only. Therefore, it should not be present
        # in other objects. Other objects will have identical splan validity time instead, go figure.
        if tag == SPATIAL_PLAN and "validity_time" in entry and entry["validity_time"]:
            validity_time = SubElement(element, VALIDITY_TIME)
            add_time_period(validity_time, entry["validity_time"])
        if "land_administration_authority" in entry:
            # TODO: Tämä muoto ei kelpaa. Pitänee lisätä finnish_municipality_codesiin codevalue, uri ja preflabel_fi ensin.
            # add_code_element(plan, RESPONSIBLE_ORGANIZATION, self.finnish_municipality_codes, plan_data["land_administration_authority"], "name")
            pass
        return element

    def add_spatial_plan_element(self, plan_data: DictRow) -> None:
        """
        Add spatial plan element using plan_data.

        :param plan_data: Plan data from Kauko database
        """
        PLAN_IDENTIFIER = SPLAN_NS + ":planIdentifier"
        INITIATION_TIME = SPLAN_NS + ":initiationTime"
        APPROVAL_TIME = SPLAN_NS + ":approvalTime"
        DIGITAL_ORIGIN = SPLAN_NS + ":digitalOrigin"

        plan = self.add_lud_core_element(plan_data, SPATIAL_PLAN)

        # spatial plan specific fields
        add_code_element(plan, TYPE, self.spatial_plan_kinds, plan_data["type"])

        plan_identifier = SubElement(plan, PLAN_IDENTIFIER)
        plan_identifier.text = plan_data["local_id"]
    
        add_code_element(plan, LIFECYCLE_STATUS, self.lifecycle_statuses, plan_data["lifecycle_status"])
        add_code_element(plan, GROUND_RELATIVE_POSITION, self.ground_relativeness_kinds, plan_data["ground_relative_position"])
        
        if plan_data["initiation_time"]:
            initiation_time = SubElement(plan, INITIATION_TIME)
            add_time_position(initiation_time, plan_data["initiation_time"])
        if plan_data["approval_time"]:
            approval_time = SubElement(plan, APPROVAL_TIME)
            add_time_position(approval_time, plan_data["approval_time"])
        
        add_code_element(plan, DIGITAL_ORIGIN, self.digital_origin_kinds, plan_data["digital_origin"])

    def add_spatial_plan_commentary_element(self, entry: DictRow) -> None:
        """
        Add XML element with spatial plan commentary fields.

        :param entry: Spatial plan commentary data from Kauko database
        """
        commentary = self.add_lud_core_element(entry, COMMENTARY)

    def add_participation_and_evaluation_plan_element(self, entry: DictRow) -> None:
        """
        Add XML element with participation and evaluation plan fields.

        :param entry: Participation and evaluation plan data from Kauko database
        """
        plan = self.add_lud_core_element(entry, PARTICIPATION_AND_EVALUATION_PLAN)

    def add_planner_element(self, entry: DictRow) -> None:
        """
        Add XML element with participation and evaluation plan fields.

        :param entry: Participation and evaluation plan data from Kauko database
        """
        # TODO: Use this once planner has any lud core fields in database.
        # planner = self.add_lud_core_element(entry, PLANNER)
        feature = SubElement(self.root, FEATUREMEMBER)
        # TODO: use proper gml id once planner has an uuid
        planner = SubElement(feature, PLANNER, {"gml:id": f"id-planner-{entry['identifier']}"})
        person_name = SubElement(planner, PERSON_NAME)
        person_name.text = entry["name"]
        if entry["professional_title"]:
            add_language_string_elements(planner, PROFESSION_TITLE, entry["professional_title"])
        if entry["role"]:
            add_language_string_elements(planner, ROLE, entry["role"])

    def add_plan_object_element(self, entry: DictRow) -> None:
        """
        Add XML element with plan object fields, if present in entry.

        :param entry: Plan object data from Kauko database
        """
        plan_object = self.add_lud_core_element(entry, PLAN_OBJECT)
        if "name" in entry and entry["name"]:
            add_language_string_elements(plan_object, NAME_INSIDE_SPLAN, entry["name"])

        geometry = SubElement(plan_object, GEOMETRY)
        if entry["gml"].startswith("<MultiSurface"):
            add_polygon(geometry, entry["gml"], f"{get_gml_id(entry)}.geom.0")
        elif entry["gml"].startswith("<MultiCurve"):
            add_linestring(geometry, entry["gml"], f"{get_gml_id(entry)}.geom.0")

        plan = SubElement(plan_object, SPATIAL_PLAN_BUT_WITH_SMALL_INITIAL_JUST_FOR_FUN, {"xlink:href": "#" + self.plan_id})
        if "bindingness_of_location" in entry:
            add_code_element(plan_object, BINDINGNESS_OF_LOCATION, self.bindingness_kinds, entry["bindingness_of_location"])
        if "ground_relative_position" in entry:
            add_code_element(plan_object, GROUND_RELATIVE_POSITION, self.ground_relativeness_kinds, entry["ground_relative_position"])

    def add_plan_order_element(self,
        entry: DictRow,
        values: Dict[str, List[DictRow]],
        supplementary_information: Dict[str, DictRow],
        supplementary_information_values: Dict[str, Dict[str, List[DictRow]]],
        target_gml_ids: List[str],
        master_plan: bool = False,
        recommendation: bool = False
    ) -> None:
        """
        Create XML element with plan order fields, if present in entry.

        :param entry: Plan order data from Kauko database
        :param values: Dict of order value types and values of each type
        :param supplementary_information: Dict of supplementary information for order
        :param supplementary_information_values: Dict of supplementary information ids and dicts of information value types
            and values of each type
        :param target_gml_ids: GML ids for all regulation targets
        :param master_plan: True if we want to use master plan code lists instead. The default is detail plan.
        :param recommendation: True if we want to add plan recommendation element instead. The default is plan order.
        """
        if recommendation:
            plan_order = self.add_lud_core_element(entry, PLAN_RECOMMENDATION)
        else:
            plan_order = self.add_lud_core_element(entry, PLAN_ORDER)

        if "name" in entry and entry["name"]:
            add_language_string_elements(plan_order, NAME_INSIDE_SPLAN, entry["name"])

        for value_type, values in values.items():
            for value in values:
                add_value_element(plan_order, value_type, value)

        plan = SubElement(plan_order, SPATIAL_PLAN_BUT_WITH_SMALL_INITIAL_JUST_FOR_FUN, {"xlink:href": "#" + self.plan_id})
        for target_gml_id in target_gml_ids:
            # TODO: This is weird. Plan cannot be a target for plan order, this causes an API error.
            # Instead, orders *without* target are assumed to belong to the plan directly.
            #
            # This is obviously a problem, since some orders without target will belong to order
            # groups, they should *not* belong to the plan directly.
            #
            # For the time being, do not add plan as target.
            if target_gml_id and not target_gml_id == self.plan_id:
                target = SubElement(plan_order, TARGET, {"xlink:href": "#" + target_gml_id})

        if "type" in entry:
            if master_plan:
                add_code_element(plan_order, TYPE, self.master_plan_regulation_kinds, entry["type"])
            else:
                add_code_element(plan_order, TYPE, self.detail_plan_regulation_kinds, entry["type"])

        # lifecycle status is required for each plan order
        lifecycle_status = entry["life_cycle_status"] if "life_cycle_status" in entry else self.lifecycle_status
        add_code_element(plan_order, LIFECYCLE_STATUS, self.lifecycle_statuses, lifecycle_status)

        if "validity_time" in plan_order and plan_order["validity_time"]:
            validity_time = SubElement(plan_order, VALIDITY_TIME_INSIDE_SPLAN)
            add_time_period(validity_time, entry["validity_time"])

        # only plan orders may have supplementary information
        for id, information in supplementary_information.items():
            info_element = SubElement(plan_order, SUPPLEMENTARY_INFO)
            information_element = SubElement(info_element, SUPPLEMENTARY_INFORMATION)

            type = information["type"]
            add_code_element(information_element, TYPE, self.detail_plan_addition_information_kinds, type)

            name = information["name"]
            add_language_string_elements(information_element, NAME_INSIDE_SPLAN, name)

            values = supplementary_information_values[id]
            for value_type, values in values.items():
                for value in values:
                    add_value_element(information_element, value_type, value)

    def add_plan_order_group_element(self, entry: DictRow, target_gml_ids: List[str], member_gml_ids: List[str]):
        """
        Create XML element with plan order group fields.

        :param entry: Plan order group data from Kauko database
        :param target_gml_ids: GML ids for targets
        :param member_gml_ids: GML ids for members
        """
        group = self.add_lud_core_element(entry, PLAN_ORDER_GROUP)
        if "name" in entry and entry["name"]:
            add_language_string_elements(group, NAME_INSIDE_SPLAN, entry["name"])

        plan = SubElement(group, SPATIAL_PLAN_BUT_WITH_SMALL_INITIAL_JUST_FOR_FUN, {"xlink:href": "#" + self.plan_id})
        for target_gml_id in target_gml_ids:
            target = SubElement(group, TARGET, {"xlink:href": "#" + target_gml_id})

        group_number = SubElement(group, GROUP_NUMBER)
        group_number.text = str(entry["group_number"])
        for member_gml_id in member_gml_ids:
            member = SubElement(group, MEMBER, {"xlink:href": "#" + member_gml_id})

    def add_regulations(self, regulations: Dict[str, Dict[str, DictRow]], guidance: bool = False) -> None:
        """
        Add Kauko database regulations (or guidances), their values, supplementary information and their
        values as plan orders (or recommendations)

        :param regulations: Plan regulations (or guidances) from Kauko database, indexed with regulation ids and target ids.
                            Each regulation may be present in multiple targets.
        :param guidance: True if we want to add guidances instead. Default is regulation.
        """
        regulation_values = get_values(
            "plan_regulation" if not guidance else "plan_guidance", regulations.keys(), self.db, self.schema
        )
        regulation_supplementary_information = get_supplementary_information(
            regulations.keys(), self.db, self.schema
        ) if not guidance else defaultdict(dict)
        supplementary_information_ids = set().union(
            *[information.keys() for information in regulation_supplementary_information.values()]
        )
        supplementary_information_values = get_values(
            "supplementary_information", supplementary_information_ids, self.db, self.schema
        ) if not guidance else defaultdict(dict)
        for regulation_id, regulation_by_target in regulations.items():
            target_ids = regulation_by_target.keys()
            regulation = next(iter(regulation_by_target.values()))
            values = regulation_values[regulation_id]
            informations = regulation_supplementary_information[regulation_id]
            self.add_plan_order_element(
                regulation,
                values,
                informations,
                supplementary_information_values,
                [get_gml_id({"local_id": id}) for id in target_ids],
                recommendation=guidance
            )

    def add_regulation_groups(self, groups: Dict[str, Dict[str, DictRow]], regulations: Dict[str, Dict[str, DictRow]]) -> None:
        """
        Add Kauko database regulation groups as plan order groups

        :param groups: Plan regulation groups from Kauko database, indexed with group ids and target ids. Each group may be
                        present in multiple targets.
        :param regulations: Plan regulations from Kauko database, indexed with group ids and regulation ids. Each regulation
                        may be present in multiple groups.
        :param targets: Plan regulation group targets from Kauko database, indexed with target id.
        """
        for group_id, group_by_target in groups.items():
            target_ids = group_by_target.keys()
            member_ids = regulations[group_id].keys()
            group = next(iter(group_by_target.values()))
            self.add_plan_order_group_element(
                group,
                [get_gml_id({"local_id": id}) for id in target_ids],
                [get_gml_id({"local_id": id}) for id in member_ids]
            )

    def add_planning_detail_lines(self, detail_lines: Dict[str, DictRow]) -> None:
        """
        Add Kauko database planning detail lines as plan objects.

        :param detail_lines: Planning detail lines from Kauko database
        """
        for id, detail_line in detail_lines.items():
            self.add_plan_object_element(detail_line)

            # TODO: lisättävä viivamaiseen tarkennemerkintään liittyvä kaavamääräys
            # kaavamääräyskoodistosta sen jälkeen, kun viivamaisiin merkintöihin on lisätty
            # asemakaavakoodistoon viittaava kenttä. Tällä hetkellä tarkennemerkinnällä on
            # oma koodisto, joka ei viittaa asemakaavakoodistoon.

    def add_planned_spaces(self, planned_spaces: Dict[str, DictRow]) -> None:
        """
        Add Kauko database planned spaces lines as plan objects.

        :param planned_spaces: Planned spaces from Kauko database
        """
        for id, planned_space in planned_spaces.items():
            self.add_plan_object_element(planned_space)

    def add_zoning_elements(self, zoning_elements: Dict[str, DictRow]) -> None:
        """
        Add Kauko database zoning elements as plan objects and their land use
        types as plan orders to Kaatio feature collection.

        :param zoning_elements: Zoning elements from Kauko database
        """
        for id, zoning_element in zoning_elements.items():
            self.add_plan_object_element(zoning_element)

            # Each zoning element must have planOrder linked to planObject.
            zoning_order = zoning_element.copy()
            # This order must have unique ids though.
            zoning_order["local_id"] += ".zoning_order"
            zoning_order["producer_specific_id"] += ".zoning_order"
            if zoning_order["reference_id"]:
                zoning_order["reference_id"] += ".zoning_order"
            # The zoning order type is the land use kind. Element type does not apply to order.
            zoning_order["type"] = zoning_order["land_use_kind"]
            # TODO: Each zoning element may only have text values and supplementary information with code values
            # https://tietomallit.ymparisto.fi/kaavatiedot/soveltamisprofiili/asemakaava/v1.0/kayttotarkoitukset/#alueen-käyttötarkoitus
            # Where are these stored in Kauko? Do we want to pick one particular regulation linked to the geometry
            # and link it to this order? Currently, we create all orders separately, because they may have
            # any type and any values, and pass empty values list in the zoning order.
            self.add_plan_order_element(zoning_order, dict(), dict(), dict(), [get_gml_id(zoning_element)])

            # TODO: commentary, document, participation, planner

    def add_commentaries(self, commentaries: Dict[str, DictRow]) -> None:
        """
        Add Kauko database commentaries as spatial plan commentary objects.

        :param commentaries: Commentaries from Kauko database
        """
        # TODO: fetch and add documents here?
        for id, commentary in commentaries.items():
            self.add_spatial_plan_commentary_element(commentary)

    def add_participation_and_evaluation_plans(self, participation_and_evaluation_plans: Dict[str, DictRow]) -> None:
        """
        Add Kauko database participation and evaluation plans as participation and evaluation plan objects.

        :param participation_and_evaluation_plans: Participation and evaluation plans from Kauko database
        """
        # TODO: fetch and add documents here?
        for id, plan in participation_and_evaluation_plans.items():
            self.add_participation_and_evaluation_plan_element(plan)

    def add_planners(self, planners: Dict[str, DictRow]) -> None:
        """
        Add Kauko database planners as planner objects.

        :param  planners: Planners from Kauko database
        """
        for id, planner in planners.items():
            self.add_planner_element(planner)

    def get_xml(self, plan_id: int) -> bytes:
        """
        Return Kaatio XML generated from a plan in Kauko database.

        :param plan_id: Plan identifier in Kauko database
        :return: UTF-8 encoded XML in bytes
        """
        LOGGER.info("fetching plan data...")
        plan_data = get_spatial_plan(plan_id, self.db, self.schema)
        LOGGER.info(plan_data)
        LOGGER.info("creating plan element")
        # TODO: add annexes here?
        self.add_spatial_plan_element(plan_data)
        LOGGER.info("setting global values")
        self.plan_id = get_gml_id(plan_data)
        self.lifecycle_status = plan_data["lifecycle_status"]

        # 1) Fetch and create all zoning elements
        LOGGER.info("fetching zoning elements...")
        zoning_elements = get_zoning_elements(plan_data["local_id"], self.db, self.schema)
        LOGGER.info(zoning_elements)
        LOGGER.info("adding zoning elements")
        self.add_zoning_elements(zoning_elements)

        # 2) Fetch and create all planning detail lines. The same lines may belong to multiple zoning
        # elements and multiple planned spaces. Creating planning detail lines
        # one zoning element at a time would duplicate lines in XML.
        LOGGER.info("fetching planning detail lines...")
        detail_lines = get_plan_detail_lines(plan_data["local_id"], self.db, self.schema)
        LOGGER.info("got detail lines:")
        LOGGER.info(detail_lines)
        self.add_planning_detail_lines(detail_lines)

        # 3) Fetch and create all planned spaces. Due to buffers in relation triggers, the same planned space
        # may belong to multiple zoning elements, even if they do not strictly overlap. Creating planned spaces
        # one zoning element at a time would duplicate planned spaces in XML.
        LOGGER.info("fetching planned spaces...")
        planned_spaces = get_planned_spaces(plan_data["local_id"], self.db, self.schema)
        LOGGER.info("got planned spaces:")
        LOGGER.info(planned_spaces)
        self.add_planned_spaces(planned_spaces)

        # 4) TODO: päätettävä, miten selittävät tekstit ja viivat viedään, jos ollenkaan
        LOGGER.info("fetching describing texts...")
        describing_texts = get_describing_texts(plan_data["local_id"], self.db, self.schema)
        #self.add_describing_texts(describing_texts)
        LOGGER.info("fetching describing lines...")
        describing_texts = get_describing_lines(plan_data["local_id"], self.db, self.schema)
        #self.add_describing_lines(describing_texts)

        # 5) Fetch all regulation groups and their regulations. The same regulation group may
        # belong to multiple zoning elements, detail lines and planned spaces. The same
        # regulation may belong to multiple groups, zoning elements, detail lines and spaces.
        LOGGER.info("fetching regulation groups...")
        zoning_element_regulation_groups = get_regulation_groups("zoning_element", zoning_elements.keys(), self.db, self.schema)
        planned_space_regulation_groups = get_regulation_groups("planned_space", planned_spaces.keys(), self.db, self.schema)
        detail_line_regulation_groups = get_regulation_groups("planning_detail_line", detail_lines.keys(), self.db, self.schema)
        # combine regulation groups:
        group_ids = set().union(
            zoning_element_regulation_groups.keys(),
            planned_space_regulation_groups.keys(),
            detail_line_regulation_groups.keys()
            )
        # regulation groups by group id and target id:
        regulation_groups = {group_id: {
            **(zoning_element_regulation_groups[group_id]),
            **(planned_space_regulation_groups[group_id]),
            **(detail_line_regulation_groups[group_id])
        } for group_id in group_ids}
        LOGGER.info("got groups:")
        LOGGER.info(regulation_groups)
        # get all regulations in groups:
        regulations_by_group = get_group_regulations(regulation_groups.keys(), self.db, self.schema)
        group_regulations = {
            id: regulation for regulation_dict in regulations_by_group.values()
            for id, regulation in regulation_dict.items()
        }
        LOGGER.info("regulations in groups:")
        LOGGER.info(group_regulations)

        # 6) Fetch and create the rest of the regulations and guidances here. Do *not* create them
        # for each zoning element, planned space, line and group separately. If the same regulation
        # refers to multiple plan objects, it would duplicate regulations in XML. We must add each
        # regulation only once.
        LOGGER.info("fetching regulations...")
        plan_regulations = get_plan_regulations("spatial_plan", [plan_data["local_id"]], self.db, self.schema)
        plan_guidances = get_plan_regulations("spatial_plan", [plan_data["local_id"]], self.db, self.schema, guidance=True)
        zoning_element_regulations = get_plan_regulations("zoning_element", zoning_elements.keys(), self.db, self.schema)
        zoning_element_guidances = get_plan_regulations(
            "zoning_element", zoning_elements.keys(), self.db, self.schema, guidance=True
            )
        planned_space_regulations = get_plan_regulations("planned_space", planned_spaces.keys(), self.db, self.schema)
        planned_space_guidances = get_plan_regulations(
            "planned_space", planned_spaces.keys(), self.db, self.schema, guidance=True
            )
        detail_line_regulations = get_plan_regulations("planning_detail_line", detail_lines.keys(), self.db, self.schema)
        detail_line_guidances = get_plan_regulations(
            "planning_detail_line", detail_lines.keys(), self.db, self.schema, guidance=True
            )
        # combine regulations, also taking into account group regulations fetched earlier:
        regulation_ids = set().union(
            plan_regulations.keys(),
            zoning_element_regulations.keys(),
            planned_space_regulations.keys(),
            detail_line_regulations.keys(),
            group_regulations.keys()
            )
        # regulations by regulation id and target id:
        regulations = {regulation_id: {
            **(plan_regulations[regulation_id]),
            **(zoning_element_regulations[regulation_id]),
            **(planned_space_regulations[regulation_id]),
            **(detail_line_regulations[regulation_id]),
            None: group_regulations.get(regulation_id, None)  # group regulations have no target
        } for regulation_id in regulation_ids}
        LOGGER.info("got regulations:")
        LOGGER.info(regulations)
        guidance_ids = set().union(
            plan_guidances.keys(),
            zoning_element_guidances.keys(),
            planned_space_guidances.keys(),
            detail_line_guidances.keys(),
            )
        guidances = {guidance_id: {
            **plan_guidances[guidance_id],
            **zoning_element_guidances[guidance_id],
            **planned_space_guidances[guidance_id],
            **detail_line_guidances[guidance_id],
        } for guidance_id in guidance_ids}
        LOGGER.info("got guidances:")
        LOGGER.info(guidances)
        self.add_regulations(regulations)
        self.add_regulations(guidances, guidance=True)

        # 7) Regulation groups may only be added after all regulations have been added. They refer
        # to existing regulations.
        self.add_regulation_groups(zoning_element_regulation_groups, regulations_by_group)

        # 8) Fetch and create all commentaries
        commentaries = get_plan_commentaries(plan_data["local_id"], self.db, self.schema)
        self.add_commentaries(commentaries)

        # 9) Fetch and create all participation and evaluation plans
        participation_and_evaluation_plans = get_participation_and_evaluation_plans(
            plan_data["local_id"], self.db , self.schema
        )
        self.add_participation_and_evaluation_plans(participation_and_evaluation_plans)

        # 10) Fetch and create all planners
        # TODO: For some reason, planners are always attached to all versions of the plan
        # (producer specific id), never one version (local id).
        planners = get_planners(plan_data["producer_specific_id"], self.db, self.schema)
        self.add_planners(planners)

        tree = ElementTree(self.root)
        tree.write("/Users/riku/repos/Kauko/plan.xml", "utf-8")
        return tostring(self.root, "utf-8")

    def update_plan_in_db(self, plan_id: int, response: str):
        """
        Update existing plan based on XML response from Kaatio server.

        :param plan_id: Plan identifier in Kauko database
        :param xml: XML response from Kaatio server
        """
        incoming_plan = fromstring(response)
        tree = ElementTree(incoming_plan)
        tree.write("/Users/riku/repos/Kauko/parsed_response.xml", "utf-8")
        spatial_plan = incoming_plan.find(".//{" + NAMESPACES[SPLAN_NS] + "}SpatialPlan")
        reference_id = spatial_plan.get("{" + NAMESPACES["gml"] + "}id")
        identity_id = incoming_plan.find(
            ".//{" + NAMESPACES[SPLAN_NS] + "}SpatialPlan/{" +
            NAMESPACES[CORE_NS] + "}objectIdentifier").text
        # get rid of id- string that is in front of UUID for some reason
        identity_id = identity_id.split("id-")[1]
        storage_time = incoming_plan.find(
            ".//{" + NAMESPACES[SPLAN_NS] + "}SpatialPlan/{" +
            NAMESPACES[CORE_NS] + "}storageTime/{" +
            NAMESPACES["gml"] + "}TimeInstant/{" +
            NAMESPACES["gml"] + "}timePosition").text
        storage_time = datetime.fromisoformat(storage_time)

        # Better be explicit and update fields separately. We don't want all plan fields to be editable.
        set_spatial_plan_identity_id(plan_id, identity_id, self.db, self.schema)
        set_spatial_plan_reference_id(plan_id, reference_id, self.db, self.schema)
        set_spatial_plan_storage_time(plan_id, storage_time, self.db, self.schema)

        # TODO: also update ids for plan objects, plan orders etc.