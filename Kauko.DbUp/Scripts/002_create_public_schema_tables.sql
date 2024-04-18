-- Table: public.qgis_projects

-- DROP TABLE IF EXISTS public.qgis_projects;

CREATE TABLE IF NOT EXISTS public.qgis_projects
(
    name text NOT NULL,
    metadata jsonb,
    content bytea,
    CONSTRAINT qgis_projects_pkey PRIMARY KEY (name)
);

-- Table: public.schema_information

-- DROP TABLE IF EXISTS public.schema_information;

CREATE TABLE IF NOT EXISTS public.schema_information
(
    identifier integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    name character varying NOT NULL,
    srid integer NOT NULL,
    municipality character varying(3) NOT NULL,
    is_master_plan boolean NOT NULL,
    created date NOT NULL DEFAULT now(),
    schema_version character(4),
    project_version character(4),
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
);
