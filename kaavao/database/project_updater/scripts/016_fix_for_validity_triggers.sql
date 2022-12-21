CREATE OR REPLACE FUNCTION validate_lifcycle_status()
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
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
BEGIN
    CREATE TEMPORARY TABLE temp_s_plan_z_element_valid_from AS
    SELECT
      ze.local_id AS zoning_id,
      sp.valid_from
    FROM SCHEMANAME.spatial_plan sp
      INNER JOIN
        SCHEMANAME.zoning_element ze ON sp.local_id = ze.spatial_plan
    WHERE ze.valid_from IS NULL
      AND sp.valid_from IS NOT NULL
      AND sp.validity = 1
      AND ze.validity <> 2
      AND (sp.valid_to > Current_Date OR sp.valid_to IS NULL);
    IF EXISTS(SELECT * FROM temp_s_plan_z_element_valid_from) THEN
        UPDATE SCHEMANAME.zoning_element
        SET valid_from = temp_s_plan_z_element_valid_from.valid_from
        FROM temp_s_plan_z_element_valid_from
        WHERE planning_object_identifier = temp_s_plan_z_element_valid_from.zoning_id;
    END IF;
    DROP TABLE temp_s_plan_z_element_valid_from;

    CREATE TEMPORARY TABLE temp_s_plan_z_element_valid_to AS
    SELECT sp.valid_to,
           ze.planning_object_identifier AS zoning_id
    FROM SCHEMANAME.spatial_plan sp
             INNER JOIN
         SCHEMANAME.zoning_element ze ON sp.planning_object_identifier = ze.fk_spatial_plan
    WHERE (ze.valid_to IS NULL OR ze.valid_to > sp.valid_to)
      AND sp.valid_to IS NOT NULL
      AND sp.validity = 1;

    IF EXISTS(SELECT * FROM temp_s_plan_z_element_valid_to) THEN
        UPDATE SCHEMANAME.zoning_element
        SET valid_to = temp_s_plan_z_element_valid_to.valid_to
        FROM temp_s_plan_z_element_valid_to
        WHERE planning_object_identifier = temp_s_plan_z_element_valid_to.zoning_id;
    END IF;
    DROP TABLE temp_s_plan_z_element_valid_to;

    CREATE TEMPORARY TABLE temp_z_element_s_plan_valid_from AS
    SELECT sp.planning_object_identifier AS spatial_id,
           ze.valid_from
    FROM SCHEMANAME.spatial_plan sp
             INNER JOIN
         SCHEMANAME.zoning_element ze ON sp.planning_object_identifier = ze.fk_spatial_plan
    WHERE sp.valid_from IS NULL
      AND ze.valid_from IS NOT NULL
      AND ze.validity = 1
      AND sp.validity <> 2
      AND (ze.valid_to > Current_Date OR ze.valid_to IS NULL);
    IF EXISTS(SELECT * FROM temp_z_element_s_plan_valid_from) THEN
        UPDATE SCHEMANAME.spatial_plan
        SET valid_from = temp_z_element_s_plan_valid_from.valid_from
        FROM temp_z_element_s_plan_valid_from
        WHERE planning_object_identifier = temp_z_element_s_plan_valid_from.spatial_id;
    END IF;
    DROP TABLE temp_z_element_s_plan_valid_from;

    CREATE TEMPORARY TABLE temp_z_element_s_plan_valid_to AS
    SELECT ze.valid_to,
           sp.planning_object_identifier AS spatial_id
    FROM SCHEMANAME.spatial_plan sp
             INNER JOIN
         SCHEMANAME.zoning_element ze ON sp.planning_object_identifier = ze.fk_spatial_plan
    WHERE (sp.valid_to IS NULL OR sp.valid_to > ze.valid_to)
      AND ze.valid_to IS NOT NULL
      AND ze.validity = 1;
    IF EXISTS(SELECT * FROM temp_z_element_s_plan_valid_to) THEN
        UPDATE SCHEMANAME.spatial_plan
        SET valid_to = temp_z_element_s_plan_valid_to.valid_to
        FROM temp_z_element_s_plan_valid_to
        WHERE planning_object_identifier = temp_z_element_s_plan_valid_to.spatial_id;
    END IF;
    DROP TABLE temp_z_element_s_plan_valid_to;

    CREATE TEMPORARY TABLE temp_z_element_p_space_valid_from AS
    SELECT ps.planning_object_identifier,
           ze.valid_from
    FROM SCHEMANAME.zoning_element ze
             INNER JOIN
         SCHEMANAME.zoning_element_planned_space ze_ps ON ze_ps.zoning_element_id = ze.planning_object_identifier
             INNER JOIN
         SCHEMANAME.planned_space ps ON ze_ps.planned_space_id = ps.planning_object_identifier
    WHERE ze.valid_from IS NOT NULL
      AND ze.validity = 1
      AND ps.valid_from IS NULL
      AND ps.validity <> 2;
    IF exists(SELECT * FROM temp_z_element_p_space_valid_from) THEN
        UPDATE SCHEMANAME.planned_space ps
        SET valid_from = temp_z_element_p_space_valid_from.valid_from
        FROM temp_z_element_p_space_valid_from
        WHERE ps.planning_object_identifier =
              temp_z_element_p_space_valid_from.planning_object_identifier;
    END IF;
    DROP TABLE temp_z_element_p_space_valid_from;

    CREATE TEMPORARY TABLE temp_z_element_p_space_valid_to AS
    SELECT ps.planning_object_identifier,
           ze.valid_to
    FROM SCHEMANAME.zoning_element ze
             INNER JOIN
         SCHEMANAME.zoning_element_planned_space ze_ps ON ze_ps.zoning_element_id = ze.planning_object_identifier
             INNER JOIN
         SCHEMANAME.planned_space ps ON ze_ps.planned_space_id = ps.planning_object_identifier
    WHERE ze.valid_to IS NOT NULL
      AND (ps.valid_to IS NULL OR ps.valid_to > ze.valid_to)
      AND ze.validity = 1;
    IF exists(SELECT * FROM temp_z_element_p_space_valid_to) THEN
        UPDATE SCHEMANAME.planned_space
        SET valid_to = temp_z_element_p_space_valid_to.valid_to
        FROM temp_z_element_p_space_valid_to
        WHERE planning_object_identifier =
              temp_z_element_p_space_valid_to.planning_object_identifier;
    END IF;
    DROP TABLE temp_z_element_p_space_valid_to;
    RETURN NULL;
END;
$BODY$;


create trigger inherit_validity
    after insert or update
        of valid_from, valid_to
    on SCHEMANAME.spatial_plan
    when (pg_trigger_depth() < 1)
execute procedure SCHEMANAME.inherit_validity();

create trigger inherit_validity
    after insert
    on SCHEMANAME.zoning_element
execute procedure SCHEMANAME.inherit_validity();

create trigger inherit_validity
    after insert
    on SCHEMANAME.planned_space
execute procedure SCHEMANAME.inherit_validity();

GRANT EXECUTE ON FUNCTION SCHEMANAME.inherit_validity() TO qgis_editor;

GRANT EXECUTE ON FUNCTION SCHEMANAME.inherit_validity() TO qgis_admin;

-- CREATE update_validity TRIGGER

CREATE FUNCTION "SCHEMANAME".update_validity()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
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
    LANGUAGE 'sql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
UPDATE SCHEMANAME.spatial_plan sp
SET validity = 1
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


grant execute on function SCHEMANAME.refresh_validity() to qgis_admin;

grant execute on function SCHEMANAME.refresh_validity() to qgis_editor;