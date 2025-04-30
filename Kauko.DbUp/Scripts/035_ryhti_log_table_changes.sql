ALTER TABLE $SCHEMANAME$.ryhti_log
ALTER COLUMN fk_spatial_plan DROP NOT NULL;

ALTER TABLE $SCHEMANAME$.ryhti_log
    ADD fk_spatial_plan_main text,
    ADD CONSTRAINT ryhti_log_fk_spatial_plan_main_fkey FOREIGN KEY (fk_spatial_plan_main)
    REFERENCES $SCHEMANAME$.spatial_plan_main (local_plan_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE RESTRICT
        DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE $SCHEMANAME$.ryhti_log
    ADD ryhti_plan_id text;

ALTER TABLE $SCHEMANAME$.ryhti_log
    ADD CONSTRAINT ensure_at_least_one_fk
        CHECK (
            num_nonnulls(
                fk_spatial_plan, 
                fk_spatial_plan_main,
                ryhti_plan_id
            ) > 0
        );
