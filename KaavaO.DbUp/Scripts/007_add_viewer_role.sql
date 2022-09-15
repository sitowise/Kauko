DO $$
BEGIN
  CREATE ROLE qgis_viewer WITH
  NOLOGIN
  NOSUPERUSER
  INHERIT
  NOCREATEDB
  NOCREATEROLE
  NOREPLICATION;
  EXCEPTION WHEN DUPLICATE_OBJECT THEN
  RAISE NOTICE 'not creating role qgis_viewer -- it already exists';
END
$$;

DO $$
BEGIN
  EXECUTE format('grant connect on database %I to %I', current_database(), 'qgis_viewer');
END;
$$;

GRANT USAGE ON SCHEMA public to qgis_viewer;

GRANT USAGE ON SCHEMA code_lists TO qgis_viewer;

ALTER DEFAULT PRIVILEGES IN SCHEMA code_lists
GRANT SELECT ON TABLES TO qgis_viewer;