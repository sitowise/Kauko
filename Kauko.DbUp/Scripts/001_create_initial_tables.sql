-- Table: SCHEMANAME.code_value

-- DROP TABLE IF EXISTS SCHEMANAME.code_value;

CREATE TABLE IF NOT EXISTS SCHEMANAME.code_value
(
    id integer NOT NULL DEFAULT nextval('SCHEMANAME.code_value_id_seq'::regclass),
    code_value_uuid uuid NOT NULL DEFAULT uuid_generate_v4(),
    value character varying COLLATE pg_catalog."default" NOT NULL,
    code_list character varying COLLATE pg_catalog."default",
    title jsonb,
    CONSTRAINT code_value_pkey PRIMARY KEY (id),
    CONSTRAINT code_value_code_value_uuid_key UNIQUE (code_value_uuid),
    CONSTRAINT code_value_title_check CHECK (check_language_string(title))
)
TABLESPACE pg_default;

-- Trigger: code_value_refresh_area_view

-- DROP TRIGGER IF EXISTS code_value_refresh_area_view ON SCHEMANAME.code_value;

CREATE OR REPLACE TRIGGER code_value_refresh_area_view
    AFTER INSERT OR DELETE OR UPDATE 
    ON SCHEMANAME.code_value
    FOR EACH STATEMENT
    EXECUTE FUNCTION SCHEMANAME.refresh_plan_regulations_area_view();

-- Trigger: code_value_refresh_line_view

-- DROP TRIGGER IF EXISTS code_value_refresh_line_view ON SCHEMANAME.code_value;

CREATE OR REPLACE TRIGGER code_value_refresh_line_view
    AFTER INSERT OR DELETE OR UPDATE 
    ON SCHEMANAME.code_value
    FOR EACH STATEMENT
    EXECUTE FUNCTION SCHEMANAME.refresh_plan_regulations_line_view();
	
-- Table: SCHEMANAME.describing_line

-- DROP TABLE IF EXISTS SCHEMANAME.describing_line;

CREATE TABLE IF NOT EXISTS SCHEMANAME.describing_line
(
    identifier integer NOT NULL DEFAULT nextval('SCHEMANAME.describing_line_identifier_seq'::regclass),
    geom geometry(MultiLineString,PROJECTSRID) NOT NULL,
    type integer NOT NULL,
    lifecycle_status character varying(3) COLLATE pg_catalog."default" NOT NULL DEFAULT '01'::character varying,
    is_active boolean DEFAULT true,
    CONSTRAINT describing_line_pkey PRIMARY KEY (identifier),
    CONSTRAINT describing_line_lifecycle_status_fkey FOREIGN KEY (lifecycle_status)
        REFERENCES code_lists.spatial_plan_lifecycle_status (codevalue) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

-- Index: sidx_describing_line_geom

-- DROP INDEX IF EXISTS SCHEMANAME.sidx_describing_line_geom;

CREATE INDEX IF NOT EXISTS sidx_describing_line_geom
    ON SCHEMANAME.describing_line USING gist
    (geom)
    TABLESPACE pg_default;

-- Trigger: delete_geom_relations

-- DROP TRIGGER IF EXISTS delete_geom_relations ON SCHEMANAME.describing_line;

CREATE OR REPLACE TRIGGER delete_geom_relations
    BEFORE UPDATE OF geom
    ON SCHEMANAME.describing_line
    FOR EACH ROW
    WHEN (old.geom IS DISTINCT FROM new.geom)
    EXECUTE FUNCTION SCHEMANAME.delete_geom_relations();

-- Trigger: geom_relations

-- DROP TRIGGER IF EXISTS geom_relations ON SCHEMANAME.describing_line;

CREATE OR REPLACE TRIGGER geom_relations
    AFTER INSERT OR UPDATE OF geom
    ON SCHEMANAME.describing_line
    FOR EACH STATEMENT
    EXECUTE FUNCTION SCHEMANAME.geom_relations();

-- Trigger: update_validity

-- DROP TRIGGER IF EXISTS update_validity ON SCHEMANAME.describing_line;

CREATE OR REPLACE TRIGGER update_validity
    AFTER INSERT OR UPDATE 
    ON SCHEMANAME.describing_line
    FOR EACH STATEMENT
    WHEN (pg_trigger_depth() < 1)
    EXECUTE FUNCTION SCHEMANAME.update_validity();

-- Trigger: validate_describing_line_geom

-- DROP TRIGGER IF EXISTS validate_describing_line_geom ON SCHEMANAME.describing_line;

CREATE OR REPLACE TRIGGER validate_describing_line_geom
    BEFORE INSERT OR UPDATE OF geom
    ON SCHEMANAME.describing_line
    FOR EACH ROW
    EXECUTE FUNCTION SCHEMANAME.validate_geometry();
	
	
-- Table: SCHEMANAME.describing_text

-- DROP TABLE IF EXISTS SCHEMANAME.describing_text;

CREATE TABLE IF NOT EXISTS SCHEMANAME.describing_text
(
    identifier integer NOT NULL DEFAULT nextval('SCHEMANAME.describing_text_identifier_seq'::regclass),
    created timestamp without time zone NOT NULL DEFAULT now(),
    geom geometry(Point,PROJECTSRID) NOT NULL,
    text character varying COLLATE pg_catalog."default" NOT NULL,
    label_x double precision,
    label_y double precision,
    label_rotation double precision,
    callouts boolean NOT NULL DEFAULT true,
    big_letters boolean,
    lifecycle_status character varying(3) COLLATE pg_catalog."default" NOT NULL DEFAULT '01'::character varying,
    is_active boolean DEFAULT true,
    CONSTRAINT describing_text_pkey PRIMARY KEY (identifier),
    CONSTRAINT describing_text_lifecycle_status_fkey FOREIGN KEY (lifecycle_status)
        REFERENCES code_lists.spatial_plan_lifecycle_status (codevalue) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

-- Index: sidx_describing_text_geom

-- DROP INDEX IF EXISTS SCHEMANAME.sidx_describing_text_geom;

CREATE INDEX IF NOT EXISTS sidx_describing_text_geom
    ON SCHEMANAME.describing_text USING gist
    (geom)
    TABLESPACE pg_default;

-- Trigger: delete_geom_relations

-- DROP TRIGGER IF EXISTS delete_geom_relations ON SCHEMANAME.describing_text;

CREATE OR REPLACE TRIGGER delete_geom_relations
    BEFORE UPDATE OF geom
    ON SCHEMANAME.describing_text
    FOR EACH ROW
    WHEN (old.geom IS DISTINCT FROM new.geom)
    EXECUTE FUNCTION SCHEMANAME.delete_geom_relations();

-- Trigger: geom_relations

-- DROP TRIGGER IF EXISTS geom_relations ON SCHEMANAME.describing_text;

CREATE OR REPLACE TRIGGER geom_relations
    AFTER INSERT OR UPDATE OF geom
    ON SCHEMANAME.describing_text
    FOR EACH STATEMENT
    EXECUTE FUNCTION SCHEMANAME.geom_relations();

-- Trigger: update_validity

-- DROP TRIGGER IF EXISTS update_validity ON SCHEMANAME.describing_text;

CREATE OR REPLACE TRIGGER update_validity
    AFTER INSERT OR UPDATE 
    ON SCHEMANAME.describing_text
    FOR EACH STATEMENT
    WHEN (pg_trigger_depth() < 1)
    EXECUTE FUNCTION SCHEMANAME.update_validity();

-- Trigger: validate_describing_text_geom

-- DROP TRIGGER IF EXISTS validate_describing_text_geom ON SCHEMANAME.describing_text;

CREATE OR REPLACE TRIGGER validate_describing_text_geom
    BEFORE INSERT OR UPDATE OF geom
    ON SCHEMANAME.describing_text
    FOR EACH ROW
    EXECUTE FUNCTION SCHEMANAME.validate_geometry();
	
-- Table: SCHEMANAME.document

-- DROP TABLE IF EXISTS SCHEMANAME.document;

CREATE TABLE IF NOT EXISTS SCHEMANAME.document
(
    id integer NOT NULL DEFAULT nextval('SCHEMANAME.document_id_seq'::regclass),
    producer_specific_id uuid NOT NULL DEFAULT uuid_generate_v4(),
    identity_id uuid NOT NULL DEFAULT uuid_generate_v4(),
    local_id character varying COLLATE pg_catalog."default" NOT NULL DEFAULT uuid_generate_v4(),
    namespace character varying COLLATE pg_catalog."default",
    reference_id character varying COLLATE pg_catalog."default",
    latest_change timestamp without time zone NOT NULL DEFAULT now(),
    storage_time timestamp without time zone,
    document_identifier character varying COLLATE pg_catalog."default",
    name jsonb,
    additional_information_link character varying COLLATE pg_catalog."default",
    metadata character varying COLLATE pg_catalog."default",
    type character varying COLLATE pg_catalog."default" NOT NULL,
    created timestamp without time zone NOT NULL DEFAULT now(),
    created_by text COLLATE pg_catalog."default" NOT NULL,
    modified_by text COLLATE pg_catalog."default" NOT NULL,
    modified_at timestamp without time zone NOT NULL,
    CONSTRAINT document_pkey PRIMARY KEY (id),
    CONSTRAINT document_local_id_key UNIQUE (local_id),
    CONSTRAINT document_producer_specific_id_key UNIQUE (producer_specific_id),
    CONSTRAINT fk_document_type FOREIGN KEY (type)
        REFERENCES code_lists.document_kind (codevalue) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT document_name_check CHECK (check_language_string(name))
)	

	-- Trigger: document_modified_trigger

-- DROP TRIGGER IF EXISTS document_modified_trigger ON SCHEMANAME.document;

CREATE OR REPLACE TRIGGER document_modified_trigger
    BEFORE INSERT OR UPDATE 
    ON SCHEMANAME.document
    FOR EACH ROW
    EXECUTE FUNCTION public.versioned_object_modified_trigger();

-- Trigger: upsert_creator_and_modifier_trigger

-- DROP TRIGGER IF EXISTS upsert_creator_and_modifier_trigger ON SCHEMANAME.document;

CREATE OR REPLACE TRIGGER upsert_creator_and_modifier_trigger
    BEFORE INSERT OR UPDATE 
    ON SCHEMANAME.document
    FOR EACH ROW
    EXECUTE FUNCTION SCHEMANAME.upsert_creator_and_modifier_trigger();
	
-- Table: SCHEMANAME.document_document

-- DROP TABLE IF EXISTS SCHEMANAME.document_document;

CREATE TABLE IF NOT EXISTS SCHEMANAME.document_document
(
    id integer NOT NULL DEFAULT nextval('SCHEMANAME.document_document_id_seq'::regclass),
    referencing_document_local_id character varying COLLATE pg_catalog."default" NOT NULL,
    referenced_document_local_id character varying COLLATE pg_catalog."default" NOT NULL,
    role jsonb,
    CONSTRAINT document_document_pkey PRIMARY KEY (id),
    CONSTRAINT fk_referenced_document FOREIGN KEY (referenced_document_local_id)
        REFERENCES SCHEMANAME.document (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT fk_referencing_document FOREIGN KEY (referencing_document_local_id)
        REFERENCES SCHEMANAME.document (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT document_document_role_check CHECK (check_language_string(role)),
    CONSTRAINT local_id_check CHECK (referencing_document_local_id::text <> referenced_document_local_id::text)
)

-- Table: SCHEMANAME.elevation_position_value

-- DROP TABLE IF EXISTS SCHEMANAME.elevation_position_value;

CREATE TABLE IF NOT EXISTS SCHEMANAME.elevation_position_value
(
    id integer NOT NULL DEFAULT nextval('SCHEMANAME.elevation_position_value_id_seq'::regclass),
    elevation_position_value_uuid uuid NOT NULL DEFAULT uuid_generate_v4(),
    value double precision NOT NULL,
    unit_of_measure character varying COLLATE pg_catalog."default",
    reference_point geometry(Point,PROJECTSRID) NOT NULL,
    vertical_reference_system integer NOT NULL,
    is_active boolean NOT NULL DEFAULT true,
    CONSTRAINT elevation_position_value_pkey PRIMARY KEY (id),
    CONSTRAINT elevation_position_value_elevation_position_value_uuid_key UNIQUE (elevation_position_value_uuid),
    CONSTRAINT elevation_position_value_vertical_system_fk FOREIGN KEY (vertical_reference_system)
        REFERENCES code_lists.finnish_vertical_coordinate_reference_system (value) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE RESTRICT
)

-- Index: sidx_elevation_position_value_geom

-- DROP INDEX IF EXISTS SCHEMANAME.sidx_elevation_position_value_geom;

CREATE INDEX IF NOT EXISTS sidx_elevation_position_value_geom
    ON SCHEMANAME.elevation_position_value USING gist
    (reference_point)
    TABLESPACE pg_default;

-- Table: SCHEMANAME.elevation_range_value

-- DROP TABLE IF EXISTS SCHEMANAME.elevation_range_value;

CREATE TABLE IF NOT EXISTS SCHEMANAME.elevation_range_value
(
    id integer NOT NULL DEFAULT nextval('SCHEMANAME.elevation_range_value_id_seq'::regclass),
    elevation_range_value_uuid uuid NOT NULL DEFAULT uuid_generate_v4(),
    minimum_value double precision,
    maximum_value double precision,
    unit_of_measure character varying COLLATE pg_catalog."default",
    reference_point geometry(Point,PROJECTSRID) NOT NULL,
    vertical_reference_system integer NOT NULL,
    is_active boolean NOT NULL DEFAULT true,
    CONSTRAINT elevation_range_value_pkey PRIMARY KEY (id),
    CONSTRAINT elevation_range_value_elevation_range_value_uuid_key UNIQUE (elevation_range_value_uuid),
    CONSTRAINT elevation_range_vertical_system_fk FOREIGN KEY (vertical_reference_system)
        REFERENCES code_lists.finnish_vertical_coordinate_reference_system (value) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT elevation_range_value_value_check CHECK (minimum_value <= maximum_value)
)

-- Index: sidx_elevation_range_value_geom

-- DROP INDEX IF EXISTS SCHEMANAME.sidx_elevation_range_value_geom;

CREATE INDEX IF NOT EXISTS sidx_elevation_range_value_geom
    ON SCHEMANAME.elevation_range_value USING gist
    (reference_point)
    TABLESPACE pg_default;

-- Table: SCHEMANAME.geometry_area_value

-- DROP TABLE IF EXISTS SCHEMANAME.geometry_area_value;

CREATE TABLE IF NOT EXISTS SCHEMANAME.geometry_area_value
(
    id integer NOT NULL DEFAULT nextval('SCHEMANAME.geometry_area_value_id_seq'::regclass),
    geometry_area_value_uuid uuid NOT NULL DEFAULT uuid_generate_v4(),
    value geometry(MultiPolygon,PROJECTSRID) NOT NULL,
    obligatory boolean NOT NULL,
    is_active boolean DEFAULT true,
    CONSTRAINT geometry_area_value_pkey PRIMARY KEY (id),
    CONSTRAINT geometry_area_value_geometry_area_value_uuid_key UNIQUE (geometry_area_value_uuid)
)

-- Index: sidx_geometry_area_value_geom

-- DROP INDEX IF EXISTS SCHEMANAME.sidx_geometry_area_value_geom;

CREATE INDEX IF NOT EXISTS sidx_geometry_area_value_geom
    ON SCHEMANAME.geometry_area_value USING gist
    (value)
    TABLESPACE pg_default;

-- Trigger: geometry_area_value_refresh_area_view

-- DROP TRIGGER IF EXISTS geometry_area_value_refresh_area_view ON SCHEMANAME.geometry_area_value;

CREATE OR REPLACE TRIGGER geometry_area_value_refresh_area_view
    AFTER INSERT OR DELETE
    ON SCHEMANAME.geometry_area_value
    FOR EACH ROW
    EXECUTE FUNCTION SCHEMANAME.refresh_plan_regulations_area_view();

-- Trigger: geometry_area_value_refresh_area_view_on_update

-- DROP TRIGGER IF EXISTS geometry_area_value_refresh_area_view_on_update ON SCHEMANAME.geometry_area_value;

CREATE OR REPLACE TRIGGER geometry_area_value_refresh_area_view_on_update
    AFTER UPDATE 
    ON SCHEMANAME.geometry_area_value
    FOR EACH ROW
    WHEN (old.value IS DISTINCT FROM new.value)
    EXECUTE FUNCTION SCHEMANAME.refresh_plan_regulations_area_view();

-- Trigger: validate_geometry_area_value_geom

-- DROP TRIGGER IF EXISTS validate_geometry_area_value_geom ON SCHEMANAME.geometry_area_value;

CREATE OR REPLACE TRIGGER validate_geometry_area_value_geom
    BEFORE INSERT OR UPDATE OF value
    ON SCHEMANAME.geometry_area_value
    FOR EACH ROW
    EXECUTE FUNCTION SCHEMANAME.validate_geometry();
	
	
-- Table: SCHEMANAME.geometry_line_value

-- DROP TABLE IF EXISTS SCHEMANAME.geometry_line_value;

CREATE TABLE IF NOT EXISTS SCHEMANAME.geometry_line_value
(
    id integer NOT NULL DEFAULT nextval('SCHEMANAME.geometry_line_value_id_seq'::regclass),
    geometry_line_value_uuid uuid NOT NULL DEFAULT uuid_generate_v4(),
    value geometry(MultiLineString,PROJECTSRID) NOT NULL,
    obligatory boolean NOT NULL,
    is_active boolean DEFAULT true,
    CONSTRAINT geometry_line_value_pkey PRIMARY KEY (id),
    CONSTRAINT geometry_line_value_geometry_line_value_uuid_key UNIQUE (geometry_line_value_uuid)
)

-- Index: sidx_geometry_line_value_geom

-- DROP INDEX IF EXISTS SCHEMANAME.sidx_geometry_line_value_geom;

CREATE INDEX IF NOT EXISTS sidx_geometry_line_value_geom
    ON SCHEMANAME.geometry_line_value USING gist
    (value)
    TABLESPACE pg_default;

-- Trigger: geometry_line_value_refresh_line_view

-- DROP TRIGGER IF EXISTS geometry_line_value_refresh_line_view ON SCHEMANAME.geometry_line_value;

CREATE OR REPLACE TRIGGER geometry_line_value_refresh_line_view
    AFTER INSERT OR DELETE
    ON SCHEMANAME.geometry_line_value
    FOR EACH ROW
    EXECUTE FUNCTION SCHEMANAME.refresh_plan_regulations_line_view();

-- Trigger: geometry_line_value_refresh_line_view_on_update

-- DROP TRIGGER IF EXISTS geometry_line_value_refresh_line_view_on_update ON SCHEMANAME.geometry_line_value;

CREATE OR REPLACE TRIGGER geometry_line_value_refresh_line_view_on_update
    AFTER UPDATE 
    ON SCHEMANAME.geometry_line_value
    FOR EACH ROW
    WHEN (old.value IS DISTINCT FROM new.value)
    EXECUTE FUNCTION SCHEMANAME.refresh_plan_regulations_line_view();

-- Trigger: validate_geometry_line_value_geom

-- DROP TRIGGER IF EXISTS validate_geometry_line_value_geom ON SCHEMANAME.geometry_line_value;

CREATE OR REPLACE TRIGGER validate_geometry_line_value_geom
    BEFORE INSERT OR UPDATE OF value
    ON SCHEMANAME.geometry_line_value
    FOR EACH ROW
    EXECUTE FUNCTION SCHEMANAME.validate_geometry();

-- Table: SCHEMANAME.geometry_point_value

-- DROP TABLE IF EXISTS SCHEMANAME.geometry_point_value;

CREATE TABLE IF NOT EXISTS SCHEMANAME.geometry_point_value
(
    id integer NOT NULL DEFAULT nextval('SCHEMANAME.geometry_point_value_id_seq'::regclass),
    geometry_point_value_uuid uuid NOT NULL DEFAULT uuid_generate_v4(),
    value geometry(Point,PROJECTSRID) NOT NULL,
    obligatory boolean NOT NULL,
    point_rotation double precision,
    is_active boolean DEFAULT true,
    CONSTRAINT geometry_point_value_pkey PRIMARY KEY (id),
    CONSTRAINT geometry_point_value_geometry_point_value_uuid_key UNIQUE (geometry_point_value_uuid)
)

-- Index: sidx_geometry_point_value_geom

-- DROP INDEX IF EXISTS SCHEMANAME.sidx_geometry_point_value_geom;

CREATE INDEX IF NOT EXISTS sidx_geometry_point_value_geom
    ON SCHEMANAME.geometry_point_value USING gist
    (value)
    TABLESPACE pg_default;

-- Trigger: geometry_point_value_refresh_point_view

-- DROP TRIGGER IF EXISTS geometry_point_value_refresh_point_view ON SCHEMANAME.geometry_point_value;

CREATE OR REPLACE TRIGGER geometry_point_value_refresh_point_view
    AFTER INSERT OR DELETE
    ON SCHEMANAME.geometry_point_value
    FOR EACH ROW
    EXECUTE FUNCTION SCHEMANAME.refresh_plan_regulations_point_view();

-- Trigger: geometry_point_value_refresh_point_view_on_update

-- DROP TRIGGER IF EXISTS geometry_point_value_refresh_point_view_on_update ON SCHEMANAME.geometry_point_value;

CREATE OR REPLACE TRIGGER geometry_point_value_refresh_point_view_on_update
    AFTER UPDATE 
    ON SCHEMANAME.geometry_point_value
    FOR EACH ROW
    WHEN (old.value IS DISTINCT FROM new.value)
    EXECUTE FUNCTION SCHEMANAME.refresh_plan_regulations_point_view();

-- Trigger: validate_geometry_point_value_geom

-- DROP TRIGGER IF EXISTS validate_geometry_point_value_geom ON SCHEMANAME.geometry_point_value;

CREATE OR REPLACE TRIGGER validate_geometry_point_value_geom
    BEFORE INSERT OR UPDATE OF value
    ON SCHEMANAME.geometry_point_value
    FOR EACH ROW
    EXECUTE FUNCTION SCHEMANAME.validate_geometry();

-- Table: SCHEMANAME.localized_objective

-- DROP TABLE IF EXISTS SCHEMANAME.localized_objective;

CREATE TABLE IF NOT EXISTS SCHEMANAME.localized_objective
(
    identifier integer NOT NULL DEFAULT nextval('SCHEMANAME.localized_objective_identifier_seq'::regclass),
    objective text COLLATE pg_catalog."default" NOT NULL,
    fk_spatial_plan uuid NOT NULL,
    CONSTRAINT localized_objective_pkey PRIMARY KEY (identifier),
    CONSTRAINT spatial_plan_objective_fkey FOREIGN KEY (fk_spatial_plan)
        REFERENCES SCHEMANAME.spatial_plan (producer_specific_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT localized_objective_objective_check CHECK (objective <> ''::text)
)
	
-- Table: SCHEMANAME.numeric_double_value

-- DROP TABLE IF EXISTS SCHEMANAME.numeric_double_value;

CREATE TABLE IF NOT EXISTS SCHEMANAME.numeric_double_value
(
    id integer NOT NULL DEFAULT nextval('SCHEMANAME.numeric_double_value_id_seq'::regclass),
    numeric_double_value_uuid uuid NOT NULL DEFAULT uuid_generate_v4(),
    value double precision NOT NULL,
    unit_of_measure character varying COLLATE pg_catalog."default",
    obligatory boolean NOT NULL,
    CONSTRAINT numeric_double_value_pkey PRIMARY KEY (id),
    CONSTRAINT numeric_double_value_numeric_double_value_uuid_key UNIQUE (numeric_double_value_uuid)
)

-- Trigger: numeric_double_value_refresh_area_view

-- DROP TRIGGER IF EXISTS numeric_double_value_refresh_area_view ON SCHEMANAME.numeric_double_value;

CREATE OR REPLACE TRIGGER numeric_double_value_refresh_area_view
    AFTER INSERT OR DELETE OR UPDATE 
    ON SCHEMANAME.numeric_double_value
    FOR EACH STATEMENT
    EXECUTE FUNCTION SCHEMANAME.refresh_plan_regulations_area_view();

-- Trigger: numeric_double_value_refresh_line_view

-- DROP TRIGGER IF EXISTS numeric_double_value_refresh_line_view ON SCHEMANAME.numeric_double_value;

CREATE OR REPLACE TRIGGER numeric_double_value_refresh_line_view
    AFTER INSERT OR DELETE OR UPDATE 
    ON SCHEMANAME.numeric_double_value
    FOR EACH STATEMENT
    EXECUTE FUNCTION SCHEMANAME.refresh_plan_regulations_line_view();
	
-- Table: SCHEMANAME.numeric_range

-- DROP TABLE IF EXISTS SCHEMANAME.numeric_range;

CREATE TABLE IF NOT EXISTS SCHEMANAME.numeric_range
(
    id integer NOT NULL DEFAULT nextval('SCHEMANAME.numeric_range_id_seq'::regclass),
    numeric_range_uuid uuid NOT NULL DEFAULT uuid_generate_v4(),
    minimum_value double precision,
    maximum_value double precision,
    unit_of_measure character varying COLLATE pg_catalog."default",
    CONSTRAINT numeric_range_pkey PRIMARY KEY (id),
    CONSTRAINT numeric_range_numeric_range_uuid_key UNIQUE (numeric_range_uuid),
    CONSTRAINT numeric_range_value_check CHECK (minimum_value <= maximum_value)
)	

-- Trigger: numeric_range_refresh_area_view

-- DROP TRIGGER IF EXISTS numeric_range_refresh_area_view ON SCHEMANAME.numeric_range;

CREATE OR REPLACE TRIGGER numeric_range_refresh_area_view
    AFTER INSERT OR DELETE OR UPDATE 
    ON SCHEMANAME.numeric_range
    FOR EACH STATEMENT
    EXECUTE FUNCTION SCHEMANAME.refresh_plan_regulations_area_view();

-- Trigger: numeric_range_refresh_line_view

-- DROP TRIGGER IF EXISTS numeric_range_refresh_line_view ON SCHEMANAME.numeric_range;

CREATE OR REPLACE TRIGGER numeric_range_refresh_line_view
    AFTER INSERT OR DELETE OR UPDATE 
    ON SCHEMANAME.numeric_range
    FOR EACH STATEMENT
    EXECUTE FUNCTION SCHEMANAME.refresh_plan_regulations_line_view();
	
-- Table: SCHEMANAME.numeric_value

-- DROP TABLE IF EXISTS SCHEMANAME.numeric_value;

CREATE TABLE IF NOT EXISTS SCHEMANAME.numeric_value
(
    identifier integer NOT NULL DEFAULT nextval('SCHEMANAME.numeric_value_identifier_seq'::regclass),
    numeric_value_id uuid NOT NULL DEFAULT uuid_generate_v4(),
    obligatory boolean NOT NULL,
    value double precision NOT NULL,
    value_type integer NOT NULL,
    target_type integer NOT NULL,
    localized_name character varying COLLATE pg_catalog."default",
    description_fi character varying COLLATE pg_catalog."default",
    description_se character varying COLLATE pg_catalog."default",
    CONSTRAINT numeric_value_pkey PRIMARY KEY (identifier),
    CONSTRAINT numeric_value_numeric_value_id_key UNIQUE (numeric_value_id)
)	

-- Table: SCHEMANAME.participation_and_evalution_plan

-- DROP TABLE IF EXISTS SCHEMANAME.participation_and_evalution_plan;

CREATE TABLE IF NOT EXISTS SCHEMANAME.participation_and_evalution_plan
(
    id integer NOT NULL DEFAULT nextval('SCHEMANAME.participation_and_evalution_plan_id_seq'::regclass),
    producer_specific_id uuid NOT NULL DEFAULT uuid_generate_v4(),
    identity_id uuid NOT NULL DEFAULT uuid_generate_v4(),
    local_id character varying COLLATE pg_catalog."default" NOT NULL DEFAULT uuid_generate_v4(),
    namespace character varying COLLATE pg_catalog."default",
    reference_id character varying COLLATE pg_catalog."default",
    latest_change timestamp without time zone NOT NULL DEFAULT now(),
    storage_time timestamp without time zone NOT NULL DEFAULT now(),
    spatial_plan character varying COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT participation_and_evalution_plan_pkey PRIMARY KEY (id),
    CONSTRAINT participation_and_evalution_plan_local_id_key UNIQUE (local_id),
    CONSTRAINT participation_and_evalution_plan_producer_specific_id_key UNIQUE (producer_specific_id),
    CONSTRAINT participation_and_evalution_plan_spatial_plan_key UNIQUE (spatial_plan),
    CONSTRAINT participation_and_evalution_plan_fk_spatial_plan FOREIGN KEY (spatial_plan)
        REFERENCES SCHEMANAME.spatial_plan (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED
)

-- Trigger: participation_and_evalution_plan_modified_trigger

-- DROP TRIGGER IF EXISTS participation_and_evalution_plan_modified_trigger ON SCHEMANAME.participation_and_evalution_plan;

CREATE OR REPLACE TRIGGER participation_and_evalution_plan_modified_trigger
    BEFORE INSERT OR UPDATE 
    ON SCHEMANAME.participation_and_evalution_plan
    FOR EACH ROW
    EXECUTE FUNCTION public.versioned_object_modified_trigger();
	
-- Table: SCHEMANAME.patricipation_evalution_plan_document

-- DROP TABLE IF EXISTS SCHEMANAME.patricipation_evalution_plan_document;

CREATE TABLE IF NOT EXISTS SCHEMANAME.patricipation_evalution_plan_document
(
    id integer NOT NULL DEFAULT nextval('SCHEMANAME.patricipation_evalution_plan_document_id_seq'::regclass),
    participation_and_evalution_plan_local_id character varying COLLATE pg_catalog."default" NOT NULL,
    document_local_id character varying COLLATE pg_catalog."default" NOT NULL,
    role jsonb,
    CONSTRAINT patricipation_evalution_plan_document_pkey PRIMARY KEY (id),
    CONSTRAINT patricipation_evalution_plan_document_fk_document FOREIGN KEY (document_local_id)
        REFERENCES SCHEMANAME.document (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT patricipation_evalution_plan_document_fk_participation_and_eval FOREIGN KEY (participation_and_evalution_plan_local_id)
        REFERENCES SCHEMANAME.participation_and_evalution_plan (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT patricipation_evalution_plan_document_role_check CHECK (check_language_string(role))
)

-- Table: SCHEMANAME.plan_guidance

-- DROP TABLE IF EXISTS SCHEMANAME.plan_guidance;

CREATE TABLE IF NOT EXISTS SCHEMANAME.plan_guidance
(
    id integer NOT NULL DEFAULT nextval('SCHEMANAME.plan_guidance_id_seq'::regclass),
    local_id character varying COLLATE pg_catalog."default" NOT NULL DEFAULT uuid_generate_v4(),
    identity_id uuid NOT NULL DEFAULT uuid_generate_v4(),
    namespace character varying COLLATE pg_catalog."default",
    reference_id character varying COLLATE pg_catalog."default",
    latest_change timestamp without time zone NOT NULL DEFAULT now(),
    producer_specific_id uuid DEFAULT uuid_generate_v4(),
    storage_time timestamp without time zone,
    name jsonb,
    life_cycle_status character varying COLLATE pg_catalog."default" NOT NULL,
    validity_time daterange,
    valid_from date,
    valid_to date,
    created timestamp without time zone NOT NULL DEFAULT now(),
    created_by text COLLATE pg_catalog."default" NOT NULL,
    modified_by text COLLATE pg_catalog."default" NOT NULL,
    modified_at timestamp without time zone NOT NULL,
    CONSTRAINT plan_guidance_pkey PRIMARY KEY (id),
    CONSTRAINT plan_guidance_local_id_key UNIQUE (local_id),
    CONSTRAINT plan_guidance_fk_life_cycle_status FOREIGN KEY (life_cycle_status)
        REFERENCES code_lists.spatial_plan_lifecycle_status (codevalue) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT plan_guidance_name_check CHECK (check_language_string(name))
)


-- Trigger: plan_guidance_modified_trigger

-- DROP TRIGGER IF EXISTS plan_guidance_modified_trigger ON SCHEMANAME.plan_guidance;

CREATE OR REPLACE TRIGGER plan_guidance_modified_trigger
    BEFORE INSERT OR UPDATE 
    ON SCHEMANAME.plan_guidance
    FOR EACH ROW
    EXECUTE FUNCTION public.versioned_object_modified_trigger();

-- Trigger: plan_guidance_validity_time

-- DROP TRIGGER IF EXISTS plan_guidance_validity_time ON SCHEMANAME.plan_guidance;

CREATE OR REPLACE TRIGGER plan_guidance_validity_time
    BEFORE INSERT OR UPDATE 
    ON SCHEMANAME.plan_guidance
    FOR EACH ROW
    EXECUTE FUNCTION SCHEMANAME.validity_to_daterange();

-- Trigger: upsert_creator_and_modifier_trigger

-- DROP TRIGGER IF EXISTS upsert_creator_and_modifier_trigger ON SCHEMANAME.plan_guidance;

CREATE OR REPLACE TRIGGER upsert_creator_and_modifier_trigger
    BEFORE INSERT OR UPDATE 
    ON SCHEMANAME.plan_guidance
    FOR EACH ROW
    EXECUTE FUNCTION SCHEMANAME.upsert_creator_and_modifier_trigger();


-- Table: SCHEMANAME.plan_guidance_document

-- DROP TABLE IF EXISTS SCHEMANAME.plan_guidance_document;

CREATE TABLE IF NOT EXISTS SCHEMANAME.plan_guidance_document
(
    id integer NOT NULL DEFAULT nextval('SCHEMANAME.plan_guidance_document_id_seq'::regclass),
    plan_guidance_local_id character varying COLLATE pg_catalog."default" NOT NULL,
    document_local_id character varying COLLATE pg_catalog."default" NOT NULL,
    role jsonb,
    CONSTRAINT plan_guidance_document_pkey PRIMARY KEY (id),
    CONSTRAINT plan_guidance_document_plan_guidance_local_id_document_loca_key UNIQUE (plan_guidance_local_id, document_local_id),
    CONSTRAINT plan_guidance_document_fk_document FOREIGN KEY (document_local_id)
        REFERENCES SCHEMANAME.document (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT plan_guidance_document_fk_plan_guidance FOREIGN KEY (plan_guidance_local_id)
        REFERENCES SCHEMANAME.plan_guidance (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT plan_guidance_document_role_check CHECK (check_language_string(role))
)

-- Table: SCHEMANAME.plan_guidance_theme

-- DROP TABLE IF EXISTS SCHEMANAME.plan_guidance_theme;

CREATE TABLE IF NOT EXISTS SCHEMANAME.plan_guidance_theme
(
    id integer NOT NULL DEFAULT nextval('SCHEMANAME.plan_guidance_theme_id_seq'::regclass),
    plan_guidance_local_id character varying COLLATE pg_catalog."default" NOT NULL,
    theme_code character varying COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT plan_guidance_theme_pkey PRIMARY KEY (id),
    CONSTRAINT plan_guidance_theme_plan_guidance_local_id_theme_code_key UNIQUE (plan_guidance_local_id, theme_code),
    CONSTRAINT plan_guidance_theme_fk_plan_guidance FOREIGN KEY (plan_guidance_local_id)
        REFERENCES SCHEMANAME.plan_guidance (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT plan_guidance_theme_fk_theme FOREIGN KEY (theme_code)
        REFERENCES code_lists.detail_plan_theme (codevalue) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE NO ACTION
        DEFERRABLE INITIALLY DEFERRED
)

-- Table: SCHEMANAME.plan_regulation

-- DROP TABLE IF EXISTS SCHEMANAME.plan_regulation;

CREATE TABLE IF NOT EXISTS SCHEMANAME.plan_regulation
(
    id integer NOT NULL DEFAULT nextval('SCHEMANAME.plan_regulation_id_seq'::regclass),
    local_id character varying COLLATE pg_catalog."default" NOT NULL DEFAULT uuid_generate_v4(),
    identity_id uuid NOT NULL DEFAULT uuid_generate_v4(),
    namespace character varying COLLATE pg_catalog."default",
    reference_id character varying COLLATE pg_catalog."default",
    latest_change timestamp without time zone NOT NULL DEFAULT now(),
    producer_specific_id uuid DEFAULT uuid_generate_v4(),
    storage_time timestamp without time zone,
    name jsonb,
    type character varying COLLATE pg_catalog."default" NOT NULL,
    life_cycle_status character varying COLLATE pg_catalog."default" NOT NULL,
    validity_time daterange,
    valid_from date,
    valid_to date,
    created timestamp without time zone NOT NULL DEFAULT now(),
    created_by text COLLATE pg_catalog."default" NOT NULL,
    modified_by text COLLATE pg_catalog."default" NOT NULL,
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
)

-- Trigger: plan_regulation_modified_trigger

-- DROP TRIGGER IF EXISTS plan_regulation_modified_trigger ON SCHEMANAME.plan_regulation;

CREATE OR REPLACE TRIGGER plan_regulation_modified_trigger
    BEFORE INSERT OR UPDATE 
    ON SCHEMANAME.plan_regulation
    FOR EACH ROW
    EXECUTE FUNCTION public.versioned_object_modified_trigger();

-- Trigger: plan_regulation_refresh_area_view

-- DROP TRIGGER IF EXISTS plan_regulation_refresh_area_view ON SCHEMANAME.plan_regulation;

CREATE OR REPLACE TRIGGER plan_regulation_refresh_area_view
    AFTER INSERT OR DELETE
    ON SCHEMANAME.plan_regulation
    FOR EACH ROW
    EXECUTE FUNCTION SCHEMANAME.refresh_plan_regulations_area_view();

-- Trigger: plan_regulation_refresh_area_view_on_update

-- DROP TRIGGER IF EXISTS plan_regulation_refresh_area_view_on_update ON SCHEMANAME.plan_regulation;

CREATE OR REPLACE TRIGGER plan_regulation_refresh_area_view_on_update
    AFTER UPDATE 
    ON SCHEMANAME.plan_regulation
    FOR EACH ROW
    WHEN (old.type::text IS DISTINCT FROM new.type::text)
    EXECUTE FUNCTION SCHEMANAME.refresh_plan_regulations_area_view();

-- Trigger: plan_regulation_refresh_line_view

-- DROP TRIGGER IF EXISTS plan_regulation_refresh_line_view ON SCHEMANAME.plan_regulation;

CREATE OR REPLACE TRIGGER plan_regulation_refresh_line_view
    AFTER INSERT OR DELETE
    ON SCHEMANAME.plan_regulation
    FOR EACH ROW
    EXECUTE FUNCTION SCHEMANAME.refresh_plan_regulations_line_view();

-- Trigger: plan_regulation_refresh_line_view_on_update

-- DROP TRIGGER IF EXISTS plan_regulation_refresh_line_view_on_update ON SCHEMANAME.plan_regulation;

CREATE OR REPLACE TRIGGER plan_regulation_refresh_line_view_on_update
    AFTER UPDATE 
    ON SCHEMANAME.plan_regulation
    FOR EACH ROW
    WHEN (old.type::text IS DISTINCT FROM new.type::text)
    EXECUTE FUNCTION SCHEMANAME.refresh_plan_regulations_line_view();

-- Trigger: plan_regulation_refresh_point_view

-- DROP TRIGGER IF EXISTS plan_regulation_refresh_point_view ON SCHEMANAME.plan_regulation;

CREATE OR REPLACE TRIGGER plan_regulation_refresh_point_view
    AFTER INSERT OR DELETE
    ON SCHEMANAME.plan_regulation
    FOR EACH ROW
    EXECUTE FUNCTION SCHEMANAME.refresh_plan_regulations_point_view();

-- Trigger: plan_regulation_refresh_point_view_on_update

-- DROP TRIGGER IF EXISTS plan_regulation_refresh_point_view_on_update ON SCHEMANAME.plan_regulation;

CREATE OR REPLACE TRIGGER plan_regulation_refresh_point_view_on_update
    AFTER UPDATE 
    ON SCHEMANAME.plan_regulation
    FOR EACH ROW
    WHEN (old.type::text IS DISTINCT FROM new.type::text)
    EXECUTE FUNCTION SCHEMANAME.refresh_plan_regulations_point_view();

-- Trigger: plan_regulation_validity_time

-- DROP TRIGGER IF EXISTS plan_regulation_validity_time ON SCHEMANAME.plan_regulation;

CREATE OR REPLACE TRIGGER plan_regulation_validity_time
    BEFORE INSERT OR UPDATE 
    ON SCHEMANAME.plan_regulation
    FOR EACH ROW
    EXECUTE FUNCTION SCHEMANAME.validity_to_daterange();

-- Trigger: upsert_creator_and_modifier_trigger

-- DROP TRIGGER IF EXISTS upsert_creator_and_modifier_trigger ON SCHEMANAME.plan_regulation;

CREATE OR REPLACE TRIGGER upsert_creator_and_modifier_trigger
    BEFORE INSERT OR UPDATE 
    ON SCHEMANAME.plan_regulation
    FOR EACH ROW
    EXECUTE FUNCTION SCHEMANAME.upsert_creator_and_modifier_trigger();


-- Table: SCHEMANAME.plan_regulation_document

-- DROP TABLE IF EXISTS SCHEMANAME.plan_regulation_document;

CREATE TABLE IF NOT EXISTS SCHEMANAME.plan_regulation_document
(
    id integer NOT NULL DEFAULT nextval('SCHEMANAME.plan_regulation_document_id_seq'::regclass),
    plan_regulation_local_id character varying COLLATE pg_catalog."default" NOT NULL,
    document_local_id character varying COLLATE pg_catalog."default" NOT NULL,
    role jsonb,
    CONSTRAINT plan_regulation_document_pkey PRIMARY KEY (id),
    CONSTRAINT plan_regulation_document_plan_regulation_local_id_document__key UNIQUE (plan_regulation_local_id, document_local_id),
    CONSTRAINT plan_regulation_document_fk_document FOREIGN KEY (document_local_id)
        REFERENCES SCHEMANAME.document (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT plan_regulation_document_fk_plan_regulation FOREIGN KEY (plan_regulation_local_id)
        REFERENCES SCHEMANAME.plan_regulation (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT plan_regulation_document_role_check CHECK (check_language_string(role))
)


-- Table: SCHEMANAME.plan_regulation_group

-- DROP TABLE IF EXISTS SCHEMANAME.plan_regulation_group;

CREATE TABLE IF NOT EXISTS SCHEMANAME.plan_regulation_group
(
    id integer NOT NULL DEFAULT nextval('SCHEMANAME.plan_regulation_group_id_seq'::regclass),
    local_id character varying COLLATE pg_catalog."default" NOT NULL DEFAULT uuid_generate_v4(),
    identity_id uuid NOT NULL DEFAULT uuid_generate_v4(),
    namespace character varying COLLATE pg_catalog."default",
    reference_id character varying COLLATE pg_catalog."default",
    latest_change timestamp without time zone NOT NULL DEFAULT now(),
    producer_specific_id uuid DEFAULT uuid_generate_v4(),
    storage_time timestamp without time zone NOT NULL DEFAULT now(),
    name jsonb,
    group_number integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    CONSTRAINT plan_regulation_group_pkey PRIMARY KEY (id),
    CONSTRAINT plan_regulation_group_local_id_key UNIQUE (local_id),
    CONSTRAINT plan_regulation_group_name_check CHECK (check_language_string(name))
)


-- Trigger: plan_regulation_group_modified_trigger

-- DROP TRIGGER IF EXISTS plan_regulation_group_modified_trigger ON SCHEMANAME.plan_regulation_group;

CREATE OR REPLACE TRIGGER plan_regulation_group_modified_trigger
    BEFORE INSERT OR UPDATE 
    ON SCHEMANAME.plan_regulation_group
    FOR EACH ROW
    EXECUTE FUNCTION public.versioned_object_modified_trigger();

-- Table: SCHEMANAME.plan_regulation_group_regulation

-- DROP TABLE IF EXISTS SCHEMANAME.plan_regulation_group_regulation;

CREATE TABLE IF NOT EXISTS SCHEMANAME.plan_regulation_group_regulation
(
    id integer NOT NULL DEFAULT nextval('SCHEMANAME.plan_regulation_group_regulation_id_seq'::regclass),
    plan_regulation_group_local_id character varying COLLATE pg_catalog."default" NOT NULL,
    plan_regulation_local_id character varying COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT plan_regulation_group_regulation_pkey PRIMARY KEY (id),
    CONSTRAINT plan_regulation_group_regulat_plan_regulation_group_local_i_key UNIQUE (plan_regulation_group_local_id, plan_regulation_local_id),
    CONSTRAINT plan_regulation_group_regulation_fk_plan_regulation FOREIGN KEY (plan_regulation_local_id)
        REFERENCES SCHEMANAME.plan_regulation (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT plan_regulation_group_regulation_fk_plan_regulation_group FOREIGN KEY (plan_regulation_group_local_id)
        REFERENCES SCHEMANAME.plan_regulation_group (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED
)

-- Table: SCHEMANAME.plan_regulation_supplementary_information

-- DROP TABLE IF EXISTS SCHEMANAME.plan_regulation_supplementary_information;

CREATE TABLE IF NOT EXISTS SCHEMANAME.plan_regulation_supplementary_information
(
    id integer NOT NULL DEFAULT nextval('SCHEMANAME.plan_regulation_supplementary_information_id_seq'::regclass),
    fk_plan_regulation character varying COLLATE pg_catalog."default" NOT NULL,
    fk_supplementary_information uuid NOT NULL,
    CONSTRAINT plan_regulation_supplementary_information_pkey PRIMARY KEY (id),
    CONSTRAINT plan_regulation_supplementary_fk_plan_regulation_fk_supplem_key UNIQUE (fk_plan_regulation, fk_supplementary_information),
    CONSTRAINT fk_plan_regulation FOREIGN KEY (fk_plan_regulation)
        REFERENCES SCHEMANAME.plan_regulation (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT fk_supplementary_information FOREIGN KEY (fk_supplementary_information)
        REFERENCES SCHEMANAME.supplementary_information (producer_specific_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED
)

-- Table: SCHEMANAME.plan_regulation_theme

-- DROP TABLE IF EXISTS SCHEMANAME.plan_regulation_theme;

CREATE TABLE IF NOT EXISTS SCHEMANAME.plan_regulation_theme
(
    id integer NOT NULL DEFAULT nextval('SCHEMANAME.plan_regulation_theme_id_seq'::regclass),
    plan_regulation_local_id character varying COLLATE pg_catalog."default" NOT NULL,
    theme_code character varying COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT plan_regulation_theme_pkey PRIMARY KEY (id),
    CONSTRAINT plan_regulation_theme_plan_regulation_local_id_theme_code_key UNIQUE (plan_regulation_local_id, theme_code),
    CONSTRAINT plan_regulation_theme_fk_plan_regulation FOREIGN KEY (plan_regulation_local_id)
        REFERENCES SCHEMANAME.plan_regulation (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT plan_regulation_theme_fk_theme FOREIGN KEY (theme_code)
        REFERENCES code_lists.detail_plan_theme (codevalue) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE NO ACTION
        DEFERRABLE INITIALLY DEFERRED
)

-- Table: SCHEMANAME.planned_space

-- DROP TABLE IF EXISTS SCHEMANAME.planned_space;

CREATE TABLE IF NOT EXISTS SCHEMANAME.planned_space
(
    identifier integer NOT NULL DEFAULT nextval('SCHEMANAME.planned_space_identifier_seq'::regclass),
    producer_specific_id uuid NOT NULL DEFAULT uuid_generate_v4(),
    geom geometry(MultiPolygon,PROJECTSRID) NOT NULL,
    storage_time timestamp without time zone,
    valid_from date,
    valid_to date,
    bindingness_of_location character varying(3) COLLATE pg_catalog."default" NOT NULL,
    ground_relative_position character varying(3) COLLATE pg_catalog."default" NOT NULL,
    identity_id uuid NOT NULL DEFAULT uuid_generate_v4(),
    local_id character varying COLLATE pg_catalog."default" NOT NULL DEFAULT uuid_generate_v4(),
    namespace character varying COLLATE pg_catalog."default",
    reference_id character varying COLLATE pg_catalog."default",
    latest_change timestamp without time zone NOT NULL DEFAULT now(),
    validity_time daterange,
    created timestamp without time zone NOT NULL DEFAULT now(),
    created_by text COLLATE pg_catalog."default" NOT NULL,
    modified_by text COLLATE pg_catalog."default" NOT NULL,
    modified_at timestamp without time zone NOT NULL,
    lifecycle_status character varying(3) COLLATE pg_catalog."default" NOT NULL DEFAULT '01'::character varying,
    is_active boolean DEFAULT true,
    CONSTRAINT planned_space_pkey PRIMARY KEY (identifier),
    CONSTRAINT planned_space_local_id_key UNIQUE (local_id),
    CONSTRAINT planned_space_planning_object_identifier_key UNIQUE (producer_specific_id),
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
)

-- Index: sidx_planned_space_geom

-- DROP INDEX IF EXISTS SCHEMANAME.sidx_planned_space_geom;

CREATE INDEX IF NOT EXISTS sidx_planned_space_geom
    ON SCHEMANAME.planned_space USING gist
    (geom)
    TABLESPACE pg_default;

-- Trigger: delete_geom_relations

-- DROP TRIGGER IF EXISTS delete_geom_relations ON SCHEMANAME.planned_space;

CREATE OR REPLACE TRIGGER delete_geom_relations
    BEFORE UPDATE OF geom
    ON SCHEMANAME.planned_space
    FOR EACH ROW
    WHEN (old.geom IS DISTINCT FROM new.geom)
    EXECUTE FUNCTION SCHEMANAME.delete_geom_relations();

-- Trigger: geom_relations

-- DROP TRIGGER IF EXISTS geom_relations ON SCHEMANAME.planned_space;

CREATE OR REPLACE TRIGGER geom_relations
    AFTER INSERT OR UPDATE OF geom
    ON SCHEMANAME.planned_space
    FOR EACH STATEMENT
    EXECUTE FUNCTION SCHEMANAME.geom_relations();

-- Trigger: inherit_validity

-- DROP TRIGGER IF EXISTS inherit_validity ON SCHEMANAME.planned_space;

CREATE OR REPLACE TRIGGER inherit_validity
    AFTER INSERT
    ON SCHEMANAME.planned_space
    FOR EACH STATEMENT
    EXECUTE FUNCTION SCHEMANAME.inherit_validity();

-- Trigger: planned_space_modified_trigger

-- DROP TRIGGER IF EXISTS planned_space_modified_trigger ON SCHEMANAME.planned_space;

CREATE OR REPLACE TRIGGER planned_space_modified_trigger
    BEFORE INSERT OR UPDATE 
    ON SCHEMANAME.planned_space
    FOR EACH ROW
    EXECUTE FUNCTION public.versioned_object_modified_trigger();

-- Trigger: planned_space_refresh_area_view

-- DROP TRIGGER IF EXISTS planned_space_refresh_area_view ON SCHEMANAME.planned_space;

CREATE OR REPLACE TRIGGER planned_space_refresh_area_view
    AFTER INSERT OR DELETE
    ON SCHEMANAME.planned_space
    FOR EACH ROW
    EXECUTE FUNCTION SCHEMANAME.refresh_plan_regulations_area_view();

-- Trigger: planned_space_refresh_area_view_on_update

-- DROP TRIGGER IF EXISTS planned_space_refresh_area_view_on_update ON SCHEMANAME.planned_space;

CREATE OR REPLACE TRIGGER planned_space_refresh_area_view_on_update
    AFTER UPDATE 
    ON SCHEMANAME.planned_space
    FOR EACH ROW
    WHEN (old.geom IS DISTINCT FROM new.geom)
    EXECUTE FUNCTION SCHEMANAME.refresh_plan_regulations_area_view();

-- Trigger: planned_space_validity_time

-- DROP TRIGGER IF EXISTS planned_space_validity_time ON SCHEMANAME.planned_space;

CREATE OR REPLACE TRIGGER planned_space_validity_time
    BEFORE INSERT OR UPDATE 
    ON SCHEMANAME.planned_space
    FOR EACH ROW
    EXECUTE FUNCTION SCHEMANAME.validity_to_daterange();

-- Trigger: update_validity

-- DROP TRIGGER IF EXISTS update_validity ON SCHEMANAME.planned_space;

CREATE OR REPLACE TRIGGER update_validity
    AFTER INSERT OR UPDATE 
    ON SCHEMANAME.planned_space
    FOR EACH STATEMENT
    WHEN (pg_trigger_depth() < 1)
    EXECUTE FUNCTION SCHEMANAME.update_validity();

-- Trigger: upsert_creator_and_modifier_trigger

-- DROP TRIGGER IF EXISTS upsert_creator_and_modifier_trigger ON SCHEMANAME.planned_space;

CREATE OR REPLACE TRIGGER upsert_creator_and_modifier_trigger
    BEFORE INSERT OR UPDATE 
    ON SCHEMANAME.planned_space
    FOR EACH ROW
    EXECUTE FUNCTION SCHEMANAME.upsert_creator_and_modifier_trigger();

-- Trigger: validate_planned_space_geom

-- DROP TRIGGER IF EXISTS validate_planned_space_geom ON SCHEMANAME.planned_space;

CREATE OR REPLACE TRIGGER validate_planned_space_geom
    BEFORE INSERT OR UPDATE OF geom
    ON SCHEMANAME.planned_space
    FOR EACH ROW
    EXECUTE FUNCTION SCHEMANAME.validate_geometry();

-- Trigger: validate_planned_space_topology

-- DROP TRIGGER IF EXISTS validate_planned_space_topology ON SCHEMANAME.planned_space;

CREATE CONSTRAINT TRIGGER validate_planned_space_topology
    AFTER INSERT OR UPDATE OF geom
    ON SCHEMANAME.planned_space
    DEFERRABLE INITIALLY DEFERRED
    FOR EACH ROW
    EXECUTE FUNCTION SCHEMANAME.validate_planned_space_geom();
	
	
-- Table: SCHEMANAME.planned_space_numeric_value

-- DROP TABLE IF EXISTS SCHEMANAME.planned_space_numeric_value;

CREATE TABLE IF NOT EXISTS SCHEMANAME.planned_space_numeric_value
(
    identifier integer NOT NULL DEFAULT nextval('SCHEMANAME.planned_space_numeric_value_identifier_seq'::regclass),
    planned_space_id uuid NOT NULL,
    numeric_id uuid NOT NULL,
    CONSTRAINT planned_space_numeric_value_pkey PRIMARY KEY (identifier),
    CONSTRAINT planned_space_numeric_value_key UNIQUE (planned_space_id, numeric_id),
    CONSTRAINT numeric_value_planned_space_fk FOREIGN KEY (numeric_id)
        REFERENCES SCHEMANAME.numeric_value (numeric_value_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT planned_space_numeric_value_fk FOREIGN KEY (planned_space_id)
        REFERENCES SCHEMANAME.planned_space (producer_specific_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED
)

-- Table: SCHEMANAME.planned_space_plan_detail_line

-- DROP TABLE IF EXISTS SCHEMANAME.planned_space_plan_detail_line;

CREATE TABLE IF NOT EXISTS SCHEMANAME.planned_space_plan_detail_line
(
    identifier integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    planned_space_local_id character varying COLLATE pg_catalog."default" NOT NULL,
    planning_detail_line_local_id character varying COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT planned_space_detail_line_pkey PRIMARY KEY (identifier),
    CONSTRAINT planned_space_plan_detail_line_fk_planned_space FOREIGN KEY (planned_space_local_id)
        REFERENCES SCHEMANAME.planned_space (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT planned_space_plan_detail_line_fk_planning_detail_line FOREIGN KEY (planning_detail_line_local_id)
        REFERENCES SCHEMANAME.planning_detail_line (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED
)


-- Table: SCHEMANAME.planned_space_plan_regulation_group

-- DROP TABLE IF EXISTS SCHEMANAME.planned_space_plan_regulation_group;

CREATE TABLE IF NOT EXISTS SCHEMANAME.planned_space_plan_regulation_group
(
    id integer NOT NULL DEFAULT nextval('SCHEMANAME.planned_space_plan_regulation_group_id_seq'::regclass),
    planned_space_local_id character varying COLLATE pg_catalog."default" NOT NULL,
    plan_regulation_group_local_id character varying COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT planned_space_plan_regulation_group_pkey PRIMARY KEY (id),
    CONSTRAINT planned_space_plan_regulation_planned_space_local_id_plan_r_key UNIQUE (planned_space_local_id, plan_regulation_group_local_id),
    CONSTRAINT planned_space_plan_regulation_group_fk_plan_regulation_group FOREIGN KEY (plan_regulation_group_local_id)
        REFERENCES SCHEMANAME.plan_regulation_group (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT planned_space_plan_regulation_group_fk_planned_space FOREIGN KEY (planned_space_local_id)
        REFERENCES SCHEMANAME.planned_space (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED
)

-- Table: SCHEMANAME.planned_space_regulation

-- DROP TABLE IF EXISTS SCHEMANAME.planned_space_regulation;

CREATE TABLE IF NOT EXISTS SCHEMANAME.planned_space_regulation
(
    identifier integer NOT NULL DEFAULT nextval('SCHEMANAME.planned_space_regulation_identifier_seq'::regclass),
    planned_space_id uuid NOT NULL,
    regulative_id uuid NOT NULL,
    CONSTRAINT planned_space_regulation_pkey PRIMARY KEY (identifier),
    CONSTRAINT planned_space_regulation_key UNIQUE (planned_space_id, regulative_id),
    CONSTRAINT planned_space_regulation_fkey FOREIGN KEY (planned_space_id)
        REFERENCES SCHEMANAME.planned_space (producer_specific_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT regulative_id_planned_space_fkey FOREIGN KEY (regulative_id)
        REFERENCES SCHEMANAME.regulative_text (regulative_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED
)

-- Table: SCHEMANAME.planner

-- DROP TABLE IF EXISTS SCHEMANAME.planner;

CREATE TABLE IF NOT EXISTS SCHEMANAME.planner
(
    identifier integer NOT NULL DEFAULT nextval('SCHEMANAME.contact_identifier_seq'::regclass),
    name character varying COLLATE pg_catalog."default" NOT NULL,
    professional_title jsonb,
    role jsonb,
    identity_id uuid NOT NULL DEFAULT uuid_generate_v4(),
    local_id character varying COLLATE pg_catalog."default" NOT NULL,
    namespace character varying COLLATE pg_catalog."default",
    reference_id character varying COLLATE pg_catalog."default",
    latest_change timestamp without time zone NOT NULL DEFAULT now(),
    storage_time timestamp without time zone NOT NULL DEFAULT now(),
    producer_specific_id uuid NOT NULL DEFAULT uuid_generate_v4(),
    fk_spatial_plan text COLLATE pg_catalog."default",
    CONSTRAINT contact_pkey PRIMARY KEY (identifier),
    CONSTRAINT planner_local_id_key UNIQUE (local_id),
    CONSTRAINT planner_fk_spatial_plan FOREIGN KEY (fk_spatial_plan)
        REFERENCES SCHEMANAME.spatial_plan (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT contact_name_check CHECK (name::text <> ''::text),
    CONSTRAINT planner_professional_title_check CHECK (check_language_string(professional_title)),
    CONSTRAINT planner_role_check CHECK (check_language_string(role))
)

-- Trigger: create_planner_local_id_trigger

-- DROP TRIGGER IF EXISTS create_planner_local_id_trigger ON SCHEMANAME.planner;

CREATE OR REPLACE TRIGGER create_planner_local_id_trigger
    BEFORE INSERT
    ON SCHEMANAME.planner
    FOR EACH ROW
    EXECUTE FUNCTION public.create_local_id_trigger();

-- Trigger: planner_modified_trigger

-- DROP TRIGGER IF EXISTS planner_modified_trigger ON SCHEMANAME.planner;

CREATE OR REPLACE TRIGGER planner_modified_trigger
    BEFORE INSERT OR UPDATE 
    ON SCHEMANAME.planner
    FOR EACH ROW
    EXECUTE FUNCTION public.versioned_object_modified_trigger();

-- Table: SCHEMANAME.planning_detail_line

-- DROP TABLE IF EXISTS SCHEMANAME.planning_detail_line;

CREATE TABLE IF NOT EXISTS SCHEMANAME.planning_detail_line
(
    identifier integer NOT NULL DEFAULT nextval('SCHEMANAME.planning_detail_line_identifier_seq'::regclass),
    producer_specific_id uuid NOT NULL DEFAULT uuid_generate_v4(),
    storage_time timestamp without time zone,
    geom geometry(MultiLineString,PROJECTSRID) NOT NULL,
    identity_id uuid NOT NULL DEFAULT uuid_generate_v4(),
    local_id character varying COLLATE pg_catalog."default" NOT NULL DEFAULT uuid_generate_v4(),
    namespace character varying COLLATE pg_catalog."default",
    reference_id character varying COLLATE pg_catalog."default",
    latest_change timestamp without time zone NOT NULL DEFAULT now(),
    created timestamp without time zone NOT NULL DEFAULT now(),
    created_by text COLLATE pg_catalog."default" NOT NULL,
    modified_by text COLLATE pg_catalog."default" NOT NULL,
    modified_at timestamp without time zone NOT NULL,
    bindingness_of_location character varying(2) COLLATE pg_catalog."default" NOT NULL,
    ground_relative_position character varying(2) COLLATE pg_catalog."default" NOT NULL,
    lifecycle_status character varying(3) COLLATE pg_catalog."default" NOT NULL DEFAULT '01'::character varying,
    name jsonb,
    is_active boolean DEFAULT true,
    CONSTRAINT planning_detail_line_pkey PRIMARY KEY (identifier),
    CONSTRAINT planning_detail_line_local_id_key UNIQUE (local_id),
    CONSTRAINT planning_detail_line_planning_object_identifier_key UNIQUE (producer_specific_id),
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
)

-- Index: sidx_planning_detail_line_geom

-- DROP INDEX IF EXISTS SCHEMANAME.sidx_planning_detail_line_geom;

CREATE INDEX IF NOT EXISTS sidx_planning_detail_line_geom
    ON SCHEMANAME.planning_detail_line USING gist
    (geom)
    TABLESPACE pg_default;

-- Trigger: delete_geom_relations

-- DROP TRIGGER IF EXISTS delete_geom_relations ON SCHEMANAME.planning_detail_line;

CREATE OR REPLACE TRIGGER delete_geom_relations
    BEFORE UPDATE OF geom
    ON SCHEMANAME.planning_detail_line
    FOR EACH ROW
    WHEN (old.geom IS DISTINCT FROM new.geom)
    EXECUTE FUNCTION SCHEMANAME.delete_geom_relations();

-- Trigger: geom_relations

-- DROP TRIGGER IF EXISTS geom_relations ON SCHEMANAME.planning_detail_line;

CREATE OR REPLACE TRIGGER geom_relations
    AFTER INSERT OR UPDATE OF geom
    ON SCHEMANAME.planning_detail_line
    FOR EACH STATEMENT
    EXECUTE FUNCTION SCHEMANAME.geom_relations();

-- Trigger: planning_detail_line_modified_trigger

-- DROP TRIGGER IF EXISTS planning_detail_line_modified_trigger ON SCHEMANAME.planning_detail_line;

CREATE OR REPLACE TRIGGER planning_detail_line_modified_trigger
    BEFORE INSERT OR UPDATE 
    ON SCHEMANAME.planning_detail_line
    FOR EACH ROW
    EXECUTE FUNCTION public.versioned_object_modified_trigger();

-- Trigger: planning_detail_line_refresh_line_view

-- DROP TRIGGER IF EXISTS planning_detail_line_refresh_line_view ON SCHEMANAME.planning_detail_line;

CREATE OR REPLACE TRIGGER planning_detail_line_refresh_line_view
    AFTER INSERT OR DELETE
    ON SCHEMANAME.planning_detail_line
    FOR EACH ROW
    EXECUTE FUNCTION SCHEMANAME.refresh_plan_regulations_line_view();

-- Trigger: planning_detail_line_refresh_line_view_on_update

-- DROP TRIGGER IF EXISTS planning_detail_line_refresh_line_view_on_update ON SCHEMANAME.planning_detail_line;

CREATE OR REPLACE TRIGGER planning_detail_line_refresh_line_view_on_update
    AFTER UPDATE 
    ON SCHEMANAME.planning_detail_line
    FOR EACH ROW
    WHEN (old.geom IS DISTINCT FROM new.geom)
    EXECUTE FUNCTION SCHEMANAME.refresh_plan_regulations_line_view();

-- Trigger: update_validity

-- DROP TRIGGER IF EXISTS update_validity ON SCHEMANAME.planning_detail_line;

CREATE OR REPLACE TRIGGER update_validity
    AFTER INSERT OR UPDATE 
    ON SCHEMANAME.planning_detail_line
    FOR EACH STATEMENT
    WHEN (pg_trigger_depth() < 1)
    EXECUTE FUNCTION SCHEMANAME.update_validity();

-- Trigger: upsert_creator_and_modifier_trigger

-- DROP TRIGGER IF EXISTS upsert_creator_and_modifier_trigger ON SCHEMANAME.planning_detail_line;

CREATE OR REPLACE TRIGGER upsert_creator_and_modifier_trigger
    BEFORE INSERT OR UPDATE 
    ON SCHEMANAME.planning_detail_line
    FOR EACH ROW
    EXECUTE FUNCTION SCHEMANAME.upsert_creator_and_modifier_trigger();

-- Trigger: validate_planning_detail_line_geom

-- DROP TRIGGER IF EXISTS validate_planning_detail_line_geom ON SCHEMANAME.planning_detail_line;

CREATE OR REPLACE TRIGGER validate_planning_detail_line_geom
    BEFORE INSERT OR UPDATE OF geom
    ON SCHEMANAME.planning_detail_line
    FOR EACH ROW
    EXECUTE FUNCTION SCHEMANAME.validate_geometry();


-- Table: SCHEMANAME.planning_detail_line_numeric_value

-- DROP TABLE IF EXISTS SCHEMANAME.planning_detail_line_numeric_value;

CREATE TABLE IF NOT EXISTS SCHEMANAME.planning_detail_line_numeric_value
(
    identifier integer NOT NULL DEFAULT nextval('SCHEMANAME.planning_detail_line_numeric_value_identifier_seq'::regclass),
    planning_detail_line_id uuid NOT NULL,
    numeric_id uuid NOT NULL,
    CONSTRAINT planning_detail_line_numeric_value_pkey PRIMARY KEY (identifier),
    CONSTRAINT planning_detail_line_numeric_value_key UNIQUE (planning_detail_line_id, numeric_id),
    CONSTRAINT numeric_value_planning_detail_line_fk FOREIGN KEY (numeric_id)
        REFERENCES SCHEMANAME.numeric_value (numeric_value_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT planning_detail_line_value_fk FOREIGN KEY (planning_detail_line_id)
        REFERENCES SCHEMANAME.planning_detail_line (producer_specific_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED
)

-- Table: SCHEMANAME.planning_detail_line_plan_regulation_group

-- DROP TABLE IF EXISTS SCHEMANAME.planning_detail_line_plan_regulation_group;

CREATE TABLE IF NOT EXISTS SCHEMANAME.planning_detail_line_plan_regulation_group
(
    id integer NOT NULL DEFAULT nextval('SCHEMANAME.planning_detail_line_plan_regulation_group_id_seq'::regclass),
    planning_detail_line_local_id character varying COLLATE pg_catalog."default" NOT NULL,
    plan_regulation_group_local_id character varying COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT planning_detail_line_plan_regulation_group_pkey PRIMARY KEY (id),
    CONSTRAINT planning_detail_line_plan_reg_planning_detail_line_local_id_key UNIQUE (planning_detail_line_local_id, plan_regulation_group_local_id),
    CONSTRAINT planning_detail_line_plan_regulation_group_fk_plan_regulation_g FOREIGN KEY (plan_regulation_group_local_id)
        REFERENCES SCHEMANAME.plan_regulation_group (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT planning_detail_line_plan_regulation_group_fk_planning_detail_l FOREIGN KEY (planning_detail_line_local_id)
        REFERENCES SCHEMANAME.planning_detail_line (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED
)

-- Table: SCHEMANAME.planning_detail_point_numeric_value

-- DROP TABLE IF EXISTS SCHEMANAME.planning_detail_point_numeric_value;

CREATE TABLE IF NOT EXISTS SCHEMANAME.planning_detail_point_numeric_value
(
    identifier integer NOT NULL DEFAULT nextval('SCHEMANAME.planning_detail_point_numeric_value_identifier_seq'::regclass),
    planning_detail_point_id uuid NOT NULL,
    numeric_id uuid NOT NULL,
    CONSTRAINT planning_detail_point_numeric_value_pkey PRIMARY KEY (identifier),
    CONSTRAINT planning_detail_point_numeric_value_key UNIQUE (planning_detail_point_id, numeric_id),
    CONSTRAINT numeric_value_planning_detail_point_fk FOREIGN KEY (numeric_id)
        REFERENCES SCHEMANAME.numeric_value (numeric_value_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED
)

-- Table: SCHEMANAME.referenced_document

-- DROP TABLE IF EXISTS SCHEMANAME.referenced_document;

CREATE TABLE IF NOT EXISTS SCHEMANAME.referenced_document
(
    identifier integer NOT NULL DEFAULT nextval('SCHEMANAME.referenced_document_identifier_seq'::regclass),
    reference character varying COLLATE pg_catalog."default" NOT NULL,
    referenced_on date NOT NULL,
    name character varying COLLATE pg_catalog."default" NOT NULL,
    fk_spatial_plan uuid NOT NULL,
    language integer NOT NULL,
    role integer NOT NULL,
    type integer NOT NULL,
    CONSTRAINT referenced_document_pkey PRIMARY KEY (identifier),
    CONSTRAINT spatial_plan_document_fkey FOREIGN KEY (fk_spatial_plan)
        REFERENCES SCHEMANAME.spatial_plan (producer_specific_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED
)

-- Table: SCHEMANAME.regulative_text

-- DROP TABLE IF EXISTS SCHEMANAME.regulative_text;

CREATE TABLE IF NOT EXISTS SCHEMANAME.regulative_text
(
    identifier integer NOT NULL DEFAULT nextval('SCHEMANAME.regulative_text_identifier_seq'::regclass),
    regulative_id uuid NOT NULL DEFAULT uuid_generate_v4(),
    type integer NOT NULL,
    description_fi character varying COLLATE pg_catalog."default",
    description_se character varying COLLATE pg_catalog."default",
    validity integer NOT NULL DEFAULT 1,
    CONSTRAINT regulative_text_pkey PRIMARY KEY (identifier),
    CONSTRAINT regulative_text_regulative_id_key UNIQUE (regulative_id)
)

-- Table: SCHEMANAME.spatial_plan

-- DROP TABLE IF EXISTS SCHEMANAME.spatial_plan;

CREATE TABLE IF NOT EXISTS SCHEMANAME.spatial_plan
(
    identifier integer NOT NULL DEFAULT nextval('SCHEMANAME.spatial_plan_identifier_seq'::regclass),
    producer_specific_id uuid NOT NULL DEFAULT uuid_generate_v4(),
    geom geometry(MultiPolygon,PROJECTSRID) NOT NULL,
    storage_time timestamp without time zone,
    plan_id character varying COLLATE pg_catalog."default" NOT NULL DEFAULT (uuid_generate_v4())::text,
    approval_time date,
    approved_by integer,
    epsg character(9) COLLATE pg_catalog."default" NOT NULL DEFAULT 'EPSG:PROJECTSRID'::bpchar,
    vertical_coordinate_system integer,
    land_administration_authority character(3) COLLATE pg_catalog."default" NOT NULL DEFAULT 'MUNICIPALITYCODE'::bpchar,
    language integer NOT NULL,
    valid_from date,
    valid_to date,
    is_released boolean NOT NULL DEFAULT false,
    type character varying(3) COLLATE pg_catalog."default" NOT NULL,
    digital_origin character varying(3) COLLATE pg_catalog."default" NOT NULL,
    ground_relative_position character varying(3) COLLATE pg_catalog."default" NOT NULL,
    legal_effectiveness character varying(2) COLLATE pg_catalog."default" NOT NULL DEFAULT '01'::character varying,
    validity_time daterange,
    lifecycle_status character varying(3) COLLATE pg_catalog."default" NOT NULL DEFAULT '01'::character varying,
    name jsonb NOT NULL,
    identity_id uuid NOT NULL DEFAULT uuid_generate_v4(),
    local_id character varying COLLATE pg_catalog."default" NOT NULL DEFAULT uuid_generate_v4(),
    namespace character varying COLLATE pg_catalog."default",
    reference_id character varying COLLATE pg_catalog."default",
    latest_change timestamp without time zone NOT NULL DEFAULT now(),
    initiation_time date,
    created timestamp without time zone NOT NULL DEFAULT now(),
    created_by text COLLATE pg_catalog."default" NOT NULL,
    modified_by text COLLATE pg_catalog."default" NOT NULL,
    modified_at timestamp without time zone NOT NULL,
    is_active boolean NOT NULL DEFAULT true,
    version_name text COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT spatial_plan_pkey PRIMARY KEY (identifier),
    CONSTRAINT spatial_plan_local_id_key UNIQUE (local_id),
    CONSTRAINT spatial_plan_planning_object_identifier_key UNIQUE (producer_specific_id),
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
    CONSTRAINT spatial_plan_metadata_id_fk FOREIGN KEY (plan_id)
        REFERENCES SCHEMANAME.spatial_plan_metadata (plan_id) MATCH SIMPLE
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
    CONSTRAINT epsg_check CHECK (epsg ~ '^EPSG:PROJECTSRID$'::text),
    CONSTRAINT land_administration_authority_check CHECK (land_administration_authority ~ '^[0-9]{3}$'::text),
    CONSTRAINT spatial_plan_approval_check CHECK (
CASE
    WHEN approval_time IS NULL AND approved_by IS NOT NULL THEN false
    WHEN approval_time IS NOT NULL AND approved_by IS NULL THEN false
    ELSE true
END),
    CONSTRAINT spatial_plan_name_check CHECK (check_language_string(name))
)

-- Index: active_version_idx

-- DROP INDEX IF EXISTS SCHEMANAME.active_version_idx;

CREATE UNIQUE INDEX IF NOT EXISTS active_version_idx
    ON SCHEMANAME.spatial_plan USING btree
    (identity_id ASC NULLS LAST)
    TABLESPACE pg_default
    WHERE is_active;
-- Index: sidx_spatial_plan_geom

-- DROP INDEX IF EXISTS SCHEMANAME.sidx_spatial_plan_geom;

CREATE INDEX IF NOT EXISTS sidx_spatial_plan_geom
    ON SCHEMANAME.spatial_plan USING gist
    (geom)
    TABLESPACE pg_default;

-- Trigger: create_or_update_spatial_plan

-- DROP TRIGGER IF EXISTS create_or_update_spatial_plan ON SCHEMANAME.spatial_plan;

CREATE OR REPLACE TRIGGER create_or_update_spatial_plan
    BEFORE INSERT OR UPDATE 
    ON SCHEMANAME.spatial_plan
    FOR EACH ROW
    WHEN (pg_trigger_depth() < 1)
    EXECUTE FUNCTION SCHEMANAME.create_or_update_spatial_plan();

-- Trigger: delete_geom_relations

-- DROP TRIGGER IF EXISTS delete_geom_relations ON SCHEMANAME.spatial_plan;

CREATE OR REPLACE TRIGGER delete_geom_relations
    BEFORE UPDATE OF geom
    ON SCHEMANAME.spatial_plan
    FOR EACH ROW
    WHEN (old.geom IS DISTINCT FROM new.geom)
    EXECUTE FUNCTION SCHEMANAME.delete_geom_relations();

-- Trigger: geom_relations

-- DROP TRIGGER IF EXISTS geom_relations ON SCHEMANAME.spatial_plan;

CREATE OR REPLACE TRIGGER geom_relations
    AFTER INSERT OR UPDATE OF geom
    ON SCHEMANAME.spatial_plan
    FOR EACH STATEMENT
    EXECUTE FUNCTION SCHEMANAME.geom_relations();

-- Trigger: inherit_validity

-- DROP TRIGGER IF EXISTS inherit_validity ON SCHEMANAME.spatial_plan;

CREATE OR REPLACE TRIGGER inherit_validity
    AFTER INSERT OR UPDATE OF valid_from, valid_to
    ON SCHEMANAME.spatial_plan
    FOR EACH STATEMENT
    WHEN (pg_trigger_depth() < 1)
    EXECUTE FUNCTION SCHEMANAME.inherit_validity();

-- Trigger: insert_version_name_trigger

-- DROP TRIGGER IF EXISTS insert_version_name_trigger ON SCHEMANAME.spatial_plan;

CREATE OR REPLACE TRIGGER insert_version_name_trigger
    BEFORE INSERT
    ON SCHEMANAME.spatial_plan
    FOR EACH ROW
    WHEN (new.version_name IS NULL)
    EXECUTE FUNCTION SCHEMANAME.insert_version_name();

-- Trigger: spatial_plan_modified_trigger

-- DROP TRIGGER IF EXISTS spatial_plan_modified_trigger ON SCHEMANAME.spatial_plan;

CREATE OR REPLACE TRIGGER spatial_plan_modified_trigger
    BEFORE INSERT OR UPDATE 
    ON SCHEMANAME.spatial_plan
    FOR EACH ROW
    EXECUTE FUNCTION public.versioned_object_modified_trigger();

-- Trigger: spatial_plan_refresh_area_view

-- DROP TRIGGER IF EXISTS spatial_plan_refresh_area_view ON SCHEMANAME.spatial_plan;

CREATE OR REPLACE TRIGGER spatial_plan_refresh_area_view
    AFTER INSERT OR DELETE
    ON SCHEMANAME.spatial_plan
    FOR EACH ROW
    EXECUTE FUNCTION SCHEMANAME.refresh_plan_regulations_area_view();

-- Trigger: spatial_plan_refresh_area_view_on_update

-- DROP TRIGGER IF EXISTS spatial_plan_refresh_area_view_on_update ON SCHEMANAME.spatial_plan;

CREATE OR REPLACE TRIGGER spatial_plan_refresh_area_view_on_update
    AFTER UPDATE 
    ON SCHEMANAME.spatial_plan
    FOR EACH ROW
    WHEN (old.geom IS DISTINCT FROM new.geom)
    EXECUTE FUNCTION SCHEMANAME.refresh_plan_regulations_area_view();

-- Trigger: spatial_plan_validity_time

-- DROP TRIGGER IF EXISTS spatial_plan_validity_time ON SCHEMANAME.spatial_plan;

CREATE OR REPLACE TRIGGER spatial_plan_validity_time
    BEFORE INSERT OR UPDATE 
    ON SCHEMANAME.spatial_plan
    FOR EACH ROW
    EXECUTE FUNCTION SCHEMANAME.validity_to_daterange();

-- Trigger: update_validity

-- DROP TRIGGER IF EXISTS update_validity ON SCHEMANAME.spatial_plan;

CREATE OR REPLACE TRIGGER update_validity
    AFTER INSERT OR UPDATE 
    ON SCHEMANAME.spatial_plan
    FOR EACH STATEMENT
    WHEN (pg_trigger_depth() < 1)
    EXECUTE FUNCTION SCHEMANAME.update_validity();

-- Trigger: upsert_creator_and_modifier_trigger

-- DROP TRIGGER IF EXISTS upsert_creator_and_modifier_trigger ON SCHEMANAME.spatial_plan;

CREATE OR REPLACE TRIGGER upsert_creator_and_modifier_trigger
    BEFORE INSERT OR UPDATE 
    ON SCHEMANAME.spatial_plan
    FOR EACH ROW
    EXECUTE FUNCTION SCHEMANAME.upsert_creator_and_modifier_trigger();

-- Trigger: validate_spatial_plan_geom

-- DROP TRIGGER IF EXISTS validate_spatial_plan_geom ON SCHEMANAME.spatial_plan;

CREATE OR REPLACE TRIGGER validate_spatial_plan_geom
    BEFORE INSERT OR UPDATE OF geom
    ON SCHEMANAME.spatial_plan
    FOR EACH ROW
    EXECUTE FUNCTION SCHEMANAME.validate_geometry();

-- Trigger: validate_spatial_plan_topology

-- DROP TRIGGER IF EXISTS validate_spatial_plan_topology ON SCHEMANAME.spatial_plan;

CREATE CONSTRAINT TRIGGER validate_spatial_plan_topology
    AFTER INSERT OR UPDATE OF geom
    ON SCHEMANAME.spatial_plan
    DEFERRABLE INITIALLY DEFERRED
    FOR EACH ROW
    EXECUTE FUNCTION SCHEMANAME.validate_spatial_plan_topology();

-- Table: SCHEMANAME.spatial_plan_commentary

-- DROP TABLE IF EXISTS SCHEMANAME.spatial_plan_commentary;

CREATE TABLE IF NOT EXISTS SCHEMANAME.spatial_plan_commentary
(
    id integer NOT NULL DEFAULT nextval('SCHEMANAME.spatial_plan_commentary_id_seq'::regclass),
    producer_specific_id uuid NOT NULL DEFAULT uuid_generate_v4(),
    identity_id uuid NOT NULL DEFAULT uuid_generate_v4(),
    local_id character varying COLLATE pg_catalog."default" NOT NULL DEFAULT uuid_generate_v4(),
    namespace character varying COLLATE pg_catalog."default",
    reference_id character varying COLLATE pg_catalog."default",
    latest_change timestamp without time zone NOT NULL DEFAULT now(),
    storage_time timestamp without time zone NOT NULL DEFAULT now(),
    spatial_plan character varying COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT spatial_plan_commentary_pkey PRIMARY KEY (id),
    CONSTRAINT spatial_plan_commentary_local_id_key UNIQUE (local_id),
    CONSTRAINT spatial_plan_commentary_producer_specific_id_key UNIQUE (producer_specific_id),
    CONSTRAINT spatial_plan_commentary_spatial_plan_key UNIQUE (spatial_plan),
    CONSTRAINT spatial_plan_commentary_fk_spatial_plan FOREIGN KEY (spatial_plan)
        REFERENCES SCHEMANAME.spatial_plan (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED
)

-- Trigger: spatial_plan_commentary_modified_trigger

-- DROP TRIGGER IF EXISTS spatial_plan_commentary_modified_trigger ON SCHEMANAME.spatial_plan_commentary;

CREATE OR REPLACE TRIGGER spatial_plan_commentary_modified_trigger
    BEFORE INSERT OR UPDATE 
    ON SCHEMANAME.spatial_plan_commentary
    FOR EACH ROW
    EXECUTE FUNCTION public.versioned_object_modified_trigger();

-- Table: SCHEMANAME.spatial_plan_commentary_document

-- DROP TABLE IF EXISTS SCHEMANAME.spatial_plan_commentary_document;

CREATE TABLE IF NOT EXISTS SCHEMANAME.spatial_plan_commentary_document
(
    id integer NOT NULL DEFAULT nextval('SCHEMANAME.spatial_plan_commentary_document_id_seq'::regclass),
    spatial_plan_commentary_local_id character varying COLLATE pg_catalog."default" NOT NULL,
    document_local_id character varying COLLATE pg_catalog."default" NOT NULL,
    role jsonb,
    CONSTRAINT spatial_plan_commentary_document_pkey PRIMARY KEY (id),
    CONSTRAINT spatial_plan_commentary_document_fk_document FOREIGN KEY (document_local_id)
        REFERENCES SCHEMANAME.document (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT spatial_plan_commentary_document_fk_spatial_plan_commentary FOREIGN KEY (spatial_plan_commentary_local_id)
        REFERENCES SCHEMANAME.spatial_plan_commentary (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT spatial_plan_commentary_document_role_check CHECK (check_language_string(role))
)

-- Table: SCHEMANAME.spatial_plan_document

-- DROP TABLE IF EXISTS SCHEMANAME.spatial_plan_document;

CREATE TABLE IF NOT EXISTS SCHEMANAME.spatial_plan_document
(
    id integer NOT NULL DEFAULT nextval('SCHEMANAME.spatial_plan_document_id_seq'::regclass),
    spatial_plan_local_id character varying COLLATE pg_catalog."default" NOT NULL,
    document_local_id character varying COLLATE pg_catalog."default" NOT NULL,
    role jsonb,
    CONSTRAINT spatial_plan_document_pkey PRIMARY KEY (id),
    CONSTRAINT fk_document FOREIGN KEY (document_local_id)
        REFERENCES SCHEMANAME.document (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT fk_spatial_plan FOREIGN KEY (spatial_plan_local_id)
        REFERENCES SCHEMANAME.spatial_plan (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT spatial_plan_document_role_check CHECK (check_language_string(role))
)

-- Table: SCHEMANAME.spatial_plan_metadata

-- DROP TABLE IF EXISTS SCHEMANAME.spatial_plan_metadata;

CREATE TABLE IF NOT EXISTS SCHEMANAME.spatial_plan_metadata
(
    id integer NOT NULL DEFAULT nextval('SCHEMANAME.spatial_plan_metadata_id_seq'::regclass),
    plan_id text COLLATE pg_catalog."default" NOT NULL,
    name jsonb NOT NULL,
    created timestamp without time zone NOT NULL DEFAULT now(),
    CONSTRAINT spatial_plan_metadata_pkey PRIMARY KEY (id),
    CONSTRAINT spatial_plan_metadata_plan_id_key UNIQUE (plan_id),
    CONSTRAINT spatial_plan_metadata_name_check CHECK (check_language_string(name))
)

-- Trigger: create_or_update_spatial_plan

-- DROP TRIGGER IF EXISTS create_or_update_spatial_plan ON SCHEMANAME.spatial_plan_metadata;

CREATE OR REPLACE TRIGGER create_or_update_spatial_plan
    BEFORE UPDATE 
    ON SCHEMANAME.spatial_plan_metadata
    FOR EACH ROW
    WHEN (pg_trigger_depth() < 1)
    EXECUTE FUNCTION SCHEMANAME.create_or_update_spatial_plan();

-- Table: SCHEMANAME.spatial_plan_regulation

-- DROP TABLE IF EXISTS SCHEMANAME.spatial_plan_regulation;

CREATE TABLE IF NOT EXISTS SCHEMANAME.spatial_plan_regulation
(
    identifier integer NOT NULL DEFAULT nextval('SCHEMANAME.spatial_plan_regulation_identifier_seq'::regclass),
    spatial_plan_id uuid NOT NULL,
    regulative_id uuid NOT NULL,
    CONSTRAINT spatial_plan_regulation_pkey PRIMARY KEY (identifier),
    CONSTRAINT spatial_plan_regulation_key UNIQUE (spatial_plan_id, regulative_id),
    CONSTRAINT regulative_id_spatial_plan_fkey FOREIGN KEY (regulative_id)
        REFERENCES SCHEMANAME.regulative_text (regulative_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT spatial_plan_regulation_fkey FOREIGN KEY (spatial_plan_id)
        REFERENCES SCHEMANAME.spatial_plan (producer_specific_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED
)

-- Table: SCHEMANAME.supplementary_information

-- DROP TABLE IF EXISTS SCHEMANAME.supplementary_information;

CREATE TABLE IF NOT EXISTS SCHEMANAME.supplementary_information
(
    id integer NOT NULL DEFAULT nextval('SCHEMANAME.supplementary_information_id_seq'::regclass),
    producer_specific_id uuid DEFAULT uuid_generate_v4(),
    type character varying COLLATE pg_catalog."default" NOT NULL,
    name jsonb,
    fk_plan_regulation character varying COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT supplementary_information_pkey PRIMARY KEY (id),
    CONSTRAINT supplementary_information_producer_specific_id_key UNIQUE (producer_specific_id),
    CONSTRAINT supplementary_information_fk_plan_regulation FOREIGN KEY (fk_plan_regulation)
        REFERENCES SCHEMANAME.plan_regulation (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT supplementary_information_fk_type FOREIGN KEY (type)
        REFERENCES code_lists.detail_plan_addition_information_kind (codevalue) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE NO ACTION,
    CONSTRAINT supplementary_information_name_check CHECK (check_language_string(name))
)

-- Trigger: supplementary_information_refresh_area_view

-- DROP TRIGGER IF EXISTS supplementary_information_refresh_area_view ON SCHEMANAME.supplementary_information;

CREATE OR REPLACE TRIGGER supplementary_information_refresh_area_view
    AFTER INSERT OR DELETE OR UPDATE 
    ON SCHEMANAME.supplementary_information
    FOR EACH STATEMENT
    EXECUTE FUNCTION SCHEMANAME.refresh_plan_regulations_area_view();

-- Trigger: supplementary_information_refresh_line_view

-- DROP TRIGGER IF EXISTS supplementary_information_refresh_line_view ON SCHEMANAME.supplementary_information;

CREATE OR REPLACE TRIGGER supplementary_information_refresh_line_view
    AFTER INSERT OR DELETE OR UPDATE 
    ON SCHEMANAME.supplementary_information
    FOR EACH STATEMENT
    EXECUTE FUNCTION SCHEMANAME.refresh_plan_regulations_line_view();

-- Table: SCHEMANAME.text_value

-- DROP TABLE IF EXISTS SCHEMANAME.text_value;

CREATE TABLE IF NOT EXISTS SCHEMANAME.text_value
(
    id integer NOT NULL DEFAULT nextval('SCHEMANAME.text_value_id_seq'::regclass),
    text_value_uuid uuid NOT NULL DEFAULT uuid_generate_v4(),
    value jsonb NOT NULL,
    syntax character varying COLLATE pg_catalog."default",
    CONSTRAINT text_value_pkey PRIMARY KEY (id),
    CONSTRAINT text_value_text_value_uuid_key UNIQUE (text_value_uuid),
    CONSTRAINT text_value_value_check CHECK (check_language_string(value))
)

-- Trigger: text_value_refresh_area_view

-- DROP TRIGGER IF EXISTS text_value_refresh_area_view ON SCHEMANAME.text_value;

CREATE OR REPLACE TRIGGER text_value_refresh_area_view
    AFTER INSERT OR DELETE OR UPDATE 
    ON SCHEMANAME.text_value
    FOR EACH STATEMENT
    EXECUTE FUNCTION SCHEMANAME.refresh_plan_regulations_area_view();

-- Trigger: text_value_refresh_line_view

-- DROP TRIGGER IF EXISTS text_value_refresh_line_view ON SCHEMANAME.text_value;

CREATE OR REPLACE TRIGGER text_value_refresh_line_view
    AFTER INSERT OR DELETE OR UPDATE 
    ON SCHEMANAME.text_value
    FOR EACH STATEMENT
    EXECUTE FUNCTION SCHEMANAME.refresh_plan_regulations_line_view();
	
-- Table: SCHEMANAME.time_instant_value

-- DROP TABLE IF EXISTS SCHEMANAME.time_instant_value;

CREATE TABLE IF NOT EXISTS SCHEMANAME.time_instant_value
(
    id integer NOT NULL DEFAULT nextval('SCHEMANAME.time_instant_value_id_seq'::regclass),
    time_instant_uuid uuid NOT NULL DEFAULT uuid_generate_v4(),
    value timestamp without time zone NOT NULL,
    CONSTRAINT time_instant_value_pkey PRIMARY KEY (id),
    CONSTRAINT time_instant_value_time_instant_uuid_key UNIQUE (time_instant_uuid)
)

-- Table: SCHEMANAME.time_period_value

-- DROP TABLE IF EXISTS SCHEMANAME.time_period_value;

CREATE TABLE IF NOT EXISTS SCHEMANAME.time_period_value
(
    id integer NOT NULL DEFAULT nextval('SCHEMANAME.time_period_value_id_seq'::regclass),
    time_period_uuid uuid NOT NULL DEFAULT uuid_generate_v4(),
    value tsrange NOT NULL,
    time_period_from timestamp without time zone,
    time_period_to timestamp without time zone,
    CONSTRAINT time_period_value_pkey PRIMARY KEY (id),
    CONSTRAINT time_period_value_time_period_uuid_key UNIQUE (time_period_uuid)
)

-- Trigger: time_period_value_value

-- DROP TRIGGER IF EXISTS time_period_value_value ON SCHEMANAME.time_period_value;

CREATE OR REPLACE TRIGGER time_period_value_value
    BEFORE INSERT OR UPDATE 
    ON SCHEMANAME.time_period_value
    FOR EACH ROW
    EXECUTE FUNCTION SCHEMANAME.convert_to_timerange();

-- Table: SCHEMANAME.versions

-- DROP TABLE IF EXISTS SCHEMANAME.versions;

CREATE TABLE IF NOT EXISTS SCHEMANAME.versions
(
    identifier integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9999 CACHE 1 ),
    scriptname character varying COLLATE pg_catalog."default" NOT NULL,
    applied timestamp(6) without time zone NOT NULL DEFAULT now(),
    CONSTRAINT versions_pkey PRIMARY KEY (identifier),
    CONSTRAINT versions_scriptname_key UNIQUE (scriptname)
)

-- Table: SCHEMANAME.zoning_element

-- DROP TABLE IF EXISTS SCHEMANAME.zoning_element;

CREATE TABLE IF NOT EXISTS SCHEMANAME.zoning_element
(
    identifier integer NOT NULL DEFAULT nextval('SCHEMANAME.zoning_element_identifier_seq'::regclass),
    producer_specific_id uuid NOT NULL DEFAULT uuid_generate_v4(),
    geom geometry(MultiPolygon,PROJECTSRID) NOT NULL,
    storage_time timestamp without time zone,
    localized_name character varying COLLATE pg_catalog."default" NOT NULL,
    name jsonb,
    type integer NOT NULL,
    up_to_dateness integer NOT NULL,
    valid_from date,
    valid_to date,
    block_number character varying COLLATE pg_catalog."default",
    parcel_number character varying COLLATE pg_catalog."default",
    bindingness_of_location character varying(3) COLLATE pg_catalog."default" NOT NULL DEFAULT '01'::character varying,
    ground_relative_position character varying(3) COLLATE pg_catalog."default" NOT NULL,
    land_use_kind character varying(6) COLLATE pg_catalog."default" NOT NULL,
    identity_id uuid NOT NULL DEFAULT uuid_generate_v4(),
    local_id character varying COLLATE pg_catalog."default" NOT NULL DEFAULT uuid_generate_v4(),
    namespace character varying COLLATE pg_catalog."default",
    reference_id character varying COLLATE pg_catalog."default",
    latest_change timestamp without time zone NOT NULL DEFAULT now(),
    spatial_plan character varying COLLATE pg_catalog."default",
    validity_time daterange,
    created timestamp without time zone NOT NULL DEFAULT now(),
    created_by text COLLATE pg_catalog."default" NOT NULL,
    modified_by text COLLATE pg_catalog."default" NOT NULL,
    modified_at timestamp without time zone NOT NULL,
    lifecycle_status character varying(3) COLLATE pg_catalog."default" NOT NULL DEFAULT '01'::character varying,
    is_active boolean DEFAULT true,
    CONSTRAINT zoning_element_pkey PRIMARY KEY (identifier),
    CONSTRAINT zoning_element_local_id_key UNIQUE (local_id),
    CONSTRAINT zoning_element_planning_object_identifier_key UNIQUE (producer_specific_id),
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
        REFERENCES SCHEMANAME.spatial_plan (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT zoning_element_lifecycle_status_fkey FOREIGN KEY (lifecycle_status)
        REFERENCES code_lists.spatial_plan_lifecycle_status (codevalue) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT check_language_string CHECK (check_language_string(name)),
    CONSTRAINT validate_validity_dates CHECK (SCHEMANAME.validate_zoning_element_validity_dates(valid_from, valid_to, spatial_plan)),
    CONSTRAINT zoning_date_check CHECK (
CASE
    WHEN valid_from IS NOT NULL AND valid_to IS NULL THEN true
    WHEN valid_from IS NOT NULL AND valid_to > valid_from THEN true
    WHEN valid_from IS NULL AND valid_to IS NULL THEN true
    ELSE false
END),
    CONSTRAINT zoning_element_land_use_kind_check CHECK (land_use_kind::text ~~ '01%'::text)
)

-- Index: sidx_zoning_element_geom

-- DROP INDEX IF EXISTS SCHEMANAME.sidx_zoning_element_geom;

CREATE INDEX IF NOT EXISTS sidx_zoning_element_geom
    ON SCHEMANAME.zoning_element USING gist
    (geom)
    TABLESPACE pg_default;

-- Trigger: delete_geom_relations

-- DROP TRIGGER IF EXISTS delete_geom_relations ON SCHEMANAME.zoning_element;

CREATE OR REPLACE TRIGGER delete_geom_relations
    BEFORE UPDATE OF geom
    ON SCHEMANAME.zoning_element
    FOR EACH ROW
    WHEN (old.geom IS DISTINCT FROM new.geom)
    EXECUTE FUNCTION SCHEMANAME.delete_geom_relations();

-- Trigger: geom_relations

-- DROP TRIGGER IF EXISTS geom_relations ON SCHEMANAME.zoning_element;

CREATE OR REPLACE TRIGGER geom_relations
    AFTER INSERT OR UPDATE OF geom
    ON SCHEMANAME.zoning_element
    FOR EACH STATEMENT
    EXECUTE FUNCTION SCHEMANAME.geom_relations();

-- Trigger: inherit_validity

-- DROP TRIGGER IF EXISTS inherit_validity ON SCHEMANAME.zoning_element;

CREATE OR REPLACE TRIGGER inherit_validity
    AFTER INSERT
    ON SCHEMANAME.zoning_element
    FOR EACH STATEMENT
    EXECUTE FUNCTION SCHEMANAME.inherit_validity();

-- Trigger: update_validity

-- DROP TRIGGER IF EXISTS update_validity ON SCHEMANAME.zoning_element;

CREATE OR REPLACE TRIGGER update_validity
    AFTER INSERT OR UPDATE 
    ON SCHEMANAME.zoning_element
    FOR EACH STATEMENT
    WHEN (pg_trigger_depth() < 1)
    EXECUTE FUNCTION SCHEMANAME.update_validity();

-- Trigger: upsert_creator_and_modifier_trigger

-- DROP TRIGGER IF EXISTS upsert_creator_and_modifier_trigger ON SCHEMANAME.zoning_element;

CREATE OR REPLACE TRIGGER upsert_creator_and_modifier_trigger
    BEFORE INSERT OR UPDATE 
    ON SCHEMANAME.zoning_element
    FOR EACH ROW
    EXECUTE FUNCTION SCHEMANAME.upsert_creator_and_modifier_trigger();

-- Trigger: validate_zoning_element_geom

-- DROP TRIGGER IF EXISTS validate_zoning_element_geom ON SCHEMANAME.zoning_element;

CREATE OR REPLACE TRIGGER validate_zoning_element_geom
    BEFORE INSERT OR UPDATE OF geom
    ON SCHEMANAME.zoning_element
    FOR EACH ROW
    EXECUTE FUNCTION SCHEMANAME.validate_geometry();

-- Trigger: validate_zoning_element_topology

-- DROP TRIGGER IF EXISTS validate_zoning_element_topology ON SCHEMANAME.zoning_element;

CREATE CONSTRAINT TRIGGER validate_zoning_element_topology
    AFTER INSERT OR UPDATE OF geom
    ON SCHEMANAME.zoning_element
    DEFERRABLE INITIALLY DEFERRED
    FOR EACH ROW
    EXECUTE FUNCTION SCHEMANAME.validate_zoning_element_topology();

-- Trigger: zoning_element_modified_trigger

-- DROP TRIGGER IF EXISTS zoning_element_modified_trigger ON SCHEMANAME.zoning_element;

CREATE OR REPLACE TRIGGER zoning_element_modified_trigger
    BEFORE INSERT OR UPDATE 
    ON SCHEMANAME.zoning_element
    FOR EACH ROW
    EXECUTE FUNCTION public.versioned_object_modified_trigger();

-- Trigger: zoning_element_refresh_area_view

-- DROP TRIGGER IF EXISTS zoning_element_refresh_area_view ON SCHEMANAME.zoning_element;

CREATE OR REPLACE TRIGGER zoning_element_refresh_area_view
    AFTER INSERT OR DELETE
    ON SCHEMANAME.zoning_element
    FOR EACH ROW
    EXECUTE FUNCTION SCHEMANAME.refresh_plan_regulations_area_view();

-- Trigger: zoning_element_refresh_area_view_on_update

-- DROP TRIGGER IF EXISTS zoning_element_refresh_area_view_on_update ON SCHEMANAME.zoning_element;

CREATE OR REPLACE TRIGGER zoning_element_refresh_area_view_on_update
    AFTER UPDATE 
    ON SCHEMANAME.zoning_element
    FOR EACH ROW
    WHEN (old.geom IS DISTINCT FROM new.geom OR old.land_use_kind::text IS DISTINCT FROM new.land_use_kind::text)
    EXECUTE FUNCTION SCHEMANAME.refresh_plan_regulations_area_view();

-- Trigger: zoning_element_validity_time

-- DROP TRIGGER IF EXISTS zoning_element_validity_time ON SCHEMANAME.zoning_element;

CREATE OR REPLACE TRIGGER zoning_element_validity_time
    BEFORE INSERT OR UPDATE 
    ON SCHEMANAME.zoning_element
    FOR EACH ROW
    EXECUTE FUNCTION SCHEMANAME.validity_to_daterange();

-- Table: SCHEMANAME.zoning_element_describing_line

-- DROP TABLE IF EXISTS SCHEMANAME.zoning_element_describing_line;

CREATE TABLE IF NOT EXISTS SCHEMANAME.zoning_element_describing_line
(
    identifier integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    describing_line_id integer NOT NULL,
    zoning_element_local_id character varying COLLATE pg_catalog."default",
    CONSTRAINT zoning_element_describing_line_pkey PRIMARY KEY (identifier),
    CONSTRAINT zoning_element_describing_line_fk_describing_line FOREIGN KEY (describing_line_id)
        REFERENCES SCHEMANAME.describing_line (identifier) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT zoning_element_describing_line_fk_zoning_element FOREIGN KEY (zoning_element_local_id)
        REFERENCES SCHEMANAME.zoning_element (local_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
)

-- Table: SCHEMANAME.zoning_element_describing_text

-- DROP TABLE IF EXISTS SCHEMANAME.zoning_element_describing_text;

CREATE TABLE IF NOT EXISTS SCHEMANAME.zoning_element_describing_text
(
    identifier integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    describing_text_id integer NOT NULL,
    zoning_element_local_id character varying COLLATE pg_catalog."default",
    CONSTRAINT zoning_element_describing_text_pkey PRIMARY KEY (identifier),
    CONSTRAINT zoning_element_describing_text_fk_describing_text FOREIGN KEY (describing_text_id)
        REFERENCES SCHEMANAME.describing_text (identifier) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT zoning_element_describing_text_fk_zoning_element FOREIGN KEY (zoning_element_local_id)
        REFERENCES SCHEMANAME.zoning_element (local_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
)

-- Table: SCHEMANAME.zoning_element_numeric_value

-- DROP TABLE IF EXISTS SCHEMANAME.zoning_element_numeric_value;

CREATE TABLE IF NOT EXISTS SCHEMANAME.zoning_element_numeric_value
(
    identifier integer NOT NULL DEFAULT nextval('SCHEMANAME.zoning_element_numeric_value_identifier_seq'::regclass),
    zoning_id uuid NOT NULL,
    numeric_id uuid NOT NULL,
    CONSTRAINT zoning_element_numeric_value_pkey PRIMARY KEY (identifier),
    CONSTRAINT zoning_element_numeric_value_key UNIQUE (zoning_id, numeric_id),
    CONSTRAINT numeric_value_zoning_element_fk FOREIGN KEY (numeric_id)
        REFERENCES SCHEMANAME.numeric_value (numeric_value_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT zoning_element_numeric_value_fk FOREIGN KEY (zoning_id)
        REFERENCES SCHEMANAME.zoning_element (producer_specific_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED
)

-- Table: SCHEMANAME.zoning_element_plan_detail_line

-- DROP TABLE IF EXISTS SCHEMANAME.zoning_element_plan_detail_line;

CREATE TABLE IF NOT EXISTS SCHEMANAME.zoning_element_plan_detail_line
(
    identifier integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    zoning_element_local_id character varying COLLATE pg_catalog."default" NOT NULL,
    planning_detail_line_local_id character varying COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT zoning_element_plan_detail_line_pkey PRIMARY KEY (identifier),
    CONSTRAINT zoning_element_plan_detail_line_fk_planning_detail_line FOREIGN KEY (planning_detail_line_local_id)
        REFERENCES SCHEMANAME.planning_detail_line (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT zoning_element_plan_detail_line_fk_zoning_element FOREIGN KEY (zoning_element_local_id)
        REFERENCES SCHEMANAME.zoning_element (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED
)

-- Table: SCHEMANAME.zoning_element_plan_regulation_group

-- DROP TABLE IF EXISTS SCHEMANAME.zoning_element_plan_regulation_group;

CREATE TABLE IF NOT EXISTS SCHEMANAME.zoning_element_plan_regulation_group
(
    id integer NOT NULL DEFAULT nextval('SCHEMANAME.zoning_element_plan_regulation_group_id_seq'::regclass),
    zoning_element_local_id character varying COLLATE pg_catalog."default" NOT NULL,
    plan_regulation_group_local_id character varying COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT zoning_element_plan_regulation_group_pkey PRIMARY KEY (id),
    CONSTRAINT zoning_element_plan_regulatio_zoning_element_local_id_plan__key UNIQUE (zoning_element_local_id, plan_regulation_group_local_id),
    CONSTRAINT zoning_element_plan_regulation_group_fk_plan_regulation_group FOREIGN KEY (plan_regulation_group_local_id)
        REFERENCES SCHEMANAME.plan_regulation_group (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT zoning_element_plan_regulation_group_fk_zoning_element FOREIGN KEY (zoning_element_local_id)
        REFERENCES SCHEMANAME.zoning_element (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED
)

-- Table: SCHEMANAME.zoning_element_planned_space

-- DROP TABLE IF EXISTS SCHEMANAME.zoning_element_planned_space;

CREATE TABLE IF NOT EXISTS SCHEMANAME.zoning_element_planned_space
(
    identifier integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    zoning_element_local_id character varying COLLATE pg_catalog."default" NOT NULL,
    planned_space_local_id character varying COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT zoning_element_planned_space_pkey PRIMARY KEY (identifier),
    CONSTRAINT zoning_element_planned_space_fk_planned_space FOREIGN KEY (planned_space_local_id)
        REFERENCES SCHEMANAME.planned_space (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT zoning_element_planned_space_fk_zoning_element FOREIGN KEY (zoning_element_local_id)
        REFERENCES SCHEMANAME.zoning_element (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED
)

-- Table: SCHEMANAME.zoning_element_regulation

-- DROP TABLE IF EXISTS SCHEMANAME.zoning_element_regulation;

CREATE TABLE IF NOT EXISTS SCHEMANAME.zoning_element_regulation
(
    identifier integer NOT NULL DEFAULT nextval('SCHEMANAME.zoning_element_regulation_identifier_seq'::regclass),
    zoning_element_id uuid NOT NULL,
    regulative_id uuid NOT NULL,
    CONSTRAINT zoning_element_regulation_pkey PRIMARY KEY (identifier),
    CONSTRAINT zoning_element_regulation_key UNIQUE (zoning_element_id, regulative_id),
    CONSTRAINT regulative_id_zoning_fkey FOREIGN KEY (regulative_id)
        REFERENCES SCHEMANAME.regulative_text (regulative_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT zoning_element_regulation_fkey FOREIGN KEY (zoning_element_id)
        REFERENCES SCHEMANAME.zoning_element (producer_specific_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED
)

-- END OF LOCAL PLAN TABLES
-- SCHEMANAME, PROJECTSRID, MUNICIPALITYCODE