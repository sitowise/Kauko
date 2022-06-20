DROP VIEW IF EXISTS SCHEMANAME.spatial_plan_view;

CREATE OR REPLACE VIEW SCHEMANAME.spatial_plan_view
    AS
    WITH contact_cte AS (
        SELECT spatial_plan_1.identifier,
            string_agg(contact.name, ';' ORDER BY (contact.name)) AS contacts
        FROM SCHEMANAME.spatial_plan spatial_plan_1
            LEFT JOIN SCHEMANAME.contact ON contact.fk_spatial_plan = spatial_plan_1.planning_object_identifier
        GROUP BY spatial_plan_1.identifier
        ), localized_objective_cte AS (
        SELECT spatial_plan_1.identifier,
            string_agg(localized_objective.objective, ';' ORDER BY localized_objective.objective) AS objectives
        FROM SCHEMANAME.spatial_plan spatial_plan_1
            LEFT JOIN SCHEMANAME.localized_objective ON localized_objective.fk_spatial_plan = spatial_plan_1.planning_object_identifier
        GROUP BY spatial_plan_1.identifier
        )
    SELECT spatial_plan.identifier,
    spatial_plan.planning_object_identifier,
    contact_cte.contacts,
    spatial_plan.geom,
    spatial_plan.name_fi,
    spatial_plan.name_sv,
    spatial_plan.plan_id,
    spatial_plan.approval_date,
    spatial_plan.approved_by,
    spatial_plan.epsg,
    spatial_plan.vertical_coordinate_system,
    spatial_plan.land_administration_authority::integer as municipality_db_code,
    finnish_municipality_codes.name AS municipality,
    spatial_plan.language,
    finnish_language.description AS language_fi,
    NULL AS language_sv,
    spatial_plan.origin,
    finnish_spatial_plan_origin.description AS description_fi,
    NULL AS description_sv,
    spatial_plan.planning_level,
    finnish_spatial_plan_level.description AS plan_level_fi,
    spatial_plan.status,
    finnish_spatial_plan_status.description AS plan_status_fi,
    NULL AS plan_status_sv,
    spatial_plan.plan_type,
    finnish_spatial_plan_type.description AS plan_type_fi,
    NULL AS plan_type_sv,
    spatial_plan.valid_from,
    spatial_plan.valid_to,
    spatial_plan.validity,
    validity_type.description AS validity_fi,
    NULL AS validity_sv,
    localized_objective_cte.objectives
    FROM SCHEMANAME.spatial_plan
        LEFT JOIN contact_cte ON contact_cte.identifier = spatial_plan.identifier
        LEFT JOIN localized_objective_cte ON localized_objective_cte.identifier = spatial_plan.identifier
        JOIN code_lists.finnish_municipality_codes ON finnish_municipality_codes.code::bpchar = spatial_plan.land_administration_authority
        JOIN code_lists.finnish_language ON finnish_language.value = spatial_plan.language
        JOIN code_lists.finnish_spatial_plan_origin ON finnish_spatial_plan_origin.value = spatial_plan.origin
        JOIN code_lists.finnish_spatial_plan_level ON finnish_spatial_plan_level.value = spatial_plan.planning_level
        JOIN code_lists.finnish_spatial_plan_status ON finnish_spatial_plan_status.value = spatial_plan.status
        JOIN code_lists.finnish_spatial_plan_type ON finnish_spatial_plan_type.value = spatial_plan.plan_type
        JOIN code_lists.validity_type ON validity_type.value = spatial_plan.validity
    WHERE spatial_plan.is_released IS TRUE;