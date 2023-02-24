CREATE FUNCTION SCHEMANAME.validate_geometry()
RETURNS TRIGGER
AS $$
DECLARE
  valid_reason text;
BEGIN
  IF NOT ST_IsValid(NEW.geom) THEN
    valid_reason := ST_IsValidReason(NEW.geom);
    NEW.geom = ST_MakeValid(NEW.geom, 'method=structure');
    RAISE WARNING 'New or updated geometry in % with identifier % is not valid. Reason: %. Geometry has been made valid. Please verify fixed geometry.', TG_TABLE_NAME, NEW.identifier, valid_reason;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER validate_spatial_plan_geom
  BEFORE INSERT OR UPDATE OF geom
    ON SCHEMANAME.spatial_plan
  FOR EACH ROW
  EXECUTE PROCEDURE SCHEMANAME.validate_geometry();

CREATE TRIGGER validate_zoning_element_geom
  BEFORE INSERT OR UPDATE OF geom
    ON SCHEMANAME.zoning_element
  FOR EACH ROW
  EXECUTE PROCEDURE SCHEMANAME.validate_geometry();

CREATE TRIGGER validate_planned_space_geom
  BEFORE INSERT OR UPDATE OF geom
    ON SCHEMANAME.planned_space
  FOR EACH ROW
  EXECUTE PROCEDURE SCHEMANAME.validate_geometry();

CREATE TRIGGER validate_planning_detail_line_geom
  BEFORE INSERT OR UPDATE OF geom
    ON SCHEMANAME.planning_detail_line
  FOR EACH ROW
  EXECUTE PROCEDURE SCHEMANAME.validate_geometry();

CREATE TRIGGER validate_describing_text_geom
  BEFORE INSERT OR UPDATE OF geom
    ON SCHEMANAME.describing_text
  FOR EACH ROW
  EXECUTE PROCEDURE SCHEMANAME.validate_geometry();

CREATE TRIGGER validate_describing_line_geom
  BEFORE INSERT OR UPDATE OF geom
    ON SCHEMANAME.describing_line
  FOR EACH ROW
  EXECUTE PROCEDURE SCHEMANAME.validate_geometry();

CREATE TRIGGER validate_geometry_area_value_geom
  BEFORE INSERT OR UPDATE OF "value"
    ON SCHEMANAME.geometry_area_value
  FOR EACH ROW
  EXECUTE PROCEDURE SCHEMANAME.validate_geometry();

CREATE TRIGGER validate_geometry_line_value_geom
  BEFORE INSERT OR UPDATE OF "value"
    ON SCHEMANAME.geometry_line_value
  FOR EACH ROW
  EXECUTE PROCEDURE SCHEMANAME.validate_geometry();

CREATE TRIGGER validate_geometry_point_value_geom
  BEFORE INSERT OR UPDATE OF "value"
    ON SCHEMANAME.geometry_point_value
  FOR EACH ROW
  EXECUTE PROCEDURE SCHEMANAME.validate_geometry();


CREATE FUNCTION SCHEMANAME.validate_spatial_plan_topology()
RETURNS TRIGGER
AS $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM SCHEMANAME.spatial_plan AS sp
    WHERE sp.identifier <> new.identifier
      AND sp.geom && NEW.geom
      AND NOT ST_Relate(ST_Buffer(sp.geom, -0.1), ST_Buffer(NEW.geom, -0.1), 'FF*******')
  ) THEN
    RAISE EXCEPTION 'New % geometry with id % overlaps with existing spatial plan geometry', TG_TABLE_NAME, NEW.identifier;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE CONSTRAINT TRIGGER validate_spatial_plan_topology
  AFTER INSERT OR UPDATE OF geom ON SCHEMANAME.spatial_plan
  DEFERRABLE INITIALLY DEFERRED
  FOR EACH ROW
  EXECUTE PROCEDURE SCHEMANAME.validate_spatial_plan_topology();

CREATE FUNCTION SCHEMANAME.validate_zoning_element_topology()
RETURNS TRIGGER
AS $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM SCHEMANAME.zoning_element AS ze
    WHERE ze.identifier <> new.identifier
      AND ze.geom && NEW.geom
      AND NOT ST_Relate(ST_Buffer(ze.geom, -0.1), ST_Buffer(NEW.geom, -0,1), 'FF*******')
  ) THEN
    RAISE EXCEPTION 'New zoning_element geometry with id % overlaps with existing zoning element geometry', NEW.identifier;
  END IF;
  -- Zoning element geometry must not overlap with spatial plan geometry
  IF EXISTS (
    SELECT 1 FROM SCHEMANAME.spatial_plan sp
    WHERE ST_Overlaps(sp.geom, ST_Buffer(NEW.geom, -0.1))
  ) THEN
    RAISE EXCEPTION 'Zoning element geometry with identifier % is not contained in spatial plan', NEW.identifier;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE CONSTRAINT TRIGGER validate_zoning_element_topology
  AFTER INSERT OR UPDATE OF geom ON SCHEMANAME.zoning_element
  DEFERRABLE INITIALLY DEFERRED
  FOR EACH ROW
  EXECUTE PROCEDURE SCHEMANAME.validate_zoning_element_topology();

CREATE FUNCTION SCHEMANAME.validate_planned_space_geom()
RETURNS TRIGGER
AS $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM SCHEMANAME.spatial_plan sp
    WHERE ST_Overlaps(sp.geom, ST_Buffer(NEW.geom, -0.1))
  ) THEN
    RAISE EXCEPTION 'Planned space geometry with identifier % is not contained in spatial plan', NEW.identifier;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE CONSTRAINT TRIGGER validate_planned_space_topology
  AFTER INSERT OR UPDATE OF geom
    ON SCHEMANAME.planned_space
  DEFERRABLE INITIALLY DEFERRED
  FOR EACH ROW
  EXECUTE PROCEDURE SCHEMANAME.validate_planned_space_geom();

CREATE FUNCTION SCHEMANAME.validate_finished_plan(spatial_plan_local_id VARCHAR)
RETURNS BOOLEAN
AS $$
DECLARE
  _spatial_plan SCHEMANAME.spatial_plan%ROWTYPE;
  _spatial_plan_area FLOAT;
  _zoning_element_area FLOAT;
BEGIN
  SELECT * INTO _spatial_plan FROM SCHEMANAME.spatial_plan WHERE local_id = spatial_plan_local_id;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Spatial plan with local id % not found', spatial_plan_local_id;
  END IF;
  SELECT ST_Area(_spatial_plan.geom) INTO _spatial_plan_area;
  SELECT ST_Area(ST_Union(ze.geom)) INTO _zoning_element_area FROM SCHEMANAME.zoning_element ze WHERE spatial_plan = _spatial_plan.local_id;
  IF ABS(_spatial_plan_area - _zoning_element_area) > 1 THEN -- 1 square meter tolerance
    RAISE WARNING 'Zoning element geometries do not cover the spatial plan geometry';
    RETURN FALSE;
  END IF;
  RETURN TRUE;
END;
$$ LANGUAGE plpgsql;
