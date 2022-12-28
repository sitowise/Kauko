CREATE TABLE IF NOT EXISTS public.qgis_projects
(
    name text COLLATE pg_catalog."default" NOT NULL,
    metadata jsonb,
    content bytea,
    CONSTRAINT qgis_projects_pkey PRIMARY KEY (name)
)

TABLESPACE pg_default;