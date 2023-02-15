import logging
from datetime import datetime
from typing import Any, Dict, List
from xml.etree.ElementTree import dump, Element, ElementTree, fromstring, SubElement, tostring

from qgis.core import QgsProject

from ..database.database import Database
from ..database.database_handler import (
    get_code_list,
    get_spatial_plan,
    set_spatial_plan_reference_id,
    set_spatial_plan_identity_id,
    set_spatial_plan_storage_time,
    get_zoning_elements
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

FEATUREMEMBER = CORE_NS + ":featureMember"
PRODUCER_SPECIFIC_IDENTIFIER = CORE_NS + ":producerSpecificIdentifier"
LATEST_CHANGE = CORE_NS + ":latestChange"
NAME = CORE_NS + ":loc_name"
BOUNDARY = CORE_NS + ":boundary"
LEGAL_EFFECTIVENESS = CORE_NS + ":legalEffectiveness"
RESPONSIBLE_ORGANIZATION = CORE_NS + ":responsibleOrganization"

SPATIAL_PLAN = SPLAN_NS + ":SpatialPlan"

GML_POLYGON = "gml:Polygon"
GML_EXTERIOR = "gml:exterior"
GML_LINEAR_RING = "gml:LinearRing"
POS_LIST = "posList"
TIME_INSTANT = "gml:TimeInstant"
TIME_POSITION = "gml:timePosition"

XML_LANG = "xml:lang"


def add_time_position(parent: Element, position: datetime, attrib: Dict = None) -> Element:
    """
    Create GML time instant element with given time position and extra tags.

    :param feature: Element under which time instant should be added
    :param position: Time instant to add
    :param attrib: Extra attributes to add to the time instant
    """
    time_instant = SubElement(parent, TIME_INSTANT, attrib if attrib else {})
    time_position = SubElement(time_instant, TIME_POSITION)
    time_position.text = position.isoformat()
    return time_instant


def add_polygon(parent: Element, gml: str, id: str) -> Element:
    """
    Create GML polygon element with given GML and GML id.

    :param feature: Element under which polygon should be added
    :param gml: Geometry GML from ST_asGML
    :param str: Desired id for polygon
    :return: Created element
    """
    # PostGIS creates polygon inside multisurface and surface member by default. Add element
    # to simple polygon instead.
    gml_element = fromstring(gml)
    srs_name = gml_element.get("srsName")
    polygon = SubElement(parent, GML_POLYGON, {"srsName": srs_name, "gml:id": "foo"})
    exterior = SubElement(polygon, GML_EXTERIOR)
    linear_ring = SubElement(exterior, GML_LINEAR_RING)
    pos_list = SubElement(linear_ring, f"gml:{POS_LIST}")

    # only support polygons without holes for now
    incoming_pos_list = gml_element.findall(f'.//{POS_LIST}')[0]
    pos_list.text = incoming_pos_list.text
    return polygon


def add_code_element(
        element: Element,
        tag: str,
        code_list: Dict[int, Dict[str, Any]],
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
    return SubElement(element, tag, {
        "xlink:href": code_data.get("uri", ""),
        "xlink:title": code_data.get(title_field, "")
    })


class XMLExporter:
    def __init__(self, db: Database, schema: str) -> None:
        self.db = db
        self.schema = schema
        self.legal_effectiveness_kinds = get_code_list("legal_effectiveness_kind", db)
        # TODO: poistettava "code"-parametri kunhan finnish_municipality_codes-taulu on
        # standardimuodossa (codevalue, uri, preflabel_fi)
        self.finnish_municipality_codes = get_code_list("finnish_municipality_codes", db, "code")
        self.spatial_plan_kinds = get_code_list("spatial_plan_kind", db)
        self.lifecycle_statuses = get_code_list("spatial_plan_lifecycle_status", db)
        self.ground_relativeness_kinds = get_code_list("ground_relativeness_kind", db)
        self.digital_origin_kinds = get_code_list("digital_origin_kind", db)

    def add_spatial_plan_element(self, collection: Element, plan_data: Dict[str, Any]) -> Element:
        """
        Create spatial plan element under specified feature collection using plan_data.

        :param collection: Element under which plan should be added
        :param plan_data: Plan data from Kauko database
        :return: Created element
        """
        PLAN_IDENTIFIER = SPLAN_NS + ":planIdentifier"
        LIFECYCLE_STATUS = SPLAN_NS + ":lifecycleStatus"
        GROUND_RELATIVE_POSITION = SPLAN_NS + ":groundRelativePosition"
        INITIATION_TIME = SPLAN_NS + ":initiationTime"
        APPROVAL_TIME = SPLAN_NS + ":approvalTime"
        DIGITAL_ORIGIN = SPLAN_NS + ":digitalOrigin"
        TYPE = SPLAN_NS + ":type"

        feature = SubElement(collection, FEATUREMEMBER)
        plan = SubElement(feature, SPATIAL_PLAN, {"gml:id": plan_data["reference_id"]})

        # lud-core fields
        producer_specific_identifier = SubElement(plan, PRODUCER_SPECIFIC_IDENTIFIER)
        producer_specific_identifier.text = plan_data["producer_specific_id"]

        latest_change = SubElement(plan, LATEST_CHANGE)
        add_time_position(latest_change, plan_data["latest_change"])

        fin_name = SubElement(plan, NAME, {XML_LANG: "fin"})
        fin_name.text = plan_data["name"]["fin"]
        swe_name = SubElement(plan, NAME, {XML_LANG: "swe"})
        swe_name.text = plan_data["name"]["swe"]

        boundary = SubElement(plan, BOUNDARY)
        add_polygon(boundary, plan_data["gml"], plan_data["producer_specific_id"] + ".geom.0")

        add_code_element(plan, LEGAL_EFFECTIVENESS, self.legal_effectiveness_kinds, plan_data["legal_effectiveness"])
        # TODO: Tämä muoto ei kelpaa. Pitänee lisätä finnish_municipality_codesiin codevalue, uri ja preflabel_fi ensin.
        # self.add_code_element(plan, RESPONSIBLE_ORGANIZATION, self.finnish_municipality_codes, plan_data["land_administration_authority"], "name")

        # splan fields
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

    # def add_plan_object_element

    def add_zoning_elements(collection: Element, zoning_elements: List[Dict[str, Any]], gml_id: str) -> List[Element]:
        """
        Add Kauko database zoning elements as plan objects and their land use
        types as plan orders to Kaatio feature collection.

        :param collection: Element under which elements should be added
        :param zoning_elements: Zoning elements from Kauko database
        :param gml_id: GML id for plan
        :return: XML elements for all zoning elements linked to the plan
        """
        elements = []
        for zoning_element in zoning_elements:
            # TODO: all zoning elements must create planObject linked with planOrder
            pass
        return elements

    def add_plan_object_elements(self, collection: Element, local_id: int, gml_id: str) -> List[Element]:
        """
        Add all Kaatio plan objects linked to a plan in Kauko database.

        :param collection: Element under which objects should be added
        :param local_id: Local id for plan in Kauko database
        :param gml_id: GML id for plan
        :return: XML elements for all plan objects linked to the plan
        """
        elements = []
        zoning_elements = get_zoning_elements(local_id, self.db, self.schema)
        elements.extend(self.add_zoning_elements(collection, zoning_elements, gml_id))
        # elements.add(self.add_planned_spaces(collection, plan_id))
        # elements.add(self.add_planning_detail_lines(collection, plan_id))
        # elements.add(self.add_describing_lines(collection, plan_id))
        # elements.add(self.add_describing_texts(collection, plan_id))
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
        self.add_plan_object_elements(root, plan_data["local_id"], plan_data["reference_id"])

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
        identity_id = incoming_plan.find(".//{" + NAMESPACES[SPLAN_NS] + "}SpatialPlan/{" + NAMESPACES[CORE_NS] + "}objectIdentifier").text
        # get rid of id- string that is in front of UUID for some reason
        identity_id = identity_id.split("id-")[1]
        storage_time = incoming_plan.find(".//{" + NAMESPACES[SPLAN_NS] + "}SpatialPlan/{" + NAMESPACES[CORE_NS] + "}storageTime/{gml}TimeInstant/{gml}timePosition").text
        storage_time = datetime.fromisoformat(storage_time)

        # Better be explicit and update fields separately. We don't want all plan fields to be editable.
        set_spatial_plan_identity_id(plan_id, identity_id, self.db, self.schema)
        set_spatial_plan_reference_id(plan_id, reference_id, self.db, self.schema)
        set_spatial_plan_storage_time(plan_id, storage_time, self.db, self.schema)
