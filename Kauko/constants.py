PG_CONNECTIONS = "PostgreSQL/connections"

KAATIO_API_URL = "https://kaatio.spatineo-devops.com/v1/"

QGS_SETTINGS_PSYCOPG2_PARAM_MAP = {
    'database': 'dbname',
    'host': 'host',
    'password': 'password',
    'port': 'port',
    'username': 'user'
}

QGS_DEFAULT_DB_SETTINGS = {
    'allowGeometrylessTables': 'false',
    'authcfg': '',
    'dontResolveType': 'false',
    'estimatedMetadata': 'false',
    'geometryColumnsOnly': 'false',
    'projectsInDatabase': 'false',
    'publicOnly': 'false',
    'savePassword': 'true',
    'saveUsername': 'true',
    'service': '',
    'sslmode': 'SslDisable',
}

VALUE_TYPES = [
    "code_value",
    "geometry_area_value",
    "geometry_line_value",
    "geometry_point_value",
    "identifier_value",
    "numeric_double_value",
    "numeric_range",
    "text_value",
    "time_instant_value",
    "time_period_value"
]

LAYERS = {
    "contact": {
        "id": "identifier",
        "geom": None,
        "name": "Kaavan laatija",
        "group": "data"
    },
    "describing_line": {
        "id": "identifier",
        "geom": "geom",
        "name": "Selittävä viiva",
        "group": "geometria"
    },
    "describing_text": {
        "id": "identifier",
        "geom": "geom",
        "name": "Selittävä teksti",
        "group": "geometria"
    },
    "localized_objective": {
        "id": "identifier",
        "geom": None,
        "name": "Kaavan tavoite",
        "group": "data"
    },
    "numeric_value": {
        "id": "identifier",
        "geom": None,
        "name": "Numeerinen arvo",
        "group": "data"
    },
    "planned_space": {
        "id": "identifier",
        "geom": "geom",
        "name": "Kaavan osa-alue",
        "group": "geometria"
    },
    "planned_space_numeric_value": {
        "id": "identifier",
        "geom": None,
        "name": "Kaavan osa-alue - Numeerinen arvo",
        "group": "relaatiot"
    },
    "planned_space_regulation": {
        "id": "identifier",
        "geom": None,
        "name": "Kaavan osa-alue - Määräys",
        "group": "relaatiot"
    },
    "planning_detail_line": {
        "id": "identifier",
        "geom": "geom",
        "name": "Viivamainen tarkennemerkintä",
        "group": "geometria"
    },
    "planning_detail_line_numeric_value": {
        "id": "identifier",
        "geom": None,
        "name": "Viivamainen tarkennemerkintä - Numeerinen arvo",
        "group": "relaatiot"
    },
    "planning_detail_point": {
        "id": "identifier",
        "geom": "geom",
        "name": "Pistemäinen tarkennemerkintä",
        "group": "geometria"
    },
    "planning_detail_point_numeric_value": {
        "id": "identifier",
        "geom": None,
        "name": "Pistemäinen tarkennemerkintä - Numeerinen arvo",
        "group": "relaatiot"
    },
    "referenced_document": {
        "id": "identifier",
        "geom": None,
        "name": "Kaavan liite",
        "group": "data"
    },
    "regulative_text": {
        "id": "identifier",
        "geom": None,
        "name": "Kaavamääräys",
        "group": "data"
    },
    "spatial_plan": {
        "id": "identifier",
        "geom": "geom",
        "name": "Kaava",
        "group": "geometria"
    },
    "spatial_plan_regulation": {
        "id": "identifier",
        "geom": None,
        "name": "Kaava - Määräys",
        "group": "relaatiot"
    },
    "zoning_element": {
        "id": "identifier",
        "geom": "geom",
        "name": "Maankäyttöalue",
        "group": "geometria"
    },
    "zoning_element_numeric_value": {
        "id": "identifier",
        "geom": None,
        "name": "Maankäyttöalue - Numeerinen arvo",
        "group": "relaatiot"
    },
    "zoning_element_regulation": {
        "id": "identifier",
        "geom": None,
        "name": "Maankäyttöalue - Määräys",
        "group": "relaatiot"
    },
    "zoning_element_planned_space": {
        "id": "identifier",
        "geom": None,
        "name": "Maankäyttöalue - Kaavan osa-alue",
        "group": "relaatiot"
    },
    "zoning_element_plan_detail_line": {
        "id": "identifier",
        "geom": None,
        "name": "Maankäyttöalue - Viivamainen tarkennemerkintä",
        "group": "relaatiot"
    },
    "zoning_element_plan_detail_point": {
        "id": "identifier",
        "geom": None,
        "name": "Maankäyttöalue - Pistemäinen tarkennemerkintä",
        "group": "relaatiot"
    },
    "zoning_element_describing_text": {
        "id": "identifier",
        "geom": None,
        "name": "Maankäyttöalue - Selittävä teksti",
        "group": "relaatiot"
    },
    "zoning_element_describing_line": {
        "id": "identifier",
        "geom": None,
        "name": "Maankäyttöalue - Selittävä viiva",
        "group": "relaatiot"
    },
    "planned_space_plan_detail_point": {
        "id": "identifier",
        "geom": None,
        "name": "Kaavan osa-alue - Pistemäinen tarkennemerkintä",
        "group": "relaatiot"
    },
    "planned_space_plan_detail_line": {
        "id": "identifier",
        "geom": None,
        "name": "Kaavan osa-alue - Viivamainen tarkennemerkintä",
        "group": "relaatiot"
    }
}

CODE_LISTS = {
    "describing_line_type": {
        "id": "value",
        "name": "describing_line_type"
    },
    "finnish_area_type": {
        "id": "value",
        "name": "finnish_area_type"
    },
    "finnish_document_role": {
        "id": "identifier",
        "name": "finnish_document_role"
    },
    "finnish_document_type": {
        "id": "identifier",
        "name": "finnish_document_type"
    },
    "finnish_informative_feature_type": {
        "id": "identifier",
        "name": "finnish_informative_feature_type"
    },
    "finnish_land_use_kind": {
        "id": "identifier",
        "name": "finnish_land_use_kind"
    },
    "finnish_language": {
        "id": "identifier",
        "name": "finnish_language"
    },
    "finnish_municipality_codes": {
        "id": "identifier",
        "name": "finnish_municipality_codes"
    },
    "finnish_numeric_value": {
        "id": "value",
        "name": "finnish_numeric_value"
    },
    "finnish_planned_space_type": {
        "id": "value",
        "name": "finnish_planned_space_type"
    },
    "finnish_planning_detail_line_type": {
        "id": "value",
        "name": "finnish_planning_detail_line_type"
    },
    "finnish_planning_detail_point_type": {
        "id": "value",
        "name": "finnish_planning_detail_point_type"
    },
    "finnish_regulative_text_type": {
        "id": "value",
        "name": "finnish_regulative_text_type"
    },
    "finnish_spatial_plan_approved_by": {
        "id": "value",
        "name": "finnish_spatial_plan_approved_by"
    },
    "finnish_spatial_plan_level": {
        "id": "value",
        "name": "finnish_spatial_plan_level"
    },
    "finnish_spatial_plan_origin": {
        "id": "value",
        "name": "finnish_spatial_plan_origin"
    },
    "finnish_spatial_plan_status": {
        "id": "value",
        "name": "finnish_spatial_plan_status"
    },
    "finnish_spatial_plan_type": {
        "id": "value",
        "name": "finnish_spatial_plan_type"
    },
    "finnish_up_to_dateness": {
        "id": "value",
        "name": "finnish_up_to_dateness"
    },
    "finnish_vertical_coordinate_reference_system": {
        "id": "value",
        "name": "finnish_vertical_coordinate_reference_system"
    },
    "finnish_zoning_element_type": {
        "id": "value",
        "name": "finnish_zoning_element_type"
    },
    "validity_type": {
        "id": "identifier",
        "name": "validity_type"
    }
}

LAYERS_IN_FINNISH = {
    "contact": "Kaavan laatija",
    "describing_line": "Selittävä viiva",
    "describing_text": "Selittävä teksti",
    "localized_objective": "Kaavan tavoite",
    "numeric_value": "Numeerinen arvo",
    "planned_space": "Kaavan osa-alue",
    "planned_space_numeric_value": "Kaavan osa-alue - Numeerinen arvo",
    "planned_space_regulation": "Kaavan osa-alue - Määräys",
    "planning_detail_line": "Viivamainen tarkennemerkintä",
    "planning_detail_line_numeric_value": "Viivamainen tarkennemerkintä - Numeerinen arvo",
    "planning_detail_point": "Pistemäinen tarkennemerkintä",
    "planning_detail_point_numeric_value": "Pistemäinen tarkennemerkintä - Numeerinen arvo",
    "referenced_document": "Kaavan liite",
    "regulative_text": "Kaavamääräys",
    "spatial_plan": "Kaava",
    "spatial_plan_regulation": "Kaava - Määräys",
    "zoning_element": "Maankäyttöalue",
    "zoning_element_numeric_value": "Maankäyttöalue - Numeerinen arvo",
    "zoning_element_regulation": "Maankäyttöalue - Määräys",
    "zoning_element_planned_space": "Maankäyttöalue - Kaavan osa-alue",
    "zoning_element_plan_detail_line": "Maankäyttöalue - Viivamainen tarkennemerkintä",
    "zoning_element_plan_detail_point": "Maankäyttöalue - Pistemäinen tarkennemerkintä",
    "zoning_element_describing_text": "Maankäyttöalue - Selittävä teksti",
    "zoning_element_describing_line": "Maankäyttöalue - Selittävä viiva",
    "planned_space_plan_detail_point": "Kaavan osa-alue - Pistemäinen tarkennemerkintä",
    "planned_space_plan_detail_line": "Kaavan osa-alue - Viivamainen tarkennemerkintä"
}

LAYER_ORDER = (
    "spatial_plan", "describing_text", "describing_line",
    "planning_detail_point", "planning_detail_line", "planned_space",
    "zoning_element"
)

ADD_GEOM_CHECK_SQL = [
    "ALTER TABLE schemaname.spatial_plan "
    "ADD CONSTRAINT spatial_plan_geom_check CHECK (ST_isvalid(geom));",
    "ALTER TABLE schemaname.planning_detail_line "
    "ADD CONSTRAINT planning_detail_line_geom_check CHECK (ST_isvalid(geom));",
    "ALTER TABLE schemaname.planning_detail_point "
    "ADD CONSTRAINT planning_detail_point_geom_check CHECK (ST_isvalid(geom));",
    "ALTER TABLE schemaname.planned_space "
    "ADD CONSTRAINT planned_space_geom_check CHECK (ST_isvalid(geom));",
    "ALTER TABLE schemaname.zoning_element "
    "ADD CONSTRAINT zoning_element_geom_check CHECK (ST_isvalid(geom));"
]

DROP_GEOM_CHECK_SQL = [
    "ALTER TABLE schemaname.spatial_plan "
    "DROP CONSTRAINT spatial_plan_geom_check;",
    "ALTER TABLE schemaname.planning_detail_line "
    "DROP CONSTRAINT planning_detail_line_geom_check;",
    "ALTER TABLE schemaname.planning_detail_point "
    "DROP CONSTRAINT planning_detail_point_geom_check;",
    "ALTER TABLE schemaname.planned_space "
    "DROP CONSTRAINT planned_space_geom_check;",
    "ALTER TABLE schemaname.zoning_element "
    "DROP CONSTRAINT zoning_element_geom_check;"
]

NUMBER_OF_GEOM_CHECKS_SQL = \
    "SELECT COUNT(con.conname) " \
    "FROM pg_catalog.pg_constraint con " \
    "INNER JOIN pg_catalog.pg_class rel " \
    "ON rel.oid = con.conrelid " \
    "INNER JOIN pg_catalog.pg_namespace nsp " \
    "ON nsp.oid = connamespace " \
    "WHERE nsp.nspname = 'schemaname' " \
    "AND conname IN (" \
    "'spatial_plan_geom_check', 'planning_detail_line_geom_check', " \
    "'planning_detail_point_geom_check', 'planned_space_geom_check', " \
    "'zoning_element_geom_check');"

PROJECT_TEMPLATE_FOLDER = "database/project_updater/projects"

SPATIALREFSYS = "<wkt>WKT</wkt>\n" \
                "<proj4>PROJ4</proj4>\n" \
                "<srsid>SRSID</srsid>\n" \
                "<srid>SRID</srid>\n" \
                "<authid>AUTHID</authid>\n" \
                "<description>DESCRIPTION</description>\n" \
                "<projectionacronym>PROJECTIONACRONYM</projectionacronym>\n" \
                "<ellipsoidacronym>ELLIPSOIDACRONYM</ellipsoidacronym>\n" \
                "<geographicflag>GEOGRAPHICFLAG</geographicflag>"

REFRESH_MATERIALIZED_VIEWS = "/sql_scripts/refresh_materialised_views.sql"
