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
LEFT JOIN code_lists.legal_effectiveness_kind LEK ON LEK.codevalue = SP.legal_effectiveness;


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


-- View: $SCHEMANAME$.view_ryhti_plan_object

-- DROP VIEW IF EXISTS $SCHEMANAME$.view_ryhti_plan_object;

-----------------------------------------------------------------------------------------
--  VIEW VIEW_RYHTI_PLAN_OBJECT - Kaavakohteiden tiedot
--
--  2025-03-26 TPu
------------------------------------------------------------------------------------------	
CREATE OR REPLACE VIEW $SCHEMANAME$.view_ryhti_plan_object AS
SELECT -- Maankäyttöalue
    SPM.id AS plan_matter_key,
    SP.local_id AS plan_matter_phase_key,
    SP.local_plan_id AS plan_key,
    ZE.local_id AS plan_object_key,
    SPLS.uri AS life_cycle_status, 
    GRK.uri AS underground_status, 
    ST_SRID (ZE.geom) AS geometry_srid,
    ZE.geom AS geometry,
    ZE.name,
    ZE.description,
    ZE.valid_from AS period_of_validity_begin,
    ZE.valid_to AS period_of_validity_end
FROM
    $SCHEMANAME$.zoning_element ZE
JOIN $SCHEMANAME$.spatial_plan SP ON SP.local_id = ZE.spatial_plan
JOIN $SCHEMANAME$.spatial_plan_main SPM ON SPM.local_plan_id = SP.local_plan_id
JOIN code_lists.spatial_plan_lifecycle_status SPLS ON SPLS.codevalue = ZE.lifecycle_status
JOIN code_lists.ground_relativeness_kind GRK ON GRK.codevalue = ZE.ground_relative_position;


-- View: $SCHEMANAME$.view_ryhti_plan_decision

-- DROP VIEW IF EXISTS $SCHEMANAME$.view_ryhti_plan_decision;

------------------------------------------------------------------------------------------
--  VIEW VIEW_RYHTI_PLAN_DECISION - Kaavan päätöksen tiedot
--
--  2024-10-23 TPu
--  2025-01-24 TPu Muutettu lukemaan tiedot plan_decision ja koodistotauluista
--  2025-01-31 TPu: Muutettu plan_key -> plan_matter_key (4.2.2025: arvoksi spatial_plan_main.id)
------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW $SCHEMANAME$.view_ryhti_plan_decision AS
SELECT
    SPM.id AS plan_matter_key,  -- ex. plan_key,
    SP.local_id AS plan_matter_phase_key,
    PD.local_id AS plan_decision_key,
    PDN.uri AS name,
    PD.decision_date,
    PD.decision_adoption_date AS date_of_decision,
    PD.decision_article,
    PD.decision_text,
    PDMT.uri AS type_of_decision_maker,
    PD.decision_identifier,
    PD.date_of_validity,
    PD.fk_decision_maker AS decision_makers_key
FROM
    $SCHEMANAME$.plan_decision PD
JOIN $SCHEMANAME$.spatial_plan SP ON SP.fk_plan_decision = PD.local_id
JOIN $SCHEMANAME$.spatial_plan_main SPM ON SPM.local_plan_id = SP.local_plan_id
JOIN code_lists.plan_decision_name PDN ON PDN.codevalue = PD.name
JOIN code_lists.plan_decision_maker_type PDMT ON PDMT.codevalue = PD.decision_maker_type;


-- View: $SCHEMANAME$.view_ryhti_plan_regulation

-- DROP VIEW IF EXISTS $SCHEMANAME$.view_ryhti_plan_regulation;

------------------------------------------------------------------------------------------
--  VIEW VIEW_RYHTI_PLAN_REGULATION - Kaavan määräykset
--
--  2025-03-26 TPu: ensimmäinen versio. Arvot puuttuvat!
------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW $SCHEMANAME$.view_ryhti_plan_regulation AS
SELECT
    PR.local_id AS plan_regulation_key,
    SPLS.uri AS life_cycle_status,
    DPRK.uri AS type,
    PR.valid_from AS period_of_validity_begin,
    PR.valid_to AS period_of_validity_end
FROM
    $SCHEMANAME$.plan_regulation PR
JOIN code_lists.spatial_plan_lifecycle_status SPLS ON SPLS.codevalue = PR.life_cycle_status
JOIN code_lists.detail_plan_regulation_kind DPRK ON DPRK.codevalue = PR.type;


-- View: $SCHEMANAME$.view_ryhti_plan_regulation_group

-- DROP VIEW IF EXISTS $SCHEMANAME$.view_ryhti_plan_regulation_group;

------------------------------------------------------------------------------------------
--  VIEW VIEW_RYHTI_PLAN_REGULATION_GROUP - Kaavan määräysryhmät
--
--  2025-03-26 TPu
------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW $SCHEMANAME$.view_ryhti_plan_regulation_group AS
SELECT
    PRG.local_id AS plan_regulation_group_key,
    PRG.name,
    PRG.letter_identifier,
    PRG.color_number,
    PRG.group_number
FROM
    $SCHEMANAME$.plan_regulation_group PRG;


-- View: $SCHEMANAME$.view_ryhti_plan_regulation_group_requlation_relations

-- DROP VIEW IF EXISTS $SCHEMANAME$.view_ryhti_plan_regulation_group_requlation_relations;

------------------------------------------------------------------------------------------
--  VIEW VIEW_RYHTI_PLAN_REGULATION_GROUP_REGULATION_RELATIONS - Kaavan määräysryhmään kuuluvat kaavamääräykset
--
--  2025-03-26 TPu
------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW $SCHEMANAME$.view_ryhti_plan_regulation_group_requlation_relations AS
SELECT
    PRGR.plan_regulation_group_local_id AS plan_regulation_group_key,
    PRGR.plan_regulation_local_id AS plan_regulation_key
FROM
    $SCHEMANAME$.plan_regulation_group_regulation PRGR;


-- View: $SCHEMANAME$.view_ryhti_plan_regulation_group_relations

-- DROP VIEW IF EXISTS $SCHEMANAME$.view_ryhti_plan_regulation_group_relations;

------------------------------------------------------------------------------------------
--  VIEW VIEW_RYHTI_PLAN_REGULATION_GROUP_RELATIONS - Kaavakohteen kaavamääräysryhmät
--
--  2025-03-26 TPu: lisättävä loputkin kaavakohdelajit
------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW $SCHEMANAME$.view_ryhti_plan_regulation_group_relations AS
SELECT -- MAANKÄYTTÖALUE
    ZEPRG.zoning_element_local_id AS plan_object_key,
    ZEPRG.plan_regulation_group_local_id AS plan_regulation_group_key
FROM
    $SCHEMANAME$.zoning_element_plan_regulation_group ZEPRG;
