CREATE OR REPLACE FUNCTION SCHEMANAME.validity_to_daterange()
RETURNS TRIGGER
AS $$
BEGIN
  IF NEW.validity_time IS NOT NULL AND NEW.validity_time <> OLD.validity_time THEN
    RAISE EXCEPTION 'Cannot change validity_time';
  END IF;
  IF NEW.valid_from IS NULL THEN
    IF NEW.valid_to IS NOT NULL THEN
      RAISE EXCEPTION 'valid_from cannot be NULL if valid_to is not NULL';
    END IF;
    NEW.validity_time = NULL;
    RETURN NEW;
  END IF;
  NEW.validity_time = DATERANGE(NEW.valid_from, NEW.valid_to, '[)');
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

ALTER TABLE SCHEMANAME.spatial_plan
  ADD COLUMN initiation_time DATE;

ALTER TABLE SCHEMANAME.spatial_plan
  RENAME COLUMN approval_date TO approval_time;

UPDATE SCHEMANAME.spatial_plan
  SET validity_time = DATERANGE(valid_from, valid_to, '[)')
  WHERE valid_from IS NOT NULL;

CREATE TRIGGER spatial_plan_validity_time
  BEFORE INSERT OR UPDATE ON SCHEMANAME.spatial_plan
  FOR EACH ROW EXECUTE PROCEDURE SCHEMANAME.validity_to_daterange();

-- FIX zoning_element date columns
ALTER TABLE SCHEMANAME.zoning_element
  ADD COLUMN validity_time DATERANGE;

UPDATE SCHEMANAME.zoning_element
  SET validity_time = DATERANGE(valid_from, valid_to, '[)')
  WHERE valid_from IS NOT NULL;

CREATE TRIGGER zoning_element_validity_time
  BEFORE INSERT OR UPDATE ON SCHEMANAME.zoning_element
  FOR EACH ROW EXECUTE PROCEDURE SCHEMANAME.validity_to_daterange();

-- FIX planned_space date columns
ALTER TABLE SCHEMANAME.planned_space
  ADD COLUMN validity_time DATERANGE;

UPDATE SCHEMANAME.planned_space
  SET validity_time = DATERANGE(valid_from, valid_to, '[)')
  WHERE valid_from IS NOT NULL;

CREATE TRIGGER planned_space_validity_time
  BEFORE INSERT OR UPDATE ON SCHEMANAME.planned_space
  FOR EACH ROW EXECUTE PROCEDURE SCHEMANAME.validity_to_daterange();

-- FIX plan_regulation date columns

ALTER TABLE SCHEMANAME.plan_regulation
  ALTER COLUMN validity_time TYPE DATERANGE USING DATERANGE(lower(validity_time)::DATE, upper(validity_time)::DATE, '(]');

ALTER TABLE SCHEMANAME.plan_regulation
  ADD COLUMN valid_from DATE,
  ADD COLUMN valid_to DATE;

UPDATE SCHEMANAME.plan_regulation
  SET valid_from = lower(validity_time),
      valid_to = upper(validity_time);

CREATE TRIGGER plan_regulation_validity_time
  BEFORE INSERT OR UPDATE ON SCHEMANAME.plan_regulation
  FOR EACH ROW EXECUTE PROCEDURE SCHEMANAME.validity_to_daterange();

-- FIX plan_guidance date columns

ALTER TABLE SCHEMANAME.plan_guidance
  ALTER COLUMN validity_time TYPE DATERANGE USING DATERANGE(lower(validity_time)::DATE, upper(validity_time)::DATE, '(]');

ALTER TABLE SCHEMANAME.plan_guidance
  ADD COLUMN valid_from DATE,
  ADD COLUMN valid_to DATE;

UPDATE SCHEMANAME.plan_guidance
  SET valid_from = lower(validity_time),
      valid_to = upper(validity_time);

CREATE TRIGGER plan_guidance_validity_time
  BEFORE INSERT OR UPDATE ON SCHEMANAME.plan_guidance
  FOR EACH ROW EXECUTE PROCEDURE SCHEMANAME.validity_to_daterange();

-- FIX time_period_value
CREATE OR REPLACE FUNCTION SCHEMANAME.convert_to_timerange()
RETURNS TRIGGER
AS $$
BEGIN
  IF NEW."value" IS NOT NULL AND NEW."value" <> OLD."value" THEN
    RAISE EXCEPTION 'Cannot change time_period_value';
  END IF;
  IF NEW.time_period_from IS NULL THEN
    IF NEW.time_period_to IS NOT NULL THEN
      RAISE EXCEPTION 'time_period_from cannot be NULL if time_period_to is not NULL';
    END IF;
    NEW."value" = NULL;
    RETURN NEW;
  END IF;
  NEW."value" = TSRANGE(NEW.time_period_from, NEW.time_period_to, '[)');
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

ALTER TABLE SCHEMANAME.time_period_value
  ADD COLUMN time_period_from timestamp without time zone,
  ADD COLUMN time_period_to timestamp without time zone;

UPDATE SCHEMANAME.time_period_value
  SET time_period_from = lower("value"),
      time_period_to = upper("value");

CREATE TRIGGER time_period_value_value
  BEFORE INSERT OR UPDATE ON SCHEMANAME.time_period_value
  FOR EACH ROW EXECUTE PROCEDURE convert_to_timerange();