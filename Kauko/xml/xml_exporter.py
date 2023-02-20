import logging
from datetime import datetime
from psycopg2.extras import DateRange, DictRow
from typing import Any, Dict, List
from xml.etree.ElementTree import dump, Element, ElementTree, fromstring, SubElement, tostring

from qgis.core import QgsProject

from ..database.database import Database
from ..database.database_handler import (
    get_code_list,
    get_regulation_values,
    get_spatial_plan,
    get_zoning_elements,
    get_zoning_element_regulations,
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
LATEST_CHANGE = CORE_NS + ":latestChange"
NAME = CORE_NS + ":loc_name"
BOUNDARY = CORE_NS + ":boundary"
LEGAL_EFFECTIVENESS = CORE_NS + ":legalEffectiveness"
RESPONSIBLE_ORGANIZATION = CORE_NS + ":responsibleOrganization"
VALIDITY_TIME = CORE_NS + ":validityTime"

# splan tags
SPATIAL_PLAN = SPLAN_NS + ":SpatialPlan"
SPATIAL_PLAN_BUT_WITH_SMALL_INITIAL_JUST_FOR_FUN = SPLAN_NS + ":spatialPlan"
VALIDITY_TIME_INSIDE_SPLAN = SPLAN_NS + ":validityTime"
PLAN_OBJECT = SPLAN_NS + ":PlanObject"
PLAN_ORDER = SPLAN_NS + ":PlanOrder"
TARGET = SPLAN_NS + ":target"
GEOMETRY = SPLAN_NS + ":geometry"
GROUND_RELATIVE_POSITION = SPLAN_NS + ":groundRelativePosition"
BINDINGNESS_OF_LOCATION = SPLAN_NS + ":bindingnessOfLocation"
TYPE = SPLAN_NS + ":type"
LIFECYCLE_STATUS = SPLAN_NS + ":lifecycleStatus"

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


def get_gml_id(entry: Dict[str, Any]) -> str:
    """
    Return unique gml id for an entry in the database. In case the row has not been saved to
    the Kaatio API yet, it will not have reference id set.
    """
    # XML is really particular about accepted identity strings. Notably, an identity string
    # cannot start with a number, since it will not fulfill the \\\\i-[:]][\\\\c-[:]]* XSD regex,
    # as reported by the Kaatio API.
    #
    # This means we cannot use the bare reference id or local id here. The id will be thrown
    # away by the API when POSTing, but it still has to pass validation.
    return "id-"+ entry["reference_id"] if entry["reference_id"] else "id-" + entry["local_id"]


def add_time_period(parent: Element, period: DateRange) -> Element:
    """
    Create GML time period element with given time period.

    :param parent: Element under which time period should be added
    :param period: Time period to add
    :return: Created GML element
    """
    #LOGGER.info(str(type(period)).replace("<", "replaced"))
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
    :param str: Desired id for point
    :return: Created element
    """
    # PostGIS creates polygon inside multisurface and surface member by default. Add element
    # to simple polygon instead.
    gml_element = fromstring(gml)
    srs_name = gml_element.get("srsName")
    point = SubElement(parent, GML_LINESTRING, {"srsName": srs_name, "gml:id": id})
    position = SubElement(point, f"gml:{POS}")

    # TODO: only support single points for now
    incoming_pos = gml_element.findall(f'.//{POS}')[0]
    position.text = incoming_pos.text
    return point


def add_line(parent: Element, gml: str, id: str) -> Element:
    """
    Create GML line element with given GML and GML id.

    :param parent: Element under which line should be added
    :param gml: Geometry GML from ST_asGML
    :param str: Desired id for line
    :return: Created element
    """
    # PostGIS creates polygon inside multisurface and surface member by default. Add element
    # to simple linestring instead.
    gml_element = fromstring(gml)
    srs_name = gml_element.get("srsName")
    linestring = SubElement(parent, GML_LINESTRING, {"srsName": srs_name, "gml:id": id})
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
    :param str: Desired id for polygon
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
        add_polygon(value_element, value["value"], value["geometry_area_value_uuid"])
    elif value_type == "geometry_line_value":
        pass
    elif value_type == "geometry_point_value":
        pass
    return container_element


class XMLExporter:
    def __init__(self, db: Database, schema: str) -> None:
        self.db = db
        self.schema = schema
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

    def add_lud_core_element(self, feature: Element, entry: DictRow, tag: str) -> Element:
        """
        Create XML element with lud-core fields, if present in entry.

        :param feature: Feature under which new element should be added
        :param entry: Row entry from Kauko database
        :param tag: Splan tag to use for the created element
        :return: Created element
        """
        LOGGER.info("adding lud core fields for entry")
        LOGGER.info(entry)
        # The gml:id will have to be unique, because it is used to link objects in the XML to each other.
        # Use placeholder gml ids generated from uuids if the plan has not been saved yet.
        element = SubElement(feature, tag, {"gml:id": get_gml_id(entry)})

        # lud-core fields
        producer_specific_identifier = SubElement(element, PRODUCER_SPECIFIC_IDENTIFIER)
        producer_specific_identifier.text = entry["producer_specific_id"]

        if "latest_change" in entry:
            latest_change = SubElement(element, LATEST_CHANGE)
            add_time_position(latest_change, entry["latest_change"])
        if "name" in entry and entry["name"]:
            add_language_string_elements(element, NAME, entry["name"])
        # NOTE: Lud-core boundary refers to plan boundary only. Therefore, it should not be present in other
        # objects. Other objects will have splan geometry instead.
        if "gml" in entry and tag == SPATIAL_PLAN:
            boundary = SubElement(element, BOUNDARY)
            add_polygon(boundary, entry["gml"], f"{get_gml_id(entry)}.geom.0")
        if "legal_effectiveness" in entry:
            add_code_element(element, LEGAL_EFFECTIVENESS, self.legal_effectiveness_kinds, entry["legal_effectiveness"])
        # NOTE: Lud-core validity time refers to plan validity time only. Therefore, it should not be present
        # in other objects. Other objects will have identical splan validity time instead, go figure.
        if "validity_time" in entry and entry["validity_time"] and tag == SPATIAL_PLAN:
            validity_time = SubElement(element, VALIDITY_TIME)
            add_time_period(validity_time, entry["validity_time"])
        if "land_administration_authority" in entry:
            # TODO: Tämä muoto ei kelpaa. Pitänee lisätä finnish_municipality_codesiin codevalue, uri ja preflabel_fi ensin.
            # add_code_element(plan, RESPONSIBLE_ORGANIZATION, self.finnish_municipality_codes, plan_data["land_administration_authority"], "name")
            pass
        return element

    def add_spatial_plan_element(self, collection: Element, plan_data: DictRow) -> Element:
        """
        Create spatial plan element under specified feature collection using plan_data.

        :param collection: Element under which plan should be added
        :param plan_data: Plan data from Kauko database
        :return: Created element
        """
        PLAN_IDENTIFIER = SPLAN_NS + ":planIdentifier"
        INITIATION_TIME = SPLAN_NS + ":initiationTime"
        APPROVAL_TIME = SPLAN_NS + ":approvalTime"
        DIGITAL_ORIGIN = SPLAN_NS + ":digitalOrigin"

        feature = SubElement(collection, FEATUREMEMBER)
        plan = self.add_lud_core_element(feature, plan_data, SPATIAL_PLAN)

        # spatial plan specific fields
        add_code_element(plan, TYPE, self.spatial_plan_kinds, plan_data["type"])

        plan_identifier = SubElement(plan, PLAN_IDENTIFIER)
        plan_identifier.text = plan_data["local_id"]
    
        add_code_element(plan, LIFECYCLE_STATUS, self.lifecycle_statuses, plan_data["lifecycle_status"])
        add_code_element(plan, GROUND_RELATIVE_POSITION, self.ground_relativeness_kinds, plan_data["ground_relative_position"])
        
        initiation_time = SubElement(plan, INITIATION_TIME)
        add_time_position(initiation_time, plan_data["initiation_time"])
        approval_time = SubElement(plan, APPROVAL_TIME)
        add_time_position(approval_time, plan_data["approval_time"])
        
        add_code_element(plan, DIGITAL_ORIGIN, self.digital_origin_kinds, plan_data["digital_origin"])

        return feature

    def add_plan_object_element(self, feature: Element, entry: DictRow, plan_gml_id: str) -> Element:
        """
        Create XML element with plan object fields, if present in entry.

        :param collection: Feature under which new element should be added
        :param object_data: Plan object data from Kauko database
        :param plan_gml_id: GML id for plan
        :return: XML element of the plan object
        """
        plan_object = self.add_lud_core_element(feature, entry, PLAN_OBJECT)

        geometry = SubElement(plan_object, GEOMETRY)
        add_polygon(geometry, entry["gml"],  f"{get_gml_id(entry)}.geom.0")

        plan = SubElement(plan_object, SPATIAL_PLAN_BUT_WITH_SMALL_INITIAL_JUST_FOR_FUN, {"xlink:href": "#" + plan_gml_id})
        add_code_element(plan_object, BINDINGNESS_OF_LOCATION, self.bindingness_kinds, entry["bindingness_of_location"])
        add_code_element(plan_object, GROUND_RELATIVE_POSITION, self.ground_relativeness_kinds, entry["ground_relative_position"])
        return plan_object

    def add_plan_order_element(self,
        feature: Element,
        entry: DictRow,
        values: Dict[str, List[DictRow]],
        plan_gml_id: str,
        target_gml_id: str,
        lifecycle_status: int = None,
        master_plan: bool = False,
    ) -> Element:
        """
        Create XML element with plan order fields, if present in entry.

        :param feature: Feature under which new element should be added
        :param entry: Plan order data from Kauko database
        :param values: Dict of order value types and values of each type
        :param plan_gml_id: GML id for plan
        :param target_gml_id: GML id for target, if order is not directly attached to plan
        :param lifecycle_status: Plan lifecycle status. Required in each plan order if not found in entry.
        :param master_plan: True if we want to use master plan code lists instead. The default is detail plan.
        :return: XML element of the plan order
        """
        plan_order = self.add_lud_core_element(feature, entry, PLAN_ORDER)

        for value_type, values in values.items():
            for value in values:
                add_value_element(plan_order, value_type, value)

        plan = SubElement(plan_order, SPATIAL_PLAN_BUT_WITH_SMALL_INITIAL_JUST_FOR_FUN, {"xlink:href": "#" + plan_gml_id})
        if target_gml_id:
            target = SubElement(plan_order, TARGET, {"xlink:href": "#" + target_gml_id})

        if master_plan:
            add_code_element(plan_order, TYPE, self.master_plan_regulation_kinds, entry["type"])
        else:
            add_code_element(plan_order, TYPE, self.detail_plan_regulation_kinds, entry["type"])

        # lifecycle status is required for each plan order
        if not lifecycle_status:
            lifecycle_status = entry["life_cycle_status"]
        add_code_element(plan_order, LIFECYCLE_STATUS, self.lifecycle_statuses, lifecycle_status)

        if "validity_time" in plan_order and plan_order["validity_time"]:
            validity_time = SubElement(plan_order, VALIDITY_TIME_INSIDE_SPLAN)
            add_time_period(validity_time, entry["validity_time"])

        return plan_order

    def add_zoning_elements(self, collection: Element, zoning_elements: List[DictRow], gml_id: str, lifecycle_status: int) -> List[Element]:
        """
        Add Kauko database zoning elements as plan objects and their land use
        types as plan orders to Kaatio feature collection.

        :param collection: Element under which elements should be added
        :param zoning_elements: Zoning elements from Kauko database
        :param gml_id: GML id for plan
        :param lifecycle_status: Plan lifecycle status. Required in each plan order.
        :return: XML elements for all zoning elements linked to the plan
        """
        elements = []
        for zoning_element in zoning_elements:
            LOGGER.info(zoning_element)
            feature = SubElement(collection, FEATUREMEMBER)
            self.add_plan_object_element(feature, zoning_element, gml_id)
            order_feature = SubElement(collection, FEATUREMEMBER)

            # Each zoning element must have planOrder linked to planObject.
            LOGGER.info("object element added, adding order...")
            zoning_order = zoning_element.copy()
            # This order must have a unique gml id though.
            zoning_order["local_id"] += "-zoning_order"
            # The zoning order type is the land use kind. Element type does not apply to order.
            zoning_order["type"] = zoning_order["land_use_kind"]
            # TODO: Each zoning element may only have text values and supplementary information with code values
            # https://tietomallit.ymparisto.fi/kaavatiedot/soveltamisprofiili/asemakaava/v1.0/kayttotarkoitukset/#alueen-käyttötarkoitus
            # Where are these stored in Kauko? Do we want to pick one particular regulation linked to the geometry
            # and link it to this order? Currently, we create all orders separately, because they may have
            # any values, and pass empty values list in the zoning order.
            self.add_plan_order_element(order_feature, zoning_order, dict(), gml_id, get_gml_id(zoning_element), lifecycle_status)

            # Create all the rest of the planOrders linked to the planObject
            LOGGER.info("fetching regulations...")
            regulations = get_zoning_element_regulations(zoning_element["local_id"], self.db, self.schema)
            regulation_values = get_regulation_values(regulations.keys(), self.db, self.schema)
            LOGGER.info("got regulations:")
            LOGGER.info(regulations)
            for id, regulation in regulations.items():
                LOGGER.info("adding regulation order...")
                values = regulation_values[id]
                order_feature = SubElement(collection, FEATUREMEMBER)
                self.add_plan_order_element(order_feature, regulation, values, gml_id, get_gml_id(zoning_element))
        return elements

    def add_plan_object_elements(self, collection: Element, local_id: int, gml_id: str, lifecycle_status: int) -> List[Element]:
        """
        Add all Kaatio plan objects linked to a plan in Kauko database.

        :param collection: Element under which objects should be added
        :param local_id: Local id for plan in Kauko database
        :param gml_id: GML id for plan
        :param lifecycle_status: Plan lifecycle status. Required in each plan order.
        :return: XML elements for all plan objects linked to the plan
        """
        elements = []
        LOGGER.info("getting zoning elements")
        zoning_elements = get_zoning_elements(local_id, self.db, self.schema)
        LOGGER.info("adding zoning elements")
        elements.extend(self.add_zoning_elements(collection, zoning_elements, gml_id, lifecycle_status))
        # elements.add(self.add_planned_spaces(collection, plan_id))
        # elements.add(self.add_planning_detail_lines(collection, plan_id))
        # elements.add(self.add_describing_lines(collection, plan_id))
        # elements.add(self.add_describing_texts(collection, plan_id))
        LOGGER.info("returning zoning elements")
        return elements

    def get_xml(self, plan_id: int) -> bytes:
        """
        Return Kaatio XML generated from a plan in Kauko database.

        :param plan_id: Plan identifier in Kauko database
        :return: UTF-8 encoded XML in bytes
        """
        LOGGER.info("creating root")
        root = Element(FEATURECOLLECTION, {**FEATURECOLLECTION_ATTRIBUTES, "gml:id": "foobar"})

        LOGGER.info("getting plan data:")
        plan_data = get_spatial_plan(plan_id, self.db, self.schema)
        LOGGER.info(plan_data)
        LOGGER.info("creating plan element")
        self.add_spatial_plan_element(root, plan_data)

        LOGGER.info("creating plan object elements")
        self.add_plan_object_elements(root, plan_data["local_id"], get_gml_id(plan_data), plan_data["lifecycle_status"])

        tree = ElementTree(root)
        tree.write("/Users/riku/repos/Kauko/plan.xml", "utf-8")
        return tostring(root, "utf-8")

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
