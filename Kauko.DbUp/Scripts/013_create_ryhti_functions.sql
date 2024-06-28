-- Trigger: delete_geom_relations

-- DROP TRIGGER IF EXISTS delete_geom_relations ON $SCHEMANAME$.planning_detail_point;

CREATE OR REPLACE TRIGGER delete_geom_relations
    BEFORE UPDATE OF geom
    ON $SCHEMANAME$.planning_detail_point
    FOR EACH ROW
    WHEN (old.geom IS DISTINCT FROM new.geom)
    EXECUTE FUNCTION $SCHEMANAME$.delete_geom_relations();

-- Trigger: geom_relations

-- DROP TRIGGER IF EXISTS geom_relations ON $SCHEMANAME$.planning_detail_point;

CREATE OR REPLACE TRIGGER geom_relations
    AFTER INSERT OR UPDATE OF geom
    ON $SCHEMANAME$.planning_detail_point
    FOR EACH STATEMENT
    EXECUTE FUNCTION $SCHEMANAME$.geom_relations();

-- Trigger: planning_detail_point_modified_trigger

-- DROP TRIGGER IF EXISTS planning_detail_point_modified_trigger ON $SCHEMANAME$.planning_detail_point;

CREATE OR REPLACE TRIGGER planning_detail_point_modified_trigger
    BEFORE INSERT OR UPDATE 
    ON $SCHEMANAME$.planning_detail_point
    FOR EACH ROW
    EXECUTE FUNCTION public.versioned_object_modified_trigger();


-- Trigger: planning_detail_point_refresh_point_view

-- DROP TRIGGER IF EXISTS planning_detail_point_refresh_point_view ON $SCHEMANAME$.planning_detail_point;

CREATE OR REPLACE TRIGGER planning_detail_point_refresh_point_view
    AFTER INSERT OR DELETE
    ON $SCHEMANAME$.planning_detail_point
    FOR EACH ROW
    EXECUTE FUNCTION $SCHEMANAME$.refresh_plan_regulations_point_view();


-- Trigger: planning_detail_point_refresh_point_view_on_update

-- DROP TRIGGER IF EXISTS planning_detail_point_refresh_point_view_on_update ON $SCHEMANAME$.planning_detail_point;

CREATE OR REPLACE TRIGGER planning_detail_point_refresh_point_view_on_update
    AFTER UPDATE 
    ON $SCHEMANAME$.planning_detail_point
    FOR EACH ROW
    WHEN (old.geom IS DISTINCT FROM new.geom)
    EXECUTE FUNCTION $SCHEMANAME$.refresh_plan_regulations_point_view();


-- Trigger: update_validity

-- DROP TRIGGER IF EXISTS update_validity ON $SCHEMANAME$.planning_detail_point;

CREATE OR REPLACE TRIGGER update_validity
    AFTER INSERT OR UPDATE 
    ON $SCHEMANAME$.planning_detail_point
    FOR EACH STATEMENT
    WHEN (pg_trigger_depth() < 1)
    EXECUTE FUNCTION $SCHEMANAME$.update_validity();

-- Trigger: upsert_creator_and_modifier_trigger

-- DROP TRIGGER IF EXISTS upsert_creator_and_modifier_trigger ON $SCHEMANAME$.planning_detail_point;

CREATE OR REPLACE TRIGGER upsert_creator_and_modifier_trigger
    BEFORE INSERT OR UPDATE 
    ON $SCHEMANAME$.planning_detail_point
    FOR EACH ROW
    EXECUTE FUNCTION $SCHEMANAME$.upsert_creator_and_modifier_trigger();

-- Trigger: validate_planning_detail_point_geom

-- DROP TRIGGER IF EXISTS validate_planning_detail_point_geom ON $SCHEMANAME$.planning_detail_point;

CREATE OR REPLACE TRIGGER validate_planning_detail_point_geom
    BEFORE INSERT OR UPDATE OF geom
    ON $SCHEMANAME$.planning_detail_point
    FOR EACH ROW
    EXECUTE FUNCTION $SCHEMANAME$.validate_geometry();


