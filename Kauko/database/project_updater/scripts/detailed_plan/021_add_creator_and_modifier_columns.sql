CREATE OR REPLACE FUNCTION SCHEMANAME.upsert_creator_and_modifier_trigger()
RETURNS trigger
AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    NEW.created = now();
    NEW.created_by = current_user;
  ELSIF TG_OP = 'UPDATE' THEN
    NEW.created = OLD.created;
    NEW.created_by = OLD.created_by;
  END IF;
  NEW.modified_by = current_user;
  NEW.modified_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

ALTER TABLE SCHEMANAME.spatial_plan
  ADD COLUMN created timestamp,
  ADD COLUMN created_by text,
  ADD COLUMN modified_by text,
  ADD COLUMN modified_at timestamp;

UPDATE SCHEMANAME.spatial_plan
  SET
    created = CASE
                WHEN storage_time IS NOT NULL THEN storage_time
                ELSE now()
              END,
    created_by = 'system',
    modified_by = 'system',
    modified_at = now();

ALTER TABLE SCHEMANAME.spatial_plan
  ALTER COLUMN storage_time DROP NOT NULL,
  ALTER COLUMN storage_time DROP DEFAULT;

UPDATE SCHEMANAME.spatial_plan
  SET storage_time = NULL;

ALTER TABLE SCHEMANAME.spatial_plan
  ALTER COLUMN created SET NOT NULL,
  ALTER COLUMN created SET DEFAULT now(),
  ALTER COLUMN created_by SET NOT NULL,
  ALTER COLUMN modified_by SET NOT NULL,
  ALTER COLUMN modified_at SET NOT NULL;


CREATE TRIGGER upsert_creator_and_modifier_trigger
  BEFORE INSERT OR UPDATE ON SCHEMANAME.spatial_plan
  FOR EACH ROW EXECUTE PROCEDURE SCHEMANAME.upsert_creator_and_modifier_trigger();

ALTER TABLE SCHEMANAME.zoning_element
  ADD COLUMN created timestamp,
  ADD COLUMN created_by text,
  ADD COLUMN modified_by text,
  ADD COLUMN modified_at timestamp;

UPDATE SCHEMANAME.zoning_element
  SET
    created = CASE
                WHEN storage_time IS NOT NULL THEN storage_time
                ELSE now()
              END,
    created_by = 'system',
    modified_by = 'system',
    modified_at = now();

ALTER TABLE SCHEMANAME.zoning_element
  ALTER COLUMN storage_time DROP NOT NULL,
  ALTER COLUMN storage_time DROP DEFAULT;

UPDATE SCHEMANAME.zoning_element
  SET storage_time = NULL;

ALTER TABLE SCHEMANAME.zoning_element
  ALTER COLUMN created SET NOT NULL,
  ALTER COLUMN created SET DEFAULT now(),
  ALTER COLUMN created_by SET NOT NULL,
  ALTER COLUMN modified_by SET NOT NULL,
  ALTER COLUMN modified_at SET NOT NULL;

CREATE TRIGGER upsert_creator_and_modifier_trigger
  BEFORE INSERT OR UPDATE ON SCHEMANAME.zoning_element
  FOR EACH ROW EXECUTE PROCEDURE SCHEMANAME.upsert_creator_and_modifier_trigger();

ALTER TABLE SCHEMANAME.planned_space
  ADD COLUMN created timestamp,
  ADD COLUMN created_by text,
  ADD COLUMN modified_by text,
  ADD COLUMN modified_at timestamp;

UPDATE SCHEMANAME.planned_space
  SET
    created = CASE
                WHEN storage_time IS NOT NULL THEN storage_time
                ELSE now()
              END,
    created_by = 'system',
    modified_by = 'system',
    modified_at = now();

ALTER TABLE SCHEMANAME.planned_space
  ALTER COLUMN storage_time DROP NOT NULL,
  ALTER COLUMN storage_time DROP DEFAULT;

UPDATE SCHEMANAME.planned_space
  SET storage_time = NULL;

ALTER TABLE SCHEMANAME.planned_space
  ALTER COLUMN created SET NOT NULL,
  ALTER COLUMN created SET DEFAULT now(),
  ALTER COLUMN created_by SET NOT NULL,
  ALTER COLUMN modified_by SET NOT NULL,
  ALTER COLUMN modified_at SET NOT NULL;

CREATE TRIGGER upsert_creator_and_modifier_trigger
  BEFORE INSERT OR UPDATE ON SCHEMANAME.planned_space
  FOR EACH ROW EXECUTE PROCEDURE SCHEMANAME.upsert_creator_and_modifier_trigger();

ALTER TABLE SCHEMANAME.planning_detail_line
  ADD COLUMN created timestamp,
  ADD COLUMN created_by text,
  ADD COLUMN modified_by text,
  ADD COLUMN modified_at timestamp;

UPDATE SCHEMANAME.planning_detail_line
  SET
    created = CASE
                WHEN storage_time IS NOT NULL THEN storage_time
                ELSE now()
              END,
    created_by = 'system',
    modified_by = 'system',
    modified_at = now();

ALTER TABLE SCHEMANAME.planning_detail_line
  ALTER COLUMN storage_time DROP NOT NULL,
  ALTER COLUMN storage_time DROP DEFAULT;

UPDATE SCHEMANAME.planning_detail_line
  SET storage_time = NULL;

ALTER TABLE SCHEMANAME.planning_detail_line
  ALTER COLUMN created SET NOT NULL,
  ALTER COLUMN created SET DEFAULT now(),
  ALTER COLUMN created_by SET NOT NULL,
  ALTER COLUMN modified_by SET NOT NULL,
  ALTER COLUMN modified_at SET NOT NULL;

CREATE TRIGGER upsert_creator_and_modifier_trigger
  BEFORE INSERT OR UPDATE ON SCHEMANAME.planning_detail_line
  FOR EACH ROW EXECUTE PROCEDURE SCHEMANAME.upsert_creator_and_modifier_trigger();

ALTER TABLE SCHEMANAME."document"
  ADD COLUMN created timestamp,
  ADD COLUMN created_by text,
  ADD COLUMN modified_by text,
  ADD COLUMN modified_at timestamp;

UPDATE SCHEMANAME."document"
  SET
    created = CASE
                WHEN storage_time IS NOT NULL THEN storage_time
                ELSE now()
              END,
    created_by = 'system',
    modified_by = 'system',
    modified_at = now();

ALTER TABLE SCHEMANAME."document"
  ALTER COLUMN storage_time DROP NOT NULL,
  ALTER COLUMN storage_time DROP DEFAULT;

UPDATE SCHEMANAME."document"
  SET storage_time = NULL;

ALTER TABLE SCHEMANAME."document"
  ALTER COLUMN created SET NOT NULL,
  ALTER COLUMN created SET DEFAULT now(),
  ALTER COLUMN created_by SET NOT NULL,
  ALTER COLUMN modified_by SET NOT NULL,
  ALTER COLUMN modified_at SET NOT NULL;

CREATE TRIGGER upsert_creator_and_modifier_trigger
  BEFORE INSERT OR UPDATE ON SCHEMANAME."document"
  FOR EACH ROW EXECUTE PROCEDURE SCHEMANAME.upsert_creator_and_modifier_trigger();

ALTER TABLE SCHEMANAME.plan_regulation
  ADD COLUMN created timestamp,
  ADD COLUMN created_by text,
  ADD COLUMN modified_by text,
  ADD COLUMN modified_at timestamp;

UPDATE SCHEMANAME.plan_regulation
  SET
    created = CASE
                WHEN storage_time IS NOT NULL THEN storage_time
                ELSE now()
              END,
    created_by = 'system',
    modified_by = 'system',
    modified_at = now();

ALTER TABLE SCHEMANAME.plan_regulation
  ALTER COLUMN storage_time DROP NOT NULL,
  ALTER COLUMN storage_time DROP DEFAULT;

UPDATE SCHEMANAME.plan_regulation
  SET storage_time = NULL;

ALTER TABLE SCHEMANAME.plan_regulation
  ALTER COLUMN created SET NOT NULL,
  ALTER COLUMN created SET DEFAULT now(),
  ALTER COLUMN created_by SET NOT NULL,
  ALTER COLUMN modified_by SET NOT NULL,
  ALTER COLUMN modified_at SET NOT NULL;

CREATE TRIGGER upsert_creator_and_modifier_trigger
  BEFORE INSERT OR UPDATE ON SCHEMANAME.plan_regulation
  FOR EACH ROW EXECUTE PROCEDURE SCHEMANAME.upsert_creator_and_modifier_trigger();

ALTER TABLE SCHEMANAME.plan_guidance
  ADD COLUMN created timestamp,
  ADD COLUMN created_by text,
  ADD COLUMN modified_by text,
  ADD COLUMN modified_at timestamp;

UPDATE SCHEMANAME.plan_guidance
  SET
    created = CASE
                WHEN storage_time IS NOT NULL THEN storage_time
                ELSE now()
              END,
    created_by = 'system',
    modified_by = 'system',
    modified_at = now();

ALTER TABLE SCHEMANAME.plan_guidance
  ALTER COLUMN storage_time DROP NOT NULL,
  ALTER COLUMN storage_time DROP DEFAULT;

UPDATE SCHEMANAME.plan_guidance
  SET storage_time = NULL;

ALTER TABLE SCHEMANAME.plan_guidance
  ALTER COLUMN created SET NOT NULL,
  ALTER COLUMN created SET DEFAULT now(),
  ALTER COLUMN created_by SET NOT NULL,
  ALTER COLUMN modified_by SET NOT NULL,
  ALTER COLUMN modified_at SET NOT NULL;


CREATE TRIGGER upsert_creator_and_modifier_trigger
  BEFORE INSERT OR UPDATE ON SCHEMANAME.plan_guidance
  FOR EACH ROW EXECUTE PROCEDURE SCHEMANAME.upsert_creator_and_modifier_trigger();
