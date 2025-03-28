-- Change column names for planned_space_plan_detail_line
-------------------------------------------------------------------------

ALTER TABLE $SCHEMANAME$.planned_space_plan_detail_line DROP CONSTRAINT planned_space_plan_detail_line_planned_space_local_id_fkey;
ALTER TABLE $SCHEMANAME$.planned_space_plan_detail_line DROP CONSTRAINT planned_space_plan_detail_line_planning_detail_line_fkey;

ALTER TABLE $SCHEMANAME$.planned_space_plan_detail_line RENAME COLUMN planned_space_local_id TO fk_planned_space;
ALTER TABLE $SCHEMANAME$.planned_space_plan_detail_line RENAME COLUMN planning_detail_line_local_id TO fk_planning_detail_line;

ALTER TABLE $SCHEMANAME$.planned_space_plan_detail_line
    ADD CONSTRAINT planned_space_plan_detail_line_planned_space_local_id_fkey FOREIGN KEY (fk_planned_space)
        REFERENCES $SCHEMANAME$.planned_space (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    ADD CONSTRAINT planned_space_plan_detail_line_planning_detail_line_fkey FOREIGN KEY (fk_planning_detail_line)
        REFERENCES $SCHEMANAME$.planning_detail_line (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED;



-- Update function geom_relations: fix referenced column names
-- for planned_space_plan_detail_line and planned_space_plan_detail_point
-------------------------------------------------------------------------

DROP TRIGGER geom_relations ON $SCHEMANAME$.spatial_plan;
DROP TRIGGER geom_relations ON $SCHEMANAME$.describing_line;
DROP TRIGGER geom_relations ON $SCHEMANAME$.describing_text;
DROP TRIGGER geom_relations ON $SCHEMANAME$.planned_space;
DROP TRIGGER geom_relations ON $SCHEMANAME$.zoning_element;
DROP TRIGGER geom_relations ON $SCHEMANAME$.planning_detail_point;
DROP TRIGGER geom_relations ON $SCHEMANAME$.planning_detail_line;

-- FUNCTION: $SCHEMANAME$.geom_relations()

DROP FUNCTION IF EXISTS $SCHEMANAME$.geom_relations();

CREATE OR REPLACE FUNCTION $SCHEMANAME$.geom_relations()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
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

  IF TG_TABLE_NAME IN ('zoning_element', 'planned_space') THEN
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

  IF (tg_table_name IN ('zoning_element', 'planning_detail_line')) THEN
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

  IF (tg_table_name IN ('zoning_element', 'planning_detail_point')) THEN
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

    IF (tg_table_name IN ('zoning_element', 'describing_line')) THEN
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

      IF (tg_table_name IN ('zoning_element', 'describing_text')) THEN
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

      IF (tg_table_name IN ('planned_space', 'planning_detail_line')) THEN
        INSERT INTO $SCHEMANAME$.planned_space_plan_detail_line (fk_planned_space, fk_planning_detail_line)
        SELECT DISTINCT
            ps.local_id,
            pdl.local_id
        FROM $SCHEMANAME$.planned_space ps
            INNER JOIN $SCHEMANAME$.planning_detail_line pdl
                ON st_intersects(ps.geom, pdl.geom)
        WHERE ps.is_active
            AND pdl.is_active
            AND ps.lifecycle_status IN ('01', '02', '03', '04', '05')
            AND pdl.lifecycle_status IN ('01', '02', '03', '04', '05')
            AND NOT EXISTS (
                SELECT 1
                FROM $SCHEMANAME$.planned_space_plan_detail_line ps_pdl
                WHERE ps_pdl.fk_planning_detail_line = pdl.local_id AND
                    ps_pdl.fk_planned_space = ps.local_id
            );
      END IF;

      IF (tg_table_name IN ('planned_space', 'planning_detail_point')) THEN
        INSERT INTO $SCHEMANAME$.planned_space_plan_detail_point (fk_planned_space, fk_planning_detail_point)
        SELECT DISTINCT
          ps.local_id,
          pdp.local_id
        FROM $SCHEMANAME$.planned_space ps
          INNER JOIN $SCHEMANAME$.planning_detail_point pdp
            ON st_intersects(ps.geom, pdp.geom)
        WHERE ps.is_active
            AND pdp.is_active
            AND ps.lifecycle_status IN ('01', '02', '03', '04', '05')
            AND pdp.lifecycle_status IN ('01', '02', '03', '04', '05')
            AND NOT EXISTS (
                SELECT 1
                FROM $SCHEMANAME$.planned_space_plan_detail_point ps_pdp
                WHERE ps_pdp.fk_planning_detail_point = pdp.local_id AND
                      ps_pdp.fk_planned_space = ps.local_id
          );
      END IF;
    RETURN NULL;
END;
$BODY$;

-- Trigger: geom_relations

-- DROP TRIGGER IF EXISTS geom_relations ON $SCHEMANAME$.spatial_plan;

CREATE OR REPLACE TRIGGER geom_relations
    AFTER INSERT OR UPDATE OF geom
    ON $SCHEMANAME$.spatial_plan
    FOR EACH STATEMENT
    EXECUTE FUNCTION $SCHEMANAME$.geom_relations();

-- Trigger: geom_relations

-- DROP TRIGGER IF EXISTS geom_relations ON $SCHEMANAME$.describing_line;

CREATE OR REPLACE TRIGGER geom_relations
    AFTER INSERT OR UPDATE OF geom
    ON $SCHEMANAME$.describing_line
    FOR EACH STATEMENT
    EXECUTE FUNCTION $SCHEMANAME$.geom_relations();

-- Trigger: geom_relations

-- DROP TRIGGER IF EXISTS geom_relations ON $SCHEMANAME$.describing_text;

CREATE OR REPLACE TRIGGER geom_relations
    AFTER INSERT OR UPDATE OF geom
    ON $SCHEMANAME$.describing_text
    FOR EACH STATEMENT
    EXECUTE FUNCTION $SCHEMANAME$.geom_relations();

-- Trigger: geom_relations

-- DROP TRIGGER IF EXISTS geom_relations ON $SCHEMANAME$.planned_space;

CREATE OR REPLACE TRIGGER geom_relations
    AFTER INSERT OR UPDATE OF geom
    ON $SCHEMANAME$.planned_space
    FOR EACH STATEMENT
    EXECUTE FUNCTION $SCHEMANAME$.geom_relations();

-- Trigger: geom_relations

-- DROP TRIGGER IF EXISTS geom_relations ON $SCHEMANAME$.zoning_element;

CREATE OR REPLACE TRIGGER geom_relations
    AFTER INSERT OR UPDATE OF geom
    ON $SCHEMANAME$.zoning_element
    FOR EACH STATEMENT
    EXECUTE FUNCTION $SCHEMANAME$.geom_relations();

-- Trigger: geom_relations

-- DROP TRIGGER IF EXISTS geom_relations ON $SCHEMANAME$.planning_detail_point;

CREATE OR REPLACE TRIGGER geom_relations
    AFTER INSERT OR UPDATE OF geom
    ON $SCHEMANAME$.planning_detail_point
    FOR EACH STATEMENT
    EXECUTE FUNCTION $SCHEMANAME$.geom_relations();

-- Trigger: geom_relations

-- DROP TRIGGER IF EXISTS geom_relations ON $SCHEMANAME$.planning_detail_line;

CREATE OR REPLACE TRIGGER geom_relations
    AFTER INSERT OR UPDATE OF geom
    ON $SCHEMANAME$.planning_detail_line
    FOR EACH STATEMENT
    EXECUTE FUNCTION $SCHEMANAME$.geom_relations();
