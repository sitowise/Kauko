-- FUNCTION: $SCHEMANAME$.get_valid_spatial_plan_area(text)

-- DROP FUNCTION IF EXISTS $SCHEMANAME$.get_valid_spatial_plan_area(text);

CREATE OR REPLACE FUNCTION $SCHEMANAME$.get_valid_spatial_plan_area(
	spatial_local_id text)
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
  RAISE NOTICE 'Calling get_valid_spatial_plan_area(%)', spatial_local_id;
  SELECT *
    INTO   _spatial_plan
    FROM   $SCHEMANAME$.spatial_plan
    WHERE  local_id = spatial_local_id
    LIMIT  1;
  IF _spatial_plan IS NULL THEN
    RAISE EXCEPTION 'Spatial plan with local_id % does not exist', spatial_local_id;
  END IF;
  IF _spatial_plan.lifecycle_status NOT IN ('8', '10', '11', '12', '13') THEN
    RAISE EXCEPTION 'Spatial plan with local_id % is not valid', spatial_local_id;
  END IF;
  IF _spatial_plan.lifecycle_status IN ('11', '12', '13') THEN
    RETURN _spatial_plan.geom;
  END IF;
  IF _spatial_plan.lifecycle_status = '8' THEN
    IF NOT EXISTS (
      SELECT 1
      FROM $SCHEMANAME$.zoning_element
      WHERE spatial_plan = spatial_local_id
        AND lifecycle_status IN ('10', '11', '12', '13')
    ) THEN
      RETURN NULL;
    END IF;
  END IF;

  -- get zoning element geometries
  SELECT
    $SCHEMANAME$.get_valid_zoning_element_area(ze.local_id)
  INTO
    _zoning_element_geoms
  FROM
    $SCHEMANAME$.zoning_element ze
  WHERE
    ze.spatial_plan = spatial_local_id
    AND ze.lifecycle_status IN ('10', '11', '12', '13')
    AND ze.validity_time @> CURRENT_DATE;

  -- compute the union of all zoning element geometries
  RETURN ST_Union(_zoning_element_geoms);
END;
$BODY$;

-- FUNCTION: $SCHEMANAME$.get_valid_zoning_element_area(text)

-- DROP FUNCTION IF EXISTS $SCHEMANAME$.get_valid_zoning_element_area(text);

CREATE OR REPLACE FUNCTION $SCHEMANAME$.get_valid_zoning_element_area(
	zoning_local_id text)
    RETURNS geometry
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE STRICT PARALLEL UNSAFE
AS $BODY$
DECLARE
  _local_id text;
  _geom geometry;
  _validity_time daterange;
  _lifecycle_status varchar;
  _spatial_plan text;
  zoning_element_geometry geometry;
BEGIN
  SELECT local_id, geom, validity_time, lifecycle_status, spatial_plan
  INTO _local_id, _geom, _validity_time, _lifecycle_status, _spatial_plan
  FROM $SCHEMANAME$.zoning_element
  WHERE local_id = zoning_local_id
  LIMIT 1;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Zoning element with local_id % does not exist', zoning_local_id;
  END IF;

  IF _lifecycle_status NOT IN ('10', '11', '12', '13') THEN
    RAISE EXCEPTION 'Zoning element with local_id % is not valid', zoning_local_id;
  END IF;

  IF _lifecycle_status IN ('11', '12', '13') THEN
    RETURN _geom;
  END IF;

  WITH valid_zoning_elements AS (
    SELECT geom
    FROM $SCHEMANAME$.zoning_element
    WHERE spatial_plan <> _spatial_plan
      AND lifecycle_status IN ('10', '11', '12', '13')
      AND validity_time &> _validity_time
      AND ST_Intersects(geom, _geom)
  )
  SELECT ST_Difference(_geom, ST_Union(valid_zoning_elements.geom))
  INTO zoning_element_geometry
  FROM valid_zoning_elements;

  RETURN zoning_element_geometry;
END;
$BODY$;

-- FUNCTION: $SCHEMANAME$.refresh_validity()

-- DROP FUNCTION IF EXISTS $SCHEMANAME$.refresh_validity();

CREATE OR REPLACE FUNCTION $SCHEMANAME$.update_validity()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
BEGIN
  PERFORM $SCHEMANAME$.refresh_validity();

  CREATE TEMPORARY TABLE temp_spatial_plan AS (
    WITH valid_geom AS (
      SELECT
        local_id,
        $SCHEMANAME$.get_valid_spatial_plan_area(local_id) AS geom
      FROM $SCHEMANAME$.spatial_plan sp
      WHERE sp.lifecycle_status IN ('8', '10', '11', '12', '13')
        AND sp.validity_time @> CURRENT_DATE
    )
    SELECT
      sp.local_id,
      vg.geom,
      sp.lifecycle_status,
      sp.validity_time
    FROM valid_geom vg
      JOIN $SCHEMANAME$.spatial_plan sp on sp.local_id = vg.local_id
    WHERE vg.geom IS NOT NULL
  );

  WITH spatial_plan_valid_from AS (
      SELECT
        MAX(lower(tsp.validity_time)) AS max_valid_from,
        sp.local_id
      FROM $SCHEMANAME$.spatial_plan sp
      JOIN temp_spatial_plan tsp ON
        sp.geom && tsp.geom
        AND NOT ST_Relate(
          ST_Buffer(sp.geom, -0.1),
          ST_Buffer(tsp.geom, 0.1),
          'FF*******'
        )
      GROUP BY sp.local_id
  )
  UPDATE $SCHEMANAME$.spatial_plan sp
  SET
    lifecycle_status = '14',
    valid_to = spvf.max_valid_from
  FROM spatial_plan_valid_from spvf
  WHERE sp.local_id = spvf.local_id
      AND sp.lifecycle_status IN ('10', '11', '12', '13')
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

  UPDATE $SCHEMANAME$.spatial_plan sp
  SET lifecycle_status = '10'
  WHERE sp.lifecycle_status in ('11', '12', '13')
    AND sp.validity_time @> CURRENT_DATE
    AND ST_Overlaps(
      sp.geom,
      ST_Buffer(
        (SELECT ST_Union(tsp.geom)
        FROM temp_spatial_plan tsp
        WHERE
          tsp.local_id <> sp.local_id
          AND tsp.validity_time &> sp.validity_time
          AND tsp.lifecycle_status IN ('10', '11', '12', '13')),
          0.1)
      );

  DROP TABLE temp_spatial_plan;

  CREATE TEMPORARY TABLE temp_zoning_element AS (
    WITH valid_zoning_elements AS (
      SELECT
        local_id,
        $SCHEMANAME$.get_valid_zoning_element_area(local_id) AS geom
      FROM $SCHEMANAME$.zoning_element
      WHERE lifecycle_status IN ('10', '11', '12', '13')
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
      JOIN $SCHEMANAME$.zoning_element ze ON ze.local_id = vze.local_id
    WHERE vze.geom IS NOT NULL
  );

  WITH zoning_element_valid_from AS (
    SELECT
      Max(tze.valid_from) AS max_valid_from,
      ze.local_id AS local_id
    FROM $SCHEMANAME$.zoning_element ze
    JOIN temp_zoning_element tze ON
      ze.geom && tze.geom
      AND NOT ST_Relate(
        ST_Buffer(ze.geom, -0.1),
        ST_Buffer(tze.geom, 0.1),
        'FF*******'
      )
    GROUP BY ze.local_id
  )
  UPDATE $SCHEMANAME$.zoning_element ze
  SET lifecycle_status = '14',
      valid_to = zevf.max_valid_from
  FROM zoning_element_valid_from zevf
  WHERE ze.local_id = zevf.local_id
    AND ze.lifecycle_status NOT IN ('10', '11', '12', '13')
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

  UPDATE $SCHEMANAME$.zoning_element ze
  SET lifecycle_status = '10'
  WHERE ze.lifecycle_status in ('11', '12', '13')
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
            AND tze.lifecycle_status in ('11', '12', '13')
        ), -0.1
      ));

  DROP TABLE temp_zoning_element;

  UPDATE $SCHEMANAME$.planned_space ps
    SET lifecycle_status = '14'
    WHERE
      ST_Within(
        ps.geom,
        ST_Buffer(
          (WITH RECURSIVE zoning_elements(local_id) AS (
            SELECT ze.local_id
            FROM $SCHEMANAME$.zoning_element ze
            WHERE ze.validity_time @> CURRENT_DATE
              AND ze.lifecycle_status NOT IN ('10', '11', '12', '13')
            EXCEPT
            SELECT ze_ps.zoning_element_local_id
            FROM $SCHEMANAME$.zoning_element_planned_space ze_ps
            WHERE ze_ps.planned_space_local_id = ps.local_id
        )
          SELECT ST_Union($SCHEMANAME$.get_valid_zoning_element_area(ze.local_id))
          FROM $SCHEMANAME$.zoning_element ze,
                zoning_elements zes
          WHERE ze.local_id = zes.local_id),
        0.1)
      )
      AND ps.lifecycle_status IN ('10', '11', '12', '13');

    UPDATE $SCHEMANAME$.planned_space ps
    SET lifecycle_status = '10'
    WHERE ST_Overlaps(
      ps.geom,
      ST_Buffer(
      (WITH RECURSIVE zoning_elements(local_id) AS (
        SELECT ze.local_id
        FROM $SCHEMANAME$.zoning_element ze
        WHERE ze.validity_time @> CURRENT_DATE
          AND ze.lifecycle_status in ('11', '12', '13')
            EXCEPT
        SELECT ze_ps.zoning_element_local_id
        FROM $SCHEMANAME$.zoning_element_planned_space ze_ps
        WHERE ze_ps.planned_space_local_id = ps.local_id
      )
        SELECT ST_Union($SCHEMANAME$.get_valid_zoning_element_area(ze.local_id))
        FROM $SCHEMANAME$.zoning_element ze,
              zoning_elements zes
        WHERE zes.local_id = ze.local_id
      ),
        0.1))
      AND ps.lifecycle_status in ('11', '12', '13');

-- ##########################

    UPDATE $SCHEMANAME$.planning_detail_line pdl
    SET lifecycle_status = '14'
    WHERE ST_Within(
      pdl.geom,
      ST_Buffer(
      (WITH RECURSIVE zoning_elements(local_id) AS (
        SELECT ze.local_id
        FROM $SCHEMANAME$.zoning_element ze
        WHERE ze.validity_time @> CURRENT_DATE
          AND ze.lifecycle_status NOT IN ('10', '11', '12', '13')
            EXCEPT
        SELECT ze_pdl.zoning_element_local_id
        FROM $SCHEMANAME$.zoning_element_plan_detail_line ze_pdl
        WHERE ze_pdl.planning_detail_line_local_id = pdl.local_id
      )
        SELECT ST_Union($SCHEMANAME$.get_valid_zoning_element_area(ze.local_id))
        FROM $SCHEMANAME$.zoning_element ze,
              zoning_elements zes
        WHERE ze.local_id = zes.local_id
      ),
        0.1)
      )
      AND pdl.lifecycle_status IN ('10', '11', '12', '13');

    UPDATE $SCHEMANAME$.planning_detail_line pdl
    SET lifecycle_status = '10'
    WHERE ST_Crosses(
      pdl.geom,
      ST_Buffer(
      (WITH RECURSIVE zoning_elements(local_id) AS (
        SELECT ze.local_id
        FROM $SCHEMANAME$.zoning_element ze
        WHERE ze.validity_time @> CURRENT_DATE
          AND ze.lifecycle_status in ('11', '12', '13')
        EXCEPT
        SELECT ze_pdl.zoning_element_local_id
        FROM $SCHEMANAME$.zoning_element_plan_detail_line ze_pdl
        WHERE ze_pdl.planning_detail_line_local_id = pdl.local_id
      )
        SELECT ST_Union($SCHEMANAME$.get_valid_zoning_element_area(ze.local_id))
        FROM $SCHEMANAME$.zoning_element ze,
              zoning_elements zes
        WHERE ze.local_id = zes.local_id
      ),
      0.1))
      AND pdl.lifecycle_status in ('11', '12', '13');

-- Update lifecycle_status to '12' for planning_detail_point
UPDATE $SCHEMANAME$.planning_detail_point pdp
SET lifecycle_status = '12'
WHERE ST_Within(
  pdp.geom,
  ST_Buffer(
    (WITH RECURSIVE zoning_elements(local_id) AS (
      SELECT ze.local_id
      FROM $SCHEMANAME$.zoning_element ze
      WHERE ze.validity_time @> CURRENT_DATE
        AND ze.lifecycle_status NOT IN ('10', '11', '12', '13')
      EXCEPT
      SELECT ze_pdp.zoning_element_local_id
      FROM $SCHEMANAME$.zoning_element_plan_detail_point ze_pdp
      WHERE ze_pdp.planning_detail_point_local_id = pdp.local_id
    )
    SELECT ST_Union($SCHEMANAME$.get_valid_zoning_element_area(ze.local_id))
    FROM $SCHEMANAME$.zoning_element ze,
          zoning_elements zes
    WHERE ze.local_id = zes.local_id),
    0.1)
  )
  AND pdp.lifecycle_status IN ('10', '11', '12', '13');

-- Update lifecycle_status to '10' for planning_detail_point
UPDATE $SCHEMANAME$.planning_detail_point pdp
SET lifecycle_status = '10'
WHERE ST_Crosses(
  pdp.geom,
  ST_Buffer(
    (WITH RECURSIVE zoning_elements(local_id) AS (
      SELECT ze.local_id
      FROM $SCHEMANAME$.zoning_element ze
      WHERE ze.validity_time @> CURRENT_DATE
        AND ze.lifecycle_status in ('11', '12', '13')
      EXCEPT
      SELECT ze_pdp.zoning_element_local_id
      FROM $SCHEMANAME$.zoning_element_plan_detail_point ze_pdp
      WHERE ze_pdp.planning_detail_point_local_id = pdp.local_id
    )
    SELECT ST_Union($SCHEMANAME$.get_valid_zoning_element_area(ze.local_id))
    FROM $SCHEMANAME$.zoning_element ze,
          zoning_elements zes
    WHERE ze.local_id = zes.local_id),
    0.1)
  )
  AND pdp.lifecycle_status in ('11', '12', '13');

-- ##########################

    UPDATE $SCHEMANAME$.describing_line dl
    SET lifecycle_status = '12'
    WHERE ST_Within(
      dl.geom,
      ST_Buffer(
      (WITH RECURSIVE zoning_elements(local_id) AS (
        SELECT ze.local_id
        FROM $SCHEMANAME$.zoning_element ze
        WHERE ze.validity_time @> CURRENT_DATE
          AND ze.lifecycle_status IN ('10', '11', '12', '13')
            EXCEPT
        SELECT ze_dl.zoning_element_local_id
        FROM $SCHEMANAME$.zoning_element_describing_line ze_dl
        WHERE ze_dl.describing_line_id = dl.id
      )
        SELECT ST_Union($SCHEMANAME$.get_valid_zoning_element_area(ze.local_id))
        FROM $SCHEMANAME$.zoning_element ze,
              zoning_elements zes
        WHERE ze.local_id = zes.local_id
      ),
      0.1))
      AND dl.lifecycle_status IN ('10', '11', '12', '13');

    UPDATE $SCHEMANAME$.describing_line dl
    SET lifecycle_status = '10'
    WHERE ST_Crosses(
      dl.geom,
      ST_Buffer(
      (WITH RECURSIVE zoning_elements(local_id) AS (
        SELECT ze.local_id
        FROM $SCHEMANAME$.zoning_element ze
        WHERE ze.validity_time @> CURRENT_DATE
          AND ze.lifecycle_status IN ('11', '12', '13')
        EXCEPT
        SELECT ze_dl.zoning_element_local_id
        FROM $SCHEMANAME$.zoning_element_describing_line ze_dl
        WHERE ze_dl.describing_line_id = dl.id
      )
        SELECT ST_Union($SCHEMANAME$.get_valid_zoning_element_area(ze.local_id))
        FROM $SCHEMANAME$.zoning_element ze,
              zoning_elements zes
        WHERE ze.local_id = zes.local_id
      ),
      0.1))
      AND dl.lifecycle_status IN ('11', '12', '13');

    UPDATE $SCHEMANAME$.describing_text dt
    SET lifecycle_status = '12'
    WHERE ST_Within(
      dt.geom,
      ST_Buffer(
      (WITH RECURSIVE zoning_elements(local_id) AS (
        SELECT ze.local_id
        FROM $SCHEMANAME$.zoning_element ze
        WHERE ze.validity_time @> CURRENT_DATE
          AND ze.lifecycle_status IN ('10', '11', '12', '13')
        EXCEPT
        SELECT ze_dt.zoning_element_local_id
        FROM $SCHEMANAME$.zoning_element_describing_text ze_dt
        WHERE ze_dt.describing_text_id = dt.id
      )
        SELECT ST_Union($SCHEMANAME$.get_valid_zoning_element_area(ze.local_id))
        FROM $SCHEMANAME$.zoning_element ze,
              zoning_elements zes
        WHERE ze.local_id = zes.local_id
      ),
      0.1))
      AND dt.lifecycle_status IN ('10', '11', '12', '13');

    PERFORM $SCHEMANAME$.refresh_validity();
    RETURN NULL;
END;
$BODY$;

-- FUNCTION: $SCHEMANAME$.refresh_validity()

-- DROP FUNCTION IF EXISTS $SCHEMANAME$.refresh_validity();

CREATE OR REPLACE FUNCTION $SCHEMANAME$.refresh_validity(
	)
    RETURNS void
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
BEGIN
  UPDATE $SCHEMANAME$.spatial_plan sp
  SET lifecycle_status = '06'
  WHERE sp.lifecycle_status IN ('01', '02', '03', '04', '05')
    AND sp.approval_time >= Current_Date;

  UPDATE $SCHEMANAME$.spatial_plan sp
  SET lifecycle_status = '13'
  WHERE sp.lifecycle_status = '06'
    AND sp.validity_time @> Current_Date;

  UPDATE $SCHEMANAME$.spatial_plan sp
  SET lifecycle_status = '10'
  WHERE sp.lifecycle_status = '08'
    AND sp.validity_time @> Current_Date;

  UPDATE $SCHEMANAME$.spatial_plan sp
  SET lifecycle_status = '14'
  WHERE sp.lifecycle_status IN ('10', '11', '12', '13')
    AND NOT sp.validity_time @> Current_Date;

  UPDATE $SCHEMANAME$.zoning_element ze
  SET lifecycle_status = '14'
  FROM $SCHEMANAME$.spatial_plan sp
  WHERE sp.local_id = ze.spatial_plan
    AND sp.lifecycle_status = '14'
    AND ze.lifecycle_status IN ('06', '07', '08', '09');

  UPDATE $SCHEMANAME$.zoning_element ze
  SET lifecycle_status = '17'
  FROM $SCHEMANAME$.spatial_plan sp
  WHERE sp.local_id = ze.spatial_plan
    AND sp.lifecycle_status = '17'
    AND ze.lifecycle_status IN ('02', '03', '04', '05');

  UPDATE $SCHEMANAME$.zoning_element ze
  SET lifecycle_status = sp.lifecycle_status
  FROM $SCHEMANAME$.spatial_plan sp
  WHERE sp.local_id = ze.spatial_plan
      AND sp.lifecycle_status IN ('01', '02', '03', '04', '05', '06', '17')
      AND ze.lifecycle_status <> sp.lifecycle_status;

  UPDATE $SCHEMANAME$.zoning_element ze
  SET lifecycle_status = '13'
  WHERE ze.lifecycle_status = '06'
    AND ze.validity_time @> Current_Date;

  UPDATE $SCHEMANAME$.zoning_element ze
  SET
    lifecycle_status = '13',
    valid_from = GREATEST(ze.valid_from, sp.valid_from),
    valid_to = LEAST(ze.valid_to, sp.valid_to)
  FROM $SCHEMANAME$.spatial_plan sp
  WHERE sp.local_id = ze.spatial_plan
    AND ze.lifecycle_status IN ('06', '07', '08', '09')
    AND sp.lifecycle_status = '13';

  UPDATE $SCHEMANAME$.zoning_element ze
  SET lifecycle_status = '14'
  WHERE ze.lifecycle_status IN ('10', '11', '12', '13')
    AND NOT ze.validity_time @> Current_Date;

  UPDATE $SCHEMANAME$.zoning_element ze
  SET lifecycle_status = '14',
      valid_to = sp.valid_to
  FROM $SCHEMANAME$.spatial_plan sp
  WHERE sp.local_id = ze.spatial_plan
    AND ze.lifecycle_status IN ('10', '11', '12', '13')
    AND sp.lifecycle_status = '14';

  UPDATE $SCHEMANAME$.planned_space ps
  SET lifecycle_status = '13'
  WHERE ps.lifecycle_status IN ('06', '07', '08', '09')
    AND ps.validity_time @> Current_Date;

  UPDATE $SCHEMANAME$.planned_space ps
  SET lifecycle_status = '14'
  FROM $SCHEMANAME$.zoning_element ze
  JOIN $SCHEMANAME$.zoning_element_planned_space ze_ps
    ON ze_ps.zoning_element_local_id = ze.local_id
    AND ze.lifecycle_status = '14'
  WHERE ps.local_id = ze_ps.planned_space_local_id
    AND ps.lifecycle_status IN ('06', '07', '08', '09');

  UPDATE $SCHEMANAME$.planned_space ps
  SET lifecycle_status = '17'
  FROM $SCHEMANAME$.zoning_element ze
  JOIN $SCHEMANAME$.zoning_element_planned_space ze_ps
    ON ze_ps.zoning_element_local_id = ze.local_id
    AND ze.lifecycle_status = '17'
  WHERE ps.local_id = ze_ps.planned_space_local_id
    AND ps.lifecycle_status IN ('02', '03', '04', '05');

  UPDATE $SCHEMANAME$.planned_space ps
  SET lifecycle_status = ze.lifecycle_status
  FROM $SCHEMANAME$.zoning_element ze
  JOIN $SCHEMANAME$.zoning_element_planned_space ze_ps
      ON ze_ps.zoning_element_local_id = ze.local_id
      AND ze.lifecycle_status IN ('01', '02', '03', '04', '05', '06', '17')
  WHERE ps.local_id = ze_ps.planned_space_local_id
      AND ps.lifecycle_status <> ze.lifecycle_status;

  UPDATE $SCHEMANAME$.planned_space ps
  SET
    lifecycle_status = '13',
    valid_from = GREATEST(ps.valid_from, ze.valid_from),
    valid_to = LEAST(ps.valid_from, ze.valid_from)
  FROM $SCHEMANAME$.zoning_element ze
  JOIN $SCHEMANAME$.zoning_element_planned_space ze_ps
    ON ze_ps.zoning_element_local_id = ze.local_id
    AND ze.lifecycle_status IN ('11', '12', '13')
  WHERE ps.local_id = ze_ps.planned_space_local_id
    AND ps.lifecycle_status IN ('06', '07', '08', '09');

  UPDATE $SCHEMANAME$.planned_space ps
  SET lifecycle_status = '14'
  WHERE ps.lifecycle_status IN ('10', '11', '12', '13')
    AND NOT upper_inf(ps.validity_time)
    AND upper(ps.validity_time) < Current_Date;

  UPDATE $SCHEMANAME$.planned_space ps
  SET lifecycle_status = '14',
      valid_to = ze.valid_to
  FROM $SCHEMANAME$.zoning_element ze
  JOIN $SCHEMANAME$.zoning_element_planned_space ze_ps
    ON ze_ps.zoning_element_local_id = ze.local_id
    AND ze.lifecycle_status = '14'
  WHERE ps.local_id = ze_ps.planned_space_local_id
    AND ps.lifecycle_status IN ('10', '11', '12', '13');

  UPDATE $SCHEMANAME$.planning_detail_line pdl
  SET lifecycle_status = '14'
  FROM $SCHEMANAME$.zoning_element ze
  JOIN $SCHEMANAME$.zoning_element_plan_detail_line ze_pdl
    ON ze_pdl.zoning_element_local_id = ze.local_id
    AND ze.lifecycle_status = '14'
  WHERE pdl.local_id = ze_pdl.planning_detail_line_local_id
    AND pdl.lifecycle_status IN ('06', '07', '08', '09');

  UPDATE $SCHEMANAME$.planning_detail_line pdl
  SET lifecycle_status = '17'
  FROM $SCHEMANAME$.zoning_element ze
  JOIN $SCHEMANAME$.zoning_element_plan_detail_line ze_pdl
    ON ze_pdl.zoning_element_local_id = ze.local_id
    AND ze.lifecycle_status = '17'
  WHERE pdl.local_id = ze_pdl.planning_detail_line_local_id
    AND pdl.lifecycle_status IN ('02', '03', '04', '05');

  UPDATE $SCHEMANAME$.planning_detail_line pdl
  SET lifecycle_status = ze.lifecycle_status
  FROM $SCHEMANAME$.zoning_element ze
  JOIN $SCHEMANAME$.zoning_element_plan_detail_line ze_pdl
    ON ze_pdl.zoning_element_local_id = ze.local_id
    AND ze.lifecycle_status IN ('01', '02', '03', '04', '05', '06', '17')
  WHERE pdl.local_id = ze_pdl.planning_detail_line_local_id
    AND pdl.lifecycle_status <> ze.lifecycle_status;

  UPDATE $SCHEMANAME$.planning_detail_line pdl
  SET lifecycle_status = '13'
  FROM $SCHEMANAME$.zoning_element ze
  JOIN $SCHEMANAME$.zoning_element_plan_detail_line ze_pdl
    ON ze_pdl.zoning_element_local_id = ze.local_id
    AND ze.lifecycle_status = '13'
  WHERE pdl.local_id = ze_pdl.planning_detail_line_local_id
    AND pdl.lifecycle_status IN ('06', '07', '08', '09');

  UPDATE $SCHEMANAME$.planning_detail_line pdl
  SET lifecycle_status = '14'
  FROM $SCHEMANAME$.zoning_element ze
  JOIN $SCHEMANAME$.zoning_element_plan_detail_line ze_pdl
    ON ze_pdl.zoning_element_local_id = ze.local_id
    AND ze.lifecycle_status = '14'
  WHERE pdl.local_id = ze_pdl.planning_detail_line_local_id
    AND pdl.lifecycle_status IN ('10', '11', '12', '13');

-- Update lifecycle_status to '13' for planning_detail_point
  UPDATE $SCHEMANAME$.planning_detail_point pdp
  SET lifecycle_status = '14'
  FROM $SCHEMANAME$.zoning_element ze
  JOIN $SCHEMANAME$.zoning_element_plan_detail_point ze_pdp
    ON ze_pdp.zoning_element_local_id = ze.local_id
    AND ze.lifecycle_status = '14'
  WHERE pdp.local_id = ze_pdp.planning_detail_point_local_id
    AND pdp.lifecycle_status IN ('06', '07', '08', '09');

-- Update lifecycle_status to '14' for planning_detail_point
  UPDATE $SCHEMANAME$.planning_detail_point pdp
  SET lifecycle_status = '17'
  FROM $SCHEMANAME$.zoning_element ze
  JOIN $SCHEMANAME$.zoning_element_plan_detail_point ze_pdp
    ON ze_pdp.zoning_element_local_id = ze.local_id
    AND ze.lifecycle_status = '17'
  WHERE pdp.local_id = ze_pdp.planning_detail_point_local_id
    AND pdp.lifecycle_status IN ('02', '03', '04', '05');

-- Update planning_detail_point lifecycle_status to match zoning_element
  UPDATE $SCHEMANAME$.planning_detail_point pdp
  SET lifecycle_status = ze.lifecycle_status
  FROM $SCHEMANAME$.zoning_element ze
  JOIN $SCHEMANAME$.zoning_element_plan_detail_point ze_pdp
    ON ze_pdp.zoning_element_local_id = ze.local_id
    AND ze.lifecycle_status IN ('01', '02', '03', '04', '05', '06', '17')
  WHERE pdp.local_id = ze_pdp.planning_detail_point_local_id
    AND pdp.lifecycle_status <> ze.lifecycle_status;

-- Update lifecycle_status to '11' for planning_detail_point
  UPDATE $SCHEMANAME$.planning_detail_point pdp
  SET lifecycle_status = '13'
  FROM $SCHEMANAME$.zoning_element ze
  JOIN $SCHEMANAME$.zoning_element_plan_detail_point ze_pdp
    ON ze_pdp.zoning_element_local_id = ze.local_id
    AND ze.lifecycle_status = '13'
  WHERE pdp.local_id = ze_pdp.planning_detail_point_local_id
    AND pdp.lifecycle_status IN ('06', '07', '08', '09');

-- Update lifecycle_status to '12' for planning_detail_point
  UPDATE $SCHEMANAME$.planning_detail_point pdp
  SET lifecycle_status = '14'
  FROM $SCHEMANAME$.zoning_element ze
  JOIN $SCHEMANAME$.zoning_element_plan_detail_point ze_pdp
    ON ze_pdp.zoning_element_local_id = ze.local_id
    AND ze.lifecycle_status = '14'
  WHERE pdp.local_id = ze_pdp.planning_detail_point_local_id
    AND pdp.lifecycle_status IN ('10', '11', '12', '13');


-- ##########################

  UPDATE $SCHEMANAME$.describing_line dl
  SET lifecycle_status = '14'
  FROM $SCHEMANAME$.zoning_element ze
  JOIN $SCHEMANAME$.zoning_element_describing_line ze_dl
    ON ze_dl.zoning_element_local_id = ze.local_id
    AND ze.lifecycle_status = '14'
  WHERE dl.id = ze_dl.describing_line_id
    AND dl.lifecycle_status IN ('06', '07', '08', '09');

  UPDATE $SCHEMANAME$.describing_line dl
  SET lifecycle_status = '17'
  FROM $SCHEMANAME$.zoning_element ze
  JOIN $SCHEMANAME$.zoning_element_describing_line ze_dl
    ON ze_dl.zoning_element_local_id = ze.local_id
    AND ze.lifecycle_status = '17'
  WHERE dl.id = ze_dl.describing_line_id
    AND dl.lifecycle_status IN ('02', '03', '04', '05');

  UPDATE $SCHEMANAME$.describing_line dl
  SET lifecycle_status = ze.lifecycle_status
  FROM $SCHEMANAME$.zoning_element ze
  JOIN $SCHEMANAME$.zoning_element_describing_line ze_dl
    ON ze_dl.zoning_element_local_id = ze.local_id
    AND ze.lifecycle_status IN ('01', '02', '03', '04', '05', '06', '17')
  WHERE dl.id = ze_dl.describing_line_id
    AND ze.lifecycle_status <> dl.lifecycle_status;

  UPDATE $SCHEMANAME$.describing_line dl
  SET lifecycle_status = '13'
  FROM $SCHEMANAME$.zoning_element ze
  JOIN $SCHEMANAME$.zoning_element_describing_line ze_dl
    ON ze_dl.zoning_element_local_id = ze.local_id
    AND ze.lifecycle_status = '13'
  WHERE dl.id = ze_dl.describing_line_id
    AND dl.lifecycle_status IN ('06', '07', '08', '09');

  UPDATE $SCHEMANAME$.describing_line dl
  SET lifecycle_status = '14'
  FROM $SCHEMANAME$.zoning_element ze
  JOIN $SCHEMANAME$.zoning_element_describing_line ze_dl
    ON ze_dl.zoning_element_local_id = ze.local_id
    AND ze.lifecycle_status = '14'
  WHERE dl.id = ze_dl.describing_line_id
    AND dl.lifecycle_status IN ('10', '11', '12', '13');

  UPDATE $SCHEMANAME$.describing_text dt
  SET lifecycle_status = '13'
  FROM $SCHEMANAME$.zoning_element ze
  JOIN $SCHEMANAME$.zoning_element_describing_text ze_dt
    ON ze_dt.zoning_element_local_id = ze.local_id
    AND ze.lifecycle_status = '13'
  WHERE dt.id = ze_dt.describing_text_id
    AND dt.lifecycle_status IN ('06', '07', '08', '09');

  UPDATE $SCHEMANAME$.describing_text dt
  SET lifecycle_status = '14'
  FROM $SCHEMANAME$.zoning_element ze
  JOIN $SCHEMANAME$.zoning_element_describing_text ze_dt
    ON ze_dt.zoning_element_local_id = ze.local_id
    AND ze.lifecycle_status = '14'
  WHERE dt.id = ze_dt.describing_text_id
    AND dt.lifecycle_status IN ('06', '07', '08', '09');

  UPDATE $SCHEMANAME$.describing_text dt
  SET lifecycle_status = '17'
  FROM $SCHEMANAME$.zoning_element ze
  JOIN $SCHEMANAME$.zoning_element_describing_text ze_dt
    ON ze_dt.zoning_element_local_id = ze.local_id
    AND ze.lifecycle_status = '17'
  WHERE dt.id = ze_dt.describing_text_id
    AND dt.lifecycle_status IN ('02', '03', '04', '05');

  UPDATE $SCHEMANAME$.describing_text dt
  SET lifecycle_status = ze.lifecycle_status
  FROM $SCHEMANAME$.zoning_element ze
  JOIN $SCHEMANAME$.zoning_element_describing_text ze_dt
    ON ze_dt.zoning_element_local_id = ze.local_id
    AND ze.lifecycle_status IN ('01', '02', '03', '04', '05', '06', '17')
  WHERE dt.id = ze_dt.describing_text_id
    AND ze.lifecycle_status <> dt.lifecycle_status;

  UPDATE $SCHEMANAME$.describing_text dt
  SET lifecycle_status = '14'
  FROM $SCHEMANAME$.zoning_element ze
  JOIN $SCHEMANAME$.zoning_element_describing_text ze_dt
    ON ze_dt.zoning_element_local_id = ze.local_id
    AND ze.lifecycle_status = '14'
  WHERE dt.id = ze_dt.describing_text_id
    AND dt.lifecycle_status IN ('10', '11', '12', '13');

  WITH RECURSIVE valid_spatial_plans(local_id) AS (
      SELECT DISTINCT sp.local_id
      FROM $SCHEMANAME$.spatial_plan sp
        INNER JOIN $SCHEMANAME$.zoning_element ze
          ON ze.spatial_plan = sp.local_id
      WHERE ze.lifecycle_status IN ('11', '12', '13')
        AND sp.lifecycle_status IN ('06', '07', '08')
      EXCEPT
      SELECT sp2.local_id
      FROM $SCHEMANAME$.spatial_plan sp2
        INNER JOIN $SCHEMANAME$.zoning_element ze2
          ON ze2.spatial_plan = sp2.local_id
      WHERE ze2.lifecycle_status IN ('06', '07', '08', '10')
  )
  UPDATE $SCHEMANAME$.spatial_plan sp
  SET lifecycle_status = '13'
  FROM valid_spatial_plans vsp
  WHERE sp.local_id = vsp.local_id;

  UPDATE $SCHEMANAME$.spatial_plan
  SET lifecycle_status = '13'
  WHERE local_id IN (
    SELECT sp.local_id
    FROM $SCHEMANAME$.spatial_plan sp
    WHERE
    EXISTS (
        SELECT 1
        FROM $SCHEMANAME$.zoning_element ze
        WHERE ze.spatial_plan = sp.local_id
    )
    AND NOT EXISTS (
      SELECT 1
      FROM $SCHEMANAME$.zoning_element ze
      WHERE ze.spatial_plan = sp.local_id
      AND ze.lifecycle_status NOT IN ('11', '12', '13')
    ));

  UPDATE $SCHEMANAME$.spatial_plan
  SET lifecycle_status = '10'
  WHERE local_id IN (
    SELECT DISTINCT sp.local_id
    FROM $SCHEMANAME$.spatial_plan sp
    JOIN $SCHEMANAME$.zoning_element ze ON ze.spatial_plan = sp.local_id
    WHERE ze.lifecycle_status IN ('11', '12', '13')
    AND EXISTS (
      SELECT 1
      FROM $SCHEMANAME$.zoning_element ze2
      WHERE ze2.spatial_plan = sp.local_id
      AND ze2.lifecycle_status NOT IN ('11', '12', '13')
    )
  );

END;
$BODY$;
