CREATE OR REPLACE FUNCTION SCHEMANAME.upsert_creator_and_modifier_trigger()
RETURNS trigger
AS $$
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
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION SCHEMANAME.geom_relations()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE
  table_name TEXT;
BEGIN
  table_name := TG_TABLE_NAME;
  IF table_name IN ('spatial_plan', 'zoning_element') THEN
    UPDATE SCHEMANAME.zoning_element ze
    SET spatial_plan = sp.local_id
    FROM SCHEMANAME.spatial_plan sp
    WHERE st_contains(st_buffer(sp.geom, 1), ze.geom)
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
    WHERE ze.lifecycle_status IN ('01', '02', '03', '04', '05')
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
    WHERE ze.lifecycle_status IN ('01', '02', '03', '04', '05')
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
      WHERE ze.lifecycle_status IN ('01', '02', '03', '04', '05')
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
        WHERE ze.lifecycle_status IN ('01', '02', '03', '04', '05')
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
        WHERE ps.lifecycle_status IN ('01', '02', '03', '04', '05')
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
$function$;

CREATE OR REPLACE FUNCTION SCHEMANAME.update_validity()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
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
$function$;

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
  SET lifecycle_status = '15'
  FROM SCHEMANAME.spatial_plan sp
  WHERE sp.local_id = ze.spatial_plan
    AND sp.lifecycle_status = '15'
    AND ze.lifecycle_status = '01';

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
  SET lifecycle_status = '15'
  FROM SCHEMANAME.zoning_element ze
  JOIN SCHEMANAME.zoning_element_planned_space ze_ps
    ON ze_ps.zoning_element_local_id = ze.local_id
    AND ze.lifecycle_status = '15'
  WHERE ps.local_id = ze_ps.planned_space_local_id
    AND ps.lifecycle_status = '01';

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
  SET lifecycle_status = '15'
  FROM SCHEMANAME.zoning_element ze
  JOIN SCHEMANAME.zoning_element_plan_detail_line ze_pdl
    ON ze_pdl.zoning_element_local_id = ze.local_id
    AND ze.lifecycle_status = '15'
  WHERE pdl.local_id = ze_pdl.planning_detail_line_local_id
    AND pdl.lifecycle_status = '01';

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
  SET lifecycle_status = '15'
  FROM SCHEMANAME.zoning_element ze
  JOIN SCHEMANAME.zoning_element_describing_line ze_dl
    ON ze_dl.zoning_element_local_id = ze.local_id
    AND ze.lifecycle_status = '15'
  WHERE dl.identifier = ze_dl.describing_line_id
    AND dl.lifecycle_status = '01';

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
  SET lifecycle_status = '15'
  FROM SCHEMANAME.zoning_element ze
  JOIN SCHEMANAME.zoning_element_describing_text ze_dt
    ON ze_dt.zoning_element_local_id = ze.local_id
    AND ze.lifecycle_status = '15'
  WHERE dt.identifier = ze_dt.describing_text_id
    AND dt.lifecycle_status = '01';

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
$function$;

CREATE OR REPLACE FUNCTION SCHEMANAME.validate_geometry()
    RETURNS trigger
    LANGUAGE plpgsql
AS $function$
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
$function$;
