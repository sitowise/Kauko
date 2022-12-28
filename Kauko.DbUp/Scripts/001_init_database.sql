DO $$
BEGIN
  CREATE ROLE spatial_plan_admin WITH
  NOLOGIN
  NOSUPERUSER
  INHERIT
  CREATEDB
  CREATEROLE
  REPLICATION;
  EXCEPTION WHEN DUPLICATE_OBJECT THEN
  RAISE NOTICE 'not creating role spatial_plan_admin -- it already exists';
END
$$;

DO $$
BEGIN
  EXECUTE format('grant all on database %I to %I with grant option', current_database(), 'spatial_plan_admin');
END;
$$;

GRANT USAGE ON SCHEMA public TO spatial_plan_admin WITH GRANT OPTION;
ALTER DEFAULT PRIVILEGES IN SCHEMA public
  GRANT ALL ON TABLES TO spatial_plan_admin WITH GRANT OPTION;

CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE SCHEMA IF NOT EXISTS code_lists;


GRANT USAGE ON SCHEMA code_lists TO spatial_plan_admin WITH GRANT OPTION;
ALTER DEFAULT PRIVILEGES IN SCHEMA code_lists
GRANT ALL ON TABLES TO spatial_plan_admin WITH GRANT OPTION;
