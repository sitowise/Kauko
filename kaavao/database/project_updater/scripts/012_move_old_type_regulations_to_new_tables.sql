DO $$
DECLARE
  _point_regulation RECORD;
  _inserted_regulation RECORD;
  _inserted_secondary_regulation RECORD;
  _inserted_geometry RECORD;
  _inserted_text RECORD;
  _zoning_element RECORD;
  _planned_space RECORD;
BEGIN
  FOR _point_regulation IN
    SELECT * FROM SCHEMANAME.planning_detail_point
  LOOP
    CASE _point_regulation."type"
      WHEN 1 THEN
        INSERT INTO SCHEMANAME.plan_regulation(producer_specific_id, "type", life_cycle_status)
          VALUES(_point_regulation.planning_object_identifier, '0801', '11')
          RETURNING * INTO _inserted_regulation;
      WHEN 2 THEN
        INSERT INTO SCHEMANAME.plan_regulation(producer_specific_id, "type", life_cycle_status)
          VALUES(_point_regulation.planning_object_identifier, '0401', '11')
          RETURNING * INTO _inserted_regulation;
    END CASE;
    IF _point_regulation.type_description IS NOT NULL THEN
      INSERT INTO SCHEMANAME.plan_regulation("type", life_cycle_status)
          VALUES('0805', '11')
          RETURNING * INTO _inserted_secondary_regulation;
      INSERT INTO SCHEMANAME.text_value("value")
        VALUES(FORMAT('{"fi": "%s"}', _point_regulation.type_description)::jsonb)
        RETURNING * INTO _inserted_text;
      INSERT INTO SCHEMANAME.plan_regulation_text_value(fk_plan_regulation, fk_text_value)
        VALUES(_inserted_secondary_regulation.local_id, _inserted_text.text_value_uuid);
    END IF;
    FOR _zoning_element IN
      SELECT ze.local_id
        FROM SCHEMANAME.zoning_element AS ze
        INNER JOIN SCHEMANAME.zoning_element_plan_detail_point AS zepdp
          ON ze.producer_specific_id = zepdp.zoning_id
        WHERE zepdp.plan_detail_point_id = _point_regulation.planning_object_identifier
    LOOP
      INSERT INTO SCHEMANAME.zoning_element_plan_regulation(zoning_element_local_id, plan_regulation_local_id)
        VALUES(_zoning_element.local_id, _inserted_regulation.local_id);
      IF _inserted_secondary_regulation IS NOT NULL THEN
        INSERT INTO SCHEMANAME.zoning_element_plan_regulation(zoning_element_local_id, plan_regulation_local_id)
          VALUES(_zoning_element.local_id, _inserted_secondary_regulation.local_id);
      END IF;
    END LOOP;
    FOR _planned_space IN
      SELECT ps.local_id
        FROM SCHEMANAME.planned_space AS ps
        INNER JOIN SCHEMANAME.planned_space_plan_detail_point AS pspdp
          ON ps.producer_specific_id = pspdp.planned_space_id
        WHERE pspdp.plan_detail_point_id = _point_regulation.planning_object_identifier
    LOOP
      INSERT INTO SCHEMANAME.planned_space_plan_regulation(planned_space_local_id, plan_regulation_local_id)
        VALUES(_planned_space.local_id, _inserted_regulation.local_id);
      IF _inserted_secondary_regulation IS NOT NULL THEN
        INSERT INTO SCHEMANAME.planned_space_plan_regulation(planned_space_local_id, plan_regulation_local_id)
          VALUES(_planned_space.local_id, _inserted_secondary_regulation.local_id);
      END IF;
    END LOOP;
    INSERT INTO SCHEMANAME.geometry_point_value(value, obligatory, point_rotation)
      VALUES(_point_regulation.geom, _point_regulation.obligatory, _point_regulation.point_rotation)
      RETURNING * INTO _inserted_geometry;
    INSERT INTO SCHEMANAME.plan_regulation_geometry_point_value(fk_plan_regulation, fk_geometry_point_value)
      VALUES(_inserted_regulation.local_id, _inserted_geometry.geometry_point_value_uuid);
  END LOOP;
END $$;

DROP TABLE SCHEMANAME.planning_detail_point CASCADE;

ALTER TABLE SCHEMANAME.planning_detail_line
  ADD COLUMN identity_id UUID DEFAULT uuid_generate_v4() NOT NULL UNIQUE,
  ADD COLUMN local_id VARCHAR UNIQUE,
  ADD COLUMN namespace VARCHAR,
  ADD COLUMN reference_id VARCHAR,
  ADD COLUMN latest_change TIMESTAMP DEFAULT now() NOT NULL;

ALTER TABLE SCHEMANAME.planning_detail_line
  RENAME COLUMN planning_object_identifier TO producer_specific_id;
ALTER TABLE SCHEMANAME.planning_detail_line
  RENAME COLUMN created to storage_time;

CREATE TRIGGER planning_detail_line_modified_trigger
  BEFORE INSERT OR UPDATE ON SCHEMANAME.planning_detail_line
  FOR EACH ROW EXECUTE PROCEDURE versioned_object_modified_trigger();

UPDATE SCHEMANAME.planning_detail_line
  SET local_id = identity_id || '.' || uuid_generate_v4();

CREATE TRIGGER create_planend_space_local_id_trigger
  BEFORE INSERT ON SCHEMANAME.planning_detail_line
  FOR EACH ROW EXECUTE PROCEDURE create_local_id_trigger();

ALTER TABLE SCHEMANAME.planning_detail_line
  ALTER COLUMN local_id SET NOT NULL;

ALTER TABLE SCHEMANAME.zoning_element_plan_detail_line
  ADD COLUMN zoning_element_local_id VARCHAR,
  ADD COLUMN planning_detail_line_local_id VARCHAR;

UPDATE SCHEMANAME.zoning_element_plan_detail_line
  SET zoning_element_local_id = subquery.local_id
  FROM (
    SELECT local_id, producer_specific_id
    FROM SCHEMANAME.zoning_element
  ) AS subquery
  WHERE subquery.producer_specific_id = zoning_element_plan_detail_line.zoning_id;

UPDATE SCHEMANAME.zoning_element_plan_detail_line
  SET planning_detail_line_local_id = subquery.local_id
  FROM (
    SELECT local_id, producer_specific_id
    FROM SCHEMANAME.planned_space
  ) AS subquery
  WHERE subquery.producer_specific_id = zoning_element_plan_detail_line.plan_detail_line_id;

ALTER TABLE SCHEMANAME.zoning_element_plan_detail_line
  ALTER COLUMN zoning_element_local_id SET NOT NULL,
  ALTER COLUMN planned_space_local_id SET NOT NULL,
  DROP COLUMN zoning_element_id,
  DROP COLUMN planned_space_id,
  ADD CONSTRAINT fk_zoning_element
    FOREIGN KEY (zoning_element_local_id)
    REFERENCES SCHEMANAME.zoning_element (local_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
    DEFERRABLE INITIALLY DEFERRED,
  ADD CONSTRAINT fk_planning_detail_line
    FOREIGN KEY (planning_detail_line_local_id)
    REFERENCES SCHEMANAME.planning_detail_line (local_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
    DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE SCHEMANAME.planned_space_plan_detail_line
  ADD COLUMN planned_space_local_id VARCHAR,
  ADD COLUMN planning_detail_line_local_id VARCHAR;

UPDATE SCHEMANAME.planned_space_plan_detail_line
  SET planned_space_local_id = subquery.local_id
  FROM (
    SELECT local_id, producer_specific_id
    FROM SCHEMANAME.planned_space
  ) AS subquery
  WHERE subquery.producer_specific_id = planned_space_plan_detail_line.planned_space_id;

UPDATE SCHEMANAME.planned_space_plan_detail_line
  SET planning_detail_line_local_id = subquery.local_id
  FROM (
    SELECT local_id, producer_specific_id
    FROM SCHEMANAME.planned_space
  ) AS subquery
  WHERE subquery.producer_specific_id = planned_space_plan_detail_line.plan_detail_line_id;

ALTER TABLE SCHEMANAME.planned_space_plan_detail_line
  ALTER COLUMN planned_space_local_id SET NOT NULL,
  ALTER COLUMN planning_detail_line_local_id SET NOT NULL,
  DROP COLUMN plan_detail_line_id,
  DROP COLUMN planned_space_id,
  ADD CONSTRAINT fk_planned_space
    FOREIGN KEY (planned_space_local_id)
    REFERENCES SCHEMANAME.planned_space (local_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
    DEFERRABLE INITIALLY DEFERRED,
  ADD CONSTRAINT fk_planning_detail_line
    FOREIGN KEY (planning_detail_line_local_id)
    REFERENCES SCHEMANAME.planning_detail_line (local_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
    DEFERRABLE INITIALLY DEFERRED;

CREATE TABLE SCHEMANAME.planning_detail_line_plan_regulation_group(
  id SERIAL PRIMARY KEY,
  planning_detail_line_local_id VARCHAR NOT NULL,
  plan_regulation_group_local_id VARCHAR NOT NULL,
  UNIQUE (planning_detail_line_local_id, plan_regulation_group_local_id),
  CONSTRAINT fk_planning_detail_line
    FOREIGN KEY (planning_detail_line_local_id)
    REFERENCES SCHEMANAME.planning_detail_line (local_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
    DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT fk_plan_regulation_group
    FOREIGN KEY (plan_regulation_group_local_id)
    REFERENCES SCHEMANAME.plan_regulation_group (local_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
    DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE SCHEMANAME.planning_detail_line_plan_regulation(
  id SERIAL PRIMARY KEY,
  planning_detail_line_local_id VARCHAR NOT NULL,
  plan_regulation_local_id VARCHAR NOT NULL,
  UNIQUE (planning_detail_line_local_id, plan_regulation_local_id),
  CONSTRAINT fk_planning_detail_line
    FOREIGN KEY (planning_detail_line_local_id)
      REFERENCES SCHEMANAME.planning_detail_line (local_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT fk_plan_regulation
    FOREIGN KEY (plan_regulation_local_id)
      REFERENCES SCHEMANAME.plan_regulation (local_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE SCHEMANAME.planning_detail_line_plan_guidance(
  id SERIAL PRIMARY KEY,
  planning_detail_line_local_id VARCHAR NOT NULL,
  plan_guidance_local_id VARCHAR NOT NULL,
  UNIQUE (planning_detail_line_local_id, plan_guidance_local_id),
  CONSTRAINT fk_planning_detail_line
    FOREIGN KEY (planning_detail_line_local_id)
      REFERENCES SCHEMANAME.planning_detail_line (local_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT fk_plan_guidance
    FOREIGN KEY (plan_guidance_local_id)
      REFERENCES SCHEMANAME.plan_guidance (local_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED
);

CREATE FUNCTION SCHEMANAME.upsert_ridge_direction() RETURNS TRIGGER
AS $$
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
$$ LANGUAGE plpgsql;

DO $$
DECLARE
  _line_regulation SCHEMANAME.planning_detail_line%ROWTYPE;
  _inserted_regulation SCHEMANAME.plan_regulation%ROWTYPE;
  _inserted_secondary_regulation SCHEMANAME.plan_regulation%ROWTYPE;
  _inserted_geometry SCHEMANAME.geometry_line_value%ROWTYPE;
  _inserted_text SCHEMANAME.text_value%ROWTYPE;
  _inserted_value SCHEMANAME.numeric_double_value%ROWTYPE;
  _numeric_regulation SCHEMANAME.numeric_value%ROWTYPE;
  _planned_space SCHEMANAME.planned_space%ROWTYPE;
BEGIN
  FOR _line_regulation IN
    SELECT * FROM SCHEMANAME.planning_detail_line
  LOOP
    CASE _line_regulation."type"
      WHEN 1 THEN
        FOR _numeric_regulation IN
          SELECT *
          FROM SCHEMANAME.numeric_value nv
          INNER JOIN SCHEMANAME.planning_detail_line_numeric_value pdlnv
            ON nv.numeric_value_id = pdlnv.numeric_id
          INNER JOIN SCHEMANAME.planning_detail_line pdl
            ON pdl.producer_specific_id = pdlnv.planning_detail_line_id
          WHERE pdl.local_id = _line_regulation.local_id
        LOOP
          INSERT INTO SCHEMANAME.plan_regulation("type", life_cycle_status)
            VALUES('0508', '1') RETURNING * INTO _inserted_regulation;
          INSERT INTO SCHEMANAME.numeric_double_value("value", unit_of_measure)
            VALUES(_numeric_regulation."value", 'dBA') RETURNING * INTO _inserted_value;
          INSERT INTO SCHEMANAME.plan_regulation_numeric_double_value(fk_plan_regulation, fk_numeric_double_value)
            VALUES(_inserted_regulation.local_id, _inserted_value.numeric_double_value_uuid);
          INSERT INTO SCHEMANAME.geometry_line_value("value", obligatory)
            VALUES(_line_regulation.geom, _line_regulation.obligatory) RETURNING * INTO _inserted_geometry;
          INSERT INTO SCHEMANAME.plan_regulation_geometry_line_value(fk_plan_regulation, fk_geometry_line_value)
            VALUES(_inserted_regulation.local_id, _inserted_geometry.geometry_line_value_uuid);
          FOR _planned_space IN
            SELECT *
            FROM SCHEMANAME.planned_space
            INNER JOIN SCHEMANAME.planning_detail_line_planned_space pdlps
              ON pdlps.planned_space_local_id = planned_space.local_id
            WHERE pdlps.planning_detail_line_local_id = _line_regulation.local_id
          LOOP
            INSERT INTO SCHEMANAME.plan_regulation_planned_space(fk_plan_regulation, fk_planned_space)
              VALUES(_inserted_regulation.local_id, _planned_space.local_id);
          END LOOP;
        END LOOP;
        DELETE FROM SCHEMANAME.planning_detail_line
          WHERE local_id = _line_regulation.local_id;
      WHEN 2 THEN
        INSERT INTO SCHEMANAME.plan_regulation("type", life_cycle_status)
          VALUES('0802', '11')
          RETURNING * INTO _inserted_regulation;
        INSERT INTO SCHEMANAME.planning_detail_line_plan_regulation(
          planning_detail_line_local_id,
          plan_regulation_local_id
        )
          VALUES(_line_regulation.local_id, _inserted_regulation.local_id);
        IF _line_regulation.type_description IS NOT NULL THEN
          INSERT INTO SCHEMANAME.plan_regulation("type", life_cycle_status)
            VALUES('0805', '11')
            RETURNING * INTO _inserted_secondary_regulation;
          INSERT INTO SCHEMANAME.text_value("value")
            VALUES(FORMAT('{"fi": "%s"}', _line_regulation.type_description)::jsonb)
            RETURNING * INTO _inserted_text;
          INSERT INTO SCHEMANAME.plan_regulation_text_value(fk_plan_regulation, fk_text_value)
            VALUES(_inserted_secondary_regulation.local_id, _inserted_text.text_value_uuid);
          INSERT INTO SCHEMANAME.planning_detail_line_plan_regulation(
            planning_detail_line_local_id,
            plan_regulation_local_id
          )
            VALUES(_line_regulation.local_id, _inserted_secondary_regulation.local_id);
        END IF;
      WHEN 3 THEN
        INSERT INTO SCHEMANAME.plan_regulation("type", life_cycle_status)
          VALUES('0503', '11')
          RETURNING * INTO _inserted_regulation;
        FOR _planned_space IN
          Select
            ps.*
          From
            SCHEMANAME.planned_space ps
              Inner Join
                SCHEMANAME.planned_space_plan_detail_line pspdl
                On pspdl.planned_space_local_id = ps.local_id
              Inner Join
                SCHEMANAME.planning_detail_line pdl
                On pspdl.planning_detail_line_local_id = pdl.local_id
          Where pdl.local_id = _line_regulation.local_id
        LOOP
          INSERT INTO SCHEMANAME.planned_space_plan_regulation(
            planned_space_local_id,
            plan_regulation_local_id
          )
            VALUES(_planned_space.local_id, _inserted_regulation.local_id);
        END LOOP;
        INSERT INTO SCHEMANAME.planning_detail_line_plan_regulation(
          planning_detail_line_local_id,
          plan_regulation_local_id
        )
          VALUES(_line_regulation.local_id, _inserted_regulation.local_id);
        INSERT INTO SCHEMANAME.numeric_double_value("value", unit_of_measure)
          VALUES(degrees(ST_Azimuth(ST_StartPoint(ST_GeometryN(_line_regulation.geom, 1)), ST_EndPoint(ST_GeometryN(_line_regulation.geom, 1)))), 'deg')
          RETURNING * INTO _inserted_value;
        INSERT INTO SCHEMANAME.plan_regulation_numeric_double_value(fk_plan_regulation, fk_numeric_double_value)
          VALUES(_inserted_regulation.local_id, _inserted_value.numeric_double_value_uuid);
      WHEN 4 THEN
        INSERT INTO SCHEMANAME.plan_regulation("type", life_cycle_status)
          VALUES('0504', '020313')
          RETURNING * INTO _inserted_regulation;
        IF _linestring.type_description IS NOT NULL THEN
          INSERT INTO SCHEMANAME.text_value("value")
            VALUES(FORMAT('{"fi": "%s"}', _line_regulation.type_description)::jsonb)
            RETURNING * INTO _inserted_text;
          INSERT INTO SCHEMANAME.plan_regulation_text_value(fk_plan_regulation, fk_text_value)
            VALUES(_inserted_regulation.local_id, _inserted_text.text_value_uuid);
        END IF;
        INSERT INTO SCHEMANAME.planning_detail_line_plan_regulation(
          planning_detail_line_local_id,
          plan_regulation_local_id
        )
          VALUES(_line_regulation.local_id, _inserted_regulation.local_id);
      WHEN 5 THEN
        INSERT INTO SCHEMANAME.plan_regulation("type", life_cycle_status)
            VALUES('0504', '020204')
            RETURNING * INTO _inserted_regulation;
          IF _linestring.type_description IS NOT NULL THEN
            INSERT INTO SCHEMANAME.text_value("value")
              VALUES(FORMAT('{"fi": "%s"}', _line_regulation.type_description)::jsonb)
              RETURNING * INTO _inserted_text;
            INSERT INTO SCHEMANAME.plan_regulation_text_value(fk_plan_regulation, fk_text_value)
              VALUES(_inserted_regulation.local_id, _inserted_text.text_value_uuid);
          END IF;
          INSERT INTO SCHEMANAME.planning_detail_line_plan_regulation(
            planning_detail_line_local_id,
            plan_regulation_local_id
          )
            VALUES(_line_regulation.local_id, _inserted_regulation.local_id);
    END CASE;
  END LOOP;
END $$;