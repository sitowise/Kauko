CREATE TABLE IF NOT EXISTS public.qgis_projects
(
    name text COLLATE pg_catalog."default" NOT NULL,
    metadata jsonb,
    content bytea,
    CONSTRAINT qgis_projects_pkey PRIMARY KEY (name)
)

TABLESPACE pg_default;

GRANT SELECT ON TABLE public.qgis_projects TO qgis_editor;

GRANT INSERT, SELECT, DELETE, UPDATE ON TABLE public.qgis_projects TO qgis_admin;