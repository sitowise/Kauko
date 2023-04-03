ALTER TABLE SCHEMANAME.planning_detail_line
    ADD COLUMN name JSONB CHECK(check_language_string(name));

DO $$
DECLARE
    v_planning_detail_line SCHEMANAME.planning_detail_line%ROWTYPE;
    v_new_regulation SCHEMANAME.plan_regulation%ROWTYPE;
    v_valid_from SCHEMANAME.plan_regulation.valid_from%TYPE;
    v_valid_to SCHEMANAME.plan_regulation.valid_to%TYPE;
    v_planned_space_count INTEGER;
    v_new_value SCHEMANAME.geometry_line_value%ROWTYPE;
    v_planned_space SCHEMANAME.planned_space%ROWTYPE;
BEGIN
    FOR v_planning_detail_line IN
        SELECT *
        FROM SCHEMANAME.planning_detail_line
        WHERE "type" = 1
    LOOP
        SELECT
            MIN(ze.valid_from),
            MAX(ze.valid_to)
        INTO v_valid_from, v_valid_to
        FROM SCHEMANAME.zoning_element ze
        JOIN SCHEMANAME.zoning_element_plan_detail_line zepdl ON ze.local_id = zepdl.zoning_element_local_id
        WHERE zepdl.planning_detail_line_local_id = v_planning_detail_line.local_id;

        SELECT COUNT(1)
        INTO v_planned_space_count
        FROM SCHEMANAME.planned_space_plan_detail_line
        WHERE planning_detail_line_local_id = v_planning_detail_line.local_id;

        IF v_planned_space_count = 1 THEN
            v_planned_space := (
                SELECT *
                FROM SCHEMANAME.planned_space
                JOIN SCHEMANAME.planned_space_plan_detail_line ps ON planned_space.local_id = ps.planned_space_local_id
                WHERE ps.planning_detail_line_local_id = v_planning_detail_line.local_id
                LIMIT 1
            );

            INSERT INTO SCHEMANAME.plan_regulation ("type", life_cycle_status, valid_from, valid_to)
                VALUES ('0508', v_planning_detail_line.life_cycle_status, v_valid_from, v_valid_to)
                RETURNING * INTO v_new_regulation;
            
            INSERT INTO SCHEMANAME.geometry_line_value ("value", obligatory)
                VALUES (v_planning_detail_line.geom, v_planning_detail_line.obligatory)
                RETURNING * INTO v_new_value;
            
            INSERT INTO SCHEMANAME.plan_regulation_geometry_line_value (fk_plan_regulation, fk_geometry_line_value)
                VALUES (v_new_regulation.local_id, v_new_value.geometry_line_value_uuid);
            
            INSERT INTO SCHEMANAME.plan_regulation_planned_space (fk_plan_regulation, fk_planned_space)
                VALUES (v_new_regulation.local_id, v_planned_space.local_id);
            
            DELETE FROM SCHEMANAME.planning_detail_line
            WHERE local_id = v_planning_detail_line.local_id;
        ELSE
            INSERT INTO SCHEMANAME.plan_regulation ("type", life_cycle_status, valid_from, valid_to)
                VALUES ('1302', v_planning_detail_line.life_cycle_status, v_valid_from, v_valid_to)
                RETURNING * INTO v_new_regulation;
            
            INSERT INTO SCHEMANAME.planning_detail_line_plan_regulation (planning_detail_line_local_id, plan_regulation_local_id)
                VALUES (v_planning_detail_line.local_id, v_new_regulation.local_id);
        END IF;
    END LOOP;
END
$$ LANGUAGE plpgsql;


DO $$
DECLARE
    v_planning_detail_line SCHEMANAME.planning_detail_line%ROWTYPE;
    v_zoning_element_local_id VARCHAR;
    v_new_regulation SCHEMANAME.plan_regulation%ROWTYPE;
    v_new_value RECORD;
    v_valid_from DATE;
    v_valid_to DATE;
BEGIN
    FOR v_planning_detail_line IN
        SELECT *
        FROM SCHEMANAME.planning_detail_line
        WHERE "type" = 2
    LOOP
        SELECT
            MIN(ze.valid_from),
            MAX(ze.valid_to)
        INTO v_valid_from, v_valid_to
        FROM SCHEMANAME.zoning_element ze
        JOIN SCHEMANAME.zoning_element_plan_detail_line zepdl ON ze.local_id = zepdl.zoning_element_local_id
        WHERE zepdl.planning_detail_line_local_id = v_planning_detail_line.local_id;

        INSERT INTO SCHEMANAME.plan_regulation ("type", life_cycle_status, valid_from, valid_to)
            VALUES ('0802', v_planning_detail_line.life_cycle_status, v_valid_from, v_valid_to)
            RETURNING * INTO v_new_regulation;
        
        INSERT INTO SCHEMANAME.geometry_line_value ("value", obligatory)
            VALUES (v_planning_detail_line.geom, v_planning_detail_line.obligatory)
            RETURNING * INTO v_new_value;
        
        INSERT INTO SCHEMANAME.plan_regulation_geometry_line_value (fk_plan_regulation, fk_geometry_line_value)
            VALUES (v_new_regulation.local_id, v_new_value.geometry_line_value_uuid);
        
        FOR v_zoning_element_local_id IN
            SELECT zoning_element_local_id
            FROM SCHEMANAME.zoning_element_plan_detail_line
            WHERE planning_detail_line_local_id = v_planning_detail_line.local_id
        LOOP
            INSERT INTO SCHEMANAME.zoning_element_plan_regulation (zoning_element_local_id, plan_regulation_local_id)
                VALUES (v_zoning_element_local_id, v_new_regulation.local_id);
        END LOOP;
        DELETE FROM SCHEMANAME.planning_detail_line
            WHERE local_id = v_planning_detail_line.local_id;
    END LOOP;
END
$$ LANGUAGE plpgsql;

DO $$
DECLARE
    v_planning_detail_line SCHEMANAME.planning_detail_line%ROWTYPE;
    v_planned_space_local_id VARCHAR;
    v_new_regulation SCHEMANAME.plan_regulation%ROWTYPE;
    v_new_value RECORD;
    v_valid_from DATE;
    v_valid_to DATE;
BEGIN
    FOR v_planning_detail_line IN
        SELECT *
        FROM SCHEMANAME.planning_detail_line
        WHERE "type" = 3
    LOOP
        SELECT
            MIN(ze.valid_from),
            MAX(ze.valid_to)
        INTO v_valid_from, v_valid_to
        FROM SCHEMANAME.zoning_element ze
        JOIN SCHEMANAME.zoning_element_plan_detail_line zepdl ON ze.local_id = zepdl.zoning_element_local_id
        WHERE zepdl.planning_detail_line_local_id = v_planning_detail_line.local_id;

        INSERT INTO SCHEMANAME.plan_regulation ("type", life_cycle_status, valid_from, valid_to)
            VALUES ('0805', v_planning_detail_line.life_cycle_status, v_valid_from, v_valid_to)
            RETURNING * INTO v_new_regulation;
        
        INSERT INTO SCHEMANAME.numeric_double_value ("value", unit_of_measure, obligatory)
            VALUES (
                round(
                    degrees(
                        ST_Azimuth(
                            ST_StartPoint(ST_GeometryN(v_planning_detail_line.geom, 1)),
                            ST_EndPoint(ST_GeometryN(v_planning_detail_line.geom, 1))
                        )
                    )
                ), "deg", v_planning_detail_line.obligatory)
            RETURNING * INTO v_new_value;
        
        INSERT INTO SCHEMANAME.plan_regulation_numeric_double_value (fk_plan_regulation, fk_numeric_double_value)
            VALUES (v_new_regulation.local_id, v_new_value.numeric_double_value_uuid);
        
        FOR v_planned_space_local_id IN
            SELECT planned_space_local_id
            FROM SCHEMANAME.planned_space_plan_detail_line
            WHERE planning_detail_line_local_id = v_planning_detail_line.local_id
        LOOP
            INSERT INTO SCHEMANAME.planned_space_plan_regulation (planned_space_local_id, plan_regulation_local_id)
                VALUES (v_planned_space_local_id, v_new_regulation.local_id);
        END LOOP;

        DELETE FROM SCHEMANAME.planning_detail_line
            WHERE local_id = v_planning_detail_line.local_id;
    END LOOP;
END
$$ LANGUAGE plpgsql;

DO $$
DECLARE
    v_planning_detail_line SCHEMANAME.planning_detail_line%ROWTYPE;
    v_new_regulation SCHEMANAME.plan_regulation%ROWTYPE;
    v_valid_from SCHEMANAME.plan_regulation.valid_from%TYPE;
    v_valid_to SCHEMANAME.plan_regulation.valid_to%TYPE;
BEGIN
    FOR v_planning_detail_line IN
        SELECT *
        FROM SCHEMANAME.planning_detail_line
        WHERE "type" = 4
    LOOP
        SELECT
            MIN(ze.valid_from),
            MAX(ze.valid_to)
        INTO v_valid_from, v_valid_to
        FROM SCHEMANAME.zoning_element ze
        JOIN SCHEMANAME.zoning_element_plan_detail_line zepdl ON ze.local_id = zepdl.zoning_element_local_id
        WHERE zepdl.planning_detail_line_local_id = v_planning_detail_line.local_id;

        INSERT INTO SCHEMANAME.plan_regulation ("type", life_cycle_status, valid_from, valid_to)
            VALUES ('020313', v_planning_detail_line.life_cycle_status, v_valid_from, v_valid_to)
            RETURNING * INTO v_new_regulation;
        
        INSERT INTO SCHEMANAME.planning_detail_line_plan_regulation (planning_detail_line_local_id, plan_regulation_local_id)
            VALUES (v_planning_detail_line.local_id, v_new_regulation.local_id);
    END LOOP;
END
$$ LANGUAGE plpgsql;

DO $$
DECLARE
    v_planning_detail_line SCHEMANAME.planning_detail_line%ROWTYPE;
    v_new_regulation SCHEMANAME.plan_regulation%ROWTYPE;
    v_valid_from SCHEMANAME.plan_regulation.valid_from%TYPE;
    v_valid_to SCHEMANAME.plan_regulation.valid_to%TYPE;
BEGIN
    FOR v_planning_detail_line IN
        SELECT *
        FROM SCHEMANAME.planning_detail_line
        WHERE "type" = 5
    LOOP
        SELECT
            MIN(ze.valid_from),
            MAX(ze.valid_to)
        INTO v_valid_from, v_valid_to
        FROM SCHEMANAME.zoning_element ze
        JOIN SCHEMANAME.zoning_element_plan_detail_line zepdl ON ze.local_id = zepdl.zoning_element_local_id
        WHERE zepdl.planning_detail_line_local_id = v_planning_detail_line.local_id;

        INSERT INTO SCHEMANAME.plan_regulation ("type", life_cycle_status, valid_from, valid_to)
            VALUES ('020204', v_planning_detail_line.life_cycle_status, v_valid_from, v_valid_to)
            RETURNING * INTO v_new_regulation;
        
        INSERT INTO SCHEMANAME.planning_detail_line_plan_regulation (planning_detail_line_local_id, plan_regulation_local_id)
            VALUES (v_planning_detail_line.local_id, v_new_regulation.local_id);
    END LOOP;
END
$$ LANGUAGE plpgsql;

DELETE FROM SCHEMANAME.planning_detail_line pdl
    WHERE "type" IN (6, 7)
    AND NOT EXISTS (
        SELECT 1
        FROM SCHEMANAME.planning_detail_line_plan_regulation pdlpr
        WHERE pdlpr.planning_detail_line_local_id = pdl.local_id
    );

ALTER TABLE SCHEMANAME.planning_detail_line
    DROP COLUMN "type",
    DROP COLUMN "type_description";
