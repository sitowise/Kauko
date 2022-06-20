GRANT USAGE ON SCHEMA SCHEMANAME TO qgis_editor;

GRANT ALL ON SCHEMA SCHEMANAME TO qgis_admin WITH GRANT OPTION;

ALTER DEFAULT PRIVILEGES IN SCHEMA SCHEMANAME
    GRANT ALL ON TABLES TO qgis_editor;

ALTER DEFAULT PRIVILEGES IN SCHEMA SCHEMANAME
    GRANT INSERT, SELECT, UPDATE, DELETE ON TABLES TO qgis_admin;

ALTER DEFAULT PRIVILEGES IN SCHEMA SCHEMANAME
    GRANT USAGE, SELECT ON SEQUENCES TO qgis_editor;

ALTER DEFAULT PRIVILEGES IN SCHEMA SCHEMANAME
    GRANT ALL ON SEQUENCES TO qgis_admin WITH GRANT OPTION;

ALTER DEFAULT PRIVILEGES IN SCHEMA SCHEMANAME
    GRANT EXECUTE ON FUNCTIONS TO qgis_editor;

ALTER DEFAULT PRIVILEGES IN SCHEMA SCHEMANAME
    GRANT EXECUTE ON FUNCTIONS TO qgis_admin WITH GRANT OPTION;

-- IDENTIFIERS

CREATE SEQUENCE SCHEMANAME.contact_identifier_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9999999;

CREATE SEQUENCE SCHEMANAME.describing_line_identifier_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9999999;

CREATE SEQUENCE SCHEMANAME.describing_text_identifier_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9999999;

CREATE SEQUENCE SCHEMANAME.localized_objective_identifier_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9999999;

CREATE SEQUENCE SCHEMANAME.numeric_value_identifier_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9999999;

CREATE SEQUENCE SCHEMANAME.planned_space_identifier_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9999999;

CREATE SEQUENCE SCHEMANAME.planned_space_numeric_value_identifier_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9999999;

CREATE SEQUENCE SCHEMANAME.planned_space_regulation_identifier_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9999999;

CREATE SEQUENCE SCHEMANAME.planning_detail_line_identifier_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9999999;

CREATE SEQUENCE SCHEMANAME.planning_detail_line_numeric_value_identifier_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9999999;

CREATE SEQUENCE SCHEMANAME.planning_detail_point_identifier_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9999999;

CREATE SEQUENCE SCHEMANAME.planning_detail_point_numeric_value_identifier_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9999999;

CREATE SEQUENCE SCHEMANAME.referenced_document_identifier_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9999999;

CREATE SEQUENCE SCHEMANAME.regulative_text_identifier_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9999999;

CREATE SEQUENCE SCHEMANAME.spatial_plan_identifier_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9999999;

CREATE SEQUENCE SCHEMANAME.spatial_plan_regulation_identifier_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9999999;

CREATE SEQUENCE SCHEMANAME.zoning_element_identifier_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9999999;

CREATE SEQUENCE SCHEMANAME.zoning_element_numeric_value_identifier_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9999999;

CREATE SEQUENCE SCHEMANAME.zoning_element_regulation_identifier_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9999999;