DO $$
LANGUAGE plpgsql
DECLARE
    table_name text;
BEGIN
    SET session_replication_role = replica;
    FOR table_name IN (
        'spatial_plan',
        'zoning_element',
        'planned_space',
        'plan_regulation',
        'plan_guidance'
    )
    LOOP
        EXECUTE format('UPDATE SCHEMANAME.%I
                          SET validity_time = DATERANGE(lower(validity_time), upper(validity_time), ''[]'')
                          WHERE validity_time IS NOT NULL',
                      table_name);
    END LOOP;
    SET session_replication_role = DEFAULT;
END $$ DISABLE TRIGGER ALL;

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
  NEW.validity_time = DATERANGE(NEW.valid_from, NEW.valid_to, '[]');
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;