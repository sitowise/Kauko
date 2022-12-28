DROP VIEW IF EXISTS SCHEMANAME.planned_space_view;

CREATE VIEW SCHEMANAME.planned_space_view AS (
Select Distinct
    planned_space.identifier,
    planned_space.planning_object_identifier,
    spatial_plan.land_administration_authority::Integer As municipality_db_code,
    planned_space.geom,
    planned_space.created,
    planned_space.obligatory,
    planned_space.type,
    finnish_planned_space_type.description As type_fi,
    Null As type_sv,
    planned_space.validity,
    validity_type.description As validity_fi,
    Null As validity_sv,
    planned_space.valid_from,
    planned_space.valid_to
From
    porvoo_gk26.spatial_plan Inner Join
    porvoo_gk26.zoning_element On porvoo_gk26.zoning_element.spatial_plan =
            porvoo_gk26.spatial_plan.local_id Inner Join
    porvoo_gk26.zoning_element_planned_space On
            porvoo_gk26.zoning_element_planned_space.zoning_element_id =
            porvoo_gk26.zoning_element.planning_object_identifier Inner Join
    porvoo_gk26.planned_space On porvoo_gk26.zoning_element_planned_space.planned_space_id =
            porvoo_gk26.planned_space.planning_object_identifier Inner Join
    code_lists.finnish_planned_space_type On code_lists.finnish_planned_space_type.value =
            porvoo_gk26.planned_space.type Inner Join
    code_lists.validity_type On code_lists.validity_type.value =
            porvoo_gk26.planned_space.validity
Where
    spatial_plan.is_released Is True
);