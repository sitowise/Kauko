-- View: $SCHEMANAME$.view_ryhti_plan

-- DROP VIEW IF EXISTS $SCHEMANAME$.view_ryhti_plan;

------------------------------------------------------------------------------------------
--  VIEW VIEW_RYHTI_PLAN - Kaavan tiedot
--
--  2025-03-26 TPu
--  2025-05-28 TKu  Changed plan_key to come from spatial_plan.local_id
------------------------------------------------------------------------------------------

CREATE OR REPLACE VIEW $SCHEMANAME$.view_ryhti_plan AS
SELECT
    SPM.id AS plan_matter_key,
    SP.local_id AS plan_matter_phase_key,
    SP.local_id AS plan_key,
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
--  2025-05-28 TKu  Changed plan_key to come from spatial_plan.local_id
------------------------------------------------------------------------------------------

CREATE OR REPLACE VIEW $SCHEMANAME$.view_ryhti_plan_object AS
SELECT -- Maankäyttöalue
    SPM.id AS plan_matter_key,
    SP.local_id AS plan_matter_phase_key,
    SP.local_id AS plan_key,
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


-- View: $SCHEMANAME$.view_ryhti_plan_regulation_group_regulation_relations

-- DROP VIEW IF EXISTS $SCHEMANAME$.view_ryhti_plan_regulation_group_regulation_relations;

------------------------------------------------------------------------------------------
--  VIEW VIEW_RYHTI_PLAN_REGULATION_GROUP_REGULATION_RELATIONS - Kaavan määräysryhmään kuuluvat kaavamääräykset
--
--  2025-03-26 TPu
--  2025-04-10 TPu: näkymän nimen kirjoitusvirhe korjattu 
------------------------------------------------------------------------------------------	

CREATE OR REPLACE VIEW $SCHEMANAME$.view_ryhti_plan_regulation_group_regulation_relations AS
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


-- View: $SCHEMANAME$.view_ryhti_plan_operator

-- DROP VIEW IF EXISTS $SCHEMANAME$.view_ryhti_plan_operator;

------------------------------------------------------------------------------------------
--  VIEW VIEW_RYHTI_PLAN_OPERATOR - Kaavan toimijan tiedot (esim. päätöksen tekijä, kaavan vastuutaho)
--
--  2024-10-23 TPu
------------------------------------------------------------------------------------------

CREATE OR REPLACE VIEW $SCHEMANAME$.view_ryhti_plan_operator AS
SELECT
    PO.local_id AS plan_operator_key,
    PO.first_name AS first_name,
    PO.last_name AS last_name,
    PO.professional_title AS title,
    PO.organization_name AS organization_name,
    PO.business_id AS business_id
FROM
    $SCHEMANAME$.plan_operator PO;


-- View: $SCHEMANAME$.view_ryhti_plan_regulation_additional_information

-- DROP VIEW IF EXISTS $SCHEMANAME$.view_ryhti_plan_regulation_additional_information;

------------------------------------------------------------------------------------------
--  VIEW VIEW_RYHTI_PLAN_REGULATION_ADDITIONAL_INFORMATION - Kaavamääräyksen lisätiedot
--
--  2025-04-16 TKu
------------------------------------------------------------------------------------------

CREATE OR REPLACE VIEW $SCHEMANAME$.view_ryhti_plan_regulation_additional_information AS
SELECT
    PRSI.fk_plan_regulation AS plan_regulation_key,
    SI.local_id AS additional_information_key,
    DPAIK.uri AS type,
    CV.value AS code_value,
    EPV.value AS elevation_position_value,
    ERV.minimum_value AS elevation_range_minimum_value,
    ERV.maximum_value AS elevation_range_maximum_value,
    GAV.value AS geometry_area_value,
    GLV.value AS geometry_line_value,
    GPV.value AS geometry_point_value,
    NV.value AS numeric_value,
    NR.minimum_value AS numeric_range_minimum_value,
    NR.maximum_value AS numeric_range_maximum_value,
    TV.value AS text_value,
    TIV.value AS time_instant_value,
    TPV.value AS time_period_value
FROM
    $SCHEMANAME$.supplementary_information SI
JOIN code_lists.detail_plan_addition_information_kind DPAIK ON DPAIK.codevalue = SI.type
JOIN $SCHEMANAME$.plan_regulation_supplementary_information PRSI ON PRSI.fk_supplementary_information = SI.local_id
LEFT JOIN $SCHEMANAME$.code_value CV ON CV.code_value_uuid = SI.fk_code_value
LEFT JOIN $SCHEMANAME$.elevation_position_value EPV ON EPV.elevation_position_value_uuid = SI.fk_elevation_position_value
LEFT JOIN $SCHEMANAME$.elevation_range_value ERV ON ERV.elevation_range_value_uuid = SI.fk_elevation_range_value
LEFT JOIN $SCHEMANAME$.geometry_area_value GAV ON GAV.geometry_area_value_uuid = SI.fk_geometry_area_value
LEFT JOIN $SCHEMANAME$.geometry_line_value GLV ON GLV.geometry_line_value_uuid = SI.fk_geometry_line_value
LEFT JOIN $SCHEMANAME$.geometry_point_value GPV ON GPV.geometry_point_value_uuid = SI.fk_geometry_point_value
LEFT JOIN $SCHEMANAME$.numeric_value NV ON NV.numeric_value_uuid = SI.fk_numeric_value
LEFT JOIN $SCHEMANAME$.numeric_range NR ON NR.numeric_range_uuid = SI.fk_numeric_range
LEFT JOIN $SCHEMANAME$.text_value TV ON TV.text_value_uuid = SI.fk_text_value
LEFT JOIN $SCHEMANAME$.time_instant_value TIV ON TIV.time_instant_uuid = SI.fk_time_instant_value
LEFT JOIN $SCHEMANAME$.time_period_value TPV ON TPV.time_period_uuid = SI.fk_time_period_value;


-- View: $SCHEMANAME$.view_ryhti_plan_attachment_document

-- DROP VIEW IF EXISTS $SCHEMANAME$.view_ryhti_plan_attachment_document;

------------------------------------------------------------------------------------------
--  VIEW VIEW_RYHTI_PLAN_ATTACHMENT_DOCUMENT - Liiteasiakirjat
--
--  2025-04-16 TKu
--  2025-05-28 TKu  Changed plan_key to come from spatial_plan.local_id
------------------------------------------------------------------------------------------

CREATE OR REPLACE VIEW $SCHEMANAME$.view_ryhti_plan_attachment_document AS
SELECT
    SPM.id AS plan_matter_key,
    SP.local_id AS plan_matter_phase_key,
    SP.local_id AS plan_key,
    DOC.local_id AS attachment_document_key,
    DOC.document_id AS document_identifier,
    DOC.name,
    PDCT.uri AS personal_data_content,
    PC.uri AS category_of_publicity,
    DOC.accessibility,
    DRT.uri AS retention_time,
    DOC.confirmation_date,
    DOC.file_id AS file_key,
    NULL AS descriptors,
    DOC.document_date,
    DOC.arrived_date,
    DK.uri AS type_of_attachment,
    DOC.document_specification,
    (
        SELECT json_agg(RL.code)
        FROM $SCHEMANAME$.document_language DL
        JOIN code_lists.ryhti_language RL ON RL.id = DL.fk_language
        WHERE DL.fk_document = DOC.local_id
    ) AS languages,
    (
        SELECT json_agg(DOC2.document_id)
        FROM $SCHEMANAME$.document_document DD
        JOIN $SCHEMANAME$.document DOC2 ON DOC2.local_id = DD.referenced_document_local_id
        WHERE DD.referencing_document_local_id = DOC.local_id
    ) AS related_plan_attachment_documents
FROM
    $SCHEMANAME$.document DOC
JOIN $SCHEMANAME$.spatial_plan_document SPD ON SPD.document_local_id = DOC.local_id
JOIN $SCHEMANAME$.spatial_plan SP ON SP.local_id = SPD.spatial_plan_local_id
JOIN $SCHEMANAME$.spatial_plan_main SPM ON SPM.local_plan_id = SP.local_plan_id
JOIN code_lists.personal_data_content_type PDCT ON PDCT.codevalue = DOC.personal_data_content
JOIN code_lists.publicity_category PC ON PC.codevalue = DOC.category_of_publicity
JOIN code_lists.document_retention_time DRT ON DRT.codevalue = DOC.retention_time
JOIN code_lists.document_kind DK ON DK.codevalue = DOC.type
WHERE
    DOC.type NOT IN ('03', '05'); -- Rajataan pois liitetyypit 03 Kaavakartta ja 05 Kaavakartta ja kaavamääräykset


-- View: $SCHEMANAME$.view_ryhti_plan_map

-- DROP VIEW IF EXISTS $SCHEMANAME$.view_ryhti_plan_map;

------------------------------------------------------------------------------------------
--  VIEW VIEW_RYHTI_PLAN_MAP - Kaavakartta
--
--  2025-04-23 TPu
--  2025-05-28 TKu  Changed plan_key to come from spatial_plan.local_id
------------------------------------------------------------------------------------------

CREATE OR REPLACE VIEW $SCHEMANAME$.view_ryhti_plan_map AS
SELECT
    SPM.id AS plan_matter_key,
    SP.local_id AS plan_matter_phase_key,
    SP.local_id AS plan_key,
    DOC.local_id AS map_key,
    DOC.name,
    DOC.file_id AS file_key,
    ST_SRID (SP.geom) AS geometry_srid
FROM
    $SCHEMANAME$.document DOC
JOIN $SCHEMANAME$.spatial_plan_document SPD ON SPD.document_local_id = DOC.local_id
JOIN $SCHEMANAME$.spatial_plan SP ON SP.local_id = SPD.spatial_plan_local_id
JOIN $SCHEMANAME$.spatial_plan_main SPM ON SPM.local_plan_id = SP.local_plan_id
WHERE
    DOC.type IN ('03', '05'); -- Mukana vain liitetyypit 03 Kaavakartta ja 05 Kaavakartta ja kaavamääräykset


-- View: $SCHEMANAME$.view_ryhti_plan_attachment_document_operator

-- DROP VIEW IF EXISTS $SCHEMANAME$.view_ryhti_plan_attachment_document_operator;

------------------------------------------------------------------------------------------
--  VIEW VIEW_RYHTI_PLAN_ATTACHMENT_DOCUMENT_OPERATOR - Liiteasiakirjojen laatijat
--
--  2025-04-16 TKu
------------------------------------------------------------------------------------------

CREATE OR REPLACE VIEW $SCHEMANAME$.view_ryhti_plan_attachment_document_operator AS
SELECT
    POD.fk_document AS attachment_document_key,
    POD.fk_plan_operator AS plan_operator_key
FROM
    $SCHEMANAME$.plan_operator_document POD;
