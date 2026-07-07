-- PLANDATA-325: Add transferred_to_current_plan flag and change description to jsonb
-- for kaavahanke → ajantasakaava transfer functionality.

-- Add transferred_to_current_plan boolean field (default false)
ALTER TABLE $SCHEMANAME$.spatial_plan_main
    ADD COLUMN IF NOT EXISTS transferred_to_current_plan boolean DEFAULT false;

-- Change description from text to jsonb (multilingual support)
ALTER TABLE $SCHEMANAME$.spatial_plan_main
    ALTER COLUMN description TYPE jsonb USING
        CASE
            WHEN description IS NULL THEN NULL
            WHEN description = '' THEN NULL
            ELSE jsonb_build_object('fi', description)
        END;
