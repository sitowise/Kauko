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

CREATE OR REPLACE FUNCTION "SCHEMANAME".delete_geom_relations() RETURNS trigger
    LANGUAGE plpgsql
AS
$$
BEGIN
    IF (tg_table_name = 'spatial_plan') THEN
        UPDATE SCHEMANAME.zoning_element
        SET spatial_plan = NULL
        WHERE spatial_plan = old.local_id;
        RETURN new;
    END IF;

    IF (tg_table_name = 'zoning_element') THEN
        DELETE
        FROM SCHEMANAME.zoning_element_planned_space
        WHERE zoning_element_local_id = old.local_id;
        DELETE
        FROM SCHEMANAME.zoning_element_plan_detail_line
        WHERE zoning_element_local_id = old.local_id;
        DELETE
        FROM SCHEMANAME.zoning_element_describing_line
        WHERE zoning_element_local_id = old.local_id;
        DELETE
        FROM SCHEMANAME.zoning_element_describing_text
        WHERE zoning_element_local_id = old.local_id;
        new.spatial_plan := NULL;
        RETURN new;
    END IF;

    IF (tg_table_name = 'planned_space') THEN
        DELETE
        FROM SCHEMANAME.zoning_element_planned_space
        WHERE planned_space_local_id = old.local_id;
        DELETE
        FROM SCHEMANAME.planned_space_plan_detail_line
        WHERE planned_space_local_id = old.local_id;
        RETURN new;
    END IF;

    IF (tg_table_name = 'planning_detail_line') THEN
        DELETE
        FROM SCHEMANAME.zoning_element_plan_detail_line
        WHERE planning_detail_line_local_id = old.local_id;
        DELETE
        FROM SCHEMANAME.planned_space_plan_detail_line
        WHERE planning_detail_line_local_id = old.local_id;
        RETURN new;
    END IF;

    IF (tg_table_name = 'describing_line') THEN
        DELETE
        FROM SCHEMANAME.zoning_element_describing_line
        WHERE describing_line_id = old.identifier;
        RETURN new;
    END IF;

    IF (tg_table_name = 'describing_text') THEN
        DELETE
        FROM SCHEMANAME.zoning_element_describing_text
        WHERE describing_text_id = old.identifier;
        RETURN new;
    END IF;

    RETURN new;
END;
$$;

COMMENT ON FUNCTION "SCHEMANAME".delete_geom_relations() IS 'Deletes old relations when updating item geom column before calculating new ones using geom_relations() trigger';

CREATE OR REPLACE TRIGGER delete_geom_relations
    BEFORE UPDATE OF geom
    ON SCHEMANAME.spatial_plan
    FOR EACH ROW
    WHEN (old.geom IS DISTINCT FROM new.geom)
EXECUTE PROCEDURE SCHEMANAME.delete_geom_relations();

CREATE OR REPLACE TRIGGER delete_geom_relations
    BEFORE UPDATE OF geom
    ON SCHEMANAME.zoning_element
    FOR EACH ROW
    WHEN (old.geom IS DISTINCT FROM new.geom)
EXECUTE PROCEDURE SCHEMANAME.delete_geom_relations();

CREATE OR REPLACE TRIGGER delete_geom_relations
    BEFORE UPDATE OF geom
    ON SCHEMANAME.planned_space
    FOR EACH ROW
    WHEN (old.geom IS DISTINCT FROM new.geom)
EXECUTE PROCEDURE SCHEMANAME.delete_geom_relations();

CREATE OR REPLACE TRIGGER delete_geom_relations
    BEFORE UPDATE OF geom
    ON SCHEMANAME.planning_detail_line
    FOR EACH ROW
    WHEN (old.geom IS DISTINCT FROM new.geom)
EXECUTE PROCEDURE SCHEMANAME.delete_geom_relations();

CREATE OR REPLACE TRIGGER delete_geom_relations
    BEFORE UPDATE OF geom
    ON SCHEMANAME.describing_line
    FOR EACH ROW
    WHEN (old.geom IS DISTINCT FROM new.geom)
EXECUTE PROCEDURE SCHEMANAME.delete_geom_relations();

CREATE OR REPLACE TRIGGER delete_geom_relations
    BEFORE UPDATE OF geom
    ON SCHEMANAME.describing_text
    FOR EACH ROW
    WHEN (old.geom IS DISTINCT FROM new.geom)
EXECUTE PROCEDURE SCHEMANAME.delete_geom_relations();

-- CREATE geom_relations TRIGGER

CREATE FUNCTION "SCHEMANAME".geom_relations() RETURNS trigger
    LANGUAGE plpgsql
AS $BODY$
BEGIN
  IF TG_OP = 'INSERT' THEN
    IF TG_TABLE_NAME IN ('spatial_plan', 'zoning_element') THEN
      UPDATE SCHEMANAME.zoning_element ze
      SET spatial_plan = sp.local_id
      FROM SCHEMANAME.spatial_plan sp
      WHERE st_contains(st_buffer(sp.geom, 1), ze.geom)
        AND sp.validity = 4
        AND ze.spatial_plan IS NULL
        AND ze.local_id IN (
          SELECT ze.local_id
          FROM SCHEMANAME.zoning_element ze
          WHERE ze.spatial_plan IS NULL
        );
    END IF;

    IF TG_TABLE_NAME IN ('zoning_element', 'planned_space') THEN
      INSERT INTO SCHEMANAME.zoning_element_planned_space (zoning_element_local_id, planned_space_local_id)
      SELECT ze.local_id, ps.local_id
      FROM SCHEMANAME.zoning_element ze
        INNER JOIN SCHEMANAME.planned_space ps ON
          st_overlaps(
            st_buffer(ze.geom, 0.1::DOUBLE PRECISION), ps.geom
          )
          OR
          st_contains(st_buffer(ze.geom, 0.1::DOUBLE PRECISION), ps.geom)
      WHERE ze.validity = 4
      AND NOT EXISTS (
        SELECT 1
        FROM SCHEMANAME.zoning_element_planned_space
        WHERE planned_space_id = ps.local_id
      );
    END IF;

    IF (tg_table_name IN ('zoning_element', 'planning_detail_line')) THEN
      INSERT INTO SCHEMANAME.zoning_element_plan_detail_line (zoning_element_local_id, plan_detail_line_local_id)
      SELECT DISTINCT
        ze.local_id AS zoning_id,
        pdl.local_id AS plan_detail_line_id
      FROM SCHEMANAME.zoning_element ze
        INNER JOIN SCHEMANAME.planning_detail_line pdl
          ON st_intersects(ze.geom, pdl.geom)
      WHERE ze.validity = 4 AND
            NOT EXISTS (
              SELECT 1
              FROM SCHEMANAME.zoning_element ze
              WHERE ze.validity <> 4 AND
                    ze.local_id = zoning_id
            );
      END IF;

      IF (tg_table_name IN ('zoning_element', 'describing_line')) THEN
        WITH z_element_describing_line AS (
          SELECT
            ze.local_id as zoning_id,
            dl.identifier as describing_line_id
          FROM SCHEMANAME.zoning_element ze
            INNER JOIN
              SCHEMANAME.describing_line dl
            ON st_intersects(ze.geom, dl.geom) AND ze.validity = 4
        )
        INSERT
        INTO SCHEMANAME.zoning_element_describing_line (zoning_element_local_id, describing_line_id)
        SELECT
          z_element_describing_line.zoning_id,
          z_element_describing_line.describing_line_id
        FROM z_element_describing_line
        WHERE NOT EXISTS (
          SELECT 1
          FROM SCHEMANAME.zoning_element_describing_line ze_dl
          WHERE ze_dl.zoning_element_local_id = z_element_describing_line.zoning_id
            AND ze_dl.describing_line_id = z_element_describing_line.describing_line_id
        );
      END IF;

        IF (tg_table_name IN ('zoning_element', 'describing_text')) THEN
          INSERT INTO SCHEMANAME.zoning_element_describing_text (zoning_element_local_id, describing_text_id)
          SELECT
              ze.local_id as zoning_id,
              dt.identifier as describing_text_id
          FROM SCHEMANAME.zoning_element ze
          INNER JOIN
              SCHEMANAME.describing_text dt ON st_intersects(ze.geom, dt.geom)
          WHERE
              ze.validity = 4
              AND NOT EXISTS (
                  SELECT 1
                  FROM SCHEMANAME.zoning_element ze1
                  WHERE
                      ze1.local_id = ze.local_id
                      AND ze1.validity <> 4
              )
              AND NOT EXISTS (
                  SELECT 1
                  FROM SCHEMANAME.zoning_element_describing_text ze_dt
                  WHERE
                      ze_dt.zoning_element_local_id = ze.local_id
                      AND ze_dt.describing_text_id = dt.identifier
              );
        END IF;

        IF (tg_table_name IN ('planned_space', 'planning_detail_line')) THEN
          WITH planned_space_plan_detail_line AS (
            SELECT
                ps.local_id as planned_space_id,
                pdl.local_id as plan_detail_line_id
            FROM SCHEMANAME.planning_detail_line pdl
            INNER JOIN SCHEMANAME.planned_space ps
            ON st_intersects(pdl.geom, ps.geom)
            WHERE ps.validity = 4
          )
          INSERT INTO SCHEMANAME.planned_space_plan_detail_line (planned_space_local_id, plan_detail_line_local_id)
          SELECT
            ps_pdl.planned_space_id,
            ps_pdl.plan_detail_line_id
          FROM planned_space_plan_detail_line ps_pdl
          WHERE ps_pdl.planned_space_id NOT IN (
            SELECT local_id
            FROM SCHEMANAME.planned_space
            WHERE validity <> 4
          );
        END IF;
    END IF;
    RETURN NULL;
END;
$BODY$;


GRANT EXECUTE ON FUNCTION SCHEMANAME.geom_relations() TO qgis_editor;

GRANT EXECUTE ON FUNCTION SCHEMANAME.geom_relations() TO qgis_admin;

CREATE TRIGGER geom_relations
    AFTER INSERT OR UPDATE OF geom
    ON SCHEMANAME.spatial_plan
    FOR EACH STATEMENT
    EXECUTE PROCEDURE SCHEMANAME.geom_relations();

CREATE TRIGGER geom_relations
    AFTER INSERT OR UPDATE OF geom
    ON SCHEMANAME.zoning_element
    FOR EACH STATEMENT
    EXECUTE PROCEDURE SCHEMANAME.geom_relations();

CREATE TRIGGER geom_relations
    AFTER INSERT OR UPDATE OF geom
    ON SCHEMANAME.planned_space
    FOR EACH STATEMENT
    EXECUTE PROCEDURE SCHEMANAME.geom_relations();

CREATE TRIGGER geom_relations
    AFTER INSERT OR UPDATE OF geom
    ON SCHEMANAME.planning_detail_line
    FOR EACH STATEMENT
    EXECUTE PROCEDURE SCHEMANAME.geom_relations();

CREATE TRIGGER geom_relations
    AFTER INSERT OR UPDATE OF geom
    ON SCHEMANAME.planning_detail_point
    FOR EACH STATEMENT
    EXECUTE PROCEDURE SCHEMANAME.geom_relations();

CREATE TRIGGER geom_relations
    AFTER INSERT OR UPDATE OF geom
    ON SCHEMANAME.describing_line
    FOR EACH STATEMENT
    EXECUTE PROCEDURE SCHEMANAME.geom_relations();

CREATE TRIGGER geom_relations
    AFTER INSERT OR UPDATE OF geom
    ON SCHEMANAME.describing_text
    FOR EACH STATEMENT
    EXECUTE PROCEDURE SCHEMANAME.geom_relations();