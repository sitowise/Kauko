from typing import Any, Dict, Hashable, Literal, Set, Union
from xml.etree.ElementTree import Element

# This is probably the only sensible usage for import *
# tags.py must *only* contain a consistent set of upper-case constants
from .tags import *  # noqa: F403


NAMESPACES = {
    "xml": "http://www.w3.org/XML/1998/namespace",
    "xsi": "http://www.w3.org/2001/XMLSchema-instance",
    "xlink": "http://www.w3.org/1999/xlink",
    "gml": "http://www.opengis.net/gml/3.2",
    "gmlexr": "http://www.opengis.net/gml/3.3/exr",
    "lsp": "http://tietomallit.ymparisto.fi/ry-yhteiset/kielituki/xml/1.0",
    CORE_NS: "http://tietomallit.ymparisto.fi/mkp-ydin/xml/1.2",
    SPLAN_NS: "http://tietomallit.ymparisto.fi/kaavatiedot/xml/1.2",
}


def add_namespaces(dictionary: Dict[str, Any]) -> Dict[str, Any]:
    """
    Add XML namespace URLs in place of namespace names for all dictionary keys.
    """
    namespaced_dict = dict()
    for key, value in dictionary.items():
        ns, name = key.split(":")
        if isinstance(value, dict):
            value = add_namespaces(value)
        namespaced_dict["{" + NAMESPACES[ns] + "}" + name] = value
    return namespaced_dict


def get_polygon_type(
    root: Element, element: Element
) -> Literal["zoning_element", "planned_space"]:
    """
    Determine correct Kauko destination table for Kaatio XML element data.

    :param root: Root of the XML element tree from Kaatio API
    :param element: XML element from Kaatio API
    :return: Kauko table to save data
    """
    return "zoning_element" if get_zoning_order(root, element) else "planned_space"


XML_VALUE_MAP_SIMPLE = {
    CODE_VALUE: "code_value",
    GEOMETRY_VALUE: {
        VALUE: {
            GML_POLYGON: "geometry_area_value",
            GML_LINESTRING: "geometry_line_value",
            GML_POINT: "geometry_point_value",
        },
    },
    IDENTITY_VALUE: "identifier_value",
    NUMERIC_VALUE: "numeric_double_value",
    NUMERIC_RANGE_VALUE: "numeric_range",
    TEXT_VALUE: "text_value",
    TIME_INSTANT_VALUE: "time_instant_value",
    TIME_PERIOD_VALUE: "time_period_value",
}

XML_TABLE_MAP_SIMPLE = {
    SPATIAL_PLAN: "spatial_plan",
    PLAN_OBJECT: {
        GEOMETRY: {
            GML_POLYGON: get_polygon_type,
            GML_LINESTRING: "planning_detail_line",
        }
    },
    PLAN_ORDER: "plan_regulation",
    PLANNER: "planner",
    PLAN_RECOMMENDATION: "plan_guidance",
    PLAN_ORDER_GROUP: "plan_regulation_group",
    COMMENTARY: "spatial_plan_commentary",
    PARTICIPATION_AND_EVALUATION_PLAN: "participation_and_evalution_plan",
    DOCUMENT: "document",
    VALUE: {
        **XML_VALUE_MAP_SIMPLE
    }, 
    SUPPLEMENTARY_INFO: "supplementary_information",
}

XML_TABLE_MAP = add_namespaces(XML_TABLE_MAP_SIMPLE)


def flip_dict(dictionary: Dict[Hashable, Any]) -> Dict[Hashable, Hashable]:
    """
    Flip dict keys and values, assuming values are unique. Non-hashable values
    are ignored.
    """
    return {
        value: key for key, value in dictionary.items() if isinstance(value, Hashable)
    }


def flatten_and_flip(
    dictionary: Dict[Hashable, Union[Dict, Hashable]]
) -> Dict[Hashable, Hashable]:
    """
    Flatten and flip a dictionary that may have subdictionaries,
    so that all hashable values in subdictionaries will become keys with
    the same value.
    """
    flattened = {}
    for key, value in dictionary.items():
        value_dict = {}
        while isinstance(value, dict):
            value_dict = value
            value = next(iter(value_dict.values()))
        flattened = {**flattened, **{value: key for value in value_dict.values()}}
    return {**flip_dict(dictionary), **flattened}


def get_destination_table(root: Element, element: Element) -> str:
    """
    Get Kauko table name for encountered Kaatio XML element. The exact
    table name may depend on any subelement and/or references
    to the element in the whole XML tree.
    """
    destination_table = XML_TABLE_MAP[element.tag]
    subelement = element
    while isinstance(destination_table, dict):
        table_dict = destination_table
        tag, destination_table = next(iter(destination_table.items()))
        if isinstance(destination_table, dict):
            subelement = subelement.find(f".//{tag}")
        else:
            for key, value in table_dict.items():
                if subelement.find(f".//{key}"):
                    # Subelement found
                    destination_table = value
    # The destination table may also be determined by a function
    if isinstance(destination_table, str):
        return destination_table
    elif callable(destination_table):
        return destination_table(root, element)


def get_zoning_order(root: Element, element: Element) -> Union[Element, None]:
    """
    Return XML zoning order corresponding to XML element, if it is a zoning element.
    If no valid zoning order is found, return None.

    :param root: Root of the XML element tree from Kaatio API
    :param element: XML plan object element from Kaatio API
    :return: XML element for corresponding zoning order
    """
    # Check for element plan orders in returned data. If the element has a plan order
    # with the right type and only allowed value types, it is a zoning element.
    # https://tietomallit.ymparisto.fi/kaavatiedot/soveltamisprofiili/asemakaava/v1.0/kayttotarkoitukset/#alueen-käyttötarkoitus
    element_id = element.get("{" + NAMESPACES["gml"] + "}id")
    element.get("{" + NAMESPACES["gml"] + "}id")
    orders = root.findall(f".//{SPLAN_NS}:PlanOrder", NAMESPACES)
    element_orders: Set[Element] = set()
    for order in orders:
        targets = order.findall(f".//{SPLAN_NS}:target", NAMESPACES)
        for target in targets:
            if target.get("{" + NAMESPACES["xlink"] + "}href") == "#" + element_id:
                element_orders.add(order)
    for order in element_orders:
        type_element = order.find(f".//{SPLAN_NS}:type", NAMESPACES)
        type = type_element.get("{" + NAMESPACES["xlink"] + "}href").split("/")[-1]
        if type.startswith("01"):
            values = order.findall(f".//{SPLAN_NS}:value", NAMESPACES)
            # zoning order may only have text values
            for value in values:
                value_element = value[0]
                if value_element.tag != "{" + NAMESPACES[SPLAN_NS] + "}TextValue":
                    # unsuitable value, this is no zoning order
                    break
            # corresponding zoning order found for element!
            else:
                return order
    # no valid zoning order found for element
    return None
