
CREATE TRIGGER delete_geom_relations
  BEFORE UPDATE OF geom
  ON SCHEMANAME.describing_line FOR EACH ROW
  WHEN (old.geom IS DISTINCT FROM new.geom)
  EXECUTE FUNCTION SCHEMANAME.delete_geom_relations();

CREATE TRIGGER geom_relations AFTER
INSERT OR UPDATE OF geom
  ON SCHEMANAME.describing_line
  FOR EACH STATEMENT
  EXECUTE FUNCTION SCHEMANAME.geom_relations();

CREATE TRIGGER update_validity AFTER
INSERT OR UPDATE
  ON SCHEMANAME.describing_line
  FOR EACH STATEMENT
  WHEN ((pg_trigger_depth() < 1))
  EXECUTE FUNCTION SCHEMANAME.update_validity();

CREATE TRIGGER delete_geom_relations BEFORE
UPDATE OF geom
  ON SCHEMANAME.describing_text
  FOR EACH ROW
  WHEN ((old.geom IS DISTINCT FROM new.geom))
  EXECUTE FUNCTION SCHEMANAME.delete_geom_relations();

CREATE TRIGGER geom_relations AFTER
INSERT OR UPDATE OF geom
  ON SCHEMANAME.describing_text
  FOR EACH STATEMENT
  EXECUTE FUNCTION SCHEMANAME.geom_relations();

CREATE TRIGGER update_validity AFTER
INSERT OR UPDATE
  ON SCHEMANAME.describing_text
  FOR EACH STATEMENT
  WHEN ((pg_trigger_depth() < 1))
  EXECUTE FUNCTION SCHEMANAME.update_validity();

CREATE TRIGGER document_modified_trigger BEFORE
INSERT OR UPDATE
  ON SCHEMANAME.document
  FOR EACH ROW
  EXECUTE FUNCTION versioned_object_modified_trigger();

CREATE TRIGGER create_document_local_id_trigger BEFORE
INSERT
  ON SCHEMANAME.document
  FOR EACH ROW
  EXECUTE FUNCTION create_local_id_trigger();

CREATE TRIGGER plan_regulation_group_modified_trigger BEFORE
INSERT OR UPDATE
  ON SCHEMANAME.plan_regulation_group
  FOR EACH ROW
  EXECUTE FUNCTION versioned_object_modified_trigger();

CREATE TRIGGER create_plan_regulatrion_group_local_id_trigger BEFORE
INSERT
  ON SCHEMANAME.plan_regulation_group
  FOR EACH ROW
  EXECUTE FUNCTION create_local_id_trigger();


CREATE TRIGGER delete_geom_relations BEFORE
UPDATE OF geom
  ON SCHEMANAME.planning_detail_line
  FOR EACH ROW
  WHEN ((old.geom IS DISTINCT FROM new.geom))
  EXECUTE FUNCTION SCHEMANAME.delete_geom_relations();

CREATE TRIGGER geom_relations AFTER
INSERT OR UPDATE OF geom
  ON SCHEMANAME.planning_detail_line
  FOR EACH STATEMENT
  EXECUTE FUNCTION SCHEMANAME.geom_relations();

CREATE TRIGGER update_validity AFTER
INSERT OR UPDATE
  ON SCHEMANAME.planning_detail_line
  FOR EACH STATEMENT
  WHEN ((pg_trigger_depth() < 1)
  EXECUTE FUNCTION SCHEMANAME.update_validity();


CREATE TRIGGER planning_detail_line_modified_trigger BEFORE
INSERT OR UPDATE
  ON SCHEMANAME.planning_detail_line
  FOR EACH ROW
  EXECUTE FUNCTION versioned_object_modified_trigger();

CREATE TRIGGER create_planend_space_local_id_trigger BEFORE
INSERT
  ON SCHEMANAME.planning_detail_line
  FOR EACH ROW
  EXECUTE FUNCTION create_local_id_trigger();

CREATE TRIGGER participation_and_evalution_plan_modified_trigger BEFORE
INSERT OR UPDATE
  ON SCHEMANAME.participation_and_evalution_plan
  FOR EACH ROW
  EXECUTE FUNCTION versioned_object_modified_trigger();

CREATE TRIGGER create_participation_and_evalution_plan_local_id_trigger BEFORE
INSERT
  ON SCHEMANAME.participation_and_evalution_plan
  FOR EACH ROW
  EXECUTE FUNCTION create_local_id_trigger();

CREATE TRIGGER plan_guidance_modified_trigger BEFORE
INSERT OR UPDATE
  ON SCHEMANAME.plan_guidance
  FOR EACH ROW
  EXECUTE FUNCTION versioned_object_modified_trigger();

CREATE TRIGGER create_plan_guidance_local_id_trigger BEFORE
INSERT
  ON SCHEMANAME.plan_guidance
  FOR EACH ROW
  EXECUTE FUNCTION create_local_id_trigger();


CREATE TRIGGER plan_regulation_modified_trigger BEFORE
INSERT OR UPDATE
  ON SCHEMANAME.plan_regulation
  FOR EACH ROW
  EXECUTE FUNCTION versioned_object_modified_trigger();

CREATE TRIGGER create_plan_regulation_local_id_trigger BEFORE
INSERT
  ON SCHEMANAME.plan_regulation
  FOR EACH ROW
  EXECUTE FUNCTION create_local_id_trigger();


CREATE TRIGGER delete_geom_relations BEFORE
UPDATE OF geom
  ON SCHEMANAME.planned_space
  FOR EACH ROW
  WHEN ((old.geom IS DISTINCT FROM new.geom))
  EXECUTE FUNCTION SCHEMANAME.delete_geom_relations();

CREATE TRIGGER geom_relations AFTER
INSERT OR UPDATE OF geom ON
  SCHEMANAME.planned_space
  FOR EACH STATEMENT
  EXECUTE FUNCTION SCHEMANAME.geom_relations();

CREATE TRIGGER inherit_validity AFTER
INSERT
  ON SCHEMANAME.planned_space
  FOR EACH STATEMENT
  EXECUTE FUNCTION SCHEMANAME.inherit_validity();

CREATE TRIGGER update_validity AFTER
INSERT OR UPDATE
  ON SCHEMANAME.planned_space
  FOR EACH STATEMENT
  WHEN ((pg_trigger_depth() < 1))
  EXECUTE FUNCTION SCHEMANAME.update_validity();


CREATE TRIGGER planned_space_modified_trigger BEFORE
INSERT OR UPDATE
  ON SCHEMANAME.planned_space
  FOR EACH ROW
  EXECUTE FUNCTION versioned_object_modified_trigger();

CREATE TRIGGER create_planend_space_local_id_trigger BEFORE
INSERT
  ON SCHEMANAME.planned_space
  FOR EACH ROW
  EXECUTE FUNCTION create_local_id_trigger();


CREATE TRIGGER delete_geom_relations BEFORE
UPDATE OF geom
  ON SCHEMANAME.spatial_plan
  FOR EACH ROW
  WHEN ((old.geom IS DISTINCT FROM new.geom))
  EXECUTE FUNCTION SCHEMANAME.delete_geom_relations();

CREATE TRIGGER geom_relations AFTER
INSERT OR UPDATE OF geom
  ON SCHEMANAME.spatial_plan
  FOR EACH STATEMENT
  EXECUTE FUNCTION SCHEMANAME.geom_relations();

CREATE TRIGGER inherit_validity AFTER
INSERT OR UPDATE OF
  valid_from,
  valid_to
  ON SCHEMANAME.spatial_plan
  FOR EACH STATEMENT
  WHEN ((pg_trigger_depth() < 1))
  EXECUTE FUNCTION SCHEMANAME.inherit_validity();

CREATE TRIGGER update_validity AFTER
INSERT OR UPDATE
  ON SCHEMANAME.spatial_plan
  FOR EACH STATEMENT
  WHEN ((pg_trigger_depth() < 1))
  EXECUTE FUNCTION SCHEMANAME.update_validity();

CREATE TRIGGER spatial_plan_modified_trigger BEFORE
INSERT OR UPDATE
  ON SCHEMANAME.spatial_plan
  FOR EACH ROW
  EXECUTE FUNCTION versioned_object_modified_trigger();

CREATE TRIGGER create_spatial_plan_local_id_trigger BEFORE
INSERT
  ON SCHEMANAME.spatial_plan
  FOR EACH ROW
  EXECUTE FUNCTION create_local_id_trigger();

CREATE TRIGGER spatial_plan_commentary_modified_trigger BEFORE
INSERT OR UPDATE
  ON SCHEMANAME.spatial_plan_commentary
  FOR EACH ROW
  EXECUTE FUNCTION versioned_object_modified_trigger();

CREATE TRIGGER create_spatial_plan_commentary_local_id_trigger BEFORE
INSERT
  ON SCHEMANAME.spatial_plan_commentary
  FOR EACH ROW
  EXECUTE FUNCTION create_local_id_trigger();

CREATE TRIGGER delete_geom_relations BEFORE
UPDATE OF geom
  ON SCHEMANAME.zoning_element
  FOR EACH ROW
  WHEN ((old.geom IS DISTINCT FROM new.geom))
  EXECUTE FUNCTION SCHEMANAME.delete_geom_relations();

CREATE TRIGGER geom_relations AFTER
INSERT OR UPDATE OF geom
  ON SCHEMANAME.zoning_element
  FOR EACH STATEMENT
  EXECUTE FUNCTION SCHEMANAME.geom_relations();

CREATE TRIGGER inherit_validity AFTER
INSERT
  ON SCHEMANAME.zoning_element
  FOR EACH STATEMENT
  EXECUTE FUNCTION SCHEMANAME.inherit_validity();

CREATE TRIGGER update_validity AFTER
INSERT OR UPDATE
  ON SCHEMANAME.zoning_element
  FOR EACH STATEMENT
  WHEN ((pg_trigger_depth() < 1))
  EXECUTE FUNCTION SCHEMANAME.update_validity();

CREATE TRIGGER zoning_element_modified_trigger BEFORE
INSERT OR UPDATE
  ON SCHEMANAME.zoning_element
  FOR EACH ROW
  EXECUTE FUNCTION versioned_object_modified_trigger();

CREATE TRIGGER create_zoning_element_local_id_trigger BEFORE
INSERT
  ON SCHEMANAME.zoning_element
  FOR EACH ROW
  EXECUTE FUNCTION create_local_id_trigger();
