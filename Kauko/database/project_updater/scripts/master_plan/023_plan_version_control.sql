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
ALTER TABLE SCHEMANAME.geometry_area_value
    ADD COLUMN is_active BOOLEAN DEFAULT TRUE;
ALTER TABLE SCHEMANAME.geometry_line_value
    ADD COLUMN is_active BOOLEAN DEFAULT TRUE;
ALTER TABLE SCHEMANAME.geometry_point_value
    ADD COLUMN is_active BOOLEAN DEFAULT TRUE;

CREATE OR REPLACE FUNCTION SCHEMANAME.update_active_plan(p_old_active_plan_local_id varchar, p_new_active_plan_local_id varchar)
RETURNS void AS $$
DECLARE
    v_old_plan_regulation_local_ids varchar[];
    v_old_plan_guidance_local_ids varchar[];
    v_new_plan_regulation_local_ids varchar[];
    v_new_plan_guidance_local_ids varchar[];
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

    SELECT SCHEMANAME.get_plan_regulation_local_ids(p_old_active_plan_local_id)
    INTO v_old_plan_regulation_local_ids;

    SELECT SCHEMANAME.get_plan_guidance_local_ids(p_old_active_plan_local_id)
    INTO v_old_plan_guidance_local_ids;

    UPDATE SCHEMANAME.geometry_area_value gav
    SET is_active = FALSE
    FROM SCHEMANAME.plan_regulation_geometry_area_value prgav
    WHERE gav.geometry_area_value_uuid = prgav.fk_geometry_area_value
    AND prgav.fk_plan_regulation = ANY(v_old_plan_regulation_local_ids);

    UPDATE SCHEMANAME.geometry_area_value gav
    SET is_active = FALSE
    FROM SCHEMANAME.plan_guidance_geometry_area_value pggav
    WHERE gav.geometry_area_value_uuid = pggav.fk_geometry_area_value
    AND pggav.fk_plan_guidance = ANY(v_old_plan_guidance_local_ids);

    UPDATE SCHEMANAME.geometry_area_value gav
    SET is_active = FALSE
    FROM SCHEMANAME.plan_regulation pr
    JOIN SCHEMANAME.plan_regulation_supplementary_information prsi
        ON prsi.fk_plan_regulation = pr.local_id
    JOIN SCHEMANAME.supplementary_information_geometry_area_value sigav
        ON sigav.fk_supplementary_information = prsi.fk_supplementary_information
    WHERE gav.geometry_area_value_uuid = sigav.fk_geometry_area_value
    AND pr.local_id = ANY(v_old_plan_regulation_local_ids);

    UPDATE SCHEMANAME.geometry_line_value glv
    SET is_active = FALSE
    FROM SCHEMANAME.plan_regulation_geometry_line_value prglv
    WHERE glv.geometry_line_value_uuid = prglv.fk_geometry_line_value
    AND prglv.fk_plan_regulation = ANY(v_old_plan_regulation_local_ids);

    UPDATE SCHEMANAME.geometry_line_value glv
    SET is_active = FALSE
    FROM SCHEMANAME.plan_guidance_geometry_line_value pgglv
    WHERE glv.geometry_line_value_uuid = pgglv.fk_geometry_line_value
    AND pgglv.fk_plan_guidance = ANY(v_old_plan_guidance_local_ids);

    UPDATE SCHEMANAME.geometry_line_value glv
    SET is_active = FALSE
    FROM SCHEMANAME.plan_regulation pr
    JOIN SCHEMANAME.plan_regulation_supplementary_information prsi
        ON prsi.fk_plan_regulation = pr.local_id
    JOIN SCHEMANAME.supplementary_information_geometry_line_value siglv
        ON siglv.fk_supplementary_information = prsi.fk_supplementary_information
    WHERE glv.geometry_line_value_uuid = siglv.fk_geometry_line_value
    AND pr.local_id = ANY(v_old_plan_regulation_local_ids);

    UPDATE SCHEMANAME.geometry_point_value gpv
    SET is_active = FALSE
    FROM SCHEMANAME.plan_regulation_geometry_point_value prgpv
    WHERE gpv.geometry_point_value_uuid = prgpv.fk_geometry_point_value
    AND prgpv.fk_plan_regulation = ANY(v_old_plan_regulation_local_ids);

    UPDATE SCHEMANAME.geometry_point_value gpv
    SET is_active = FALSE
    FROM SCHEMANAME.plan_guidance_geometry_point_value pggpv
    WHERE gpv.geometry_point_value_uuid = pggpv.fk_geometry_point_value
    AND pggpv.fk_plan_guidance = ANY(v_old_plan_guidance_local_ids);

    UPDATE SCHEMANAME.geometry_point_value gpv
    SET is_active = FALSE
    FROM SCHEMANAME.plan_regulation pr
    JOIN SCHEMANAME.plan_regulation_supplementary_information prsi
        ON prsi.fk_plan_regulation = pr.local_id
    JOIN SCHEMANAME.supplementary_information_geometry_point_value sigpv
        ON sigpv.fk_supplementary_information = prsi.fk_supplementary_information
    WHERE gpv.geometry_point_value_uuid = sigpv.fk_geometry_point_value
    AND pr.local_id = ANY(v_old_plan_regulation_local_ids);

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

    SELECT SCHEMANAME.get_plan_regulation_local_ids(p_old_active_plan_local_id)
    INTO v_new_plan_regulation_local_ids;

    SELECT SCHEMANAME.get_plan_guidance_local_ids(p_old_active_plan_local_id)
    INTO v_new_plan_guidance_local_ids;

    UPDATE SCHEMANAME.geometry_area_value gav
    SET is_active = TRUE
    FROM SCHEMANAME.plan_regulation_geometry_area_value prgav
    WHERE gav.geometry_area_value_uuid = prgav.fk_geometry_area_value
    AND prgav.fk_plan_regulation = ANY(v_new_plan_regulation_local_ids);

    UPDATE SCHEMANAME.geometry_area_value gav
    SET is_active = TRUE
    FROM SCHEMANAME.plan_guidance_geometry_area_value pggav
    WHERE gav.geometry_area_value_uuid = pggav.fk_geometry_area_value
    AND pggav.fk_plan_guidance = ANY(v_new_plan_guidance_local_ids);

    UPDATE SCHEMANAME.geometry_area_value gav
    SET is_active = TRUE
    FROM SCHEMANAME.plan_regulation pr
    JOIN SCHEMANAME.plan_regulation_supplementary_information prsi
        ON prsi.fk_plan_regulation = pr.local_id
    JOIN SCHEMANAME.supplementary_information_geometry_area_value sigav
        ON sigav.fk_supplementary_information = prsi.fk_supplementary_information
    WHERE gav.geometry_area_value_uuid = sigav.fk_geometry_area_value
    AND pr.local_id = ANY(v_new_plan_regulation_local_ids);

    UPDATE SCHEMANAME.geometry_line_value glv
    SET is_active = TRUE
    FROM SCHEMANAME.plan_regulation_geometry_line_value prglv
    WHERE glv.geometry_line_value_uuid = prglv.fk_geometry_line_value
    AND prglv.fk_plan_regulation = ANY(v_new_plan_regulation_local_ids);

    UPDATE SCHEMANAME.geometry_line_value glv
    SET is_active = TRUE
    FROM SCHEMANAME.plan_guidance_geometry_line_value pgglv
    WHERE glv.geometry_line_value_uuid = pgglv.fk_geometry_line_value
    AND pgglv.fk_plan_guidance = ANY(v_new_plan_guidance_local_ids);

    UPDATE SCHEMANAME.geometry_line_value glv
    SET is_active = TRUE
    FROM SCHEMANAME.plan_regulation pr
    JOIN SCHEMANAME.plan_regulation_supplementary_information prsi
        ON prsi.fk_plan_regulation = pr.local_id
    JOIN SCHEMANAME.supplementary_information_geometry_line_value siglv
        ON siglv.fk_supplementary_information = prsi.fk_supplementary_information
    WHERE glv.geometry_line_value_uuid = siglv.fk_geometry_line_value
    AND pr.local_id = ANY(v_new_plan_regulation_local_ids);

    UPDATE SCHEMANAME.geometry_point_value gpv
    SET is_active = TRUE
    FROM SCHEMANAME.plan_regulation_geometry_point_value prgpv
    WHERE gpv.geometry_point_value_uuid = prgpv.fk_geometry_point_value
    AND prgpv.fk_plan_regulation = ANY(v_new_plan_regulation_local_ids);

    UPDATE SCHEMANAME.geometry_point_value gpv
    SET is_active = TRUE
    FROM SCHEMANAME.plan_guidance_geometry_point_value pggpv
    WHERE gpv.geometry_point_value_uuid = pggpv.fk_geometry_point_value
    AND pggpv.fk_plan_guidance = ANY(v_new_plan_guidance_local_ids);

    UPDATE SCHEMANAME.geometry_point_value gpv
    SET is_active = TRUE
    FROM SCHEMANAME.plan_regulation pr
    JOIN SCHEMANAME.plan_regulation_supplementary_information prsi
        ON prsi.fk_plan_regulation = pr.local_id
    JOIN SCHEMANAME.supplementary_information_geometry_point_value sigpv
        ON sigpv.fk_supplementary_information = prsi.fk_supplementary_information
    WHERE gpv.geometry_point_value_uuid = sigpv.fk_geometry_point_value
    AND pr.local_id = ANY(v_new_plan_regulation_local_ids);
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


CREATE OR REPLACE FUNCTION SCHEMANAME.create_or_update_spatial_plan()
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
EXECUTE PROCEDURE SCHEMANAME.create_or_update_spatial_plan();

CREATE TRIGGER create_or_update_spatial_plan
BEFORE UPDATE ON SCHEMANAME.spatial_plan_metadata
FOR EACH ROW
WHEN (pg_trigger_depth() < 1)
EXECUTE PROCEDURE SCHEMANAME.create_or_update_spatial_plan();

CREATE OR REPLACE FUNCTION SCHEMANAME.get_plan_regulation_local_ids(p_spatial_plan_local_id TEXT)
RETURNS TABLE(local_id VARCHAR) AS $$
BEGIN
  RETURN QUERY (
    SELECT DISTINCT zer.plan_regulation_local_id AS local_id
    FROM SCHEMANAME.zoning_element_plan_regulation AS zer
    JOIN SCHEMANAME.zoning_element AS ze ON ze.local_id = zer.zoning_element_local_id
    WHERE ze.spatial_plan = p_spatial_plan_local_id

    UNION

    SELECT DISTINCT psr.plan_regulation_group_local_id AS local_id
    FROM SCHEMANAME.zoning_element_planned_space AS zeps
    JOIN SCHEMANAME.planned_space_plan_regulation_group AS psr ON psr.planned_space_local_id = zeps.planned_space_local_id
    JOIN SCHEMANAME.zoning_element AS ze ON ze.local_id = zeps.zoning_element_local_id
    WHERE ze.spatial_plan = p_spatial_plan_local_id

    UNION

    SELECT DISTINCT pdlr.plan_regulation_local_id AS local_id
    FROM SCHEMANAME.zoning_element_plan_detail_line AS zedl
    JOIN SCHEMANAME.planning_detail_line_plan_regulation AS pdlr ON pdlr.planning_detail_line_local_id = zedl.planning_detail_line_local_id
    JOIN SCHEMANAME.zoning_element AS ze ON ze.local_id = zedl.zoning_element_local_id
    WHERE ze.spatial_plan = p_spatial_plan_local_id

    UNION

    SELECT DISTINCT prgr.plan_regulation_local_id AS local_id
    FROM SCHEMANAME.zoning_element ze
    JOIN SCHEMANAME.zoning_element_plan_regulation_group zeprg ON zeprg.zoning_element_local_id = ze.local_id
    JOIN SCHEMANAME.plan_regulation_group_regulation prgr ON prgr.plan_regulation_group_local_id = zeprg.plan_regulation_group_local_id
    WHERE ze.spatial_plan = p_spatial_plan_local_id

    UNION

    SELECT DISTINCT prgr.plan_regulation_local_id AS local_id
    FROM SCHEMANAME.zoning_element ze
    JOIN SCHEMANAME.zoning_element_planned_space zeps ON zeps.zoning_element_local_id = ze.local_id
    JOIN SCHEMANAME.planned_space_plan_regulation_group psprg ON zeps.planned_space_local_id = psprg.planned_space_local_id
    JOIN SCHEMANAME.plan_regulation_group_regulation prgr ON prgr.plan_regulation_group_local_id = psprg.plan_regulation_group_local_id
    WHERE ze.spatial_plan = p_spatial_plan_local_id

    UNION

    SELECT DISTINCT prgr.plan_regulation_local_id AS local_id
    FROM SCHEMANAME.zoning_element ze
    JOIN SCHEMANAME.zoning_element_plan_detail_line zepdl ON zepdl.zoning_element_local_id = ze.local_id
    JOIN SCHEMANAME.planning_detail_line_plan_regulation_group pdlprg ON zepdl.planning_detail_line_local_id = pdlprg.planning_detail_line_local_id
    JOIN SCHEMANAME.plan_regulation_group_regulation prgr ON pdlprg.plan_regulation_group_local_id = prgr.plan_regulation_group_local_id
    WHERE ze.spatial_plan = p_spatial_plan_local_id
  );
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION SCHEMANAME.get_plan_guidance_local_ids(p_spatial_plan_local_id TEXT)
RETURNS TABLE(local_id VARCHAR) AS $$
BEGIN
  RETURN QUERY (
    SELECT DISTINCT sppg.plan_guidance_local_id AS local_id
    FROM SCHEMANAME.spatial_plan_plan_guidance sppg
    WHERE sppg.spatial_plan_local_id = p_spatial_plan_local_id

    UNION

    SELECT DISTINCT zepg.plan_guidance_local_id
    FROM SCHEMANAME.zoning_element ze
    JOIN SCHEMANAME.zoning_element_plan_guidance zepg ON zepg.zoning_element_local_id = ze.local_id
    WHERE ze.spatial_plan = p_spatial_plan_local_id

    UNION

    SELECT DISTINCT pspg.plan_guidance_local_id AS local_id
    FROM SCHEMANAME.zoning_element ze
    JOIN SCHEMANAME.zoning_element_planned_space zeps ON zeps.zoning_element_local_id = ze.local_id
    JOIN SCHEMANAME.planned_space ps ON zeps.planned_space_local_id = ps.local_id
    JOIN SCHEMANAME.planned_space_plan_guidance pspg ON pspg.planned_space_local_id = ps.local_id
    WHERE ze.spatial_plan = p_spatial_plan_local_id

    UNION

    SELECT DISTINCT pdlpg.plan_guidance_local_id AS local_id
    FROM SCHEMANAME.zoning_element ze
    JOIN SCHEMANAME.zoning_element_plan_detail_line zepdl ON zepdl.zoning_element_local_id = ze.local_id
    JOIN SCHEMANAME.planning_detail_line pdl ON zepdl.planning_detail_line_local_id = pdl.local_id
    JOIN SCHEMANAME.planning_detail_line_plan_guidance pdlpg ON pdlpg.planning_detail_line_local_id = pdl.local_id
    WHERE ze.spatial_plan = p_spatial_plan_local_id
  );
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION SCHEMANAME.get_document_local_ids(p_spatial_plan_local_id TEXT)
RETURNS TABLE(local_id VARCHAR) AS $$
BEGIN
  RETURN QUERY (
    SELECT DISTINCT d.local_id AS local_id
    FROM SCHEMANAME.document d
    JOIN SCHEMANAME.patricipation_evalution_plan_document pepd ON pepd.document_local_id = d.local_id
    JOIN SCHEMANAME.plan_guidance_document pgd ON pgd.document_local_id = d.local_id
    JOIN SCHEMANAME.plan_regulation_document prd ON prd.document_local_id = d.local_id
    JOIN SCHEMANAME.spatial_plan_commentary_document spcd ON spcd.document_local_id = d.local_id
    JOIN SCHEMANAME.spatial_plan_document spd ON spd.document_local_id = d.local_id
    JOIN SCHEMANAME.participation_and_evalution_plan pep ON pepd.participation_and_evalution_plan_local_id = pep.local_id
    JOIN SCHEMANAME.spatial_plan_commentary spc ON spcd.spatial_plan_commentary_local_id = spc.local_id
    WHERE
      (spd.spatial_plan_local_id = p_spatial_plan_local_id) OR
      (spc.spatial_plan = p_spatial_plan_local_id) OR
      (pep.spatial_plan = p_spatial_plan_local_id) OR
      (prd.document_local_id IN (SELECT SCHEMANAME.get_plan_regulation_local_ids(p_spatial_plan_local_id))) OR
      (pgd.document_local_id IN (SELECT SCHEMANAME.get_plan_guidance_local_ids(p_spatial_plan_local_id)))
  );
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION SCHEMANAME.get_regulation_group_local_ids(p_spatial_plan_local_id TEXT)
RETURNS TABLE(local_id VARCHAR) AS $$
BEGIN
  RETURN QUERY (
    SELECT DISTINCT zeprg.plan_regulation_group_local_id AS local_id
    FROM SCHEMANAME.zoning_element_plan_regulation_group zeprg
        INNER JOIN SCHEMANAME.zoning_element ze ON ze.local_id = zeprg.zoning_element_local_id
    WHERE ze.spatial_plan = p_spatial_plan_local_id
    UNION
    SELECT DISTINCT psprg.plan_regulation_group_local_id AS local_id
    FROM SCHEMANAME.planned_space_plan_regulation_group psprg
        INNER JOIN SCHEMANAME.planned_space ps ON psprg.planned_space_local_id = ps.local_id
        INNER JOIN SCHEMANAME.zoning_element_planned_space zeps ON zeps.planned_space_local_id = ps.local_id
        INNER JOIN SCHEMANAME.zoning_element ze ON zeps.zoning_element_local_id = ze.local_id
    WHERE ze.spatial_plan = p_spatial_plan_local_id
    UNION
    SELECT DISTINCT pdlprg.planning_detail_line_local_id AS local_id
    FROM SCHEMANAME.planning_detail_line_plan_regulation_group pdlprg
        INNER JOIN SCHEMANAME.planning_detail_line pdl ON pdlprg.planning_detail_line_local_id = pdl.local_id
        INNER JOIN SCHEMANAME.zoning_element_plan_detail_line zepdl ON zepdl.planning_detail_line_local_id = pdl.local_id
        INNER JOIN SCHEMANAME.zoning_element ze ON zepdl.zoning_element_local_id = ze.local_id
    WHERE ze.spatial_plan = p_spatial_plan_local_id
  );
END;
$$ LANGUAGE plpgsql;

DO $$
DECLARE
    max_group_number INTEGER;
BEGIN
    -- Find the max group_number value
    SELECT MAX(group_number) INTO max_group_number FROM SCHEMANAME.plan_regulation_group;

    -- If no value found (empty table), set max_group_number to 0
    IF max_group_number IS NULL THEN
        max_group_number := 0;
    END IF;

    -- Add the identity constraint to group_number
execute format('
    ALTER TABLE SCHEMANAME.plan_regulation_group
    ALTER COLUMN group_number ADD GENERATED ALWAYS AS IDENTITY (INCREMENT BY 1 MINVALUE %s)', max_group_number + 1);

END;
$$ LANGUAGE plpgsql;

ALTER TABLE SCHEMANAME.zoning_element_describing_text DROP CONSTRAINT zoning_element_describing_text_fk_zoning_element;
ALTER TABLE SCHEMANAME.zoning_element_describing_text ADD CONSTRAINT zoning_element_describing_text_fk_zoning_element FOREIGN KEY (zoning_element_local_id) REFERENCES SCHEMANAME.zoning_element(local_id) ON DELETE CASCADE;

ALTER TABLE SCHEMANAME.zoning_element_describing_line DROP CONSTRAINT zoning_element_describing_line_fk_zoning_element;
ALTER TABLE SCHEMANAME.zoning_element_describing_line ADD CONSTRAINT zoning_element_describing_line_fk_zoning_element FOREIGN KEY (zoning_element_local_id) REFERENCES SCHEMANAME.zoning_element(local_id) ON DELETE CASCADE;
