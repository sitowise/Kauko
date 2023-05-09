CREATE OR REPLACE FUNCTION SCHEMANAME.refresh_validity()
 RETURNS void
 LANGUAGE plpgsql
AS $function$
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
      AND sp.lifecycle_status IN ('01', '02', '03', '04', '05', '15');

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
  WHERE ps.local_id = ze_ps.planned_space_local_id
      AND ze.lifecycle_status IN ('01', '02', '03', '04', '05', '15');

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
  WHERE pdl.local_id = ze_pdl.planning_detail_line_local_id
    AND ze.lifecycle_status IN ('01', '02', '03', '04', '05', '15');

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
  WHERE dl.identifier = ze_dl.describing_line_id;

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
  WHERE dt.identifier = ze_dt.describing_text_id;

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
$function$
;
