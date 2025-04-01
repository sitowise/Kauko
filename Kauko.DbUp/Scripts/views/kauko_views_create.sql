-- View: $SCHEMANAME$.view_ryhti_plan

-- DROP VIEW IF EXISTS $SCHEMANAME$.view_ryhti_plan;

------------------------------------------------------------------------------------------
--  VIEW VIEW_RYHTI_PLAN - Kaavan tiedot
--
--  2025-03-26 TPu
------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW $SCHEMANAME$.view_ryhti_plan AS
SELECT
    SPM.id AS plan_matter_key,
    SP.local_id AS plan_matter_phase_key,
    SP.local_plan_id AS plan_key,
    SPLS.uri AS life_cycle_status,
    LEK.uri AS legal_effect_of_local_master_plans,
    NULL AS scale,
    ST_SRID (SP.geom) AS geometry_srid,
    SP.geom AS geometry,
    SP.version_name AS plan_description, -- onko tämä oikea teksti tähän?
    SP.valid_from AS period_of_validity_begin,
    SP.valid_to AS period_of_validity_end,
    SP.approval_time AS approval_date
FROM
    $SCHEMANAME$.spatial_plan SP
JOIN $SCHEMANAME$.spatial_plan_main SPM ON SPM.local_plan_id = SP.local_plan_id
JOIN code_lists.spatial_plan_lifecycle_status SPLS ON SPLS.codevalue = SP.lifecycle_status
JOIN code_lists.legal_effectiveness_kind LEK ON LEK.codevalue = SP.legal_effectiveness;



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


-- View: $SCHEMANAME$.view_ryhti_plan_interaction

-- DROP VIEW IF EXISTS $SCHEMANAME$.view_ryhti_plan_interaction;

------------------------------------------------------------------------------------------
--  VIEW VIEW_RYHTI_PLAN_INTERACTION - Kaavan vuorovaikutustapahtuman tiedot
--
--  2024-10-23 TPu  Luotu tyhjä näkymä
--  2025-01-14 TPu  Lisätty luku vuorovaikutustapahtuman tauluista
--  2025-01-?? TPu  Added spatial_plan_main to joins
--                  Changed column name: plan_key -> plan_matter_key
--                  Changed plan_key to come from spatial_plan_main.id
--                  Added column location_srid
------------------------------------------------------------------------------------------

CREATE OR REPLACE VIEW $SCHEMANAME$.view_ryhti_plan_interaction
AS
SELECT
    SPM.id AS plan_matter_key,
    SP.local_id AS plan_matter_phase_key,
    PIE.local_id AS interaction_event_key,
    PIET.uri AS interaction_event_type, 
    PIE.event_time_begin,
    PIE.event_time_end,
    PIE.name,
    PIE.description,
    PIE.geom AS location,
    st_srid(PIE.geom) AS location_srid,
    PIE.additional_information_link,
    PIE.cancelled
FROM
    $SCHEMANAME$.plan_interaction_event PIE
JOIN $SCHEMANAME$.spatial_plan_interaction_event SPIE ON SPIE.fk_plan_interaction_event = PIE.local_id
JOIN $SCHEMANAME$.spatial_plan SP ON SP.local_id = SPIE.fk_spatial_plan
JOIN $SCHEMANAME$.spatial_plan_main SPM ON SPM.local_plan_id = SP.local_plan_id
JOIN code_lists.plan_interaction_event_type PIET ON PIET.codevalue = PIE.interaction_event_type;


-- View: $SCHEMANAME$.view_ryhti_plan_handling

-- DROP VIEW IF EXISTS $SCHEMANAME$.view_ryhti_plan_handling;

------------------------------------------------------------------------------------------
--  VIEW VIEW_RYHTI_PLAN_HANDLING - Kaavan käsittelytapahtuman tiedot
--
--  2024-10-23 TPu
--  2025-01-17 TPu Lisätty luku käsittelytapahtuman tauluista ja poistettu geometria
--  2025-01-?? TPu  Added spatial_plan_main to joins
--                  Changed column name: plan_key -> plan_matter_key
--                  Changed plan_key to come from spatial_plan_main.id
------------------------------------------------------------------------------------------

CREATE OR REPLACE VIEW $SCHEMANAME$.view_ryhti_plan_handling AS
SELECT
    SPM.id AS plan_matter_key,
    SP.local_id AS plan_matter_phase_key,
    PHE.local_id AS handling_event_key,
    PHET.uri AS handling_event_type,
    PHE.event_time,
    PHE.name,
    PHE.description,
    PHE.additional_information_link,
    PHE.cancelled
FROM
    $SCHEMANAME$.plan_handling_event PHE
JOIN $SCHEMANAME$.spatial_plan SP ON SP.fk_plan_handling_event = PHE.local_id
JOIN $SCHEMANAME$.spatial_plan_main SPM ON SPM.local_plan_id = SP.local_plan_id
JOIN code_lists.plan_handling_event_type PHET ON PHET.codevalue = PHE.handling_event_type;
