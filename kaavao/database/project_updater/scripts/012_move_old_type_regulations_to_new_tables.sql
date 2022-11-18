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
    CASE
      WHEN _point_regulation."type" = 1 THEN
        INSERT INTO SCHEMANAME.plan_regulation(producer_specific_id, "type", life_cycle_status)
          VALUES(_point_regulation.planning_object_identifier, '0801', '11')
          RETURNING * INTO _inserted_regulation;
      WHEN _point_regulation."type" = 2 THEN
        INSERT INTO SCHEMANAME.plan_regulation(producer_specific_id, "type", life_cycle_status)
          VALUES(_point_regulation.planning_object_identifier, '0401', '11')
          RETURNING * INTO _inserted_regulation;
    END CASE;
    IF _point_regulation.type_description IS NOT NULL THEN
      INSERT INTO SCHEMANAME.plan_regulation("type", life_cycle_status)
          VALUES('0805', '11')
          RETURNING * INTO _inserted_secondary_regulation;
      INSERT INTO SCHEMANAME.text_value(value)
        VALUES(FORMAT('{"fi": "%s"}', _point_regulation.type_description)::jsonb)
        RETURNING * INTO _inserted_text;
      INSERT INTO SCHEMANAME.plan_regulation_text_value(fk_plan_regulation, fk_text_value)
        VALUES(_inserted_secondary_regulation.local_id, _inserted_text.text_value_uuid);
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