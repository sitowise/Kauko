ALTER TABLE SCHEMANAME.zoning_element
    ALTER COLUMN environmental_change_nature
        DROP NOT NULL;

ALTER TABLE SCHEMANAME.planned_space
    ALTER COLUMN environmental_change_nature
        DROP NOT NULL;

ALTER TABLE SCHEMANAME.planning_detail_line
    ALTER COLUMN environmental_change_nature
        DROP NOT NULL;
