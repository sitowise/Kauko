-- AI Generated
-- ryhti_log.transfer_id holds 32 lowercase hexadecimal digits as text instead of a uuid.
-- Existing uuid values keep their digits without hyphens.
ALTER TABLE $SCHEMANAME$.ryhti_log
    ALTER COLUMN transfer_id TYPE text USING replace(transfer_id::text, '-', '');

ALTER TABLE $SCHEMANAME$.ryhti_log
    DROP CONSTRAINT IF EXISTS ryhti_log_transfer_id_format;

ALTER TABLE $SCHEMANAME$.ryhti_log
    ADD CONSTRAINT ryhti_log_transfer_id_format
        CHECK (transfer_id ~ '^[0-9a-f]{32}$');
