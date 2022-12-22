CREATE OR REPLACE FUNCTION SCHEMANAME.validate_zoning_element_validity_dates(
  valid_from DATE,
  valid_to DATE,
  spatial_plan VARCHAR
)
RETURNS BOOLEAN
LANGUAGE plpgsql
AS $$
DECLARE
  sp_valid_from DATE;
  sp_valid_to DATE;
  is_valid BOOLEAN := TRUE;
BEGIN
  SELECT valid_from, valid_to
  INTO sp_valid_from, sp_valid_to
  FROM SCHEMANAME.spatial_plan
  WHERE local_id = spatial_plan;

  IF valid_from IS NOT NULL AND valid_to IS NOT NULL AND valid_from > valid_to THEN
    is_valid := FALSE;
  ELSIF valid_from IS NOT NULL AND sp_valid_from IS NOT NULL AND valid_from < sp_valid_from THEN
    is_valid := FALSE;
  ELSIF valid_to IS NOT NULL AND sp_valid_to IS NOT NULL AND valid_to > sp_valid_to THEN
    is_valid := FALSE;
  END IF;

  RETURN is_valid;
END;
$$;

ALTER TABLE SCHEMANAME.zoning_element
ADD CONSTRAINT validate_validity_dates
CHECK (validate_zoning_element_validity_dates(valid_from, valid_to, spatial_plan));

CREATE OR REPLACE FUNCTION SCHEMANAME.validate_lifcycle_status()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
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
$$;

-- CREATE INHERIT VALIDITY TRIGGER

-- FUNCTION: SCHEMANAME.inherit_validity()

CREATE FUNCTION "SCHEMANAME".inherit_validity()
    RETURNS trigger
    LANGUAGE 'plpgsql'
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
  )
  UPDATE SCHEMANAME.planned_space ps
  SET valid_from = zeiv.valid_from,
      valid_to = zeiv.valid_to
  FROM ze_inherited_validity zeiv
  WHERE zeiv.local_id = ps.local_id;

  RETURN NULL;
END;
$BODY$;


CREATE TRIGGER inherit_validity
  AFTER INSERT OR UPDATE
    OF valid_from, valid_to
  ON SCHEMANAME.spatial_plan
  WHEN (pg_trigger_depth() < 1)
EXECUTE PROCEDURE SCHEMANAME.inherit_validity();

CREATE TRIGGER inherit_validity
  AFTER INSERT
  ON SCHEMANAME.zoning_element
EXECUTE PROCEDURE SCHEMANAME.inherit_validity();

CREATE TRIGGER inherit_validity
  AFTER INSERT
  ON SCHEMANAME.planned_space
EXECUTE PROCEDURE SCHEMANAME.inherit_validity();

GRANT EXECUTE ON FUNCTION SCHEMANAME.inherit_validity() TO qgis_editor;

GRANT EXECUTE ON FUNCTION SCHEMANAME.inherit_validity() TO qgis_admin;

-- CREATE update_validity TRIGGER

CREATE FUNCTION "SCHEMANAME".update_validity()
    RETURNS TRIGGER
    LANGUAGE plpgsql
AS $BODY$
BEGIN
    PERFORM SCHEMANAME.refresh_validity();

    CREATE TEMPORARY TABLE temp_spatial_plan AS (
        SELECT sp.planning_object_identifier AS planning_object_identifier,
               sp.geom                       AS geom,
               sp.valid_from                 AS valid_from,
               sp.valid_to                   AS valid_to,
               sp.validity                   AS validity
        FROM SCHEMANAME.spatial_plan sp
        WHERE sp.valid_from IS NOT NULL
          AND sp.validity <> 3
          AND (sp.valid_to IS NULL OR sp.valid_to >= Current_Date)
    );

    WITH spatial_plan_valid_from AS (
        SELECT Max(temp_spatial_plan.valid_from) AS max_valid_from,
               sp.planning_object_identifier     AS planning_object_identifier
        FROM SCHEMANAME.spatial_plan sp,
             temp_spatial_plan
        WHERE st_intersects(sp.geom, temp_spatial_plan.geom) = TRUE
          AND st_touches(sp.geom, temp_spatial_plan.geom) = FALSE
        GROUP BY sp.planning_object_identifier
    )
    UPDATE SCHEMANAME.spatial_plan sp
    SET validity = 3,
        valid_to = spvf.max_valid_from
    FROM spatial_plan_valid_from spvf
    WHERE sp.planning_object_identifier = spvf.planning_object_identifier
      AND (sp.validity <> 3 AND
           (sp.valid_to IS NULL OR
            sp.valid_to >= Current_Date) AND
           st_within(sp.geom,
                            st_buffer((SELECT st_union(temp_spatial_plan.geom)
                                              FROM temp_spatial_plan
                                              WHERE temp_spatial_plan.planning_object_identifier <>
                                                    sp.planning_object_identifier
                                                AND temp_spatial_plan.valid_from > sp.valid_from),
                                             0.1)) = TRUE);

    UPDATE SCHEMANAME.spatial_plan sp
    SET validity = 2
    WHERE sp.validity = 1
      AND (sp.valid_to IS NULL OR
           sp.valid_to >= Current_Date)
      AND st_overlaps(sp.geom,
                             st_buffer((SELECT st_union(temp_spatial_plan.geom)
                                               FROM temp_spatial_plan
                                               WHERE temp_spatial_plan.planning_object_identifier <>
                                                     sp.planning_object_identifier
                                                 AND temp_spatial_plan.valid_from > sp.valid_from
                                                 AND temp_spatial_plan.validity = 1), 0.1)) = TRUE;

    DROP TABLE temp_spatial_plan;

    CREATE TEMPORARY TABLE temp_zoning_element AS
    SELECT ze.planning_object_identifier AS planning_object_identifier,
           ze.geom                       AS geom,
           ze.valid_from                 AS valid_from,
           ze.validity                   AS validity,
           ze.fk_spatial_plan            AS fk_spatial_plan
    FROM SCHEMANAME.zoning_element ze
    WHERE ze.valid_from IS NOT NULL
      AND ze.validity <> 3
      AND (ze.valid_to IS NULL OR ze.valid_to >= Current_Date);

    WITH zoning_element_valid_from AS (
        SELECT Max(temp_zoning_element.valid_from) AS max_valid_from,
               ze.planning_object_identifier       AS planning_object_identifier
        FROM SCHEMANAME.zoning_element ze,
             temp_zoning_element
        WHERE st_intersects(ze.geom, temp_zoning_element.geom) = TRUE
          AND st_touches(ze.geom, temp_zoning_element.geom) = FALSE
        GROUP BY ze.planning_object_identifier
    )
    UPDATE SCHEMANAME.zoning_element ze
    SET validity = 3,
        valid_to = zevf.max_valid_from
    FROM zoning_element_valid_from zevf
    WHERE ze.planning_object_identifier = zevf.planning_object_identifier
      AND ze.validity <> 3
      AND (ze.valid_to IS NULL OR
           ze.valid_to >= Current_Date)
      AND st_within(ze.geom,
                           st_buffer((SELECT st_union(temp_zoning_element.geom)
                                             FROM temp_zoning_element
                                             WHERE temp_zoning_element.planning_object_identifier <>
                                                   ze.planning_object_identifier
                                               AND temp_zoning_element.valid_from > ze.valid_from),
                                            0.1)) = TRUE;

    UPDATE SCHEMANAME.zoning_element ze
    SET validity = 2
    WHERE ze.validity = 1
      AND (ze.valid_to IS NULL OR
           ze.valid_to >= Current_Date)
      AND st_overlaps(ze.geom,
                             st_buffer((SELECT st_union(temp_zoning_element.geom)
                                               FROM temp_zoning_element
                                               WHERE temp_zoning_element.planning_object_identifier <>
                                                     ze.planning_object_identifier
                                                 AND temp_zoning_element.fk_spatial_plan <>
                                                     ze.fk_spatial_plan
                                                 AND temp_zoning_element.valid_from > ze.valid_from
                                                 AND temp_zoning_element.validity = 1), -0.1)) = TRUE;

    DROP TABLE temp_zoning_element;

    UPDATE SCHEMANAME.planned_space ps
    SET validity = 3
    WHERE st_within(ps.geom, st_buffer((WITH RECURSIVE zoning_elements(planning_object_identifier) AS (
        SELECT ze.planning_object_identifier
        FROM SCHEMANAME.zoning_element ze
        WHERE ze.valid_from IS NOT NULL
          AND ze.validity <> 3
          AND (ze.valid_to IS NULL OR ze.valid_to >= Current_Date)
            EXCEPT
        SELECT ze_ps.zoning_element_id
        FROM SCHEMANAME.zoning_element_planned_space ze_ps
        WHERE ze_ps.planned_space_id = ps.planning_object_identifier
    )
                                                      SELECT st_union(ze.geom)
                                                      FROM SCHEMANAME.zoning_element ze,
                                                           zoning_elements zes
                                                      WHERE ze.planning_object_identifier = zes.planning_object_identifier),
                                                     0.1)) = TRUE
      AND ps.validity <> 3;

    UPDATE SCHEMANAME.planned_space ps
    SET validity = 2
    WHERE st_overlaps(ps.geom, st_buffer((WITH RECURSIVE zoning_elements(planning_object_identifier) AS (
        SELECT ze.planning_object_identifier
        FROM SCHEMANAME.zoning_element ze
        WHERE ze.valid_from IS NOT NULL
          AND ze.validity = 1
          AND (ze.valid_to IS NULL OR ze.valid_to >= Current_Date)
            EXCEPT
        SELECT ze_ps.zoning_element_id
        FROM SCHEMANAME.zoning_element_planned_space ze_ps
        WHERE ze_ps.planned_space_id = ps.planning_object_identifier
    )
                                                        SELECT st_union(ze.geom)
                                                        FROM SCHEMANAME.zoning_element ze,
                                                             zoning_elements zes
                                                        WHERE zes.planning_object_identifier = ze.planning_object_identifier),
                                                       0.1)) = TRUE
      AND ps.validity = 1;

    UPDATE SCHEMANAME.planning_detail_line pdl
    SET validity = 3
    WHERE st_within(pdl.geom, st_buffer((WITH RECURSIVE zoning_elements(planning_object_identifier) AS (
        SELECT ze.planning_object_identifier
        FROM SCHEMANAME.zoning_element ze
        WHERE ze.valid_from IS NOT NULL
          AND ze.validity <> 3
          AND (ze.valid_to IS NULL OR ze.valid_to >= Current_Date)
            EXCEPT
        SELECT ze_pdl.zoning_id
        FROM SCHEMANAME.zoning_element_plan_detail_line ze_pdl
        WHERE ze_pdl.plan_detail_line_id = pdl.planning_object_identifier
    )
                                                       SELECT st_union(ze.geom)
                                                       FROM SCHEMANAME.zoning_element ze,
                                                            zoning_elements zes
                                                       WHERE ze.planning_object_identifier = zes.planning_object_identifier),
                                                      0.1)) = TRUE
      AND pdl.validity <> 3;

    UPDATE SCHEMANAME.planning_detail_line pdl
    SET validity = 2
    WHERE st_crosses(pdl.geom, st_buffer((WITH RECURSIVE zoning_elements(planning_object_identifier) AS (
        SELECT ze.planning_object_identifier
        FROM SCHEMANAME.zoning_element ze
        WHERE ze.valid_from IS NOT NULL
          AND ze.validity = 1
          AND (ze.valid_to IS NULL OR ze.valid_to >= Current_Date)
            EXCEPT
        SELECT ze_pdl.zoning_id
        FROM SCHEMANAME.zoning_element_plan_detail_line ze_pdl
        WHERE ze_pdl.plan_detail_line_id = pdl.planning_object_identifier
    )
                                                        SELECT st_union(ze.geom)
                                                        FROM SCHEMANAME.zoning_element ze,
                                                             zoning_elements zes
                                                        WHERE ze.planning_object_identifier = zes.planning_object_identifier),
                                                       0.1)) = TRUE
      AND pdl.validity = 1;

    UPDATE SCHEMANAME.planning_detail_point pdp
    SET validity = 3
    WHERE st_within(pdp.geom, st_buffer((WITH RECURSIVE zoning_elements(planning_object_identifier) AS (
        SELECT ze.planning_object_identifier
        FROM SCHEMANAME.zoning_element ze
        WHERE ze.valid_from IS NOT NULL
          AND ze.validity <> 3
          AND (ze.valid_to IS NULL OR ze.valid_to >= Current_Date)
            EXCEPT
        SELECT ze_pdp.zoning_id
        FROM SCHEMANAME.zoning_element_plan_detail_point ze_pdp
        WHERE ze_pdp.plan_detail_point_id = pdp.planning_object_identifier
    )
                                                       SELECT st_union(ze.geom)
                                                       FROM SCHEMANAME.zoning_element ze,
                                                            zoning_elements zes
                                                       WHERE ze.planning_object_identifier = zes.planning_object_identifier),
                                                      0.1)) = TRUE
      AND pdp.validity <> 3;

    UPDATE SCHEMANAME.describing_line dl
    SET validity = 3
    WHERE st_within(dl.geom, st_buffer((WITH RECURSIVE zoning_elements(planning_object_identifier) AS (
        SELECT ze.planning_object_identifier
        FROM SCHEMANAME.zoning_element ze
        WHERE ze.valid_from IS NOT NULL
          AND ze.validity <> 3
          AND (ze.valid_to IS NULL OR ze.valid_to >= Current_Date)
            EXCEPT
        SELECT ze_dl.zoning_id
        FROM SCHEMANAME.zoning_element_describing_line ze_dl
        WHERE ze_dl.describing_line_id = dl.identifier
    )
                                                      SELECT st_union(ze.geom)
                                                      FROM SCHEMANAME.zoning_element ze,
                                                           zoning_elements zes
                                                      WHERE ze.planning_object_identifier = zes.planning_object_identifier),
                                                     0.1)) = TRUE
      AND dl.validity <> 3;

    UPDATE SCHEMANAME.describing_line dl
    SET validity = 2
    WHERE st_crosses(dl.geom, st_buffer((WITH RECURSIVE zoning_elements(planning_object_identifier) AS (
        SELECT ze.planning_object_identifier
        FROM SCHEMANAME.zoning_element ze
        WHERE ze.valid_from IS NOT NULL
          AND ze.validity = 1
          AND (ze.valid_to IS NULL OR ze.valid_to >= Current_Date)
            EXCEPT
        SELECT ze_dl.zoning_id
        FROM SCHEMANAME.zoning_element_describing_line ze_dl
        WHERE ze_dl.describing_line_id = dl.identifier
    )
                                                       SELECT st_union(ze.geom)
                                                       FROM SCHEMANAME.zoning_element ze,
                                                            zoning_elements zes
                                                       WHERE ze.planning_object_identifier = zes.planning_object_identifier),
                                                      0.1)) = TRUE
      AND dl.validity = 1;

    UPDATE SCHEMANAME.describing_text dt
    SET validity = 3
    WHERE st_within(dt.geom, st_buffer((WITH RECURSIVE zoning_elements(planning_object_identifier) AS (
        SELECT ze.planning_object_identifier
        FROM SCHEMANAME.zoning_element ze
        WHERE ze.valid_from IS NOT NULL
          AND ze.validity <> 3
          AND (ze.valid_to IS NULL OR ze.valid_to >= Current_Date)
            EXCEPT
        SELECT ze_dt.zoning_id
        FROM SCHEMANAME.zoning_element_describing_text ze_dt
        WHERE ze_dt.describing_text_id = dt.identifier
    )
                                                      SELECT st_union(ze.geom)
                                                      FROM SCHEMANAME.zoning_element ze,
                                                           zoning_elements zes
                                                      WHERE ze.planning_object_identifier = zes.planning_object_identifier),
                                                     0.1)) = TRUE
      AND dt.validity <> 3;
    PERFORM SCHEMANAME.refresh_validity();
    RETURN NULL;
END;
$BODY$;


GRANT EXECUTE ON FUNCTION SCHEMANAME.update_validity() TO qgis_editor;

GRANT EXECUTE ON FUNCTION SCHEMANAME.update_validity() TO qgis_admin;

create trigger update_validity
    after insert or update
    on SCHEMANAME.spatial_plan
    when (pg_trigger_depth() < 1)
execute procedure SCHEMANAME.update_validity();

create trigger update_validity
    after insert or update
    on SCHEMANAME.zoning_element
    when (pg_trigger_depth() < 1)
execute procedure SCHEMANAME.update_validity();

create trigger update_validity
    after insert or update
    on SCHEMANAME.planned_space
    when (pg_trigger_depth() < 1)
execute procedure SCHEMANAME.update_validity();

create trigger update_validity
    after insert or update
    on SCHEMANAME.planning_detail_line
    when (pg_trigger_depth() < 1)
execute procedure SCHEMANAME.update_validity();

create trigger update_validity
    after insert or update
    on SCHEMANAME.planning_detail_point
    when (pg_trigger_depth() < 1)
execute procedure SCHEMANAME.update_validity();

create trigger update_validity
    after insert or update
    on SCHEMANAME.describing_text
    when (pg_trigger_depth() < 1)
execute procedure SCHEMANAME.update_validity();

create trigger update_validity
    after insert or update
    on SCHEMANAME.describing_line
    when (pg_trigger_depth() < 1)
execute procedure SCHEMANAME.update_validity();

-- CREATE refresh_validity FUNCTION

-- FUNCTION: SCHEMANAME.refresh_validity()

CREATE OR REPLACE FUNCTION "SCHEMANAME".refresh_validity()
    RETURNS void
    LANGUAGE plpgsql
AS $BODY$
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
$BODY$;


grant execute on function SCHEMANAME.refresh_validity() to qgis_admin;

grant execute on function SCHEMANAME.refresh_validity() to qgis_editor;