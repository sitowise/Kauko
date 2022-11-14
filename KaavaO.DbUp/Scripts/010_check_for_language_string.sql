CREATE OR REPLACE FUNCTION public.check_language_string(languageString JSONB)
RETURNS BOOLEAN AS
$$
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
$$
LANGUAGE plpgsql;