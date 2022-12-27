CREATE TABLE code_lists.describing_line_type (
    identifier integer PRIMARY KEY,
    value integer NOT NULL UNIQUE,
    description character varying NOT NULL
);

CREATE SEQUENCE code_lists.describing_line_type_identifier_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE code_lists.describing_line_type_identifier_seq OWNED BY code_lists.describing_line_type.identifier;

CREATE TABLE code_lists.finnish_area_type (
    identifier integer PRIMARY KEY,
    value integer NOT NULL UNIQUE,
    description character varying NOT NULL
);

CREATE SEQUENCE code_lists.finnish_area_type_identifier_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE code_lists.finnish_area_type_identifier_seq OWNED BY code_lists.finnish_area_type.identifier;

CREATE TABLE code_lists.finnish_document_role (
    identifier integer PRIMARY KEY,
    value integer NOT NULL UNIQUE,
    description character varying NOT NULL
);

CREATE SEQUENCE code_lists.finnish_document_role_identifier_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE code_lists.finnish_document_role_identifier_seq OWNED BY code_lists.finnish_document_role.identifier;

CREATE TABLE code_lists.finnish_document_type (
    identifier integer PRIMARY KEY,
    value integer NOT NULL UNIQUE,
    description character varying NOT NULL,
    codevalue character varying
);

CREATE SEQUENCE code_lists.finnish_document_type_identifier_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE code_lists.finnish_document_type_identifier_seq OWNED BY code_lists.finnish_document_type.identifier;

CREATE TABLE code_lists.finnish_informative_feature_type (
    identifier integer PRIMARY KEY,
    value integer NOT NULL UNIQUE,
    description character varying NOT NULL
);

CREATE SEQUENCE code_lists.finnish_informative_feature_type_identifier_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE code_lists.finnish_informative_feature_type_identifier_seq OWNED BY code_lists.finnish_informative_feature_type.identifier;

CREATE TABLE code_lists.finnish_land_use_kind (
    identifier integer PRIMARY KEY,
    code character varying NOT NULL UNIQUE,
    "group" character varying NOT NULL,
    label character varying NOT NULL,
    mark character varying,
    codevalue character varying
);

CREATE SEQUENCE code_lists.finnish_land_use_kind_identifier_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE code_lists.finnish_land_use_kind_identifier_seq OWNED BY code_lists.finnish_land_use_kind.identifier;

CREATE TABLE code_lists.finnish_language (
    identifier integer PRIMARY KEY,
    value integer NOT NULL UNIQUE,
    description character varying NOT NULL
);

CREATE SEQUENCE code_lists.finnish_language_identifier_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE code_lists.finnish_language_identifier_seq OWNED BY code_lists.finnish_language.identifier;

CREATE TABLE code_lists.finnish_municipality_codes (
    identifier integer PRIMARY KEY,
    code character varying NOT NULL UNIQUE,
    name character varying NOT NULL
);

CREATE SEQUENCE code_lists.finnish_municipality_codes_identifier_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE code_lists.finnish_municipality_codes_identifier_seq OWNED BY code_lists.finnish_municipality_codes.identifier;

CREATE TABLE code_lists.finnish_numeric_value (
    identifier integer PRIMARY KEY,
    value integer NOT NULL UNIQUE,
    description character varying NOT NULL,
    type character varying
);

CREATE SEQUENCE code_lists.finnish_numeric_value_identifier_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE code_lists.finnish_numeric_value_identifier_seq OWNED BY code_lists.finnish_numeric_value.identifier;

CREATE TABLE code_lists.finnish_ordinance_process (
    identifier integer PRIMARY KEY,
    value integer NOT NULL UNIQUE,
    description character varying NOT NULL
);

CREATE SEQUENCE code_lists.finnish_ordinance_process_identifier_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE code_lists.finnish_ordinance_process_identifier_seq OWNED BY code_lists.finnish_ordinance_process.identifier;

CREATE TABLE code_lists.finnish_ordinance_process_step (
    identifier integer PRIMARY KEY,
    value integer NOT NULL UNIQUE,
    description character varying NOT NULL
);

CREATE SEQUENCE code_lists.finnish_ordinance_process_step_identifier_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE code_lists.finnish_ordinance_process_step_identifier_seq OWNED BY code_lists.finnish_ordinance_process_step.identifier;

CREATE TABLE code_lists.finnish_plan_description (
    identifier integer PRIMARY KEY,
    value character varying NOT NULL UNIQUE,
    description character varying NOT NULL
);

CREATE SEQUENCE code_lists.finnish_plan_description_identifier_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE code_lists.finnish_plan_description_identifier_seq OWNED BY code_lists.finnish_plan_description.identifier;

CREATE TABLE code_lists.finnish_planned_space_type (
    identifier integer PRIMARY KEY,
    value integer NOT NULL UNIQUE,
    description character varying NOT NULL
);

CREATE SEQUENCE code_lists.finnish_planned_space_type_identifier_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE code_lists.finnish_planned_space_type_identifier_seq OWNED BY code_lists.finnish_planned_space_type.identifier;

CREATE TABLE code_lists.finnish_planning_detail_line_type (
    identifier integer PRIMARY KEY,
    value integer NOT NULL UNIQUE,
    description character varying NOT NULL
);

CREATE SEQUENCE code_lists.finnish_planning_detail_line_type_identifier_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE code_lists.finnish_planning_detail_line_type_identifier_seq OWNED BY code_lists.finnish_planning_detail_line_type.identifier;

CREATE TABLE code_lists.finnish_planning_detail_point_type (
    identifier integer PRIMARY KEY,
    value integer NOT NULL UNIQUE,
    description character varying NOT NULL
);

CREATE SEQUENCE code_lists.finnish_planning_detail_point_type_identifier_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE code_lists.finnish_planning_detail_point_type_identifier_seq OWNED BY code_lists.finnish_planning_detail_point_type.identifier;

CREATE TABLE code_lists.finnish_regulative_text_type (
    identifier integer PRIMARY KEY,
    value integer NOT NULL UNIQUE,
    description character varying NOT NULL
);

CREATE SEQUENCE code_lists.finnish_regulative_text_type_identifier_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE code_lists.finnish_regulative_text_type_identifier_seq OWNED BY code_lists.finnish_regulative_text_type.identifier;

CREATE TABLE code_lists.finnish_spatial_plan_approved_by (
    identifier integer PRIMARY KEY,
    value integer NOT NULL UNIQUE,
    description character varying NOT NULL
);

CREATE SEQUENCE code_lists.finnish_spatial_plan_approved_by_identifier_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE code_lists.finnish_spatial_plan_approved_by_identifier_seq OWNED BY code_lists.finnish_spatial_plan_approved_by.identifier;

CREATE TABLE code_lists.finnish_spatial_plan_level (
    identifier integer PRIMARY KEY,
    value integer NOT NULL UNIQUE,
    description character varying NOT NULL
);

CREATE SEQUENCE code_lists.finnish_spatial_plan_level_identifier_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE code_lists.finnish_spatial_plan_level_identifier_seq OWNED BY code_lists.finnish_spatial_plan_level.identifier;

CREATE TABLE code_lists.finnish_spatial_plan_origin (
    identifier integer PRIMARY KEY,
    value integer NOT NULL UNIQUE,
    description character varying NOT NULL,
    codevalue character varying
);

CREATE SEQUENCE code_lists.finnish_spatial_plan_origin_identifier_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE code_lists.finnish_spatial_plan_origin_identifier_seq OWNED BY code_lists.finnish_spatial_plan_origin.identifier;

CREATE TABLE code_lists.finnish_spatial_plan_status (
    identifier integer PRIMARY KEY,
    value integer NOT NULL UNIQUE,
    description character varying NOT NULL,
    codevalue character varying
);

CREATE SEQUENCE code_lists.finnish_spatial_plan_status_identifier_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE code_lists.finnish_spatial_plan_status_identifier_seq OWNED BY code_lists.finnish_spatial_plan_status.identifier;

CREATE TABLE code_lists.finnish_spatial_plan_type (
    identifier integer PRIMARY KEY,
    value integer NOT NULL UNIQUE,
    description character varying NOT NULL,
    codevalue character varying
);

CREATE SEQUENCE code_lists.finnish_spatial_plan_type_identifier_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE code_lists.finnish_spatial_plan_type_identifier_seq OWNED BY code_lists.finnish_spatial_plan_type.identifier;

CREATE TABLE code_lists.finnish_up_to_dateness (
    identifier integer PRIMARY KEY,
    value integer NOT NULL UNIQUE,
    description character varying NOT NULL
);

CREATE SEQUENCE code_lists.finnish_up_to_dateness_identifier_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE code_lists.finnish_up_to_dateness_identifier_seq OWNED BY code_lists.finnish_up_to_dateness.identifier;

CREATE TABLE code_lists.finnish_vertical_coordinate_reference_system (
    identifier integer PRIMARY KEY,
    value integer NOT NULL UNIQUE,
    description character varying NOT NULL
);

CREATE SEQUENCE code_lists.finnish_vertical_coordinate_reference_system_identifier_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE code_lists.finnish_vertical_coordinate_reference_system_identifier_seq OWNED BY code_lists.finnish_vertical_coordinate_reference_system.identifier;

CREATE TABLE code_lists.finnish_zoning_element_type (
    identifier integer PRIMARY KEY,
    value integer NOT NULL UNIQUE,
    description character varying NOT NULL
);

CREATE SEQUENCE code_lists.finnish_zoning_element_type_identifier_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE code_lists.finnish_zoning_element_type_identifier_seq OWNED BY code_lists.finnish_zoning_element_type.identifier;

CREATE TABLE code_lists.validity_type (
    identifier integer PRIMARY KEY,
    value integer NOT NULL UNIQUE,
    description character varying NOT NULL
);

CREATE SEQUENCE code_lists.validity_type_identifier_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE code_lists.validity_type_identifier_seq OWNED BY code_lists.validity_type.identifier;

ALTER TABLE ONLY code_lists.describing_line_type ALTER COLUMN identifier SET DEFAULT nextval('code_lists.describing_line_type_identifier_seq'::regclass);
ALTER TABLE ONLY code_lists.finnish_area_type ALTER COLUMN identifier SET DEFAULT nextval('code_lists.finnish_area_type_identifier_seq'::regclass);
ALTER TABLE ONLY code_lists.finnish_document_role ALTER COLUMN identifier SET DEFAULT nextval('code_lists.finnish_document_role_identifier_seq'::regclass);
ALTER TABLE ONLY code_lists.finnish_document_type ALTER COLUMN identifier SET DEFAULT nextval('code_lists.finnish_document_type_identifier_seq'::regclass);
ALTER TABLE ONLY code_lists.finnish_informative_feature_type ALTER COLUMN identifier SET DEFAULT nextval('code_lists.finnish_informative_feature_type_identifier_seq'::regclass);
ALTER TABLE ONLY code_lists.finnish_land_use_kind ALTER COLUMN identifier SET DEFAULT nextval('code_lists.finnish_land_use_kind_identifier_seq'::regclass);
ALTER TABLE ONLY code_lists.finnish_language ALTER COLUMN identifier SET DEFAULT nextval('code_lists.finnish_language_identifier_seq'::regclass);
ALTER TABLE ONLY code_lists.finnish_municipality_codes ALTER COLUMN identifier SET DEFAULT nextval('code_lists.finnish_municipality_codes_identifier_seq'::regclass);
ALTER TABLE ONLY code_lists.finnish_numeric_value ALTER COLUMN identifier SET DEFAULT nextval('code_lists.finnish_numeric_value_identifier_seq'::regclass);
ALTER TABLE ONLY code_lists.finnish_ordinance_process ALTER COLUMN identifier SET DEFAULT nextval('code_lists.finnish_ordinance_process_identifier_seq'::regclass);
ALTER TABLE ONLY code_lists.finnish_ordinance_process_step ALTER COLUMN identifier SET DEFAULT nextval('code_lists.finnish_ordinance_process_step_identifier_seq'::regclass);
ALTER TABLE ONLY code_lists.finnish_plan_description ALTER COLUMN identifier SET DEFAULT nextval('code_lists.finnish_plan_description_identifier_seq'::regclass);
ALTER TABLE ONLY code_lists.finnish_planned_space_type ALTER COLUMN identifier SET DEFAULT nextval('code_lists.finnish_planned_space_type_identifier_seq'::regclass);
ALTER TABLE ONLY code_lists.finnish_planning_detail_line_type ALTER COLUMN identifier SET DEFAULT nextval('code_lists.finnish_planning_detail_line_type_identifier_seq'::regclass);
ALTER TABLE ONLY code_lists.finnish_planning_detail_point_type ALTER COLUMN identifier SET DEFAULT nextval('code_lists.finnish_planning_detail_point_type_identifier_seq'::regclass);
ALTER TABLE ONLY code_lists.finnish_regulative_text_type ALTER COLUMN identifier SET DEFAULT nextval('code_lists.finnish_regulative_text_type_identifier_seq'::regclass);
ALTER TABLE ONLY code_lists.finnish_spatial_plan_approved_by ALTER COLUMN identifier SET DEFAULT nextval('code_lists.finnish_spatial_plan_approved_by_identifier_seq'::regclass);
ALTER TABLE ONLY code_lists.finnish_spatial_plan_level ALTER COLUMN identifier SET DEFAULT nextval('code_lists.finnish_spatial_plan_level_identifier_seq'::regclass);
ALTER TABLE ONLY code_lists.finnish_spatial_plan_origin ALTER COLUMN identifier SET DEFAULT nextval('code_lists.finnish_spatial_plan_origin_identifier_seq'::regclass);
ALTER TABLE ONLY code_lists.finnish_spatial_plan_status ALTER COLUMN identifier SET DEFAULT nextval('code_lists.finnish_spatial_plan_status_identifier_seq'::regclass);
ALTER TABLE ONLY code_lists.finnish_spatial_plan_type ALTER COLUMN identifier SET DEFAULT nextval('code_lists.finnish_spatial_plan_type_identifier_seq'::regclass);
ALTER TABLE ONLY code_lists.finnish_up_to_dateness ALTER COLUMN identifier SET DEFAULT nextval('code_lists.finnish_up_to_dateness_identifier_seq'::regclass);
ALTER TABLE ONLY code_lists.finnish_vertical_coordinate_reference_system ALTER COLUMN identifier SET DEFAULT nextval('code_lists.finnish_vertical_coordinate_reference_system_identifier_seq'::regclass);
ALTER TABLE ONLY code_lists.finnish_zoning_element_type ALTER COLUMN identifier SET DEFAULT nextval('code_lists.finnish_zoning_element_type_identifier_seq'::regclass);
ALTER TABLE ONLY code_lists.validity_type ALTER COLUMN identifier SET DEFAULT nextval('code_lists.validity_type_identifier_seq'::regclass);