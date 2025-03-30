ALTER TABLE $SCHEMANAME$.planned_space ALTER COLUMN bindingness_of_location DROP NOT NULL;
ALTER TABLE $SCHEMANAME$.planning_detail_line ALTER COLUMN bindingness_of_location DROP NOT NULL;
ALTER TABLE $SCHEMANAME$.planning_detail_point ALTER COLUMN bindingness_of_location DROP NOT NULL;
ALTER TABLE $SCHEMANAME$.zoning_element ALTER COLUMN bindingness_of_location DROP NOT NULL;
ALTER TABLE $SCHEMANAME$.zoning_element ALTER COLUMN bindingness_of_location DROP DEFAULT;
