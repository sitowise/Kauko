-- Table: $SCHEMANAME$.code_value

-- DROP TABLE IF EXISTS $SCHEMANAME$.code_value;

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.code_value
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    code_value_uuid uuid NOT NULL DEFAULT uuid_generate_v4(),
    value TEXT NOT NULL,
    code_list TEXT,
    title jsonb,
    CONSTRAINT code_value_pkey PRIMARY KEY (id),
    CONSTRAINT code_value_code_value_uuid_key UNIQUE (code_value_uuid),
    CONSTRAINT code_value_title_check CHECK (check_ryhti_language(title))
)
;

CREATE SEQUENCE $SCHEMANAME$.describing_line_identifier_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

-- Table: $SCHEMANAME$.describing_line

-- DROP TABLE IF EXISTS $SCHEMANAME$.describing_line;

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.describing_line
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    geom geometry(MultiLineString,$PROJECTSRID$) NOT NULL,
    type integer NOT NULL,
    lifecycle_status character varying(3) NOT NULL DEFAULT '01'::TEXT,
    is_active boolean DEFAULT true,
    CONSTRAINT describing_line_pkey PRIMARY KEY (id),
    CONSTRAINT describing_line_lifecycle_status_fkey FOREIGN KEY (lifecycle_status)
        REFERENCES code_lists.spatial_plan_lifecycle_status (codevalue) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);

CREATE SEQUENCE $SCHEMANAME$.describing_text_identifier_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

-- Table: $SCHEMANAME$.describing_text

-- DROP TABLE IF EXISTS $SCHEMANAME$.describing_text;

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.describing_text
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    created timestamp without time zone NOT NULL DEFAULT now(),
    geom geometry(Point,$PROJECTSRID$) NOT NULL,
    text TEXT NOT NULL,
    label_x double precision,
    label_y double precision,
    label_rotation double precision,
    callouts boolean NOT NULL DEFAULT true,
    big_letters boolean,
    lifecycle_status character varying(3) NOT NULL DEFAULT '01'::TEXT,
    is_active boolean DEFAULT true,
    CONSTRAINT describing_text_pkey PRIMARY KEY (id),
    CONSTRAINT describing_text_lifecycle_status_fkey FOREIGN KEY (lifecycle_status)
        REFERENCES code_lists.spatial_plan_lifecycle_status (codevalue) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);

-- Table: $SCHEMANAME$.document

-- DROP TABLE IF EXISTS $SCHEMANAME$.document;

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.document
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    local_id TEXT NOT NULL DEFAULT uuid_generate_v4(),
    latest_change timestamp without time zone NOT NULL DEFAULT now(),
    storage_time timestamp without time zone,
    document_id TEXT,
    name jsonb,
    additional_information_link TEXT,
    metadata TEXT,
    type TEXT NOT NULL,
    created timestamp without time zone NOT NULL DEFAULT now(),
    created_by text NOT NULL,
    modified_by text NOT NULL,
    modified_at timestamp without time zone NOT NULL,
    CONSTRAINT document_pkey PRIMARY KEY (id),
    CONSTRAINT document_local_id_key UNIQUE (local_id),
    CONSTRAINT fk_document_type FOREIGN KEY (type)
        REFERENCES code_lists.document_kind (codevalue) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT document_name_check CHECK (check_ryhti_language(name))
);

-- Table: $SCHEMANAME$.document_document

-- DROP TABLE IF EXISTS $SCHEMANAME$.document_document;

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.document_document
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    referencing_document_local_id TEXT NOT NULL,
    referenced_document_local_id TEXT NOT NULL,
    role jsonb,
    CONSTRAINT document_document_pkey PRIMARY KEY (id),
    CONSTRAINT fk_referenced_document FOREIGN KEY (referenced_document_local_id)
        REFERENCES $SCHEMANAME$.document (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT fk_referencing_document FOREIGN KEY (referencing_document_local_id)
        REFERENCES $SCHEMANAME$.document (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT document_document_role_check CHECK (check_language_string(role)),
    CONSTRAINT local_id_check CHECK (referencing_document_local_id::text <> referenced_document_local_id::text)
);

-- Table: $SCHEMANAME$.elevation_position_value

-- DROP TABLE IF EXISTS $SCHEMANAME$.elevation_position_value;

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.elevation_position_value
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    elevation_position_value_uuid uuid NOT NULL DEFAULT uuid_generate_v4(),
    value double precision NOT NULL,
    unit_of_measure TEXT,
    reference_point geometry(Point,$PROJECTSRID$) NOT NULL,
    vertical_reference_system integer NOT NULL,
    is_active boolean NOT NULL DEFAULT true,
    CONSTRAINT elevation_position_value_pkey PRIMARY KEY (id),
    CONSTRAINT elevation_position_value_elevation_position_value_uuid_key UNIQUE (elevation_position_value_uuid),
    CONSTRAINT elevation_position_value_vertical_system_fk FOREIGN KEY (vertical_reference_system)
        REFERENCES code_lists.finnish_vertical_coordinate_reference_system (value) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- Table: $SCHEMANAME$.elevation_range_value

-- DROP TABLE IF EXISTS $SCHEMANAME$.elevation_range_value;

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.elevation_range_value
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    elevation_range_value_uuid uuid NOT NULL DEFAULT uuid_generate_v4(),
    minimum_value double precision,
    maximum_value double precision,
    unit_of_measure TEXT,
    reference_point geometry(Point,$PROJECTSRID$) NOT NULL,
    vertical_reference_system integer NOT NULL,
    is_active boolean NOT NULL DEFAULT true,
    CONSTRAINT elevation_range_value_pkey PRIMARY KEY (id),
    CONSTRAINT elevation_range_value_elevation_range_value_uuid_key UNIQUE (elevation_range_value_uuid),
    CONSTRAINT elevation_range_vertical_system_fk FOREIGN KEY (vertical_reference_system)
        REFERENCES code_lists.finnish_vertical_coordinate_reference_system (value) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT elevation_range_value_value_check CHECK (minimum_value <= maximum_value)
);

-- Table: $SCHEMANAME$.geometry_area_value

-- DROP TABLE IF EXISTS $SCHEMANAME$.geometry_area_value;

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.geometry_area_value
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    geometry_area_value_uuid uuid NOT NULL DEFAULT uuid_generate_v4(),
    value geometry(MultiPolygon,$PROJECTSRID$) NOT NULL,
    obligatory boolean NOT NULL,
    is_active boolean DEFAULT true,
    CONSTRAINT geometry_area_value_pkey PRIMARY KEY (id),
    CONSTRAINT geometry_area_value_geometry_area_value_uuid_key UNIQUE (geometry_area_value_uuid)
);

-- Table: $SCHEMANAME$.geometry_line_value

-- DROP TABLE IF EXISTS $SCHEMANAME$.geometry_line_value;

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.geometry_line_value
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    geometry_line_value_uuid uuid NOT NULL DEFAULT uuid_generate_v4(),
    value geometry(MultiLineString,$PROJECTSRID$) NOT NULL,
    obligatory boolean NOT NULL,
    is_active boolean DEFAULT true,
    CONSTRAINT geometry_line_value_pkey PRIMARY KEY (id),
    CONSTRAINT geometry_line_value_geometry_line_value_uuid_key UNIQUE (geometry_line_value_uuid)
);

-- Table: $SCHEMANAME$.geometry_point_value

-- DROP TABLE IF EXISTS $SCHEMANAME$.geometry_point_value;

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.geometry_point_value
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    geometry_point_value_uuid uuid NOT NULL DEFAULT uuid_generate_v4(),
    value geometry(Point,$PROJECTSRID$) NOT NULL,
    obligatory boolean NOT NULL,
    point_rotation double precision,
    is_active boolean DEFAULT true,
    CONSTRAINT geometry_point_value_pkey PRIMARY KEY (id),
    CONSTRAINT geometry_point_value_geometry_point_value_uuid_key UNIQUE (geometry_point_value_uuid)
);

-- Table: $SCHEMANAME$.planner

-- DROP TABLE IF EXISTS $SCHEMANAME$.planner;

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.planner
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    name TEXT NOT NULL,
    professional_title jsonb,
    role jsonb,
    local_id TEXT NOT NULL,
    latest_change timestamp without time zone NOT NULL DEFAULT now(),
    storage_time timestamp without time zone NOT NULL DEFAULT now(),
    CONSTRAINT contact_pkey PRIMARY KEY (id),
    CONSTRAINT planner_local_id_key UNIQUE (local_id),
    CONSTRAINT contact_name_check CHECK (name::text <> ''::text),
    CONSTRAINT planner_professional_title_check CHECK (check_language_string(professional_title)),
    CONSTRAINT planner_role_check CHECK (check_language_string(role))
);

-- Table: $SCHEMANAME$.spatial_plan_main

-- DROP TABLE IF EXISTS $SCHEMANAME$.spatial_plan_main;

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.spatial_plan_main
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    local_plan_id text NOT NULL DEFAULT (uuid_generate_v4())::text,
    ryhti_plan_id text,
    name jsonb NOT NULL,
    fk_responsible text,
    created timestamp without time zone NOT NULL DEFAULT now(),
    CONSTRAINT spatial_plan_main_pkey PRIMARY KEY (id),
    CONSTRAINT spatial_plan_main_local_plan_id_key UNIQUE (local_plan_id),
    CONSTRAINT spatial_plan_main_ryhti_plan_id_key UNIQUE (ryhti_plan_id),
    CONSTRAINT spatial_plan_main_name_check CHECK (check_language_string(name)),
    CONSTRAINT plan_operator_spatial_plan_main_fkey FOREIGN KEY (fk_responsible)
        REFERENCES $SCHEMANAME$.planner (local_id) MATCH SIMPLE
        ON DELETE RESTRICT
        DEFERRABLE INITIALLY DEFERRED
);

-- Table: $SCHEMANAME$.spatial_plan

-- DROP TABLE IF EXISTS $SCHEMANAME$.spatial_plan;

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.spatial_plan
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    local_plan_id text NOT NULL DEFAULT (uuid_generate_v4())::text,
    geom geometry(MultiPolygon,$PROJECTSRID$) NOT NULL,
    storage_time timestamp without time zone,
    approval_time date,
    approved_by integer,
    epsg character(9) NOT NULL DEFAULT 'EPSG:$PROJECTSRID$'::bpchar,
    vertical_coordinate_system integer,
    land_administration_authority character(3) NOT NULL DEFAULT '$MUNICIPALITYCODE$'::bpchar,
    language integer NOT NULL,
    valid_from date,
    valid_to date,
    is_released boolean NOT NULL DEFAULT false,
    type character varying(3) NOT NULL,
    digital_origin character varying(3) NOT NULL,
    ground_relative_position character varying(3) NOT NULL,
    legal_effectiveness character varying(2) NOT NULL DEFAULT '01'::TEXT,
    validity_time daterange,
    lifecycle_status character varying(3) NOT NULL DEFAULT '01'::TEXT,
    name jsonb NOT NULL,
    local_id TEXT NOT NULL DEFAULT uuid_generate_v4(),
    latest_change timestamp without time zone NOT NULL DEFAULT now(),
    initiation_time date,
    created timestamp without time zone NOT NULL DEFAULT now(),
    created_by text NOT NULL,
    modified_by text NOT NULL,
    modified_at timestamp without time zone NOT NULL,
    is_active boolean NOT NULL DEFAULT true,
    version_name text NOT NULL,
    CONSTRAINT spatial_plan_pkey PRIMARY KEY (id),
    CONSTRAINT spatial_plan_local_id_key UNIQUE (local_id),
    CONSTRAINT fk_finnish_muncipality FOREIGN KEY (land_administration_authority)
        REFERENCES code_lists.finnish_municipalities (codevalue) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT spatial_plan_digital_origin_fkey FOREIGN KEY (digital_origin)
        REFERENCES code_lists.digital_origin_kind (codevalue) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE RESTRICT
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT spatial_plan_ground_relative_position_fkey FOREIGN KEY (ground_relative_position)
        REFERENCES code_lists.ground_relativeness_kind (codevalue) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE RESTRICT
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT spatial_plan_legal_effectiveness_fkey FOREIGN KEY (legal_effectiveness)
        REFERENCES code_lists.legal_effectiveness_kind (codevalue) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE RESTRICT
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT spatial_plan_lifecycle_status_fkey FOREIGN KEY (lifecycle_status)
        REFERENCES code_lists.spatial_plan_lifecycle_status (codevalue) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE RESTRICT
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT spatial_plan_main_local_plan_id_fk FOREIGN KEY (local_plan_id)
        REFERENCES $SCHEMANAME$.spatial_plan_main (local_plan_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE RESTRICT
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT spatial_plan_type_fkey FOREIGN KEY (type)
        REFERENCES code_lists.spatial_plan_kind (codevalue) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE RESTRICT
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT date_check CHECK (
CASE
    WHEN approval_time IS NULL AND valid_from IS NULL AND valid_to IS NULL THEN true
    WHEN approval_time IS NOT NULL AND valid_from IS NULL AND valid_to IS NULL THEN true
    WHEN approval_time <= valid_from AND valid_to IS NULL THEN true
    WHEN approval_time <= valid_from AND valid_from < valid_to THEN true
    ELSE false
END),
    CONSTRAINT epsg_check CHECK (epsg ~ '^EPSG:$PROJECTSRID$$'::text),
    CONSTRAINT land_administration_authority_check CHECK (land_administration_authority ~ '^[0-9]{3}$'::text),
    CONSTRAINT spatial_plan_approval_check CHECK (
CASE
    WHEN approval_time IS NULL AND approved_by IS NOT NULL THEN false
    WHEN approval_time IS NOT NULL AND approved_by IS NULL THEN false
    ELSE true
END),
    CONSTRAINT spatial_plan_name_check CHECK (check_language_string(name))
);

-- Table: $SCHEMANAME$.spatial_plan_planner

-- DROP TABLE IF EXISTS $SCHEMANAME$.spatial_plan_planner;

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.spatial_plan_planner
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    fk_spatial_plan text NOT NULL,
    fk_plan_operator text NOT NULL,
    CONSTRAINT spatial_plan_planner_pkey PRIMARY KEY (id),
    CONSTRAINT spatial_plan_planner_unique UNIQUE (fk_spatial_plan, fk_plan_operator),
    CONSTRAINT spatial_plan_plan_planner_fkey FOREIGN KEY (fk_spatial_plan)
        REFERENCES $SCHEMANAME$.spatial_plan (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT plan_operator_plan_planner_fkey FOREIGN KEY (fk_plan_operator)
        REFERENCES $SCHEMANAME$.planner (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED
);

-- Table: $SCHEMANAME$.localized_objective

-- DROP TABLE IF EXISTS $SCHEMANAME$.localized_objective;

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.localized_objective
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    objective text NOT NULL,
    fk_spatial_plan text NOT NULL,
    CONSTRAINT localized_objective_pkey PRIMARY KEY (id),
    CONSTRAINT spatial_plan_objective_fkey FOREIGN KEY (fk_spatial_plan)
        REFERENCES $SCHEMANAME$.spatial_plan (local_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT localized_objective_objective_check CHECK (objective <> ''::text)
);

-- Table: $SCHEMANAME$.numeric_double_value

-- DROP TABLE IF EXISTS $SCHEMANAME$.numeric_double_value;

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.numeric_double_value
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    numeric_double_value_uuid uuid NOT NULL DEFAULT uuid_generate_v4(),
    value double precision NOT NULL,
    unit_of_measure TEXT,
    obligatory boolean NOT NULL,
    CONSTRAINT numeric_double_value_pkey PRIMARY KEY (id),
    CONSTRAINT numeric_double_value_numeric_double_value_uuid_key UNIQUE (numeric_double_value_uuid)
);

-- Table: $SCHEMANAME$.numeric_range

-- DROP TABLE IF EXISTS $SCHEMANAME$.numeric_range;

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.numeric_range
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    numeric_range_uuid uuid NOT NULL DEFAULT uuid_generate_v4(),
    minimum_value double precision,
    maximum_value double precision,
    unit_of_measure TEXT,
    CONSTRAINT numeric_range_pkey PRIMARY KEY (id),
    CONSTRAINT numeric_range_numeric_range_uuid_key UNIQUE (numeric_range_uuid),
    CONSTRAINT numeric_range_value_check CHECK (minimum_value <= maximum_value)
)	;

-- Table: $SCHEMANAME$.numeric_value

-- DROP TABLE IF EXISTS $SCHEMANAME$.numeric_value;

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.numeric_value
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    numeric_value_id uuid NOT NULL DEFAULT uuid_generate_v4(),
    obligatory boolean NOT NULL,
    value double precision NOT NULL,
    value_type integer NOT NULL,
    target_type integer NOT NULL,
    localized_name TEXT,
    description_fi TEXT,
    description_se TEXT,
    CONSTRAINT numeric_value_pkey PRIMARY KEY (id),
    CONSTRAINT numeric_value_numeric_value_id_key UNIQUE (numeric_value_id)
)	;

-- Table: $SCHEMANAME$.participation_and_evalution_plan

-- DROP TABLE IF EXISTS $SCHEMANAME$.participation_and_evalution_plan;

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.participation_and_evalution_plan
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    local_id TEXT NOT NULL DEFAULT uuid_generate_v4(),
    latest_change timestamp without time zone NOT NULL DEFAULT now(),
    storage_time timestamp without time zone NOT NULL DEFAULT now(),
    spatial_plan TEXT NOT NULL,
    CONSTRAINT participation_and_evalution_plan_pkey PRIMARY KEY (id),
    CONSTRAINT participation_and_evalution_plan_local_id_key UNIQUE (local_id),
    CONSTRAINT participation_and_evalution_plan_spatial_plan_key UNIQUE (spatial_plan),
    CONSTRAINT participation_and_evalution_plan_fk_spatial_plan FOREIGN KEY (spatial_plan)
        REFERENCES $SCHEMANAME$.spatial_plan (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED
);

-- Table: $SCHEMANAME$.patricipation_evalution_plan_document

-- DROP TABLE IF EXISTS $SCHEMANAME$.patricipation_evalution_plan_document;

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.patricipation_evalution_plan_document
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    participation_and_evalution_plan_local_id TEXT NOT NULL,
    document_local_id TEXT NOT NULL,
    role jsonb,
    CONSTRAINT patricipation_evalution_plan_document_pkey PRIMARY KEY (id),
    CONSTRAINT patricipation_evalution_plan_document_fk_document FOREIGN KEY (document_local_id)
        REFERENCES $SCHEMANAME$.document (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT patricipation_evalution_plan_document_fk_participation_and_eval FOREIGN KEY (participation_and_evalution_plan_local_id)
        REFERENCES $SCHEMANAME$.participation_and_evalution_plan (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT patricipation_evalution_plan_document_role_check CHECK (check_language_string(role))
);

-- Table: $SCHEMANAME$.plan_guidance

-- DROP TABLE IF EXISTS $SCHEMANAME$.plan_guidance;

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.plan_guidance
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    local_id TEXT NOT NULL DEFAULT uuid_generate_v4(),
    latest_change timestamp without time zone NOT NULL DEFAULT now(),
    storage_time timestamp without time zone,
    name jsonb,
    life_cycle_status TEXT NOT NULL,
    validity_time daterange,
    valid_from date,
    valid_to date,
    created timestamp without time zone NOT NULL DEFAULT now(),
    created_by text NOT NULL,
    modified_by text NOT NULL,
    modified_at timestamp without time zone NOT NULL,
    CONSTRAINT plan_guidance_pkey PRIMARY KEY (id),
    CONSTRAINT plan_guidance_local_id_key UNIQUE (local_id),
    CONSTRAINT plan_guidance_fk_life_cycle_status FOREIGN KEY (life_cycle_status)
        REFERENCES code_lists.spatial_plan_lifecycle_status (codevalue) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT plan_guidance_name_check CHECK (check_ryhti_language(name))
);

-- Table: $SCHEMANAME$.plan_guidance_document

-- DROP TABLE IF EXISTS $SCHEMANAME$.plan_guidance_document;

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.plan_guidance_document
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    plan_guidance_local_id TEXT NOT NULL,
    document_local_id TEXT NOT NULL,
    role jsonb,
    CONSTRAINT plan_guidance_document_pkey PRIMARY KEY (id),
    CONSTRAINT plan_guidance_document_plan_guidance_local_id_document_loca_key UNIQUE (plan_guidance_local_id, document_local_id),
    CONSTRAINT plan_guidance_document_fk_document FOREIGN KEY (document_local_id)
        REFERENCES $SCHEMANAME$.document (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT plan_guidance_document_fk_plan_guidance FOREIGN KEY (plan_guidance_local_id)
        REFERENCES $SCHEMANAME$.plan_guidance (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT plan_guidance_document_role_check CHECK (check_language_string(role))
);

-- Table: $SCHEMANAME$.plan_guidance_theme

-- DROP TABLE IF EXISTS $SCHEMANAME$.plan_guidance_theme;

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.plan_guidance_theme
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    plan_guidance_local_id TEXT NOT NULL,
    theme_code TEXT NOT NULL,
    CONSTRAINT plan_guidance_theme_pkey PRIMARY KEY (id),
    CONSTRAINT plan_guidance_theme_plan_guidance_local_id_theme_code_key UNIQUE (plan_guidance_local_id, theme_code),
    CONSTRAINT plan_guidance_theme_fk_plan_guidance FOREIGN KEY (plan_guidance_local_id)
        REFERENCES $SCHEMANAME$.plan_guidance (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT plan_guidance_theme_fk_theme FOREIGN KEY (theme_code)
        REFERENCES code_lists.detail_plan_theme (codevalue) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE NO ACTION
        DEFERRABLE INITIALLY DEFERRED
);

-- Table: $SCHEMANAME$.plan_regulation

-- DROP TABLE IF EXISTS $SCHEMANAME$.plan_regulation;

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.plan_regulation
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    local_id TEXT NOT NULL DEFAULT uuid_generate_v4(),
    latest_change timestamp without time zone NOT NULL DEFAULT now(),
    storage_time timestamp without time zone,
    name jsonb,
    type TEXT NOT NULL,
    life_cycle_status TEXT NOT NULL,
    validity_time daterange,
    valid_from date,
    valid_to date,
    created timestamp without time zone NOT NULL DEFAULT now(),
    created_by text NOT NULL,
    modified_by text NOT NULL,
    modified_at timestamp without time zone NOT NULL,
    CONSTRAINT plan_regulation_pkey PRIMARY KEY (id),
    CONSTRAINT plan_regulation_local_id_key UNIQUE (local_id),
    CONSTRAINT plan_regulation_fk_life_cycle_status FOREIGN KEY (life_cycle_status)
        REFERENCES code_lists.spatial_plan_lifecycle_status (codevalue) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE NO ACTION
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT plan_regulation_fk_type FOREIGN KEY (type)
        REFERENCES code_lists.detail_plan_regulation_kind (codevalue) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE NO ACTION
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT plan_regulation_name_check CHECK (check_language_string(name))
);

-- Table: $SCHEMANAME$.plan_regulation_document

-- DROP TABLE IF EXISTS $SCHEMANAME$.plan_regulation_document;

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.plan_regulation_document
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    plan_regulation_local_id TEXT NOT NULL,
    document_local_id TEXT NOT NULL,
    role jsonb,
    CONSTRAINT plan_regulation_document_pkey PRIMARY KEY (id),
    CONSTRAINT plan_regulation_document_plan_regulation_local_id_document__key UNIQUE (plan_regulation_local_id, document_local_id),
    CONSTRAINT plan_regulation_document_fk_document FOREIGN KEY (document_local_id)
        REFERENCES $SCHEMANAME$.document (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT plan_regulation_document_fk_plan_regulation FOREIGN KEY (plan_regulation_local_id)
        REFERENCES $SCHEMANAME$.plan_regulation (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT plan_regulation_document_role_check CHECK (check_language_string(role))
);

-- Table: $SCHEMANAME$.plan_regulation_group

-- DROP TABLE IF EXISTS $SCHEMANAME$.plan_regulation_group;

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.plan_regulation_group
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    local_id TEXT NOT NULL DEFAULT uuid_generate_v4(),
    latest_change timestamp without time zone NOT NULL DEFAULT now(),
    storage_time timestamp without time zone NOT NULL DEFAULT now(),
    name jsonb,
    group_number integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    CONSTRAINT plan_regulation_group_pkey PRIMARY KEY (id),
    CONSTRAINT plan_regulation_group_local_id_key UNIQUE (local_id),
    CONSTRAINT plan_regulation_group_name_check CHECK (check_language_string(name))
);

-- Table: $SCHEMANAME$.plan_regulation_group_regulation

-- DROP TABLE IF EXISTS $SCHEMANAME$.plan_regulation_group_regulation;

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.plan_regulation_group_regulation
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    plan_regulation_group_local_id TEXT NOT NULL,
    plan_regulation_local_id TEXT NOT NULL,
    CONSTRAINT plan_regulation_group_regulation_pkey PRIMARY KEY (id),
    CONSTRAINT plan_regulation_group_regulat_plan_regulation_group_local_id_key UNIQUE (plan_regulation_group_local_id, plan_regulation_local_id),
    CONSTRAINT plan_regulation_group_regulation_fk_plan_regulation FOREIGN KEY (plan_regulation_local_id)
        REFERENCES $SCHEMANAME$.plan_regulation (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT plan_regulation_group_regulation_fk_plan_regulation_group FOREIGN KEY (plan_regulation_group_local_id)
        REFERENCES $SCHEMANAME$.plan_regulation_group (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED
);

-- Table: $SCHEMANAME$.supplementary_information

-- DROP TABLE IF EXISTS $SCHEMANAME$.supplementary_information;

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.supplementary_information
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    local_id text NOT NULL DEFAULT (uuid_generate_v4())::text,
    type TEXT NOT NULL,
    name jsonb,
    fk_plan_regulation TEXT NOT NULL,
    CONSTRAINT supplementary_information_pkey PRIMARY KEY (id),
    CONSTRAINT supplementary_information_local_id_key UNIQUE (local_id),
    CONSTRAINT supplementary_information_fk_plan_regulation FOREIGN KEY (fk_plan_regulation)
        REFERENCES $SCHEMANAME$.plan_regulation (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT supplementary_information_fk_type FOREIGN KEY (type)
        REFERENCES code_lists.detail_plan_addition_information_kind (codevalue) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE NO ACTION,
    CONSTRAINT supplementary_information_name_check CHECK (check_language_string(name))
);

-- Table: $SCHEMANAME$.plan_regulation_supplementary_information

-- DROP TABLE IF EXISTS $SCHEMANAME$.plan_regulation_supplementary_information;

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.plan_regulation_supplementary_information
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    fk_plan_regulation TEXT NOT NULL,
    fk_supplementary_information text NOT NULL,
    CONSTRAINT plan_regulation_supplementary_information_pkey PRIMARY KEY (id),
    CONSTRAINT plan_regulation_supplementary_fk_plan_regulation_fk_supplem_key UNIQUE (fk_plan_regulation, fk_supplementary_information),
    CONSTRAINT fk_plan_regulation FOREIGN KEY (fk_plan_regulation)
        REFERENCES $SCHEMANAME$.plan_regulation (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT fk_supplementary_information FOREIGN KEY (fk_supplementary_information)
        REFERENCES $SCHEMANAME$.supplementary_information (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED
);

-- Table: $SCHEMANAME$.plan_regulation_theme

-- DROP TABLE IF EXISTS $SCHEMANAME$.plan_regulation_theme;

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.plan_regulation_theme
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    plan_regulation_local_id TEXT NOT NULL,
    theme_code TEXT NOT NULL,
    CONSTRAINT plan_regulation_theme_pkey PRIMARY KEY (id),
    CONSTRAINT plan_regulation_theme_plan_regulation_local_id_theme_code_key UNIQUE (plan_regulation_local_id, theme_code),
    CONSTRAINT plan_regulation_theme_fk_plan_regulation FOREIGN KEY (plan_regulation_local_id)
        REFERENCES $SCHEMANAME$.plan_regulation (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT plan_regulation_theme_fk_theme FOREIGN KEY (theme_code)
        REFERENCES code_lists.detail_plan_theme (codevalue) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE NO ACTION
        DEFERRABLE INITIALLY DEFERRED
);

-- Table: $SCHEMANAME$.planned_space

-- DROP TABLE IF EXISTS $SCHEMANAME$.planned_space;

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.planned_space
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    geom geometry(MultiPolygon,$PROJECTSRID$) NOT NULL,
    storage_time timestamp without time zone,
    valid_from date,
    valid_to date,
    bindingness_of_location character varying(3) NOT NULL,
    ground_relative_position character varying(3) NOT NULL,
    local_id TEXT NOT NULL DEFAULT uuid_generate_v4(),
    latest_change timestamp without time zone NOT NULL DEFAULT now(),
    validity_time daterange,
    created timestamp without time zone NOT NULL DEFAULT now(),
    created_by text NOT NULL,
    modified_by text NOT NULL,
    modified_at timestamp without time zone NOT NULL,
    lifecycle_status character varying(3) NOT NULL DEFAULT '01'::TEXT,
    is_active boolean DEFAULT true,
    CONSTRAINT planned_space_pkey PRIMARY KEY (id),
    CONSTRAINT planned_space_local_id_key UNIQUE (local_id),
    CONSTRAINT planned_space_bindingness_of_location_fkey FOREIGN KEY (bindingness_of_location)
        REFERENCES code_lists.bindingness_kind (codevalue) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE RESTRICT
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT planned_space_ground_relative_position_fkey FOREIGN KEY (ground_relative_position)
        REFERENCES code_lists.ground_relativeness_kind (codevalue) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE RESTRICT
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT planned_space_lifecycle_status_fkey FOREIGN KEY (lifecycle_status)
        REFERENCES code_lists.spatial_plan_lifecycle_status (codevalue) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT planned_space_date_check CHECK (
CASE
    WHEN valid_from IS NOT NULL AND valid_to IS NULL THEN true
    WHEN valid_from IS NOT NULL AND valid_to > valid_from THEN true
    WHEN valid_from IS NULL AND valid_to IS NULL THEN true
    ELSE false
END)
);

-- Table: $SCHEMANAME$.planned_space_numeric_value

-- DROP TABLE IF EXISTS $SCHEMANAME$.planned_space_numeric_value;

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.planned_space_numeric_value
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    planned_space_id text NOT NULL,
    numeric_id uuid NOT NULL,
    CONSTRAINT planned_space_numeric_value_pkey PRIMARY KEY (id),
    CONSTRAINT planned_space_numeric_value_key UNIQUE (planned_space_id, numeric_id),
    CONSTRAINT numeric_value_planned_space_fk FOREIGN KEY (numeric_id)
        REFERENCES $SCHEMANAME$.numeric_value (numeric_value_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT planned_space_numeric_value_fk FOREIGN KEY (planned_space_id)
        REFERENCES $SCHEMANAME$.planned_space (local_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED
);

-- Table: $SCHEMANAME$.planning_detail_line

-- DROP TABLE IF EXISTS $SCHEMANAME$.planning_detail_line;

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.planning_detail_line
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    storage_time timestamp without time zone,
    geom geometry(MultiLineString,$PROJECTSRID$) NOT NULL,
    local_id TEXT NOT NULL DEFAULT uuid_generate_v4(),
    latest_change timestamp without time zone NOT NULL DEFAULT now(),
    created timestamp without time zone NOT NULL DEFAULT now(),
    created_by text NOT NULL,
    modified_by text NOT NULL,
    modified_at timestamp without time zone NOT NULL,
    bindingness_of_location character varying(2) NOT NULL,
    ground_relative_position character varying(2) NOT NULL,
    lifecycle_status character varying(3) NOT NULL DEFAULT '01'::TEXT,
    name jsonb,
    is_active boolean DEFAULT true,
    CONSTRAINT planning_detail_line_pkey PRIMARY KEY (id),
    CONSTRAINT planning_detail_line_local_id_key UNIQUE (local_id),
    CONSTRAINT planning_detail_line_bindingness_of_location_fk FOREIGN KEY (bindingness_of_location)
        REFERENCES code_lists.bindingness_kind (codevalue) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT planning_detail_line_ground_relative_position_fk FOREIGN KEY (ground_relative_position)
        REFERENCES code_lists.ground_relativeness_kind (codevalue) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT planning_detail_line_lifecycle_status_fkey FOREIGN KEY (lifecycle_status)
        REFERENCES code_lists.spatial_plan_lifecycle_status (codevalue) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT planning_detail_line_name_check CHECK (check_language_string(name))
);


-- Table: $SCHEMANAME$.planned_space_plan_detail_line

-- DROP TABLE IF EXISTS $SCHEMANAME$.planned_space_plan_detail_line;

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.planned_space_plan_detail_line
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    planned_space_local_id TEXT NOT NULL,
    planning_detail_line_local_id TEXT NOT NULL,
    CONSTRAINT planned_space_detail_line_pkey PRIMARY KEY (id),
    CONSTRAINT planned_space_plan_detail_line_fk_planned_space FOREIGN KEY (planned_space_local_id)
        REFERENCES $SCHEMANAME$.planned_space (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT planned_space_plan_detail_line_fk_planning_detail_line FOREIGN KEY (planning_detail_line_local_id)
        REFERENCES $SCHEMANAME$.planning_detail_line (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED
);

-- Table: $SCHEMANAME$.planned_space_plan_regulation_group

-- DROP TABLE IF EXISTS $SCHEMANAME$.planned_space_plan_regulation_group;

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.planned_space_plan_regulation_group
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    planned_space_local_id TEXT NOT NULL,
    plan_regulation_group_local_id TEXT NOT NULL,
    CONSTRAINT planned_space_plan_regulation_group_pkey PRIMARY KEY (id),
    CONSTRAINT planned_space_plan_regulation_planned_space_local_id_plan_r_key UNIQUE (planned_space_local_id, plan_regulation_group_local_id),
    CONSTRAINT planned_space_plan_regulation_group_fk_plan_regulation_group FOREIGN KEY (plan_regulation_group_local_id)
        REFERENCES $SCHEMANAME$.plan_regulation_group (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT planned_space_plan_regulation_group_fk_planned_space FOREIGN KEY (planned_space_local_id)
        REFERENCES $SCHEMANAME$.planned_space (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED
);

-- Table: $SCHEMANAME$.regulative_text

-- DROP TABLE IF EXISTS $SCHEMANAME$.regulative_text;

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.regulative_text
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    regulative_id uuid NOT NULL DEFAULT uuid_generate_v4(),
    type integer NOT NULL,
    description_fi TEXT,
    description_se TEXT,
    validity integer NOT NULL DEFAULT 1,
    CONSTRAINT regulative_text_pkey PRIMARY KEY (id),
    CONSTRAINT regulative_text_regulative_id_key UNIQUE (regulative_id)
);

-- Table: $SCHEMANAME$.planned_space_regulation

-- DROP TABLE IF EXISTS $SCHEMANAME$.planned_space_regulation;

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.planned_space_regulation
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    planned_space_id text NOT NULL,
    regulative_id uuid NOT NULL,
    CONSTRAINT planned_space_regulation_pkey PRIMARY KEY (id),
    CONSTRAINT planned_space_regulation_key UNIQUE (planned_space_id, regulative_id),
    CONSTRAINT planned_space_regulation_fkey FOREIGN KEY (planned_space_id)
        REFERENCES $SCHEMANAME$.planned_space (local_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT regulative_id_planned_space_fkey FOREIGN KEY (regulative_id)
        REFERENCES $SCHEMANAME$.regulative_text (regulative_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED
);

-- Table: $SCHEMANAME$.planning_detail_line_numeric_value

-- DROP TABLE IF EXISTS $SCHEMANAME$.planning_detail_line_numeric_value;

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.planning_detail_line_numeric_value
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    planning_detail_line_id text NOT NULL,
    numeric_id uuid NOT NULL,
    CONSTRAINT planning_detail_line_numeric_value_pkey PRIMARY KEY (id),
    CONSTRAINT planning_detail_line_numeric_value_key UNIQUE (planning_detail_line_id, numeric_id),
    CONSTRAINT numeric_value_planning_detail_line_fk FOREIGN KEY (numeric_id)
        REFERENCES $SCHEMANAME$.numeric_value (numeric_value_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT planning_detail_line_value_fk FOREIGN KEY (planning_detail_line_id)
        REFERENCES $SCHEMANAME$.planning_detail_line (local_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED
);

-- Table: $SCHEMANAME$.planning_detail_line_plan_regulation_group

-- DROP TABLE IF EXISTS $SCHEMANAME$.planning_detail_line_plan_regulation_group;

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.planning_detail_line_plan_regulation_group
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    planning_detail_line_local_id TEXT NOT NULL,
    plan_regulation_group_local_id TEXT NOT NULL,
    CONSTRAINT planning_detail_line_plan_regulation_group_pkey PRIMARY KEY (id),
    CONSTRAINT planning_detail_line_plan_reg_planning_detail_line_local_id_key UNIQUE (planning_detail_line_local_id, plan_regulation_group_local_id),
    CONSTRAINT planning_detail_line_plan_regulation_group_fk_plan_regulation_g FOREIGN KEY (plan_regulation_group_local_id)
        REFERENCES $SCHEMANAME$.plan_regulation_group (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT planning_detail_line_plan_regulation_group_fk_planning_detail_l FOREIGN KEY (planning_detail_line_local_id)
        REFERENCES $SCHEMANAME$.planning_detail_line (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED
);

-- Table: $SCHEMANAME$.planning_detail_point_numeric_value

-- DROP TABLE IF EXISTS $SCHEMANAME$.planning_detail_point_numeric_value;

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.planning_detail_point_numeric_value
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    planning_detail_point_id uuid NOT NULL,
    numeric_id uuid NOT NULL,
    CONSTRAINT planning_detail_point_numeric_value_pkey PRIMARY KEY (id),
    CONSTRAINT planning_detail_point_numeric_value_key UNIQUE (planning_detail_point_id, numeric_id),
    CONSTRAINT numeric_value_planning_detail_point_fk FOREIGN KEY (numeric_id)
        REFERENCES $SCHEMANAME$.numeric_value (numeric_value_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED
);

-- Table: $SCHEMANAME$.referenced_document

-- DROP TABLE IF EXISTS $SCHEMANAME$.referenced_document;

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.referenced_document
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    reference TEXT NOT NULL,
    referenced_on date NOT NULL,
    name TEXT NOT NULL,
    fk_spatial_plan text NOT NULL,
    language integer NOT NULL,
    role integer NOT NULL,
    type integer NOT NULL,
    CONSTRAINT referenced_document_pkey PRIMARY KEY (id),
    CONSTRAINT spatial_plan_document_fkey FOREIGN KEY (fk_spatial_plan)
        REFERENCES $SCHEMANAME$.spatial_plan (local_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED
);


-- Table: $SCHEMANAME$.spatial_plan_commentary

-- DROP TABLE IF EXISTS $SCHEMANAME$.spatial_plan_commentary;

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.spatial_plan_commentary
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    local_id TEXT NOT NULL DEFAULT uuid_generate_v4(),
    latest_change timestamp without time zone NOT NULL DEFAULT now(),
    storage_time timestamp without time zone NOT NULL DEFAULT now(),
    spatial_plan TEXT NOT NULL,
    CONSTRAINT spatial_plan_commentary_pkey PRIMARY KEY (id),
    CONSTRAINT spatial_plan_commentary_local_id_key UNIQUE (local_id),
    CONSTRAINT spatial_plan_commentary_spatial_plan_key UNIQUE (spatial_plan),
    CONSTRAINT spatial_plan_commentary_fk_spatial_plan FOREIGN KEY (spatial_plan)
        REFERENCES $SCHEMANAME$.spatial_plan (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED
);

-- Table: $SCHEMANAME$.spatial_plan_commentary_document

-- DROP TABLE IF EXISTS $SCHEMANAME$.spatial_plan_commentary_document;

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.spatial_plan_commentary_document
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    spatial_plan_commentary_local_id TEXT NOT NULL,
    document_local_id TEXT NOT NULL,
    role jsonb,
    CONSTRAINT spatial_plan_commentary_document_pkey PRIMARY KEY (id),
    CONSTRAINT spatial_plan_commentary_document_fk_document FOREIGN KEY (document_local_id)
        REFERENCES $SCHEMANAME$.document (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT spatial_plan_commentary_document_fk_spatial_plan_commentary FOREIGN KEY (spatial_plan_commentary_local_id)
        REFERENCES $SCHEMANAME$.spatial_plan_commentary (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT spatial_plan_commentary_document_role_check CHECK (check_language_string(role))
);

-- Table: $SCHEMANAME$.spatial_plan_document

-- DROP TABLE IF EXISTS $SCHEMANAME$.spatial_plan_document;

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.spatial_plan_document
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    spatial_plan_local_id TEXT NOT NULL,
    document_local_id TEXT NOT NULL,
    role jsonb,
    CONSTRAINT spatial_plan_document_pkey PRIMARY KEY (id),
    CONSTRAINT fk_document FOREIGN KEY (document_local_id)
        REFERENCES $SCHEMANAME$.document (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT fk_spatial_plan FOREIGN KEY (spatial_plan_local_id)
        REFERENCES $SCHEMANAME$.spatial_plan (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT spatial_plan_document_role_check CHECK (check_language_string(role))
);


-- Table: $SCHEMANAME$.spatial_plan_regulation

-- DROP TABLE IF EXISTS $SCHEMANAME$.spatial_plan_regulation;

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.spatial_plan_regulation
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    spatial_plan_id text NOT NULL,
    regulative_id uuid NOT NULL,
    CONSTRAINT spatial_plan_regulation_pkey PRIMARY KEY (id),
    CONSTRAINT spatial_plan_regulation_key UNIQUE (spatial_plan_id, regulative_id),
    CONSTRAINT regulative_id_spatial_plan_fkey FOREIGN KEY (regulative_id)
        REFERENCES $SCHEMANAME$.regulative_text (regulative_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT spatial_plan_regulation_fkey FOREIGN KEY (spatial_plan_id)
        REFERENCES $SCHEMANAME$.spatial_plan (local_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED
);



-- Table: $SCHEMANAME$.text_value

-- DROP TABLE IF EXISTS $SCHEMANAME$.text_value;

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.text_value
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    text_value_uuid uuid NOT NULL DEFAULT uuid_generate_v4(),
    value jsonb NOT NULL,
    syntax TEXT,
    CONSTRAINT text_value_pkey PRIMARY KEY (id),
    CONSTRAINT text_value_text_value_uuid_key UNIQUE (text_value_uuid),
    CONSTRAINT text_value_value_check CHECK (check_language_string(value))
);

-- Table: $SCHEMANAME$.time_instant_value

-- DROP TABLE IF EXISTS $SCHEMANAME$.time_instant_value;

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.time_instant_value
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    time_instant_uuid uuid NOT NULL DEFAULT uuid_generate_v4(),
    value timestamp without time zone NOT NULL,
    CONSTRAINT time_instant_value_pkey PRIMARY KEY (id),
    CONSTRAINT time_instant_value_time_instant_uuid_key UNIQUE (time_instant_uuid)
);

-- Table: $SCHEMANAME$.time_period_value

-- DROP TABLE IF EXISTS $SCHEMANAME$.time_period_value;

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.time_period_value
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    time_period_uuid uuid NOT NULL DEFAULT uuid_generate_v4(),
    value tsrange NOT NULL,
    time_period_from timestamp without time zone,
    time_period_to timestamp without time zone,
    CONSTRAINT time_period_value_pkey PRIMARY KEY (id),
    CONSTRAINT time_period_value_time_period_uuid_key UNIQUE (time_period_uuid)
);

-- Table: $SCHEMANAME$.versions

-- DROP TABLE IF EXISTS $SCHEMANAME$.versions;

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.versions
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9999 CACHE 1 ),
    scriptname TEXT NOT NULL,
    applied timestamp(6) without time zone NOT NULL DEFAULT now(),
    CONSTRAINT versions_pkey PRIMARY KEY (id),
    CONSTRAINT versions_scriptname_key UNIQUE (scriptname)
);

-- FUNCTION: $SCHEMANAME$.validate_zoning_element_validity_dates(date, date, TEXT)

-- DROP FUNCTION IF EXISTS $SCHEMANAME$.validate_zoning_element_validity_dates(date, date, TEXT);

CREATE OR REPLACE FUNCTION $SCHEMANAME$.validate_zoning_element_validity_dates(
	valid_from date,
	valid_to date,
	spatial_plan TEXT)
    RETURNS boolean
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
  sp_valid_from DATE;
  sp_valid_to DATE;
  is_valid BOOLEAN := TRUE;
BEGIN
  SELECT sp.valid_from, sp.valid_to
  INTO sp_valid_from, sp_valid_to
  FROM $SCHEMANAME$.spatial_plan sp
  WHERE sp.local_id = spatial_plan;

  IF valid_from IS NOT NULL AND valid_to IS NOT NULL AND valid_from > valid_to THEN
    is_valid := FALSE;
  ELSIF valid_from IS NOT NULL AND sp_valid_from IS NOT NULL AND valid_from < sp_valid_from THEN
    is_valid := FALSE;
  ELSIF valid_to IS NOT NULL AND sp_valid_to IS NOT NULL AND valid_to > sp_valid_to THEN
    is_valid := FALSE;
  END IF;

  RETURN is_valid;
END;
$BODY$;

-- Table: $SCHEMANAME$.zoning_element

-- DROP TABLE IF EXISTS $SCHEMANAME$.zoning_element;

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.zoning_element
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    geom geometry(MultiPolygon,$PROJECTSRID$) NOT NULL,
    storage_time timestamp without time zone,
    localized_name TEXT NOT NULL,
    name jsonb,
    type integer NOT NULL,
    up_to_dateness integer NOT NULL,
    valid_from date,
    valid_to date,
    block_number TEXT,
    parcel_number TEXT,
    bindingness_of_location character varying(3) NOT NULL DEFAULT '01'::TEXT,
    ground_relative_position character varying(3) NOT NULL,
    land_use_kind character varying(6) NOT NULL,
    local_id TEXT NOT NULL DEFAULT uuid_generate_v4(),
    latest_change timestamp without time zone NOT NULL DEFAULT now(),
    spatial_plan TEXT,
    validity_time daterange,
    created timestamp without time zone NOT NULL DEFAULT now(),
    created_by text NOT NULL,
    modified_by text NOT NULL,
    modified_at timestamp without time zone NOT NULL,
    lifecycle_status character varying(3) NOT NULL DEFAULT '01'::TEXT,
    is_active boolean DEFAULT true,
    CONSTRAINT zoning_element_pkey PRIMARY KEY (id),
    CONSTRAINT zoning_element_local_id_key UNIQUE (local_id),
    CONSTRAINT zoning_element_fk_bindingness_of_location FOREIGN KEY (bindingness_of_location)
        REFERENCES code_lists.bindingness_kind (codevalue) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE RESTRICT
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT zoning_element_fk_ground_relative_position FOREIGN KEY (ground_relative_position)
        REFERENCES code_lists.ground_relativeness_kind (codevalue) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE RESTRICT
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT zoning_element_fk_land_use_kind FOREIGN KEY (land_use_kind)
        REFERENCES code_lists.detail_plan_regulation_kind (codevalue) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE RESTRICT
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT zoning_element_fk_spatial_plan FOREIGN KEY (spatial_plan)
        REFERENCES $SCHEMANAME$.spatial_plan (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT zoning_element_lifecycle_status_fkey FOREIGN KEY (lifecycle_status)
        REFERENCES code_lists.spatial_plan_lifecycle_status (codevalue) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT check_language_string CHECK (check_language_string(name)),
    CONSTRAINT validate_validity_dates CHECK ($SCHEMANAME$.validate_zoning_element_validity_dates(valid_from, valid_to, spatial_plan)),
    CONSTRAINT zoning_date_check CHECK (
CASE
    WHEN valid_from IS NOT NULL AND valid_to IS NULL THEN true
    WHEN valid_from IS NOT NULL AND valid_to > valid_from THEN true
    WHEN valid_from IS NULL AND valid_to IS NULL THEN true
    ELSE false
END),
    CONSTRAINT zoning_element_land_use_kind_check CHECK (land_use_kind::text ~~ '01%'::text)
);

-- Table: $SCHEMANAME$.zoning_element_describing_line

-- DROP TABLE IF EXISTS $SCHEMANAME$.zoning_element_describing_line;

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.zoning_element_describing_line
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    describing_line_id integer NOT NULL,
    zoning_element_local_id TEXT,
    CONSTRAINT zoning_element_describing_line_pkey PRIMARY KEY (id),
    CONSTRAINT zoning_element_describing_line_fk_describing_line FOREIGN KEY (describing_line_id)
        REFERENCES $SCHEMANAME$.describing_line (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT zoning_element_describing_line_fk_zoning_element FOREIGN KEY (zoning_element_local_id)
        REFERENCES $SCHEMANAME$.zoning_element (local_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
);

-- Table: $SCHEMANAME$.zoning_element_describing_text

-- DROP TABLE IF EXISTS $SCHEMANAME$.zoning_element_describing_text;

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.zoning_element_describing_text
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    describing_text_id integer NOT NULL,
    zoning_element_local_id TEXT,
    CONSTRAINT zoning_element_describing_text_pkey PRIMARY KEY (id),
    CONSTRAINT zoning_element_describing_text_fk_describing_text FOREIGN KEY (describing_text_id)
        REFERENCES $SCHEMANAME$.describing_text (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT zoning_element_describing_text_fk_zoning_element FOREIGN KEY (zoning_element_local_id)
        REFERENCES $SCHEMANAME$.zoning_element (local_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
);

-- Table: $SCHEMANAME$.zoning_element_numeric_value

-- DROP TABLE IF EXISTS $SCHEMANAME$.zoning_element_numeric_value;

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.zoning_element_numeric_value
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    zoning_id text NOT NULL,
    numeric_id uuid NOT NULL,
    CONSTRAINT zoning_element_numeric_value_pkey PRIMARY KEY (id),
    CONSTRAINT zoning_element_numeric_value_key UNIQUE (zoning_id, numeric_id),
    CONSTRAINT numeric_value_zoning_element_fk FOREIGN KEY (numeric_id)
        REFERENCES $SCHEMANAME$.numeric_value (numeric_value_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT zoning_element_numeric_value_fk FOREIGN KEY (zoning_id)
        REFERENCES $SCHEMANAME$.zoning_element (local_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED
);

-- Table: $SCHEMANAME$.zoning_element_plan_detail_line

-- DROP TABLE IF EXISTS $SCHEMANAME$.zoning_element_plan_detail_line;

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.zoning_element_plan_detail_line
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    zoning_element_local_id TEXT NOT NULL,
    planning_detail_line_local_id TEXT NOT NULL,
    CONSTRAINT zoning_element_plan_detail_line_pkey PRIMARY KEY (id),
    CONSTRAINT zoning_element_plan_detail_line_fk_planning_detail_line FOREIGN KEY (planning_detail_line_local_id)
        REFERENCES $SCHEMANAME$.planning_detail_line (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT zoning_element_plan_detail_line_fk_zoning_element FOREIGN KEY (zoning_element_local_id)
        REFERENCES $SCHEMANAME$.zoning_element (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED
);

-- Table: $SCHEMANAME$.zoning_element_plan_regulation_group

-- DROP TABLE IF EXISTS $SCHEMANAME$.zoning_element_plan_regulation_group;

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.zoning_element_plan_regulation_group
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    zoning_element_local_id TEXT NOT NULL,
    plan_regulation_group_local_id TEXT NOT NULL,
    CONSTRAINT zoning_element_plan_regulation_group_pkey PRIMARY KEY (id),
    CONSTRAINT zoning_element_plan_regulatio_zoning_element_local_id_plan__key UNIQUE (zoning_element_local_id, plan_regulation_group_local_id),
    CONSTRAINT zoning_element_plan_regulation_group_fk_plan_regulation_group FOREIGN KEY (plan_regulation_group_local_id)
        REFERENCES $SCHEMANAME$.plan_regulation_group (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT zoning_element_plan_regulation_group_fk_zoning_element FOREIGN KEY (zoning_element_local_id)
        REFERENCES $SCHEMANAME$.zoning_element (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED
);

-- Table: $SCHEMANAME$.zoning_element_planned_space

-- DROP TABLE IF EXISTS $SCHEMANAME$.zoning_element_planned_space;

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.zoning_element_planned_space
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    zoning_element_local_id TEXT NOT NULL,
    planned_space_local_id TEXT NOT NULL,
    CONSTRAINT zoning_element_planned_space_pkey PRIMARY KEY (id),
    CONSTRAINT zoning_element_planned_space_fk_planned_space FOREIGN KEY (planned_space_local_id)
        REFERENCES $SCHEMANAME$.planned_space (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT zoning_element_planned_space_fk_zoning_element FOREIGN KEY (zoning_element_local_id)
        REFERENCES $SCHEMANAME$.zoning_element (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED
);

-- Table: $SCHEMANAME$.zoning_element_regulation

-- DROP TABLE IF EXISTS $SCHEMANAME$.zoning_element_regulation;

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.zoning_element_regulation
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    zoning_element_id text NOT NULL,
    regulative_id uuid NOT NULL,
    CONSTRAINT zoning_element_regulation_pkey PRIMARY KEY (id),
    CONSTRAINT zoning_element_regulation_key UNIQUE (zoning_element_id, regulative_id),
    CONSTRAINT regulative_id_zoning_fkey FOREIGN KEY (regulative_id)
        REFERENCES $SCHEMANAME$.regulative_text (regulative_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT zoning_element_regulation_fkey FOREIGN KEY (zoning_element_id)
        REFERENCES $SCHEMANAME$.zoning_element (local_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED
);

-- END OF LOCAL PLAN TABLES
-- $SCHEMANAME$, $PROJECTSRID$, $MUNICIPALITYCODE$
