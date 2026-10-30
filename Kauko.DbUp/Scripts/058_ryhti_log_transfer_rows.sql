-- AI Generated

-- Plan identifiers in ryhti_log are stored as plain values. The referenced rows may be deleted.
ALTER TABLE $SCHEMANAME$.ryhti_log
    DROP CONSTRAINT IF EXISTS ryhti_log_fk_spatial_plan_fkey;

ALTER TABLE $SCHEMANAME$.ryhti_log
    DROP CONSTRAINT IF EXISTS ryhti_log_fk_spatial_plan_main_fkey;

-- user_id holds an optional text identifier.
ALTER TABLE $SCHEMANAME$.ryhti_log
    ALTER COLUMN user_id DROP NOT NULL;

ALTER TABLE $SCHEMANAME$.ryhti_log
    ALTER COLUMN user_id TYPE text USING user_id::text;

-- Document identifier for document transfers.
ALTER TABLE $SCHEMANAME$.ryhti_log
    ADD COLUMN IF NOT EXISTS document_id text;

-- Every row names at least one plan, planning matter or document.
ALTER TABLE $SCHEMANAME$.ryhti_log
    DROP CONSTRAINT IF EXISTS ensure_at_least_one_fk;

ALTER TABLE $SCHEMANAME$.ryhti_log
    ADD CONSTRAINT ensure_at_least_one_fk
        CHECK (
            num_nonnulls(
                fk_spatial_plan,
                fk_spatial_plan_main,
                ryhti_plan_id,
                document_id
            ) > 0
        );

-- New transfer status: transfer rejected by local validation.
INSERT INTO code_lists.ryhti_transfer_status (
    id,
    codevalue,
    preflabel_fi,
    preflabel_sv,
    preflabel_en
) VALUES
(4, 4, 'siirto hylätty paikallisessa tarkistuksessa', 'överföringen avvisades vid lokal kontroll', 'transfer rejected by local validation')
ON CONFLICT DO NOTHING;

SELECT pg_catalog.setval(
    'code_lists.ryhti_transfer_status_id_seq',
    (SELECT max(id) FROM code_lists.ryhti_transfer_status),
    true);
