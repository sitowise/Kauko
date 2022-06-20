DO $$
BEGIN
  CREATE ROLE qgis_admin WITH
  NOLOGIN
  NOSUPERUSER
  INHERIT
  NOCREATEDB
  NOCREATEROLE
  NOREPLICATION;
  EXCEPTION WHEN DUPLICATE_OBJECT THEN
  RAISE NOTICE 'not creating role qgis_admin -- it already exists';
END
$$;

DO $$
BEGIN
  CREATE ROLE qgis_editor WITH
  NOLOGIN
  NOSUPERUSER
  INHERIT
  NOCREATEDB
  NOCREATEROLE
  NOREPLICATION;
  EXCEPTION WHEN DUPLICATE_OBJECT THEN
  RAISE NOTICE 'not creating role qgis_editor -- it already exists';
END
$$;


DO $$
BEGIN
  EXECUTE format('grant all on database %I to %I with grant option', current_database(), 'qgis_admin');
  EXECUTE format('grant connect on database %I to %I', current_database(), 'qgis_editor');
END;
$$;

CREATE EXTENSION IF NOT EXISTS postgis;
create EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE SCHEMA IF NOT EXISTS code_lists;

GRANT USAGE ON SCHEMA public to qgis_admin WITH GRANT OPTION;
GRANT USAGE ON SCHEMA public to qgis_editor;

GRANT USAGE ON SCHEMA code_lists TO qgis_admin WITH GRANT OPTION;
GRANT USAGE ON SCHEMA code_lists TO qgis_editor;

ALTER DEFAULT PRIVILEGES IN SCHEMA code_lists
GRANT ALL ON TABLES TO qgis_admin WITH GRANT OPTION;

ALTER DEFAULT PRIVILEGES IN SCHEMA code_lists
GRANT SELECT ON TABLES TO qgis_editor;

