ALTER TABLE SCHEMANAME.spatial_plan
ADD COLUMN is_released BOOLEAN NOT NULL DEFAULT FALSE;

CREATE OR REPLACE FUNCTION SCHEMANAME.refresh_validity()
    RETURNS void
    LANGUAGE 'sql'
    VOLATILE
    PARALLEL UNSAFE
    COST 100
    
AS $BODY$
UPDATE SCHEMANAME.spatial_plan sp
SET validity = 1, is_released = TRUE
WHERE sp.validity = 4
  AND sp.valid_from <= Current_Date
  AND (sp.valid_to IS NULL OR sp.valid_to >= Current_Date);

UPDATE SCHEMANAME.spatial_plan sp
SET validity = 3
WHERE sp.validity <> 3
  AND sp.valid_to < Current_Date;

UPDATE SCHEMANAME.zoning_element ze
SET validity = 1
WHERE ze.validity = 4
  AND ze.valid_from <= Current_Date
  AND (ze.valid_to IS NULL OR ze.valid_to >= Current_Date);

UPDATE SCHEMANAME.zoning_element ze
SET validity   = 1,
    valid_from = sp.valid_from,
    valid_to   = sp.valid_to
FROM SCHEMANAME.spatial_plan sp
WHERE sp.planning_object_identifier = ze.fk_spatial_plan
  AND ze.validity = 4
  AND (ze.valid_from IS NULL OR ze.valid_from <= sp.valid_from)
  AND (ze.valid_to IS NULL OR ze.valid_to >= sp.valid_to)
  AND sp.validity = 1;

UPDATE SCHEMANAME.zoning_element ze
SET validity = 3
WHERE ze.validity <> 3
  AND ze.valid_to < Current_Date;

UPDATE SCHEMANAME.zoning_element ze
SET validity = 3,
    valid_to = sp.valid_to
FROM SCHEMANAME.spatial_plan sp
WHERE sp.planning_object_identifier = ze.fk_spatial_plan
  AND ze.validity <> 3
  AND sp.validity = 3;

UPDATE SCHEMANAME.planned_space ps
SET validity = 1
WHERE ps.validity = 4
  AND ps.valid_from <= Current_Date
  AND (ps.valid_to IS NULL OR ps.valid_to >= Current_Date);

UPDATE SCHEMANAME.planned_space ps
SET validity   = 1,
    valid_from = ze.valid_from,
    valid_to   = ze.valid_to
FROM SCHEMANAME.zoning_element ze,
     SCHEMANAME.zoning_element_planned_space ze_ps
WHERE ps.planning_object_identifier = ze_ps.planned_space_id
  AND ze_ps.zoning_element_id = ze.planning_object_identifier
  AND ps.validity = 4
  AND ze.validity = 1
  AND ps.valid_from IS NULL
  AND ps.valid_to IS NULL;

UPDATE SCHEMANAME.planned_space ps
SET validity = 3
WHERE ps.validity <> 3
  AND ps.valid_to < Current_Date;

UPDATE SCHEMANAME.planned_space ps
SET validity = 3,
    valid_to = ze.valid_to
FROM SCHEMANAME.zoning_element ze,
     SCHEMANAME.zoning_element_planned_space ze_ps
WHERE ps.planning_object_identifier = ze_ps.planned_space_id
  AND ze_ps.zoning_element_id = ze.planning_object_identifier
  AND NOT Exists(SELECT *
                 FROM SCHEMANAME.zoning_element ze
                          INNER JOIN
                      SCHEMANAME.zoning_element_planned_space ze_ps
                      ON ze_ps.zoning_element_id = ze.planning_object_identifier
                 WHERE ze.validity <> 3
                   AND ze_ps.planned_space_id = ps.planning_object_identifier)
  AND ps.validity <> 3;

UPDATE SCHEMANAME.planning_detail_line pdl
SET validity = 1
FROM SCHEMANAME.zoning_element ze,
     SCHEMANAME.zoning_element_plan_detail_line ze_pdl
WHERE ze_pdl.zoning_id = ze.planning_object_identifier
  AND pdl.planning_object_identifier = ze_pdl.plan_detail_line_id
  AND pdl.validity = 4
  AND ze.validity = 1;

UPDATE SCHEMANAME.planning_detail_line pdl
SET validity = 3
FROM SCHEMANAME.zoning_element ze,
     SCHEMANAME.zoning_element_plan_detail_line ze_pdl
WHERE pdl.planning_object_identifier = ze_pdl.plan_detail_line_id
  AND ze_pdl.zoning_id = ze.planning_object_identifier
  AND pdl.validity <> 3
  AND ze.validity = 3;

UPDATE SCHEMANAME.planning_detail_point pdp
SET validity = 1
FROM SCHEMANAME.zoning_element ze,
     SCHEMANAME.zoning_element_plan_detail_point ze_pdp
WHERE pdp.planning_object_identifier = ze_pdp.plan_detail_point_id
  AND ze_pdp.zoning_id = ze.planning_object_identifier
  AND pdp.validity = 4
  AND ze.validity = 1;

UPDATE SCHEMANAME.planning_detail_point pdp
SET validity = 3
FROM SCHEMANAME.zoning_element ze,
     SCHEMANAME.zoning_element_plan_detail_point ze_pdp
WHERE pdp.planning_object_identifier = ze_pdp.plan_detail_point_id
  AND ze_pdp.zoning_id = ze.planning_object_identifier
  AND pdp.validity <> 3
  AND ze.validity = 3;

UPDATE SCHEMANAME.describing_line dl
SET validity = 1
FROM SCHEMANAME.zoning_element ze,
     SCHEMANAME.zoning_element_describing_line ze_dl
WHERE dl.identifier = ze_dl.describing_line_id
  AND ze_dl.zoning_id = ze.planning_object_identifier
  AND dl.validity = 4
  AND ze.validity = 1;

UPDATE SCHEMANAME.describing_line dl
SET validity = 3
FROM SCHEMANAME.zoning_element ze,
     SCHEMANAME.zoning_element_describing_line ze_dl
WHERE dl.identifier = ze_dl.describing_line_id
  AND ze_dl.zoning_id = ze.planning_object_identifier
  AND dl.validity <> 3
  AND ze.validity = 3;

UPDATE SCHEMANAME.describing_text dt
SET validity = 1
FROM SCHEMANAME.zoning_element ze,
     SCHEMANAME.zoning_element_describing_text ze_dt
WHERE dt.identifier = ze_dt.describing_text_id
  AND ze_dt.zoning_id = ze.planning_object_identifier
  AND dt.validity = 4
  AND ze.validity = 1;

UPDATE SCHEMANAME.describing_text dt
SET validity = 3
FROM SCHEMANAME.zoning_element ze,
     SCHEMANAME.zoning_element_describing_text ze_dt
WHERE dt.identifier = ze_dt.describing_text_id
  AND ze_dt.zoning_id = ze.planning_object_identifier
  AND dt.validity <> 3
  AND ze.validity = 3;

WITH RECURSIVE valid_spatial_plans(planning_object_identifier) AS (
    SELECT sp.planning_object_identifier
    FROM SCHEMANAME.spatial_plan sp
             INNER JOIN
         SCHEMANAME.zoning_element ze ON ze.fk_spatial_plan = sp.planning_object_identifier
    WHERE ze.validity = 1
      AND sp.validity <> 1
        EXCEPT
    SELECT SCHEMANAME.spatial_plan.planning_object_identifier
    FROM SCHEMANAME.spatial_plan
             INNER JOIN
         SCHEMANAME.zoning_element ON SCHEMANAME.zoning_element.fk_spatial_plan =
                                     SCHEMANAME.spatial_plan.planning_object_identifier
    WHERE SCHEMANAME.zoning_element.validity <> 1
)
UPDATE SCHEMANAME.spatial_plan sp
SET validity = 1
FROM valid_spatial_plans
WHERE sp.planning_object_identifier = valid_spatial_plans.planning_object_identifier;

UPDATE SCHEMANAME.spatial_plan sp
SET validity = 2
FROM SCHEMANAME.zoning_element ze
WHERE sp.planning_object_identifier = ze.fk_spatial_plan
  AND ze.validity <> 1
  AND sp.validity = 1;
$BODY$;

DO $$ 
BEGIN
    PERFORM SCHEMANAME.refresh_validity();
END $$;

