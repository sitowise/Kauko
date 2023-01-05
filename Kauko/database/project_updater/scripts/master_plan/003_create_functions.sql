CREATE OR REPLACE FUNCTION SCHEMANAME.convert_to_timerange()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
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
$function$
;

CREATE OR REPLACE FUNCTION SCHEMANAME.delete_geom_relations()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
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
$function$
;

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
      AND sp.validity = 4
      AND ze.validity = 4
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
    WHERE ze.validity = 4
      AND ps.validity = 4
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
    WHERE ze.validity = 4
      AND pdl.validity = 4
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
      WHERE ze.validity = 4
        AND dl.validity = 4
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
        WHERE ze.validity = 4
          AND dt.validity = 4
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
        WHERE ps.validity = 4
          AND pdl.validity = 4
          AND NOT EXISTS (
            SELECT 1
            FROM SCHEMANAME.planned_space_plan_detail_line ps_pdl
            WHERE ps_pdl.planning_detail_line_local_id = pdl.local_id AND
                  ps_pdl.planned_space_local_id = ps.local_id
          );
      END IF;
    RETURN NULL;
END;
$function$
;

CREATE OR REPLACE FUNCTION SCHEMANAME.inherit_validity()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
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
  )
  UPDATE SCHEMANAME.planned_space ps
  SET valid_from = zeiv.valid_from,
      valid_to = zeiv.valid_to
  FROM ze_inherited_validity zeiv
  WHERE zeiv.local_id = ps.local_id;

  RETURN NULL;
END;
$function$
;

CREATE OR REPLACE FUNCTION SCHEMANAME.refresh_validity()
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN
  UPDATE SCHEMANAME.spatial_plan sp
  SET validity = 1
  WHERE sp.validity = 4
    AND sp.validity_time @> Current_Date;

  UPDATE SCHEMANAME.spatial_plan sp
  SET validity = 3
  WHERE sp.validity <> 3
    AND upper(sp.validity_time) < Current_Date;

  UPDATE SCHEMANAME.zoning_element ze
  SET validity = 1
  WHERE ze.validity = 4
    AND ze.validity_time @> Current_Date;

  UPDATE SCHEMANAME.zoning_element ze
  SET
    validity = 1,
    valid_from = GREATEST(ze.valid_from, sp.valid_from),
    valid_to = LEAST(ze.valid_to, sp.valid_to)
  FROM SCHEMANAME.spatial_plan sp
  WHERE sp.local_id = ze.spatial_plan
    AND ze.validity = 4
    AND sp.validity = 1;

  UPDATE SCHEMANAME.zoning_element ze
  SET validity = 3
  WHERE ze.validity <> 3
    AND upper(ze.validity_time) < Current_Date;

  UPDATE SCHEMANAME.zoning_element ze
  SET validity = 3,
      valid_to = sp.valid_to
  FROM SCHEMANAME.spatial_plan sp
  WHERE sp.local_id = ze.spatial_plan
    AND ze.validity <> 3
    AND sp.validity = 3;

  UPDATE SCHEMANAME.planned_space ps
  SET validity = 1
  WHERE ps.validity = 4
    AND ps.validity_time @> Current_Date;

  UPDATE SCHEMANAME.planned_space ps
  SET
    validity = 1,
    valid_from = GREATEST(ps.valid_from, ze.valid_from),
    valid_to = LEAST(ps.valid_from, ze.valid_from)
  FROM SCHEMANAME.zoning_element ze
  JOIN SCHEMANAME.zoning_element_planned_space ze_ps
    ON ze_ps.zoning_element_local_id = ze.local_id
    AND ze.validity = 1
  WHERE ps.local_id = ze_ps.planned_space_local_id
    AND ps.validity = 4;

  UPDATE SCHEMANAME.planned_space ps
  SET validity = 3
  WHERE ps.validity <> 3
    AND upper(ps.validity_time) < Current_Date;

  UPDATE SCHEMANAME.planned_space ps
  SET validity = 3,
      valid_to = ze.valid_to
  FROM SCHEMANAME.zoning_element ze
  JOIN SCHEMANAME.zoning_element_planned_space ze_ps
    ON ze_ps.zoning_element_local_id = ze.local_id
    AND ze.validity = 3
  WHERE ps.local_id = ze_ps.planned_space_local_id
    AND ps.validity <> 3;

  UPDATE SCHEMANAME.planning_detail_line pdl
  SET validity = 1
  FROM SCHEMANAME.zoning_element ze
  JOIN SCHEMANAME.zoning_element_plan_detail_line ze_pdl
    ON ze_pdl.zoning_element_local_id = ze.local_id
    AND ze.validity = 1
  WHERE pdl.local_id = ze_pdl.planning_detail_line_local_id
    AND pdl.validity = 4;

  UPDATE SCHEMANAME.planning_detail_line pdl
  SET validity = 3
  FROM SCHEMANAME.zoning_element ze
  JOIN SCHEMANAME.zoning_element_plan_detail_line ze_pdl
    ON ze_pdl.zoning_element_local_id = ze.local_id
    AND ze.validity = 3
  WHERE pdl.local_id = ze_pdl.planning_detail_line_local_id
    AND pdl.validity <> 3;

  UPDATE SCHEMANAME.describing_line dl
  SET validity = 1
  FROM SCHEMANAME.zoning_element ze
  JOIN SCHEMANAME.zoning_element_describing_line ze_dl
    ON ze_dl.zoning_element_local_id = ze.local_id
    AND ze.validity = 1
  WHERE dl.identifier = ze_dl.describing_line_id
    AND dl.validity = 4;

  UPDATE SCHEMANAME.describing_line dl
  SET validity = 3
  FROM SCHEMANAME.zoning_element ze
  JOIN SCHEMANAME.zoning_element_describing_line ze_dl
    ON ze_dl.zoning_element_local_id = ze.local_id
    AND ze.validity = 3
  WHERE dl.identifier = ze_dl.describing_line_id
    AND dl.validity <> 3;

  UPDATE SCHEMANAME.describing_text dt
  SET validity = 1
  FROM SCHEMANAME.zoning_element ze
  JOIN SCHEMANAME.zoning_element_describing_text ze_dt
    ON ze_dt.zoning_element_local_id = ze.local_id
    AND ze.validity = 1
  WHERE dt.identifier = ze_dt.describing_text_id
    AND dt.validity = 4;

  UPDATE SCHEMANAME.describing_text dt
  SET validity = 3
  FROM SCHEMANAME.zoning_element ze
  JOIN SCHEMANAME.zoning_element_describing_text ze_dt
    ON ze_dt.zoning_element_local_id = ze.local_id
    AND ze.validity = 3
  WHERE dt.identifier = ze_dt.describing_text_id
    AND dt.validity <> 3;

  WITH RECURSIVE valid_spatial_plans(local_id) AS (
      SELECT DISTINCT sp.local_id
      FROM SCHEMANAME.spatial_plan sp
        INNER JOIN SCHEMANAME.zoning_element ze
          ON ze.spatial_plan = sp.local_id
      WHERE ze.validity = 1
        AND sp.validity <> 1
      EXCEPT
      SELECT sp2.local_id
      FROM SCHEMANAME.spatial_plan sp2
        INNER JOIN SCHEMANAME.zoning_element ze2
          ON ze2.spatial_plan = sp2.local_id
      WHERE ze2.validity <> 1
  )
  UPDATE SCHEMANAME.spatial_plan sp
  SET validity = 1
  FROM valid_spatial_plans vsp
  WHERE sp.local_id = vsp.local_id;

  UPDATE SCHEMANAME.spatial_plan sp
  SET validity = 2
  FROM SCHEMANAME.zoning_element ze
  WHERE sp.local_id = ze.spatial_plan
    AND ze.validity <> 1
    AND sp.validity = 1;
END;
$function$
;

CREATE OR REPLACE FUNCTION SCHEMANAME.update_validity()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
  PERFORM SCHEMANAME.refresh_validity();

  CREATE TEMPORARY TABLE temp_spatial_plan AS (
    SELECT
      sp.local_id AS local_id,
      sp.geom AS geom,
      sp.valid_from AS valid_from,
      sp.valid_to AS valid_to,
      sp.validity AS validity,
      sp.validity_time AS validity_time
    FROM SCHEMANAME.spatial_plan sp
    WHERE
      sp.valid_from IS NOT NULL
      AND sp.validity <> 3
      AND (sp.valid_to IS NULL OR sp.valid_to >= Current_Date)
    );

    WITH spatial_plan_valid_from AS (
      SELECT
        Max(temp_spatial_plan.valid_from) AS max_valid_from,
        sp.local_id AS local_id
      FROM
        SCHEMANAME.spatial_plan sp,
        temp_spatial_plan
      WHERE
        st_intersects(sp.geom, temp_spatial_plan.geom) = TRUE
        AND st_touches(sp.geom, temp_spatial_plan.geom) = FALSE
      GROUP BY sp.local_id
    )
    UPDATE SCHEMANAME.spatial_plan sp
    SET
      validity = 3,
      valid_to = spvf.max_valid_from
    FROM spatial_plan_valid_from spvf
    WHERE
      sp.local_id = spvf.local_id
      AND (
        sp.validity <> 3
        AND (
          sp.valid_to IS NULL
          OR sp.valid_to >= Current_Date)
        AND st_within(
          sp.geom,
          st_buffer(
            (SELECT
              st_union(temp_spatial_plan.geom)
            FROM temp_spatial_plan
            WHERE temp_spatial_plan.local_id <> sp.local_id
            AND temp_spatial_plan.valid_from > sp.valid_from),
            0.1
          )
        ) = TRUE
      );

    UPDATE SCHEMANAME.spatial_plan sp
    SET validity = 2
    WHERE
      sp.validity = 1
      AND (
        sp.valid_to IS NULL OR
        sp.valid_to >= Current_Date)
      AND st_overlaps(
        sp.geom,
        st_buffer(
          (
            SELECT st_union(temp_spatial_plan.geom)
            FROM temp_spatial_plan
            WHERE temp_spatial_plan.local_id <> sp.local_id
              AND temp_spatial_plan.valid_from > sp.valid_from
              AND temp_spatial_plan.validity = 1
          ), 0.1
        )
      ) = TRUE;

    DROP TABLE temp_spatial_plan;

    CREATE TEMPORARY TABLE temp_zoning_element AS
    SELECT
      ze.local_id AS local_id,
      ze.geom AS geom,
      ze.valid_from AS valid_from,
      ze.validity AS validity,
      ze.spatial_plan AS spatial_plan
    FROM SCHEMANAME.zoning_element ze
    WHERE ze.valid_from IS NOT NULL
      AND ze.validity <> 3
      AND (ze.valid_to IS NULL OR ze.valid_to >= Current_Date);

    WITH zoning_element_valid_from AS (
      SELECT
        Max(temp_zoning_element.valid_from) AS max_valid_from,
        ze.local_id AS local_id
      FROM SCHEMANAME.zoning_element ze,
            temp_zoning_element
      WHERE st_intersects(ze.geom, temp_zoning_element.geom) = TRUE
        AND st_touches(ze.geom, temp_zoning_element.geom) = FALSE
      GROUP BY ze.local_id
    )
    UPDATE SCHEMANAME.zoning_element ze
    SET validity = 3,
        valid_to = zevf.max_valid_from
    FROM zoning_element_valid_from zevf
    WHERE ze.local_id = zevf.local_id
      AND ze.validity <> 3
      AND (ze.valid_to IS NULL OR
        ze.valid_to >= Current_Date)
      AND st_within(
        ze.geom,
        st_buffer(
          (
            SELECT st_union(temp_zoning_element.geom)
            FROM temp_zoning_element
            WHERE temp_zoning_element.local_id <> ze.local_id
              AND temp_zoning_element.valid_from > ze.valid_from
          ), 0.1
        )
      ) = TRUE;

    UPDATE SCHEMANAME.zoning_element ze
    SET validity = 2
    WHERE ze.validity = 1
      AND (ze.valid_to IS NULL OR
          ze.valid_to >= Current_Date)
      AND st_overlaps(
        ze.geom,
        st_buffer(
          (
            SELECT st_union(temp_zoning_element.geom)
            FROM temp_zoning_element
            WHERE temp_zoning_element.local_id <> ze.local_id
              AND temp_zoning_element.spatial_plan <> ze.spatial_plan
              AND temp_zoning_element.valid_from > ze.valid_from
              AND temp_zoning_element.validity = 1
          ), -0.1
        )
      ) = TRUE;

    DROP TABLE temp_zoning_element;

    WITH zoning_elements AS (
      SELECT ze.local_id, ze.geom
      FROM SCHEMANAME.zoning_element ze
      WHERE
        ze.valid_from IS NOT NULL
        AND ze.validity <> 3
        AND (ze.valid_to IS NULL OR ze.valid_to >= Current_Date)
      EXCEPT
      SELECT ze.zoning_element_local_id, ze.geom
      FROM SCHEMANAME.zoning_element_planned_space ze
      WHERE ze.planned_space_local_id = ps.local_id
    )
    UPDATE SCHEMANAME.planned_space ps
    SET validity = 3
    WHERE
      st_within(
        ps.geom,
        st_buffer(
          (SELECT st_union(ze.geom) FROM zoning_elements ze),
          0.1
        )
      ) = TRUE
      AND ps.validity <> 3;

    WITH zoning_elements AS (
      SELECT ze.local_id, ze.geom
      FROM SCHEMANAME.zoning_element ze
      WHERE
        ze.valid_from IS NOT NULL
        AND ze.validity = 1
        AND (ze.valid_to IS NULL OR ze.valid_to >= Current_Date)
      EXCEPT
      SELECT ze.zoning_element_local_id, ze.geom
      FROM SCHEMANAME.zoning_element_planned_space ze
      WHERE ze.planned_space_local_id = ps.local_id
    )
    UPDATE SCHEMANAME.planned_space ps
    SET validity = 2
    WHERE
      st_overlaps(
        ps.geom,
        st_buffer(
          (SELECT st_union(ze.geom) FROM zoning_elements ze),
          0.1
        )
      ) = TRUE
      AND ps.validity = 1;

    WITH zoning_elements AS (
      SELECT ze.local_id, ze.geom
      FROM SCHEMANAME.zoning_element ze
      WHERE
        ze.valid_from IS NOT NULL
        AND ze.validity <> 3
        AND (ze.valid_to IS NULL OR ze.valid_to >= Current_Date)
      EXCEPT
      SELECT ze.zoning_element_local_id, ze.geom
      FROM SCHEMANAME.zoning_element_plan_detail_line ze
      WHERE ze.planning_detail_line_local_id = pdl.local_id
    )
    UPDATE SCHEMANAME.planning_detail_line pdl
    SET validity = 3
    WHERE
      st_within(
        pdl.geom,
        st_buffer(
          (SELECT st_union(ze.geom) FROM zoning_elements ze),
          0.1
        )
      ) = TRUE
      AND pdl.validity <> 3;

    WITH zoning_elements AS (
      SELECT ze.local_id, ze.geom
      FROM SCHEMANAME.zoning_element ze
      WHERE
        ze.valid_from IS NOT NULL
        AND ze.validity = 1
        AND (ze.valid_to IS NULL OR ze.valid_to >= Current_Date)
      EXCEPT
      SELECT ze.zoning_element_local_id, ze.geom
      FROM SCHEMANAME.zoning_element_plan_detail_line ze
      WHERE ze.planning_detail_line_local_id = pdl.local_id
    )
    UPDATE SCHEMANAME.planning_detail_line pdl
    SET validity = 2
    WHERE
      st_crosses(
        pdl.geom,
        st_buffer(
          (SELECT st_union(ze.geom) FROM zoning_elements ze),
          0.1
        )
      ) = TRUE
      AND pdl.validity = 1;

    WITH zoning_elements AS (
      SELECT ze.local_id, ze.geom
      FROM SCHEMANAME.zoning_element ze
      WHERE
        ze.valid_from IS NOT NULL
        AND ze.validity <> 3
        AND (ze.valid_to IS NULL OR ze.valid_to >= Current_Date)
      EXCEPT
      SELECT ze.zoning_element_local_id, ze.geom
      FROM SCHEMANAME.zoning_element_describing_line ze
      WHERE ze.describing_line_id = dl.identifier
    )
    UPDATE SCHEMANAME.describing_line dl
    SET validity = 3
    WHERE
      st_within(
        dl.geom,
        st_buffer(
          (SELECT st_union(ze.geom) FROM zoning_elements ze),
          0.1
        )
      ) = TRUE
      AND dl.validity <> 3;

    WITH zoning_elements AS (
      SELECT ze.local_id, ze.geom
      FROM SCHEMANAME.zoning_element ze
      WHERE
        ze.valid_from IS NOT NULL
        AND ze.validity = 1
        AND (ze.valid_to IS NULL OR ze.valid_to >= Current_Date)
      EXCEPT
      SELECT ze.zoning_element_local_id, ze.geom
      FROM SCHEMANAME.zoning_element_describing_line ze
      WHERE ze.describing_line_id = dl.identifier
    )
    UPDATE SCHEMANAME.describing_line dl
    SET validity = 2
    WHERE
      st_crosses(
        dl.geom,
        st_buffer(
          (SELECT st_union(ze.geom) FROM zoning_elements ze),
          0.1
        )
      ) = TRUE
      AND dl.validity = 1;

    WITH zoning_elements AS (
      SELECT ze.local_id, ze.geom
      FROM SCHEMANAME.zoning_element ze
      WHERE
        ze.valid_from IS NOT NULL
        AND ze.validity <> 3
        AND (ze.valid_to IS NULL OR ze.valid_to >= Current_Date)
      EXCEPT
      SELECT ze.zoning_element_local_id, ze.geom
      FROM SCHEMANAME.zoning_element_describing_text ze
      WHERE ze.describing_text_id = dt.identifier
    )
    UPDATE SCHEMANAME.describing_text dt
    SET validity = 3
    WHERE
      st_within(
        dt.geom,
        st_buffer(
          (SELECT st_union(ze.geom) FROM zoning_elements ze),
          0.1
        )
      ) = TRUE
      AND dt.validity <> 3;

    PERFORM SCHEMANAME.refresh_validity();
    RETURN NULL;
END;
$function$
;

CREATE OR REPLACE FUNCTION SCHEMANAME.upsert_ridge_direction()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
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
$function$
;

CREATE OR REPLACE FUNCTION SCHEMANAME.validate_lifcycle_status()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
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
$function$
;

CREATE OR REPLACE FUNCTION SCHEMANAME.validity_to_daterange()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
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
  NEW.validity_time = DATERANGE(NEW.valid_from, NEW.valid_to, '[)');
  RETURN NEW;
END;
$function$
;
