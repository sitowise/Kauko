-- KAAVA-212: Remove obsolete triggers and disable geometry relations triggers
-- Validity and geometry validation triggers are no longer needed since plan data
-- now comes from Ryhti GeoJSON. Geometry relations triggers are disabled (not dropped)
-- so they can be re-enabled for QGIS manual drawing workflows.

-- ============================================================================
-- SECTION 1: Drop obsolete validity triggers (update_validity, inherit_validity)
-- ============================================================================

-- update_validity triggers (7 tables)
DROP TRIGGER IF EXISTS update_validity ON $SCHEMANAME$.describing_line;
DROP TRIGGER IF EXISTS update_validity ON $SCHEMANAME$.describing_text;
DROP TRIGGER IF EXISTS update_validity ON $SCHEMANAME$.spatial_plan;
DROP TRIGGER IF EXISTS update_validity ON $SCHEMANAME$.planned_space;
DROP TRIGGER IF EXISTS update_validity ON $SCHEMANAME$.planning_detail_line;
DROP TRIGGER IF EXISTS update_validity ON $SCHEMANAME$.planning_detail_point;
DROP TRIGGER IF EXISTS update_validity ON $SCHEMANAME$.zoning_element;

-- inherit_validity triggers (3 tables)
DROP TRIGGER IF EXISTS inherit_validity ON $SCHEMANAME$.spatial_plan;
DROP TRIGGER IF EXISTS inherit_validity ON $SCHEMANAME$.planned_space;
DROP TRIGGER IF EXISTS inherit_validity ON $SCHEMANAME$.zoning_element;

-- ============================================================================
-- SECTION 2: Drop obsolete geometry validation triggers
-- ============================================================================

-- validate_*_geom triggers (7 tables)
DROP TRIGGER IF EXISTS validate_describing_line_geom ON $SCHEMANAME$.describing_line;
DROP TRIGGER IF EXISTS validate_describing_text_geom ON $SCHEMANAME$.describing_text;
DROP TRIGGER IF EXISTS validate_spatial_plan_geom ON $SCHEMANAME$.spatial_plan;
DROP TRIGGER IF EXISTS validate_planned_space_geom ON $SCHEMANAME$.planned_space;
DROP TRIGGER IF EXISTS validate_planning_detail_line_geom ON $SCHEMANAME$.planning_detail_line;
DROP TRIGGER IF EXISTS validate_planning_detail_point_geom ON $SCHEMANAME$.planning_detail_point;
DROP TRIGGER IF EXISTS validate_zoning_element_geom ON $SCHEMANAME$.zoning_element;

-- validate_*_topology triggers (3 tables)
DROP TRIGGER IF EXISTS validate_spatial_plan_topology ON $SCHEMANAME$.spatial_plan;
DROP TRIGGER IF EXISTS validate_planned_space_topology ON $SCHEMANAME$.planned_space;
DROP TRIGGER IF EXISTS validate_zoning_element_topology ON $SCHEMANAME$.zoning_element;

-- ============================================================================
-- SECTION 3: Disable geometry relations triggers (kept for QGIS manual drawing)
-- ============================================================================

-- delete_geom_relations triggers (7 tables)
ALTER TABLE $SCHEMANAME$.describing_line DISABLE TRIGGER delete_geom_relations;
ALTER TABLE $SCHEMANAME$.describing_text DISABLE TRIGGER delete_geom_relations;
ALTER TABLE $SCHEMANAME$.spatial_plan DISABLE TRIGGER delete_geom_relations;
ALTER TABLE $SCHEMANAME$.planned_space DISABLE TRIGGER delete_geom_relations;
ALTER TABLE $SCHEMANAME$.planning_detail_line DISABLE TRIGGER delete_geom_relations;
ALTER TABLE $SCHEMANAME$.planning_detail_point DISABLE TRIGGER delete_geom_relations;
ALTER TABLE $SCHEMANAME$.zoning_element DISABLE TRIGGER delete_geom_relations;

-- geom_relations triggers (7 tables)
ALTER TABLE $SCHEMANAME$.describing_line DISABLE TRIGGER geom_relations;
ALTER TABLE $SCHEMANAME$.describing_text DISABLE TRIGGER geom_relations;
ALTER TABLE $SCHEMANAME$.spatial_plan DISABLE TRIGGER geom_relations;
ALTER TABLE $SCHEMANAME$.planned_space DISABLE TRIGGER geom_relations;
ALTER TABLE $SCHEMANAME$.planning_detail_line DISABLE TRIGGER geom_relations;
ALTER TABLE $SCHEMANAME$.planning_detail_point DISABLE TRIGGER geom_relations;
ALTER TABLE $SCHEMANAME$.zoning_element DISABLE TRIGGER geom_relations;

-- create_or_update_spatial_plan triggers (2 tables)
ALTER TABLE $SCHEMANAME$.spatial_plan_main DISABLE TRIGGER create_or_update_spatial_plan;
ALTER TABLE $SCHEMANAME$.spatial_plan DISABLE TRIGGER create_or_update_spatial_plan;
