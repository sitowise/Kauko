CREATE FUNCTION SCHEMANAME.validate_geometry()
RETURN TRIGGER
AS $$
BEGIN
  IF NOT ST_IsValid(NEW.geom) THEN
    NEW.geom = ST_MakeValid(NEW.geom, 'method=structure');
    RAISE WARNING 'New or updated geometry in % with identifier % is not valid, but has been made valid. Please verify fixed geometry.', TG_TABLE_NAME, NEW.identifier;
  END IF;
  RETURN NEW;
END;

CREATE TRIGGER validate_spatial_plan_geom()
  BEFORE INSERT OR UPDATE OF geom
    ON SCHEMANAME.spatial_plan
  FOR EACH ROW
  EXECUTE PROCEDURE SCHEMANAME.validate_geometry();

CREATE TRIGGER validate_zoning_element_geom()
  BEFORE INSERT OR UPDATE OF geom
    ON SCHEMANAME.zoning_element
  FOR EACH ROW
  EXECUTE PROCEDURE SCHEMANAME.validate_geometry();

CREATE TRIGGER validate_planned_space_geom()
  BEFORE INSERT OR UPDATE OF geom
    ON SCHEMANAME.planned_space
  FOR EACH ROW
  EXECUTE PROCEDURE SCHEMANAME.validate_geometry();

CREATE TRIGGER validate_planning_detail_line_geom()
  BEFORE INSERT OR UPDATE OF geom
    ON SCHEMANAME.planning_detail_line
  FOR EACH ROW
  EXECUTE PROCEDURE SCHEMANAME.validate_geometry();

CREATE TRIGGER validate_describing_text_geom()
  BEFORE INSERT OR UPDATE OF geom
    ON SCHEMANAME.describing_text
  FOR EACH ROW
  EXECUTE PROCEDURE SCHEMANAME.validate_geometry();

CREATE TRIGGER validate_describing_line_geom()
  BEFORE INSERT OR UPDATE OF geom
    ON SCHEMANAME.describing_line
  FOR EACH ROW
  EXECUTE PROCEDURE SCHEMANAME.validate_geometry();

CREATE TRIGGER validate_geometry_area_value_geom()
  BEFORE INSERT OR UPDATE OF geom
    ON SCHEMANAME.geometry_area_value
  FOR EACH ROW
  EXECUTE PROCEDURE SCHEMANAME.validate_geometry();

CREATE TRIGGER validate_geometry_line_value_geom()
  BEFORE INSERT OR UPDATE OF geom
    ON SCHEMANAME.geometry_line_value
  FOR EACH ROW
  EXECUTE PROCEDURE SCHEMANAME.validate_geometry();

CREATE TRIGGER validate_geometry_point_value_geom()
  BEFORE INSERT OR UPDATE OF geom
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
      AND ST_Relates(sp.geom, NEW.geom, 'F********')
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
      AND ST_Relates(ze.geom, NEW.geom, 'F********')
  ) THEN
    RAISE EXCEPTION 'Geometry overlaps with existing zoning element geometry';
  END IF;
  -- Zoning element geometry must not overlap with spatial plan geometry
  IF EXISTS (
    SELECT 1 FROM SCHEMANAME.spatial_plan sp
    WHERE ST_Overlaps(sp.geom, NEW.geom)) THEN
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
    WHERE ST_Overlaps(sp.geom, NEW.geom)) THEN
    RAISE EXCEPTION 'Planned space geometry with identifier % is not contained in spatial plan', NEW.identifier;
  )
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE CONSTRAINT TRIGGER validate_planned_space_topology
  AFTER INSERT OR UPDATE OF geom
    ON SCHEMANAME.planned_space
  DEFERRABLE INITIALLY DEFERRED
  FOR EACH ROW
  EXECUTE PROCEDURE SCHEMANAME.validate_planned_space_geom();

CREATE FUNCTION SCHEMANAME.validate_planning_detail_line_topology()
RETURNS TRIGGER
AS $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM SCHEMANAME.spatial_plan sp
    WHERE sp.geom && NEW.geom
      AND NOT ST_Relates(sp.geom, NEW.geom, '******FF*')
    RAISE EXCEPTION 'Planning detail line geometry with identifier % is not contained in spatial plan', NEW.identifier;
  )
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE CONSTRAINT TRIGGER validate_planning_detail_line_topology
  AFTER INSERT OR UPDATE OF geom
    ON SCHEMANAME.planning_detail_line
  DEFERRABLE INITIALLY DEFERRED
  FOR EACH ROW
  EXECUTE PROCEDURE SCHEMANAME.validate_planning_detail_line_topology();

CREATE FUNCTION SCHEMANAME.validate_describing_text_topology()
RETURNS TRIGGER
AS $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM SCHEMANAME.spatial_plan sp
    WHERE sp.geom && NEW.geom
      AND NOT ST_Relates(sp.geom, NEW.geom, '******FF*')
    RAISE EXCEPTION 'Describing text geometry with identifier % is not contained in spatial plan', NEW.identifier;
  )
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE CONSTRAINT TRIGGER validate_describing_text_topology
  AFTER INSERT OR UPDATE OF geom
    ON SCHEMANAME.describing_text
  DEFERRABLE INITIALLY DEFERRED
  FOR EACH ROW
  EXECUTE PROCEDURE SCHEMANAME.validate_describing_text_topology();

CREATE FUNCTION SCHEMANAME.validate_describing_line_topology()
RETURNS TRIGGER
AS $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM SCHEMANAME.spatial_plan sp
    WHERE sp.geom && NEW.geom
      AND NOT ST_Relates(sp.geom, NEW.geom, '******FF*')
    RAISE EXCEPTION 'Describing line geometry with identifier % is not contained in spatial plan', NEW.identifier;
  )
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;
