CREATE OR REPLACE VIEW all_plans_view AS (
    SELECT
        sp.local_id AS 'spatial_plan_local_id',
        string_agg(ze.local_id, ';') AS 'zoning_element_local_ids',
        string_agg(zeps.planned_space_local_id, ';') AS 'planned_space_local_ids',
    FROM SCHEMANAME.spatial_plan sp
    JOIN SCHEMANAME.planner p
        ON p.fk_spatial_plan
    JOIN SCHEMANAME.zoning_element ze
        ON ze.spatial_plan = sp.local_id
    JOIN SCHEMANAME.zoning_element_planned_space zeps
        ON zeps.zoning_element = ze.local_id

)