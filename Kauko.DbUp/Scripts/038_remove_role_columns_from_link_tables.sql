ALTER TABLE $SCHEMANAME$.decision_document DROP COLUMN IF EXISTS "role";
ALTER TABLE $SCHEMANAME$.document_document DROP COLUMN IF EXISTS "role";
ALTER TABLE $SCHEMANAME$.plan_guidance_document DROP COLUMN IF EXISTS "role";
ALTER TABLE $SCHEMANAME$.plan_regulation_document DROP COLUMN IF EXISTS "role";
ALTER TABLE $SCHEMANAME$.spatial_plan_document DROP COLUMN IF EXISTS "role";
