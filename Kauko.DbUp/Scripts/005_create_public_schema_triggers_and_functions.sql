-- FUNCTION: public.check_update()

-- DROP FUNCTION IF EXISTS public.check_update();

CREATE OR REPLACE FUNCTION public.check_update()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$

BEGIN
IF (TG_OP = 'INSERT') THEN
    IF (NEW.schema_version IS NOT NULL) THEN
        NEW.schema_updated := CURRENT_TIMESTAMP;
    END IF;
    IF (NEW.PROJECT_version IS NOT NULL) THEN
        NEW.project_updated := CURRENT_TIMESTAMP;
    END IF;
END IF;
IF (TG_OP = 'UPDATE') THEN
    IF NEW.schema_version IS DISTINCT FROM OLD.schema_version THEN
        NEW.schema_updated := current_timestamp;
    END IF;
    IF NEW.project_version IS DISTINCT FROM OLD.project_version THEN
        NEW.project_updated := current_timestamp;
    END IF;
END IF;
RETURN NEW;
END;
$BODY$;

-- FUNCTION: public.create_local_id_trigger()

-- DROP FUNCTION IF EXISTS public.create_local_id_trigger();

CREATE OR REPLACE FUNCTION public.create_local_id_trigger()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$

  BEGIN
    IF NEW.local_id IS NULL THEN
      NEW.local_id := NEW.identity_id || '.' || uuid_generate_v4();
    END IF;
    RETURN NEW;
  END;
$BODY$;

-- FUNCTION: public.versioned_object_modified_trigger()

-- DROP FUNCTION IF EXISTS public.versioned_object_modified_trigger();

CREATE OR REPLACE FUNCTION public.versioned_object_modified_trigger()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$

  BEGIN
    NEW.latest_change := now();
    IF TG_OP = 'INSERT' THEN
      NEW.storage_time := now();
    ELSIF TG_OP = 'UPDATE' THEN
      NEW.storage_time = OLD.storage_time;
    END IF;
    RETURN NEW;
  END;
$BODY$;



-- FUNCTION: public.check_language_string(jsonb)

-- DROP FUNCTION IF EXISTS public.check_language_string(jsonb);

CREATE OR REPLACE FUNCTION public.check_language_string(
	languagestring jsonb)
    RETURNS boolean
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$

DECLARE
  languageCode RECORD;
BEGIN
  FOR languageCode IN
    SELECT *
    FROM jsonb_each_text(languageString)
  LOOP
    IF NOT EXISTS (SELECT 1 FROM code_lists.iso_639_language WHERE code = languageCode.key) THEN
      RAISE EXCEPTION 'Language code % does not exist', languageCode.key;
      RETURN FALSE;
    END IF;
    IF (languageCode.value <> '') IS NOT TRUE THEN
      RAISE EXCEPTION 'Text for % is either NULL or empty', languageCode.key;
      RETURN FALSE;
    END IF;
  END LOOP;
  RETURN TRUE;
END;
$BODY$;


