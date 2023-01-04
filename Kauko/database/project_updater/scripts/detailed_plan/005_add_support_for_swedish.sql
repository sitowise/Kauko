ALTER TABLE SCHEMANAME.spatial_plan
RENAME COLUMN name TO name_fi;

ALTER TABLE SCHEMANAME.spatial_plan
RENAME COLUMN alternative_name to name_sv;

ALTER TABLE SCHEMANAME.spatial_plan
ALTER COLUMN name_fi DROP NOT NULL;

ALTER TABLE SCHEMANAME.spatial_plan
ADD CONSTRAINT name_not_null_check
CHECK (
    CASE
        WHEN language = 1 AND name_fi IS NOT NULL THEN TRUE
        WHEN language = 2 AND name_sv IS NOT NULL THEN TRUE
        WHEN language = 3 AND (name_fi IS NOT NULL OR name_sv IS NOT NULL) THEN TRUE
        ELSE FALSE
    END
)