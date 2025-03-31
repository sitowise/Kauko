INSERT INTO $SCHEMANAME$.plan_regulation_supplementary_information (fk_plan_regulation, fk_supplementary_information)
SELECT fk_plan_regulation, local_id
FROM $SCHEMANAME$.supplementary_information;

ALTER TABLE $SCHEMANAME$.supplementary_information
DROP CONSTRAINT supplementary_information_fk_plan_regulation;

ALTER TABLE $SCHEMANAME$.supplementary_information
DROP COLUMN fk_plan_regulation;
