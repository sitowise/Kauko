ALTER TABLE SCHEMANAME.zoning_element_describing_line
  ADD COLUMN zoning_element_local_id VARCHAR;

UPDATE SCHEMANAME.zoning_element_describing_line
  SET zoning_element_local_id = subquery.local_id
  FROM (
    SELECT local_id, producer_specific_id
    FROM SCHEMANAME.zoning_element
  ) AS subquery
  WHERE subquery.producer_specific_id = zoning_element_describing_line.zoning_id;

ALTER TABLE SCHEMANAME.zoning_element_describing_line
  DROP COLUMN zoning_id CASCADE;

ALTER TABLE SCHEMANAME.zoning_element_describing_line
  ADD CONSTRAINT zoning_element_fk
  FOREIGN KEY (zoning_element_local_id)
  REFERENCES SCHEMANAME.zoning_element (local_id);

ALTER TABLE SCHEMANAME.zoning_element_describing_text
  ADD COLUMN zoning_element_local_id VARCHAR;

UPDATE SCHEMANAME.zoning_element_describing_text
  SET zoning_element_local_id = subquery.local_id
  FROM (
    SELECT local_id, producer_specific_id
    FROM SCHEMANAME.zoning_element
  ) AS subquery
  WHERE subquery.producer_specific_id = zoning_element_describing_text.zoning_id;

ALTER TABLE SCHEMANAME.zoning_element_describing_text
  DROP COLUMN zoning_id CASCADE;

ALTER TABLE SCHEMANAME.zoning_element_describing_text
  ADD CONSTRAINT zoning_element_fk
  FOREIGN KEY (zoning_element_local_id)
  REFERENCES SCHEMANAME.zoning_element (local_id);

-- CREATE delete_geom_relations TRIGGER

CREATE OR REPLACE FUNCTION "SCHEMANAME".delete_geom_relations()
RETURNS TRIGGER
LANGUAGE plpgsql
AS
$$
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
$$;

COMMENT ON FUNCTION "SCHEMANAME".delete_geom_relations() IS 'Deletes old relations when updating item geom column before calculating new ones using geom_relations() trigger';

DROP TRIGGER IF EXISTS delete_geom_relations ON SCHEMANAME.spatial_plan;
CREATE TRIGGER delete_geom_relations
  BEFORE UPDATE OF geom
    ON SCHEMANAME.spatial_plan
  FOR EACH ROW
  WHEN (OLD.geom IS DISTINCT FROM NEW.geom)
  EXECUTE PROCEDURE SCHEMANAME.delete_geom_relations();

DROP TRIGGER IF EXISTS delete_geom_relations ON SCHEMANAME.zoning_element;
CREATE TRIGGER delete_geom_relations
  BEFORE UPDATE OF geom
  ON SCHEMANAME.zoning_element
  FOR EACH ROW
  WHEN (old.geom IS DISTINCT FROM new.geom)
  EXECUTE PROCEDURE SCHEMANAME.delete_geom_relations();

DROP TRIGGER IF EXISTS delete_geom_relations ON SCHEMANAME.planned_space;
CREATE TRIGGER delete_geom_relations
  BEFORE UPDATE OF geom
  ON SCHEMANAME.planned_space
  FOR EACH ROW
  WHEN (old.geom IS DISTINCT FROM new.geom)
  EXECUTE PROCEDURE SCHEMANAME.delete_geom_relations();

DROP TRIGGER IF EXISTS delete_geom_relations ON SCHEMANAME.planning_detail_line;
CREATE TRIGGER delete_geom_relations
  BEFORE UPDATE OF geom
  ON SCHEMANAME.planning_detail_line
  FOR EACH ROW
  WHEN (old.geom IS DISTINCT FROM new.geom)
  EXECUTE PROCEDURE SCHEMANAME.delete_geom_relations();

DROP TRIGGER IF EXISTS delete_geom_relations ON SCHEMANAME.describing_line;
CREATE TRIGGER delete_geom_relations
  BEFORE UPDATE OF geom
  ON SCHEMANAME.describing_line
  FOR EACH ROW
  WHEN (old.geom IS DISTINCT FROM new.geom)
  EXECUTE PROCEDURE SCHEMANAME.delete_geom_relations();

DROP TRIGGER IF EXISTS delete_geom_relations ON SCHEMANAME.describing_text;
CREATE TRIGGER delete_geom_relations
  BEFORE UPDATE OF geom
  ON SCHEMANAME.describing_text
  FOR EACH ROW
  WHEN (old.geom IS DISTINCT FROM new.geom)
  EXECUTE PROCEDURE SCHEMANAME.delete_geom_relations();

-- CREATE geom_relations TRIGGER

CREATE OR REPLACE FUNCTION "SCHEMANAME".geom_relations() RETURNS trigger
    LANGUAGE plpgsql
AS $BODY$
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
    INSERT INTO SCHEMANAME.zoning_element_plan_detail_line (zoning_element_local_id, plan_detail_line_local_id)
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
        WHERE zepdl.plan_detail_line_local_id = pdl.local_id AND
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
        INSERT INTO SCHEMANAME.planned_space_plan_detail_line (planned_space_local_id, plan_detail_line_local_id)
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
            WHERE ps_pdl.plan_detail_line_local_id = pdl.local_id AND
                  ps_pdl.planned_space_local_id = ps.local_id
          );
      END IF;
    RETURN NULL;
END;
$BODY$;


GRANT EXECUTE ON FUNCTION SCHEMANAME.geom_relations() TO qgis_editor;

GRANT EXECUTE ON FUNCTION SCHEMANAME.geom_relations() TO qgis_admin;

DROP TRIGGER IF EXISTS geom_relations ON SCHEMANAME.spatial_plan;
CREATE TRIGGER geom_relations
    AFTER INSERT OR UPDATE OF geom
    ON SCHEMANAME.spatial_plan
    FOR EACH STATEMENT
    EXECUTE PROCEDURE SCHEMANAME.geom_relations();

DROP TRIGGER IF EXISTS geom_relations ON SCHEMANAME.zoning_element;
CREATE TRIGGER geom_relations
    AFTER INSERT OR UPDATE OF geom
    ON SCHEMANAME.zoning_element
    FOR EACH STATEMENT
    EXECUTE PROCEDURE SCHEMANAME.geom_relations();

DROP TRIGGER IF EXISTS geom_relations ON SCHEMANAME.planned_space;
CREATE TRIGGER geom_relations
    AFTER INSERT OR UPDATE OF geom
    ON SCHEMANAME.planned_space
    FOR EACH STATEMENT
    EXECUTE PROCEDURE SCHEMANAME.geom_relations();

DROP TRIGGER IF EXISTS geom_relations ON SCHEMANAME.planning_detail_line;
CREATE TRIGGER geom_relations
    AFTER INSERT OR UPDATE OF geom
    ON SCHEMANAME.planning_detail_line
    FOR EACH STATEMENT
    EXECUTE PROCEDURE SCHEMANAME.geom_relations();

DROP TRIGGER IF EXISTS geom_relations ON SCHEMANAME.describing_line;
CREATE TRIGGER geom_relations
    AFTER INSERT OR UPDATE OF geom
    ON SCHEMANAME.describing_line
    FOR EACH STATEMENT
    EXECUTE PROCEDURE SCHEMANAME.geom_relations();

DROP TRIGGER IF EXISTS geom_relations ON SCHEMANAME.describing_text;
CREATE TRIGGER geom_relations
    AFTER INSERT OR UPDATE OF geom
    ON SCHEMANAME.describing_text
    FOR EACH STATEMENT
    EXECUTE PROCEDURE SCHEMANAME.geom_relations();