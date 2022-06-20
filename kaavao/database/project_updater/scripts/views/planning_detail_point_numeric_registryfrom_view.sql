DROP VIEW IF EXISTS SCHEMANAME.planning_detail_point_numeric_registryform_view;

CREATE VIEW SCHEMANAME.planning_detail_point_numeric_registryform_view AS
Select
    SCHEMANAME.planning_detail_point_numeric_value.planning_detail_point_id::VARCHAR As planning_detail_point_uuid,
    SCHEMANAME.planning_detail_point_numeric_value.numeric_id::VARCHAR As numeric_uuid
From
    SCHEMANAME.planning_detail_point_numeric_value