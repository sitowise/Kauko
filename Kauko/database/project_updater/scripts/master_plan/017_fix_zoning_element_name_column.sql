ALTER TABLE SCHEMANAME.zoning_element
    ALTER COLUMN "name" TYPE jsonb
    USING CASE WHEN "name" IS NULL THEN NULL ELSE json_build_object('fin', "name") END,
	ADD CONSTRAINT check_language_string CHECK (check_language_string(name));
