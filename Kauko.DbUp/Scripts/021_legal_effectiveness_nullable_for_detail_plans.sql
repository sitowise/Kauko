ALTER TABLE $SCHEMANAME$.spatial_plan
ALTER COLUMN legal_effectiveness DROP NOT NULL;

ALTER TABLE $SCHEMANAME$.spatial_plan
ALTER COLUMN legal_effectiveness DROP DEFAULT;

UPDATE $SCHEMANAME$.spatial_plan
SET legal_effectiveness = NULL
WHERE "type" like '3%';

UPDATE $SCHEMANAME$.spatial_plan
SET legal_effectiveness = '1'
WHERE "type" like '2%' AND legal_effectiveness is null;

ALTER TABLE $SCHEMANAME$.spatial_plan
ADD CONSTRAINT check_legal_effectiveness
CHECK (
  (("type" LIKE '3%' AND legal_effectiveness IS NULL) OR
   ("type" LIKE '2%' AND legal_effectiveness IS NOT NULL))
);
