import os


def get_query(schema_name: str, filename: str, srid: str = "", municipality: str = "",
              layers=None, plan_name=None) -> str:
    """Converts, modifies and returns sql file to string query with given parameters

    :param filename:
    :param plan_name:
    :param layers: dict
    :param schema_name: str
    :param srid: str
    :param municipality: str
    :return: str
    """
    with open(os.path.dirname(os.path.abspath(__file__)) + filename, "r") as sql_file:
        raw_sql = sql_file.read()
    sql_lines = []
    for line in raw_sql.split("\n"):
        line = line.replace("SCHEMANAME", schema_name)
        line = line.replace("PROJECTSRID", srid)
        line = line.replace("MUNICIPALITYCODE", municipality)
        if layers:
            if len(layers["spatial_plan"]) > 0:
                line = line.replace(
                    "SPATIAL_PLAN_PLANNING_OBJECT_IDENTIFIER",
                    ", ".join(
                        "'" + layer_id + "'"
                        for layer_id in layers["spatial_plan"]
                    ),
                )

            else:
                line = line.replace("SPATIAL_PLAN_PLANNING_OBJECT_IDENTIFIER", "NULL")

            if len(layers["regulative_text"]) > 0:
                line = line.replace(
                    "REGULATIVE_ID",
                    ", ".join(
                        "'" + layer_id + "'"
                        for layer_id in layers["regulative_text"]
                    ),
                )

            else:
                line = line.replace("REGULATIVE_ID", "NULL")

            if len(layers["numeric_value"]) > 0:
                line = line.replace(
                    "NUMERIC_ID",
                    ", ".join(
                        "'" + layer_id + "'"
                        for layer_id in layers["numeric_value"]
                    ),
                )

            else:
                line = line.replace("NUMERIC_ID", "NULL")

            if len(layers["zoning_element"]) > 0:
                line = line.replace(
                    "ZONING_ELEMENT_PLANNING_OBJECT_IDENTIFIER",
                    ", ".join(
                        "'" + layer_id + "'"
                        for layer_id in layers["zoning_element"]
                    ),
                )

            else:
                line = line.replace("ZONING_ELEMENT_PLANNING_OBJECT_IDENTIFIER", "NULL")

            if len(layers["planned_space"]) > 0:
                line = line.replace(
                    "PLANNED_SPACE_PLANNING_OBJECT_IDENTIFIER",
                    ", ".join(
                        "'" + layer_id + "'"
                        for layer_id in layers["planned_space"]
                    ),
                )

            else:
                line = line.replace("PLANNED_SPACE_PLANNING_OBJECT_IDENTIFIER", "NULL")

            if len(layers["planning_detail_line"]) > 0:
                line = line.replace(
                    "PLAN_DETAIL_LINE_PLANNING_OBJECT_IDENTIFIER",
                    ", ".join(
                        "'" + layer_id + "'"
                        for layer_id in layers["planning_detail_line"]
                    ),
                )

            else:
                line = line.replace("PLAN_DETAIL_LINE_PLANNING_OBJECT_IDENTIFIER", "NULL")

            if len(layers["planning_detail_point"]) > 0:
                line = line.replace(
                    "PLAN_DETAIL_POINT_PLANNING_OBJECT_IDENTIFIER",
                    ", ".join(
                        "'" + layer_id + "'"
                        for layer_id in layers["planning_detail_point"]
                    ),
                )

            else:
                line = line.replace("PLAN_DETAIL_POINT_PLANNING_OBJECT_IDENTIFIER", "NULL")

            if len(layers["describing_text"]) > 0:
                line = line.replace(
                    "DESCRIBING_TEXT_ID",
                    ", ".join(
                        "'" + layer_id + "'"
                        for layer_id in layers["describing_text"]
                    ),
                )

            else:
                line = line.replace("DESCRIBING_TEXT_ID", "NULL")

            if len(layers["describing_line"]) > 0:
                line = line.replace(
                    "DESCRIBING_LINE_ID",
                    ", ".join(
                        "'" + layer_id + "'"
                        for layer_id in layers["describing_line"]
                    ),
                )

            else:
                line = line.replace("DESCRIBING_LINE_ID", "NULL")

        if plan_name:
            line = line.replace("PLANNAME", "'" + str(plan_name) + "'")
        sql_lines.append(line)
    return "\n".join(sql_lines)
