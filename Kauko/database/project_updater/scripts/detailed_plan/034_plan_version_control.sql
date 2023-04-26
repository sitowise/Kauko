CREATE TABLE SCHEMANAME.spatial_plan_metadata (
    id SERIAL PRIMARY KEY,
    plan_id TEXT UNIQUE NOT NULL,
    "name" JSONB NOT NULL CHECK (check_language_string(name)),
    created TIMESTAMP NOT NULL DEFAULT NOW()
);


-- DROP wrong identity_id unique constraints
ALTER TABLE SCHEMANAME.spatial_plan
    DROP CONSTRAINT IF EXISTS spatial_plan_identity_id_key;
ALTER TABLE SCHEMANAME."document"
    DROP CONSTRAINT IF EXISTS document_identity_id_key;
ALTER TABLE SCHEMANAME.participation_and_evalution_plan
    DROP CONSTRAINT IF EXISTS participation_and_evalution_plan_identity_id_key;
ALTER TABLE SCHEMANAME.planned_space
    DROP CONSTRAINT IF EXISTS planned_space_identity_id_key;
ALTER TABLE SCHEMANAME.planner
    DROP CONSTRAINT IF EXISTS planner_identity_id_key;
ALTER TABLE SCHEMANAME.planning_detail_line
    DROP CONSTRAINT IF EXISTS planning_detail_line_identity_id_key;
ALTER TABLE SCHEMANAME.spatial_plan_commentary
    DROP CONSTRAINT IF EXISTS spatial_plan_commentary_identity_id_key;
ALTER TABLE SCHEMANAME.zoning_element
    DROP CONSTRAINT IF EXISTS zoning_element_identity_id_key;

ALTER TABLE SCHEMANAME.spatial_plan
    ADD COLUMN is_active BOOLEAN DEFAULT TRUE NOT NULL,
    ADD COLUMN version_name TEXT;

UPDATE SCHEMANAME.spatial_plan
    SET plan_id = uuid_generate_v4()::text
    WHERE plan_id IS NULL;

INSERT INTO SCHEMANAME.spatial_plan_metadata (plan_id, "name", created)
    SELECT DISTINCT
        plan_id,
        "name",
        created
    FROM SCHEMANAME.spatial_plan;

UPDATE SCHEMANAME.spatial_plan sp
    SET version_name = "name" ->> 'fin';

ALTER TABLE SCHEMANAME.spatial_plan
    ALTER COLUMN plan_id SET NOT NULL,
    ALTER COLUMN is_active SET NOT NULL,
    ALTER COLUMN version_name SET NOT NULL,
    ALTER COLUMN plan_id SET DEFAULT uuid_generate_v4()::text,
    ADD CONSTRAINT spatial_plan_metadata_id_fk FOREIGN KEY (plan_id)
        REFERENCES SCHEMANAME.spatial_plan_metadata (plan_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
        DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE SCHEMANAME.zoning_element
    ADD COLUMN is_active BOOLEAN DEFAULT TRUE;
ALTER TABLE SCHEMANAME.planned_space
    ADD COLUMN is_active BOOLEAN DEFAULT TRUE;
ALTER TABLE SCHEMANAME.planning_detail_line
    ADD COLUMN is_active BOOLEAN DEFAULT TRUE;
ALTER TABLE SCHEMANAME.describing_line
    ADD COLUMN is_active BOOLEAN DEFAULT TRUE;
ALTER TABLE SCHEMANAME.describing_text
    ADD COLUMN is_active BOOLEAN DEFAULT TRUE;

CREATE OR REPLACE FUNCTION SCHEMANAME.update_active_plan(p_old_active_plan_local_id varchar, p_new_active_plan_local_id varchar)
RETURNS void AS $$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM SCHEMANAME.spatial_plan WHERE local_id = p_old_active_plan_local_id LIMIT 1) THEN
        RAISE EXCEPTION 'Old active plan does not exist';
    END IF;

    IF NOT EXISTS(SELECT 1 FROM SCHEMANAME.spatial_plan WHERE local_id = p_new_active_plan_local_id LIMIT 1) THEN
        RAISE EXCEPTION 'New active plan does not exist';
    END IF;

    IF NOT (SELECT is_active FROM SCHEMANAME.spatial_plan WHERE local_id = p_old_active_plan_local_id LIMIT 1) THEN
        RAISE EXCEPTION 'Old active plan is not active';
    END IF;

    -- Deactivate old active plan
    UPDATE SCHEMANAME.spatial_plan
    SET is_active = FALSE
    WHERE local_id = p_old_active_plan_local_id;

    UPDATE SCHEMANAME.zoning_element
    SET is_active = FALSE
    WHERE spatial_plan = p_old_active_plan_local_id;

    UPDATE SCHEMANAME.planned_space ps
    SET is_active = FALSE
    FROM SCHEMANAME.zoning_element_planned_space zeps
    JOIN SCHEMANAME.zoning_element ze
        ON ze.local_id = zeps.zoning_element_local_id
    WHERE ze.spatial_plan = p_old_active_plan_local_id
    AND ps.local_id = zeps.planned_space_local_id;

    UPDATE SCHEMANAME.planning_detail_line pdl
    SET is_active = FALSE
    FROM SCHEMANAME.zoning_element_plan_detail_line zepdl
    JOIN SCHEMANAME.zoning_element ze
        ON ze.local_id = zepdl.zoning_element_local_id
    WHERE ze.spatial_plan = p_old_active_plan_local_id
    AND pdl.local_id = zepdl.planning_detail_line_local_id;

    UPDATE SCHEMANAME.describing_line dl
    SET is_active = FALSE
    FROM SCHEMANAME.zoning_element_describing_line zedl
    JOIN SCHEMANAME.zoning_element ze
        ON ze.local_id = zedl.zoning_element_local_id
    WHERE ze.spatial_plan = p_old_active_plan_local_id
    AND dl.identifier = zedl.describing_line_id;

    UPDATE SCHEMANAME.describing_text dt
    SET is_active = FALSE
    FROM SCHEMANAME.zoning_element_describing_text zedt
    JOIN SCHEMANAME.zoning_element ze
        ON ze.local_id = zedt.zoning_element_local_id
    WHERE ze.spatial_plan = p_old_active_plan_local_id
    AND dt.identifier = zedt.describing_text_id;

    -- Activate new plan
    UPDATE SCHEMANAME.spatial_plan
    SET is_active = TRUE
    WHERE local_id = p_new_active_plan_local_id;

    UPDATE SCHEMANAME.zoning_element
    SET is_active = TRUE
    WHERE spatial_plan = p_new_active_plan_local_id;

    UPDATE SCHEMANAME.planned_space ps
    SET is_active = TRUE
    FROM SCHEMANAME.zoning_element_planned_space zeps
    JOIN SCHEMANAME.zoning_element ze
        ON ze.local_id = zeps.zoning_element_local_id
    WHERE ze.spatial_plan = p_new_active_plan_local_id
    AND ps.local_id = zeps.planned_space_local_id;

    UPDATE SCHEMANAME.planning_detail_line pdl
    SET is_active = TRUE
    FROM SCHEMANAME.zoning_element_plan_detail_line zepdl
    JOIN SCHEMANAME.zoning_element ze
        ON ze.local_id = zepdl.zoning_element_local_id
    WHERE ze.spatial_plan = p_new_active_plan_local_id
    AND pdl.local_id = zepdl.planning_detail_line_local_id;

    UPDATE SCHEMANAME.describing_line dl
    SET is_active = TRUE
    FROM SCHEMANAME.zoning_element_describing_line zedl
    JOIN SCHEMANAME.zoning_element ze
        ON ze.local_id = zedl.zoning_element_local_id
    WHERE ze.spatial_plan = p_new_active_plan_local_id
    AND dl.identifier = zedl.describing_line_id;

    UPDATE SCHEMANAME.describing_text dt
    SET is_active = TRUE
    FROM SCHEMANAME.zoning_element_describing_text zedt
    JOIN SCHEMANAME.zoning_element ze
        ON ze.local_id = zedt.zoning_element_local_id
    WHERE ze.spatial_plan = p_new_active_plan_local_id
    AND dt.identifier = zedt.describing_text_id;
END;
$$ LANGUAGE plpgsql;

CREATE UNIQUE INDEX active_version_idx
ON SCHEMANAME.spatial_plan (identity_id)
WHERE is_active;

CREATE OR REPLACE FUNCTION SCHEMANAME.validate_spatial_plan_topology()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    IF (NEW.is_active = FALSE) THEN
        RETURN NEW;
    END IF;
    IF EXISTS (
        SELECT 1
        FROM SCHEMANAME.spatial_plan AS sp
        WHERE sp.is_active
            AND sp.identifier <> new.identifier
            AND sp.geom && NEW.geom
            AND NOT ST_Relate(ST_Buffer(sp.geom, -0.1), ST_Buffer(NEW.geom, -0.1), 'FF*******')
    ) THEN
    RAISE EXCEPTION 'New % geometry with id % overlaps with existing spatial plan geometry', TG_TABLE_NAME, NEW.identifier;
    END IF;
  RETURN NEW;
END;
$function$;

CREATE OR REPLACE FUNCTION SCHEMANAME.validate_zoning_element_topology()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    IF (NEW.is_active = FALSE) THEN
        RETURN NEW;
    END IF;
    IF EXISTS (
        SELECT 1
        FROM SCHEMANAME.zoning_element AS ze
        WHERE ze.is_active
            AND ze.identifier <> new.identifier
            AND ze.geom && NEW.geom
            AND NOT ST_Relate(ST_Buffer(ze.geom, -0.1), ST_Buffer(NEW.geom, -0,1), 'FF*******')
    ) THEN
        RAISE EXCEPTION 'New zoning_element geometry with id % overlaps with existing zoning element geometry', NEW.identifier;
    END IF;
    -- Zoning element geometry must not overlap with spatial plan geometry
    IF EXISTS (
        SELECT 1 FROM SCHEMANAME.spatial_plan sp
        WHERE sp.is_active
            AND ST_Overlaps(sp.geom, ST_Buffer(NEW.geom, -0.1))
    ) THEN
        RAISE EXCEPTION 'Zoning element geometry with identifier % is not contained in spatial plan', NEW.identifier;
    END IF;
    RETURN NEW;
END;
$function$;

CREATE OR REPLACE FUNCTION SCHEMANAME.validate_planned_space_geom()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    IF (NEW.is_active = FALSE) THEN
        RETURN NEW;
    END IF;
    IF EXISTS (
        SELECT 1
        FROM SCHEMANAME.spatial_plan sp
        WHERE sp.is_active
            AND ST_Overlaps(sp.geom, ST_Buffer(NEW.geom, -0.1))
    ) THEN
        RAISE EXCEPTION 'Planned space geometry with identifier % is not contained in spatial plan', NEW.identifier;
    END IF;
    RETURN NEW;
END;
$function$;

CREATE OR REPLACE FUNCTION SCHEMANAME.geom_relations()
    RETURNS trigger
    LANGUAGE plpgsql
AS $function$
DECLARE
    table_name TEXT;
BEGIN
    IF NOT (NEW.is_active) THEN
        RETURN NEW;
    END IF;
    table_name := TG_TABLE_NAME;
    IF table_name IN ('spatial_plan', 'zoning_element') THEN
        UPDATE SCHEMANAME.zoning_element ze
        SET spatial_plan = sp.local_id
        FROM SCHEMANAME.spatial_plan sp
        WHERE ze.is_active
            AND sp.is_active
            AND st_contains(st_buffer(sp.geom, 1), ze.geom)
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
    WHERE ze.is_active
        AND ps.is_active
        AND ze.lifecycle_status IN ('01', '02', '03', '04', '05')
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
    WHERE ze.is_active
        AND pdl.is_active
        AND ze.lifecycle_status IN ('01', '02', '03', '04', '05')
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
      WHERE ze.is_active
        AND dl.is_active
        AND ze.lifecycle_status IN ('01', '02', '03', '04', '05')
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
        WHERE ze.is_active
            AND dt.is_active
            AND ze.lifecycle_status IN ('01', '02', '03', '04', '05')
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
        WHERE ps.is_active
            AND pdl.is_active
            AND ps.lifecycle_status IN ('01', '02', '03', '04', '05')
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


CREATE OR REPLACE FUNCTION create_or_update_spatial_plan()
RETURNS TRIGGER
AS $$
BEGIN
    IF (TG_TABLE_NAME = 'spatial_plan_metadata' AND TG_OP = 'UPDATE') THEN
        IF (NEW."name" <> OLD."name") THEN
            UPDATE SCHEMANAME.spatial_plan
            SET "name" = NEW."name"
            WHERE plan_id = NEW.plan_id;
        END IF;

        IF (NEW."plan_id" <> OLD."plan_id") THEN
            UPDATE SCHEMANAME.spatial_plan
            SET plan_id = NEW."plan_id"
            WHERE plan_id = OLD."plan_id";
        END IF;
        RETURN NEW;
    END IF;
    IF (TG_TABLE_NAME = 'spatial_plan') THEN
        IF NOT EXISTS (
            SELECT 1
            FROM SCHEMANAME.spatial_plan_metadata
            WHERE plan_id = NEW.plan_id
        ) THEN
            INSERT INTO SCHEMANAME.spatial_plan_metadata (plan_id, "name", created)
            VALUES (NEW.plan_id, NEW."name", NOW());
        ELSE
            UPDATE SCHEMANAME.spatial_plan_metadata
            SET "name" = NEW."name"
            WHERE plan_id = NEW.plan_id;

            UPDATE SCHEMANAME.spatial_plan
            SET "name" = NEW."name"
            WHERE plan_id = NEW.plan_id
            AND "name" <> NEW."name";
        END IF;
        RETURN NEW;
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER create_or_update_spatial_plan
BEFORE INSERT OR UPDATE ON SCHEMANAME.spatial_plan
FOR EACH ROW
WHEN (pg_trigger_depth() < 1)
EXECUTE PROCEDURE create_or_update_spatial_plan();

CREATE TRIGGER create_or_update_spatial_plan
BEFORE UPDATE ON SCHEMANAME.spatial_plan_metadata
FOR EACH ROW
WHEN (pg_trigger_depth() < 1)
EXECUTE PROCEDURE create_or_update_spatial_plan();
