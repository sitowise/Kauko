-- Table: $SCHEMANAME$.ryhti_log

-- DROP TABLE IF EXISTS $SCHEMANAME$.ryhti_log;

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.ryhti_log
(
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    transfer_id UUID NOT NULL,
    transfer_type TEXT,
    transfer_status INTEGER,
    timestamp TIMESTAMP WITH TIME ZONE NOT NULL,
    user_id UUID NOT NULL,
    message JSONB,
    request JSONB,
    fk_spatial_plan TEXT NOT NULL,
    CONSTRAINT ryhti_log_fk_spatial_plan_fkey FOREIGN KEY (fk_spatial_plan)
        REFERENCES $SCHEMANAME$.spatial_plan (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED
);
