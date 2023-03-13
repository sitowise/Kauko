ALTER TABLE SCHEMANAME.planner
    ADD COLUMN identity_id UUID DEFAULT uuid_generate_v4() NOT NULL UNIQUE,
    ADD COLUMN local_id VARCHAR UNIQUE,
    ADD COLUMN namespace VARCHAR,
    ADD COLUMN reference_id VARCHAR,
    ADD COLUMN latest_change TIMESTAMP DEFAULT now() NOT NULL,
    ADD COLUMN storage_time TIMESTAMP DEFAULT now() NOT NULL;

CREATE TRIGGER planner_modified_trigger
  BEFORE INSERT OR UPDATE ON SCHEMANAME.planner
  FOR EACH ROW EXECUTE PROCEDURE versioned_object_modified_trigger();

UPDATE SCHEMANAME.planner
  SET local_id = identity_id || '.' || uuid_generate_v4();

CREATE TRIGGER create_planner_local_id_trigger
  BEFORE INSERT ON SCHEMANAME.planner
  FOR EACH ROW EXECUTE PROCEDURE create_local_id_trigger();

ALTER TABLE SCHEMANAME.planner
  ALTER COLUMN local_id SET NOT NULL;