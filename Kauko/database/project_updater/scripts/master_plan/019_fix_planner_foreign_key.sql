ALTER TABLE SCHEMANAME.planner DROP CONSTRAINT planner_fk_spatial_plan;
ALTER TABLE SCHEMANAME.planner
    ADD COLUMN temp_fk_spatial_plan TEXT;

UPDATE SCHEMANAME.planner
    SET temp_fk_spatial_plan = sp.local_id
    FROM SCHEMANAME.spatial_plan sp
    WHERE sp.producer_specific_id = planner.fk_spatial_plan;

ALTER TABLE SCHEMANAME.planner
    DROP COLUMN fk_spatial_plan,
    RENAME COLUMN temp_fk_spatial_plan TO fk_spatial_plan;

ALTER TABLE SCHEMANAME.planner
    ADD CONSTRAINT planner_fk_spatial_plan FOREIGN KEY (fk_spatial_plan)
        REFERENCES SCHEMANAME.spatial_plan (local_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
        DEFERRABLE INITIALLY DEFERRED;
