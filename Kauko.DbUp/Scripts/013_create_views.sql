-- View: $SCHEMANAME$.view_ryhti_plan_matter

-- DROP VIEW IF EXISTS $SCHEMANAME$.view_ryhti_plan_matter;

------------------------------------------------------------------------------------------
--  VIEW VIEW_RYHTI_PLAN_MATTER - Kaava-asian perustiedot
--
--  2024-10-03 TPu
--  2025-01-02 TPu  Poistettu geometry,
--                  Lisätty description, responsible_party_key
--  2025-01-?? TPu  Changed column name: plan_key -> plan_matter_key
--                  Changed plan_key to come from spatial_plan_main.id
--                  Added NULL condition to spatial_plan.type case-when expression
------------------------------------------------------------------------------------------

CREATE OR REPLACE VIEW $SCHEMANAME$.view_ryhti_plan_matter
AS
SELECT
    SPM.id AS plan_matter_key,
    SPM.ryhti_plan_id AS permanent_plan_identifier, 
    SP.land_administration_authority AS administrative_area_identifiers,
    SP.language,
    CASE 
        WHEN SP.type like '2%' THEN 2
        WHEN SP.type like '3%' THEN 3
        ELSE NULL
    END AS plan_main_type,
    SPK.uri AS plan_type,
    SPM.plan_identifier AS producer_plan_identifier,
    SP.initiation_time AS time_of_initiation,
    DOK.uri AS digital_origin,
    SPM.name,
    SP.created AS plan_created,
    PO.local_id as responsible_party_key,
    SPM.description
FROM
    $SCHEMANAME$.spatial_plan SP
JOIN $SCHEMANAME$.spatial_plan_main SPM ON SPM.local_plan_id = SP.local_plan_id
JOIN $SCHEMANAME$.plan_operator PO ON PO.local_id = SPM.fk_responsible
JOIN code_lists.spatial_plan_kind SPK ON SPK.codevalue = SP.type
JOIN code_lists.digital_origin_kind DOK ON DOK.codevalue = SP.digital_origin;


-- View: $SCHEMANAME$.view_ryhti_plan_phase

-- DROP VIEW IF EXISTS $SCHEMANAME$.view_ryhti_plan_phase;

------------------------------------------------------------------------------------------
--  VIEW VIEW_RYHTI_PLAN_PHASE - Kaavan vaiheen tiedot
--
--  2024-10-10 TPu
--  2025-01-?? TPu  Added spatial_plan_main to joins
--                  Changed column name: plan_key -> plan_matter_key
--                  Changed plan_key to come from spatial_plan_main.id
------------------------------------------------------------------------------------------

CREATE OR REPLACE VIEW $SCHEMANAME$.view_ryhti_plan_phase
AS
SELECT
    SPM.id AS plan_matter_key,
    SP.local_id as plan_matter_phase_key,
    SP.geom as geometry,
    SPLS.uri as life_cycle_status
FROM
    $SCHEMANAME$.spatial_plan SP
JOIN $SCHEMANAME$.spatial_plan_main SPM ON SPM.local_plan_id = SP.local_plan_id
JOIN code_lists.spatial_plan_lifecycle_status SPLS ON SPLS.codevalue = SP.lifecycle_status;
