ALTER TABLE SCHEMANAME.spatial_plan
  DROP COLUMN validity;

DO $$
LANGUAGE plpgsql
DECLARE
    table_name text;
BEGIN
    SET session_replication_role = replica;
    FOR table_name IN ('zoning_element', 'planned_space', 'planning_detail_line', 'describing_line', 'describing_text')
    LOOP
        EXECUTE format('ALTER TABLE SCHEMANAME.%I
                          ADD COLUMN lifecycle_status VARCHAR(3);',
                      table_name);
        EXECUTE format('ALTER TABLE SCHEMANAME.%I
                          ADD CONSTRAINT %1$I_lifecycle_status_fkey
                          FOREIGN KEY (lifecycle_status)
                          REFERENCES code_lists.spatial_plan_lifecycle_status (code_value);',
                      table_name);
        EXECUTE format('UPDATE SCHEMANAME.%I
                          SET lifecycle_status =
                            CASE
                              WHEN validity = 1 THEN ''11''
                              WHEN validity = 2 THEN ''10''
                              WHEN validity = 3 THEN ''12''
                              WHEN validity = 4 THEN ''01''
                            END;',
                      table_name);
        EXECUTE format('ALTER TABLE SCHEMANAME.%I
                          DROP COLUMN validity,
                          ALTER COLUMN lifecycle_status SET NOT NULL;',
                      table_name);
    END LOOP;
    SET session_replication_role = DEFAULT;
END $$ DISABLE TRIGGER ALL;

CREATE OR REPLACE FUNCTION SCHEMANAME.update_validity()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
  PERFORM SCHEMANAME.refresh_validity();

  CREATE TEMPORARY TABLE temp_spatial_plan AS (
      SELECT
        sp.local_id,
        sp.geom,
        sp.lifecycle_status,
        sp.validity_time
      FROM SCHEMANAME.spatial_plan sp
      WHERE sp.validity_time IS NOT NULL
          AND sp.lifecycle_status NOT IN ('12', '13')
          AND (UPPER(sp.validity_time) IS NULL OR UPPER(sp.validity_time) >= CURRENT_DATE)
  );

  WITH spatial_plan_valid_from AS (
      SELECT
        MAX(tsp.valid_from) AS max_valid_from,
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
      AND sp.lifecycle_status NOT IN ('12', '13', '14', '15')
      AND (sp.valid_to IS NULL OR sp.valid_to >= CURRENT_DATE)
      AND ST_Within(
        sp.geom,
        ST_Buffer(
          (SELECT
            ST_Union(tsp.geom)
          FROM temp_spatial_plan tsp
          WHERE tsp.local_id <> sp.local_id
          AND tsp.valid_from > sp.valid_from),
          0.1));

  UPDATE SCHEMANAME.spatial_plan sp
  SET lifecycle_status = '10'
  WHERE sp.lifecycle_status = '11'
    AND (sp.valid_to IS NULL OR sp.valid_to >= CURRENT_DATE)
    AND ST_Overlaps(
      sp.geom,
      ST_Buffer(
        (SELECT ST_Union(tsp.geom)
        FROM temp_spatial_plan tsp
        WHERE 
          tsp.local_id <> sp.local_id
          AND tsp.valid_from > sp.valid_from
          AND tsp.lifecycle_status = '11'),
          0.1)
      );

  DROP TABLE temp_spatial_plan;


  CREATE TEMPORARY TABLE temp_zoning_element AS
  SELECT
    ze.local_id AS local_id,
    ze.geom AS geom,
    ze.valid_from AS valid_from,
    ze.lifecycle_status AS lifecycle_status,
    ze.spatial_plan AS spatial_plan
  FROM SCHEMANAME.zoning_element ze
  WHERE ze.valid_from IS NOT NULL
    AND ze.validity NOT IN ('07', '09', '12', '13', '14', '15')
    AND (ze.valid_to IS NULL OR ze.valid_to >= Current_Date);

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
    AND ze.lifecycle_status NOT IN ('12', '13', '14', '15')
    AND (ze.valid_to IS NULL OR
      ze.valid_to >= Current_Date)
    AND st_within(
      ze.geom,
      ST_Buffer(
        (
          SELECT ST_Union(tze.geom)
          FROM temp_zoning_element tze
          WHERE tze.local_id <> ze.local_id
            AND tze.valid_from > ze.valid_from),
        0.1
      ));

  UPDATE SCHEMANAME.zoning_element ze
  SET lifecycle_status = '10'
  WHERE ze.lifecycle_status = '11'
    AND (ze.valid_to IS NULL OR
        ze.valid_to >= Current_Date)
    AND ST_Overlaps(
      ze.geom,
      ST_Buffer(
        (
          SELECT ST_Union(tze.geom)
          FROM temp_zoning_element tze
          WHERE tze.local_id <> ze.local_id
            AND tze.spatial_plan <> ze.spatial_plan
            AND tze.valid_from > ze.valid_from
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
            WHERE ze.valid_from IS NOT NULL
              AND ze.lifecycle_status NOT IN ('12', '13', '14', '15')
              AND (ze.valid_to IS NULL OR ze.valid_to >= Current_Date)
            EXCEPT
            SELECT ze_ps.zoning_element_local_id
            FROM SCHEMANAME.zoning_element_planned_space ze_ps
            WHERE ze_ps.planned_space_local_id = ps.local_id
        )
          SELECT ST_Union(ze.geom)
          FROM SCHEMANAME.zoning_element ze,
                zoning_elements zes
          WHERE ze.local_id = zes.local_id),
        0.1)
      )
      AND ps.lifecycle_status NOT IN ('12', '13', '14', '15');

    UPDATE SCHEMANAME.planned_space ps
    SET lifecycle_status = '10'
    WHERE ST_Overlaps(
      ps.geom,
      ST_Buffer(
      (WITH RECURSIVE zoning_elements(local_id) AS (
        SELECT ze.local_id
        FROM SCHEMANAME.zoning_element ze
        WHERE ze.valid_from IS NOT NULL
          AND ze.lifecycle_status = '11'
          AND (ze.valid_to IS NULL OR ze.valid_to >= Current_Date)
            EXCEPT
        SELECT ze_ps.zoning_element_local_id
        FROM SCHEMANAME.zoning_element_planned_space ze_ps
        WHERE ze_ps.planned_space_local_id = ps.local_id
      )
        SELECT ST_Union(ze.geom)
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
        WHERE ze.valid_from IS NOT NULL
          AND ze.lifecycle_status NOT IN ('12', '13', '14', '15')
          AND (ze.valid_to IS NULL OR ze.valid_to >= Current_Date)
            EXCEPT
        SELECT ze_pdl.zoning_element_local_id
        FROM SCHEMANAME.zoning_element_plan_detail_line ze_pdl
        WHERE ze_pdl.planning_detail_line_local_id = pdl.local_id
      )
        SELECT ST_Union(ze.geom)
        FROM SCHEMANAME.zoning_element ze,
              zoning_elements zes
        WHERE ze.local_id = zes.local_id
      ),
        0.1)
      )
      AND pdl.lifecycle_status NOT IN ('12', '13', '14', '15');

    UPDATE SCHEMANAME.planning_detail_line pdl
    SET lifecycle_status = '10'
    WHERE ST_Crosses(
      pdl.geom,
      ST_Buffer(
      (WITH RECURSIVE zoning_elements(local_id) AS (
        SELECT ze.local_id
        FROM SCHEMANAME.zoning_element ze
        WHERE ze.valid_from IS NOT NULL
          AND ze.lifecycle_status = '11'
          AND (ze.valid_to IS NULL OR ze.valid_to >= Current_Date)
        EXCEPT
        SELECT ze_pdl.zoning_element_local_id
        FROM SCHEMANAME.zoning_element_plan_detail_line ze_pdl
        WHERE ze_pdl.planning_detail_line_local_id = pdl.local_id
      )
        SELECT ST_Union(ze.geom)
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
        WHERE ze.valid_from IS NOT NULL
          AND ze.lifecycle_status <> '12'
          AND (ze.valid_to IS NULL OR ze.valid_to >= Current_Date)
            EXCEPT
        SELECT ze_dl.zoning_element_local_id
        FROM SCHEMANAME.zoning_element_describing_line ze_dl
        WHERE ze_dl.describing_line_id = dl.identifier
      )
        SELECT ST_Union(ze.geom)
        FROM SCHEMANAME.zoning_element ze,
              zoning_elements zes
        WHERE ze.local_id = zes.local_id
      ),
      0.1))
      AND dl.lifecycle_status <> '12';

    UPDATE SCHEMANAME.describing_line dl
    SET lifecycle_status = '10'
    WHERE ST_Crosses(
      dl.geom,
      ST_Buffer(
      (WITH RECURSIVE zoning_elements(local_id) AS (
        SELECT ze.local_id
        FROM SCHEMANAME.zoning_element ze
        WHERE ze.valid_from IS NOT NULL
          AND ze.lifecycle_status = '11'
          AND (ze.valid_to IS NULL OR ze.valid_to >= Current_Date)
        EXCEPT
        SELECT ze_dl.zoning_element_local_id
        FROM SCHEMANAME.zoning_element_describing_line ze_dl
        WHERE ze_dl.describing_line_id = dl.identifier
      )
        SELECT ST_Union(ze.geom)
        FROM SCHEMANAME.zoning_element ze,
              zoning_elements zes
        WHERE ze.local_id = zes.local_id
      ),
      0.1))
      AND dl.lifecycle_status = '11';


    UPDATE SCHEMANAME.describing_text dt
    SET validity = '12'
    WHERE ST_Within(
      dt.geom,
      ST_Buffer(
      (WITH RECURSIVE zoning_elements(local_id) AS (
        SELECT ze.local_id
        FROM SCHEMANAME.zoning_element ze
        WHERE ze.valid_from IS NOT NULL
          AND ze.lifecycle_status NOT IN ('12', '13', '14', '15')
          AND (ze.valid_to IS NULL OR ze.valid_to >= Current_Date)
        EXCEPT
        SELECT ze_dt.zoning_element_local_id
        FROM SCHEMANAME.zoning_element_describing_text ze_dt
        WHERE ze_dt.describing_text_id = dt.identifier
      )
        SELECT ST_Union(ze.geom)
        FROM SCHEMANAME.zoning_element ze,
              zoning_elements zes
        WHERE ze.local_id = zes.local_id
      ),
      0.1))
      AND dt.lifecycle_status <> '12';

    PERFORM SCHEMANAME.refresh_validity();
    RETURN NULL;
END;
$function$;

CREATE OR REPLACE FUNCTION "SCHEMANAME".refresh_validity()
    RETURNS void
    LANGUAGE plpgsql
AS $BODY$
BEGIN
  UPDATE SCHEMANAME.spatial_plan sp
  SET lifecycle_status = '06'
  WHERE sp.lifecycle_status IN ('01', '02', '03', '04', '05')
    AND sp.approval_time >= Current_Date;

  UPDATE SCHEMANAME.spatial_plan sp
  SET lifecycle_status = '11'
  WHERE sp.lifecycle_status IN ('06', '07', '08')
    AND sp.validity_time @> Current_Date;

  UPDATE SCHEMANAME.spatial_plan sp
  SET lifecycle_status = '12'
  WHERE sp.lifecycle_status IN ('10', '11')
    AND upper(sp.validity_time) < Current_Date;

  UPDATE SCHEMANAME.zoning_element ze
  SET lifecycle_status = '11'
  WHERE ze.lifecycle_status IN ('06', '07', '08')
    AND ze.validity_time @> Current_Date;

  UPDATE SCHEMANAME.zoning_element ze
  SET
    lifecycle_status = '11',
    valid_from = GREATEST(ze.valid_from, sp.valid_from),
    valid_to = LEAST(ze.valid_to, sp.valid_to)
  FROM SCHEMANAME.spatial_plan sp
  WHERE sp.local_id = ze.spatial_plan
    AND ze.lifecycle_status IN ('06', '07', '08')
    AND sp.lifecycle_status = '11';

  UPDATE SCHEMANAME.zoning_element ze
  SET lifecycle_status = '12'
  WHERE ze.lifecycle_status IN ('10', '11')
    AND upper(ze.validity_time) < Current_Date;

  UPDATE SCHEMANAME.zoning_element ze
  SET lifecycle_status = '12',
      valid_to = sp.valid_to
  FROM SCHEMANAME.spatial_plan sp
  WHERE sp.local_id = ze.spatial_plan
    AND ze.lifecycle_status IN ('10', '11')
    AND sp.lifecycle_status = '12';

  UPDATE SCHEMANAME.planned_space ps
  SET lifecycle_status = '11'
  WHERE ps.lifecycle_status IN ('06', '07', '08')
    AND ps.validity_time @> Current_Date;

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
    AND ps.lifecycle_status IN ('06', '07', '08');

  UPDATE SCHEMANAME.planned_space ps
  SET lifecycle_status = '12'
  WHERE ps.lifecycle_status IN ('10', '11')
    AND upper(ps.validity_time) < Current_Date;

  UPDATE SCHEMANAME.planned_space ps
  SET lifecycle_status = '12',
      valid_to = ze.valid_to
  FROM SCHEMANAME.zoning_element ze
  JOIN SCHEMANAME.zoning_element_planned_space ze_ps
    ON ze_ps.zoning_element_local_id = ze.local_id
    AND ze.lifecycle_status = '12'
  WHERE ps.local_id = ze_ps.planned_space_local_id
    AND ps.validity IN ('10', '11');

  UPDATE SCHEMANAME.planning_detail_line pdl
  SET lifecycle_status = '11'
  FROM SCHEMANAME.zoning_element ze
  JOIN SCHEMANAME.zoning_element_plan_detail_line ze_pdl
    ON ze_pdl.zoning_element_local_id = ze.local_id
    AND ze.lifecycle_status = '11'
  WHERE pdl.local_id = ze_pdl.planning_detail_line_local_id
    AND pdl.lifecycle_status IN ('06', '07', '08');

  UPDATE SCHEMANAME.planning_detail_line pdl
  SET lifecycle_status = '12'
  FROM SCHEMANAME.zoning_element ze
  JOIN SCHEMANAME.zoning_element_plan_detail_line ze_pdl
    ON ze_pdl.zoning_element_local_id = ze.local_id
    AND ze.lifecycle_status = '12'
  WHERE pdl.local_id = ze_pdl.planning_detail_line_local_id
    AND pdl.lifecycle_status IN ('10', '11');

  UPDATE SCHEMANAME.describing_line dl
  SET lifecycle_status = '11'
  FROM SCHEMANAME.zoning_element ze
  JOIN SCHEMANAME.zoning_element_describing_line ze_dl
    ON ze_dl.zoning_element_local_id = ze.local_id
    AND ze.lifecycle_status = '11'
  WHERE dl.identifier = ze_dl.describing_line_id
    AND dl.lifecycle_status IN ('06', '07', '08');

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
    AND dt.lifecycle_status IN ('06', '07', '08');

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

  UPDATE SCHEMANAME.spatial_plan sp
  SET lifecycle_status = '10'
  FROM SCHEMANAME.zoning_element ze
  WHERE sp.local_id = ze.spatial_plan
    AND ze.lifecycle_status <> ('06', '07', '08', '10', '12')
    AND sp.lifecycle_status = '11';
END;
$BODY$;