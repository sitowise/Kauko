DROP VIEW IF EXISTS SCHEMANAME.zoning_element_view;

CREATE VIEW SCHEMANAME.zoning_element_view AS (
    Select
        zoning_element.identifier,
        zoning_element.planning_object_identifier,
        spatial_plan.land_administration_authority::integer As municipality_db_code,
        zoning_element.geom,
        zoning_element.created,
        zoning_element.localized_name,
        zoning_element.name As area_name,
        zoning_element.type,
        finnish_zoning_element_type.description As type_fi,
        Null As type_sv,
        zoning_element.up_to_dateness,
        finnish_up_to_dateness.description As up_to_dateness_fi,
        Null As up_to_dateness_sv,
        zoning_element.finnish_land_use_kind,
        finnish_land_use_kind.label As land_use_kind_fi,
        Null As land_use_kind_sv,
        zoning_element.valid_from,
        zoning_element.valid_to,
        zoning_element.block_number,
        zoning_element.parcel_number,
        zoning_element.validity,
        validity_type.description As validity_fi,
        Null As validity_sv
    From
        SCHEMANAME.spatial_plan Inner Join
        SCHEMANAME.zoning_element On SCHEMANAME.zoning_element.fk_spatial_plan =
                SCHEMANAME.spatial_plan.planning_object_identifier Inner Join
        code_lists.finnish_zoning_element_type On code_lists.finnish_zoning_element_type.value =
                SCHEMANAME.zoning_element.type Inner Join
        code_lists.finnish_up_to_dateness On code_lists.finnish_up_to_dateness.value =
                SCHEMANAME.zoning_element.up_to_dateness Inner Join
        code_lists.finnish_land_use_kind On code_lists.finnish_land_use_kind.code =
                SCHEMANAME.zoning_element.finnish_land_use_kind Inner Join
        code_lists.validity_type On SCHEMANAME.zoning_element.validity =
                code_lists.validity_type.value
    Where
        spatial_plan.is_released Is True
);