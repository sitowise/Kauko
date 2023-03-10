from typing import Any, Dict, Hashable, Literal, Set, Union
from xml.etree.ElementTree import Element


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

XML_VALUE_MAP = {
    SPLAN_NS + ":CodeValue": "code_value",
    SPLAN_NS
    + ":GeometryValue": {
        SPLAN_NS + ":value": {
            "gml:Polygon": "geometry_area_value",
            "gml:LineString": "geometry_line_value",
            "gml:Point": "geometry_point_value",
        },
    },
    SPLAN_NS + ":IdentityValue": "identifier_value",
    SPLAN_NS + ":NumericValue": "numeric_double_value",
    SPLAN_NS + ":NumericRange": "numeric_range",
    SPLAN_NS + ":TextValue": "text_value",
    SPLAN_NS + ":TimeInstantValue": "time_instant_value",
    SPLAN_NS + ":TimePeriodValue": "time_period_value",
}


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


XML_TABLE_MAP = {
    "{" + NAMESPACES[SPLAN_NS] + "}SpatialPlan": "spatial_plan",
    "{"
    + NAMESPACES[SPLAN_NS]
    + "}PlanObject": {
        "{"
        + NAMESPACES[SPLAN_NS]
        + "}geometry": {
            "{" + NAMESPACES["gml"] + "}Polygon": get_polygon_type,
            "{" + NAMESPACES["gml"] + "}LineString": "planning_detail_line",
        }
    },
    "{" + NAMESPACES[SPLAN_NS] + "}PlanOrder": "plan_regulation",
    "{" + NAMESPACES[SPLAN_NS] + "}Planner": "planner",
    "{" + NAMESPACES[SPLAN_NS] + "}PlanRecommendation": "plan_guidance",
    "{" + NAMESPACES[SPLAN_NS] + "}PlanOrderGroup": "plan_regulation_group",
    "{" + NAMESPACES[SPLAN_NS] + "}SpatialPlanCommentary": "spatial_plan_commentary",
    "{"
    + NAMESPACES[SPLAN_NS]
    + "}ParticipationAndEvaluationPlan": "participation_and_evalution_plan",
    "{" + NAMESPACES[CORE_NS] + "}Document": "document",
}


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
