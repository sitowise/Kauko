-- Table: $SCHEMANAME$.cancelled_group_relations

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.cancelled_group_relations (
    -- UUID Key for Plan Regulation Group, primary key, not null
    id UUID NOT NULL DEFAULT uuid_generate_v4(),
    -- UUID Key for Plan Object, primary key, not null
    plan_object_id UUID NOT NULL DEFAULT uuid_generate_v4(),
    -- Descriptions as comments for better understanding and maintainability
    CONSTRAINT pk_cancelled_group_relations PRIMARY KEY (id, plan_object_id)
);


-- Table: $SCHEMANAME$.descriptors

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.descriptor (
    id TEXT NULL,
    vocabulary TEXT NULL,
    descriptor TEXT NULL
);


-- Table: $SCHEMANAME$.general_regulation_group

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.general_regulation_group (
    id UUID NOT NULL DEFAULT uuid_generate_v4(),
    plan_regulation_title JSONB,
    group_number INT,
    PRIMARY KEY (id),
    CONSTRAINT plan_regulation_title_check CHECK (check_ryhti_language(plan_regulation_title))
);


-- Table: $SCHEMANAME$.identifier_value

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.identifier_value (
    id SERIAL PRIMARY KEY,
    identifier_value TEXT,
    register_id TEXT,
    register_name JSONB,
    data_type VARCHAR(100) NOT NULL CHECK (data_type = 'Identifier'),
    CONSTRAINT identifier_value_register_name_check CHECK (check_ryhti_language(register_name))
);


-- Table: $SCHEMANAME$.localized_text_values

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.localized_text (
    localized_text_value_id SERIAL PRIMARY KEY,
    language_string_id INT,
    text JSONB,
    syntax TEXT,
    data_type VARCHAR(100) NOT NULL CHECK (data_type = 'LocalizedText'),
    CONSTRAINT localized_text_text_check CHECK (check_ryhti_language(text))
);


-- Table: $SCHEMANAME$.numeric_range

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.numeric_range (
    numeric_range_id SERIAL PRIMARY KEY,
    minimum_value INT,
    maximum_value INT,
    unit_of_measure TEXT,
    data_type VARCHAR(100) NOT NULL CHECK (data_type = 'NumericRange')
);


-- Table: $SCHEMANAME$.numeric_value

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.numeric_value (
    numeric_value_id SERIAL PRIMARY KEY,
    number INT,
    unit_of_measure TEXT,
    data_type VARCHAR(100) NOT NULL CHECK (data_type = 'Numeric')
);


-- Table: $SCHEMANAME$.partially_cancelled_plan_object_info

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.partially_cancelled_plan_object_info (
    partially_cancelled_plan_object_id UUID PRIMARY KEY,
    validity_geometry GEOMETRY,
    description TEXT
);


-- Table: $SCHEMANAME$.plan_cancellation_info

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.plan_cancellation_info (
    plan_cancellation_info_key UUID PRIMARY KEY,
    cancelled_plan_id UUID NOT NULL,
    cancels_entire_plan BOOLEAN NOT NULL,
    cancelled_plan_object_ids UUID[],
    cancelled_regulation_ids UUID[],
    cancelled_guidance_ids UUID[],
    description TEXT
);


-- Table: $SCHEMANAME$.plan_decision

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.plan_decision (
    id UUID PRIMARY KEY,
    local_id TEXT NOT NULL DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    decision_date DATE NOT NULL,
    decision_adoption_date DATE NOT NULL,
    decision_id VARCHAR(255),
    decisionmaker_type VARCHAR(255) NOT NULL,
    fk_decision_maker TEXT,
    decision_text JSONB,
    decision_article JSONB,
    decision_documents JSONB,
    statutes JSONB,
    fk_spatial_plan TEXT NOT NULL,
    plans JSONB,
    date_of_validity DATE,
    CONSTRAINT plan_decision_local_id_key UNIQUE (local_id),
    CONSTRAINT plan_decision_decision_text_check CHECK (check_ryhti_language(decision_text)),
    CONSTRAINT plan_decision_decision_article_check CHECK (check_ryhti_language(decision_article)),
    CONSTRAINT plan_decision_fk_decision_maker_fkey FOREIGN KEY (fk_decision_maker)
        REFERENCES $SCHEMANAME$.plan_operator (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT plan_decision_fk_spatial_plan_fkey FOREIGN KEY (fk_spatial_plan)
        REFERENCES $SCHEMANAME$.spatial_plan (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
);


-- Table: $SCHEMANAME$.plan_map

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.plan_map (
    plan_map_key UUID PRIMARY KEY,
    name JSONB,
    file_key UUID NOT NULL,
    coordinate_system VARCHAR(255) NOT NULL,
    CONSTRAINT plan_map_name_check CHECK (check_ryhti_language(name))
);


-- Table: $SCHEMANAME$.plan_matter_phase

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.plan_matter_phase (
    plan_matter_phase_key UUID PRIMARY KEY,
    life_cycle_status VARCHAR(255) NOT NULL,
    geographical_area GEOMETRY,
    plan_handling_event UUID,  -- Reference to a PlanHandlingEvent, assuming it has its own table
    interaction_events UUID[],
    plan_decision UUID  -- Reference to a PlanDecision, assuming it has its own table
);


-- Table: $SCHEMANAME$.plan_regulation_group_relation

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.plan_regulation_group_relation (
    plan_object_key UUID NOT NULL,
    plan_regulation_group_key UUID NOT NULL,
    PRIMARY KEY (plan_object_key, plan_regulation_group_key)
);


-- Table: $SCHEMANAME$.plan_source_data

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.plan_source_data (
    plan_source_data_key UUID PRIMARY KEY,
    type VARCHAR(255) NOT NULL,
    name JSONB,
    geographical_area GEOMETRY,
    additional_information_link TEXT,
    files JSONB,
    CONSTRAINT plan_source_data_name_check CHECK (check_ryhti_language(name))
);


-- Table: $SCHEMANAME$.positive_decimal_range

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.positive_decimal_range (
    positive_decimal_range_id SERIAL PRIMARY KEY,
    minimum_value NUMERIC,
    maximum_value NUMERIC,
    unit_of_measure VARCHAR(255),
    data_type VARCHAR(100) NOT NULL CHECK (data_type = 'PositiveDecimalRange')
);


-- Table: $SCHEMANAME$.positive_decimal_value

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.positive_decimal_value (
    positive_decimal_value_id SERIAL PRIMARY KEY,
    number NUMERIC CHECK (number >= 0),
    unit_of_measure VARCHAR(255),
    data_type VARCHAR(100) NOT NULL CHECK (data_type = 'PositiveDecimal')
);


-- Table: $SCHEMANAME$.positive_numeric_range

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.positive_numeric_range (
    positive_numeric_range_id SERIAL PRIMARY KEY,
    minimum_value INT CHECK (minimum_value >= 0),
    maximum_value INT CHECK (maximum_value >= 0),
    unit_of_measure VARCHAR(255),
    data_type VARCHAR(100) NOT NULL CHECK (data_type = 'PositiveNumericRange')
);


-- Table: $SCHEMANAME$.positive_numeric_value

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.positive_numeric_value (
    positive_numeric_value_id SERIAL PRIMARY KEY,
    number INT CHECK (number >= 0),
    unit_of_measure VARCHAR(255),
    data_type VARCHAR(100) NOT NULL CHECK (data_type = 'PositiveNumeric')
);


-- Table: $SCHEMANAME$.statute

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.statute (
    statute_id SERIAL PRIMARY KEY,
    local_id TEXT NOT NULL DEFAULT uuid_generate_v4(),
    name_of_statute JSONB,
    number_of_statute_collection INT,
    year_of_statute_collection INT,
    chapter INT,
    section INT,
    subsections INT[],
    paragraphs INT[],
    subparagraphs TEXT[],
    CONSTRAINT statute_local_id_key UNIQUE (local_id),
    CONSTRAINT statute_name_of_statute_check CHECK (check_ryhti_language(name_of_statute))
);


-- Table: $SCHEMANAME$.time_period_date_only

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.time_period_date_only (
    time_period_id SERIAL PRIMARY KEY,
    begin_date DATE,
    end_date DATE
);


-- Table: $SCHEMANAME$.spatial_plan_plan_regulation_group

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.spatial_plan_plan_regulation_group (
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    spatial_plan_local_id TEXT NOT NULL,
    plan_regulation_group_local_id TEXT NOT NULL,
    CONSTRAINT spatial_plan_plan_regulation_group_pkey PRIMARY KEY (id),
    CONSTRAINT spatial_plan_plan_regulation_group_fk_spatial_plan_local_id FOREIGN KEY (spatial_plan_local_id)
        REFERENCES $SCHEMANAME$.spatial_plan (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT spatial_plan_plan_regulation_group_fk_plan_regulation_group_local_id FOREIGN KEY (plan_regulation_group_local_id)
        REFERENCES $SCHEMANAME$.plan_regulation_group (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED
);


-- Table: $SCHEMANAME$.plan_decision_statutes

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.plan_decision_statutes (
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    statute_local_id TEXT NOT NULL,
    decision_local_id TEXT NOT NULL,
    CONSTRAINT plan_decision_statutes_pkey PRIMARY KEY (id),
    CONSTRAINT plan_decision_statutes_fk_statute FOREIGN KEY (statute_local_id)
        REFERENCES $SCHEMANAME$.statute (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT plan_decision_statutes_fk_decision FOREIGN KEY (decision_local_id)
        REFERENCES $SCHEMANAME$.plan_decision (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED
);


-- Table: $SCHEMANAME$.decision_document

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.decision_document (
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    decision_local_id TEXT NOT NULL,
    document_local_id TEXT NOT NULL,
    role JSONB,
    CONSTRAINT decision_document_pkey PRIMARY KEY (id),
    CONSTRAINT decision_document_fk_decision FOREIGN KEY (decision_local_id)
        REFERENCES $SCHEMANAME$.plan_decision (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT decision_document_fk_document FOREIGN KEY (document_local_id)
        REFERENCES $SCHEMANAME$.document (local_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED
);
