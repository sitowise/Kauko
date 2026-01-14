-- Drop tables not in use
---------------------------

DROP TABLE IF EXISTS $SCHEMANAME$.plan_map;

-- Drop useless columns from document
---------------------------------------

ALTER TABLE $SCHEMANAME$.document
    DROP COLUMN IF EXISTS metadata,
    DROP COLUMN IF EXISTS descriptor;
