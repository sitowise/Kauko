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

DO $$
DECLARE
  _table_names text[] := ARRAY[
        'zoning_element',
        'planned_space',
        'planning_detail_line',
        'document',
        'plan_regulation',
        'plan_guidance'
    ];
    table_name text;
    _triggers_to_disable RECORD;
BEGIN
  FOR _triggers_to_disable IN
    SELECT tgname, relname
      FROM pg_trigger
      JOIN pg_class ON tgrelid = pg_class.oid
      WHERE tgfoid in (
        'public.versioned_object_modified_trigger()'::regprocedure,
        'SCHEMANAME.validity_to_daterange()'::regprocedure,
        'SCHEMANAME.update_validity()'::regprocedure,
        'SCHEMANAME.inherit_validity()'::regprocedure
      )
      AND relnamespace = (SELECT oid FROM pg_namespace WHERE nspname = 'SCHEMANAME')
      AND relname IN (SELECT unnest(_table_names))
    LOOP
        EXECUTE format('ALTER TABLE SCHEMANAME.%I
                          DISABLE TRIGGER %I;',
                      quote_ident(_triggers_to_disable.relname),
                      quote_ident(_triggers_to_disable.tgname));
    END LOOP;

  FOREACH table_name IN ARRAY _table_names
  LOOP
    EXECUTE format('ALTER TABLE SCHEMANAME.%I
                      ADD COLUMN created timestamp,
                      ADD COLUMN created_by text,
                      ADD COLUMN modified_by text,
                      ADD COLUMN modified_at timestamp;',
                  quote_ident(table_name));

    EXECUTE format('UPDATE SCHEMANAME.%I
                      SET
                        created = CASE
                                    WHEN storage_time IS NOT NULL THEN storage_time
                                    ELSE now()
                                  END,
                        created_by = ''system'',
                        modified_by = ''system'',
                        modified_at = now();',
                  quote_ident(table_name));

    EXECUTE format('ALTER TABLE SCHEMANAME.%I
                      ALTER COLUMN storage_time DROP NOT NULL,
                      ALTER COLUMN storage_time DROP DEFAULT;',
                  quote_ident(table_name));


    EXECUTE format('ALTER TABLE SCHEMANAME.%I
                      ALTER COLUMN created SET NOT NULL,
                      ALTER COLUMN created SET DEFAULT now(),
                      ALTER COLUMN created_by SET NOT NULL,
                      ALTER COLUMN modified_by SET NOT NULL,
                      ALTER COLUMN modified_at SET NOT NULL;',
                  quote_ident(table_name));

    EXECUTE format('CREATE TRIGGER upsert_creator_and_modifier_trigger
                      BEFORE INSERT OR UPDATE ON SCHEMANAME.%I
                      FOR EACH ROW EXECUTE PROCEDURE SCHEMANAME.upsert_creator_and_modifier_trigger();',
                  quote_ident(table_name));
  END LOOP;

  FOR _triggers_to_disable IN
    SELECT tgname, relname
      FROM pg_trigger
      JOIN pg_class ON tgrelid = pg_class.oid
      WHERE tgfoid in (
        'public.versioned_object_modified_trigger()'::regprocedure,
        'SCHEMANAME.validity_to_daterange()'::regprocedure,
        'SCHEMANAME.update_validity()'::regprocedure,
        'SCHEMANAME.inherit_validity()'::regprocedure
      )
      AND relnamespace = (SELECT oid FROM pg_namespace WHERE nspname = 'SCHEMANAME')
      AND relname IN (SELECT unnest(_table_names))
    LOOP
        EXECUTE format('ALTER TABLE SCHEMANAME.%I
                          ENABLE TRIGGER %I;',
                      quote_ident(_triggers_to_disable.relname),
                      quote_ident(_triggers_to_disable.tgname));
    END LOOP;

  FOREACH table_name IN ARRAY _table_names
  LOOP
    EXECUTE format('UPDATE SCHEMANAME.%I
                      SET storage_time = NULL;',
                  quote_ident(table_name));
  END LOOP;
END $$ LANGUAGE plpgsql;
