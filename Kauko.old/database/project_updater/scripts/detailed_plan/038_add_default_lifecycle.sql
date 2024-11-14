ALTER TABLE SCHEMANAME.spatial_plan
    ALTER COLUMN lifecycle_status SET DEFAULT '01';
ALTER TABLE SCHEMANAME.zoning_element
    ALTER COLUMN lifecycle_status SET DEFAULT '01';
ALTER TABLE SCHEMANAME.planned_space
    ALTER COLUMN lifecycle_status SET DEFAULT '01';
ALTER TABLE SCHEMANAME.planning_detail_line
    ALTER COLUMN lifecycle_status SET DEFAULT '01';
ALTER TABLE SCHEMANAME.describing_line
    ALTER COLUMN lifecycle_status SET DEFAULT '01';
ALTER TABLE SCHEMANAME.describing_text
    ALTER COLUMN lifecycle_status SET DEFAULT '01';
