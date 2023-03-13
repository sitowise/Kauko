ALTER TABLE SCHEMANAME.planning_detail_line
    ADD COLUMN name JSONB CHECK(check_language_string(name));

