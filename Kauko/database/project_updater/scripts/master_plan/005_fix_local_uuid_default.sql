DROP TRIGGER IF EXISTS create_document_local_id_trigger
  ON SCHEMANAME."document";

ALTER TABLE SCHEMANAME."document"
ALTER COLUMN local_id
  SET DEFAULT uuid_generate_v4();

DROP TRIGGER IF EXISTS create_participation_and_evalution_plan_local_id_trigger
  ON SCHEMANAME.participation_and_evalution_plan;

ALTER TABLE SCHEMANAME.participation_and_evalution_plan
ALTER COLUMN local_id
  SET DEFAULT uuid_generate_v4();


DROP TRIGGER IF EXISTS create_plan_guidance_local_id_trigger
  ON SCHEMANAME.plan_guidance;

ALTER TABLE SCHEMANAME.plan_guidance
ALTER COLUMN local_id
  SET DEFAULT uuid_generate_v4();

DROP TRIGGER IF EXISTS create_plan_regulation_local_id_trigger
  ON SCHEMANAME.plan_regulation;

ALTER TABLE SCHEMANAME.plan_regulation
ALTER COLUMN local_id
  SET DEFAULT uuid_generate_v4();

DROP TRIGGER IF EXISTS create_plan_regulatrion_group_local_id_trigger
  ON SCHEMANAME.plan_regulation_group;

ALTER TABLE SCHEMANAME.plan_regulation_group
ALTER COLUMN local_id
  SET DEFAULT uuid_generate_v4();


DROP TRIGGER IF EXISTS create_planend_space_local_id_trigger
  ON SCHEMANAME.planned_space;

ALTER TABLE SCHEMANAME.planned_space
ALTER COLUMN local_id
  SET DEFAULT uuid_generate_v4();

DROP TRIGGER IF EXISTS create_planend_space_local_id_trigger
  ON SCHEMANAME.planning_detail_line;

ALTER TABLE SCHEMANAME.planning_detail_line
ALTER COLUMN local_id
  SET DEFAULT uuid_generate_v4();

DROP TRIGGER IF EXISTS create_spatial_plan_commentary_local_id_trigger
  ON SCHEMANAME.spatial_plan_commentary;

ALTER TABLE SCHEMANAME.spatial_plan_commentary
ALTER COLUMN local_id
  SET DEFAULT uuid_generate_v4();

DROP TRIGGER IF EXISTS create_spatial_plan_local_id_trigger
  ON SCHEMANAME.spatial_plan;

ALTER TABLE SCHEMANAME.spatial_plan
ALTER COLUMN local_id
  SET DEFAULT uuid_generate_v4();

DROP TRIGGER IF EXISTS create_zoning_element_local_id_trigger
  ON SCHEMANAME.zoning_element;

ALTER TABLE SCHEMANAME.zoning_element
ALTER COLUMN local_id
  SET DEFAULT uuid_generate_v4();

