-- Drop link tables

DROP TABLE IF EXISTS $SCHEMANAME$.planned_space_plan_detail_line CASCADE;
DROP TABLE IF EXISTS $SCHEMANAME$.planned_space_plan_detail_point CASCADE;

-- Update delete_geom_relations()

CREATE OR REPLACE FUNCTION $SCHEMANAME$.delete_geom_relations()
 RETURNS trigger
 LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
  table_name text;
BEGIN
  table_name := TG_TABLE_NAME;
  CASE table_name
    WHEN 'spatial_plan' THEN
      UPDATE $SCHEMANAME$.zoning_element
      SET spatial_plan = NULL
      WHERE spatial_plan = OLD.local_id;
      RETURN NEW;

    WHEN 'zoning_element' THEN
      DELETE
      FROM $SCHEMANAME$.zoning_element_planned_space
      WHERE zoning_element_local_id = OLD.local_id;
      DELETE
      FROM $SCHEMANAME$.zoning_element_plan_detail_line
      WHERE zoning_element_local_id = OLD.local_id;
      DELETE
      FROM $SCHEMANAME$.zoning_element_plan_detail_point
      WHERE zoning_element_local_id = OLD.local_id;
      DELETE
      FROM $SCHEMANAME$.zoning_element_describing_line
      WHERE zoning_element_local_id = OLD.local_id;
      DELETE
      FROM $SCHEMANAME$.zoning_element_describing_text
      WHERE zoning_element_local_id = OLD.local_id;
      NEW.spatial_plan := NULL;
      RETURN NEW;

    WHEN 'planned_space' THEN
      DELETE
      FROM $SCHEMANAME$.zoning_element_planned_space
      WHERE planned_space_local_id = OLD.local_id;
      RETURN NEW;

    WHEN 'planning_detail_line' THEN
      DELETE
      FROM $SCHEMANAME$.zoning_element_plan_detail_line
      WHERE planning_detail_line_local_id = OLD.local_id;
      RETURN NEW;
    
    WHEN 'planning_detail_point' THEN
      DELETE
      FROM $SCHEMANAME$.zoning_element_plan_detail_point
      WHERE planning_detail_point_local_id = OLD.local_id;
      RETURN NEW;

    WHEN 'describing_line' THEN
      DELETE
      FROM $SCHEMANAME$.zoning_element_describing_line
      WHERE describing_line_id = OLD.id;
      RETURN NEW;
    WHEN 'describing_text' THEN
      DELETE
      FROM $SCHEMANAME$.zoning_element_describing_text
      WHERE describing_text_id = OLD.id;
      RETURN NEW;
    ELSE
      RETURN NEW;
  END CASE;
END;
$BODY$;

-- Update geom_relations()

CREATE OR REPLACE FUNCTION $SCHEMANAME$.geom_relations()
 RETURNS trigger
 LANGUAGE plpgsql
AS $BODY$
DECLARE
    table_name TEXT;
BEGIN
    IF NOT (NEW.is_active) THEN
        RETURN NEW;
    END IF;
    table_name := TG_TABLE_NAME;

    IF table_name IN ('spatial_plan', 'zoning_element') THEN
        UPDATE $SCHEMANAME$.zoning_element ze
        SET spatial_plan = sp.local_id
        FROM $SCHEMANAME$.spatial_plan sp
        WHERE ze.is_active
            AND sp.is_active
            AND st_contains(st_buffer(sp.geom, 1), ze.geom)
            AND sp.lifecycle_status IN ('01', '02', '03', '04', '05')
            AND ze.lifecycle_status IN ('01', '02', '03', '04', '05')
            AND ze.spatial_plan IS NULL;
    END IF;

    IF table_name IN ('zoning_element', 'planned_space') THEN
      INSERT INTO $SCHEMANAME$.zoning_element_planned_space (zoning_element_local_id, planned_space_local_id)
      SELECT DISTINCT ze.local_id, ps.local_id
      FROM $SCHEMANAME$.zoning_element ze
        INNER JOIN $SCHEMANAME$.planned_space ps ON
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
        FROM $SCHEMANAME$.zoning_element_planned_space zeps
        WHERE zeps.planned_space_local_id = ps.local_id AND
              zeps.zoning_element_local_id = ze.local_id
      );
    END IF;

    IF (table_name IN ('zoning_element', 'planning_detail_line')) THEN
      INSERT INTO $SCHEMANAME$.zoning_element_plan_detail_line (zoning_element_local_id, planning_detail_line_local_id)
      SELECT DISTINCT
        ze.local_id,
        pdl.local_id
      FROM $SCHEMANAME$.zoning_element ze
        INNER JOIN $SCHEMANAME$.planning_detail_line pdl
          ON st_intersects(ze.geom, pdl.geom)
      WHERE ze.is_active
          AND pdl.is_active
          AND ze.lifecycle_status IN ('01', '02', '03', '04', '05')
          AND pdl.lifecycle_status IN ('01', '02', '03', '04', '05')
          AND NOT EXISTS (
              SELECT 1
              FROM $SCHEMANAME$.zoning_element_plan_detail_line zepdl
              WHERE zepdl.planning_detail_line_local_id = pdl.local_id AND
                  zepdl.zoning_element_local_id = ze.local_id
        );
    END IF;

    IF (table_name IN ('zoning_element', 'planning_detail_point')) THEN
      INSERT INTO $SCHEMANAME$.zoning_element_plan_detail_point (zoning_element_local_id, planning_detail_point_local_id)
      SELECT DISTINCT
        ze.local_id,
        pdp.local_id
      FROM $SCHEMANAME$.zoning_element ze
        INNER JOIN $SCHEMANAME$.planning_detail_point pdp
          ON st_intersects(ze.geom, pdp.geom)
      WHERE ze.is_active
          AND pdp.is_active
          AND ze.lifecycle_status IN ('01', '02', '03', '04', '05')
          AND pdp.lifecycle_status IN ('01', '02', '03', '04', '05')
          AND NOT EXISTS (
              SELECT 1
              FROM $SCHEMANAME$.zoning_element_plan_detail_point zepdp
              WHERE zepdp.planning_detail_point_local_id = pdp.local_id AND
                    zepdp.zoning_element_local_id = ze.local_id
        );
    END IF;

    IF (table_name IN ('zoning_element', 'describing_line')) THEN
      INSERT INTO $SCHEMANAME$.zoning_element_describing_line (zoning_element_local_id, describing_line_id)
      SELECT DISTINCT
        ze.local_id,
        dl.id
      FROM $SCHEMANAME$.zoning_element ze
        INNER JOIN $SCHEMANAME$.describing_line dl
          ON st_intersects(ze.geom, dl.geom)
      WHERE ze.is_active
        AND dl.is_active
        AND ze.lifecycle_status IN ('01', '02', '03', '04', '05')
        AND dl.lifecycle_status IN ('01', '02', '03', '04', '05')
        AND NOT EXISTS (
          SELECT 1
          FROM $SCHEMANAME$.zoning_element_describing_line zedl
          WHERE zedl.describing_line_id = dl.id AND
                zedl.zoning_element_local_id = ze.local_id
        );
    END IF;

    IF (table_name IN ('zoning_element', 'describing_text')) THEN
      INSERT INTO $SCHEMANAME$.zoning_element_describing_text (zoning_element_local_id, describing_text_id)
      SELECT DISTINCT
        ze.local_id,
        dt.id
      FROM $SCHEMANAME$.zoning_element ze
        INNER JOIN $SCHEMANAME$.describing_text dt
          ON st_intersects(ze.geom, dt.geom)
      WHERE ze.is_active
          AND dt.is_active
          AND ze.lifecycle_status IN ('01', '02', '03', '04', '05')
          AND dt.lifecycle_status IN ('01', '02', '03', '04', '05')
          AND NOT EXISTS (
              SELECT 1
              FROM $SCHEMANAME$.zoning_element_describing_text zedt
              WHERE zedt.describing_text_id = dt.id AND
                  zedt.zoning_element_local_id = ze.local_id
        );
    END IF;
    RETURN NULL;
END;
$BODY$;
