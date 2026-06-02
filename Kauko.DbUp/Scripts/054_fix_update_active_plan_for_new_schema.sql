-- RYHTIEXPORT-326: Päivitä update_active_plan vastaamaan 052-migraation jälkeistä rakennetta
--
-- Ongelma:
--   Migraatio 047 loi update_active_plan-funktion, joka viittaa spatial_plan.local_plan_id-sarakkeeseen.
--   Migraatio 052 poisti tämän sarakkeen ja siirsi kaava-asian tunnisteen spatial_plan_phase-taulun
--   kautta spatial_plan_main-tauluun (local_plan_main_id).
--
-- Ratkaisu:
--   "Saman kaavan kaikki vaiheet" löydetään nyt ketjun kautta:
--     spatial_plan.fk_spatial_plan_phase → spatial_plan_phase.local_phase_key
--     spatial_plan_phase.local_plan_main_id → spatial_plan_main.local_plan_main_id
--
-- Toiminta pysyy samana:
--   1. Haetaan annetun spatial_plan-rivin kautta sen kaava-asia (spatial_plan_main)
--   2. Deaktivoidaan kaikki saman kaava-asian spatial_plan-rivit ja niiden alaiset elementit
--   3. Aktivoidaan valittu vaihe ja sen alaiset elementit

DROP FUNCTION IF EXISTS $SCHEMANAME$.update_active_plan;

CREATE OR REPLACE FUNCTION $SCHEMANAME$.update_active_plan(p_new_active_plan_local_id text)
RETURNS void
LANGUAGE plpgsql
AS $function$
DECLARE
  v_local_plan_main_id text;
BEGIN
  -- Validate & fetch the plan main id (kaava-asian tunnus) via phase table
  SELECT spp.local_plan_main_id
  INTO v_local_plan_main_id
  FROM $SCHEMANAME$.spatial_plan sp
  JOIN $SCHEMANAME$.spatial_plan_phase spp ON spp.local_phase_key = sp.fk_spatial_plan_phase
  WHERE sp.local_id = p_new_active_plan_local_id;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'New active plan does not exist';
  END IF;

  -- Lock all spatial_plan rows belonging to the same plan main
  PERFORM 1
  FROM $SCHEMANAME$.spatial_plan sp
  JOIN $SCHEMANAME$.spatial_plan_phase spp ON spp.local_phase_key = sp.fk_spatial_plan_phase
  WHERE spp.local_plan_main_id = v_local_plan_main_id
  FOR UPDATE OF sp;

  -- Build temp id sets for "all phases in the plan"
  CREATE TEMP TABLE tmp_plan_phases(local_id text) ON COMMIT DROP;
  INSERT INTO tmp_plan_phases(local_id)
  SELECT sp.local_id
  FROM $SCHEMANAME$.spatial_plan sp
  JOIN $SCHEMANAME$.spatial_plan_phase spp ON spp.local_phase_key = sp.fk_spatial_plan_phase
  WHERE spp.local_plan_main_id = v_local_plan_main_id;

  CREATE TEMP TABLE tmp_ze_all(local_id text) ON COMMIT DROP;
  INSERT INTO tmp_ze_all(local_id)
  SELECT ze.local_id
  FROM $SCHEMANAME$.zoning_element ze
  JOIN tmp_plan_phases pp ON pp.local_id = ze.spatial_plan;

  CREATE TEMP TABLE tmp_ps_ids(id text) ON COMMIT DROP;
  INSERT INTO tmp_ps_ids(id)
  SELECT DISTINCT zeps.planned_space_local_id
  FROM $SCHEMANAME$.zoning_element_planned_space zeps
  JOIN tmp_ze_all ze ON ze.local_id = zeps.zoning_element_local_id;

  CREATE TEMP TABLE tmp_pdl_ids(id text) ON COMMIT DROP;
  INSERT INTO tmp_pdl_ids(id)
  SELECT DISTINCT zepdl.planning_detail_line_local_id
  FROM $SCHEMANAME$.zoning_element_plan_detail_line zepdl
  JOIN tmp_ze_all ze ON ze.local_id = zepdl.zoning_element_local_id;

  CREATE TEMP TABLE tmp_pdp_ids(id text) ON COMMIT DROP;
  INSERT INTO tmp_pdp_ids(id)
  SELECT DISTINCT zepdp.planning_detail_point_local_id
  FROM $SCHEMANAME$.zoning_element_plan_detail_point zepdp
  JOIN tmp_ze_all ze ON ze.local_id = zepdp.zoning_element_local_id;

  CREATE TEMP TABLE tmp_dl_ids(id int4) ON COMMIT DROP;
  INSERT INTO tmp_dl_ids(id)
  SELECT DISTINCT zedl.describing_line_id
  FROM $SCHEMANAME$.zoning_element_describing_line zedl
  JOIN tmp_ze_all ze ON ze.local_id = zedl.zoning_element_local_id;

  CREATE TEMP TABLE tmp_dt_ids(id int4) ON COMMIT DROP;
  INSERT INTO tmp_dt_ids(id)
  SELECT DISTINCT zedt.describing_text_id
  FROM $SCHEMANAME$.zoning_element_describing_text zedt
  JOIN tmp_ze_all ze ON ze.local_id = zedt.zoning_element_local_id;

  -- Deactivate all phases and their dependents
  UPDATE $SCHEMANAME$.spatial_plan sp
  SET is_active = false
  FROM tmp_plan_phases pp
  WHERE sp.local_id = pp.local_id
    AND sp.is_active IS true;

  UPDATE $SCHEMANAME$.zoning_element ze
  SET is_active = false
  WHERE ze.local_id IN (SELECT local_id FROM tmp_ze_all)
    AND ze.is_active IS true;

  UPDATE $SCHEMANAME$.planned_space ps
  SET is_active = false
  WHERE ps.local_id IN (SELECT id FROM tmp_ps_ids)
    AND ps.is_active IS true;

  UPDATE $SCHEMANAME$.planning_detail_line pdl
  SET is_active = false
  WHERE pdl.local_id IN (SELECT id FROM tmp_pdl_ids)
    AND pdl.is_active IS true;

  UPDATE $SCHEMANAME$.planning_detail_point pdp
  SET is_active = false
  WHERE pdp.local_id IN (SELECT id FROM tmp_pdp_ids)
    AND pdp.is_active IS true;

  UPDATE $SCHEMANAME$.describing_line dl
  SET is_active = false
  WHERE dl.id IN (SELECT id FROM tmp_dl_ids)
    AND dl.is_active IS true;

  UPDATE $SCHEMANAME$.describing_text dt
  SET is_active = false
  WHERE dt.id IN (SELECT id FROM tmp_dt_ids)
    AND dt.is_active IS true;

  -- Now build temp sets for "selected phase" only
  CREATE TEMP TABLE tmp_ze_new(local_id text) ON COMMIT DROP;
  INSERT INTO tmp_ze_new(local_id)
  SELECT ze.local_id
  FROM $SCHEMANAME$.zoning_element ze
  WHERE ze.spatial_plan = p_new_active_plan_local_id;

  CREATE TEMP TABLE tmp_ps_new(id text) ON COMMIT DROP;
  INSERT INTO tmp_ps_new(id)
  SELECT DISTINCT zeps.planned_space_local_id
  FROM $SCHEMANAME$.zoning_element_planned_space zeps
  JOIN tmp_ze_new ze ON ze.local_id = zeps.zoning_element_local_id;

  CREATE TEMP TABLE tmp_pdl_new(id text) ON COMMIT DROP;
  INSERT INTO tmp_pdl_new(id)
  SELECT DISTINCT zepdl.planning_detail_line_local_id
  FROM $SCHEMANAME$.zoning_element_plan_detail_line zepdl
  JOIN tmp_ze_new ze ON ze.local_id = zepdl.zoning_element_local_id;

  CREATE TEMP TABLE tmp_pdp_new(id text) ON COMMIT DROP;
  INSERT INTO tmp_pdp_new(id)
  SELECT DISTINCT zepdp.planning_detail_point_local_id
  FROM $SCHEMANAME$.zoning_element_plan_detail_point zepdp
  JOIN tmp_ze_new ze ON ze.local_id = zepdp.zoning_element_local_id;

  CREATE TEMP TABLE tmp_dl_new(id integer) ON COMMIT DROP;
  INSERT INTO tmp_dl_new(id)
  SELECT DISTINCT zedl.describing_line_id
  FROM $SCHEMANAME$.zoning_element_describing_line zedl
  JOIN tmp_ze_new ze ON ze.local_id = zedl.zoning_element_local_id;

  CREATE TEMP TABLE tmp_dt_new(id integer) ON COMMIT DROP;
  INSERT INTO tmp_dt_new(id)
  SELECT DISTINCT zedt.describing_text_id
  FROM $SCHEMANAME$.zoning_element_describing_text zedt
  JOIN tmp_ze_new ze ON ze.local_id = zedt.zoning_element_local_id;

  -- Activate selected phase and dependents
  UPDATE $SCHEMANAME$.spatial_plan sp
  SET is_active = true
  WHERE sp.local_id = p_new_active_plan_local_id
    AND sp.is_active IS DISTINCT FROM true;

  UPDATE $SCHEMANAME$.zoning_element ze
  SET is_active = true
  WHERE ze.local_id IN (SELECT local_id FROM tmp_ze_new)
    AND ze.is_active IS DISTINCT FROM true;

  UPDATE $SCHEMANAME$.planned_space ps
  SET is_active = true
  WHERE ps.local_id IN (SELECT id FROM tmp_ps_new)
    AND ps.is_active IS DISTINCT FROM true;

  UPDATE $SCHEMANAME$.planning_detail_line pdl
  SET is_active = true
  WHERE pdl.local_id IN (SELECT id FROM tmp_pdl_new)
    AND pdl.is_active IS DISTINCT FROM true;

  UPDATE $SCHEMANAME$.planning_detail_point pdp
  SET is_active = true
  WHERE pdp.local_id IN (SELECT id FROM tmp_pdp_new)
    AND pdp.is_active IS DISTINCT FROM true;

  UPDATE $SCHEMANAME$.describing_line dl
  SET is_active = true
  WHERE dl.id IN (SELECT id FROM tmp_dl_new)
    AND dl.is_active IS DISTINCT FROM true;

  UPDATE $SCHEMANAME$.describing_text dt
  SET is_active = true
  WHERE dt.id IN (SELECT id FROM tmp_dt_new)
    AND dt.is_active IS DISTINCT FROM true;

END;
$function$;
