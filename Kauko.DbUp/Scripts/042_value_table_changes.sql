-- Drop check constraints
---------------------------

ALTER TABLE $SCHEMANAME$.plan_regulation
    DROP CONSTRAINT IF EXISTS ensure_one_fk;

ALTER TABLE $SCHEMANAME$.supplementary_information
    DROP CONSTRAINT IF EXISTS ensure_one_fk;


-- Drop misspelled table indentifier_value
--------------------------------------------

-- Drop foreign keys and columns from plan_regulation and supplementary_information

ALTER TABLE $SCHEMANAME$.plan_regulation
    DROP CONSTRAINT IF EXISTS plan_regulation_fk_indentifier_value,
    DROP COLUMN IF EXISTS fk_indentifier_value;

ALTER TABLE $SCHEMANAME$.supplementary_information
    DROP CONSTRAINT IF EXISTS supplementary_information_fk_indentifier_value,
    DROP COLUMN IF EXISTS fk_indentifier_value;

-- Drop table

DROP TABLE IF EXISTS $SCHEMANAME$.indentifier_value;


-- Add uuid and value for identifier_value
--------------------------------------------

ALTER TABLE $SCHEMANAME$.identifier_value
    ADD COLUMN identifier_value_uuid UUID NOT NULL DEFAULT uuid_generate_v4(),
    ADD COLUMN value TEXT NOT NULL,
    ADD CONSTRAINT identifier_value_identifier_value_uuid_key UNIQUE (identifier_value_uuid);


-- Drop columns data_type and identifier_value from identifier_value
----------------------------------------------------------------------

ALTER TABLE $SCHEMANAME$.identifier_value
    DROP COLUMN IF EXISTS data_type,
    DROP COLUMN IF EXISTS identifier_value;


-- Add foreign keys for identifier_value
------------------------------------------

ALTER TABLE $SCHEMANAME$.plan_regulation
    ADD fk_identifier_value uuid,
    ADD CONSTRAINT plan_regulation_fk_identifier_value FOREIGN KEY (fk_identifier_value)
    REFERENCES $SCHEMANAME$.identifier_value(identifier_value_uuid)
        ON DELETE CASCADE
        ON UPDATE CASCADE
        DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE $SCHEMANAME$.supplementary_information
    ADD fk_identifier_value uuid,
    ADD CONSTRAINT supplementary_information_fk_identifier_value FOREIGN KEY (fk_identifier_value)
    REFERENCES $SCHEMANAME$.identifier_value(identifier_value_uuid)
        ON DELETE CASCADE
        ON UPDATE CASCADE
        DEFERRABLE INITIALLY DEFERRED;


-- Rename table numeric_range --> numeric_range_value
-------------------------------------------------------

ALTER TABLE $SCHEMANAME$.plan_regulation
    DROP CONSTRAINT IF EXISTS plan_regulation_fk_numeric_range,
    DROP COLUMN IF EXISTS fk_numeric_range;

ALTER TABLE $SCHEMANAME$.supplementary_information
    DROP CONSTRAINT IF EXISTS supplementary_information_fk_numeric_range,
    DROP COLUMN IF EXISTS fk_numeric_range;

DROP TABLE IF EXISTS $SCHEMANAME$.numeric_range;

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.numeric_range_value
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    numeric_range_value_uuid uuid NOT NULL DEFAULT uuid_generate_v4(),
    minimum_value double precision,
    maximum_value double precision,
    unit_of_measure TEXT,
    CONSTRAINT numeric_range_value_pkey PRIMARY KEY (id),
    CONSTRAINT numeric_range_numeric_range_value_uuid_key UNIQUE (numeric_range_value_uuid),
    CONSTRAINT numeric_range_value_check CHECK (minimum_value <= maximum_value)
);

ALTER TABLE $SCHEMANAME$.plan_regulation
    ADD fk_numeric_range_value uuid,
    ADD CONSTRAINT plan_regulation_fk_numeric_range_value FOREIGN KEY (fk_numeric_range_value)
    REFERENCES $SCHEMANAME$.numeric_range_value(numeric_range_value_uuid)
        ON DELETE CASCADE
        ON UPDATE CASCADE
        DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE $SCHEMANAME$.supplementary_information
    ADD fk_numeric_range_value uuid,
    ADD CONSTRAINT supplementary_information_fk_numeric_range_value FOREIGN KEY (fk_numeric_range_value)
    REFERENCES $SCHEMANAME$.numeric_range_value(numeric_range_value_uuid)
        ON DELETE CASCADE
        ON UPDATE CASCADE
        DEFERRABLE INITIALLY DEFERRED;


-- Drop useless table localized_text
--------------------------------------

DROP TABLE IF EXISTS $SCHEMANAME$.localized_text;


-- Add check constraints
---------------------------

ALTER TABLE $SCHEMANAME$.plan_regulation
    ADD CONSTRAINT ensure_one_fk
        CHECK (
            num_nonnulls(
                fk_code_value,
                fk_numeric_value,
                fk_numeric_range_value,
                fk_text_value,
                fk_identifier_value,
                fk_localized_text_value,
                fk_time_period_value,
                fk_time_period_date_only_value
            ) = ANY (ARRAY[0, 1])
        );

ALTER TABLE $SCHEMANAME$.supplementary_information
    ADD CONSTRAINT ensure_one_fk
        CHECK (
            num_nonnulls(
                fk_code_value,
                fk_numeric_value,
                fk_numeric_range_value,
                fk_text_value,
                fk_identifier_value,
                fk_localized_text_value,
                fk_time_period_value,
                fk_time_period_date_only_value
            ) = ANY (ARRAY[0, 1])
        );
