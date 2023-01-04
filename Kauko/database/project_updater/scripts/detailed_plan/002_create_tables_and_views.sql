/*
 Used to create tables
 */

-- Table: SCHEMANAME.spatial_plan
CREATE TABLE "SCHEMANAME".spatial_plan
(
    identifier integer NOT NULL DEFAULT nextval('"SCHEMANAME".spatial_plan_identifier_seq'::regclass),
    planning_object_identifier uuid NOT NULL DEFAULT uuid_generate_v4(),
    geom geometry(MultiPolygon,PROJECTSRID) NOT NULL,
    created timestamp without time zone NOT NULL DEFAULT now(),
    name character varying COLLATE pg_catalog."default" NOT NULL,
    alternative_name character varying COLLATE pg_catalog."default",
    plan_id character varying COLLATE pg_catalog."default",
    approval_date date,
    approved_by integer,
    epsg character(9) COLLATE pg_catalog."default" NOT NULL DEFAULT 'EPSG:PROJECTSRID'::bpchar,
    vertical_coordinate_system integer,
    land_administration_authority character(3) COLLATE pg_catalog."default" NOT NULL DEFAULT 'MUNICIPALITYCODE'::bpchar,
    language integer NOT NULL,
    origin integer NOT NULL,
    planning_level integer NOT NULL,
    status integer NOT NULL,
    plan_type integer NOT NULL,
    valid_from date,
    valid_to date,
    validity integer NOT NULL DEFAULT 4,
    CONSTRAINT spatial_plan_pkey PRIMARY KEY (identifier),
    CONSTRAINT spatial_plan_alternative_name_unique UNIQUE (alternative_name),
    CONSTRAINT spatial_plan_name_unique UNIQUE (name),
    CONSTRAINT spatial_plan_planning_object_identifier_key UNIQUE (planning_object_identifier),
    CONSTRAINT epsg_check CHECK (epsg ~ '^EPSG:PROJECTSRID$'::text),
    CONSTRAINT land_administration_authority_check CHECK (land_administration_authority ~ '^[0-9]{3}$'::text),
    CONSTRAINT spatial_plan_approval_check CHECK (
CASE
    WHEN approval_date IS NULL AND approved_by IS NOT NULL THEN false
    WHEN approval_date IS NOT NULL AND approved_by IS NULL THEN false
    ELSE true
END),
    CONSTRAINT date_check CHECK (
CASE
    WHEN approval_date IS NULL AND valid_from IS NULL AND valid_to IS NULL THEN true
    WHEN approval_date IS NOT NULL AND valid_from IS NULL AND valid_to IS NULL THEN true
    WHEN approval_date <= valid_from AND valid_to IS NULL THEN true
    WHEN approval_date <= valid_from AND valid_from < valid_to THEN true
    ELSE false
END)
)

TABLESPACE pg_default;

CREATE INDEX sidx_spatial_plan_geom
    ON "SCHEMANAME".spatial_plan USING gist
    (geom)
    TABLESPACE pg_default;


-- Table: SCHEMANAME.contact
CREATE TABLE SCHEMANAME.contact
(
    identifier INTEGER DEFAULT nextval('SCHEMANAME.contact_identifier_seq'::regclass),
    name CHARACTER VARYING COLLATE pg_catalog."default" NOT NULL,
    fk_spatial_plan UUID NOT NULL,
    CONSTRAINT contact_pkey PRIMARY KEY (identifier),
    CONSTRAINT spatial_plan_contact_fkey FOREIGN KEY (fk_spatial_plan)
        REFERENCES SCHEMANAME.spatial_plan (planning_object_identifier) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT contact_name_check CHECK (name::TEXT <> ''::TEXT)
)
    TABLESPACE pg_default;

-- Table: SCHEMANAME.localized_objective
CREATE TABLE SCHEMANAME.localized_objective
(
    identifier INTEGER DEFAULT nextval('SCHEMANAME.localized_objective_identifier_seq'::regclass),
    objective TEXT COLLATE pg_catalog."default" NOT NULL,
    fk_spatial_plan UUID NOT NULL,
    CONSTRAINT localized_objective_pkey PRIMARY KEY (identifier),
    CONSTRAINT spatial_plan_objective_fkey FOREIGN KEY (fk_spatial_plan)
        REFERENCES SCHEMANAME.spatial_plan (planning_object_identifier) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT localized_objective_objective_check CHECK (objective <> ''::TEXT)
)
    TABLESPACE pg_default;

-- Table: SCHEMANAME.referenced_document
CREATE TABLE SCHEMANAME.referenced_document
(
    identifier INTEGER DEFAULT nextval('SCHEMANAME.referenced_document_identifier_seq'::regclass),
    reference CHARACTER VARYING COLLATE pg_catalog."default" NOT NULL,
    referenced_on DATE NOT NULL,
    name CHARACTER VARYING COLLATE pg_catalog."default" NOT NULL,
    fk_spatial_plan UUID NOT NULL,
    language INTEGER NOT NULL,
    role INTEGER NOT NULL,
    type INTEGER NOT NULL,
    CONSTRAINT referenced_document_pkey PRIMARY KEY (identifier),
    CONSTRAINT spatial_plan_document_fkey FOREIGN KEY (fk_spatial_plan)
        REFERENCES SCHEMANAME.spatial_plan (planning_object_identifier) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED
)
    TABLESPACE pg_default;

-- Table: SCHEMANAME.zoning_element
CREATE TABLE "SCHEMANAME".zoning_element
(
    identifier integer NOT NULL DEFAULT nextval('"SCHEMANAME".zoning_element_identifier_seq'::regclass),
    planning_object_identifier uuid NOT NULL DEFAULT uuid_generate_v4(),
    geom geometry(MultiPolygon,PROJECTSRID) NOT NULL,
    created timestamp without time zone NOT NULL DEFAULT now(),
    localized_name character varying COLLATE pg_catalog."default" NOT NULL,
    name character varying COLLATE pg_catalog."default",
    type integer NOT NULL,
    up_to_dateness integer NOT NULL,
    finnish_land_use_kind character varying(4) COLLATE pg_catalog."default" NOT NULL,
    valid_from date,
    valid_to date,
    block_number character varying COLLATE pg_catalog."default",
    parcel_number character varying COLLATE pg_catalog."default",
    validity integer NOT NULL DEFAULT 4,
    fk_spatial_plan uuid,
    CONSTRAINT zoning_element_pkey PRIMARY KEY (identifier),
    CONSTRAINT zoning_element_planning_object_identifier_key UNIQUE (planning_object_identifier),
    CONSTRAINT spatial_plan_zoning_element_fk FOREIGN KEY (fk_spatial_plan)
        REFERENCES "SCHEMANAME".spatial_plan (planning_object_identifier) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT zoning_date_check CHECK (
CASE
    WHEN valid_from IS NOT NULL AND valid_to IS NULL THEN true
    WHEN valid_from IS NOT NULL AND valid_to > valid_from THEN true
    WHEN valid_from IS NULL AND valid_to IS NULL THEN true
    ELSE false
END)
)

TABLESPACE pg_default;


CREATE INDEX fki_spatial_plan_zoning_element_fk
    ON SCHEMANAME.zoning_element USING btree
        (fk_spatial_plan ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE INDEX sidx_zoning_element_geom
    ON SCHEMANAME.zoning_element USING gist
        (geom)
    TABLESPACE pg_default;

-- Table: SCHEMANAME.planned_space
CREATE TABLE "SCHEMANAME".planned_space
(
    identifier integer NOT NULL DEFAULT nextval('"SCHEMANAME".planned_space_identifier_seq'::regclass),
    planning_object_identifier uuid NOT NULL DEFAULT uuid_generate_v4(),
    geom geometry(MultiPolygon,PROJECTSRID) NOT NULL,
    created timestamp without time zone NOT NULL DEFAULT now(),
    obligatory boolean NOT NULL,
    type integer NOT NULL,
    validity integer NOT NULL DEFAULT 4,
    valid_from date,
    valid_to date,
    CONSTRAINT planned_space_pkey PRIMARY KEY (identifier),
    CONSTRAINT planned_space_planning_object_identifier_key UNIQUE (planning_object_identifier),
    CONSTRAINT planned_space_date_check CHECK (
CASE
    WHEN valid_from IS NOT NULL AND valid_to IS NULL THEN true
    WHEN valid_from IS NOT NULL AND valid_to > valid_from THEN true
    WHEN valid_from IS NULL AND valid_to IS NULL THEN true
    ELSE false
END)
)

TABLESPACE pg_default;

CREATE INDEX sidx_planned_space_geom
    ON SCHEMANAME.planned_space USING gist
        (geom)
    TABLESPACE pg_default;

-- Table: SCHEMANAME.planning_detail_line
CREATE TABLE "SCHEMANAME".planning_detail_line
(
    identifier integer NOT NULL DEFAULT nextval('"SCHEMANAME".planning_detail_line_identifier_seq'::regclass),
    planning_object_identifier uuid NOT NULL DEFAULT uuid_generate_v4(),
    created timestamp without time zone NOT NULL DEFAULT now(),
    geom geometry(MultiLineString,PROJECTSRID) NOT NULL,
    type integer NOT NULL,
	type_description character varying COLLATE pg_catalog."default",
    obligatory boolean NOT NULL,
    validity integer NOT NULL DEFAULT 4,
    CONSTRAINT planning_detail_line_pkey PRIMARY KEY (identifier),
    CONSTRAINT planning_detail_line_planning_object_identifier_key UNIQUE (planning_object_identifier)
)

TABLESPACE pg_default;

CREATE INDEX sidx_planning_detail_line_geom
    ON SCHEMANAME.planning_detail_line USING gist
        (geom)
    TABLESPACE pg_default;

-- Table: SCHEMANAME.planning_detail_point
CREATE TABLE "SCHEMANAME".planning_detail_point
(
    identifier integer NOT NULL DEFAULT nextval('"SCHEMANAME".planning_detail_point_identifier_seq'::regclass),
    planning_object_identifier uuid NOT NULL DEFAULT uuid_generate_v4(),
    created timestamp without time zone NOT NULL DEFAULT now(),
    geom geometry(Point,PROJECTSRID) NOT NULL,
    type integer NOT NULL,
    obligatory boolean NOT NULL,
    validity integer NOT NULL DEFAULT 4,
    point_rotation double precision NOT NULL DEFAULT 0.0,
    type_description character varying COLLATE pg_catalog."default",
    CONSTRAINT planning_detail_point_pkey PRIMARY KEY (identifier),
    CONSTRAINT planning_detail_point_planning_object_identifier_key UNIQUE (planning_object_identifier),
    CONSTRAINT planning_detail_point_validity_check CHECK (validity <> 2)
)

TABLESPACE pg_default;

CREATE INDEX sidx_planning_detail_point_geom
    ON SCHEMANAME.planning_detail_point USING gist
        (geom)
    TABLESPACE pg_default;

-- Table: SCHEMANAME.regulative_text
CREATE TABLE SCHEMANAME.regulative_text
(
    identifier INTEGER DEFAULT nextval('SCHEMANAME.regulative_text_identifier_seq'::regclass),
    regulative_id UUID NOT NULL,
    type INTEGER NOT NULL,
    description_fi CHARACTER VARYING COLLATE pg_catalog."default",
    description_se CHARACTER VARYING COLLATE pg_catalog."default",
    validity INTEGER NOT NULL DEFAULT 1,
    CONSTRAINT regulative_text_pkey PRIMARY KEY (identifier),
    CONSTRAINT regulative_text_regulative_id_key UNIQUE (regulative_id)
)
    TABLESPACE pg_default;

-- Table: SCHEMANAME.spatial_plan_regulation
CREATE TABLE SCHEMANAME.spatial_plan_regulation
(
    identifier INTEGER DEFAULT nextval('SCHEMANAME.spatial_plan_regulation_identifier_seq'::regclass),
    spatial_plan_id UUID NOT NULL,
    regulative_id UUID NOT NULL,
    CONSTRAINT spatial_plan_regulation_pkey PRIMARY KEY (identifier),
    CONSTRAINT spatial_plan_regulation_key UNIQUE (spatial_plan_id, regulative_id),
    CONSTRAINT regulative_id_spatial_plan_fkey FOREIGN KEY (regulative_id)
        REFERENCES SCHEMANAME.regulative_text (regulative_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT spatial_plan_regulation_fkey FOREIGN KEY (spatial_plan_id)
        REFERENCES SCHEMANAME.spatial_plan (planning_object_identifier) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED
)
    TABLESPACE pg_default;


-- Table: SCHEMANAME.zoning_element_regulation
CREATE TABLE SCHEMANAME.zoning_element_regulation
(
    identifier INTEGER DEFAULT nextval('SCHEMANAME.zoning_element_regulation_identifier_seq'::regclass),
    zoning_element_id UUID NOT NULL,
    regulative_id UUID NOT NULL,
    CONSTRAINT zoning_element_regulation_pkey PRIMARY KEY (identifier),
    CONSTRAINT zoning_element_regulation_key UNIQUE (zoning_element_id, regulative_id),
    CONSTRAINT regulative_id_zoning_fkey FOREIGN KEY (regulative_id)
        REFERENCES SCHEMANAME.regulative_text (regulative_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT zoning_element_regulation_fkey FOREIGN KEY (zoning_element_id)
        REFERENCES SCHEMANAME.zoning_element (planning_object_identifier) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED
)
    TABLESPACE pg_default;

-- Table: SCHEMANAME.planned_space_regulation
CREATE TABLE SCHEMANAME.planned_space_regulation
(
    identifier INTEGER DEFAULT nextval('SCHEMANAME.planned_space_regulation_identifier_seq'::regclass),
    planned_space_id UUID NOT NULL,
    regulative_id UUID NOT NULL,
    CONSTRAINT planned_space_regulation_pkey PRIMARY KEY (identifier),
    CONSTRAINT planned_space_regulation_key UNIQUE (planned_space_id, regulative_id),
    CONSTRAINT planned_space_regulation_fkey FOREIGN KEY (planned_space_id)
        REFERENCES SCHEMANAME.planned_space (planning_object_identifier) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT regulative_id_planned_space_fkey FOREIGN KEY (regulative_id)
        REFERENCES SCHEMANAME.regulative_text (regulative_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED
)
    TABLESPACE pg_default;


-- Table: SCHEMANAME.describing_text
CREATE TABLE SCHEMANAME.describing_text
(
    identifier INTEGER DEFAULT nextval('SCHEMANAME.describing_text_identifier_seq'::regclass),
    created TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT now(),
    geom GEOMETRY(Point, PROJECTSRID) NOT NULL,
    text CHARACTER VARYING COLLATE pg_catalog."default" NOT NULL,
    label_x DOUBLE PRECISION,
    label_y DOUBLE PRECISION,
    label_rotation DOUBLE PRECISION,
    callouts BOOLEAN NOT NULL DEFAULT TRUE,
    big_letters BOOLEAN,
    validity INTEGER NOT NULL DEFAULT 4,
    CONSTRAINT describing_text_pkey PRIMARY KEY (identifier),
    CONSTRAINT describing_text_validity_check CHECK (validity <> 2)
)
    TABLESPACE pg_default;

CREATE INDEX sidx_describing_text_geom
    ON SCHEMANAME.describing_text USING gist
        (geom)
    TABLESPACE pg_default;

-- Table: SCHEMANAME.describing_line
CREATE TABLE SCHEMANAME.describing_line
(
    identifier INTEGER DEFAULT nextval('SCHEMANAME.describing_line_identifier_seq'::regclass),
    geom GEOMETRY(MultiLineString, PROJECTSRID) NOT NULL,
    type INTEGER NOT NULL,
    validity INTEGER NOT NULL DEFAULT 4,
    CONSTRAINT describing_line_pkey PRIMARY KEY (identifier)
)
    TABLESPACE pg_default;

CREATE INDEX sidx_describing_line_geom
    ON SCHEMANAME.describing_line USING gist
        (geom)
    TABLESPACE pg_default;

-- Table: SCHEMANAME.numeric_value
CREATE TABLE SCHEMANAME.numeric_value
(
    identifier INTEGER DEFAULT nextval('SCHEMANAME.numeric_value_identifier_seq'::regclass),
    numeric_value_id UUID NOT NULL DEFAULT uuid_generate_v4(),
    obligatory BOOLEAN NOT NULL,
    value DOUBLE PRECISION NOT NULL,
    value_type INTEGER NOT NULL,
    target_type INTEGER NOT NULL,
    localized_name CHARACTER VARYING COLLATE pg_catalog."default",
    description_fi CHARACTER VARYING COLLATE pg_catalog."default",
    description_se CHARACTER VARYING COLLATE pg_catalog."default",
    CONSTRAINT numeric_value_pkey PRIMARY KEY (identifier),
    CONSTRAINT numeric_value_numeric_value_id_key UNIQUE (numeric_value_id)
)
    TABLESPACE pg_default;

-- Table: SCHEMANAME.zoning_element_numeric_value
CREATE TABLE SCHEMANAME.zoning_element_numeric_value
(
    identifier INTEGER NOT NULL DEFAULT nextval('SCHEMANAME.zoning_element_numeric_value_identifier_seq'::regclass),
    zoning_id UUID NOT NULL,
    numeric_id UUID NOT NULL,
    CONSTRAINT zoning_element_numeric_value_pkey PRIMARY KEY (identifier),
    CONSTRAINT zoning_element_numeric_value_key UNIQUE (zoning_id, numeric_id),
    CONSTRAINT numeric_value_zoning_element_fk FOREIGN KEY (numeric_id)
        REFERENCES SCHEMANAME.numeric_value (numeric_value_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT zoning_element_numeric_value_fk FOREIGN KEY (zoning_id)
        REFERENCES SCHEMANAME.zoning_element (planning_object_identifier) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED
)
    TABLESPACE pg_default;

-- Table: SCHEMANAME.planned_space_numeric_value
CREATE TABLE SCHEMANAME.planned_space_numeric_value
(
    identifier INTEGER NOT NULL DEFAULT nextval('SCHEMANAME.planned_space_numeric_value_identifier_seq'::regclass),
    planned_space_id UUID NOT NULL,
    numeric_id UUID NOT NULL,
    CONSTRAINT planned_space_numeric_value_pkey PRIMARY KEY (identifier),
    CONSTRAINT planned_space_numeric_value_key UNIQUE (planned_space_id, numeric_id),
    CONSTRAINT numeric_value_planned_space_fk FOREIGN KEY (numeric_id)
        REFERENCES SCHEMANAME.numeric_value (numeric_value_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT planned_space_numeric_value_fk FOREIGN KEY (planned_space_id)
        REFERENCES SCHEMANAME.planned_space (planning_object_identifier) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED
)
    TABLESPACE pg_default;

-- Table: SCHEMANAME.planning_detail_line_numeric_value
CREATE TABLE SCHEMANAME.planning_detail_line_numeric_value
(
    identifier INTEGER NOT NULL DEFAULT nextval('SCHEMANAME.planning_detail_line_numeric_value_identifier_seq'::regclass),
    planning_detail_line_id UUID NOT NULL,
    numeric_id UUID NOT NULL,
    CONSTRAINT planning_detail_line_numeric_value_pkey PRIMARY KEY (identifier),
    CONSTRAINT planning_detail_line_numeric_value_key UNIQUE (planning_detail_line_id, numeric_id),
    CONSTRAINT numeric_value_planning_detail_line_fk FOREIGN KEY (numeric_id)
        REFERENCES SCHEMANAME.numeric_value (numeric_value_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT planning_detail_line_value_fk FOREIGN KEY (planning_detail_line_id)
        REFERENCES SCHEMANAME.planning_detail_line (planning_object_identifier) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED
)
    TABLESPACE pg_default;

-- Table: SCHEMANAME.planning_detail_point_numeric_value
CREATE TABLE SCHEMANAME.planning_detail_point_numeric_value
(
    identifier INTEGER NOT NULL DEFAULT nextval('SCHEMANAME.planning_detail_point_numeric_value_identifier_seq'::regclass),
    planning_detail_point_id UUID NOT NULL,
    numeric_id UUID NOT NULL,
    CONSTRAINT planning_detail_point_numeric_value_pkey PRIMARY KEY (identifier),
    CONSTRAINT planning_detail_point_numeric_value_key UNIQUE (planning_detail_point_id, numeric_id),
    CONSTRAINT numeric_value_planning_detail_point_fk FOREIGN KEY (numeric_id)
        REFERENCES SCHEMANAME.numeric_value (numeric_value_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT planning_detail_point_value_fk FOREIGN KEY (planning_detail_point_id)
        REFERENCES SCHEMANAME.planning_detail_point (planning_object_identifier) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED
)
    TABLESPACE pg_default;

-- Table: SCHEMANAME.planned_space_plan_detail_line
CREATE TABLE SCHEMANAME.planned_space_plan_detail_line
(
    identifier INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    planned_space_id UUID NOT NULL,
    plan_detail_line_id UUID NOT NULL,
    CONSTRAINT planned_space_detail_line_pkey PRIMARY KEY (identifier),
    CONSTRAINT planned_space_detail_line_planned_space_id_plan_detail_line_key UNIQUE (planned_space_id, plan_detail_line_id),
    CONSTRAINT plan_detail_line_planned_space_fk FOREIGN KEY (plan_detail_line_id)
        REFERENCES SCHEMANAME.planning_detail_line (planning_object_identifier) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT planned_space_plan_detail_line_fk FOREIGN KEY (planned_space_id)
        REFERENCES SCHEMANAME.planned_space (planning_object_identifier) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED
)
    TABLESPACE pg_default;

-- Table: SCHEMANAME.planned_space_plan_detail_point
CREATE TABLE SCHEMANAME.planned_space_plan_detail_point
(
    identifier INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    planned_space_id UUID NOT NULL,
    plan_detail_point_id UUID NOT NULL,
    CONSTRAINT planned_space_detail_point_pkey PRIMARY KEY (identifier),
    CONSTRAINT planned_space_detail_point_planned_space_id_plan_detail_poi_key UNIQUE (planned_space_id, plan_detail_point_id),
    CONSTRAINT plan_detail_point_planned_space_fk FOREIGN KEY (plan_detail_point_id)
        REFERENCES SCHEMANAME.planning_detail_point (planning_object_identifier) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT planned_space_plan_detail_point_fk FOREIGN KEY (planned_space_id)
        REFERENCES SCHEMANAME.planned_space (planning_object_identifier) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED
)
    TABLESPACE pg_default;

-- Table: SCHEMANAME.zoning_element_describing_line
CREATE TABLE SCHEMANAME.zoning_element_describing_line
(
    identifier INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    zoning_id UUID NOT NULL,
    describing_line_id INTEGER NOT NULL,
    CONSTRAINT zoning_element_describing_line_pkey PRIMARY KEY (identifier),
    CONSTRAINT zoning_element_describing_line_zoning_id_describing_line_id_key UNIQUE (zoning_id, describing_line_id),
    CONSTRAINT describing_line_zoning_element_fk FOREIGN KEY (describing_line_id)
        REFERENCES SCHEMANAME.describing_line (identifier) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT zoning_element_describing_line_fk FOREIGN KEY (zoning_id)
        REFERENCES SCHEMANAME.zoning_element (planning_object_identifier) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED
)
    TABLESPACE pg_default;

-- Table: SCHEMANAME.zoning_element_describing_text
CREATE TABLE SCHEMANAME.zoning_element_describing_text
(
    identifier INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    zoning_id UUID NOT NULL,
    describing_text_id INTEGER NOT NULL,
    CONSTRAINT zoning_element_describing_text_pkey PRIMARY KEY (identifier),
    CONSTRAINT zoning_element_describing_text_zoning_id_describing_text_id_key UNIQUE (zoning_id, describing_text_id),
    CONSTRAINT describing_text_zoning_element_fk FOREIGN KEY (describing_text_id)
        REFERENCES SCHEMANAME.describing_text (identifier) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT zoning_element_describing_text_fk FOREIGN KEY (zoning_id)
        REFERENCES SCHEMANAME.zoning_element (planning_object_identifier) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED
)
    TABLESPACE pg_default;

-- Table: SCHEMANAME.zoning_element_plan_detail_line
CREATE TABLE SCHEMANAME.zoning_element_plan_detail_line
(
    identifier INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    zoning_id UUID NOT NULL,
    plan_detail_line_id UUID NOT NULL,
    CONSTRAINT zoning_element_plan_detail_line_pkey PRIMARY KEY (identifier),
    CONSTRAINT zoning_element_plan_detail_li_zoning_id_plan_detail_line_id_key UNIQUE (zoning_id, plan_detail_line_id),
    CONSTRAINT plan_detail_line_zoning_element_fk FOREIGN KEY (plan_detail_line_id)
        REFERENCES SCHEMANAME.planning_detail_line (planning_object_identifier) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT zoning_element_plan_detail_line_fk FOREIGN KEY (zoning_id)
        REFERENCES SCHEMANAME.zoning_element (planning_object_identifier) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED
)
    TABLESPACE pg_default;

-- Table: SCHEMANAME.zoning_element_plan_detail_point
CREATE TABLE SCHEMANAME.zoning_element_plan_detail_point
(
    identifier INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    zoning_id UUID NOT NULL,
    plan_detail_point_id UUID NOT NULL,
    CONSTRAINT zoning_element_plan_detail_point_pkey PRIMARY KEY (identifier),
    CONSTRAINT zoning_element_plan_detail_po_zoning_id_plan_detail_point_i_key UNIQUE (zoning_id, plan_detail_point_id),
    CONSTRAINT plan_detail_point_zoning_element_fk FOREIGN KEY (plan_detail_point_id)
        REFERENCES SCHEMANAME.planning_detail_point (planning_object_identifier) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT zoning_element_plan_detail_point_fk FOREIGN KEY (zoning_id)
        REFERENCES SCHEMANAME.zoning_element (planning_object_identifier) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED
)
    TABLESPACE pg_default;

-- Table: SCHEMANAME.zoning_element_planned_space
CREATE TABLE SCHEMANAME.zoning_element_planned_space
(
    identifier INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    zoning_element_id UUID NOT NULL,
    planned_space_id UUID NOT NULL,
    CONSTRAINT zoning_element_planned_space_pkey PRIMARY KEY (identifier),
    CONSTRAINT zoning_element_planned_space_zoning_element_id_planned_spac_key UNIQUE (zoning_element_id, planned_space_id),
    CONSTRAINT planned_space_zoning_element_fk FOREIGN KEY (planned_space_id)
        REFERENCES SCHEMANAME.planned_space (planning_object_identifier) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT zoning_element_planned_space_fk FOREIGN KEY (zoning_element_id)
        REFERENCES SCHEMANAME.zoning_element (planning_object_identifier) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED
)
    TABLESPACE pg_default;