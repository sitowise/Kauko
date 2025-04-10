-- FUNCTION: $SCHEMANAME$.update_theme_for_zoning_element()

-- DROP FUNCTION IF EXISTS $SCHEMANAME$.update_theme_for_zoning_element();

CREATE OR REPLACE FUNCTION $SCHEMANAME$.update_theme_for_zoning_element()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
DECLARE
    _style text;
    _letter_identifier text;
BEGIN
    IF (NEW."style" IS NOT NULL AND NEW."localized_name" IS NOT NULL) THEN
        RETURN NEW;
    END IF;

    SELECT INTO
        _style, _letter_identifier
        PLAN_REGULATION_TYPE.style, PLAN_REGULATION_GROUP.letter_identifier 
    FROM $SCHEMANAME$.zoning_element ZE
    JOIN $SCHEMANAME$.zoning_element_plan_regulation_group ZEPRG ON ZEPRG.zoning_element_local_id = ZE.local_id 
    JOIN $SCHEMANAME$.plan_regulation_group PLAN_REGULATION_GROUP ON 
        (PLAN_REGULATION_GROUP.local_id = ZEPRG.plan_regulation_group_local_id AND PLAN_REGULATION_GROUP.letter_identifier IS NOT NULL) 
    JOIN $SCHEMANAME$.plan_regulation_group_regulation PRGR ON PRGR.plan_regulation_group_local_id = PLAN_REGULATION_GROUP.local_id 
    JOIN $SCHEMANAME$.plan_regulation PR ON PR.local_id = PRGR.plan_regulation_local_id 
    JOIN code_lists.detail_plan_regulation_kind PLAN_REGULATION_TYPE ON PLAN_REGULATION_TYPE.codevalue = PR.type
    WHERE
        ZE.local_id = NEW."local_id" AND
        PLAN_REGULATION_TYPE.style IS NOT NULL
    ORDER BY PLAN_REGULATION_GROUP.id, PR.id
    LIMIT 1;

    IF (_style IS NOT NULL AND NEW."style" IS NULL) THEN
        UPDATE $SCHEMANAME$.zoning_element SET style = _style WHERE local_id = NEW."local_id";
    END IF;

    IF (_letter_identifier IS NOT NULL AND NEW."localized_name" IS NULL) THEN
        UPDATE $SCHEMANAME$.zoning_element SET localized_name = _letter_identifier WHERE local_id = NEW."local_id";
    END IF;

    RETURN NEW;
END;
$BODY$;


-- Trigger: update_theme_for_zoning_element

-- DROP TRIGGER IF EXISTS update_theme_for_zoning_element ON $SCHEMANAME$.zoning_element;

CREATE CONSTRAINT TRIGGER update_theme_for_zoning_element
    AFTER INSERT
    ON $SCHEMANAME$.zoning_element
    DEFERRABLE INITIALLY DEFERRED
    FOR EACH ROW
    WHEN (pg_trigger_depth() < 1)
    EXECUTE FUNCTION $SCHEMANAME$.update_theme_for_zoning_element();
    