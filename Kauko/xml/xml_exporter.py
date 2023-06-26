import logging
from collections import defaultdict
from datetime import datetime
from psycopg2.extras import DateRange, DictRow
from typing import Dict, List, Union
from xml.etree.ElementTree import (
    dump,
    Element,
    ElementTree,
    fromstring,
    SubElement,
    tostring,
)

# from qgis.core import QgsProject

from ..database.database import Database
from ..database.database_handler import (
    get_code_list,
    get_describing_texts,
    get_describing_lines,
    get_documents,
    get_group_regulations,
    get_participation_and_evaluation_plan,
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
    set_object_reference_id,
    set_object_storage_time,
)
from .tools import (
    flatten_and_flip,
    get_destination_table,
    CORE_NS,
    SPLAN_NS,
    NAMESPACES,
    XML_VALUE_MAP_SIMPLE,
)

# This is probably the only sensible usage for import *
# tags.py must *only* contain a consistent set of upper-case constants
from .tags import *   # noqa: F403

LOGGER = logging.getLogger("kauko")

FEATURECOLLECTION = CORE_NS + ":LandUseFeatureCollection"
FEATURECOLLECTION_ATTRIBUTES = {
    "xmlns:" + namespace: uri for namespace, uri in NAMESPACES.items()
}
FEATURECOLLECTION_ATTRIBUTES[
    "xsi:schemaLocation"
] = "http://tietomallit.ymparisto.fi/kaavatiedot/xml/1.2 https://tietomallit.ymparisto.fi/kehitys/kaatio/xml/spatialplan-1.2.xsd"


VALUE_TYPE_MAP = flatten_and_flip(XML_VALUE_MAP_SIMPLE)


def get_gml_id(entry: Union[DictRow, Dict]) -> Union[str, None]:
    """
    Return unique gml id for an entry in the database.
    """
    # XML is really particular about accepted identity strings. Notably, an identity string
    # cannot start with a number, since it will not fulfill the \\\\i-[:]][\\\\c-[:]]* XSD regex,
    # as reported by the Kaatio API.
    #
    # This means we cannot use the bare local id here. Kaatio API uses the GML id (not planIdentifier)
    # to generate version identifier and object identifier.
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


def add_time_position(
    parent: Element, position: datetime, attrib: Dict = None
) -> Element:
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
    incoming_pos = gml_element.findall(f".//{POS}")[0]
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
    linestring = SubElement(
        parent, GML_LINESTRING, {"srsName": srs_name, "gml:id": id, "srsDimension": "2"}
    )
    pos_list = SubElement(linestring, f"gml:{POS_LIST}")

    # TODO: only support single linestrings for now
    incoming_pos_list = gml_element.findall(f".//{POS_LIST}")[0]
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
    incoming_pos_list = gml_element.findall(f".//{POS_LIST}")[0]
    pos_list.text = incoming_pos_list.text
    return polygon


def add_language_string_elements(
    parent: Element, tag: str, strings: Dict[str, str]
) -> List[Element]:
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


def add_reference_element(parent: Element, tag: str, uri: str) -> None:
    """
    Add XML reference element under specified element.

    :param parent: Element under which reference should be added
    :param tag: Tag to use in reference
    :param uri: URI to use in reference
    """
    return SubElement(parent, tag, {"xlink:href": uri})


def add_code_element(
    parent: Element,
    tag: str,
    code_list: Dict[int, DictRow],
    code_value: str,
    title_field: str = "preflabel_fi",
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
    code_element = add_reference_element(parent, tag, code_data.get("uri", ""))
    code_element.set("xlink:title", code_data.get(title_field, ""))
    return code_element


def add_value_element(parent: Element, value_type: str, value: DictRow) -> Element:
    """
    Create value element under specified element.

    :param feature: Element under which value should be added
    :param tag: Value type string
    :param value: Value contents to add
    :return: Created element
    """
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
        add_polygon(
            value_element, value["gml"], "id-" + value["geometry_area_value_uuid"]
        )
    elif value_type == "geometry_line_value":
        value_element = SubElement(type_element, VALUE)
        add_linestring(
            value_element, value["gml"], "id-" + value["geometry_line_value_uuid"]
        )
    elif value_type == "geometry_point_value":
        value_element = SubElement(type_element, VALUE)
        add_point(
            value_element, value["gml"], "id-" + value["geometry_point_value_uuid"]
        )
    return container_element


class XMLExporter:
    def __init__(self, db: Database, schema: str) -> None:
        self.db = db
        self.schema = schema
        self.root = Element(
            FEATURECOLLECTION, {**FEATURECOLLECTION_ATTRIBUTES, "gml:id": "foobar"}
        )
        self.plan = None
        self.plan_name = None
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
        self.detail_plan_regulation_kinds = get_code_list(
            "detail_plan_regulation_kind", db
        )
        self.master_plan_regulation_kinds = get_code_list(
            "master_plan_regulation_kind", db
        )
        self.detail_plan_addition_information_kinds = get_code_list(
            "detail_plan_addition_information_kind", db
        )
        self.document_kinds = get_code_list("document_kind", db)

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
            add_code_element(
                element,
                LEGAL_EFFECTIVENESS,
                self.legal_effectiveness_kinds,
                entry["legal_effectiveness"],
            )
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

    def add_spatial_plan_element(self, plan_data: DictRow) -> Element:
        """
        Add spatial plan element using plan_data.

        :param plan_data: Plan data from Kauko database
        :return: Created plan element
        """

        plan = self.add_lud_core_element(plan_data, SPATIAL_PLAN)

        # spatial plan specific fields
        add_code_element(plan, TYPE, self.spatial_plan_kinds, plan_data["type"])

        plan_identifier = SubElement(plan, PLAN_IDENTIFIER)
        # NOTE: This doesn't do anything. To create identifier and object identifier, Kaatio API seems to use
        # the gml:id. This field is returned as is, so there is no need to update identity id after POST.
        plan_identifier.text = plan_data["identity_id"]

        add_code_element(
            plan,
            LIFECYCLE_STATUS,
            self.lifecycle_statuses,
            plan_data["lifecycle_status"],
        )
        add_code_element(
            plan,
            GROUND_RELATIVE_POSITION,
            self.ground_relativeness_kinds,
            plan_data["ground_relative_position"],
        )

        if plan_data["initiation_time"]:
            initiation_time = SubElement(plan, INITIATION_TIME)
            add_time_position(initiation_time, plan_data["initiation_time"])
        if plan_data["approval_time"]:
            approval_time = SubElement(plan, APPROVAL_TIME)
            add_time_position(approval_time, plan_data["approval_time"])

        add_code_element(
            plan, DIGITAL_ORIGIN, self.digital_origin_kinds, plan_data["digital_origin"]
        )
        return plan

    def add_document_element(
        self, parent: Element, tag: str, document: DictRow, type_uri: str = None
    ) -> None:
        """
        Add XML document element under specified element.

        :param feature: Element under which document should be added
        :param tag: Tag to use for the document element
        :param document: Document data
        :param type_uri: Document type uri, if missing in database
        :return: Created element
        """
        container_element = SubElement(parent, tag)
        document_element = SubElement(
            container_element, DOCUMENT, {"gml:id": get_gml_id(document)}
        )
        add_language_string_elements(document_element, NAME, document["name"])
        if "type" in document and document["type"]:
            add_code_element(
                document_element, CORE_TYPE, self.document_kinds, document["type"]
            )
        else:
            # Older db versions do not contain the type field. Document type is mandatory in API.
            type_element = add_reference_element(document_element, CORE_TYPE, type_uri)

        link_element = SubElement(document_element, ADDITIONAL_INFORMATION_LINK)
        if "additional_information_link" in document:
            link_element.text = document["additional_information_link"]

    def add_spatial_plan_commentary_element(
        self, entry: DictRow, documents: Dict[str, DictRow]
    ) -> None:
        """
        Add XML element with spatial plan commentary fields.

        :param entry: Spatial plan commentary data from Kauko database
        """
        commentary = self.add_lud_core_element(entry, COMMENTARY)
        for id, document in documents.items():
            self.add_document_element(
                commentary,
                DOCUMENT_INSIDE_SPLAN,
                document,
                # NOTE: This is only needed for older database versions where type field is missing
                "http://uri.suomi.fi/codelist/rytj/RY_AsiakirjanLaji_YKAK/code/06",
            )

    def add_participation_and_evaluation_plan_element(
        self, entry: DictRow, documents: Dict[str, DictRow]
    ) -> None:
        """
        Add XML element with participation and evaluation plan fields.

        :param entry: Participation and evaluation plan data from Kauko database
        :param documents: Documents related to the participation and evaluation plan
        """
        plan = self.add_lud_core_element(entry, PARTICIPATION_AND_EVALUATION_PLAN)
        for id, document in documents.items():
            self.add_document_element(
                plan,
                DOCUMENT_INSIDE_SPLAN,
                document,
                # NOTE: This is only needed for older database versions where type field is missing
                "http://uri.suomi.fi/codelist/rytj/RY_AsiakirjanLaji_YKAK/code/14",
            )

    def add_planner_element(self, entry: DictRow) -> None:
        """
        Add XML element with participation and evaluation plan fields.

        :param entry: Participation and evaluation plan data from Kauko database
        """
        # TODO: Use this once planner has any lud core fields in database.
        # planner = self.add_lud_core_element(entry, PLANNER)
        feature = SubElement(self.root, FEATUREMEMBER)
        # TODO: use get_gml_id once planner has an uuid
        planner = SubElement(
            feature, PLANNER, {"gml:id": f"id-planner-{entry['identifier']}"}
        )
        person_name = SubElement(planner, PERSON_NAME)
        person_name.text = entry["name"]
        if entry["professional_title"]:
            add_language_string_elements(
                planner, PROFESSION_TITLE, entry["professional_title"]
            )
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

        add_reference_element(plan_object, SPATIAL_PLAN_REF, "#" + self.plan_id)

        if "bindingness_of_location" in entry:
            add_code_element(
                plan_object,
                BINDINGNESS_OF_LOCATION,
                self.bindingness_kinds,
                entry["bindingness_of_location"],
            )
        if "ground_relative_position" in entry:
            add_code_element(
                plan_object,
                GROUND_RELATIVE_POSITION,
                self.ground_relativeness_kinds,
                entry["ground_relative_position"],
            )

    def add_plan_order_element(
        self,
        entry: DictRow,
        values: Dict[str, List[DictRow]],
        documents: Dict[str, DictRow],
        supplementary_information: Dict[str, DictRow],
        supplementary_information_values: Dict[str, Dict[str, List[DictRow]]],
        target_gml_ids: List[str],
        master_plan: bool = False,
        recommendation: bool = False,
    ) -> None:
        """
        Create XML element with plan order fields, if present in entry.

        :param entry: Plan order data from Kauko database
        :param values: Dict of order value types and values of each type
        :param documents: Dict of documents for order
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
            # TODO: remove this once zoning element name is proper jsonb field too
            if isinstance(entry["name"], str):
                element = SubElement(plan_order, NAME_INSIDE_SPLAN, {"xml:lang": "fin"})
                element.text = entry["name"]
            else:
                add_language_string_elements(
                    plan_order, NAME_INSIDE_SPLAN, entry["name"]
                )

        for value_type, values in values.items():
            for value in values:
                add_value_element(plan_order, value_type, value)

        add_reference_element(plan_order, SPATIAL_PLAN_REF, "#" + self.plan_id)

        for target_gml_id in target_gml_ids:
            if target_gml_id:
                if target_gml_id == self.plan_id:
                    # This is weird. While plan orders target plan objects, the *plan* must link to
                    # any plan orders that are attached to the plan directly, not the other way around.
                    # So the plan cannot be a target here.
                    reference_tag = (
                        GENERAL_ORDER if not recommendation else GENERAL_RECOMMENDATION
                    )
                    add_reference_element(
                        self.plan, reference_tag, "#" + get_gml_id(entry)
                    )
                else:
                    add_reference_element(plan_order, TARGET, "#" + target_gml_id)

        if "type" in entry:
            if master_plan:
                add_code_element(
                    plan_order, TYPE, self.master_plan_regulation_kinds, entry["type"]
                )
            else:
                add_code_element(
                    plan_order, TYPE, self.detail_plan_regulation_kinds, entry["type"]
                )

        # lifecycle status is required for each plan order
        lifecycle_status = (
            entry["life_cycle_status"]
            if "life_cycle_status" in entry
            else self.lifecycle_status
        )
        add_code_element(
            plan_order, LIFECYCLE_STATUS, self.lifecycle_statuses, lifecycle_status
        )

        if "validity_time" in plan_order and plan_order["validity_time"]:
            validity_time = SubElement(plan_order, VALIDITY_TIME_INSIDE_SPLAN)
            add_time_period(validity_time, entry["validity_time"])

        # only plan orders may have supplementary information
        for id, information in supplementary_information.items():
            info_element = SubElement(plan_order, SUPPLEMENTARY_INFO)
            information_element = SubElement(info_element, SUPPLEMENTARY_INFORMATION)

            type = information["type"]
            add_code_element(
                information_element,
                TYPE,
                self.detail_plan_addition_information_kinds,
                type,
            )

            name = information["name"]
            add_language_string_elements(information_element, NAME_INSIDE_SPLAN, name)

            values = supplementary_information_values[id]
            for value_type, values in values.items():
                for value in values:
                    add_value_element(information_element, value_type, value)

        for id, document in documents.items():
            # NOTE: this is stupid. If we have a regulation, we have to create the document
            # separately and refer to it here. If we have a recommendation, we inline
            # documents here.
            if not recommendation:
                add_reference_element(
                    plan_order, RELATED_DOCUMENT, "#" + get_gml_id(document)
                )
            else:
                self.add_document_element(
                    plan_order,
                    RELATED_DOCUMENT,
                    document,
                    # NOTE: This is only needed for older database versions where type field is missing
                    "http://uri.suomi.fi/codelist/rytj/RY_AsiakirjanLaji_YKAK/code/18",
                )

    def add_plan_order_group_element(
        self, entry: DictRow, target_gml_ids: List[str], member_gml_ids: List[str]
    ):
        """
        Create XML element with plan order group fields.

        :param entry: Plan order group data from Kauko database
        :param target_gml_ids: GML ids for targets
        :param member_gml_ids: GML ids for members
        """
        group = self.add_lud_core_element(entry, PLAN_ORDER_GROUP)
        if "name" in entry and entry["name"]:
            add_language_string_elements(group, NAME_INSIDE_SPLAN, entry["name"])

        add_reference_element(group, SPATIAL_PLAN_REF, "#" + self.plan_id)
        for target_gml_id in target_gml_ids:
            add_reference_element(group, TARGET, "#" + target_gml_id)

        group_number = SubElement(group, GROUP_NUMBER)
        group_number.text = str(entry["group_number"])
        for member_gml_id in member_gml_ids:
            add_reference_element(group, MEMBER, "#" + member_gml_id)

    def add_regulations(
        self, regulations: Dict[str, Dict[str, DictRow]], guidance: bool = False
    ) -> None:
        """
        Add Kauko database regulations (or guidances), their values, documents (for guidances),
        supplementary information and their values as plan orders (or recommendations). Note that
        regulation documents have to be added separately for unknown reasons.

        :param regulations: Plan regulations (or guidances) from Kauko database, indexed with regulation ids and target ids.
                            Each regulation may be present in multiple targets.
        :param guidance: True if we want to add guidances instead. Default is regulation.
        """
        regulation_values = get_values(
            "plan_regulation" if not guidance else "plan_guidance",
            regulations.keys(),
            self.db,
            self.schema,
        )
        regulation_supplementary_information = (
            get_supplementary_information(regulations.keys(), self.db, self.schema)
            if not guidance
            else defaultdict(dict)
        )
        supplementary_information_ids = set().union(
            *[
                information.keys()
                for information in regulation_supplementary_information.values()
            ]
        )
        supplementary_information_values = (
            get_values(
                "supplementary_information",
                supplementary_information_ids,
                self.db,
                self.schema,
            )
            if not guidance
            else defaultdict(dict)
        )
        regulation_documents = get_documents(
            "plan_regulation" if not guidance else "plan_guidance",
            regulations.keys(),
            self.db,
            self.schema,
        )
        for regulation_id, regulation_by_target in regulations.items():
            target_ids = regulation_by_target.keys()
            regulation = next(iter(regulation_by_target.values()))
            values = regulation_values[regulation_id]
            documents = regulation_documents[regulation_id]
            informations = regulation_supplementary_information[regulation_id]
            self.add_plan_order_element(
                regulation,
                values,
                documents,
                informations,
                supplementary_information_values,
                # TODO: Here we assume that gml ids are local ids. Local ids are used for all db queries.
                [get_gml_id({"local_id": id}) for id in target_ids],
                recommendation=guidance,
            )

    def add_regulation_documents(
        self, documents: Dict[str, Dict[str, DictRow]]
    ) -> None:
        """
        Add Kauko database regulation documents as separate feature members.

        :param documents: Documents from Kauko database, indexed with document ids.
        """
        for document_id, document in documents.items():
            self.add_document_element(
                self.root,
                FEATUREMEMBER,
                document,
                # NOTE: This is only needed for older database versions where type field is missing
                "http://uri.suomi.fi/codelist/rytj/RY_AsiakirjanLaji_YKAK/code/18",
            )

    def add_regulation_groups(
        self,
        groups: Dict[str, Dict[str, DictRow]],
        regulations: Dict[str, Dict[str, DictRow]],
    ) -> None:
        """
        Add Kauko database regulation groups as plan order groups

        :param groups: Plan regulation groups from Kauko database, indexed with group ids and target ids. Each group may be
                        present in multiple targets.
        :param regulations: Plan regulations from Kauko database, indexed with group ids and regulation ids. Each regulation
                        may be present in multiple groups.
        """
        for group_id, group_by_target in groups.items():
            target_ids = group_by_target.keys()
            member_ids = regulations[group_id].keys()
            group = next(iter(group_by_target.values()))
            self.add_plan_order_group_element(
                group,
                # TODO: Here we assume that gml ids are local ids. Local ids are used for all db queries.
                [get_gml_id({"local_id": id}) for id in target_ids],
                # TODO: Here we assume that gml ids are local ids. Local ids are used for all db queries.
                [get_gml_id({"local_id": id}) for id in member_ids],
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
            zoning_order["local_id"] += "-zoning_order"
            zoning_order["producer_specific_id"] += "-zoning_order"
            if zoning_order["reference_id"]:
                zoning_order["reference_id"] += "-zoning_order"
            # The zoning order type is the land use kind. Element type does not apply to order.
            zoning_order["type"] = zoning_order["land_use_kind"]
            # TODO: Each zoning element may only have text values and supplementary information with code values
            # https://tietomallit.ymparisto.fi/kaavatiedot/soveltamisprofiili/asemakaava/v1.0/kayttotarkoitukset/#alueen-käyttötarkoitus
            # Where are these stored in Kauko? Do we want to pick one particular regulation linked to the geometry
            # and link it to this order? Currently, we create all orders separately, because they may have
            # any type and any values, and pass empty values list in the zoning order.
            self.add_plan_order_element(
                zoning_order,
                dict(),
                dict(),
                dict(),
                dict(),
                [get_gml_id(zoning_element)],
            )

    def add_commentaries(self, commentaries: Dict[str, DictRow]) -> None:
        """
        Add Kauko database commentaries as spatial plan commentary objects.

        :param commentaries: Commentaries from Kauko database
        """
        documents = get_documents(
            "spatial_plan_commentary", commentaries.keys(), self.db, self.schema
        )
        for id, commentary in commentaries.items():
            self.add_spatial_plan_commentary_element(commentary, documents[id])
            # TODO: add commentary references directly to plan, once the commentary field is found in
            # schema. Currently the schema does not contain a field that would link commentaries to plan.

    def add_participation_and_evaluation_plans(
        self, participation_and_evaluation_plans: Dict[str, DictRow]
    ) -> None:
        """
        Add Kauko database participation and evaluation plans as participation and evaluation plan objects.

        :param participation_and_evaluation_plans: Participation and evaluation plans from Kauko database
        """
        documents = get_documents(
            "patricipation_evalution_plan",
            participation_and_evaluation_plans.keys(),
            self.db,
            self.schema,
        )
        for id, plan in participation_and_evaluation_plans.items():
            self.add_participation_and_evaluation_plan_element(plan, documents[id])
            # Participation and evaluation plan has to be referred to in the plan.
            # The current schema assumes there is only one for each plan version.
            add_reference_element(
                self.plan, PARTICIPATION_AND_EVALUATION_PLAN_REF, "#" + get_gml_id(plan)
            )

    def add_planners(self, planners: Dict[str, DictRow]) -> None:
        """
        Add Kauko database planners as planner objects.

        :param  planners: Planners from Kauko database
        """
        for id, planner in planners.items():
            self.add_planner_element(planner)
            # Planners have to be referred to in the plan
            # TODO: use get_gml_id once planner has an uuid
            add_reference_element(
                self.plan, PLANNER_REF, f"#id-planner-{planner['identifier']}"
            )

    def get_xml(self, plan_id: int, save_path: str = None) -> bytes:
        """
        Return Kaatio XML generated from a plan in Kauko database. Optionally, also save generated XML
        to given location.

        :param plan_id: Plan identifier in Kauko database
        :param save_path: Path to save XML to
        :return: UTF-8 encoded XML in bytes
        """
        # 1) Fetch and create spatial plan
        LOGGER.info("fetching plan data...")
        plan_data = get_spatial_plan(plan_id, self.db, self.schema)
        # TODO: enable this once db contains spatial_plan_documents table. These are plan
        # annex documents that should be added directly in the top level plan with annex tag.
        # plan_documents = get_documents("spatial_plan", [plan_data["local_id"]], self.db, self.schema)
        LOGGER.info(plan_data)
        LOGGER.info("creating plan element")
        self.plan = self.add_spatial_plan_element(plan_data)
        LOGGER.info("setting global values")
        self.plan_id = get_gml_id(plan_data)
        self.plan_name = plan_data["name"]["fin"]
        self.lifecycle_status = plan_data["lifecycle_status"]

        # 2) Fetch and create all zoning elements
        LOGGER.info("fetching zoning elements...")
        zoning_elements = get_zoning_elements(
            plan_data["local_id"], self.db, self.schema
        )
        LOGGER.info(zoning_elements)
        LOGGER.info("adding zoning elements")
        self.add_zoning_elements(zoning_elements)

        # 3) Fetch and create all planning detail lines. The same lines may belong to multiple zoning
        # elements and multiple planned spaces. Creating planning detail lines
        # one zoning element at a time would duplicate lines in XML.
        LOGGER.info("fetching planning detail lines...")
        detail_lines = get_plan_detail_lines(
            plan_data["local_id"], self.db, self.schema
        )
        LOGGER.info("got detail lines:")
        LOGGER.info(detail_lines)
        self.add_planning_detail_lines(detail_lines)

        # 4) Fetch and create all planned spaces. Due to buffers in relation triggers, the same planned space
        # may belong to multiple zoning elements, even if they do not strictly overlap. Creating planned spaces
        # one zoning element at a time would duplicate planned spaces in XML.
        LOGGER.info("fetching planned spaces...")
        planned_spaces = get_planned_spaces(plan_data["local_id"], self.db, self.schema)
        LOGGER.info("got planned spaces:")
        LOGGER.info(planned_spaces)
        self.add_planned_spaces(planned_spaces)

        # 5) TODO: päätettävä, miten selittävät tekstit ja viivat viedään, jos ollenkaan
        LOGGER.info("fetching describing texts...")
        describing_texts = get_describing_texts(
            plan_data["local_id"], self.db, self.schema
        )
        # self.add_describing_texts(describing_texts)
        LOGGER.info("fetching describing lines...")
        describing_texts = get_describing_lines(
            plan_data["local_id"], self.db, self.schema
        )
        # self.add_describing_lines(describing_texts)

        # 6) Fetch all regulation groups and their regulations. The same regulation group may
        # belong to multiple zoning elements, detail lines and planned spaces. The same
        # regulation may belong to multiple groups, zoning elements, detail lines and spaces.
        LOGGER.info("fetching regulation groups...")
        zoning_element_regulation_groups = get_regulation_groups(
            "zoning_element", zoning_elements.keys(), self.db, self.schema
        )
        planned_space_regulation_groups = get_regulation_groups(
            "planned_space", planned_spaces.keys(), self.db, self.schema
        )
        detail_line_regulation_groups = get_regulation_groups(
            "planning_detail_line", detail_lines.keys(), self.db, self.schema
        )
        # combine regulation groups:
        group_ids = set().union(
            zoning_element_regulation_groups.keys(),
            planned_space_regulation_groups.keys(),
            detail_line_regulation_groups.keys(),
        )
        # regulation groups by group id and target id:
        regulation_groups = {}
        for group_id in group_ids:
            regulation_groups[group_id] = {}
            regulation_groups[group_id].update(zoning_element_regulation_groups.get(group_id, {}))
            regulation_groups[group_id].update(planned_space_regulation_groups.get(group_id, {}))
            regulation_groups[group_id].update(detail_line_regulation_groups.get(group_id, {}))
        LOGGER.info("got groups:")
        LOGGER.info(regulation_groups)
        # get all regulations in groups:
        regulations_by_group = get_group_regulations(
            regulation_groups.keys(), self.db, self.schema
        )
        group_regulations = {
            id: regulation
            for regulation_dict in regulations_by_group.values()
            for id, regulation in regulation_dict.items()
        }
        LOGGER.info("regulations in groups:")
        LOGGER.info(group_regulations)

        # 7) Fetch and create the rest of the regulations. Do *not* create them
        # for each zoning element, planned space, line and group separately. If the same regulation
        # refers to multiple plan objects, it would duplicate regulations in XML. We must add each
        # regulation only once.
        LOGGER.info("fetching regulations...")
        plan_regulations = get_plan_regulations(
            "spatial_plan", [plan_data["local_id"]], self.db, self.schema
        )
        plan_guidances = get_plan_regulations(
            "spatial_plan", [plan_data["local_id"]], self.db, self.schema, guidance=True
        )
        zoning_element_regulations = get_plan_regulations(
            "zoning_element", zoning_elements.keys(), self.db, self.schema
        )
        zoning_element_guidances = get_plan_regulations(
            "zoning_element",
            zoning_elements.keys(),
            self.db,
            self.schema,
            guidance=True,
        )
        planned_space_regulations = get_plan_regulations(
            "planned_space", planned_spaces.keys(), self.db, self.schema
        )
        planned_space_guidances = get_plan_regulations(
            "planned_space", planned_spaces.keys(), self.db, self.schema, guidance=True
        )
        detail_line_regulations = get_plan_regulations(
            "planning_detail_line", detail_lines.keys(), self.db, self.schema
        )
        detail_line_guidances = get_plan_regulations(
            "planning_detail_line",
            detail_lines.keys(),
            self.db,
            self.schema,
            guidance=True,
        )
        # combine regulations, also taking into account group regulations fetched earlier:
        regulation_ids = set().union(
            plan_regulations.keys(),
            zoning_element_regulations.keys(),
            planned_space_regulations.keys(),
            detail_line_regulations.keys(),
            group_regulations.keys(),
        )
        # regulations by regulation id and target id:
        regulations = {}
        for regulation_id in regulation_ids:
            regulations[regulation_id] = {}
            regulations[regulation_id].update(plan_regulations.get(regulation_id, {}))
            regulations[regulation_id].update(zoning_element_regulations.get(regulation_id, {}))
            regulations[regulation_id].update(planned_space_regulations.get(regulation_id, {}))
            regulations[regulation_id].update(detail_line_regulations.get(regulation_id, {}))
            regulations[regulation_id].update(group_regulations.get(regulation_id, {}))
        LOGGER.info("got regulations:")
        LOGGER.info(regulations)
        guidance_ids = set().union(
            plan_guidances.keys(),
            zoning_element_guidances.keys(),
            planned_space_guidances.keys(),
            detail_line_guidances.keys(),
        )
        guidances = {
            guidance_id: {
                **plan_guidances[guidance_id],
                **zoning_element_guidances[guidance_id],
                **planned_space_guidances[guidance_id],
                **detail_line_guidances[guidance_id],
            }
            for guidance_id in guidance_ids
        }
        LOGGER.info("got guidances:")
        LOGGER.info(guidances)
        self.add_regulations(regulations)

        # 8) Fetch and create all planners smack in the middle of the regulation thing.
        # For reasons beyond our comprehension, the Kaatio
        # API will *only* accept planners for a plan if they are linked *after* general regulations
        # but *before* general recommendations. Looks like the validator requires a very
        # specific ordering of fields for no particular reason.
        # TODO: For some reason, planners are always attached to all versions of the plan
        # (producer specific id), never one version (local id).
        planners = get_planners(plan_data["producer_specific_id"], self.db, self.schema)
        self.add_planners(planners)

        # 9) Now, after planners have been linked, the validator will not get terribly confused
        # when we try to add guidances.
        self.add_regulations(guidances, guidance=True)

        # 10) Regulation groups may only be added after all regulations have been added. They refer
        # to existing regulations.
        self.add_regulation_groups(regulation_groups, regulations_by_group)

        # 11) Fetch and create all commentaries
        commentaries = get_plan_commentaries(
            plan_data["local_id"], self.db, self.schema
        )
        self.add_commentaries(commentaries)

        # 12) Fetch and create participation and evaluation plan
        participation_and_evaluation_plan = get_participation_and_evaluation_plan(
            plan_data["local_id"], self.db, self.schema
        )
        self.add_participation_and_evaluation_plans(participation_and_evaluation_plan)

        # 13) Fetch and create regulation documents here. For some reason, documents cannot be contained
        # inline in *regulations* (they must be referenced instead), while they are fine contained inline
        # in guidances, commentaries and participation and evaluation plans. So *some* of the documents have
        # to be created separately, go figure.
        # TODO: Most likely all documents will have to be created this way at some point, because
        # any document may be linked to multiple objects, even in commentaries, guidances etc.
        # Current API schema assumes the same document may not be common to multiple guidances, commentaries etc.
        documents_by_regulation = get_documents(
            "plan_regulation", regulation_ids, self.db, self.schema
        )
        documents_by_id = {
            id: document
            for document_dict in documents_by_regulation.values()
            for id, document in document_dict.items()
        }
        self.add_regulation_documents(documents_by_id)

        if save_path:
            tree = ElementTree(self.root)
            tree.write(f"{save_path}/{self.plan_name}.xml", "utf-8")
        return tostring(self.root, "utf-8")

    def save_response(self, response: str, save_path: str):
        """
        Save XML response from Kaatio server to given location

        :param response: XML response from Kaatio server
        :param save_path: Path to save XML to
        """
        incoming_plan = fromstring(response)
        tree = ElementTree(incoming_plan)
        tree.write(f"{save_path}/{self.plan_name}.response.xml", "utf-8")

    def update_ids_in_db(self, response: str):
        """
        Update existing plan based on XML response from Kaatio server.

        :param xml: XML response from Kaatio server
        """
        incoming_plan = fromstring(response)
        feature_members = incoming_plan.findall(f".//{FEATUREMEMBER}", NAMESPACES)
        # spatial_plan = incoming_plan.find(".//{" + NAMESPACES[SPLAN_NS] + "}SpatialPlan")
        for member in feature_members:
            member_element = member.find(".//")
            LOGGER.info("saving id for element")
            LOGGER.info(member_element.tag)
            producer_id_element = member.find(
                ".//{" + NAMESPACES[CORE_NS] + "}producerSpecificIdentifier"
            )
            # TODO: remove this check once planner table has producer specific id
            if producer_id_element is None:
                LOGGER.info("object has no producer id, skipping...")
                continue
            producer_id = producer_id_element.text
            # if the element is an order created from zoning element type, it has no separate
            # entry in Kauko database:
            if producer_id.endswith("-zoning_order"):
                LOGGER.info("zoning order element found, skipping...")
                continue
            table_name = get_destination_table(incoming_plan, member_element)

            reference_id = member_element.get("{" + NAMESPACES["gml"] + "}id")
            # NOTE: currently, Kaatio API always returns planIdentifier as is.
            # Therefore, there is no need to update identity id.
            # identity_id = incoming_plan.find(
            #     ".//{SPATIAL_PLAN}/{PLAN_IDENTIFIER}", NAMESPACES).text
            # get rid of id- string that is in front of UUIDs for some reason
            # identity_id = identity_id.split("id-")[1]
            reference_id = reference_id.split("id-")[1]
            # Better be explicit and update fields separately. We don't want all plan fields to be editable.
            # set_spatial_plan_identity_id(plan_id, identity_id, self.db, self.schema)
            set_object_reference_id(
                table_name, producer_id, reference_id, self.db, self.schema
            )

            storage_time_element = member.find(
                f".//{STORAGE_TIME}/{TIME_INSTANT}/{TIME_POSITION}", NAMESPACES
            )
            # TODO: For unknown reasons, PlanRecommendation, PlanOrderGroup and SpatialPlanCommentary
            # are currently missing storage time in the Kaatio API.
            if storage_time_element is None:
                LOGGER.info("storage time missing, skipping...")
                continue
            storage_time = storage_time_element.text
            storage_time = datetime.fromisoformat(storage_time)
            set_object_storage_time(
                table_name, producer_id, storage_time, self.db, self.schema
            )
