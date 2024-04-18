CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE SCHEMA IF NOT EXISTS $SCHEMANAME$;
CREATE SCHEMA IF NOT EXISTS code_lists;


-- Table: code_lists.detail_plan_regulation_kind

-- DROP TABLE IF EXISTS code_lists.detail_plan_regulation_kind;

CREATE TABLE IF NOT EXISTS code_lists.detail_plan_regulation_kind
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    codevalue character varying(6) NOT NULL,
    uri character varying(255) NOT NULL,
    preflabel_fi TEXT NOT NULL,
    description_fi TEXT,
    main_class TEXT NOT NULL,
    sub_class TEXT,
    CONSTRAINT detail_plan_regulation_kind_pkey PRIMARY KEY (id),
    CONSTRAINT detail_plan_regulation_kind_codevalue_key UNIQUE (codevalue),
    CONSTRAINT detail_plan_regulation_kind_uri_key UNIQUE (uri)
);

-- Table: code_lists.master_plan_regulation_kind

-- DROP TABLE IF EXISTS code_lists.master_plan_regulation_kind;

CREATE TABLE IF NOT EXISTS code_lists.master_plan_regulation_kind
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    codevalue character varying(6) NOT NULL,
    uri character varying(255) NOT NULL,
    preflabel_fi TEXT NOT NULL,
    definition_fi TEXT,
    description_fi TEXT,
    main_class TEXT NOT NULL,
    sub_class TEXT,
    CONSTRAINT master_plan_regulation_kind_pkey PRIMARY KEY (id),
    CONSTRAINT master_plan_regulation_kind_codevalue_key UNIQUE (codevalue),
    CONSTRAINT master_plan_regulation_kind_uri_key UNIQUE (uri)
);

-- Table: code_lists.spatial_plan_lifecycle_status

-- DROP TABLE IF EXISTS code_lists.spatial_plan_lifecycle_status;

CREATE TABLE IF NOT EXISTS code_lists.spatial_plan_lifecycle_status
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    codevalue character varying(3) NOT NULL,
    uri character varying(255) NOT NULL,
    preflabel_fi TEXT NOT NULL,
    preflabel_sv TEXT,
    definition_fi TEXT,
    definition_sv TEXT,
    description_fi TEXT,
    description_sv TEXT,
    CONSTRAINT spatial_plan_lifecycle_status_pkey PRIMARY KEY (id),
    CONSTRAINT spatial_plan_lifecycle_status_codevalue_key UNIQUE (codevalue),
    CONSTRAINT spatial_plan_lifecycle_status_uri_key UNIQUE (uri)
);

-- END OF NON-QUESTIONMARK TABLES

-- Table: code_lists.bindingness_kind

-- DROP TABLE IF EXISTS code_lists.bindingness_kind;

CREATE TABLE IF NOT EXISTS code_lists.bindingness_kind
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    codevalue character varying(3) NOT NULL,
    uri character varying(255) NOT NULL,
    preflabel_fi TEXT NOT NULL,
    description_fi TEXT,
    CONSTRAINT bindingness_kind_pkey PRIMARY KEY (id),
    CONSTRAINT bindingness_kind_codevalue_key UNIQUE (codevalue),
    CONSTRAINT bindingness_kind_uri_key UNIQUE (uri)
);


-- Table: code_lists.detail_plan_addition_information_kind

-- DROP TABLE IF EXISTS code_lists.detail_plan_addition_information_kind;

CREATE TABLE IF NOT EXISTS code_lists.detail_plan_addition_information_kind
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    codevalue character varying(3) NOT NULL,
    uri character varying(255) NOT NULL,
    preflabel_fi TEXT NOT NULL,
    preflabel_sv TEXT,
    definition_fi TEXT,
    definition_sv TEXT,
    description_fi TEXT,
    description_sv TEXT,
    CONSTRAINT detail_plan_addition_information_kind_pkey PRIMARY KEY (id),
    CONSTRAINT detail_plan_addition_information_kind_codevalue_key UNIQUE (codevalue),
    CONSTRAINT detail_plan_addition_information_kind_uri_key UNIQUE (uri)
);

-- Table: code_lists.detail_plan_theme

-- DROP TABLE IF EXISTS code_lists.detail_plan_theme;

CREATE TABLE IF NOT EXISTS code_lists.detail_plan_theme
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    codevalue character varying(3) NOT NULL,
    uri character varying(255) NOT NULL,
    preflabel_fi TEXT NOT NULL,
    preflabel_sv TEXT,
    definition_fi TEXT,
    definition_sv TEXT,
    CONSTRAINT detail_plan_theme_pkey PRIMARY KEY (id),
    CONSTRAINT detail_plan_theme_codevalue_key UNIQUE (codevalue),
    CONSTRAINT detail_plan_theme_uri_key UNIQUE (uri)
);


-- Table: code_lists.digital_origin_kind

-- DROP TABLE IF EXISTS code_lists.digital_origin_kind;

CREATE TABLE IF NOT EXISTS code_lists.digital_origin_kind
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    codevalue character varying(3) NOT NULL,
    uri character varying(255) NOT NULL,
    preflabel_fi TEXT NOT NULL,
    CONSTRAINT digital_origin_kind_pkey PRIMARY KEY (id),
    CONSTRAINT digital_origin_kind_codevalue_key UNIQUE (codevalue),
    CONSTRAINT digital_origin_kind_uri_key UNIQUE (uri)
);

-- Table: code_lists.document_kind

-- DROP TABLE IF EXISTS code_lists.document_kind;

CREATE TABLE IF NOT EXISTS code_lists.document_kind
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    codevalue character varying(2) NOT NULL,
    uri character varying(255) NOT NULL,
    preflabel_fi TEXT NOT NULL,
    preflabel_sv TEXT,
    definition_fi TEXT,
    description_fi TEXT,
    CONSTRAINT document_kind_pkey PRIMARY KEY (id),
    CONSTRAINT document_kind_codevalue_key UNIQUE (codevalue),
    CONSTRAINT document_kind_uri_key UNIQUE (uri)
);

-- Table: code_lists.finnish_municipalities

-- DROP TABLE IF EXISTS code_lists.finnish_municipalities;

CREATE TABLE IF NOT EXISTS code_lists.finnish_municipalities
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    codevalue character varying(3) NOT NULL,
    uri character varying(255) NOT NULL,
    preflabel_fi TEXT NOT NULL,
    preflabel_sv TEXT,
    CONSTRAINT finnish_municipalities_pkey PRIMARY KEY (id),
    CONSTRAINT finnish_municipalities_codevalue_key UNIQUE (codevalue),
    CONSTRAINT finnish_municipalities_uri_key UNIQUE (uri)
);

-- Table: code_lists.finnish_vertical_coordinate_reference_system

-- DROP TABLE IF EXISTS code_lists.finnish_vertical_coordinate_reference_system;

CREATE TABLE IF NOT EXISTS code_lists.finnish_vertical_coordinate_reference_system
(
    identifier integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    value integer NOT NULL,
    description TEXT NOT NULL,
    CONSTRAINT finnish_vertical_coordinate_reference_system_pkey PRIMARY KEY (identifier),
    CONSTRAINT finnish_vertical_coordinate_reference_system_value_key UNIQUE (value)
);

-- Table: code_lists.ground_relativeness_kind

-- DROP TABLE IF EXISTS code_lists.ground_relativeness_kind;

CREATE TABLE IF NOT EXISTS code_lists.ground_relativeness_kind
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    codevalue character varying(3) NOT NULL,
    uri character varying(255) NOT NULL,
    preflabel_fi TEXT NOT NULL,
    CONSTRAINT ground_relativeness_kind_pkey PRIMARY KEY (id),
    CONSTRAINT ground_relativeness_kind_codevalue_key UNIQUE (codevalue),
    CONSTRAINT ground_relativeness_kind_uri_key UNIQUE (uri)
);

-- Table: code_lists.iso_639_language

-- DROP TABLE IF EXISTS code_lists.iso_639_language;

CREATE TABLE IF NOT EXISTS code_lists.iso_639_language
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    code character varying(3) NOT NULL,
    name character varying(100) NOT NULL,
    CONSTRAINT iso_639_language_pkey PRIMARY KEY (id),
    CONSTRAINT iso_639_language_code_key UNIQUE (code)
);


-- Table: code_lists.legal_effectiveness_kind

-- DROP TABLE IF EXISTS code_lists.legal_effectiveness_kind;

CREATE TABLE IF NOT EXISTS code_lists.legal_effectiveness_kind
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    codevalue character varying(3) NOT NULL,
    uri character varying(255) NOT NULL,
    preflabel_fi TEXT NOT NULL,
    definition_fi TEXT,
    CONSTRAINT legal_effectiveness_kind_pkey PRIMARY KEY (id),
    CONSTRAINT legal_effectiveness_kind_codevalue_key UNIQUE (codevalue),
    CONSTRAINT legal_effectiveness_kind_uri_key UNIQUE (uri)
);

-- Table: code_lists.master_plan_envrionmental_change_kind

-- DROP TABLE IF EXISTS code_lists.master_plan_envrionmental_change_kind;

CREATE TABLE IF NOT EXISTS code_lists.master_plan_envrionmental_change_kind
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    codevalue character varying(3) NOT NULL,
    uri character varying(255) NOT NULL,
    preflabel_fi TEXT NOT NULL,
    preflabel_sv TEXT,
    description_fi TEXT,
    description_sv TEXT,
    CONSTRAINT master_plan_envrionmental_change_kind_pkey PRIMARY KEY (id),
    CONSTRAINT master_plan_envrionmental_change_kind_codevalue_key UNIQUE (codevalue),
    CONSTRAINT master_plan_envrionmental_change_kind_uri_key UNIQUE (uri)
);

-- Table: code_lists.master_plan_theme

-- DROP TABLE IF EXISTS code_lists.master_plan_theme;

CREATE TABLE IF NOT EXISTS code_lists.master_plan_theme
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    codevalue character varying(3) NOT NULL,
    uri character varying(255) NOT NULL,
    preflabel_fi TEXT NOT NULL,
    preflabel_sv TEXT,
    definition_fi TEXT,
    definition_sv TEXT,
    CONSTRAINT master_plan_theme_pkey PRIMARY KEY (id),
    CONSTRAINT master_plan_theme_codevalue_key UNIQUE (codevalue),
    CONSTRAINT master_plan_theme_uri_key UNIQUE (uri)
);

-- Table: code_lists.spatial_plan_kind

-- DROP TABLE IF EXISTS code_lists.spatial_plan_kind;

CREATE TABLE IF NOT EXISTS code_lists.spatial_plan_kind
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    kind_group TEXT,
    codevalue character varying(3) NOT NULL,
    uri character varying(255) NOT NULL,
    preflabel_fi TEXT NOT NULL,
    preflabel_sv TEXT,
    description_fi TEXT,
    description_sv TEXT,
    CONSTRAINT spatial_plan_kind_pkey PRIMARY KEY (id),
    CONSTRAINT spatial_plan_kind_codevalue_key UNIQUE (codevalue),
    CONSTRAINT spatial_plan_kind_uri_key UNIQUE (uri)
);

