-- Change datatype in table time_period_value
-------------------------------------------------------------------------

ALTER TABLE $SCHEMANAME$.time_period_value DROP COLUMN value;
ALTER TABLE $SCHEMANAME$.time_period_value ADD value tstzrange NOT NULL;



-- Update function convert_to_timerange: TSRANGE --> TSTZRANGE 
-------------------------------------------------------------------------

DROP TRIGGER IF EXISTS time_period_value_value ON $SCHEMANAME$.time_period_value;

-- FUNCTION: $SCHEMANAME$.convert_to_timerange()
DROP FUNCTION IF EXISTS $SCHEMANAME$.convert_to_timerange();

CREATE OR REPLACE FUNCTION $SCHEMANAME$.convert_to_timerange()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
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
  NEW."value" = TSTZRANGE(NEW.time_period_from, NEW.time_period_to, '[)');
  RETURN NEW;
END;
$BODY$;

-- Trigger: time_period_value_value

CREATE OR REPLACE TRIGGER time_period_value_value
    BEFORE INSERT OR UPDATE 
    ON $SCHEMANAME$.time_period_value
    FOR EACH ROW
    EXECUTE FUNCTION $SCHEMANAME$.convert_to_timerange();
