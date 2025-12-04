-- New value table: indentifier_value
---------------------------------------

-- Table: $SCHEMANAME$.indentifier_value 

-- DROP TABLE IF EXISTS $SCHEMANAME$.indentifier_value;

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.indentifier_value
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    indentifier_value_uuid uuid NOT NULL DEFAULT uuid_generate_v4(),
    value text NOT NULL,
    CONSTRAINT indentifier_value_pkey PRIMARY KEY (id),
    CONSTRAINT indentifier_value_indentifier_value_uuid_key UNIQUE (indentifier_value_uuid)
);

-- Add foreign keys

ALTER TABLE $SCHEMANAME$.plan_regulation
    ADD fk_indentifier_value uuid,
    ADD CONSTRAINT plan_regulation_fk_indentifier_value FOREIGN KEY (fk_indentifier_value)
    REFERENCES $SCHEMANAME$.indentifier_value(indentifier_value_uuid)
        ON DELETE CASCADE
        ON UPDATE CASCADE
        DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE $SCHEMANAME$.supplementary_information
    ADD fk_indentifier_value uuid,
    ADD CONSTRAINT supplementary_information_fk_indentifier_value FOREIGN KEY (fk_indentifier_value)
    REFERENCES $SCHEMANAME$.indentifier_value(indentifier_value_uuid)
        ON DELETE CASCADE
        ON UPDATE CASCADE
        DEFERRABLE INITIALLY DEFERRED;


-- Drop check constraints
---------------------------

ALTER TABLE $SCHEMANAME$.plan_regulation
    DROP CONSTRAINT IF EXISTS ensure_one_fk;

ALTER TABLE $SCHEMANAME$.supplementary_information
    DROP CONSTRAINT IF EXISTS ensure_one_fk;


-- Alter text_value table's value column
-------------------------------------------

ALTER TABLE $SCHEMANAME$.text_value
    DROP CONSTRAINT IF EXISTS text_value_value_check,
    DROP COLUMN IF EXISTS value,
    ADD value text;


-- New value table: localized_text_value
------------------------------------------

-- Table: $SCHEMANAME$.localized_text_value 

-- DROP TABLE IF EXISTS $SCHEMANAME$.localized_text_value;

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.localized_text_value (
	id int4 GENERATED ALWAYS AS IDENTITY,
	localized_text_value_uuid uuid DEFAULT uuid_generate_v4() NOT NULL,
	value jsonb NOT NULL,
	syntax text NULL,
	CONSTRAINT localized_text_value_pkey PRIMARY KEY (id),
	CONSTRAINT localized_text_value_localized_text_value_uuid_key UNIQUE (localized_text_value_uuid),
	CONSTRAINT localized_text_value_value_check CHECK (check_ryhti_language(value))
);

-- Add foreign keys

ALTER TABLE $SCHEMANAME$.plan_regulation
    ADD fk_localized_text_value uuid,
    ADD CONSTRAINT plan_regulation_fk_localized_text_value FOREIGN KEY (fk_localized_text_value)
    REFERENCES $SCHEMANAME$.localized_text_value(localized_text_value_uuid)
        ON DELETE CASCADE
        ON UPDATE CASCADE
        DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE $SCHEMANAME$.supplementary_information
    ADD fk_localized_text_value uuid,
    ADD CONSTRAINT supplementary_information_fk_localized_text_value FOREIGN KEY (fk_localized_text_value)
    REFERENCES $SCHEMANAME$.localized_text_value(localized_text_value_uuid)
        ON DELETE CASCADE
        ON UPDATE CASCADE
        DEFERRABLE INITIALLY DEFERRED;


-- Modify time_period_value table
-----------------------------------

ALTER TABLE $SCHEMANAME$.time_period_value
    DROP COLUMN IF EXISTS value,
    DROP COLUMN IF EXISTS time_period_from,
    DROP COLUMN IF EXISTS time_period_to,
    ADD time_period_begin timestamp with time zone NOT NULL,
    ADD time_period_end timestamp with time zone;


-- New value table: time_period_date_only_value
------------------------------------------

-- Table: $SCHEMANAME$.time_period_date_only_value 

-- DROP TABLE IF EXISTS $SCHEMANAME$.time_period_date_only_value;

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.time_period_date_only_value (
	id int4 GENERATED ALWAYS AS IDENTITY,
	time_period_date_only_value_uuid uuid DEFAULT uuid_generate_v4() NOT NULL,
	time_period_date_only_begin date NOT NULL,
    time_period_date_only_end date,
	CONSTRAINT time_period_date_only_value_pkey PRIMARY KEY (id),
	CONSTRAINT tpdo_value_time_period_date_only_value_uuid_key UNIQUE (time_period_date_only_value_uuid)
);

-- Add foreign keys

ALTER TABLE $SCHEMANAME$.plan_regulation
    ADD fk_time_period_date_only_value uuid,
    ADD CONSTRAINT plan_regulation_fk_time_period_date_only_value FOREIGN KEY (fk_time_period_date_only_value)
    REFERENCES $SCHEMANAME$.time_period_date_only_value(time_period_date_only_value_uuid)
        ON DELETE CASCADE
        ON UPDATE CASCADE
        DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE $SCHEMANAME$.supplementary_information
    ADD fk_time_period_date_only_value uuid,
    ADD CONSTRAINT supplementary_information_fk_time_period_date_only_value FOREIGN KEY (fk_time_period_date_only_value)
    REFERENCES $SCHEMANAME$.time_period_date_only_value(time_period_date_only_value_uuid)
        ON DELETE CASCADE
        ON UPDATE CASCADE
        DEFERRABLE INITIALLY DEFERRED;


-- Drop tables no longer needed
---------------------------------

-- Drop foreign keys and columns from plan_regulation and supplementary_information

ALTER TABLE $SCHEMANAME$.plan_regulation
    DROP CONSTRAINT IF EXISTS plan_regulation_fk_elevation_position_value,
    DROP CONSTRAINT IF EXISTS plan_regulation_fk_elevation_range_value,
    DROP CONSTRAINT IF EXISTS plan_regulation_fk_geometry_area_value,
    DROP CONSTRAINT IF EXISTS plan_regulation_fk_geometry_line_value,
    DROP CONSTRAINT IF EXISTS plan_regulation_fk_geometry_point_value,
    DROP CONSTRAINT IF EXISTS plan_regulation_fk_time_instant_value,
    DROP COLUMN IF EXISTS fk_elevation_position_value,
    DROP COLUMN IF EXISTS fk_elevation_range_value,
    DROP COLUMN IF EXISTS fk_geometry_area_value,
    DROP COLUMN IF EXISTS fk_geometry_line_value,
    DROP COLUMN IF EXISTS fk_geometry_point_value,
    DROP COLUMN IF EXISTS fk_time_instant_value;

ALTER TABLE $SCHEMANAME$.supplementary_information
    DROP CONSTRAINT IF EXISTS supplementary_information_fk_elevation_position_value,
    DROP CONSTRAINT IF EXISTS supplementary_information_fk_elevation_range_value,
    DROP CONSTRAINT IF EXISTS supplementary_information_fk_geometry_area_value,
    DROP CONSTRAINT IF EXISTS supplementary_information_fk_geometry_line_value,
    DROP CONSTRAINT IF EXISTS supplementary_information_fk_geometry_point_value,
    DROP CONSTRAINT IF EXISTS supplementary_information_fk_time_instant_value,
    DROP COLUMN IF EXISTS fk_elevation_position_value,
    DROP COLUMN IF EXISTS fk_elevation_range_value,
    DROP COLUMN IF EXISTS fk_geometry_area_value,
    DROP COLUMN IF EXISTS fk_geometry_line_value,
    DROP COLUMN IF EXISTS fk_geometry_point_value,
    DROP COLUMN IF EXISTS fk_time_instant_value;

-- Drop tables

DROP TABLE IF EXISTS $SCHEMANAME$.elevation_position_value;
DROP TABLE IF EXISTS $SCHEMANAME$.elevation_range_value;
DROP TABLE IF EXISTS $SCHEMANAME$.geometry_area_value;
DROP TABLE IF EXISTS $SCHEMANAME$.geometry_line_value;
DROP TABLE IF EXISTS $SCHEMANAME$.geometry_point_value;
DROP TABLE IF EXISTS $SCHEMANAME$.time_instant_value;
DROP TABLE IF EXISTS $SCHEMANAME$.time_period_date_only;


-- Add renewed check constraints
--------------------------------

ALTER TABLE $SCHEMANAME$.plan_regulation
    ADD CONSTRAINT ensure_one_fk
        CHECK (
            num_nonnulls(
                fk_code_value,
                fk_numeric_value,
                fk_numeric_range,
                fk_text_value,
                fk_indentifier_value,
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
                fk_numeric_range,
                fk_text_value,
                fk_indentifier_value,
                fk_localized_text_value,
                fk_time_period_value,
                fk_time_period_date_only_value
            ) = ANY (ARRAY[0, 1])
        );
