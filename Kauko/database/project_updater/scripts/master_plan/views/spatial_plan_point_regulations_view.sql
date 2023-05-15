DROP MATERIALIZED VIEW IF EXISTS SCHEMANAME.plan_regulations_point_view;
CREATE MATERIALIZED VIEW SCHEMANAME.plan_regulations_point_view AS
SELECT Row_Number() OVER () AS id,
    regulation.type AS type,
    regulation.geom AS geom,
    mprk.preflabel_fi AS type_name_fin,
    SCHEMANAME.text_value.value ->> 'fin' AS text_value_fin,
    SCHEMANAME.text_value.value ->> 'swe' AS text_value_swe,
    SCHEMANAME.numeric_double_value.value || ' ' || SCHEMANAME.numeric_double_value.unit_of_measure AS numeric_value,
    SCHEMANAME.numeric_range.minimum_value || '-' || SCHEMANAME.numeric_range.maximum_value || ' ' || SCHEMANAME.numeric_range.unit_of_measure AS numeric_range,
    SCHEMANAME.code_value.value AS code_value,
    SCHEMANAME.supplementary_information.type AS supplementary_information_type,
    info_numeric_range.minimum_value || '-' || info_numeric_range.maximum_value || ' ' || info_numeric_range.unit_of_measure AS supplementary_numeric_range
FROM (
        SELECT
            plan_regulation.local_id AS local_id,
            plan_regulation.type AS type,
            geometry_point_value.value as geom
        FROM SCHEMANAME.plan_regulation
            INNER JOIN SCHEMANAME.plan_regulation_geometry_point_value ON plan_regulation.local_id = plan_regulation_geometry_point_value.fk_plan_regulation
            INNER JOIN SCHEMANAME.geometry_point_value ON geometry_point_value.geometry_point_value_uuid = plan_regulation_geometry_point_value.fk_geometry_point_value
        WHERE geometry_point_value.is_active
        -- add geometry point value to regulation
    ) AS regulation
    INNER JOIN code_lists.master_plan_regulation_kind mprk ON mprk.codevalue = regulation.type
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
