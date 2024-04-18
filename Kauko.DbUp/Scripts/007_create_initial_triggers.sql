-- Trigger: code_value_refresh_area_view

-- DROP TRIGGER IF EXISTS code_value_refresh_area_view ON $SCHEMANAME$.code_value;

CREATE OR REPLACE TRIGGER code_value_refresh_area_view
    AFTER INSERT OR DELETE OR UPDATE 
    ON $SCHEMANAME$.code_value
    FOR EACH STATEMENT
    EXECUTE FUNCTION $SCHEMANAME$.refresh_plan_regulations_area_view();

-- Trigger: code_value_refresh_line_view

-- DROP TRIGGER IF EXISTS code_value_refresh_line_view ON $SCHEMANAME$.code_value;

CREATE OR REPLACE TRIGGER code_value_refresh_line_view
    AFTER INSERT OR DELETE OR UPDATE 
    ON $SCHEMANAME$.code_value
    FOR EACH STATEMENT
    EXECUTE FUNCTION $SCHEMANAME$.refresh_plan_regulations_line_view();
	

    -- Trigger: delete_geom_relations

-- DROP TRIGGER IF EXISTS delete_geom_relations ON $SCHEMANAME$.describing_line;

CREATE OR REPLACE TRIGGER delete_geom_relations
    BEFORE UPDATE OF geom
    ON $SCHEMANAME$.describing_line
    FOR EACH ROW
    WHEN (old.geom IS DISTINCT FROM new.geom)
    EXECUTE FUNCTION $SCHEMANAME$.delete_geom_relations();

-- Trigger: geom_relations

-- DROP TRIGGER IF EXISTS geom_relations ON $SCHEMANAME$.describing_line;

CREATE OR REPLACE TRIGGER geom_relations
    AFTER INSERT OR UPDATE OF geom
    ON $SCHEMANAME$.describing_line
    FOR EACH STATEMENT
    EXECUTE FUNCTION $SCHEMANAME$.geom_relations();

-- Trigger: update_validity

-- DROP TRIGGER IF EXISTS update_validity ON $SCHEMANAME$.describing_line;

CREATE OR REPLACE TRIGGER update_validity
    AFTER INSERT OR UPDATE 
    ON $SCHEMANAME$.describing_line
    FOR EACH STATEMENT
    WHEN (pg_trigger_depth() < 1)
    EXECUTE FUNCTION $SCHEMANAME$.update_validity();

-- Trigger: validate_describing_line_geom

-- DROP TRIGGER IF EXISTS validate_describing_line_geom ON $SCHEMANAME$.describing_line;

CREATE OR REPLACE TRIGGER validate_describing_line_geom
    BEFORE INSERT OR UPDATE OF geom
    ON $SCHEMANAME$.describing_line
    FOR EACH ROW
    EXECUTE FUNCTION $SCHEMANAME$.validate_geometry();
	
-- Trigger: delete_geom_relations

-- DROP TRIGGER IF EXISTS delete_geom_relations ON $SCHEMANAME$.describing_text;

CREATE OR REPLACE TRIGGER delete_geom_relations
    BEFORE UPDATE OF geom
    ON $SCHEMANAME$.describing_text
    FOR EACH ROW
    WHEN (old.geom IS DISTINCT FROM new.geom)
    EXECUTE FUNCTION $SCHEMANAME$.delete_geom_relations();

-- Trigger: geom_relations

-- DROP TRIGGER IF EXISTS geom_relations ON $SCHEMANAME$.describing_text;

CREATE OR REPLACE TRIGGER geom_relations
    AFTER INSERT OR UPDATE OF geom
    ON $SCHEMANAME$.describing_text
    FOR EACH STATEMENT
    EXECUTE FUNCTION $SCHEMANAME$.geom_relations();

-- Trigger: update_validity

-- DROP TRIGGER IF EXISTS update_validity ON $SCHEMANAME$.describing_text;

CREATE OR REPLACE TRIGGER update_validity
    AFTER INSERT OR UPDATE 
    ON $SCHEMANAME$.describing_text
    FOR EACH STATEMENT
    WHEN (pg_trigger_depth() < 1)
    EXECUTE FUNCTION $SCHEMANAME$.update_validity();
	
-- Trigger: validate_describing_text_geom

-- DROP TRIGGER IF EXISTS validate_describing_text_geom ON $SCHEMANAME$.describing_text;

CREATE OR REPLACE TRIGGER validate_describing_text_geom
    BEFORE INSERT OR UPDATE OF geom
    ON $SCHEMANAME$.describing_text
    FOR EACH ROW
    EXECUTE FUNCTION $SCHEMANAME$.validate_geometry();
	
-- Trigger: document_modified_trigger

-- DROP TRIGGER IF EXISTS document_modified_trigger ON $SCHEMANAME$.document;

CREATE OR REPLACE TRIGGER document_modified_trigger
    BEFORE INSERT OR UPDATE 
    ON $SCHEMANAME$.document
    FOR EACH ROW
    EXECUTE FUNCTION public.versioned_object_modified_trigger();

-- Trigger: upsert_creator_and_modifier_trigger

-- DROP TRIGGER IF EXISTS upsert_creator_and_modifier_trigger ON $SCHEMANAME$.document;

CREATE OR REPLACE TRIGGER upsert_creator_and_modifier_trigger
    BEFORE INSERT OR UPDATE 
    ON $SCHEMANAME$.document
    FOR EACH ROW
    EXECUTE FUNCTION $SCHEMANAME$.upsert_creator_and_modifier_trigger();
	
-- Trigger: geometry_area_value_refresh_area_view

-- DROP TRIGGER IF EXISTS geometry_area_value_refresh_area_view ON $SCHEMANAME$.geometry_area_value;

CREATE OR REPLACE TRIGGER geometry_area_value_refresh_area_view
    AFTER INSERT OR DELETE
    ON $SCHEMANAME$.geometry_area_value
    FOR EACH ROW
    EXECUTE FUNCTION $SCHEMANAME$.refresh_plan_regulations_area_view();

-- Trigger: geometry_area_value_refresh_area_view_on_update

-- DROP TRIGGER IF EXISTS geometry_area_value_refresh_area_view_on_update ON $SCHEMANAME$.geometry_area_value;

CREATE OR REPLACE TRIGGER geometry_area_value_refresh_area_view_on_update
    AFTER UPDATE 
    ON $SCHEMANAME$.geometry_area_value
    FOR EACH ROW
    WHEN (old.value IS DISTINCT FROM new.value)
    EXECUTE FUNCTION $SCHEMANAME$.refresh_plan_regulations_area_view();

-- Trigger: validate_geometry_area_value_geom

-- DROP TRIGGER IF EXISTS validate_geometry_area_value_geom ON $SCHEMANAME$.geometry_area_value;

CREATE OR REPLACE TRIGGER validate_geometry_area_value_geom
    BEFORE INSERT OR UPDATE OF value
    ON $SCHEMANAME$.geometry_area_value
    FOR EACH ROW
    EXECUTE FUNCTION $SCHEMANAME$.validate_geometry();
	
-- Trigger: geometry_line_value_refresh_line_view

-- DROP TRIGGER IF EXISTS geometry_line_value_refresh_line_view ON $SCHEMANAME$.geometry_line_value;

CREATE OR REPLACE TRIGGER geometry_line_value_refresh_line_view
    AFTER INSERT OR DELETE
    ON $SCHEMANAME$.geometry_line_value
    FOR EACH ROW
    EXECUTE FUNCTION $SCHEMANAME$.refresh_plan_regulations_line_view();

-- Trigger: geometry_line_value_refresh_line_view_on_update

-- DROP TRIGGER IF EXISTS geometry_line_value_refresh_line_view_on_update ON $SCHEMANAME$.geometry_line_value;

CREATE OR REPLACE TRIGGER geometry_line_value_refresh_line_view_on_update
    AFTER UPDATE 
    ON $SCHEMANAME$.geometry_line_value
    FOR EACH ROW
    WHEN (old.value IS DISTINCT FROM new.value)
    EXECUTE FUNCTION $SCHEMANAME$.refresh_plan_regulations_line_view();

-- Trigger: validate_geometry_line_value_geom

-- DROP TRIGGER IF EXISTS validate_geometry_line_value_geom ON $SCHEMANAME$.geometry_line_value;

CREATE OR REPLACE TRIGGER validate_geometry_line_value_geom
    BEFORE INSERT OR UPDATE OF value
    ON $SCHEMANAME$.geometry_line_value
    FOR EACH ROW
    EXECUTE FUNCTION $SCHEMANAME$.validate_geometry();


-- Trigger: geometry_point_value_refresh_point_view

-- DROP TRIGGER IF EXISTS geometry_point_value_refresh_point_view ON $SCHEMANAME$.geometry_point_value;

CREATE OR REPLACE TRIGGER geometry_point_value_refresh_point_view
    AFTER INSERT OR DELETE
    ON $SCHEMANAME$.geometry_point_value
    FOR EACH ROW
    EXECUTE FUNCTION $SCHEMANAME$.refresh_plan_regulations_point_view();

-- Trigger: geometry_point_value_refresh_point_view_on_update

-- DROP TRIGGER IF EXISTS geometry_point_value_refresh_point_view_on_update ON $SCHEMANAME$.geometry_point_value;

CREATE OR REPLACE TRIGGER geometry_point_value_refresh_point_view_on_update
    AFTER UPDATE 
    ON $SCHEMANAME$.geometry_point_value
    FOR EACH ROW
    WHEN (old.value IS DISTINCT FROM new.value)
    EXECUTE FUNCTION $SCHEMANAME$.refresh_plan_regulations_point_view();

-- Trigger: validate_geometry_point_value_geom

-- DROP TRIGGER IF EXISTS validate_geometry_point_value_geom ON $SCHEMANAME$.geometry_point_value;

CREATE OR REPLACE TRIGGER validate_geometry_point_value_geom
    BEFORE INSERT OR UPDATE OF value
    ON $SCHEMANAME$.geometry_point_value
    FOR EACH ROW
    EXECUTE FUNCTION $SCHEMANAME$.validate_geometry();

-- Trigger: numeric_double_value_refresh_area_view

-- DROP TRIGGER IF EXISTS numeric_double_value_refresh_area_view ON $SCHEMANAME$.numeric_double_value;

CREATE OR REPLACE TRIGGER numeric_double_value_refresh_area_view
    AFTER INSERT OR DELETE OR UPDATE 
    ON $SCHEMANAME$.numeric_double_value
    FOR EACH STATEMENT
    EXECUTE FUNCTION $SCHEMANAME$.refresh_plan_regulations_area_view();

-- Trigger: numeric_double_value_refresh_line_view

-- DROP TRIGGER IF EXISTS numeric_double_value_refresh_line_view ON $SCHEMANAME$.numeric_double_value;

CREATE OR REPLACE TRIGGER numeric_double_value_refresh_line_view
    AFTER INSERT OR DELETE OR UPDATE 
    ON $SCHEMANAME$.numeric_double_value
    FOR EACH STATEMENT
    EXECUTE FUNCTION $SCHEMANAME$.refresh_plan_regulations_line_view();
	
-- Trigger: numeric_range_refresh_area_view

-- DROP TRIGGER IF EXISTS numeric_range_refresh_area_view ON $SCHEMANAME$.numeric_range;

CREATE OR REPLACE TRIGGER numeric_range_refresh_area_view
    AFTER INSERT OR DELETE OR UPDATE 
    ON $SCHEMANAME$.numeric_range
    FOR EACH STATEMENT
    EXECUTE FUNCTION $SCHEMANAME$.refresh_plan_regulations_area_view();

-- Trigger: numeric_range_refresh_line_view

-- DROP TRIGGER IF EXISTS numeric_range_refresh_line_view ON $SCHEMANAME$.numeric_range;

CREATE OR REPLACE TRIGGER numeric_range_refresh_line_view
    AFTER INSERT OR DELETE OR UPDATE 
    ON $SCHEMANAME$.numeric_range
    FOR EACH STATEMENT
    EXECUTE FUNCTION $SCHEMANAME$.refresh_plan_regulations_line_view();
	
-- Trigger: participation_and_evalution_plan_modified_trigger

-- DROP TRIGGER IF EXISTS participation_and_evalution_plan_modified_trigger ON $SCHEMANAME$.participation_and_evalution_plan;

CREATE OR REPLACE TRIGGER participation_and_evalution_plan_modified_trigger
    BEFORE INSERT OR UPDATE 
    ON $SCHEMANAME$.participation_and_evalution_plan
    FOR EACH ROW
    EXECUTE FUNCTION public.versioned_object_modified_trigger();
	
-- Trigger: plan_guidance_modified_trigger

-- DROP TRIGGER IF EXISTS plan_guidance_modified_trigger ON $SCHEMANAME$.plan_guidance;

CREATE OR REPLACE TRIGGER plan_guidance_modified_trigger
    BEFORE INSERT OR UPDATE 
    ON $SCHEMANAME$.plan_guidance
    FOR EACH ROW
    EXECUTE FUNCTION public.versioned_object_modified_trigger();

-- Trigger: plan_guidance_validity_time

-- DROP TRIGGER IF EXISTS plan_guidance_validity_time ON $SCHEMANAME$.plan_guidance;

CREATE OR REPLACE TRIGGER plan_guidance_validity_time
    BEFORE INSERT OR UPDATE 
    ON $SCHEMANAME$.plan_guidance
    FOR EACH ROW
    EXECUTE FUNCTION $SCHEMANAME$.validity_to_daterange();

-- Trigger: upsert_creator_and_modifier_trigger

-- DROP TRIGGER IF EXISTS upsert_creator_and_modifier_trigger ON $SCHEMANAME$.plan_guidance;

CREATE OR REPLACE TRIGGER upsert_creator_and_modifier_trigger
    BEFORE INSERT OR UPDATE 
    ON $SCHEMANAME$.plan_guidance
    FOR EACH ROW
    EXECUTE FUNCTION $SCHEMANAME$.upsert_creator_and_modifier_trigger();

-- Trigger: plan_regulation_modified_trigger

-- DROP TRIGGER IF EXISTS plan_regulation_modified_trigger ON $SCHEMANAME$.plan_regulation;

CREATE OR REPLACE TRIGGER plan_regulation_modified_trigger
    BEFORE INSERT OR UPDATE 
    ON $SCHEMANAME$.plan_regulation
    FOR EACH ROW
    EXECUTE FUNCTION public.versioned_object_modified_trigger();

-- Trigger: plan_regulation_refresh_area_view

-- DROP TRIGGER IF EXISTS plan_regulation_refresh_area_view ON $SCHEMANAME$.plan_regulation;

CREATE OR REPLACE TRIGGER plan_regulation_refresh_area_view
    AFTER INSERT OR DELETE
    ON $SCHEMANAME$.plan_regulation
    FOR EACH ROW
    EXECUTE FUNCTION $SCHEMANAME$.refresh_plan_regulations_area_view();

-- Trigger: plan_regulation_refresh_area_view_on_update

-- DROP TRIGGER IF EXISTS plan_regulation_refresh_area_view_on_update ON $SCHEMANAME$.plan_regulation;

CREATE OR REPLACE TRIGGER plan_regulation_refresh_area_view_on_update
    AFTER UPDATE 
    ON $SCHEMANAME$.plan_regulation
    FOR EACH ROW
    WHEN (old.type::text IS DISTINCT FROM new.type::text)
    EXECUTE FUNCTION $SCHEMANAME$.refresh_plan_regulations_area_view();

-- Trigger: plan_regulation_refresh_line_view

-- DROP TRIGGER IF EXISTS plan_regulation_refresh_line_view ON $SCHEMANAME$.plan_regulation;

CREATE OR REPLACE TRIGGER plan_regulation_refresh_line_view
    AFTER INSERT OR DELETE
    ON $SCHEMANAME$.plan_regulation
    FOR EACH ROW
    EXECUTE FUNCTION $SCHEMANAME$.refresh_plan_regulations_line_view();

-- Trigger: plan_regulation_refresh_line_view_on_update

-- DROP TRIGGER IF EXISTS plan_regulation_refresh_line_view_on_update ON $SCHEMANAME$.plan_regulation;

CREATE OR REPLACE TRIGGER plan_regulation_refresh_line_view_on_update
    AFTER UPDATE 
    ON $SCHEMANAME$.plan_regulation
    FOR EACH ROW
    WHEN (old.type::text IS DISTINCT FROM new.type::text)
    EXECUTE FUNCTION $SCHEMANAME$.refresh_plan_regulations_line_view();

-- Trigger: plan_regulation_refresh_point_view

-- DROP TRIGGER IF EXISTS plan_regulation_refresh_point_view ON $SCHEMANAME$.plan_regulation;

CREATE OR REPLACE TRIGGER plan_regulation_refresh_point_view
    AFTER INSERT OR DELETE
    ON $SCHEMANAME$.plan_regulation
    FOR EACH ROW
    EXECUTE FUNCTION $SCHEMANAME$.refresh_plan_regulations_point_view();

-- Trigger: plan_regulation_refresh_point_view_on_update

-- DROP TRIGGER IF EXISTS plan_regulation_refresh_point_view_on_update ON $SCHEMANAME$.plan_regulation;

CREATE OR REPLACE TRIGGER plan_regulation_refresh_point_view_on_update
    AFTER UPDATE 
    ON $SCHEMANAME$.plan_regulation
    FOR EACH ROW
    WHEN (old.type::text IS DISTINCT FROM new.type::text)
    EXECUTE FUNCTION $SCHEMANAME$.refresh_plan_regulations_point_view();

-- Trigger: plan_regulation_validity_time

-- DROP TRIGGER IF EXISTS plan_regulation_validity_time ON $SCHEMANAME$.plan_regulation;

CREATE OR REPLACE TRIGGER plan_regulation_validity_time
    BEFORE INSERT OR UPDATE 
    ON $SCHEMANAME$.plan_regulation
    FOR EACH ROW
    EXECUTE FUNCTION $SCHEMANAME$.validity_to_daterange();

-- Trigger: upsert_creator_and_modifier_trigger

-- DROP TRIGGER IF EXISTS upsert_creator_and_modifier_trigger ON $SCHEMANAME$.plan_regulation;

CREATE OR REPLACE TRIGGER upsert_creator_and_modifier_trigger
    BEFORE INSERT OR UPDATE 
    ON $SCHEMANAME$.plan_regulation
    FOR EACH ROW
    EXECUTE FUNCTION $SCHEMANAME$.upsert_creator_and_modifier_trigger();

-- Trigger: plan_regulation_group_modified_trigger

-- DROP TRIGGER IF EXISTS plan_regulation_group_modified_trigger ON $SCHEMANAME$.plan_regulation_group;

CREATE OR REPLACE TRIGGER plan_regulation_group_modified_trigger
    BEFORE INSERT OR UPDATE 
    ON $SCHEMANAME$.plan_regulation_group
    FOR EACH ROW
    EXECUTE FUNCTION public.versioned_object_modified_trigger();

-- Trigger: delete_geom_relations

-- DROP TRIGGER IF EXISTS delete_geom_relations ON $SCHEMANAME$.planned_space;

CREATE OR REPLACE TRIGGER delete_geom_relations
    BEFORE UPDATE OF geom
    ON $SCHEMANAME$.planned_space
    FOR EACH ROW
    WHEN (old.geom IS DISTINCT FROM new.geom)
    EXECUTE FUNCTION $SCHEMANAME$.delete_geom_relations();

-- Trigger: geom_relations

-- DROP TRIGGER IF EXISTS geom_relations ON $SCHEMANAME$.planned_space;

CREATE OR REPLACE TRIGGER geom_relations
    AFTER INSERT OR UPDATE OF geom
    ON $SCHEMANAME$.planned_space
    FOR EACH STATEMENT
    EXECUTE FUNCTION $SCHEMANAME$.geom_relations();

-- Trigger: inherit_validity

-- DROP TRIGGER IF EXISTS inherit_validity ON $SCHEMANAME$.planned_space;

CREATE OR REPLACE TRIGGER inherit_validity
    AFTER INSERT
    ON $SCHEMANAME$.planned_space
    FOR EACH STATEMENT
    EXECUTE FUNCTION $SCHEMANAME$.inherit_validity();

-- Trigger: planned_space_modified_trigger

-- DROP TRIGGER IF EXISTS planned_space_modified_trigger ON $SCHEMANAME$.planned_space;

CREATE OR REPLACE TRIGGER planned_space_modified_trigger
    BEFORE INSERT OR UPDATE 
    ON $SCHEMANAME$.planned_space
    FOR EACH ROW
    EXECUTE FUNCTION public.versioned_object_modified_trigger();

-- Trigger: planned_space_refresh_area_view

-- DROP TRIGGER IF EXISTS planned_space_refresh_area_view ON $SCHEMANAME$.planned_space;

CREATE OR REPLACE TRIGGER planned_space_refresh_area_view
    AFTER INSERT OR DELETE
    ON $SCHEMANAME$.planned_space
    FOR EACH ROW
    EXECUTE FUNCTION $SCHEMANAME$.refresh_plan_regulations_area_view();

-- Trigger: planned_space_refresh_area_view_on_update

-- DROP TRIGGER IF EXISTS planned_space_refresh_area_view_on_update ON $SCHEMANAME$.planned_space;

CREATE OR REPLACE TRIGGER planned_space_refresh_area_view_on_update
    AFTER UPDATE 
    ON $SCHEMANAME$.planned_space
    FOR EACH ROW
    WHEN (old.geom IS DISTINCT FROM new.geom)
    EXECUTE FUNCTION $SCHEMANAME$.refresh_plan_regulations_area_view();

-- Trigger: planned_space_validity_time

-- DROP TRIGGER IF EXISTS planned_space_validity_time ON $SCHEMANAME$.planned_space;

CREATE OR REPLACE TRIGGER planned_space_validity_time
    BEFORE INSERT OR UPDATE 
    ON $SCHEMANAME$.planned_space
    FOR EACH ROW
    EXECUTE FUNCTION $SCHEMANAME$.validity_to_daterange();

-- Trigger: update_validity

-- DROP TRIGGER IF EXISTS update_validity ON $SCHEMANAME$.planned_space;

CREATE OR REPLACE TRIGGER update_validity
    AFTER INSERT OR UPDATE 
    ON $SCHEMANAME$.planned_space
    FOR EACH STATEMENT
    WHEN (pg_trigger_depth() < 1)
    EXECUTE FUNCTION $SCHEMANAME$.update_validity();

-- Trigger: upsert_creator_and_modifier_trigger

-- DROP TRIGGER IF EXISTS upsert_creator_and_modifier_trigger ON $SCHEMANAME$.planned_space;

CREATE OR REPLACE TRIGGER upsert_creator_and_modifier_trigger
    BEFORE INSERT OR UPDATE 
    ON $SCHEMANAME$.planned_space
    FOR EACH ROW
    EXECUTE FUNCTION $SCHEMANAME$.upsert_creator_and_modifier_trigger();

-- Trigger: validate_planned_space_geom

-- DROP TRIGGER IF EXISTS validate_planned_space_geom ON $SCHEMANAME$.planned_space;

CREATE OR REPLACE TRIGGER validate_planned_space_geom
    BEFORE INSERT OR UPDATE OF geom
    ON $SCHEMANAME$.planned_space
    FOR EACH ROW
    EXECUTE FUNCTION $SCHEMANAME$.validate_geometry();

-- Trigger: validate_planned_space_topology

-- DROP TRIGGER IF EXISTS validate_planned_space_topology ON $SCHEMANAME$.planned_space;

CREATE CONSTRAINT TRIGGER validate_planned_space_topology
    AFTER INSERT OR UPDATE OF geom
    ON $SCHEMANAME$.planned_space
    DEFERRABLE INITIALLY DEFERRED
    FOR EACH ROW
    EXECUTE FUNCTION $SCHEMANAME$.validate_planned_space_geom();

-- Trigger: create_planner_local_id_trigger

-- DROP TRIGGER IF EXISTS create_planner_local_id_trigger ON $SCHEMANAME$.planner;

CREATE OR REPLACE TRIGGER create_planner_local_id_trigger
    BEFORE INSERT
    ON $SCHEMANAME$.planner
    FOR EACH ROW
    EXECUTE FUNCTION public.create_local_id_trigger();

-- Trigger: planner_modified_trigger

-- DROP TRIGGER IF EXISTS planner_modified_trigger ON $SCHEMANAME$.planner;

CREATE OR REPLACE TRIGGER planner_modified_trigger
    BEFORE INSERT OR UPDATE 
    ON $SCHEMANAME$.planner
    FOR EACH ROW
    EXECUTE FUNCTION public.versioned_object_modified_trigger();

-- Trigger: delete_geom_relations

-- DROP TRIGGER IF EXISTS delete_geom_relations ON $SCHEMANAME$.planning_detail_line;

CREATE OR REPLACE TRIGGER delete_geom_relations
    BEFORE UPDATE OF geom
    ON $SCHEMANAME$.planning_detail_line
    FOR EACH ROW
    WHEN (old.geom IS DISTINCT FROM new.geom)
    EXECUTE FUNCTION $SCHEMANAME$.delete_geom_relations();

-- Trigger: geom_relations

-- DROP TRIGGER IF EXISTS geom_relations ON $SCHEMANAME$.planning_detail_line;

CREATE OR REPLACE TRIGGER geom_relations
    AFTER INSERT OR UPDATE OF geom
    ON $SCHEMANAME$.planning_detail_line
    FOR EACH STATEMENT
    EXECUTE FUNCTION $SCHEMANAME$.geom_relations();

-- Trigger: planning_detail_line_modified_trigger

-- DROP TRIGGER IF EXISTS planning_detail_line_modified_trigger ON $SCHEMANAME$.planning_detail_line;

CREATE OR REPLACE TRIGGER planning_detail_line_modified_trigger
    BEFORE INSERT OR UPDATE 
    ON $SCHEMANAME$.planning_detail_line
    FOR EACH ROW
    EXECUTE FUNCTION public.versioned_object_modified_trigger();

-- Trigger: planning_detail_line_refresh_line_view

-- DROP TRIGGER IF EXISTS planning_detail_line_refresh_line_view ON $SCHEMANAME$.planning_detail_line;

CREATE OR REPLACE TRIGGER planning_detail_line_refresh_line_view
    AFTER INSERT OR DELETE
    ON $SCHEMANAME$.planning_detail_line
    FOR EACH ROW
    EXECUTE FUNCTION $SCHEMANAME$.refresh_plan_regulations_line_view();

-- Trigger: planning_detail_line_refresh_line_view_on_update

-- DROP TRIGGER IF EXISTS planning_detail_line_refresh_line_view_on_update ON $SCHEMANAME$.planning_detail_line;

CREATE OR REPLACE TRIGGER planning_detail_line_refresh_line_view_on_update
    AFTER UPDATE 
    ON $SCHEMANAME$.planning_detail_line
    FOR EACH ROW
    WHEN (old.geom IS DISTINCT FROM new.geom)
    EXECUTE FUNCTION $SCHEMANAME$.refresh_plan_regulations_line_view();

-- Trigger: update_validity

-- DROP TRIGGER IF EXISTS update_validity ON $SCHEMANAME$.planning_detail_line;

CREATE OR REPLACE TRIGGER update_validity
    AFTER INSERT OR UPDATE 
    ON $SCHEMANAME$.planning_detail_line
    FOR EACH STATEMENT
    WHEN (pg_trigger_depth() < 1)
    EXECUTE FUNCTION $SCHEMANAME$.update_validity();

-- Trigger: upsert_creator_and_modifier_trigger

-- DROP TRIGGER IF EXISTS upsert_creator_and_modifier_trigger ON $SCHEMANAME$.planning_detail_line;

CREATE OR REPLACE TRIGGER upsert_creator_and_modifier_trigger
    BEFORE INSERT OR UPDATE 
    ON $SCHEMANAME$.planning_detail_line
    FOR EACH ROW
    EXECUTE FUNCTION $SCHEMANAME$.upsert_creator_and_modifier_trigger();

-- Trigger: validate_planning_detail_line_geom

-- DROP TRIGGER IF EXISTS validate_planning_detail_line_geom ON $SCHEMANAME$.planning_detail_line;

CREATE OR REPLACE TRIGGER validate_planning_detail_line_geom
    BEFORE INSERT OR UPDATE OF geom
    ON $SCHEMANAME$.planning_detail_line
    FOR EACH ROW
    EXECUTE FUNCTION $SCHEMANAME$.validate_geometry();

-- Trigger: create_or_update_spatial_plan

-- DROP TRIGGER IF EXISTS create_or_update_spatial_plan ON $SCHEMANAME$.spatial_plan;

CREATE OR REPLACE TRIGGER create_or_update_spatial_plan
    BEFORE INSERT OR UPDATE 
    ON $SCHEMANAME$.spatial_plan
    FOR EACH ROW
    WHEN (pg_trigger_depth() < 1)
    EXECUTE FUNCTION $SCHEMANAME$.create_or_update_spatial_plan();

-- Trigger: delete_geom_relations

-- DROP TRIGGER IF EXISTS delete_geom_relations ON $SCHEMANAME$.spatial_plan;

CREATE OR REPLACE TRIGGER delete_geom_relations
    BEFORE UPDATE OF geom
    ON $SCHEMANAME$.spatial_plan
    FOR EACH ROW
    WHEN (old.geom IS DISTINCT FROM new.geom)
    EXECUTE FUNCTION $SCHEMANAME$.delete_geom_relations();

-- Trigger: geom_relations

-- DROP TRIGGER IF EXISTS geom_relations ON $SCHEMANAME$.spatial_plan;

CREATE OR REPLACE TRIGGER geom_relations
    AFTER INSERT OR UPDATE OF geom
    ON $SCHEMANAME$.spatial_plan
    FOR EACH STATEMENT
    EXECUTE FUNCTION $SCHEMANAME$.geom_relations();

-- Trigger: inherit_validity

-- DROP TRIGGER IF EXISTS inherit_validity ON $SCHEMANAME$.spatial_plan;

CREATE OR REPLACE TRIGGER inherit_validity
    AFTER INSERT OR UPDATE OF valid_from, valid_to
    ON $SCHEMANAME$.spatial_plan
    FOR EACH STATEMENT
    WHEN (pg_trigger_depth() < 1)
    EXECUTE FUNCTION $SCHEMANAME$.inherit_validity();

-- Trigger: insert_version_name_trigger

-- DROP TRIGGER IF EXISTS insert_version_name_trigger ON $SCHEMANAME$.spatial_plan;

CREATE OR REPLACE TRIGGER insert_version_name_trigger
    BEFORE INSERT
    ON $SCHEMANAME$.spatial_plan
    FOR EACH ROW
    WHEN (new.version_name IS NULL)
    EXECUTE FUNCTION $SCHEMANAME$.insert_version_name();

-- Trigger: spatial_plan_modified_trigger

-- DROP TRIGGER IF EXISTS spatial_plan_modified_trigger ON $SCHEMANAME$.spatial_plan;

CREATE OR REPLACE TRIGGER spatial_plan_modified_trigger
    BEFORE INSERT OR UPDATE 
    ON $SCHEMANAME$.spatial_plan
    FOR EACH ROW
    EXECUTE FUNCTION public.versioned_object_modified_trigger();

-- Trigger: spatial_plan_refresh_area_view

-- DROP TRIGGER IF EXISTS spatial_plan_refresh_area_view ON $SCHEMANAME$.spatial_plan;

CREATE OR REPLACE TRIGGER spatial_plan_refresh_area_view
    AFTER INSERT OR DELETE
    ON $SCHEMANAME$.spatial_plan
    FOR EACH ROW
    EXECUTE FUNCTION $SCHEMANAME$.refresh_plan_regulations_area_view();

-- Trigger: spatial_plan_refresh_area_view_on_update

-- DROP TRIGGER IF EXISTS spatial_plan_refresh_area_view_on_update ON $SCHEMANAME$.spatial_plan;

CREATE OR REPLACE TRIGGER spatial_plan_refresh_area_view_on_update
    AFTER UPDATE 
    ON $SCHEMANAME$.spatial_plan
    FOR EACH ROW
    WHEN (old.geom IS DISTINCT FROM new.geom)
    EXECUTE FUNCTION $SCHEMANAME$.refresh_plan_regulations_area_view();

-- Trigger: spatial_plan_validity_time

-- DROP TRIGGER IF EXISTS spatial_plan_validity_time ON $SCHEMANAME$.spatial_plan;

CREATE OR REPLACE TRIGGER spatial_plan_validity_time
    BEFORE INSERT OR UPDATE 
    ON $SCHEMANAME$.spatial_plan
    FOR EACH ROW
    EXECUTE FUNCTION $SCHEMANAME$.validity_to_daterange();

-- Trigger: update_validity

-- DROP TRIGGER IF EXISTS update_validity ON $SCHEMANAME$.spatial_plan;

CREATE OR REPLACE TRIGGER update_validity
    AFTER INSERT OR UPDATE 
    ON $SCHEMANAME$.spatial_plan
    FOR EACH STATEMENT
    WHEN (pg_trigger_depth() < 1)
    EXECUTE FUNCTION $SCHEMANAME$.update_validity();

-- Trigger: upsert_creator_and_modifier_trigger

-- DROP TRIGGER IF EXISTS upsert_creator_and_modifier_trigger ON $SCHEMANAME$.spatial_plan;

CREATE OR REPLACE TRIGGER upsert_creator_and_modifier_trigger
    BEFORE INSERT OR UPDATE 
    ON $SCHEMANAME$.spatial_plan
    FOR EACH ROW
    EXECUTE FUNCTION $SCHEMANAME$.upsert_creator_and_modifier_trigger();

-- Trigger: validate_spatial_plan_geom

-- DROP TRIGGER IF EXISTS validate_spatial_plan_geom ON $SCHEMANAME$.spatial_plan;

CREATE OR REPLACE TRIGGER validate_spatial_plan_geom
    BEFORE INSERT OR UPDATE OF geom
    ON $SCHEMANAME$.spatial_plan
    FOR EACH ROW
    EXECUTE FUNCTION $SCHEMANAME$.validate_geometry();

-- Trigger: validate_spatial_plan_topology

-- DROP TRIGGER IF EXISTS validate_spatial_plan_topology ON $SCHEMANAME$.spatial_plan;

CREATE CONSTRAINT TRIGGER validate_spatial_plan_topology
    AFTER INSERT OR UPDATE OF geom
    ON $SCHEMANAME$.spatial_plan
    DEFERRABLE INITIALLY DEFERRED
    FOR EACH ROW
    EXECUTE FUNCTION $SCHEMANAME$.validate_spatial_plan_topology();

-- Trigger: spatial_plan_commentary_modified_trigger

-- DROP TRIGGER IF EXISTS spatial_plan_commentary_modified_trigger ON $SCHEMANAME$.spatial_plan_commentary;

CREATE OR REPLACE TRIGGER spatial_plan_commentary_modified_trigger
    BEFORE INSERT OR UPDATE 
    ON $SCHEMANAME$.spatial_plan_commentary
    FOR EACH ROW
    EXECUTE FUNCTION public.versioned_object_modified_trigger();

-- Trigger: create_or_update_spatial_plan

-- DROP TRIGGER IF EXISTS create_or_update_spatial_plan ON $SCHEMANAME$.spatial_plan_metadata;

CREATE OR REPLACE TRIGGER create_or_update_spatial_plan
    BEFORE UPDATE 
    ON $SCHEMANAME$.spatial_plan_metadata
    FOR EACH ROW
    WHEN (pg_trigger_depth() < 1)
    EXECUTE FUNCTION $SCHEMANAME$.create_or_update_spatial_plan();

-- Trigger: supplementary_information_refresh_area_view

-- DROP TRIGGER IF EXISTS supplementary_information_refresh_area_view ON $SCHEMANAME$.supplementary_information;

CREATE OR REPLACE TRIGGER supplementary_information_refresh_area_view
    AFTER INSERT OR DELETE OR UPDATE 
    ON $SCHEMANAME$.supplementary_information
    FOR EACH STATEMENT
    EXECUTE FUNCTION $SCHEMANAME$.refresh_plan_regulations_area_view();

-- Trigger: supplementary_information_refresh_line_view

-- DROP TRIGGER IF EXISTS supplementary_information_refresh_line_view ON $SCHEMANAME$.supplementary_information;

CREATE OR REPLACE TRIGGER supplementary_information_refresh_line_view
    AFTER INSERT OR DELETE OR UPDATE 
    ON $SCHEMANAME$.supplementary_information
    FOR EACH STATEMENT
    EXECUTE FUNCTION $SCHEMANAME$.refresh_plan_regulations_line_view();

-- Trigger: text_value_refresh_area_view

-- DROP TRIGGER IF EXISTS text_value_refresh_area_view ON $SCHEMANAME$.text_value;

CREATE OR REPLACE TRIGGER text_value_refresh_area_view
    AFTER INSERT OR DELETE OR UPDATE 
    ON $SCHEMANAME$.text_value
    FOR EACH STATEMENT
    EXECUTE FUNCTION $SCHEMANAME$.refresh_plan_regulations_area_view();

-- Trigger: text_value_refresh_line_view

-- DROP TRIGGER IF EXISTS text_value_refresh_line_view ON $SCHEMANAME$.text_value;

CREATE OR REPLACE TRIGGER text_value_refresh_line_view
    AFTER INSERT OR DELETE OR UPDATE 
    ON $SCHEMANAME$.text_value
    FOR EACH STATEMENT
    EXECUTE FUNCTION $SCHEMANAME$.refresh_plan_regulations_line_view();

-- Trigger: time_period_value_value

-- DROP TRIGGER IF EXISTS time_period_value_value ON $SCHEMANAME$.time_period_value;

CREATE OR REPLACE TRIGGER time_period_value_value
    BEFORE INSERT OR UPDATE 
    ON $SCHEMANAME$.time_period_value
    FOR EACH ROW
    EXECUTE FUNCTION $SCHEMANAME$.convert_to_timerange();

-- Trigger: delete_geom_relations

-- DROP TRIGGER IF EXISTS delete_geom_relations ON $SCHEMANAME$.zoning_element;

CREATE OR REPLACE TRIGGER delete_geom_relations
    BEFORE UPDATE OF geom
    ON $SCHEMANAME$.zoning_element
    FOR EACH ROW
    WHEN (old.geom IS DISTINCT FROM new.geom)
    EXECUTE FUNCTION $SCHEMANAME$.delete_geom_relations();

-- Trigger: geom_relations

-- DROP TRIGGER IF EXISTS geom_relations ON $SCHEMANAME$.zoning_element;

CREATE OR REPLACE TRIGGER geom_relations
    AFTER INSERT OR UPDATE OF geom
    ON $SCHEMANAME$.zoning_element
    FOR EACH STATEMENT
    EXECUTE FUNCTION $SCHEMANAME$.geom_relations();

-- Trigger: inherit_validity

-- DROP TRIGGER IF EXISTS inherit_validity ON $SCHEMANAME$.zoning_element;

CREATE OR REPLACE TRIGGER inherit_validity
    AFTER INSERT
    ON $SCHEMANAME$.zoning_element
    FOR EACH STATEMENT
    EXECUTE FUNCTION $SCHEMANAME$.inherit_validity();

-- Trigger: update_validity

-- DROP TRIGGER IF EXISTS update_validity ON $SCHEMANAME$.zoning_element;

CREATE OR REPLACE TRIGGER update_validity
    AFTER INSERT OR UPDATE 
    ON $SCHEMANAME$.zoning_element
    FOR EACH STATEMENT
    WHEN (pg_trigger_depth() < 1)
    EXECUTE FUNCTION $SCHEMANAME$.update_validity();

-- Trigger: upsert_creator_and_modifier_trigger

-- DROP TRIGGER IF EXISTS upsert_creator_and_modifier_trigger ON $SCHEMANAME$.zoning_element;

CREATE OR REPLACE TRIGGER upsert_creator_and_modifier_trigger
    BEFORE INSERT OR UPDATE 
    ON $SCHEMANAME$.zoning_element
    FOR EACH ROW
    EXECUTE FUNCTION $SCHEMANAME$.upsert_creator_and_modifier_trigger();

-- Trigger: validate_zoning_element_geom

-- DROP TRIGGER IF EXISTS validate_zoning_element_geom ON $SCHEMANAME$.zoning_element;

CREATE OR REPLACE TRIGGER validate_zoning_element_geom
    BEFORE INSERT OR UPDATE OF geom
    ON $SCHEMANAME$.zoning_element
    FOR EACH ROW
    EXECUTE FUNCTION $SCHEMANAME$.validate_geometry();

-- Trigger: validate_zoning_element_topology

-- DROP TRIGGER IF EXISTS validate_zoning_element_topology ON $SCHEMANAME$.zoning_element;

CREATE CONSTRAINT TRIGGER validate_zoning_element_topology
    AFTER INSERT OR UPDATE OF geom
    ON $SCHEMANAME$.zoning_element
    DEFERRABLE INITIALLY DEFERRED
    FOR EACH ROW
    EXECUTE FUNCTION $SCHEMANAME$.validate_zoning_element_topology();

-- Trigger: zoning_element_modified_trigger

-- DROP TRIGGER IF EXISTS zoning_element_modified_trigger ON $SCHEMANAME$.zoning_element;

CREATE OR REPLACE TRIGGER zoning_element_modified_trigger
    BEFORE INSERT OR UPDATE 
    ON $SCHEMANAME$.zoning_element
    FOR EACH ROW
    EXECUTE FUNCTION public.versioned_object_modified_trigger();

-- Trigger: zoning_element_refresh_area_view

-- DROP TRIGGER IF EXISTS zoning_element_refresh_area_view ON $SCHEMANAME$.zoning_element;

CREATE OR REPLACE TRIGGER zoning_element_refresh_area_view
    AFTER INSERT OR DELETE
    ON $SCHEMANAME$.zoning_element
    FOR EACH ROW
    EXECUTE FUNCTION $SCHEMANAME$.refresh_plan_regulations_area_view();

-- Trigger: zoning_element_refresh_area_view_on_update

-- DROP TRIGGER IF EXISTS zoning_element_refresh_area_view_on_update ON $SCHEMANAME$.zoning_element;

CREATE OR REPLACE TRIGGER zoning_element_refresh_area_view_on_update
    AFTER UPDATE 
    ON $SCHEMANAME$.zoning_element
    FOR EACH ROW
    WHEN (old.geom IS DISTINCT FROM new.geom OR old.land_use_kind::text IS DISTINCT FROM new.land_use_kind::text)
    EXECUTE FUNCTION $SCHEMANAME$.refresh_plan_regulations_area_view();

-- Trigger: zoning_element_validity_time

-- DROP TRIGGER IF EXISTS zoning_element_validity_time ON $SCHEMANAME$.zoning_element;

CREATE OR REPLACE TRIGGER zoning_element_validity_time
    BEFORE INSERT OR UPDATE 
    ON $SCHEMANAME$.zoning_element
    FOR EACH ROW
    EXECUTE FUNCTION $SCHEMANAME$.validity_to_daterange();









