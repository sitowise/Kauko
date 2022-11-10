ALTER TABLE SCHEMANAME.spatial_plan
  ADD COLUMN name JSONB CHECK(check_language_string(name));

DO $$
DECLARE
  _row RECORD;
BEGIN
  FOR _row IN SELECT identifier, name_fi, name_sv FROM SCHEMANAME.spatial_plan
  LOOP
    CONTINUE WHEN _row.name_fi IS NULL AND _row.name_sv IS NULL;
    IF _row.name_fi IS NOT NULL AND _row.name_sv IS NOT NULL THEN
      UPDATE SCHEMANAME.spatial_plan
      SET name = FORMAT('{"fi": "%s", "sv": "%s"}', _row.name_fi, _row.name_sv)::JSONB
      WHERE identifier = _row.identifier;
    ELSIF _row.name_fi IS NOT NULL THEN
      UPDATE SCHEMANAME.spatial_plan
      SET name = FORMAT('{"fi": "%s"}', _row.name_fi)::JSONB
      WHERE identifier = _row.identifier;
    ELSE
      UPDATE SCHEMANAME.spatial_plan
      SET name = FORMAT('{"sv": "%s"}', _row.name_sv)::JSONB
      WHERE identifier = _row.identifier;
    END IF;
  END LOOP;
END;
$$ LANGUAGE plpgsql;

ALTER TABLE SCHEMANAME.spatial_plan
  ALTER COLUMN name SET NOT NULL;
  DROP COLUMN name_fi,
  DROP COLUMN name_sv;

ALTER TABLE SCHEMANAME.contact
  RENAME TO planner;
  ADD COLUMN professional_title JSONB CHECK(check_language_string(professional_title));
  ADD COLUMN "role" JSONB CHECK(check_language_string("role"));
