-- Table: public.qgis_projects

-- DROP TABLE IF EXISTS public.qgis_projects;

CREATE TABLE IF NOT EXISTS public.qgis_projects
(
    name text COLLATE pg_catalog."default" NOT NULL,
    metadata jsonb,
    content bytea,
    CONSTRAINT qgis_projects_pkey PRIMARY KEY (name)
)

TABLESPACE pg_default;

-- Table: public.schema_information

-- DROP TABLE IF EXISTS public.schema_information;

CREATE TABLE IF NOT EXISTS public.schema_information
(
    identifier integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    name character varying COLLATE pg_catalog."default" NOT NULL,
    srid integer NOT NULL,
    municipality character varying(3) COLLATE pg_catalog."default" NOT NULL,
    is_master_plan boolean NOT NULL,
    created date NOT NULL DEFAULT now(),
    schema_version character(4) COLLATE pg_catalog."default",
    project_version character(4) COLLATE pg_catalog."default",
    schema_updated timestamp(6) without time zone,
    project_updated timestamp(6) without time zone,
    CONSTRAINT schema_information_pkey PRIMARY KEY (identifier),
    CONSTRAINT name_unique UNIQUE (name),
    CONSTRAINT check_is_master_plan CHECK (
CASE
    WHEN name::text ~~ '%y'::text AND is_master_plan IS TRUE THEN true
    WHEN name::text !~~ '%y'::text AND is_master_plan IS FALSE THEN true
    ELSE false
END)
)

TABLESPACE pg_default;

-- Trigger: check_update

-- DROP TRIGGER IF EXISTS check_update ON public.schema_information;

CREATE OR REPLACE TRIGGER check_update
    BEFORE INSERT OR UPDATE OF schema_version, project_version
    ON public.schema_information
    FOR EACH ROW
    EXECUTE FUNCTION public.check_update();
	
-- Table: public.schemaversions

-- DROP TABLE IF EXISTS public.schemaversions;

CREATE TABLE IF NOT EXISTS public.schemaversions
(
    schemaversionsid integer NOT NULL DEFAULT nextval('schemaversions_schemaversionsid_seq'::regclass),
    scriptname character varying(255) COLLATE pg_catalog."default" NOT NULL,
    applied timestamp without time zone NOT NULL,
    CONSTRAINT "PK_schemaversions_Id" PRIMARY KEY (schemaversionsid)
)

TABLESPACE pg_default;

-- Table: public.spatial_ref_sys

-- DROP TABLE IF EXISTS public.spatial_ref_sys;

CREATE TABLE IF NOT EXISTS public.spatial_ref_sys
(
    srid integer NOT NULL,
    auth_name character varying(256) COLLATE pg_catalog."default",
    auth_srid integer,
    srtext character varying(2048) COLLATE pg_catalog."default",
    proj4text character varying(2048) COLLATE pg_catalog."default",
    CONSTRAINT spatial_ref_sys_pkey PRIMARY KEY (srid),
    CONSTRAINT spatial_ref_sys_srid_check CHECK (srid > 0 AND srid <= 998999)
)

TABLESPACE pg_default;

