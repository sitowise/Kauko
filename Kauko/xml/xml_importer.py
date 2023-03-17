import json
import logging
from datetime import datetime
from psycopg2.extras import DateRange
from typing import Any, Callable, Dict, Union
from xml.etree.ElementTree import Element, parse, tostring

from ..database.database import Database
from ..database.database_handler import upsert_object
from .tools import NAMESPACES, add_namespaces, get_destination_table, get_zoning_order, XML_VALUE_MAP_SIMPLE

# This is probably the only sensible usage for import *
# tags.py must *only* contain a consistent set of upper-case constants
from .tags import *  # noqa: F403

LOGGER = logging.getLogger("kauko")


def add_reference(referring_tag: str, referring_uuid: str, element: Element):
    """
    Add entry to many-to-many table in Kauko database. Objects in the referred tables
    must already exist.

    :param referring_tag: Tag for element that contains the reference
    :param referring_uuid: UUID for element that contains the reference
    :param element: Reference element
    """
    pass


def add_value(referring_tag: str, referring_uuid: str, element: Element):
    """
    Add value data to Kauko database.

    :param referring_tag: Tag for element that contains the value
    :param referring_uuid: UUID for element that contains the value
    :param element: Value element
    """
    pass


def add_supplementary_info(referring_tag: str, referring_uuid: str, element: Element):
    """
    Add supplementary info data to Kauko database.

    :param referring_tag: Tag for element that contains the supplementary info element
    :param referring_uuid: UUID for element that contains the supplementary info element
    :param element: Supplementary info element
    """
    pass


def add_document(referring_tag: str, referring_uuid: str, element: Element):
    """
    Add document data to Kauko database.

    :param referring_tag: Tag for element that contains the document element
    :param referring_uuid: UUID for element that contains the document element
    :param element: Document element
    """
    pass


# Determine destination field or function to call for each encountered XML field
XML_FIELD_MAP_SIMPLE: Dict[str, Union[str, Callable]] = {
    PRODUCER_SPECIFIC_IDENTIFIER: "producer_specific_id",
    LATEST_CHANGE: "latest_change",
    NAME: "name",
    BOUNDARY: "geom",
    LEGAL_EFFECTIVENESS: "legal_effectiveness",
    VALIDITY_TIME: "validity_time",
    TYPE: "type",
    PLAN_IDENTIFIER: "identity_id",
    LIFECYCLE_STATUS: "lifecycle_status",
    GROUND_RELATIVE_POSITION: "ground_relative_position",
    INITIATION_TIME: "initiation_time",
    APPROVAL_TIME: "approval_time",
    DIGITAL_ORIGIN: "digital_origin",
    ANNEX: add_document,
    GENERAL_ORDER: add_reference,
    PLANNER_REF: add_reference,
    GENERAL_RECOMMENDATION: add_reference,
    PARTICIPATION_AND_EVALUATION_PLAN_REF: add_reference,
    GEOMETRY: "geom",
    SPATIAL_PLAN_REF: add_reference,
    BINDINGNESS_OF_LOCATION: "bindingness_of_location",
    TARGET: add_reference,
    VALUE: add_value,
    SUPPLEMENTARY_INFO: add_supplementary_info,
    PERSON_NAME: "name",
    PROFESSION_TITLE: "professional_title",
    ROLE: "role",
    GROUP_NUMBER: "group_number",
    MEMBER: add_reference,
    DOCUMENT: add_document,
    ADDITIONAL_INFORMATION_LINK: "additional_information_link",
}

XML_FIELD_MAP: Dict[str, Union[str, Callable]] = add_namespaces(XML_FIELD_MAP_SIMPLE)


def get_text(element: Element) -> str:
    return element.text


def get_language_version(element: Element) -> str:
    return {element.attrib["{" + NAMESPACES["xml"] + "}lang"]: element.text}


def get_code(element: Element) -> int:
    return element.attrib["{" + NAMESPACES["xlink"] + "}href"].split("/")[-1]


def get_geometry(element: Element) -> str:
    # PostGIS will handle the GML
    return tostring(element, "unicode")


def get_time_position(element: Element) -> datetime:
    for subelement in element:
        return datetime.fromisoformat(subelement.text)


def get_time_period(element: Element) -> DateRange:
    lower = element.find(".//gml:beginPosition", NAMESPACES).text
    upper = element.find(".//gml:endPosition", NAMESPACES).text
    return DateRange(lower, upper)


def get_code_value(element: Element) -> None:
    # TODO
    pass


def get_identity_value(element: Element) -> None:
    # TODO
    pass


def get_numeric_value(element: Element) -> None:
    # TODO
    pass


def get_numeric_range_value(element: Element) -> None:
    # TODO
    pass


def get_text_value(element: Element) -> None:
    # TODO
    pass


def get_time_instant_value(element: Element) -> None:
    # TODO
    pass


def get_time_period_value(element: Element) -> None:
    # TODO
    pass


# Determine function to call for each encountered structured XML type
XML_TYPE_MAP_SIMPLE: Dict[str, Union[dict, Callable]] = {
    PRODUCER_SPECIFIC_IDENTIFIER: get_text,
    NAME: get_language_version,
    LEGAL_EFFECTIVENESS: get_code,
    TYPE: get_code,
    LIFECYCLE_STATUS: get_code,
    GROUND_RELATIVE_POSITION: get_code,
    DIGITAL_ORIGIN: get_code, 
    BINDINGNESS_OF_LOCATION: get_code,
    GROUND_RELATIVE_POSITION: get_code,
    GML_POINT: get_geometry,
    GML_LINESTRING: get_geometry,
    GML_POLYGON: get_geometry,
    TIME_INSTANT: get_time_position,
    TIME_PERIOD: get_time_period,
    CODE_VALUE: get_code_value,
    GEOMETRY_VALUE: {
        VALUE: {
            GML_POINT: get_geometry,
            GML_LINESTRING: get_geometry,
            GML_POLYGON: get_geometry,
        }
    },
    IDENTITY_VALUE: get_identity_value,
    NUMERIC_VALUE: get_numeric_value,
    NUMERIC_RANGE_VALUE: get_numeric_range_value,
    TEXT_VALUE: get_text_value,
    TIME_INSTANT_VALUE: get_time_instant_value,
    TIME_PERIOD_VALUE: get_time_period_value,
}

XML_TYPE_MAP: Dict[str, Union[dict, Callable]] = add_namespaces(XML_TYPE_MAP_SIMPLE)


def get_kauko_fields(element: Element) -> Dict[str, Any]:
    """
    Get all values from Kaatio element to Kauko database format

    :param element: XML element to read fields from
    :return: Dictionary with table column names and values
    """
    kauko_row = {}
    for subelement in element:
        LOGGER.info("importing subelement")
        LOGGER.info(subelement.tag)
        target_column = XML_FIELD_MAP[subelement.tag]
        if callable(target_column):
            # Value should be saved in a separate table.
            target_column(element.tag, element.attrib["{" + NAMESPACES["gml"] + "}id"], subelement)
        else:
            # Value should be saved in this table. Whether data is in element or
            # subelement depends on element type.
            try:
                # Simple elements contain all their data in attributes and text.
                # However, name element may be present multiple times.
                value = XML_TYPE_MAP[subelement.tag](subelement)
                LOGGER.info('got value')
                LOGGER.info(value)
                if target_column in kauko_row:
                    LOGGER.info('column found, appending')
                    kauko_row[target_column].update(value)
                else:
                    LOGGER.info('column not found, adding')
                    kauko_row[target_column] = value
            except KeyError:
                LOGGER.info('value not found in element')
                # More complex elements are nested and have special types
                for type_element in subelement:
                    kauko_row[target_column] = XML_TYPE_MAP[type_element.tag](type_element)
                    LOGGER.info("value from subelement")
                    LOGGER.info(kauko_row[target_column])
        LOGGER.info(kauko_row)
    return kauko_row


def add_extra_fields(root: Element, element: Element, table_name: str, row: Dict[str, Any]) -> Dict[str, Any]:
    """
    Some Kauko tables have extra fields that cannot be empty. Some data may
    have to be fetched from other XML elements.

    :param root: XML root element
    :param element: Element to be imported
    :param table_name: Destination table for the element
    :param row: Row to be saved to Kauko database
    """
    if table_name == "spatial_plan":
        if "name" in row and isinstance(row["name"], dict):
            if "fin" in row["name"] and "swe" in row["name"]:
                row["language"] = 3
            elif "fin" in row["name"] and "swe" not in row["name"]:
                row["language"] = 1
            elif "swe" in row["name"] and "fin" not in row["name"]:
                row["language"] = 2
        if "approval_time" in row and row["approval_time"]:
            # TODO: approved_by is required in Kauko, but Kaatio XML does not
            # currently tell us who approved the plan. We have to make things up.
            row["approved_by"] = 1
    if table_name == "zoning_element":
        # TODO: Kaatio XML API has no such field. We have to make things up.
        row["localized_name"] = "Zoning element localized name"
        # Zoning element type is determined by the linked zoning order.
        type_element = get_zoning_order(root, element).find(f".//{TYPE}", NAMESPACES)
    return row


class XMLImporter:
    def __init__(self, db: Database, schema: str) -> None:
        self.db = db
        self.schema = schema
        self.plan = None
        self.references_to_add = {}

    def add_references(self):
        """
        At the end of import run, add all entries in many-to-many tables.
        """
        for table_name, row_to_add in self.references_to_add.items():
            LOGGER.info(f"adding reference in {table_name}")
            LOGGER.info(row_to_add)
            upsert_object(table_name, row_to_add)

    def save_xml(self, file_path: str) -> bool:
        """
        Save Kaatio XML to Kauko database.

        :param file_path: Path to read XML from
        :return: Whether plan was successfully saved to Kauko database.
        """
        tree = parse(file_path)
        self.plan = tree.getroot()
        feature_members = self.plan.findall(f".//{FEATUREMEMBER}", NAMESPACES)
        for member in feature_members:
            element = member.find(".//")
            LOGGER.info("importing element")
            LOGGER.info(element.tag)
            table_name = get_destination_table(self.plan, element)
            row_to_add = get_kauko_fields(element)
            row_to_add = add_extra_fields(self.plan, element, table_name, row_to_add)
            LOGGER.info(row_to_add)
            upsert_object(table_name, row_to_add, self.db, self.schema)
            LOGGER.info("element added or updated")
        #self.add_references()
        LOGGER.info("element references added")
