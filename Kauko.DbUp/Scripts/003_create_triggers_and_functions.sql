-- FUNCTION: SCHEMANAME.get_document_local_ids(text)

-- DROP FUNCTION IF EXISTS SCHEMANAME.get_document_local_ids(text);

CREATE OR REPLACE FUNCTION SCHEMANAME.get_document_local_ids(
	p_spatial_plan_local_id text)
    RETURNS TABLE(local_id character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
BEGIN
  RETURN QUERY (
    SELECT DISTINCT d.local_id AS local_id
    FROM SCHEMANAME.document d
    JOIN SCHEMANAME.patricipation_evalution_plan_document pepd ON pepd.document_local_id = d.local_id
    JOIN SCHEMANAME.plan_guidance_document pgd ON pgd.document_local_id = d.local_id
    JOIN SCHEMANAME.plan_regulation_document prd ON prd.document_local_id = d.local_id
    JOIN SCHEMANAME.spatial_plan_commentary_document spcd ON spcd.document_local_id = d.local_id
    JOIN SCHEMANAME.spatial_plan_document spd ON spd.document_local_id = d.local_id
    JOIN SCHEMANAME.participation_and_evalution_plan pep ON pepd.participation_and_evalution_plan_local_id = pep.local_id
    JOIN SCHEMANAME.spatial_plan_commentary spc ON spcd.spatial_plan_commentary_local_id = spc.local_id
    WHERE
      (spd.spatial_plan_local_id = p_spatial_plan_local_id) OR
      (spc.spatial_plan = p_spatial_plan_local_id) OR
      (pep.spatial_plan = p_spatial_plan_local_id) OR
      (prd.document_local_id IN (SELECT SCHEMANAME.get_plan_regulation_local_ids(p_spatial_plan_local_id))) OR
      (pgd.document_local_id IN (SELECT SCHEMANAME.get_plan_guidance_local_ids(p_spatial_plan_local_id)))
  );
END;
$BODY$;

-- FUNCTION: SCHEMANAME.get_plan_guidance_local_ids(text)

-- DROP FUNCTION IF EXISTS SCHEMANAME.get_plan_guidance_local_ids(text);

CREATE OR REPLACE FUNCTION SCHEMANAME.get_plan_guidance_local_ids(
	p_spatial_plan_local_id text)
    RETURNS TABLE(local_id character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
BEGIN
  RETURN QUERY (
    SELECT DISTINCT sppg.plan_guidance_local_id AS local_id
    FROM SCHEMANAME.spatial_plan_plan_guidance sppg
    WHERE sppg.spatial_plan_local_id = p_spatial_plan_local_id

    UNION

    SELECT DISTINCT zepg.plan_guidance_local_id
    FROM SCHEMANAME.zoning_element ze
    JOIN SCHEMANAME.zoning_element_plan_guidance zepg ON zepg.zoning_element_local_id = ze.local_id
    WHERE ze.spatial_plan = p_spatial_plan_local_id

    UNION

    SELECT DISTINCT pspg.plan_guidance_local_id AS local_id
    FROM SCHEMANAME.zoning_element ze
    JOIN SCHEMANAME.zoning_element_planned_space zeps ON zeps.zoning_element_local_id = ze.local_id
    JOIN SCHEMANAME.planned_space ps ON zeps.planned_space_local_id = ps.local_id
    JOIN SCHEMANAME.planned_space_plan_guidance pspg ON pspg.planned_space_local_id = ps.local_id
    WHERE ze.spatial_plan = p_spatial_plan_local_id

    UNION

    SELECT DISTINCT pdlpg.plan_guidance_local_id AS local_id
    FROM SCHEMANAME.zoning_element ze
    JOIN SCHEMANAME.zoning_element_plan_detail_line zepdl ON zepdl.zoning_element_local_id = ze.local_id
    JOIN SCHEMANAME.planning_detail_line pdl ON zepdl.planning_detail_line_local_id = pdl.local_id
    JOIN SCHEMANAME.planning_detail_line_plan_guidance pdlpg ON pdlpg.planning_detail_line_local_id = pdl.local_id
    WHERE ze.spatial_plan = p_spatial_plan_local_id
  );
END;
$BODY$;

-- FUNCTION: SCHEMANAME.get_plan_regulation_local_ids(text)

-- DROP FUNCTION IF EXISTS SCHEMANAME.get_plan_regulation_local_ids(text);

CREATE OR REPLACE FUNCTION SCHEMANAME.get_plan_regulation_local_ids(
	p_spatial_plan_local_id text)
    RETURNS TABLE(local_id character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
BEGIN
  RETURN QUERY (
    SELECT DISTINCT zer.plan_regulation_local_id AS local_id
    FROM SCHEMANAME.zoning_element_plan_regulation AS zer
    JOIN SCHEMANAME.zoning_element AS ze ON ze.local_id = zer.zoning_element_local_id
    WHERE ze.spatial_plan = p_spatial_plan_local_id

    UNION

    SELECT DISTINCT psr.plan_regulation_group_local_id AS local_id
    FROM SCHEMANAME.zoning_element_planned_space AS zeps
    JOIN SCHEMANAME.planned_space_plan_regulation_group AS psr ON psr.planned_space_local_id = zeps.planned_space_local_id
    JOIN SCHEMANAME.zoning_element AS ze ON ze.local_id = zeps.zoning_element_local_id
    WHERE ze.spatial_plan = p_spatial_plan_local_id

    UNION

    SELECT DISTINCT pdlr.plan_regulation_local_id AS local_id
    FROM SCHEMANAME.zoning_element_plan_detail_line AS zedl
    JOIN SCHEMANAME.planning_detail_line_plan_regulation AS pdlr ON pdlr.planning_detail_line_local_id = zedl.planning_detail_line_local_id
    JOIN SCHEMANAME.zoning_element AS ze ON ze.local_id = zedl.zoning_element_local_id
    WHERE ze.spatial_plan = p_spatial_plan_local_id

    UNION

    SELECT DISTINCT prgr.plan_regulation_local_id AS local_id
    FROM SCHEMANAME.zoning_element ze
    JOIN SCHEMANAME.zoning_element_plan_regulation_group zeprg ON zeprg.zoning_element_local_id = ze.local_id
    JOIN SCHEMANAME.plan_regulation_group_regulation prgr ON prgr.plan_regulation_group_local_id = zeprg.plan_regulation_group_local_id
    WHERE ze.spatial_plan = p_spatial_plan_local_id

    UNION

    SELECT DISTINCT prgr.plan_regulation_local_id AS local_id
    FROM SCHEMANAME.zoning_element ze
    JOIN SCHEMANAME.zoning_element_planned_space zeps ON zeps.zoning_element_local_id = ze.local_id
    JOIN SCHEMANAME.planned_space_plan_regulation_group psprg ON zeps.planned_space_local_id = psprg.planned_space_local_id
    JOIN SCHEMANAME.plan_regulation_group_regulation prgr ON prgr.plan_regulation_group_local_id = psprg.plan_regulation_group_local_id
    WHERE ze.spatial_plan = p_spatial_plan_local_id

    UNION

    SELECT DISTINCT prgr.plan_regulation_local_id AS local_id
    FROM SCHEMANAME.zoning_element ze
    JOIN SCHEMANAME.zoning_element_plan_detail_line zepdl ON zepdl.zoning_element_local_id = ze.local_id
    JOIN SCHEMANAME.planning_detail_line_plan_regulation_group pdlprg ON zepdl.planning_detail_line_local_id = pdlprg.planning_detail_line_local_id
    JOIN SCHEMANAME.plan_regulation_group_regulation prgr ON pdlprg.plan_regulation_group_local_id = prgr.plan_regulation_group_local_id
    WHERE ze.spatial_plan = p_spatial_plan_local_id
  );
END;
$BODY$;

-- FUNCTION: SCHEMANAME.get_regulation_group_local_ids(text)

-- DROP FUNCTION IF EXISTS SCHEMANAME.get_regulation_group_local_ids(text);

CREATE OR REPLACE FUNCTION SCHEMANAME.get_regulation_group_local_ids(
	p_spatial_plan_local_id text)
    RETURNS TABLE(local_id character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
BEGIN
  RETURN QUERY (
    SELECT DISTINCT zeprg.plan_regulation_group_local_id AS local_id
    FROM SCHEMANAME.zoning_element_plan_regulation_group zeprg
        INNER JOIN SCHEMANAME.zoning_element ze ON ze.local_id = zeprg.zoning_element_local_id
    WHERE ze.spatial_plan = p_spatial_plan_local_id
    UNION
    SELECT DISTINCT psprg.plan_regulation_group_local_id AS local_id
    FROM SCHEMANAME.planned_space_plan_regulation_group psprg
        INNER JOIN SCHEMANAME.planned_space ps ON psprg.planned_space_local_id = ps.local_id
        INNER JOIN SCHEMANAME.zoning_element_planned_space zeps ON zeps.planned_space_local_id = ps.local_id
        INNER JOIN SCHEMANAME.zoning_element ze ON zeps.zoning_element_local_id = ze.local_id
    WHERE ze.spatial_plan = p_spatial_plan_local_id
    UNION
    SELECT DISTINCT pdlprg.planning_detail_line_local_id AS local_id
    FROM SCHEMANAME.planning_detail_line_plan_regulation_group pdlprg
        INNER JOIN SCHEMANAME.planning_detail_line pdl ON pdlprg.planning_detail_line_local_id = pdl.local_id
        INNER JOIN SCHEMANAME.zoning_element_plan_detail_line zepdl ON zepdl.planning_detail_line_local_id = pdl.local_id
        INNER JOIN SCHEMANAME.zoning_element ze ON zepdl.zoning_element_local_id = ze.local_id
    WHERE ze.spatial_plan = p_spatial_plan_local_id
  );
END;
$BODY$;

-- FUNCTION: SCHEMANAME.get_valid_spatial_plan_area(character varying)

-- DROP FUNCTION IF EXISTS SCHEMANAME.get_valid_spatial_plan_area(character varying);

CREATE OR REPLACE FUNCTION SCHEMANAME.get_valid_spatial_plan_area(
	spatial_local_id character varying)
    RETURNS geometry
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE STRICT PARALLEL UNSAFE
AS $BODY$
DECLARE
  spatial_plan_geometry geometry;
  _spatial_plan RECORD;
  _zoning_element_geoms geometry[];
BEGIN
  _spatial_plan := (
    SELECT local_id, geom, validity_time, lifecycle_status
    FROM SCHEMANAME.spatial_plan
    WHERE local_id = spatial_local_id
    LIMIT 1
  );
  IF _spatial_plan IS NULL THEN
    RAISE EXCEPTION 'Spatial plan with local_id % does not exist', spatial_local_id;
  END IF;
  IF _spatial_plan.lifecycle_status NOT IN ('8', '10', '11') THEN
    RAISE EXCEPTION 'Spatial plan with local_id % is not valid', spatial_local_id;
  END IF;
  IF _spatial_plan.lifecycle_status = '11' THEN
    RETURN _spatial_plan.geom;
  END IF;
  IF _spatial_plan.lifecycle_status = '8' THEN
    IF NOT EXISTS (
      SELECT 1
      FROM SCHEMANAME.zoning_element
      WHERE spatial_plan = spatial_local_id
        AND lifecycle_status IN ('10', '11')
    ) THEN
      RETURN NULL;
    END IF;
  END IF;

  -- get zoning element geometries
  SELECT
    SCHEMANAME.get_valid_zoning_element_area(ze.local_id)
  INTO
    _zoning_element_geoms
  FROM
    SCHEMANAME.zoning_element ze
  WHERE
    ze.spatial_plan = spatial_local_id
    AND ze.lifecycle_status IN ('10', '11')
    AND ze.validity_time @> CURRENT_DATE;

  -- compute the union of all zoning element geometries
  RETURN ST_Union(_zoning_element_geoms);
END;
$BODY$;

-- FUNCTION: SCHEMANAME.get_valid_zoning_element_area(character varying)

-- DROP FUNCTION IF EXISTS SCHEMANAME.get_valid_zoning_element_area(character varying);

CREATE OR REPLACE FUNCTION SCHEMANAME.get_valid_zoning_element_area(
	zoning_local_id character varying)
    RETURNS geometry
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE STRICT PARALLEL UNSAFE
AS $BODY$
DECLARE
  _local_id varchar;
  _geom geometry;
  _validity_time daterange;
  _lifecycle_status varchar;
  _spatial_plan varchar;
  zoning_element_geometry geometry;
BEGIN
  SELECT local_id, geom, validity_time, lifecycle_status, spatial_plan
  INTO _local_id, _geom, _validity_time, _lifecycle_status, _spatial_plan
  FROM SCHEMANAME.zoning_element
  WHERE local_id = zoning_local_id
  LIMIT 1;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Zoning element with local_id % does not exist', zoning_local_id;
  END IF;

  IF _lifecycle_status NOT IN ('10', '11') THEN
    RAISE EXCEPTION 'Zoning element with local_id % is not valid', zoning_local_id;
  END IF;

  IF _lifecycle_status = '11' THEN
    RETURN _geom;
  END IF;

  WITH valid_zoning_elements AS (
    SELECT geom
    FROM SCHEMANAME.zoning_element
    WHERE spatial_plan <> _spatial_plan
      AND lifecycle_status IN ('10', '11')
      AND validity_time &> _validity_time
      AND ST_Intersects(geom, _geom)
  )
  SELECT ST_Difference(_geom, ST_Union(valid_zoning_elements.geom))
  INTO zoning_element_geometry
  FROM valid_zoning_elements;

  RETURN zoning_element_geometry;
END;
$BODY$;

-- FUNCTION: SCHEMANAME.refresh_validity()

-- DROP FUNCTION IF EXISTS SCHEMANAME.refresh_validity();

CREATE OR REPLACE FUNCTION SCHEMANAME.refresh_validity(
	)
    RETURNS void
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
BEGIN
  UPDATE SCHEMANAME.spatial_plan sp
  SET lifecycle_status = '06'
  WHERE sp.lifecycle_status IN ('01', '02', '03', '04', '05')
    AND sp.approval_time >= Current_Date;

  UPDATE SCHEMANAME.spatial_plan sp
  SET lifecycle_status = '11'
  WHERE sp.lifecycle_status = '06'
    AND sp.validity_time @> Current_Date;

  UPDATE SCHEMANAME.spatial_plan sp
  SET lifecycle_status = '10'
  WHERE sp.lifecycle_status = '08'
    AND sp.validity_time @> Current_Date;

  UPDATE SCHEMANAME.spatial_plan sp
  SET lifecycle_status = '12'
  WHERE sp.lifecycle_status IN ('10', '11')
    AND NOT sp.validity_time @> Current_Date;

  UPDATE SCHEMANAME.zoning_element ze
  SET lifecycle_status = '13'
  FROM SCHEMANAME.spatial_plan sp
  WHERE sp.local_id = ze.spatial_plan
    AND sp.lifecycle_status = '13'
    AND ze.lifecycle_status IN ('06', '07', '08', '09');

  UPDATE SCHEMANAME.zoning_element ze
  SET lifecycle_status = '14'
  FROM SCHEMANAME.spatial_plan sp
  WHERE sp.local_id = ze.spatial_plan
    AND sp.lifecycle_status = '14'
    AND ze.lifecycle_status IN ('02', '03', '04', '05');

  UPDATE SCHEMANAME.zoning_element ze
  SET lifecycle_status = sp.lifecycle_status
  FROM SCHEMANAME.spatial_plan sp
  WHERE sp.local_id = ze.spatial_plan
      AND sp.lifecycle_status IN ('01', '02', '03', '04', '05', '15')
      AND ze.lifecycle_status <> sp.lifecycle_status;

  UPDATE SCHEMANAME.zoning_element ze
  SET lifecycle_status = '11'
  WHERE ze.lifecycle_status = '06'
    AND ze.validity_time @> Current_Date;

  UPDATE SCHEMANAME.zoning_element ze
  SET
    lifecycle_status = '11',
    valid_from = GREATEST(ze.valid_from, sp.valid_from),
    valid_to = LEAST(ze.valid_to, sp.valid_to)
  FROM SCHEMANAME.spatial_plan sp
  WHERE sp.local_id = ze.spatial_plan
    AND ze.lifecycle_status IN ('06', '07', '08', '09')
    AND sp.lifecycle_status = '11';

  UPDATE SCHEMANAME.zoning_element ze
  SET lifecycle_status = '12'
  WHERE ze.lifecycle_status IN ('10', '11')
    AND NOT ze.validity_time @> Current_Date;

  UPDATE SCHEMANAME.zoning_element ze
  SET lifecycle_status = '12',
      valid_to = sp.valid_to
  FROM SCHEMANAME.spatial_plan sp
  WHERE sp.local_id = ze.spatial_plan
    AND ze.lifecycle_status IN ('10', '11')
    AND sp.lifecycle_status = '12';

  UPDATE SCHEMANAME.planned_space ps
  SET lifecycle_status = '11'
  WHERE ps.lifecycle_status IN ('06', '07', '08', '09')
    AND ps.validity_time @> Current_Date;

  UPDATE SCHEMANAME.planned_space ps
  SET lifecycle_status = '13'
  FROM SCHEMANAME.zoning_element ze
  JOIN SCHEMANAME.zoning_element_planned_space ze_ps
    ON ze_ps.zoning_element_local_id = ze.local_id
    AND ze.lifecycle_status = '13'
  WHERE ps.local_id = ze_ps.planned_space_local_id
    AND ps.lifecycle_status IN ('06', '07', '08', '09');

  UPDATE SCHEMANAME.planned_space ps
  SET lifecycle_status = '14'
  FROM SCHEMANAME.zoning_element ze
  JOIN SCHEMANAME.zoning_element_planned_space ze_ps
    ON ze_ps.zoning_element_local_id = ze.local_id
    AND ze.lifecycle_status = '14'
  WHERE ps.local_id = ze_ps.planned_space_local_id
    AND ps.lifecycle_status IN ('02', '03', '04', '05');

  UPDATE SCHEMANAME.planned_space ps
  SET lifecycle_status = ze.lifecycle_status
  FROM SCHEMANAME.zoning_element ze
  JOIN SCHEMANAME.zoning_element_planned_space ze_ps
      ON ze_ps.zoning_element_local_id = ze.local_id
      AND ze.lifecycle_status IN ('01', '02', '03', '04', '05', '15')
  WHERE ps.local_id = ze_ps.planned_space_local_id
      AND ps.lifecycle_status <> ze.lifecycle_status;

  UPDATE SCHEMANAME.planned_space ps
  SET
    lifecycle_status = '11',
    valid_from = GREATEST(ps.valid_from, ze.valid_from),
    valid_to = LEAST(ps.valid_from, ze.valid_from)
  FROM SCHEMANAME.zoning_element ze
  JOIN SCHEMANAME.zoning_element_planned_space ze_ps
    ON ze_ps.zoning_element_local_id = ze.local_id
    AND ze.lifecycle_status = '11'
  WHERE ps.local_id = ze_ps.planned_space_local_id
    AND ps.lifecycle_status IN ('06', '07', '08', '09');

  UPDATE SCHEMANAME.planned_space ps
  SET lifecycle_status = '12'
  WHERE ps.lifecycle_status IN ('10', '11')
    AND ps.validity_time @> Current_Date;

  UPDATE SCHEMANAME.planned_space ps
  SET lifecycle_status = '12',
      valid_to = ze.valid_to
  FROM SCHEMANAME.zoning_element ze
  JOIN SCHEMANAME.zoning_element_planned_space ze_ps
    ON ze_ps.zoning_element_local_id = ze.local_id
    AND ze.lifecycle_status = '12'
  WHERE ps.local_id = ze_ps.planned_space_local_id
    AND ps.lifecycle_status IN ('10', '11');

  UPDATE SCHEMANAME.planning_detail_line pdl
  SET lifecycle_status = '13'
  FROM SCHEMANAME.zoning_element ze
  JOIN SCHEMANAME.zoning_element_plan_detail_line ze_pdl
    ON ze_pdl.zoning_element_local_id = ze.local_id
    AND ze.lifecycle_status = '13'
  WHERE pdl.local_id = ze_pdl.planning_detail_line_local_id
    AND pdl.lifecycle_status IN ('06', '07', '08', '09');

  UPDATE SCHEMANAME.planning_detail_line pdl
  SET lifecycle_status = '14'
  FROM SCHEMANAME.zoning_element ze
  JOIN SCHEMANAME.zoning_element_plan_detail_line ze_pdl
    ON ze_pdl.zoning_element_local_id = ze.local_id
    AND ze.lifecycle_status = '14'
  WHERE pdl.local_id = ze_pdl.planning_detail_line_local_id
    AND pdl.lifecycle_status IN ('02', '03', '04', '05');

  UPDATE SCHEMANAME.planning_detail_line pdl
  SET lifecycle_status = ze.lifecycle_status
  FROM SCHEMANAME.zoning_element ze
  JOIN SCHEMANAME.zoning_element_plan_detail_line ze_pdl
    ON ze_pdl.zoning_element_local_id = ze.local_id
    AND ze.lifecycle_status IN ('01', '02', '03', '04', '05', '15')
  WHERE pdl.local_id = ze_pdl.planning_detail_line_local_id
    AND pdl.lifecycle_status <> ze.lifecycle_status;

  UPDATE SCHEMANAME.planning_detail_line pdl
  SET lifecycle_status = '11'
  FROM SCHEMANAME.zoning_element ze
  JOIN SCHEMANAME.zoning_element_plan_detail_line ze_pdl
    ON ze_pdl.zoning_element_local_id = ze.local_id
    AND ze.lifecycle_status = '11'
  WHERE pdl.local_id = ze_pdl.planning_detail_line_local_id
    AND pdl.lifecycle_status IN ('06', '07', '08', '09');

  UPDATE SCHEMANAME.planning_detail_line pdl
  SET lifecycle_status = '12'
  FROM SCHEMANAME.zoning_element ze
  JOIN SCHEMANAME.zoning_element_plan_detail_line ze_pdl
    ON ze_pdl.zoning_element_local_id = ze.local_id
    AND ze.lifecycle_status = '12'
  WHERE pdl.local_id = ze_pdl.planning_detail_line_local_id
    AND pdl.lifecycle_status IN ('10', '11');

  UPDATE SCHEMANAME.describing_line dl
  SET lifecycle_status = '13'
  FROM SCHEMANAME.zoning_element ze
  JOIN SCHEMANAME.zoning_element_describing_line ze_dl
    ON ze_dl.zoning_element_local_id = ze.local_id
    AND ze.lifecycle_status = '13'
  WHERE dl.identifier = ze_dl.describing_line_id
    AND dl.lifecycle_status IN ('06', '07', '08', '09');

  UPDATE SCHEMANAME.describing_line dl
  SET lifecycle_status = '14'
  FROM SCHEMANAME.zoning_element ze
  JOIN SCHEMANAME.zoning_element_describing_line ze_dl
    ON ze_dl.zoning_element_local_id = ze.local_id
    AND ze.lifecycle_status = '14'
  WHERE dl.identifier = ze_dl.describing_line_id
    AND dl.lifecycle_status IN ('02', '03', '04', '05');

  UPDATE SCHEMANAME.describing_line dl
  SET lifecycle_status = ze.lifecycle_status
  FROM SCHEMANAME.zoning_element ze
  JOIN SCHEMANAME.zoning_element_describing_line ze_dl
    ON ze_dl.zoning_element_local_id = ze.local_id
    AND ze.lifecycle_status IN ('01', '02', '03', '04', '05', '15')
  WHERE dl.identifier = ze_dl.describing_line_id
    AND ze.lifecycle_status <> dl.lifecycle_status;

  UPDATE SCHEMANAME.describing_line dl
  SET lifecycle_status = '11'
  FROM SCHEMANAME.zoning_element ze
  JOIN SCHEMANAME.zoning_element_describing_line ze_dl
    ON ze_dl.zoning_element_local_id = ze.local_id
    AND ze.lifecycle_status = '11'
  WHERE dl.identifier = ze_dl.describing_line_id
    AND dl.lifecycle_status IN ('06', '07', '08', '09');

  UPDATE SCHEMANAME.describing_line dl
  SET lifecycle_status = '12'
  FROM SCHEMANAME.zoning_element ze
  JOIN SCHEMANAME.zoning_element_describing_line ze_dl
    ON ze_dl.zoning_element_local_id = ze.local_id
    AND ze.lifecycle_status = '12'
  WHERE dl.identifier = ze_dl.describing_line_id
    AND dl.lifecycle_status IN ('10', '11');

  UPDATE SCHEMANAME.describing_text dt
  SET lifecycle_status = '11'
  FROM SCHEMANAME.zoning_element ze
  JOIN SCHEMANAME.zoning_element_describing_text ze_dt
    ON ze_dt.zoning_element_local_id = ze.local_id
    AND ze.lifecycle_status = '11'
  WHERE dt.identifier = ze_dt.describing_text_id
    AND dt.lifecycle_status IN ('06', '07', '08', '09');

  UPDATE SCHEMANAME.describing_text dt
  SET lifecycle_status = '13'
  FROM SCHEMANAME.zoning_element ze
  JOIN SCHEMANAME.zoning_element_describing_text ze_dt
    ON ze_dt.zoning_element_local_id = ze.local_id
    AND ze.lifecycle_status = '13'
  WHERE dt.identifier = ze_dt.describing_text_id
    AND dt.lifecycle_status IN ('06', '07', '08', '09');

  UPDATE SCHEMANAME.describing_text dt
  SET lifecycle_status = '14'
  FROM SCHEMANAME.zoning_element ze
  JOIN SCHEMANAME.zoning_element_describing_text ze_dt
    ON ze_dt.zoning_element_local_id = ze.local_id
    AND ze.lifecycle_status = '14'
  WHERE dt.identifier = ze_dt.describing_text_id
    AND dt.lifecycle_status IN ('02', '03', '04', '05');

  UPDATE SCHEMANAME.describing_text dt
  SET lifecycle_status = ze.lifecycle_status
  FROM SCHEMANAME.zoning_element ze
  JOIN SCHEMANAME.zoning_element_describing_text ze_dt
    ON ze_dt.zoning_element_local_id = ze.local_id
    AND ze.lifecycle_status IN ('01', '02', '03', '04', '05', '15')
  WHERE dt.identifier = ze_dt.describing_text_id
    AND ze.lifecycle_status <> dt.lifecycle_status;

  UPDATE SCHEMANAME.describing_text dt
  SET lifecycle_status = '12'
  FROM SCHEMANAME.zoning_element ze
  JOIN SCHEMANAME.zoning_element_describing_text ze_dt
    ON ze_dt.zoning_element_local_id = ze.local_id
    AND ze.lifecycle_status = '12'
  WHERE dt.identifier = ze_dt.describing_text_id
    AND dt.lifecycle_status IN ('10', '11');

  WITH RECURSIVE valid_spatial_plans(local_id) AS (
      SELECT DISTINCT sp.local_id
      FROM SCHEMANAME.spatial_plan sp
        INNER JOIN SCHEMANAME.zoning_element ze
          ON ze.spatial_plan = sp.local_id
      WHERE ze.lifecycle_status = '11'
        AND sp.lifecycle_status IN ('06', '07', '08')
      EXCEPT
      SELECT sp2.local_id
      FROM SCHEMANAME.spatial_plan sp2
        INNER JOIN SCHEMANAME.zoning_element ze2
          ON ze2.spatial_plan = sp2.local_id
      WHERE ze2.lifecycle_status IN ('06', '07', '08', '10')
  )
  UPDATE SCHEMANAME.spatial_plan sp
  SET lifecycle_status = '11'
  FROM valid_spatial_plans vsp
  WHERE sp.local_id = vsp.local_id;

  UPDATE SCHEMANAME.spatial_plan
  SET lifecycle_status = '11'
  WHERE local_id IN (
    SELECT sp.local_id
    FROM SCHEMANAME.spatial_plan sp
    WHERE
    EXISTS (
        SELECT 1
        FROM SCHEMANAME.zoning_element ze
        WHERE ze.spatial_plan = sp.local_id
    )
    AND NOT EXISTS (
      SELECT 1
      FROM SCHEMANAME.zoning_element ze
      WHERE ze.spatial_plan = sp.local_id
      AND ze.lifecycle_status != '11'
    ));

  UPDATE SCHEMANAME.spatial_plan
  SET lifecycle_status = '10'
  WHERE local_id IN (
    SELECT DISTINCT sp.local_id
    FROM SCHEMANAME.spatial_plan sp
    JOIN SCHEMANAME.zoning_element ze ON ze.spatial_plan = sp.local_id
    WHERE ze.lifecycle_status = '11'
    AND EXISTS (
      SELECT 1
      FROM SCHEMANAME.zoning_element ze2
      WHERE ze2.spatial_plan = sp.local_id
      AND ze2.lifecycle_status != '11'
    )
  );

END;
$BODY$;

-- FUNCTION: SCHEMANAME.update_active_plan(character varying, character varying)

-- DROP FUNCTION IF EXISTS SCHEMANAME.update_active_plan(character varying, character varying);

CREATE OR REPLACE FUNCTION SCHEMANAME.update_active_plan(
	p_old_active_plan_local_id character varying,
	p_new_active_plan_local_id character varying)
    RETURNS void
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
    v_old_plan_regulation_local_ids varchar[];
    v_old_plan_guidance_local_ids varchar[];
    v_new_plan_regulation_local_ids varchar[];
    v_new_plan_guidance_local_ids varchar[];
BEGIN
    IF NOT EXISTS(SELECT 1 FROM SCHEMANAME.spatial_plan WHERE local_id = p_old_active_plan_local_id LIMIT 1) THEN
        RAISE EXCEPTION 'Old active plan does not exist';
    END IF;

    IF NOT EXISTS(SELECT 1 FROM SCHEMANAME.spatial_plan WHERE local_id = p_new_active_plan_local_id LIMIT 1) THEN
        RAISE EXCEPTION 'New active plan does not exist';
    END IF;

    IF NOT (SELECT is_active FROM SCHEMANAME.spatial_plan WHERE local_id = p_old_active_plan_local_id LIMIT 1) THEN
        RAISE EXCEPTION 'Old active plan is not active';
    END IF;

    -- Deactivate old active plan
    UPDATE SCHEMANAME.spatial_plan
    SET is_active = FALSE
    WHERE local_id = p_old_active_plan_local_id;

    UPDATE SCHEMANAME.zoning_element
    SET is_active = FALSE
    WHERE spatial_plan = p_old_active_plan_local_id;

    UPDATE SCHEMANAME.planned_space ps
    SET is_active = FALSE
    FROM SCHEMANAME.zoning_element_planned_space zeps
    JOIN SCHEMANAME.zoning_element ze
        ON ze.local_id = zeps.zoning_element_local_id
    WHERE ze.spatial_plan = p_old_active_plan_local_id
    AND ps.local_id = zeps.planned_space_local_id;

    UPDATE SCHEMANAME.planning_detail_line pdl
    SET is_active = FALSE
    FROM SCHEMANAME.zoning_element_plan_detail_line zepdl
    JOIN SCHEMANAME.zoning_element ze
        ON ze.local_id = zepdl.zoning_element_local_id
    WHERE ze.spatial_plan = p_old_active_plan_local_id
    AND pdl.local_id = zepdl.planning_detail_line_local_id;

    UPDATE SCHEMANAME.describing_line dl
    SET is_active = FALSE
    FROM SCHEMANAME.zoning_element_describing_line zedl
    JOIN SCHEMANAME.zoning_element ze
        ON ze.local_id = zedl.zoning_element_local_id
    WHERE ze.spatial_plan = p_old_active_plan_local_id
    AND dl.identifier = zedl.describing_line_id;

    UPDATE SCHEMANAME.describing_text dt
    SET is_active = FALSE
    FROM SCHEMANAME.zoning_element_describing_text zedt
    JOIN SCHEMANAME.zoning_element ze
        ON ze.local_id = zedt.zoning_element_local_id
    WHERE ze.spatial_plan = p_old_active_plan_local_id
    AND dt.identifier = zedt.describing_text_id;

    SELECT ARRAY(SELECT SCHEMANAME.get_plan_regulation_local_ids(p_old_active_plan_local_id))
    INTO v_old_plan_regulation_local_ids;

    SELECT ARRAY(SELECT SCHEMANAME.get_plan_guidance_local_ids(p_old_active_plan_local_id))
    INTO v_old_plan_guidance_local_ids;

    UPDATE SCHEMANAME.geometry_area_value gav
    SET is_active = FALSE
    FROM SCHEMANAME.plan_regulation_geometry_area_value prgav
    WHERE gav.geometry_area_value_uuid = prgav.fk_geometry_area_value
    AND prgav.fk_plan_regulation = ANY(v_old_plan_regulation_local_ids);

    UPDATE SCHEMANAME.geometry_area_value gav
    SET is_active = FALSE
    FROM SCHEMANAME.plan_guidance_geometry_area_value pggav
    WHERE gav.geometry_area_value_uuid = pggav.fk_geometry_area_value
    AND pggav.fk_plan_guidance = ANY(v_old_plan_guidance_local_ids);

    UPDATE SCHEMANAME.geometry_area_value gav
    SET is_active = FALSE
    FROM SCHEMANAME.plan_regulation pr
    JOIN SCHEMANAME.plan_regulation_supplementary_information prsi
        ON prsi.fk_plan_regulation = pr.local_id
    JOIN SCHEMANAME.supplementary_information_geometry_area_value sigav
        ON sigav.fk_supplementary_information = prsi.fk_supplementary_information
    WHERE gav.geometry_area_value_uuid = sigav.fk_geometry_area_value
    AND pr.local_id = ANY(v_old_plan_regulation_local_ids);

    UPDATE SCHEMANAME.geometry_line_value glv
    SET is_active = FALSE
    FROM SCHEMANAME.plan_regulation_geometry_line_value prglv
    WHERE glv.geometry_line_value_uuid = prglv.fk_geometry_line_value
    AND prglv.fk_plan_regulation = ANY(v_old_plan_regulation_local_ids);

    UPDATE SCHEMANAME.geometry_line_value glv
    SET is_active = FALSE
    FROM SCHEMANAME.plan_guidance_geometry_line_value pgglv
    WHERE glv.geometry_line_value_uuid = pgglv.fk_geometry_line_value
    AND pgglv.fk_plan_guidance = ANY(v_old_plan_guidance_local_ids);

    UPDATE SCHEMANAME.geometry_line_value glv
    SET is_active = FALSE
    FROM SCHEMANAME.plan_regulation pr
    JOIN SCHEMANAME.plan_regulation_supplementary_information prsi
        ON prsi.fk_plan_regulation = pr.local_id
    JOIN SCHEMANAME.supplementary_information_geometry_line_value siglv
        ON siglv.fk_supplementary_information = prsi.fk_supplementary_information
    WHERE glv.geometry_line_value_uuid = siglv.fk_geometry_line_value
    AND pr.local_id = ANY(v_old_plan_regulation_local_ids);

    UPDATE SCHEMANAME.geometry_point_value gpv
    SET is_active = FALSE
    FROM SCHEMANAME.plan_regulation_geometry_point_value prgpv
    WHERE gpv.geometry_point_value_uuid = prgpv.fk_geometry_point_value
    AND prgpv.fk_plan_regulation = ANY(v_old_plan_regulation_local_ids);

    UPDATE SCHEMANAME.geometry_point_value gpv
    SET is_active = FALSE
    FROM SCHEMANAME.plan_guidance_geometry_point_value pggpv
    WHERE gpv.geometry_point_value_uuid = pggpv.fk_geometry_point_value
    AND pggpv.fk_plan_guidance = ANY(v_old_plan_guidance_local_ids);

    UPDATE SCHEMANAME.geometry_point_value gpv
    SET is_active = FALSE
    FROM SCHEMANAME.plan_regulation pr
    JOIN SCHEMANAME.plan_regulation_supplementary_information prsi
        ON prsi.fk_plan_regulation = pr.local_id
    JOIN SCHEMANAME.supplementary_information_geometry_point_value sigpv
        ON sigpv.fk_supplementary_information = prsi.fk_supplementary_information
    WHERE gpv.geometry_point_value_uuid = sigpv.fk_geometry_point_value
    AND pr.local_id = ANY(v_old_plan_regulation_local_ids);

    UPDATE SCHEMANAME.elevation_position_value epv
    SET is_active = FALSE
    FROM SCHEMANAME.plan_regulation_elevation_position_value prepv
    WHERE epv.elevation_position_value_uuid = prepv.fk_elevation_position_value
    AND prepv.fk_plan_regulation = ANY(v_old_plan_regulation_local_ids);

    UPDATE SCHEMANAME.elevation_position_value epv
    SET is_active = FALSE
    FROM SCHEMANAME.plan_guidance_elevation_position_value pgepv
    WHERE epv.elevation_position_value_uuid = pgepv.fk_elevation_position_value
    AND pgepv.fk_plan_guidance = ANY(v_old_plan_guidance_local_ids);

    UPDATE SCHEMANAME.elevation_position_value epv
    SET is_active = FALSE
    FROM SCHEMANAME.plan_regulation pr
    JOIN SCHEMANAME.plan_regulation_supplementary_information prsi
        ON prsi.fk_plan_regulation = pr.local_id
    JOIN SCHEMANAME.supplementary_information_elevation_position_value siepv
        ON siepv.fk_supplementary_information = prsi.fk_supplementary_information
    WHERE epv.elevation_position_value_uuid = siepv.fk_elevation_position_value
    AND pr.local_id = ANY(v_old_plan_regulation_local_ids);

    UPDATE SCHEMANAME.elevation_range_value erv
    SET is_active = FALSE
    FROM SCHEMANAME.plan_regulation_elevation_range_value prerv
    WHERE erv.elevation_range_value_uuid = prerv.fk_elevation_range_value
    AND prerv.fk_plan_regulation = ANY(v_old_plan_regulation_local_ids);

    UPDATE SCHEMANAME.elevation_range_value erv
    SET is_active = FALSE
    FROM SCHEMANAME.plan_guidance_elevation_range_value pgerv
    WHERE erv.elevation_range_value_uuid = pgerv.fk_elevation_range_value
    AND pgerv.fk_plan_guidance = ANY(v_old_plan_guidance_local_ids);

    UPDATE SCHEMANAME.elevation_range_value erv
    SET is_active = FALSE
    FROM SCHEMANAME.plan_regulation pr
    JOIN SCHEMANAME.plan_regulation_supplementary_information prsi
        ON prsi.fk_plan_regulation = pr.local_id
    JOIN SCHEMANAME.supplementary_information_elevation_range_value sierv
        ON sierv.fk_supplementary_information = prsi.fk_supplementary_information
    WHERE erv.elevation_range_value_uuid = sierv.fk_elevation_range_value
    AND pr.local_id = ANY(v_old_plan_regulation_local_ids);

    -- Activate new plan
    UPDATE SCHEMANAME.spatial_plan
    SET is_active = TRUE
    WHERE local_id = p_new_active_plan_local_id;

    UPDATE SCHEMANAME.zoning_element
    SET is_active = TRUE
    WHERE spatial_plan = p_new_active_plan_local_id;

    UPDATE SCHEMANAME.planned_space ps
    SET is_active = TRUE
    FROM SCHEMANAME.zoning_element_planned_space zeps
    JOIN SCHEMANAME.zoning_element ze
        ON ze.local_id = zeps.zoning_element_local_id
    WHERE ze.spatial_plan = p_new_active_plan_local_id
    AND ps.local_id = zeps.planned_space_local_id;

    UPDATE SCHEMANAME.planning_detail_line pdl
    SET is_active = TRUE
    FROM SCHEMANAME.zoning_element_plan_detail_line zepdl
    JOIN SCHEMANAME.zoning_element ze
        ON ze.local_id = zepdl.zoning_element_local_id
    WHERE ze.spatial_plan = p_new_active_plan_local_id
    AND pdl.local_id = zepdl.planning_detail_line_local_id;

    UPDATE SCHEMANAME.describing_line dl
    SET is_active = TRUE
    FROM SCHEMANAME.zoning_element_describing_line zedl
    JOIN SCHEMANAME.zoning_element ze
        ON ze.local_id = zedl.zoning_element_local_id
    WHERE ze.spatial_plan = p_new_active_plan_local_id
    AND dl.identifier = zedl.describing_line_id;

    UPDATE SCHEMANAME.describing_text dt
    SET is_active = TRUE
    FROM SCHEMANAME.zoning_element_describing_text zedt
    JOIN SCHEMANAME.zoning_element ze
        ON ze.local_id = zedt.zoning_element_local_id
    WHERE ze.spatial_plan = p_new_active_plan_local_id
    AND dt.identifier = zedt.describing_text_id;

    SELECT ARRAY(SELECT SCHEMANAME.get_plan_regulation_local_ids(p_old_active_plan_local_id))
    INTO v_new_plan_regulation_local_ids;

    SELECT ARRAY(SELECT SCHEMANAME.get_plan_guidance_local_ids(p_old_active_plan_local_id))
    INTO v_new_plan_guidance_local_ids;

    UPDATE SCHEMANAME.geometry_area_value gav
    SET is_active = TRUE
    FROM SCHEMANAME.plan_regulation_geometry_area_value prgav
    WHERE gav.geometry_area_value_uuid = prgav.fk_geometry_area_value
    AND prgav.fk_plan_regulation = ANY(v_new_plan_regulation_local_ids);

    UPDATE SCHEMANAME.geometry_area_value gav
    SET is_active = TRUE
    FROM SCHEMANAME.plan_guidance_geometry_area_value pggav
    WHERE gav.geometry_area_value_uuid = pggav.fk_geometry_area_value
    AND pggav.fk_plan_guidance = ANY(v_new_plan_guidance_local_ids);

    UPDATE SCHEMANAME.geometry_area_value gav
    SET is_active = TRUE
    FROM SCHEMANAME.plan_regulation pr
    JOIN SCHEMANAME.plan_regulation_supplementary_information prsi
        ON prsi.fk_plan_regulation = pr.local_id
    JOIN SCHEMANAME.supplementary_information_geometry_area_value sigav
        ON sigav.fk_supplementary_information = prsi.fk_supplementary_information
    WHERE gav.geometry_area_value_uuid = sigav.fk_geometry_area_value
    AND pr.local_id = ANY(v_new_plan_regulation_local_ids);

    UPDATE SCHEMANAME.geometry_line_value glv
    SET is_active = TRUE
    FROM SCHEMANAME.plan_regulation_geometry_line_value prglv
    WHERE glv.geometry_line_value_uuid = prglv.fk_geometry_line_value
    AND prglv.fk_plan_regulation = ANY(v_new_plan_regulation_local_ids);

    UPDATE SCHEMANAME.geometry_line_value glv
    SET is_active = TRUE
    FROM SCHEMANAME.plan_guidance_geometry_line_value pgglv
    WHERE glv.geometry_line_value_uuid = pgglv.fk_geometry_line_value
    AND pgglv.fk_plan_guidance = ANY(v_new_plan_guidance_local_ids);

    UPDATE SCHEMANAME.geometry_line_value glv
    SET is_active = TRUE
    FROM SCHEMANAME.plan_regulation pr
    JOIN SCHEMANAME.plan_regulation_supplementary_information prsi
        ON prsi.fk_plan_regulation = pr.local_id
    JOIN SCHEMANAME.supplementary_information_geometry_line_value siglv
        ON siglv.fk_supplementary_information = prsi.fk_supplementary_information
    WHERE glv.geometry_line_value_uuid = siglv.fk_geometry_line_value
    AND pr.local_id = ANY(v_new_plan_regulation_local_ids);

    UPDATE SCHEMANAME.geometry_point_value gpv
    SET is_active = TRUE
    FROM SCHEMANAME.plan_regulation_geometry_point_value prgpv
    WHERE gpv.geometry_point_value_uuid = prgpv.fk_geometry_point_value
    AND prgpv.fk_plan_regulation = ANY(v_new_plan_regulation_local_ids);

    UPDATE SCHEMANAME.geometry_point_value gpv
    SET is_active = TRUE
    FROM SCHEMANAME.plan_guidance_geometry_point_value pggpv
    WHERE gpv.geometry_point_value_uuid = pggpv.fk_geometry_point_value
    AND pggpv.fk_plan_guidance = ANY(v_new_plan_guidance_local_ids);

    UPDATE SCHEMANAME.geometry_point_value gpv
    SET is_active = TRUE
    FROM SCHEMANAME.plan_regulation pr
    JOIN SCHEMANAME.plan_regulation_supplementary_information prsi
        ON prsi.fk_plan_regulation = pr.local_id
    JOIN SCHEMANAME.supplementary_information_geometry_point_value sigpv
        ON sigpv.fk_supplementary_information = prsi.fk_supplementary_information
    WHERE gpv.geometry_point_value_uuid = sigpv.fk_geometry_point_value
    AND pr.local_id = ANY(v_new_plan_regulation_local_ids);

    UPDATE SCHEMANAME.elevation_position_value epv
    SET is_active = TRUE
    FROM SCHEMANAME.plan_regulation_elevation_position_value prepv
    WHERE epv.elevation_position_value_uuid = prepv.fk_elevation_position_value
    AND prepv.fk_plan_regulation = ANY(v_new_plan_regulation_local_ids);

    UPDATE SCHEMANAME.elevation_position_value epv
    SET is_active = TRUE
    FROM SCHEMANAME.plan_guidance_elevation_position_value pgepv
    WHERE epv.elevation_position_value_uuid = pgepv.fk_elevation_position_value
    AND pgepv.fk_plan_guidance = ANY(v_new_plan_guidance_local_ids);

    UPDATE SCHEMANAME.elevation_position_value epv
    SET is_active = TRUE
    FROM SCHEMANAME.plan_regulation pr
    JOIN SCHEMANAME.plan_regulation_supplementary_information prsi
        ON prsi.fk_plan_regulation = pr.local_id
    JOIN SCHEMANAME.supplementary_information_elevation_position_value siepv
        ON siepv.fk_supplementary_information = prsi.fk_supplementary_information
    WHERE epv.elevation_position_value_uuid = siepv.fk_elevation_position_value
    AND pr.local_id = ANY(v_new_plan_regulation_local_ids);

    UPDATE SCHEMANAME.elevation_range_value erv
    SET is_active = TRUE
    FROM SCHEMANAME.plan_regulation_elevation_range_value prerv
    WHERE erv.elevation_range_value_uuid = prerv.fk_elevation_range_value
    AND prerv.fk_plan_regulation = ANY(v_new_plan_regulation_local_ids);

    UPDATE SCHEMANAME.elevation_range_value erv
    SET is_active = TRUE
    FROM SCHEMANAME.plan_guidance_elevation_range_value pgerv
    WHERE erv.elevation_range_value_uuid = pgerv.fk_elevation_range_value
    AND pgerv.fk_plan_guidance = ANY(v_new_plan_guidance_local_ids);

    UPDATE SCHEMANAME.elevation_range_value erv
    SET is_active = TRUE
    FROM SCHEMANAME.plan_regulation pr
    JOIN SCHEMANAME.plan_regulation_supplementary_information prsi
        ON prsi.fk_plan_regulation = pr.local_id
    JOIN SCHEMANAME.supplementary_information_elevation_range_value sierv
        ON sierv.fk_supplementary_information = prsi.fk_supplementary_information
    WHERE erv.elevation_range_value_uuid = sierv.fk_elevation_range_value
    AND pr.local_id = ANY(v_new_plan_regulation_local_ids);
END;
$BODY$;

-- FUNCTION: SCHEMANAME.validate_finished_plan(character varying)

-- DROP FUNCTION IF EXISTS SCHEMANAME.validate_finished_plan(character varying);

CREATE OR REPLACE FUNCTION SCHEMANAME.validate_finished_plan(
	spatial_plan_local_id character varying)
    RETURNS boolean
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
  _spatial_plan SCHEMANAME.spatial_plan%ROWTYPE;
  _spatial_plan_area FLOAT;
  _zoning_element_area FLOAT;
BEGIN
  SELECT * INTO _spatial_plan FROM SCHEMANAME.spatial_plan WHERE local_id = spatial_plan_local_id;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Spatial plan with local id % not found', spatial_plan_local_id;
  END IF;
  SELECT ST_Area(_spatial_plan.geom) INTO _spatial_plan_area;
  SELECT ST_Area(ST_Union(ze.geom)) INTO _zoning_element_area FROM SCHEMANAME.zoning_element ze WHERE spatial_plan = _spatial_plan.local_id;
  IF ABS(_spatial_plan_area - _zoning_element_area) > 1 THEN -- 1 square meter tolerance
    RAISE WARNING 'Zoning element geometries do not cover the spatial plan geometry';
    RETURN FALSE;
  END IF;
  RETURN TRUE;
END;
$BODY$;

-- FUNCTION: SCHEMANAME.validate_zoning_element_validity_dates(date, date, character varying)

-- DROP FUNCTION IF EXISTS SCHEMANAME.validate_zoning_element_validity_dates(date, date, character varying);

CREATE OR REPLACE FUNCTION SCHEMANAME.validate_zoning_element_validity_dates(
	valid_from date,
	valid_to date,
	spatial_plan character varying)
    RETURNS boolean
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
  sp_valid_from DATE;
  sp_valid_to DATE;
  is_valid BOOLEAN := TRUE;
BEGIN
  SELECT sp.valid_from, sp.valid_to
  INTO sp_valid_from, sp_valid_to
  FROM SCHEMANAME.spatial_plan sp
  WHERE sp.local_id = spatial_plan;

  IF valid_from IS NOT NULL AND valid_to IS NOT NULL AND valid_from > valid_to THEN
    is_valid := FALSE;
  ELSIF valid_from IS NOT NULL AND sp_valid_from IS NOT NULL AND valid_from < sp_valid_from THEN
    is_valid := FALSE;
  ELSIF valid_to IS NOT NULL AND sp_valid_to IS NOT NULL AND valid_to > sp_valid_to THEN
    is_valid := FALSE;
  END IF;

  RETURN is_valid;
END;
$BODY$;

-- END OF FUNCTIONS
-- START OF TRIGGER FUNCTIONS

-- FUNCTION: SCHEMANAME.convert_to_timerange()

-- DROP FUNCTION IF EXISTS SCHEMANAME.convert_to_timerange();

CREATE OR REPLACE FUNCTION SCHEMANAME.convert_to_timerange()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
BEGIN
  IF NEW."value" IS NOT NULL AND NEW."value" <> OLD."value" THEN
    RAISE EXCEPTION 'Cannot change time_period_value';
  END IF;
  IF NEW.time_period_from IS NULL THEN
    IF NEW.time_period_to IS NOT NULL THEN
      RAISE EXCEPTION 'time_period_from cannot be NULL if time_period_to is not NULL';
    END IF;
    NEW."value" = NULL;
    RETURN NEW;
  END IF;
  NEW."value" = TSRANGE(NEW.time_period_from, NEW.time_period_to, '[)');
  RETURN NEW;
END;
$BODY$;


-- FUNCTION: SCHEMANAME.create_or_update_spatial_plan()

-- DROP FUNCTION IF EXISTS SCHEMANAME.create_or_update_spatial_plan();

CREATE OR REPLACE FUNCTION SCHEMANAME.create_or_update_spatial_plan()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
BEGIN
    IF (TG_TABLE_NAME = 'spatial_plan_metadata' AND TG_OP = 'UPDATE') THEN
        IF (NEW."name" <> OLD."name") THEN
            UPDATE SCHEMANAME.spatial_plan
            SET "name" = NEW."name"
            WHERE plan_id = NEW.plan_id;
        END IF;

        IF (NEW."plan_id" <> OLD."plan_id") THEN
            UPDATE SCHEMANAME.spatial_plan
            SET plan_id = NEW."plan_id"
            WHERE plan_id = OLD."plan_id";
        END IF;
        RETURN NEW;
    END IF;
    IF (TG_TABLE_NAME = 'spatial_plan') THEN
        IF NOT EXISTS (
            SELECT 1
            FROM SCHEMANAME.spatial_plan_metadata
            WHERE plan_id = NEW.plan_id
        ) THEN
            INSERT INTO SCHEMANAME.spatial_plan_metadata (plan_id, "name", created)
            VALUES (NEW.plan_id, NEW."name", NOW());
        ELSE
            UPDATE SCHEMANAME.spatial_plan_metadata
            SET "name" = NEW."name"
            WHERE plan_id = NEW.plan_id;

            UPDATE SCHEMANAME.spatial_plan
            SET "name" = NEW."name"
            WHERE plan_id = NEW.plan_id
            AND "name" <> NEW."name";
        END IF;
        RETURN NEW;
    END IF;

    RETURN NULL;
END;
$BODY$;

-- FUNCTION: SCHEMANAME.delete_geom_relations()

-- DROP FUNCTION IF EXISTS SCHEMANAME.delete_geom_relations();

CREATE OR REPLACE FUNCTION SCHEMANAME.delete_geom_relations()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
DECLARE
  table_name text;
BEGIN
  table_name := TG_TABLE_NAME;
  CASE table_name
    WHEN 'spatial_plan' THEN
      UPDATE SCHEMANAME.zoning_element
      SET spatial_plan = NULL
      WHERE spatial_plan = OLD.local_id;
      RETURN NEW;
    WHEN 'zoning_element' THEN
      DELETE
      FROM SCHEMANAME.zoning_element_planned_space
      WHERE zoning_element_local_id = OLD.local_id;
      DELETE
      FROM SCHEMANAME.zoning_element_plan_detail_line
      WHERE zoning_element_local_id = OLD.local_id;
      DELETE
      FROM SCHEMANAME.zoning_element_describing_line
      WHERE zoning_element_local_id = OLD.local_id;
      DELETE
      FROM SCHEMANAME.zoning_element_describing_text
      WHERE zoning_element_local_id = OLD.local_id;
      NEW.spatial_plan := NULL;
      RETURN NEW;
    WHEN 'planned_space' THEN
      DELETE
      FROM SCHEMANAME.zoning_element_planned_space
      WHERE planned_space_local_id = OLD.local_id;
      DELETE
      FROM SCHEMANAME.planned_space_plan_detail_line
      WHERE planned_space_local_id = OLD.local_id;
      RETURN NEW;
    WHEN 'planning_detail_line' THEN
      DELETE
      FROM SCHEMANAME.zoning_element_plan_detail_line
      WHERE planning_detail_line_local_id = OLD.local_id;
      DELETE
      FROM SCHEMANAME.planned_space_plan_detail_line
      WHERE planning_detail_line_local_id = OLD.local_id;
      RETURN NEW;
    WHEN 'describing_line' THEN
      DELETE
      FROM SCHEMANAME.zoning_element_describing_line
      WHERE describing_line_id = OLD.identifier;
      RETURN NEW;
    WHEN 'describing_text' THEN
      DELETE
      FROM SCHEMANAME.zoning_element_describing_text
      WHERE describing_text_id = OLD.identifier;
      RETURN NEW;
    ELSE
      RETURN NEW;
  END CASE;
END;
$BODY$;

-- FUNCTION: SCHEMANAME.geom_relations()

-- DROP FUNCTION IF EXISTS SCHEMANAME.geom_relations();

CREATE OR REPLACE FUNCTION SCHEMANAME.geom_relations()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
DECLARE
    table_name TEXT;
BEGIN
    IF NOT (NEW.is_active) THEN
        RETURN NEW;
    END IF;
    table_name := TG_TABLE_NAME;
    IF table_name IN ('spatial_plan', 'zoning_element') THEN
        UPDATE SCHEMANAME.zoning_element ze
        SET spatial_plan = sp.local_id
        FROM SCHEMANAME.spatial_plan sp
        WHERE ze.is_active
            AND sp.is_active
            AND st_contains(st_buffer(sp.geom, 1), ze.geom)
            AND sp.lifecycle_status IN ('01', '02', '03', '04', '05')
            AND ze.lifecycle_status IN ('01', '02', '03', '04', '05')
            AND ze.spatial_plan IS NULL;
    END IF;

  IF TG_TABLE_NAME IN ('zoning_element', 'planned_space') THEN
    INSERT INTO SCHEMANAME.zoning_element_planned_space (zoning_element_local_id, planned_space_local_id)
    SELECT DISTINCT ze.local_id, ps.local_id
    FROM SCHEMANAME.zoning_element ze
      INNER JOIN SCHEMANAME.planned_space ps ON
        st_overlaps(
          st_buffer(ze.geom, 0.1::DOUBLE PRECISION), ps.geom
        )
        OR
        st_contains(st_buffer(ze.geom, 0.1::DOUBLE PRECISION), ps.geom)
    WHERE ze.is_active
        AND ps.is_active
        AND ze.lifecycle_status IN ('01', '02', '03', '04', '05')
        AND ps.lifecycle_status IN ('01', '02', '03', '04', '05')
    AND NOT EXISTS (
      SELECT 1
      FROM SCHEMANAME.zoning_element_planned_space zeps
      WHERE zeps.planned_space_local_id = ps.local_id AND
            zeps.zoning_element_local_id = ze.local_id
    );
  END IF;

  IF (tg_table_name IN ('zoning_element', 'planning_detail_line')) THEN
    INSERT INTO SCHEMANAME.zoning_element_plan_detail_line (zoning_element_local_id, planning_detail_line_local_id)
    SELECT DISTINCT
      ze.local_id,
      pdl.local_id
    FROM SCHEMANAME.zoning_element ze
      INNER JOIN SCHEMANAME.planning_detail_line pdl
        ON st_intersects(ze.geom, pdl.geom)
    WHERE ze.is_active
        AND pdl.is_active
        AND ze.lifecycle_status IN ('01', '02', '03', '04', '05')
        AND pdl.lifecycle_status IN ('01', '02', '03', '04', '05')
        AND NOT EXISTS (
            SELECT 1
            FROM SCHEMANAME.zoning_element_plan_detail_line zepdl
            WHERE zepdl.planning_detail_line_local_id = pdl.local_id AND
                zepdl.zoning_element_local_id = ze.local_id
      );
    END IF;

    IF (tg_table_name IN ('zoning_element', 'describing_line')) THEN
      INSERT INTO SCHEMANAME.zoning_element_describing_line (zoning_element_local_id, describing_line_id)
      SELECT DISTINCT
        ze.local_id,
        dl.identifier
      FROM SCHEMANAME.zoning_element ze
        INNER JOIN SCHEMANAME.describing_line dl
          ON st_intersects(ze.geom, dl.geom)
      WHERE ze.is_active
        AND dl.is_active
        AND ze.lifecycle_status IN ('01', '02', '03', '04', '05')
        AND dl.lifecycle_status IN ('01', '02', '03', '04', '05')
        AND NOT EXISTS (
          SELECT 1
          FROM SCHEMANAME.zoning_element_describing_line zedl
          WHERE zedl.describing_line_id = dl.identifier AND
                zedl.zoning_element_local_id = ze.local_id
        );
    END IF;

      IF (tg_table_name IN ('zoning_element', 'describing_text')) THEN
        INSERT INTO SCHEMANAME.zoning_element_describing_text (zoning_element_local_id, describing_text_id)
        SELECT DISTINCT
          ze.local_id,
          dt.identifier
        FROM SCHEMANAME.zoning_element ze
          INNER JOIN SCHEMANAME.describing_text dt
            ON st_intersects(ze.geom, dt.geom)
        WHERE ze.is_active
            AND dt.is_active
            AND ze.lifecycle_status IN ('01', '02', '03', '04', '05')
            AND dt.lifecycle_status IN ('01', '02', '03', '04', '05')
            AND NOT EXISTS (
                SELECT 1
                FROM SCHEMANAME.zoning_element_describing_text zedt
                WHERE zedt.describing_text_id = dt.identifier AND
                    zedt.zoning_element_local_id = ze.local_id
          );
      END IF;

      IF (tg_table_name IN ('planned_space', 'planning_detail_line')) THEN
        INSERT INTO SCHEMANAME.planned_space_plan_detail_line (planned_space_local_id, planning_detail_line_local_id)
        SELECT DISTINCT
            ps.local_id,
            pdl.local_id
        FROM SCHEMANAME.planned_space ps
            INNER JOIN SCHEMANAME.planning_detail_line pdl
                ON st_intersects(ps.geom, pdl.geom)
        WHERE ps.is_active
            AND pdl.is_active
            AND ps.lifecycle_status IN ('01', '02', '03', '04', '05')
            AND pdl.lifecycle_status IN ('01', '02', '03', '04', '05')
            AND NOT EXISTS (
                SELECT 1
                FROM SCHEMANAME.planned_space_plan_detail_line ps_pdl
                WHERE ps_pdl.planning_detail_line_local_id = pdl.local_id AND
                    ps_pdl.planned_space_local_id = ps.local_id
            );
      END IF;
    RETURN NULL;
END;
$BODY$;

-- FUNCTION: SCHEMANAME.inherit_validity()

-- DROP FUNCTION IF EXISTS SCHEMANAME.inherit_validity();

CREATE OR REPLACE FUNCTION SCHEMANAME.inherit_validity()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
BEGIN
  WITH sp_inherited_validity AS (
    SELECT
      sp.valid_from AS valid_from,
      sp.valid_to AS valid_to,
      ze.local_id AS local_id
    FROM SCHEMANAME.spatial_plan sp
    INNER JOIN SCHEMANAME.zoning_element ze
      ON sp.local_id = ze.spatial_plan
    WHERE (
      sp.valid_from IS NOT NULL
      AND (
        ze.valid_from IS NULL
        OR ze.valid_from < sp.valid_from
      )
    ) OR (
      sp.valid_to IS NOT NULL
      AND (
        ze.valid_to IS NULL
        OR ze.valid_to > sp.valid_to
      )
    )
  )
  UPDATE SCHEMANAME.zoning_element ze
  SET valid_from = spiv.valid_from,
      valid_to = spiv.valid_to
  FROM sp_inherited_validity spiv
  WHERE spiv.local_id = ze.local_id;

  WITH ze_inherited_validity AS (
    SELECT
      MIN(ze.valid_from) AS valid_from,
      MAX(ze.valid_to) AS valid_to,
      ps.local_id AS local_id
    FROM SCHEMANAME.zoning_element ze
      INNER JOIN SCHEMANAME.zoning_element_planned_space ze_ps
        ON ze_ps.zoning_element_local_id = ze.local_id
      INNER JOIN SCHEMANAME.planned_space ps
        ON ps.local_id = ze_ps.planned_space_local_id
    WHERE (
      ze.valid_from IS NOT NULL
      AND (
        ps.valid_from IS NULL
        OR ps.valid_from < ze.valid_from
      )
    ) OR (
      ze.valid_to IS NOT NULL
      AND (
        ps.valid_to IS NULL
        OR ps.valid_to > ze.valid_to
      )
    )
    GROUP BY ps.local_id
  )
  UPDATE SCHEMANAME.planned_space ps
  SET valid_from = zeiv.valid_from,
      valid_to = zeiv.valid_to
  FROM ze_inherited_validity zeiv
  WHERE zeiv.local_id = ps.local_id;

  RETURN NULL;
END;
$BODY$;

-- FUNCTION: SCHEMANAME.insert_version_name()

-- DROP FUNCTION IF EXISTS SCHEMANAME.insert_version_name();

CREATE OR REPLACE FUNCTION SCHEMANAME.insert_version_name()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
BEGIN
    IF (NEW.version_name IS NULL) THEN
        CASE NEW."language"
            WHEN 1 THEN NEW.version_name := NEW.name ->> 'fin';
            WHEN 2 THEN NEW.version_name := NEW.name ->> 'swe';
            WHEN 3 THEN NEW.version_name := NEW.name ->> 'fin';
        END CASE;

        NEW.version_name := NEW.version_name || '_import_' || to_char(now(), 'YYYY-MM-DDHH24:MI:SS');
    END IF;

    RETURN NEW;
END;
$BODY$;

-- FUNCTION: SCHEMANAME.refresh_plan_regulations_area_view()

-- DROP FUNCTION IF EXISTS SCHEMANAME.refresh_plan_regulations_area_view();

CREATE OR REPLACE FUNCTION SCHEMANAME.refresh_plan_regulations_area_view()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF SECURITY DEFINER
AS $BODY$
BEGIN REFRESH MATERIALIZED VIEW SCHEMANAME.plan_regulations_area_view;
RETURN NULL;
END 
$BODY$;

-- FUNCTION: SCHEMANAME.refresh_plan_regulations_line_view()

-- DROP FUNCTION IF EXISTS SCHEMANAME.refresh_plan_regulations_line_view();

CREATE OR REPLACE FUNCTION SCHEMANAME.refresh_plan_regulations_line_view()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF SECURITY DEFINER
AS $BODY$
BEGIN REFRESH MATERIALIZED VIEW SCHEMANAME.plan_regulations_line_view;
RETURN NULL;
END 
$BODY$;

-- FUNCTION: SCHEMANAME.refresh_plan_regulations_point_view()

-- DROP FUNCTION IF EXISTS SCHEMANAME.refresh_plan_regulations_point_view();

CREATE OR REPLACE FUNCTION SCHEMANAME.refresh_plan_regulations_point_view()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF SECURITY DEFINER
AS $BODY$
    BEGIN REFRESH MATERIALIZED VIEW SCHEMANAME.plan_regulations_point_view;
    RETURN NULL;
END 
$BODY$;

-- FUNCTION: SCHEMANAME.update_validity()

-- DROP FUNCTION IF EXISTS SCHEMANAME.update_validity();

CREATE OR REPLACE FUNCTION SCHEMANAME.update_validity()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
BEGIN
  PERFORM SCHEMANAME.refresh_validity();

  CREATE TEMPORARY TABLE temp_spatial_plan AS (
    WITH valid_geom AS (
      SELECT
        local_id,
        SCHEMANAME.get_valid_spatial_plan_area(local_id) AS geom
      FROM SCHEMANAME.spatial_plan sp
      WHERE sp.lifecycle_status IN ('8', '10', '11')
        AND sp.validity_time @> CURRENT_DATE
    )
    SELECT
      sp.local_id,
      vg.geom,
      sp.lifecycle_status,
      sp.validity_time
    FROM valid_geom vg
      JOIN SCHEMANAME.spatial_plan sp on sp.local_id = vg.local_id
    WHERE vg.geom IS NOT NULL
  );

  WITH spatial_plan_valid_from AS (
      SELECT
        MAX(lower(tsp.validity_time)) AS max_valid_from,
        sp.local_id
      FROM SCHEMANAME.spatial_plan sp
      JOIN temp_spatial_plan tsp ON
        sp.geom && tsp.geom
        AND NOT ST_Relate(
          ST_Buffer(sp.geom, -0.1),
          ST_Buffer(tsp.geom, 0.1),
          'FF*******'
        )
      GROUP BY sp.local_id
  )
  UPDATE SCHEMANAME.spatial_plan sp
  SET
    lifecycle_status = '12',
    valid_to = spvf.max_valid_from
  FROM spatial_plan_valid_from spvf
  WHERE sp.local_id = spvf.local_id
      AND sp.lifecycle_status IN ('10', '11')
      AND sp.validity_time @> CURRENT_DATE
      AND ST_Within(
        sp.geom,
        ST_Buffer(
          (SELECT
            ST_Union(tsp.geom)
          FROM temp_spatial_plan tsp
          WHERE tsp.local_id <> sp.local_id
          AND tsp.validity_time &> sp.validity_time
          ),
          0.1));

  UPDATE SCHEMANAME.spatial_plan sp
  SET lifecycle_status = '10'
  WHERE sp.lifecycle_status = '11'
    AND sp.validity_time @> CURRENT_DATE
    AND ST_Overlaps(
      sp.geom,
      ST_Buffer(
        (SELECT ST_Union(tsp.geom)
        FROM temp_spatial_plan tsp
        WHERE
          tsp.local_id <> sp.local_id
          AND tsp.validity_time &> sp.validity_time
          AND tsp.lifecycle_status IN ('10', '11')),
          0.1)
      );

  DROP TABLE temp_spatial_plan;

  CREATE TEMPORARY TABLE temp_zoning_element AS (
    WITH valid_zoning_elements AS (
      SELECT
        local_id,
        SCHEMANAME.get_valid_zoning_element_area(local_id) AS geom
      FROM SCHEMANAME.zoning_element
      WHERE lifecycle_status IN ('10', '11')
        AND validity_time @> CURRENT_DATE
    )
    SELECT
      ze.local_id AS local_id,
      vze.geom AS geom,
      ze.valid_from,
      ze.valid_to,
      ze.validity_time AS validity_time,
      ze.lifecycle_status AS lifecycle_status,
      ze.spatial_plan AS spatial_plan
    FROM valid_zoning_elements vze
      JOIN SCHEMANAME.zoning_element ze ON ze.local_id = vze.local_id
    WHERE vze.geom IS NOT NULL
  );

  WITH zoning_element_valid_from AS (
    SELECT
      Max(tze.valid_from) AS max_valid_from,
      ze.local_id AS local_id
    FROM SCHEMANAME.zoning_element ze
    JOIN temp_zoning_element tze ON
      ze.geom && tze.geom
      AND NOT ST_Relate(
        ST_Buffer(ze.geom, -0.1),
        ST_Buffer(tze.geom, 0.1),
        'FF*******'
      )
    GROUP BY ze.local_id
  )
  UPDATE SCHEMANAME.zoning_element ze
  SET lifecycle_status = '12',
      valid_to = zevf.max_valid_from
  FROM zoning_element_valid_from zevf
  WHERE ze.local_id = zevf.local_id
    AND ze.lifecycle_status NOT IN ('10', '11')
    AND ze.validity_time @> CURRENT_DATE
    AND st_within(
      ze.geom,
      ST_Buffer(
        (
          SELECT ST_Union(tze.geom)
          FROM temp_zoning_element tze
          WHERE tze.local_id <> ze.local_id
            AND tze.validity_time &> ze.validity_time),
        0.1
      ));

  UPDATE SCHEMANAME.zoning_element ze
  SET lifecycle_status = '10'
  WHERE ze.lifecycle_status = '11'
    AND ze.validity_time @> CURRENT_DATE
    AND ST_Overlaps(
      ze.geom,
      ST_Buffer(
        (
          SELECT ST_Union(tze.geom)
          FROM temp_zoning_element tze
          WHERE tze.local_id <> ze.local_id
            AND tze.spatial_plan <> ze.spatial_plan
            AND tze.validity_time &> ze.validity_time
            AND tze.lifecycle_status = '11'
        ), -0.1
      ));

  DROP TABLE temp_zoning_element;

  UPDATE SCHEMANAME.planned_space ps
    SET lifecycle_status = '12'
    WHERE
      ST_Within(
        ps.geom,
        ST_Buffer(
          (WITH RECURSIVE zoning_elements(local_id) AS (
            SELECT ze.local_id
            FROM SCHEMANAME.zoning_element ze
            WHERE ze.validity_time @> CURRENT_DATE
              AND ze.lifecycle_status NOT IN ('10', '11')
            EXCEPT
            SELECT ze_ps.zoning_element_local_id
            FROM SCHEMANAME.zoning_element_planned_space ze_ps
            WHERE ze_ps.planned_space_local_id = ps.local_id
        )
          SELECT ST_Union(SCHEMANAME.get_valid_zoning_element_area(ze.local_id))
          FROM SCHEMANAME.zoning_element ze,
                zoning_elements zes
          WHERE ze.local_id = zes.local_id),
        0.1)
      )
      AND ps.lifecycle_status IN ('10', '11');

    UPDATE SCHEMANAME.planned_space ps
    SET lifecycle_status = '10'
    WHERE ST_Overlaps(
      ps.geom,
      ST_Buffer(
      (WITH RECURSIVE zoning_elements(local_id) AS (
        SELECT ze.local_id
        FROM SCHEMANAME.zoning_element ze
        WHERE ze.validity_time @> CURRENT_DATE
          AND ze.lifecycle_status = '11'
            EXCEPT
        SELECT ze_ps.zoning_element_local_id
        FROM SCHEMANAME.zoning_element_planned_space ze_ps
        WHERE ze_ps.planned_space_local_id = ps.local_id
      )
        SELECT ST_Union(SCHEMANAME.get_valid_zoning_element_area(ze.local_id))
        FROM SCHEMANAME.zoning_element ze,
              zoning_elements zes
        WHERE zes.local_id = ze.local_id
      ),
        0.1))
      AND ps.lifecycle_status = '11';

    UPDATE SCHEMANAME.planning_detail_line pdl
    SET lifecycle_status = '12'
    WHERE ST_Within(
      pdl.geom,
      ST_Buffer(
      (WITH RECURSIVE zoning_elements(local_id) AS (
        SELECT ze.local_id
        FROM SCHEMANAME.zoning_element ze
        WHERE ze.validity_time @> CURRENT_DATE
          AND ze.lifecycle_status NOT IN ('10', '11')
            EXCEPT
        SELECT ze_pdl.zoning_element_local_id
        FROM SCHEMANAME.zoning_element_plan_detail_line ze_pdl
        WHERE ze_pdl.planning_detail_line_local_id = pdl.local_id
      )
        SELECT ST_Union(SCHEMANAME.get_valid_zoning_element_area(ze.local_id))
        FROM SCHEMANAME.zoning_element ze,
              zoning_elements zes
        WHERE ze.local_id = zes.local_id
      ),
        0.1)
      )
      AND pdl.lifecycle_status IN ('10', '11');

    UPDATE SCHEMANAME.planning_detail_line pdl
    SET lifecycle_status = '10'
    WHERE ST_Crosses(
      pdl.geom,
      ST_Buffer(
      (WITH RECURSIVE zoning_elements(local_id) AS (
        SELECT ze.local_id
        FROM SCHEMANAME.zoning_element ze
        WHERE ze.validity_time @> CURRENT_DATE
          AND ze.lifecycle_status = '11'
        EXCEPT
        SELECT ze_pdl.zoning_element_local_id
        FROM SCHEMANAME.zoning_element_plan_detail_line ze_pdl
        WHERE ze_pdl.planning_detail_line_local_id = pdl.local_id
      )
        SELECT ST_Union(SCHEMANAME.get_valid_zoning_element_area(ze.local_id))
        FROM SCHEMANAME.zoning_element ze,
              zoning_elements zes
        WHERE ze.local_id = zes.local_id
      ),
      0.1))
      AND pdl.lifecycle_status = '11';

    UPDATE SCHEMANAME.describing_line dl
    SET lifecycle_status = '12'
    WHERE ST_Within(
      dl.geom,
      ST_Buffer(
      (WITH RECURSIVE zoning_elements(local_id) AS (
        SELECT ze.local_id
        FROM SCHEMANAME.zoning_element ze
        WHERE ze.validity_time @> CURRENT_DATE
          AND ze.lifecycle_status IN ('10', '11')
            EXCEPT
        SELECT ze_dl.zoning_element_local_id
        FROM SCHEMANAME.zoning_element_describing_line ze_dl
        WHERE ze_dl.describing_line_id = dl.identifier
      )
        SELECT ST_Union(SCHEMANAME.get_valid_zoning_element_area(ze.local_id))
        FROM SCHEMANAME.zoning_element ze,
              zoning_elements zes
        WHERE ze.local_id = zes.local_id
      ),
      0.1))
      AND dl.lifecycle_status IN ('10', '11');

    UPDATE SCHEMANAME.describing_line dl
    SET lifecycle_status = '10'
    WHERE ST_Crosses(
      dl.geom,
      ST_Buffer(
      (WITH RECURSIVE zoning_elements(local_id) AS (
        SELECT ze.local_id
        FROM SCHEMANAME.zoning_element ze
        WHERE ze.validity_time @> CURRENT_DATE
          AND ze.lifecycle_status = '11'
        EXCEPT
        SELECT ze_dl.zoning_element_local_id
        FROM SCHEMANAME.zoning_element_describing_line ze_dl
        WHERE ze_dl.describing_line_id = dl.identifier
      )
        SELECT ST_Union(SCHEMANAME.get_valid_zoning_element_area(ze.local_id))
        FROM SCHEMANAME.zoning_element ze,
              zoning_elements zes
        WHERE ze.local_id = zes.local_id
      ),
      0.1))
      AND dl.lifecycle_status = '11';

    UPDATE SCHEMANAME.describing_text dt
    SET lifecycle_status = '12'
    WHERE ST_Within(
      dt.geom,
      ST_Buffer(
      (WITH RECURSIVE zoning_elements(local_id) AS (
        SELECT ze.local_id
        FROM SCHEMANAME.zoning_element ze
        WHERE ze.validity_time @> CURRENT_DATE
          AND ze.lifecycle_status IN ('10', '11')
        EXCEPT
        SELECT ze_dt.zoning_element_local_id
        FROM SCHEMANAME.zoning_element_describing_text ze_dt
        WHERE ze_dt.describing_text_id = dt.identifier
      )
        SELECT ST_Union(SCHEMANAME.get_valid_zoning_element_area(ze.local_id))
        FROM SCHEMANAME.zoning_element ze,
              zoning_elements zes
        WHERE ze.local_id = zes.local_id
      ),
      0.1))
      AND dt.lifecycle_status IN ('10', '11');

    PERFORM SCHEMANAME.refresh_validity();
    RETURN NULL;
END;
$BODY$;

-- FUNCTION: SCHEMANAME.upsert_creator_and_modifier_trigger()

-- DROP FUNCTION IF EXISTS SCHEMANAME.upsert_creator_and_modifier_trigger();

CREATE OR REPLACE FUNCTION SCHEMANAME.upsert_creator_and_modifier_trigger()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
BEGIN
  IF TG_OP = 'INSERT' THEN
    NEW.created = now();
    NEW.created_by = current_user;
  ELSIF TG_OP = 'UPDATE' THEN
    NEW.created = OLD.created;
    NEW.created_by = OLD.created_by;
  END IF;
  NEW.modified_by = current_user;
  NEW.modified_at = now();
  RETURN NEW;
END;
$BODY$;

-- FUNCTION: SCHEMANAME.upsert_ridge_direction()

-- DROP FUNCTION IF EXISTS SCHEMANAME.upsert_ridge_direction();

CREATE OR REPLACE FUNCTION SCHEMANAME.upsert_ridge_direction()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
DECLARE
  _ridge_direction DOUBLE PRECISION;
  _regulation RECORD;
  _planning_detail_line RECORD;
  _planned_space RECORD;
  _numeric_value UUID;
  _inserted_regulation RECORD;
  _inserted_value RECORD;
BEGIN
  IF TG_TABLE_NAME = 'planning_detail_line_plan_regulation' THEN
    _regulation = (SELECT * FROM SCHEMANAME.plan_regulation WHERE local_id = NEW.plan_regulation_local_id);
    IF _regulation."type" = '0503' THEN
      _planning_detail_line := (SELECT * FROM SCHEMANAME.planning_detail_line WHERE local_id = NEW.planning_detail_line_local_id);
      _ridge_direction := degrees(ST_Azimuth(ST_StartPoint(ST_GeometryN(_planning_detail_line.geom, 1)), ST_EndPoint(ST_GeometryN(_planning_detail_line.geom, 1))));
      _numeric_value = (SELECT fk_numeric_double_value FROM SCHEMANAME.plan_regulation_numeric_double_value WHERE fk_plan_regulation = _regulation.local_id);
      IF _numeric_value IS NULL THEN
        INSERT INTO SCHEMANAME.plan_regulation_numeric_double_value ("value", unit_of_measure)
          VALUES (_ridge_direction, 'deg') RETURNING * INTO _inserted_value;
        INSERT INTO SCHEMANAME.plan_regulation_numeric_double_value(fk_plan_regulation, fk_numeric_double_value)
          VALUES (_regulation.local_id, _inserted_value.numeric_double_value_uuid);
      ELSE
        UPDATE SCHEMANAME.numeric_double_value
          SET "value" = _ridge_direction
          WHERE numeric_double_value_uuid = _numeric_value;
      END IF;
    END IF;
  ELSIF TG_TABLE_NAME = 'planning_detail_line' AND TG_OP = 'update' THEN
    _regulation := (SELECT pr.* FROM SCHEMANAME.plan_regulation pr INNER JOIN SCHEMANAME.planning_detail_line_plan_regulation pdlr ON pr.local_id = pdlr.plan_regulation_local_id INNER JOIN SCHEMANAME.planning_detail_line pdl ON pdl.local_id = pdlr.planning_detail_line_local_id WHERE pdl.local_id = NEW.local_id AND pr."type" = '0503');
    IF _regulation IS NOT NULL THEN
      _ridge_direction := degrees(ST_Azimuth(ST_StartPoint(ST_GeometryN(NEW.geom, 1)), ST_EndPoint(ST_GeometryN(NEW.geom, 1))));
      _numeric_value = (SELECT fk_numeric_double_value FROM SCHEMANAME.plan_regulation_numeric_double_value WHERE fk_plan_regulation = _regulation.local_id);
      IF _numeric_value IS NULL THEN
        INSERT INTO SCHEMANAME.plan_regulation_numeric_double_value ("value", unit_of_measure)
          VALUES (_ridge_direction, 'deg') RETURNING * INTO _inserted_value;
        INSERT INTO SCHEMANAME.plan_regulation_numeric_double_value(fk_plan_regulation, fk_numeric_double_value)
          VALUES (_regulation.local_id, _inserted_value.numeric_double_value_uuid);
      ELSE
        UPDATE SCHEMANAME.numeric_double_value
          SET "value" = _ridge_direction
          WHERE numeric_double_value_uuid = _numeric_value;
      END IF;
    END IF;
  END IF;
  RETURN NEW;
END;
$BODY$;

-- FUNCTION: SCHEMANAME.validate_geometry()

-- DROP FUNCTION IF EXISTS SCHEMANAME.validate_geometry();

CREATE OR REPLACE FUNCTION SCHEMANAME.validate_geometry()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
DECLARE
    valid_reason text;
BEGIN
    IF TG_TABLE_NAME IN ('geometry_area_value', 'geometry_line_value', 'geometry_point_value') THEN
        IF NOT ST_IsValid(NEW."value") THEN
            valid_reason := ST_IsValidReason(NEW."value");
            NEW."value" = ST_MakeValid(NEW."value", 'method=structure');
            RAISE WARNING 'New or updated geometry in % with identifier % is not valid. Reason: %. Geometry has been made valid. Please verify fixed geometry.', TG_TABLE_NAME, NEW.identifier, valid_reason;
        END IF;
    ELSE
        IF NOT ST_IsValid(NEW.geom) THEN
            valid_reason := ST_IsValidReason(NEW.geom);
            NEW.geom = ST_MakeValid(NEW.geom, 'method=structure');
            RAISE WARNING 'New or updated geometry in % with identifier % is not valid. Reason: %. Geometry has been made valid. Please verify fixed geometry.', TG_TABLE_NAME, NEW.identifier, valid_reason;
        END IF;
    END IF;
  RETURN NEW;
END;
$BODY$;

-- FUNCTION: SCHEMANAME.validate_lifcycle_status()

-- DROP FUNCTION IF EXISTS SCHEMANAME.validate_lifcycle_status();

CREATE OR REPLACE FUNCTION SCHEMANAME.validate_lifcycle_status()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
DECLARE
  old_status text;
  valid_statuses text;
BEGIN
  IF OLD.lifecycle_status IS NOT NULL OR OLD.lifecycle_status <> NEW.lifecycle_status THEN
    CASE OLD.lifecycle_status
      WHEN '01' THEN
        IF NEW.lifecycle_status NOT IN ('02', '03', '04', '05', '06', '15') THEN
          old_status := (
            SELECT preflabel_fi
            FROM code_lists.spatial_plan_lifecycle_status
            WHERE codevalue = OLD.lifecycle_status
          );
          valid_statuses := (
            SELECT string_agg(preflabel_fi, ', ')
            FROM code_lists.spatial_plan_lifecycle_status
            WHERE codevalue IN ('02', '03', '04', '05', '06', '15')
          );
          RAISE EXCEPTION 'Invalid status transition. Valid transitions from % are %', old_status, valid_statuses;
        END IF;
      WHEN '02' THEN
        IF NEW.lifecycle_status NOT IN ('03', '04', '05', '06', '14') THEN
          old_status := (
            SELECT preflabel_fi
            FROM code_lists.spatial_plan_lifecycle_status
            WHERE codevalue = OLD.lifecycle_status
          );
          valid_statuses := (
            SELECT string_agg(preflabel_fi, ', ')
            FROM code_lists.spatial_plan_lifecycle_status
            WHERE codevalue IN ('03', '04', '05', '06', '14')
          );
          RAISE EXCEPTION 'Invalid status transition. Valid transitions from % are %', old_status, valid_statuses;
        END IF;
      WHEN '03' THEN
        IF NEW.lifecycle_status NOT IN ('04', '05', '06', '14') THEN
          old_status := (
            SELECT preflabel_fi
            FROM code_lists.spatial_plan_lifecycle_status
            WHERE codevalue = OLD.lifecycle_status
          );
          valid_statuses := (
            SELECT string_agg(preflabel_fi, ', ')
            FROM code_lists.spatial_plan_lifecycle_status
            WHERE codevalue IN ('04', '05', '06', '14')
          );
          RAISE EXCEPTION 'Invalid status transition. Valid transitions from % are %', old_status, valid_statuses;
        END IF;
      WHEN '04' THEN
        IF NEW.lifecycle_status NOT IN ('05', '06', '14') THEN
          old_status := (
            SELECT preflabel_fi
            FROM code_lists.spatial_plan_lifecycle_status
            WHERE codevalue = OLD.lifecycle_status
          );
          valid_statuses := (
            SELECT string_agg(preflabel_fi, ', ')
            FROM code_lists.spatial_plan_lifecycle_status
            WHERE codevalue IN ('05', '06', '14')
          );
          RAISE EXCEPTION 'Invalid status transition. Valid transitions from % are %', old_status, valid_statuses;
        END IF;
      WHEN '05' THEN
        IF NEW.lifecycle_status NOT IN ('06', '14') THEN
          old_status := (
            SELECT preflabel_fi
            FROM code_lists.spatial_plan_lifecycle_status
            WHERE codevalue = OLD.lifecycle_status
          );
          valid_statuses := (
            SELECT string_agg(preflabel_fi, ', ')
            FROM code_lists.spatial_plan_lifecycle_status
            WHERE codevalue IN ('06', '14')
          );
          RAISE EXCEPTION 'Invalid status transition. Valid transitions from % are %', old_status, valid_statuses;
        END IF;
      WHEN '06' THEN
        IF NEW.lifecycle_status NOT IN ('07', '08', '09', '10', '11', '13') THEN
          old_status := (
            SELECT preflabel_fi
            FROM code_lists.spatial_plan_lifecycle_status
            WHERE codevalue = OLD.lifecycle_status
          );
          valid_statuses := (
            SELECT string_agg(preflabel_fi, ', ')
            FROM code_lists.spatial_plan_lifecycle_status
            WHERE codevalue IN ('07', '08', '09', '10', '11', '13')
          );
          RAISE EXCEPTION 'Invalid status transition. Valid transitions from % are %', old_status, valid_statuses;
        END IF;
      WHEN '07' THEN
        IF NEW.lifecycle_status NOT IN ('08', '09', '10', '11', '13') THEN
          old_status := (
            SELECT preflabel_fi
            FROM code_lists.spatial_plan_lifecycle_status
            WHERE codevalue = OLD.lifecycle_status
          );
          valid_statuses := (
            SELECT string_agg(preflabel_fi, ', ')
            FROM code_lists.spatial_plan_lifecycle_status
            WHERE codevalue IN ('08', '09', '10', '11', '13')
          );
          RAISE EXCEPTION 'Invalid status transition. Valid transitions from % are %', old_status, valid_statuses;
        END IF;
      WHEN '08' THEN
        IF NEW.lifecycle_status NOT IN ('07', '09', '10', '11', '13') THEN
          old_status := (
            SELECT preflabel_fi
            FROM code_lists.spatial_plan_lifecycle_status
            WHERE codevalue = OLD.lifecycle_status
          );
          valid_statuses := (
            SELECT string_agg(preflabel_fi, ', ')
            FROM code_lists.spatial_plan_lifecycle_status
            WHERE codevalue IN ('07', '09', '10', '11', '13')
          );
          RAISE EXCEPTION 'Invalid status transition. Valid transitions from % are %', old_status, valid_statuses;
        END IF;
      WHEN '09' THEN
        IF NEW.lifecycle_status NOT IN ('07', '08', '10', '11', '13') THEN
          old_status := (
            SELECT preflabel_fi
            FROM code_lists.spatial_plan_lifecycle_status
            WHERE codevalue = OLD.lifecycle_status
          );
          valid_statuses := (
            SELECT string_agg(preflabel_fi, ', ')
            FROM code_lists.spatial_plan_lifecycle_status
            WHERE codevalue IN ('07', '08', '10', '11', '13')
          );
          RAISE EXCEPTION 'Invalid status transition. Valid transitions from % are %', old_status, valid_statuses;
        END IF;
      WHEN '10' THEN
        IF NEW.lifecycle_status NOT IN ('12') THEN
          old_status := (
            SELECT preflabel_fi
            FROM code_lists.spatial_plan_lifecycle_status
            WHERE codevalue = OLD.lifecycle_status
          );
          valid_statuses := (
            SELECT string_agg(preflabel_fi, ', ')
            FROM code_lists.spatial_plan_lifecycle_status
            WHERE codevalue IN ('12')
          );
          RAISE EXCEPTION 'Invalid status transition. Valid transitions from % are %', old_status, valid_statuses;
        END IF;
      WHEN '11' THEN
        IF NEW.lifecycle_status NOT IN ('12') THEN
          old_status := (
            SELECT preflabel_fi
            FROM code_lists.spatial_plan_lifecycle_status
            WHERE codevalue = OLD.lifecycle_status
          );
          valid_statuses := (
            SELECT string_agg(preflabel_fi, ', ')
            FROM code_lists.spatial_plan_lifecycle_status
            WHERE codevalue IN ('12')
          );
          RAISE EXCEPTION 'Invalid status transition. Valid transitions from % are %', old_status, valid_statuses;
        END IF;
      ELSE
        old_status := (
          SELECT preflabel_fi
          FROM code_lists.spatial_plan_lifecycle_status
          WHERE codevalue = OLD.lifecycle_status
          );
        RAISE EXCEPTION 'Invalid status transition. Status cannot change from %', old_status;
    END CASE;
  END IF;

  IF NEW.lifecycle_status = '06' AND NEW.initiation_time IS NULL THEN
    RAISE EXCEPTION 'Initiation time is not set';
  ELSIF NEW.lifecycle_status = '06' AND NEW.approval_time IS NULL THEN
    RAISE EXCEPTION 'Approval time is not set';
  ELSIF NEW.lifecycle_status IN ('10', '11') AND NEW.validity_time.lower IS NULL THEN
    RAISE EXCEPTION 'Valid from is not set';
  ELSIF NEW.lifecycle_status IN ('12') AND NEW.validity_time.upper IS NULL THEN
    RAISE EXCEPTION 'Valid to is not set';
  END IF;
END;
$BODY$;

-- FUNCTION: SCHEMANAME.validate_planned_space_geom()

-- DROP FUNCTION IF EXISTS SCHEMANAME.validate_planned_space_geom();

CREATE OR REPLACE FUNCTION SCHEMANAME.validate_planned_space_geom()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
BEGIN
    IF (NEW.is_active = FALSE) THEN
        RETURN NEW;
    END IF;
    IF EXISTS (
        SELECT 1
        FROM SCHEMANAME.spatial_plan sp
        WHERE sp.is_active
            AND ST_Overlaps(sp.geom, ST_Buffer(NEW.geom, -0.1))
    ) THEN
        RAISE EXCEPTION 'Planned space geometry with identifier % is not contained in spatial plan', NEW.identifier;
    END IF;
    RETURN NEW;
END;
$BODY$;

-- FUNCTION: SCHEMANAME.validate_spatial_plan_topology()

-- DROP FUNCTION IF EXISTS SCHEMANAME.validate_spatial_plan_topology();

CREATE OR REPLACE FUNCTION SCHEMANAME.validate_spatial_plan_topology()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
BEGIN
    IF (NEW.is_active = FALSE) THEN
        RETURN NEW;
    END IF;
    IF EXISTS (
        SELECT 1
        FROM SCHEMANAME.spatial_plan AS sp
        WHERE sp.is_active
            AND sp.identifier <> new.identifier
            AND sp.geom && NEW.geom
            AND NOT ST_Relate(ST_Buffer(sp.geom, -0.1), ST_Buffer(NEW.geom, -0.1), 'FF*******')
    ) THEN
    RAISE EXCEPTION 'New % geometry with id % overlaps with existing spatial plan geometry', TG_TABLE_NAME, NEW.identifier;
    END IF;
  RETURN NEW;
END;
$BODY$;

-- FUNCTION: SCHEMANAME.validate_zoning_element_topology()

-- DROP FUNCTION IF EXISTS SCHEMANAME.validate_zoning_element_topology();

CREATE OR REPLACE FUNCTION SCHEMANAME.validate_zoning_element_topology()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
BEGIN
    IF (NEW.is_active = FALSE) THEN
        RETURN NEW;
    END IF;
    IF EXISTS (
        SELECT 1
        FROM SCHEMANAME.zoning_element AS ze
        WHERE ze.is_active
            AND ze.identifier <> new.identifier
            AND ze.geom && NEW.geom
            AND NOT ST_Relate(ST_Buffer(ze.geom, -0.1), ST_Buffer(NEW.geom, -0,1), 'FF*******')
    ) THEN
        RAISE EXCEPTION 'New zoning_element geometry with id % overlaps with existing zoning element geometry', NEW.identifier;
    END IF;
    -- Zoning element geometry must not overlap with spatial plan geometry
    IF EXISTS (
        SELECT 1 FROM SCHEMANAME.spatial_plan sp
        WHERE sp.is_active
            AND ST_Overlaps(sp.geom, ST_Buffer(NEW.geom, -0.1))
    ) THEN
        RAISE EXCEPTION 'Zoning element geometry with identifier % is not contained in spatial plan', NEW.identifier;
    END IF;
    RETURN NEW;
END;
$BODY$;

-- FUNCTION: SCHEMANAME.validity_to_daterange()

-- DROP FUNCTION IF EXISTS SCHEMANAME.validity_to_daterange();

CREATE OR REPLACE FUNCTION SCHEMANAME.validity_to_daterange()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
BEGIN
  IF NEW.validity_time IS NOT NULL AND NEW.validity_time <> OLD.validity_time THEN
    RAISE EXCEPTION 'Cannot change validity_time';
  END IF;
  IF NEW.valid_from IS NULL THEN
    IF NEW.valid_to IS NOT NULL THEN
      RAISE EXCEPTION 'valid_from cannot be NULL if valid_to is not NULL';
    END IF;
    NEW.validity_time = NULL;
    RETURN NEW;
  END IF;
  NEW.validity_time = DATERANGE(NEW.valid_from, NEW.valid_to, '[]');
  RETURN NEW;
END;
$BODY$;

