ALTER TABLE SCHEMANAME.spatial_plan
  DROP COLUMN validity;

DO $$
DECLARE
    _table_names text[] := ARRAY[
        'zoning_element',
        'planned_space',
        'planning_detail_line',
        'describing_line',
        'describing_text'
    ];
    table_name text;
    _triggers_to_disable RECORD;
BEGIN
    FOR _triggers_to_disable IN
    SELECT tgname, relname
      FROM pg_trigger
      JOIN pg_class ON tgrelid = pg_class.oid
      WHERE tgfoid in (
        'SCHEMANAME.update_validity()'::regprocedure,
        'SCHEMANAME.inherit_validity()'::regprocedure,
        'SCHEMANAME.upsert_creator_and_modifier_trigger()'::regprocedure
      )
    LOOP
        EXECUTE format('ALTER TABLE SCHEMANAME.%I
                          DISABLE TRIGGER %I;',
                      quote_ident(_triggers_to_disable.relname),
                      quote_ident(_triggers_to_disable.tgname));
    END LOOP;

    FOREACH table_name IN ARRAY _table_names
    LOOP
        EXECUTE format('ALTER TABLE SCHEMANAME.%I
                          ADD COLUMN lifecycle_status VARCHAR(3);',
                      quote_ident(table_name));
        EXECUTE format('ALTER TABLE SCHEMANAME.%I
                          ADD CONSTRAINT %1$I_lifecycle_status_fkey
                          FOREIGN KEY (lifecycle_status)
                          REFERENCES code_lists.spatial_plan_lifecycle_status (codevalue);',
                      quote_ident(table_name));
        EXECUTE format('UPDATE SCHEMANAME.%I
                          SET lifecycle_status =
                            CASE
                              WHEN validity = 1 THEN ''11''
                              WHEN validity = 2 THEN ''10''
                              WHEN validity = 3 THEN ''12''
                              WHEN validity = 4 THEN ''01''
                            END;',
                      quote_ident(table_name));
        EXECUTE format('ALTER TABLE SCHEMANAME.%I
                          DROP COLUMN validity,
                          ALTER COLUMN lifecycle_status SET NOT NULL;',
                      quote_ident(table_name));
    END LOOP;

    FOR _triggers_to_disable IN
    SELECT tgname, relname
      FROM pg_trigger
      JOIN pg_class ON tgrelid = pg_class.oid
      WHERE tgfoid in (
        'SCHEMANAME.update_validity()'::regprocedure,
        'SCHEMANAME.inherit_validity()'::regprocedure,
        'SCHEMANAME.upsert_creator_and_modifier_trigger()'::regprocedure
      )
    LOOP
        EXECUTE format('ALTER TABLE SCHEMANAME.%I
                          ENABLE TRIGGER %I;',
                      quote_ident(_triggers_to_disable.relname),
                      quote_ident(_triggers_to_disable.tgname));
    END LOOP;
END $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION SCHEMANAME.get_valid_spatial_plan_area(spatial_local_id VARCHAR)
RETURNS geometry
LANGUAGE plpgsql
STRICT
AS $$
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
$$;


CREATE OR REPLACE FUNCTION SCHEMANAME.get_valid_zoning_element_area(zoning_local_id VARCHAR)
  RETURNS geometry
  LANGUAGE plpgsql STRICT
AS $$
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
$$;

CREATE OR REPLACE FUNCTION SCHEMANAME.update_validity()
 RETURNS trigger
 LANGUAGE plpgsql
AS $$
BEGIN
  PERFORM SCHEMANAME.refresh_validity();

  CREATE TEMPORARY TABLE temp_spatial_plan AS (
    WITH valid_geom AS (
      SELECT
        local_id,
        SCHEMANAME.get_valid_spatial_plan_area(local_id) AS geom
      FROM SCHEMANAME.spatial_plan
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
    SET validity = '12'
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
$$;

CREATE OR REPLACE FUNCTION "SCHEMANAME".refresh_validity()
    RETURNS void
    LANGUAGE plpgsql
AS $$
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
    AND ps.validity IN ('10', '11');

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
    WHERE NOT EXISTS (
      SELECT 1
      FROM SCHEMANAME.zoning_element ze
      WHERE ze.spatial_plan = sp.local_id
      AND ze.lifecycle_status != '11'
    )
  );

  UPDATE SCHEMANAME.spatial_plan
  SET lifecycle_status = '10'
  WHERE local_id IN (
    SELECT DISTINCT sp.local_id
    FROM SCHEMANAME.spatial_plan sp
    JOIN SCHEMANAME.zoning_element ze ON ze.spatial_plan = sp.local_id
    WHERE zoning_element.lifecycle_status = '11'
    AND EXISTS (
      SELECT 1
      FROM SCHEMANAME.zoning_element ze2
      WHERE ze2.spatial_plan = sp.local_id
      AND ze2.lifecycle_status != '11'
    )
  );

END;
$$;
