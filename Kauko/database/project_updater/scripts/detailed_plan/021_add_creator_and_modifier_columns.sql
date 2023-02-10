CREATE OR REPLACE FUNCTION SCHEMANAME.upsert_creator_and_modifier_trigger()
RETURNS trigger
AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    NEW.created_by = current_user;
  ELSIF TG_OP = 'UPDATE' THEN
    NEW.created_by = OLD.created_by;
  NEW.modified_by = current_user;
  NEW.modified_at = now();
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

ALTER TABLE SCHEMANAME.spatial_plan
  ADD COLUMN created_by text,
  ADD COLUMN modified_by text,
  ADD COLUMN modified_at timestamp;

CREATE TRIGGER upsert_creator_and_modifier_trigger
  BEFORE INSERT OR UPDATE ON SCHEMANAME.spatial_plan
  FOR EACH ROW EXECUTE PROCEDURE SCHEMANAME.upsert_creator_and_modifier_trigger();

ALTER TABLE SCHEMANAME.zoning_element
  ADD COLUMN created_by text,
  ADD COLUMN modified_by text,
  ADD COLUMN modified_at timestamp;

CREATE TRIGGER upsert_creator_and_modifier_trigger
  BEFORE INSERT OR UPDATE ON SCHEMANAME.zoning_element
  FOR EACH ROW EXECUTE PROCEDURE SCHEMANAME.upsert_creator_and_modifier_trigger();

ALTER TABLE SCHEMANAME.planned_space
  ADD COLUMN created_by text,
  ADD COLUMN modified_by text,
  ADD COLUMN modified_at timestamp;

CREATE TRIGGER upsert_creator_and_modifier_trigger
  BEFORE INSERT OR UPDATE ON SCHEMANAME.planned_space
  FOR EACH ROW EXECUTE PROCEDURE SCHEMANAME.upsert_creator_and_modifier_trigger();

ALTER TABLE SCHEMANAME.planning_detail_line
  ADD COLUMN created_by text,
  ADD COLUMN modified_by text,
  ADD COLUMN modified_at timestamp;

CREATE TRIGGER upsert_creator_and_modifier_trigger
  BEFORE INSERT OR UPDATE ON SCHEMANAME.planning_detail_line
  FOR EACH ROW EXECUTE PROCEDURE SCHEMANAME.upsert_creator_and_modifier_trigger();

ALTER TABLE SCHEMANAME."document"
  ADD COLUMN created_by text,
  ADD COLUMN modified_by text,
  ADD COLUMN modified_at timestamp;

CREATE TRIGGER upsert_creator_and_modifier_trigger
  BEFORE INSERT OR UPDATE ON SCHEMANAME."document"
  FOR EACH ROW EXECUTE PROCEDURE SCHEMANAME.upsert_creator_and_modifier_trigger();

ALTER TABLE SCHEMANAME.plan_regulation
  ADD COLUMN created_by text,
  ADD COLUMN modified_by text,
  ADD COLUMN modified_at timestamp;

CREATE TRIGGER upsert_creator_and_modifier_trigger
  BEFORE INSERT OR UPDATE ON SCHEMANAME.plan_regulation
  FOR EACH ROW EXECUTE PROCEDURE SCHEMANAME.upsert_creator_and_modifier_trigger();

ALTER TABLE SCHEMANAME.plan_guidance
  ADD COLUMN created_by text,
  ADD COLUMN modified_by text,
  ADD COLUMN modified_at timestamp;

CREATE TRIGGER upsert_creator_and_modifier_trigger
  BEFORE INSERT OR UPDATE ON SCHEMANAME.plan_guidance
  FOR EACH ROW EXECUTE PROCEDURE SCHEMANAME.upsert_creator_and_modifier_trigger();
