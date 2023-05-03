DROP MATERIALIZED VIEW IF EXISTS SCHEMANAME.plan_regulations_area_view;
CREATE MATERIALIZED VIEW SCHEMANAME.plan_regulations_area_view AS
SELECT Row_Number() OVER () AS id,
    regulation.type AS type,
    regulation.geom AS geom,
    SCHEMANAME.text_value.value ->> 'fin' AS text_value_fin,
    SCHEMANAME.text_value.value ->> 'swe' AS text_value_swe,
    SCHEMANAME.numeric_double_value.value || ' ' || SCHEMANAME.numeric_double_value.unit_of_measure AS numeric_value,
    SCHEMANAME.numeric_range.minimum_value || '-' || SCHEMANAME.numeric_range.maximum_value || ' ' || SCHEMANAME.numeric_range.unit_of_measure AS numeric_range,
    SCHEMANAME.code_value.value AS code_value,
    SCHEMANAME.supplementary_information.type AS supplementary_information_type,
    info_numeric_range.minimum_value || '-' || info_numeric_range.maximum_value || ' ' || info_numeric_range.unit_of_measure AS supplementary_numeric_range
FROM (
        SELECT plan_regulation.local_id AS local_id,
            plan_regulation.type AS type,
            spatial_plan.geom AS geom
        FROM SCHEMANAME.plan_regulation
            INNER JOIN SCHEMANAME.spatial_plan_plan_regulation ON plan_regulation.local_id = spatial_plan_plan_regulation.plan_regulation_local_id
            INNER JOIN SCHEMANAME.spatial_plan ON spatial_plan.local_id = spatial_plan_plan_regulation.spatial_plan_local_id
        UNION
        -- add plan geometry to regulation
        SELECT plan_regulation.local_id AS local_id,
            plan_regulation.type AS type,
            zoning_element.geom AS geom
        FROM SCHEMANAME.plan_regulation
            INNER JOIN SCHEMANAME.zoning_element_plan_regulation ON plan_regulation.local_id = zoning_element_plan_regulation.plan_regulation_local_id
            INNER JOIN SCHEMANAME.zoning_element ON zoning_element.local_id = zoning_element_plan_regulation.zoning_element_local_id
        UNION
        -- add element geometry to regulation
        SELECT plan_regulation.local_id AS local_id,
            plan_regulation.type AS type,
            planned_space.geom AS geom
        FROM SCHEMANAME.plan_regulation
            INNER JOIN SCHEMANAME.planned_space_plan_regulation ON plan_regulation.local_id = planned_space_plan_regulation.plan_regulation_local_id
            INNER JOIN SCHEMANAME.planned_space ON planned_space.local_id = planned_space_plan_regulation.planned_space_local_id
        UNION
        -- add planned space geometry to regulation
        SELECT plan_regulation.local_id AS local_id,
            plan_regulation.type AS type,
            geometry_area_value.value as geom
        FROM SCHEMANAME.plan_regulation
            INNER JOIN SCHEMANAME.plan_regulation_geometry_area_value ON plan_regulation.local_id = plan_regulation_geometry_area_value.fk_plan_regulation
            INNER JOIN SCHEMANAME.geometry_area_value ON geometry_area_value.geometry_area_value_uuid = plan_regulation_geometry_area_value.fk_geometry_area_value
        -- add geometry area value to regulation
    ) AS regulation
    LEFT OUTER JOIN (
        SCHEMANAME.plan_regulation_text_value
        INNER JOIN SCHEMANAME.text_value ON text_value.text_value_uuid = plan_regulation_text_value.fk_text_value
    ) ON plan_regulation_text_value.fk_plan_regulation = regulation.local_id -- text values are used when visualizing names
    LEFT OUTER JOIN (
        SCHEMANAME.plan_regulation_numeric_double_value
        INNER JOIN SCHEMANAME.numeric_double_value ON numeric_double_value.numeric_double_value_uuid = plan_regulation_numeric_double_value.fk_numeric_double_value
    ) ON plan_regulation_numeric_double_value.fk_plan_regulation = regulation.local_id -- numeric values are used when visualizing some numeric regulations,
    -- e.g.kattokaltevuus, kerrosluku, melutaso, korkeusasema, rakennusoikeus, tehokkuusluku etc.
    LEFT OUTER JOIN (
        SCHEMANAME.plan_regulation_numeric_range
        INNER JOIN SCHEMANAME.numeric_range ON numeric_range.numeric_range_uuid = plan_regulation_numeric_range.fk_numeric_range
    ) ON plan_regulation_numeric_range.fk_plan_regulation = regulation.local_id -- numeric ranges are used when visualizing some numeric regulations,
    -- e.g. kattokaltevuus, kerrosluku, melutaso, korkeusasema, rakennusoikeus, tehokkuusluku etc.
    LEFT OUTER JOIN (
        SCHEMANAME.plan_regulation_code_value
        INNER JOIN SCHEMANAME.code_value ON code_value.code_value_uuid = plan_regulation_code_value.fk_code_value
    ) ON plan_regulation_code_value.fk_plan_regulation = regulation.local_id -- code values are used as extra information for limiting specific numeric regulations to specific code,
    -- e.g. käyttötarkoitusosuudet prosentteina, käyttötarkoitukset kerroksittain
    LEFT OUTER JOIN (
        SCHEMANAME.supplementary_information
        LEFT OUTER JOIN (
            SCHEMANAME.supplementary_information_numeric_range
            INNER JOIN SCHEMANAME.numeric_range AS info_numeric_range ON info_numeric_range.numeric_range_uuid = supplementary_information_numeric_range.fk_numeric_range
        ) ON supplementary_information_numeric_range.fk_supplementary_information = supplementary_information.producer_specific_id
    ) ON supplementary_information.fk_plan_regulation = regulation.local_id -- supplementary information numeric range is used in parking regulations to make the structure extra complex,
    -- e.g. pysäköintipaikkojen lukumäärä per kerrosneliömetri
;