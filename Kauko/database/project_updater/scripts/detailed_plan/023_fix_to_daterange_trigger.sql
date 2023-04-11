DO $$
DECLARE
    _table_name text[] := ARRAY[
        'spatial_plan',
        'zoning_element',
        'planned_space',
        'plan_regulation',
        'plan_guidance'
    ];
    table_name text;
BEGIN
    ALTER TABLE SCHEMANAME.spatial_plan
      DISABLE TRIGGER spatial_plan_validity_time;
    ALTER TABLE SCHEMANAME.zoning_element
      DISABLE TRIGGER zoning_element_validity_time;
    ALTER TABLE SCHEMANAME.planned_space
      DISABLE TRIGGER planned_space_validity_time;
    ALTER TABLE SCHEMANAME.plan_regulation
      DISABLE TRIGGER plan_regulation_validity_time;
    ALTER TABLE SCHEMANAME.plan_guidance
      DISABLE TRIGGER plan_guidance_validity_time;

    FOREACH table_name IN ARRAY _table_name
    LOOP
        EXECUTE format('UPDATE SCHEMANAME.%I
                          SET validity_time = DATERANGE(lower(validity_time), upper(validity_time), ''[]'')
                          WHERE validity_time IS NOT NULL',
                      quote_ident(table_name));
    END LOOP;

    ALTER TABLE SCHEMANAME.spatial_plan
      ENABLE TRIGGER spatial_plan_validity_time;
    ALTER TABLE SCHEMANAME.zoning_element
      ENABLE TRIGGER zoning_element_validity_time;
    ALTER TABLE SCHEMANAME.planned_space
      ENABLE TRIGGER planned_space_validity_time;
    ALTER TABLE SCHEMANAME.plan_regulation
      ENABLE TRIGGER plan_regulation_validity_time;
    ALTER TABLE SCHEMANAME.plan_guidance
      ENABLE TRIGGER plan_guidance_validity_time;
END $$ LANGUAGE plpgsql;

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
