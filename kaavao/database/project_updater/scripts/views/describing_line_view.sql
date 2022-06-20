DROP VIEW IF EXISTS SCHEMANAME.describing_line_view;

CREATE VIEW SCHEMANAME.describing_line_view AS (
    Select Distinct
        describing_line.identifier,
        spatial_plan.land_administration_authority::Integer As municipality_db_code,
        describing_line.geom,
        describing_line.type,
        describing_line.validity,
        validity_type.value As validity_fi,
        Null As validity_sv
    From
        SCHEMANAME.spatial_plan Inner Join
        SCHEMANAME.zoning_element On SCHEMANAME.zoning_element.fk_spatial_plan =
                SCHEMANAME.spatial_plan.planning_object_identifier Inner Join
        SCHEMANAME.zoning_element_describing_line On SCHEMANAME.zoning_element_describing_line.zoning_id
                = SCHEMANAME.zoning_element.planning_object_identifier Inner Join
        SCHEMANAME.describing_line On SCHEMANAME.zoning_element_describing_line.describing_line_id =
                SCHEMANAME.describing_line.identifier Inner Join
        code_lists.validity_type On code_lists.validity_type.value =
                SCHEMANAME.describing_line.validity
    Where
        spatial_plan.is_released Is True
);