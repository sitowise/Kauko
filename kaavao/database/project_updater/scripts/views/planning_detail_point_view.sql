DROP VIEW IF EXISTS SCHEMANAME.planning_detail_point_view;

CREATE VIEW SCHEMANAME.planning_detail_point_view AS (
    Select Distinct
    planning_detail_point.identifier,
    planning_detail_point.planning_object_identifier,
    spatial_plan.land_administration_authority::Integer As municipality_db_code,
    planning_detail_point.created,
    planning_detail_point.geom,
    planning_detail_point.type,
    finnish_planning_detail_point_type.description As type_fi,
    Null As type_sv,
    planning_detail_point.obligatory,
    planning_detail_point.validity,
    validity_type.description As validity_fi,
    Null As validity_sv,
    planning_detail_point.point_rotation,
    planning_detail_point.type_description
From
    SCHEMANAME.spatial_plan Inner Join
    SCHEMANAME.zoning_element On SCHEMANAME.zoning_element.spatial_plan =
            SCHEMANAME.spatial_plan.local_id Inner Join
    SCHEMANAME.zoning_element_plan_detail_point On
            SCHEMANAME.zoning_element_plan_detail_point.zoning_id =
            SCHEMANAME.zoning_element.planning_object_identifier Inner Join
    SCHEMANAME.planning_detail_point On
            SCHEMANAME.zoning_element_plan_detail_point.plan_detail_point_id =
            SCHEMANAME.planning_detail_point.planning_object_identifier Inner Join
    code_lists.finnish_planning_detail_point_type On
            code_lists.finnish_planning_detail_point_type.value =
            SCHEMANAME.planning_detail_point.type Inner Join
    code_lists.validity_type On code_lists.validity_type.value =
            SCHEMANAME.planning_detail_point.validity
Where
    spatial_plan.is_released Is True
);
