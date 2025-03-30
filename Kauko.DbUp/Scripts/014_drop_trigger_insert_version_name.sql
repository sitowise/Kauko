-- Drop trigger
DROP TRIGGER IF EXISTS insert_version_name_trigger ON $SCHEMANAME$.spatial_plan;
DROP FUNCTION IF EXISTS $SCHEMANAME$.insert_version_name;
