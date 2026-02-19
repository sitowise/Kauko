ALTER TABLE $SCHEMANAME$.spatial_plan 
ADD COLUMN local_plan_key text NOT NULL DEFAULT (uuid_generate_v4()::text);
