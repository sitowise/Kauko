DO $$
DECLARE
    v_planned_space SCHEMANAME.planned_space%ROWTYPE;
    v_new_regulation_local_id SCHEMANAME.plan_regulation.local_id%TYPE;
BEGIN
    FOR v_planned_space IN
        SELECT * FROM
            SCHEMANAME.planned_space
        WHERE
            "type" = 1
    LOOP
        IF NOT EXISTS (
            SELECT 1
            FROM SCHEMANAME.plan_regulation pr
            JOIN SCHEMANAME.planned_space_plan_regulation pspr
                ON pspr.planned_space_local_id = v_planned_space.local_id
                AND pspr.plan_regulation_local_id = pr.local_id
            WHERE
                pr."type" = '0403'
        ) THEN
            INSERT INTO SCHEMANAME.plan_regulation("type", "life_cycle_status", "valid_from", "valid_to")
            VALUES ('0403', v_planned_space."lifecycle_status", v_planned_space."valid_from", v_planned_space."valid_to")
            RETURNING local_id INTO v_new_regulation_local_id;

            INSERT INTO SCHEMANAME.planned_space_plan_regulation(planned_space_local_id, plan_regulation_local_id)
            VALUES (v_planned_space.local_id, v_new_regulation_local_id);
        END IF;
    END LOOP;
END
$$ LANGUAGE plpgsql;

ALTER TABLE SCHEMANAME.planned_space
    DROP COLUMN "type";
