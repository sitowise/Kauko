-- AI Generated
-- ryhti_log also holds one row for each call made to Ryhti.
-- A call row has request_path set; a transfer row leaves the four call columns NULL.
ALTER TABLE $SCHEMANAME$.ryhti_log
    ADD COLUMN IF NOT EXISTS http_method text;
ALTER TABLE $SCHEMANAME$.ryhti_log
    ADD COLUMN IF NOT EXISTS request_path text;
ALTER TABLE $SCHEMANAME$.ryhti_log
    ADD COLUMN IF NOT EXISTS http_status integer;
ALTER TABLE $SCHEMANAME$.ryhti_log
    ADD COLUMN IF NOT EXISTS correlation_id text;
-- A transfer row still names at least one plan, planning matter or document.
-- A call row may name none (for example the token call).
ALTER TABLE $SCHEMANAME$.ryhti_log
    DROP CONSTRAINT IF EXISTS ensure_at_least_one_fk;
ALTER TABLE $SCHEMANAME$.ryhti_log
    ADD CONSTRAINT ensure_at_least_one_fk
        CHECK (
            request_path IS NOT NULL
            OR num_nonnulls(
                fk_spatial_plan,
                fk_spatial_plan_main,
                ryhti_plan_id,
                document_id
            ) > 0
        );
CREATE INDEX IF NOT EXISTS ryhti_log_transfer_id_idx
    ON $SCHEMANAME$.ryhti_log (transfer_id);
