ALTER TABLE $SCHEMANAME$.spatial_plan
ALTER COLUMN ground_relative_position DROP NOT NULL;

ALTER TABLE $SCHEMANAME$.spatial_plan
ALTER COLUMN ground_relative_position DROP DEFAULT;
