ALTER TABLE SCHEMANAME.zoning_element
    ALTER COLUMN "name" TYPE jsonb
    USING json_build_object('fi', "name"),
	ADD CONSTRAINT check_language_string CHECK (check_language_string(name));
