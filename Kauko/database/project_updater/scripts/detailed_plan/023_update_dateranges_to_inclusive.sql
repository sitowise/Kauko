DO $$
LANGUAGE plpgsql
DECLARE
    table_name text;
BEGIN
    FOR table_name IN ('spatial_plan', 'zoning_element', 'planned_space', 'plan_regulation', 'plan_guidance')
    LOOP
        EXECUTE format('ALTER TABLE SCHEMANAME.%I ALTER COLUMN validity_time TYPE inclusive_daterange
            USING CASE
                WHEN validity_time IS NULL THEN NULL
                WHEN upper(validity_time) IS NOT NULL THEN
                    inclusive_daterange(lower(validity_time), upper(validity_time), ''[]'')
            ELSE
                inclusive_daterange(lower(validity_time), NULL, ''[]'')
            END;',
            table_name);
        RAISE NOTICE 'Validity time column in table % has been updated to inclusive_daterange.', table_name;
    END LOOP;
END $$;