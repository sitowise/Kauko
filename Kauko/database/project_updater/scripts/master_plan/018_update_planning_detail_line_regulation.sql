ALTER TABLE SCHEMANAME.planning_detail_line
    ADD COLUMN name JSONB CHECK(check_language_string(name));

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
            VALUES ('0324', v_planning_detail_line.lifecycle_status, v_valid_from, v_valid_to)
            RETURNING * INTO v_new_regulation;

        INSERT INTO SCHEMANAME.planning_detail_line_plan_regulation (planning_detail_line_local_id, plan_regulation_local_id)
            VALUES (v_planning_detail_line.local_id, v_new_regulation.local_id);
    END LOOP;
END
$$ LANGUAGE plpgsql;

DELETE FROM SCHEMANAME.planning_detail_line pdl
    WHERE "type" <> 4
    AND NOT EXISTS (
        SELECT 1
        FROM SCHEMANAME.planning_detail_line_plan_regulation pdlpr
        WHERE pdlpr.planning_detail_line_local_id = pdl.local_id
    );

ALTER TABLE SCHEMANAME.planning_detail_line
    DROP COLUMN "type",
    DROP COLUMN "type_description";
