-- RYHTIEXPORT-310: Eriytetään spatial_plan käsittelyvaiheeseen ja kaavaan
--
-- Tarkoitus:
--   Erotetaan kaava-asian käsittelyvaihe (spatial_plan_phase) omaksi taulukseen.
--   Aiemmin spatial_plan sisälsi sekä käsittelyvaiheen että kaavan tiedot.
--   Tämän jälkeen:
--     - spatial_plan_main  = kaava-asia (PlanMatter)
--     - spatial_plan_phase = käsittelyvaihe (PlanMatterPhase)
--     - spatial_plan       = kaava (Plan)
--
-- Esiehdot:
--   - Skripti 050: local_plan_key lisätty spatial_plan-tauluun
--   - Skripti 051: vanhat triggerit poistettu/disabloitu
--
-- Muutokset:
--   1. Nimeä spatial_plan_main.local_plan_id -> local_plan_main_id
--   2. Lisää PlanMatter-tason kentät spatial_plan_main-tauluun
--   3. Kopioi PlanMatter-tason kentät spatial_plan -> spatial_plan_main
--   4. Luo spatial_plan_phase-taulu
--   5. Kopioi rivit spatial_plan -> spatial_plan_phase
--   6. Lisää fk_spatial_plan_phase spatial_plan-tauluun ja aseta arvot
--   7. Päivitä plan_decision FK: spatial_plan -> spatial_plan_phase
--   8. Päivitä plan_handling_event FK: spatial_plan -> spatial_plan_phase
--   9. Päivitä spatial_plan_interaction_event FK: fk_spatial_plan -> fk_spatial_plan_phase
--  10. Poista vanhat sarakkeet spatial_plan-taulusta
--
-- Tekijä: RYHTIEXPORT-310
-- Päivämäärä: 2026-05-15

BEGIN;

-- ============================================================================
-- VAIHE 1: Nimeä spatial_plan_main.local_plan_id -> local_plan_main_id
-- ============================================================================

ALTER TABLE $SCHEMANAME$.spatial_plan_main
    RENAME COLUMN local_plan_id TO local_plan_main_id;

-- Päivitä myös FK-rajoite spatial_plan-taulussa (viittaa nyt uuteen sarakenimeen)
-- Rajoite viittaa sarakkeeseen nimellä, joten se on voimassa automaattisesti
-- kun sarake nimetään uudelleen. Nimetään rajoite selkeyden vuoksi.
ALTER TABLE $SCHEMANAME$.spatial_plan_main
    RENAME CONSTRAINT spatial_plan_main_local_plan_id_key TO spatial_plan_main_local_plan_main_id_key;

-- ============================================================================
-- VAIHE 2: Lisää PlanMatter-tason kentät spatial_plan_main-tauluun
-- ============================================================================

ALTER TABLE $SCHEMANAME$.spatial_plan_main
    ADD COLUMN IF NOT EXISTS type VARCHAR(3),
    ADD COLUMN IF NOT EXISTS initiation_time DATE,
    ADD COLUMN IF NOT EXISTS digital_origin VARCHAR(4),
    ADD COLUMN IF NOT EXISTS land_administration_authority BPCHAR(3);

-- ============================================================================
-- VAIHE 3: Kopioi PlanMatter-tason kentät spatial_plan -> spatial_plan_main
--
-- Koska yhdellä spatial_plan_main-rivillä voi olla useita spatial_plan-rivejä,
-- otetaan arvot ensimmäisestä (vanhimmasta) spatial_plan-rivistä.
-- ============================================================================

UPDATE $SCHEMANAME$.spatial_plan_main SPM
SET
    type                       = SP.type,
    initiation_time            = SP.initiation_time,
    digital_origin             = SP.digital_origin,
    land_administration_authority = SP.land_administration_authority
FROM (
    SELECT DISTINCT ON (local_plan_id)
        local_plan_id,
        type,
        initiation_time,
        digital_origin,
        land_administration_authority
    FROM $SCHEMANAME$.spatial_plan
    ORDER BY local_plan_id, id ASC
) SP
WHERE SPM.local_plan_main_id = SP.local_plan_id;

-- ============================================================================
-- VAIHE 4: Luo spatial_plan_phase-taulu
-- ============================================================================

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.spatial_plan_phase (
    id                  INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY,
    local_phase_key     TEXT    NOT NULL DEFAULT (uuid_generate_v4())::text,
    local_plan_main_id  TEXT    NOT NULL,
    lifecycle_status    VARCHAR(3) NOT NULL DEFAULT '01',
    geom                GEOMETRY(MultiPolygon, $PROJECTSRID$),
    version_name        TEXT    NOT NULL,
    fk_plan_handling_event TEXT,
    fk_plan_decision       TEXT,
    created             TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    CONSTRAINT spatial_plan_phase_pkey PRIMARY KEY (id),
    CONSTRAINT spatial_plan_phase_local_phase_key_key UNIQUE (local_phase_key),
    CONSTRAINT spatial_plan_phase_fk_spatial_plan_main FOREIGN KEY (local_plan_main_id)
        REFERENCES $SCHEMANAME$.spatial_plan_main (local_plan_main_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE RESTRICT
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT spatial_plan_phase_lifecycle_status_fkey FOREIGN KEY (lifecycle_status)
        REFERENCES code_lists.spatial_plan_lifecycle_status (codevalue) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE RESTRICT
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT spatial_plan_phase_fk_plan_handling_event_fkey FOREIGN KEY (fk_plan_handling_event)
        REFERENCES $SCHEMANAME$.plan_handling_event (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE RESTRICT
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT spatial_plan_phase_fk_plan_decision_fkey FOREIGN KEY (fk_plan_decision)
        REFERENCES $SCHEMANAME$.plan_decision (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE RESTRICT
        DEFERRABLE INITIALLY DEFERRED
);

-- ============================================================================
-- VAIHE 5: Kopioi rivit spatial_plan -> spatial_plan_phase
--
-- Käytetään spatial_plan.local_plan_key uuden spatial_plan_phase.local_phase_key-arvona,
-- jotta viittaukset voidaan asettaa seuraavassa vaiheessa.
-- ============================================================================

INSERT INTO $SCHEMANAME$.spatial_plan_phase (
    local_phase_key,
    local_plan_main_id,
    lifecycle_status,
    geom,
    version_name,
    fk_plan_handling_event,
    fk_plan_decision,
    created
)
SELECT
    SP.local_plan_key,
    SP.local_plan_id,
    SP.lifecycle_status,
    SP.geom,
    SP.version_name,
    SP.fk_plan_handling_event,
    SP.fk_plan_decision,
    SP.created
FROM $SCHEMANAME$.spatial_plan SP;

-- ============================================================================
-- VAIHE 6: Lisää fk_spatial_plan_phase spatial_plan-tauluun ja aseta arvot
-- ============================================================================

ALTER TABLE $SCHEMANAME$.spatial_plan
    ADD COLUMN IF NOT EXISTS fk_spatial_plan_phase TEXT;

-- Aseta viittaus: spatial_plan.local_plan_key = spatial_plan_phase.local_phase_key
UPDATE $SCHEMANAME$.spatial_plan SP
SET fk_spatial_plan_phase = SPP.local_phase_key
FROM $SCHEMANAME$.spatial_plan_phase SPP
WHERE SPP.local_phase_key = SP.local_plan_key;

-- Validointi: varmista että kaikki rivit saivat viittauksen
DO $$
DECLARE
    missing_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO missing_count
    FROM $SCHEMANAME$.spatial_plan
    WHERE fk_spatial_plan_phase IS NULL;

    IF missing_count > 0 THEN
        RAISE EXCEPTION 'Validointivirhe: % spatial_plan-riviä ilman fk_spatial_plan_phase-arvoa', missing_count;
    END IF;
END;
$$;

-- Lisää NOT NULL -rajoite ja FK nyt kun arvot on asetettu
ALTER TABLE $SCHEMANAME$.spatial_plan
    ALTER COLUMN fk_spatial_plan_phase SET NOT NULL;

ALTER TABLE $SCHEMANAME$.spatial_plan
    ADD CONSTRAINT spatial_plan_fk_spatial_plan_phase_fkey FOREIGN KEY (fk_spatial_plan_phase)
        REFERENCES $SCHEMANAME$.spatial_plan_phase (local_phase_key) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE RESTRICT
        DEFERRABLE INITIALLY DEFERRED;

-- ============================================================================
-- VAIHE 7: Päivitä plan_decision FK: spatial_plan -> spatial_plan_phase
--
-- plan_decision.local_id on jo viitattuna spatial_plan_phase.fk_plan_decision-sarakkeessa.
-- Ei tarvita rakenteellisia muutoksia plan_decision-tauluun — FK on spatial_plan_phase-puolella.
-- ============================================================================

-- (Ei rakenteellisia muutoksia plan_decision-tauluun tässä migraatiossa)

-- ============================================================================
-- VAIHE 8: Päivitä plan_handling_event FK: spatial_plan -> spatial_plan_phase
--
-- plan_handling_event.local_id on jo viitattuna spatial_plan_phase.fk_plan_handling_event-sarakkeessa.
-- Ei tarvita rakenteellisia muutoksia plan_handling_event-tauluun.
-- ============================================================================

-- (Ei rakenteellisia muutoksia plan_handling_event-tauluun tässä migraatiossa)

-- ============================================================================
-- VAIHE 9: Päivitä spatial_plan_interaction_event FK:
--          fk_spatial_plan -> fk_spatial_plan_phase
-- ============================================================================

-- Lisää uusi sarake
ALTER TABLE $SCHEMANAME$.spatial_plan_interaction_event
    ADD COLUMN IF NOT EXISTS fk_spatial_plan_phase TEXT;

-- Aseta arvot: hae local_phase_key spatial_plan_phase-taulusta
UPDATE $SCHEMANAME$.spatial_plan_interaction_event SPIE
SET fk_spatial_plan_phase = SPP.local_phase_key
FROM $SCHEMANAME$.spatial_plan SP
JOIN $SCHEMANAME$.spatial_plan_phase SPP ON SPP.local_phase_key = SP.local_plan_key
WHERE SP.local_id = SPIE.fk_spatial_plan;

-- Validointi: varmista että kaikki rivit saivat viittauksen
DO $$
DECLARE
    missing_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO missing_count
    FROM $SCHEMANAME$.spatial_plan_interaction_event
    WHERE fk_spatial_plan_phase IS NULL;

    IF missing_count > 0 THEN
        RAISE EXCEPTION 'Validointivirhe: % spatial_plan_interaction_event-riviä ilman fk_spatial_plan_phase-arvoa', missing_count;
    END IF;
END;
$$;

-- Poista vanha FK-rajoite ja sarake
ALTER TABLE $SCHEMANAME$.spatial_plan_interaction_event
    DROP CONSTRAINT IF EXISTS spatial_plan_interaction_event_fk_spatial_plan_fkey;

ALTER TABLE $SCHEMANAME$.spatial_plan_interaction_event
    DROP COLUMN IF EXISTS fk_spatial_plan;

-- Lisää NOT NULL ja uusi FK
ALTER TABLE $SCHEMANAME$.spatial_plan_interaction_event
    ALTER COLUMN fk_spatial_plan_phase SET NOT NULL;

ALTER TABLE $SCHEMANAME$.spatial_plan_interaction_event
    ADD CONSTRAINT spatial_plan_interaction_event_fk_spatial_plan_phase_fkey
        FOREIGN KEY (fk_spatial_plan_phase)
        REFERENCES $SCHEMANAME$.spatial_plan_phase (local_phase_key) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE RESTRICT
        DEFERRABLE INITIALLY DEFERRED;

-- ============================================================================
-- VAIHE 10: Poista vanhat sarakkeet spatial_plan-taulusta
-- ============================================================================

-- Poista FK-rajoitteet ennen sarakkeiden poistoa
ALTER TABLE $SCHEMANAME$.spatial_plan
    DROP CONSTRAINT IF EXISTS spatial_plan_fk_plan_handling_event_fkey;

ALTER TABLE $SCHEMANAME$.spatial_plan
    DROP CONSTRAINT IF EXISTS spatial_plan_fk_plan_decision_fkey;

ALTER TABLE $SCHEMANAME$.spatial_plan
    DROP CONSTRAINT IF EXISTS spatial_plan_type_fkey;

ALTER TABLE $SCHEMANAME$.spatial_plan
    DROP CONSTRAINT IF EXISTS spatial_plan_digital_origin_fkey;

ALTER TABLE $SCHEMANAME$.spatial_plan
    DROP CONSTRAINT IF EXISTS fk_finnish_muncipality;

ALTER TABLE $SCHEMANAME$.spatial_plan
    DROP CONSTRAINT IF EXISTS spatial_plan_main_local_plan_id_fk;

-- Poista sarakkeet
ALTER TABLE $SCHEMANAME$.spatial_plan
    DROP COLUMN IF EXISTS type,
    DROP COLUMN IF EXISTS initiation_time,
    DROP COLUMN IF EXISTS digital_origin,
    DROP COLUMN IF EXISTS land_administration_authority,
    DROP COLUMN IF EXISTS fk_plan_handling_event,
    DROP COLUMN IF EXISTS fk_plan_decision,
    DROP COLUMN IF EXISTS local_plan_id;

-- ============================================================================
-- LOPULLINEN VALIDOINTI
-- ============================================================================

DO $$
DECLARE
    phase_count     INTEGER;
    plan_count      INTEGER;
    orphan_count    INTEGER;
BEGIN
    SELECT COUNT(*) INTO phase_count FROM $SCHEMANAME$.spatial_plan_phase;
    SELECT COUNT(*) INTO plan_count  FROM $SCHEMANAME$.spatial_plan;

    IF phase_count <> plan_count THEN
        RAISE EXCEPTION 'Validointivirhe: spatial_plan_phase-rivejä (%) ei vastaa spatial_plan-rivejä (%)',
            phase_count, plan_count;
    END IF;

    -- Varmista ettei orpoja spatial_plan-rivejä ole
    SELECT COUNT(*) INTO orphan_count
    FROM $SCHEMANAME$.spatial_plan SP
    LEFT JOIN $SCHEMANAME$.spatial_plan_phase SPP ON SPP.local_phase_key = SP.fk_spatial_plan_phase
    WHERE SPP.local_phase_key IS NULL;

    IF orphan_count > 0 THEN
        RAISE EXCEPTION 'Validointivirhe: % spatial_plan-riviä ilman vastaavaa spatial_plan_phase-riviä', orphan_count;
    END IF;

    RAISE NOTICE 'Migraatio 052 valmis: % käsittelyvaihetta, % kaavaa', phase_count, plan_count;
END;
$$;

COMMIT;
