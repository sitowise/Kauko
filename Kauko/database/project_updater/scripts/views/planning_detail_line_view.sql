DROP VIEW IF EXISTS SCHEMANAME.planning_detail_line_view;

CREATE VIEW SCHEMANAME.planning_detail_line_view AS (
Select Distinct
    planning_detail_line.identifier,
    planning_detail_line.planning_object_identifier,
    spatial_plan.land_administration_authority::Integer As municipality_db_code,
    planning_detail_line.created,
    planning_detail_line.geom,
    planning_detail_line.type,
    finnish_planning_detail_line_type.description As type_fi,
    Null As type_sv,
    planning_detail_line.type_description,
    planning_detail_line.obligatory,
    planning_detail_line.validity,
    validity_type.description As validity_fi,
    Null As validity_sv
From
    SCHEMANAME.spatial_plan Inner Join
    SCHEMANAME.zoning_element On SCHEMANAME.zoning_element.fk_spatial_plan =
            SCHEMANAME.spatial_plan.planning_object_identifier Inner Join
    SCHEMANAME.zoning_element_plan_detail_line On
            SCHEMANAME.zoning_element_plan_detail_line.zoning_id =
            SCHEMANAME.zoning_element.planning_object_identifier Inner Join
    SCHEMANAME.planning_detail_line On
            SCHEMANAME.zoning_element_plan_detail_line.plan_detail_line_id =
            SCHEMANAME.planning_detail_line.planning_object_identifier Inner Join
    code_lists.finnish_planning_detail_line_type On code_lists.finnish_planning_detail_line_type.value
            = SCHEMANAME.planning_detail_line.type Inner Join
    code_lists.validity_type On code_lists.validity_type.value =
            SCHEMANAME.planning_detail_line.validity
Where
    spatial_plan.is_released Is True
);