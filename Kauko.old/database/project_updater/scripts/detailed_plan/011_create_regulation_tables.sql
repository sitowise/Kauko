CREATE TABLE SCHEMANAME.plan_regulation_group (
  id SERIAL PRIMARY KEY,
  local_id VARCHAR NOT NULL UNIQUE,
  identity_id UUID DEFAULT uuid_generate_v4() NOT NULL,
  namespace VARCHAR,
  reference_id VARCHAR,
  latest_change TIMESTAMP DEFAULT now() NOT NULL,
  producer_specific_id UUID DEFAULT uuid_generate_v4(),
  storage_time TIMESTAMP DEFAULT now() NOT NULL,
  name JSONB CHECK(check_language_string(name)),
  group_number INTEGER NOT NULL
);

CREATE TRIGGER plan_regulation_group_modified_trigger
  BEFORE INSERT OR UPDATE ON SCHEMANAME.plan_regulation_group
  FOR EACH ROW EXECUTE PROCEDURE versioned_object_modified_trigger();

CREATE TRIGGER create_plan_regulatrion_group_local_id_trigger
  BEFORE INSERT ON SCHEMANAME.plan_regulation_group
  FOR EACH ROW EXECUTE PROCEDURE create_local_id_trigger();

CREATE TABLE SCHEMANAME.zoning_element_plan_regulation_group(
  id SERIAL PRIMARY KEY,
  zoning_element_local_id VARCHAR NOT NULL,
  plan_regulation_group_local_id VARCHAR NOT NULL,
  UNIQUE (zoning_element_local_id, plan_regulation_group_local_id),
  CONSTRAINT fk_zoning_element
    FOREIGN KEY (zoning_element_local_id)
    REFERENCES SCHEMANAME.zoning_element (local_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
    DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT fk_plan_regulation_group
    FOREIGN KEY (plan_regulation_group_local_id)
    REFERENCES SCHEMANAME.plan_regulation_group (local_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
    DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE SCHEMANAME.planned_space_plan_regulation_group(
  id SERIAL PRIMARY KEY,
  planned_space_local_id VARCHAR NOT NULL,
  plan_regulation_group_local_id VARCHAR NOT NULL,
  UNIQUE (planned_space_local_id, plan_regulation_group_local_id),
  CONSTRAINT fk_planned_space
    FOREIGN KEY (planned_space_local_id)
    REFERENCES SCHEMANAME.planned_space (local_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
    DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT fk_plan_regulation_group
    FOREIGN KEY (plan_regulation_group_local_id)
    REFERENCES SCHEMANAME.plan_regulation_group (local_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
    DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE SCHEMANAME.plan_regulation (
  id SERIAL PRIMARY KEY,
  local_id VARCHAR NOT NULL UNIQUE,
  identity_id UUID DEFAULT uuid_generate_v4() NOT NULL,
  namespace VARCHAR,
  reference_id VARCHAR,
  latest_change TIMESTAMP DEFAULT now() NOT NULL,
  producer_specific_id UUID DEFAULT uuid_generate_v4(),
  storage_time TIMESTAMP DEFAULT now() NOT NULL,
  name JSONB CHECK(check_language_string(name)),
  type VARCHAR NOT NULL,
  life_cycle_status VARCHAR NOT NULL,
  validity_time TSRANGE,
  CONSTRAINT fk_type
    FOREIGN KEY (type)
      REFERENCES code_lists.detail_plan_regulation_kind (codevalue)
      ON UPDATE CASCADE
      ON DELETE NO ACTION
      DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT fk_life_cycle_status
    FOREIGN KEY (life_cycle_status)
      REFERENCES code_lists.spatial_plan_lifecycle_status (codevalue)
      ON UPDATE CASCADE
      ON DELETE NO ACTION
      DEFERRABLE INITIALLY DEFERRED
);

CREATE TRIGGER plan_regulation_modified_trigger
  BEFORE INSERT OR UPDATE ON SCHEMANAME.plan_regulation
  FOR EACH ROW EXECUTE PROCEDURE versioned_object_modified_trigger();

CREATE TRIGGER create_plan_regulation_local_id_trigger
  BEFORE INSERT ON SCHEMANAME.plan_regulation
  FOR EACH ROW EXECUTE PROCEDURE create_local_id_trigger();

CREATE TABLE SCHEMANAME.plan_regulation_theme(
  id SERIAL PRIMARY KEY,
  plan_regulation_local_id VARCHAR NOT NULL,
  theme_code VARCHAR NOT NULL,
  UNIQUE (plan_regulation_local_id, theme_code),
  CONSTRAINT fk_theme
    FOREIGN KEY (theme_code)
      REFERENCES code_lists.detail_plan_theme (codevalue)
      ON UPDATE CASCADE
      ON DELETE NO ACTION
      DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT fk_plan_regulation
    FOREIGN KEY (plan_regulation_local_id)
      REFERENCES SCHEMANAME.plan_regulation (local_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE SCHEMANAME.plan_regulation_document(
  id SERIAL PRIMARY KEY,
  plan_regulation_local_id VARCHAR NOT NULL,
  document_local_id VARCHAR NOT NULL,
  role JSONB CHECK(check_language_string(role)),
  UNIQUE (plan_regulation_local_id, document_local_id),
  CONSTRAINT fk_document
    FOREIGN KEY (document_local_id)
      REFERENCES SCHEMANAME.document (local_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT fk_plan_regulation
    FOREIGN KEY (plan_regulation_local_id)
      REFERENCES SCHEMANAME.plan_regulation (local_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE SCHEMANAME.plan_regulation_group_regulation(
  id SERIAL PRIMARY KEY,
  plan_regulation_group_local_id VARCHAR NOT NULL,
  plan_regulation_local_id VARCHAR NOT NULL,
  UNIQUE (plan_regulation_group_local_id, plan_regulation_local_id),
  CONSTRAINT fk_plan_regulation_group
    FOREIGN KEY (plan_regulation_group_local_id)
      REFERENCES SCHEMANAME.plan_regulation_group (local_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT fk_plan_regulation
    FOREIGN KEY (plan_regulation_local_id)
      REFERENCES SCHEMANAME.plan_regulation (local_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE SCHEMANAME.spatial_plan_plan_regulation(
  id SERIAL PRIMARY KEY,
  spatial_plan_local_id VARCHAR NOT NULL,
  plan_regulation_local_id VARCHAR NOT NULL,
  UNIQUE (spatial_plan_local_id, plan_regulation_local_id),
  CONSTRAINT fk_spatial_plan
    FOREIGN KEY (spatial_plan_local_id)
      REFERENCES SCHEMANAME.spatial_plan (local_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT fk_plan_regulation
    FOREIGN KEY (plan_regulation_local_id)
      REFERENCES SCHEMANAME.plan_regulation (local_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE SCHEMANAME.zoning_element_plan_regulation(
  id SERIAL PRIMARY KEY,
  zoning_element_local_id VARCHAR NOT NULL,
  plan_regulation_local_id VARCHAR NOT NULL,
  UNIQUE (zoning_element_local_id, plan_regulation_local_id),
  CONSTRAINT fk_zoning_element
    FOREIGN KEY (zoning_element_local_id)
      REFERENCES SCHEMANAME.zoning_element (local_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT fk_plan_regulation
    FOREIGN KEY (plan_regulation_local_id)
      REFERENCES SCHEMANAME.plan_regulation (local_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE SCHEMANAME.planned_space_plan_regulation(
  id SERIAL PRIMARY KEY,
  planned_space_local_id VARCHAR NOT NULL,
  plan_regulation_local_id VARCHAR NOT NULL,
  UNIQUE (planned_space_local_id, plan_regulation_local_id),
  CONSTRAINT fk_planned_space
    FOREIGN KEY (planned_space_local_id)
      REFERENCES SCHEMANAME.planned_space (local_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT fk_plan_regulation
    FOREIGN KEY (plan_regulation_local_id)
      REFERENCES SCHEMANAME.plan_regulation (local_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE SCHEMANAME.plan_guidance(
  id SERIAL PRIMARY KEY,
  local_id VARCHAR NOT NULL UNIQUE,
  identity_id UUID DEFAULT uuid_generate_v4() NOT NULL,
  namespace VARCHAR,
  reference_id VARCHAR,
  latest_change TIMESTAMP DEFAULT now() NOT NULL,
  producer_specific_id UUID DEFAULT uuid_generate_v4(),
  storage_time TIMESTAMP DEFAULT now() NOT NULL,
  name JSONB CHECK(check_language_string(name)),
  life_cycle_status VARCHAR NOT NULL,
  validity_time TSRANGE,
  CONSTRAINT fk_life_cycle_status
    FOREIGN KEY (life_cycle_status)
      REFERENCES code_lists.spatial_plan_lifecycle_status (codevalue)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED
);

CREATE TRIGGER plan_guidance_modified_trigger
  BEFORE INSERT OR UPDATE ON SCHEMANAME.plan_guidance
  FOR EACH ROW EXECUTE PROCEDURE versioned_object_modified_trigger();

CREATE TRIGGER create_plan_guidance_local_id_trigger
  BEFORE INSERT ON SCHEMANAME.plan_guidance
  FOR EACH ROW EXECUTE PROCEDURE create_local_id_trigger();

CREATE TABLE SCHEMANAME.plan_guidance_theme(
  id SERIAL PRIMARY KEY,
  plan_guidance_local_id VARCHAR NOT NULL,
  theme_code VARCHAR NOT NULL,
  UNIQUE (plan_guidance_local_id, theme_code),
  CONSTRAINT fk_theme
    FOREIGN KEY (theme_code)
      REFERENCES code_lists.detail_plan_theme (codevalue)
      ON UPDATE CASCADE
      ON DELETE NO ACTION
      DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT fk_plan_guidance
    FOREIGN KEY (plan_guidance_local_id)
      REFERENCES SCHEMANAME.plan_guidance (local_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE SCHEMANAME.plan_guidance_document(
  id SERIAL PRIMARY KEY,
  plan_guidance_local_id VARCHAR NOT NULL,
  document_local_id VARCHAR NOT NULL,
  role JSONB CHECK(check_language_string(role)),
  UNIQUE (plan_guidance_local_id, document_local_id),
  CONSTRAINT fk_document
    FOREIGN KEY (document_local_id)
      REFERENCES SCHEMANAME.document (local_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT fk_plan_guidance
    FOREIGN KEY (plan_guidance_local_id)
      REFERENCES SCHEMANAME.plan_guidance (local_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE SCHEMANAME.spatial_plan_plan_guidance(
  id SERIAL PRIMARY KEY,
  spatial_plan_local_id VARCHAR NOT NULL,
  plan_guidance_local_id VARCHAR NOT NULL,
  UNIQUE (spatial_plan_local_id, plan_guidance_local_id),
  CONSTRAINT fk_spatial_plan
    FOREIGN KEY (spatial_plan_local_id)
      REFERENCES SCHEMANAME.spatial_plan (local_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT fk_plan_guidance
    FOREIGN KEY (plan_guidance_local_id)
      REFERENCES SCHEMANAME.plan_guidance (local_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE SCHEMANAME.zoning_element_plan_guidance(
  id SERIAL PRIMARY KEY,
  zoning_element_local_id VARCHAR NOT NULL,
  plan_guidance_local_id VARCHAR NOT NULL,
  UNIQUE (zoning_element_local_id, plan_guidance_local_id),
  CONSTRAINT fk_zoning_element
    FOREIGN KEY (zoning_element_local_id)
      REFERENCES SCHEMANAME.zoning_element (local_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT fk_plan_guidance
    FOREIGN KEY (plan_guidance_local_id)
      REFERENCES SCHEMANAME.plan_guidance (local_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE SCHEMANAME.planned_space_plan_guidance(
  id SERIAL PRIMARY KEY,
  planned_space_local_id VARCHAR NOT NULL,
  plan_guidance_local_id VARCHAR NOT NULL,
  UNIQUE (planned_space_local_id, plan_guidance_local_id),
  CONSTRAINT fk_planned_space
    FOREIGN KEY (planned_space_local_id)
      REFERENCES SCHEMANAME.planned_space (local_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT fk_plan_guidance
    FOREIGN KEY (plan_guidance_local_id)
      REFERENCES SCHEMANAME.plan_guidance (local_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE SCHEMANAME.supplementary_information (
  id SERIAL PRIMARY KEY,
  producer_specific_id UUID DEFAULT uuid_generate_v4() UNIQUE,
  type VARCHAR NOT NULL,
  name JSONB CHECK(check_language_string(name)),
  fk_plan_regulation VARCHAR NOT NULL,
  CONSTRAINT fk_type
    FOREIGN KEY (type)
      REFERENCES code_lists.detail_plan_addition_information_kind (codevalue)
      ON UPDATE CASCADE
      ON DELETE NO ACTION,
  CONSTRAINT fk_plan_regulation
    FOREIGN KEY (fk_plan_regulation)
      REFERENCES SCHEMANAME.plan_regulation(local_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE SCHEMANAME.plan_regulation_supplementary_information (
  id SERIAL PRIMARY KEY,
  fk_plan_regulation VARCHAR NOT NULL,
  fk_supplementary_information UUID NOT NULL,
  UNIQUE (fk_plan_regulation, fk_supplementary_information),
  CONSTRAINT fk_plan_regulation
    FOREIGN KEY (fk_plan_regulation)
      REFERENCES SCHEMANAME.plan_regulation(local_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT fk_supplementary_information
    FOREIGN KEY (fk_supplementary_information)
      REFERENCES SCHEMANAME.supplementary_information(producer_specific_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE SCHEMANAME.numeric_double_value (
  id SERIAL PRIMARY KEY,
  numeric_double_value_uuid UUID DEFAULT uuid_generate_v4() UNIQUE NOT NULL,
  value DOUBLE PRECISION NOT NULL,
  unit_of_measure VARCHAR,
  obligatory BOOLEAN NOT NULL
);

CREATE TABLE SCHEMANAME.plan_regulation_numeric_double_value(
  id SERIAL PRIMARY KEY,
  fk_plan_regulation VARCHAR NOT NULL,
  fk_numeric_double_value UUID NOT NULL,
  UNIQUE (fk_plan_regulation, fk_numeric_double_value),
  CONSTRAINT fk_plan_regulation
    FOREIGN KEY (fk_plan_regulation)
      REFERENCES SCHEMANAME.plan_regulation(local_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT fk_numeric_double_value
    FOREIGN KEY (fk_numeric_double_value)
      REFERENCES SCHEMANAME.numeric_double_value(numeric_double_value_uuid)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE SCHEMANAME.plan_guidance_numeric_double_value(
  id SERIAL PRIMARY KEY,
  fk_plan_guidance VARCHAR NOT NULL,
  fk_numeric_double_value UUID NOT NULL,
  UNIQUE (fk_plan_guidance, fk_numeric_double_value),
  CONSTRAINT fk_plan_guidance
    FOREIGN KEY (fk_plan_guidance)
      REFERENCES SCHEMANAME.plan_guidance(local_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT fk_numeric_double_value
    FOREIGN KEY (fk_numeric_double_value)
      REFERENCES SCHEMANAME.numeric_double_value(numeric_double_value_uuid)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE SCHEMANAME.supplementary_information_numeric_double_value(
  id SERIAL PRIMARY KEY,
  fk_supplementary_information UUID NOT NULL,
  fk_numeric_double_value UUID NOT NULL,
  UNIQUE (fk_supplementary_information, fk_numeric_double_value),
  CONSTRAINT fk_supplementary_information
    FOREIGN KEY (fk_supplementary_information)
      REFERENCES SCHEMANAME.supplementary_information(producer_specific_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT fk_numeric_double_value
    FOREIGN KEY (fk_numeric_double_value)
      REFERENCES SCHEMANAME.numeric_double_value(numeric_double_value_uuid)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE SCHEMANAME.numeric_range (
  id SERIAL PRIMARY KEY,
  numeric_range_uuid UUID DEFAULT uuid_generate_v4() UNIQUE NOT NULL,
  minimum_value DOUBLE PRECISION,
  maximum_value DOUBLE PRECISION,
  unit_of_measure VARCHAR,
  CONSTRAINT numeric_range_value_check CHECK (minimum_value <= maximum_value)
);

CREATE TABLE SCHEMANAME.plan_regulation_numeric_range(
  id SERIAL PRIMARY KEY,
  fk_plan_regulation VARCHAR NOT NULL,
  fk_numeric_range UUID NOT NULL,
  UNIQUE (fk_plan_regulation, fk_numeric_range),
  CONSTRAINT fk_plan_regulation
    FOREIGN KEY (fk_plan_regulation)
      REFERENCES SCHEMANAME.plan_regulation(local_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT fk_numeric_range
    FOREIGN KEY (fk_numeric_range)
      REFERENCES SCHEMANAME.numeric_range(numeric_range_uuid)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE SCHEMANAME.plan_guidance_numeric_range(
  id SERIAL PRIMARY KEY,
  fk_plan_guidance VARCHAR NOT NULL,
  fk_numeric_range UUID NOT NULL,
  UNIQUE (fk_plan_guidance, fk_numeric_range),
  CONSTRAINT fk_plan_guidance
    FOREIGN KEY (fk_plan_guidance)
      REFERENCES SCHEMANAME.plan_guidance(local_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT fk_numeric_range
    FOREIGN KEY (fk_numeric_range)
      REFERENCES SCHEMANAME.numeric_range(numeric_range_uuid)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE SCHEMANAME.supplementary_information_numeric_range(
  id SERIAL PRIMARY KEY,
  fk_supplementary_information UUID NOT NULL,
  fk_numeric_range UUID NOT NULL,
  UNIQUE (fk_supplementary_information, fk_numeric_range),
  CONSTRAINT fk_supplementary_information
    FOREIGN KEY (fk_supplementary_information)
      REFERENCES SCHEMANAME.supplementary_information(producer_specific_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT fk_numeric_range
    FOREIGN KEY (fk_numeric_range)
      REFERENCES SCHEMANAME.numeric_range(numeric_range_uuid)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE SCHEMANAME.time_instant_value (
  id SERIAL PRIMARY KEY,
  time_instant_uuid UUID DEFAULT uuid_generate_v4() UNIQUE NOT NULL,
  value TIMESTAMP WITHOUT TIME ZONE NOT NULL
);

CREATE TABLE SCHEMANAME.plan_regulation_time_instant_value(
  id SERIAL PRIMARY KEY,
  fk_plan_regulation VARCHAR NOT NULL,
  fk_time_instant_value UUID NOT NULL,
  UNIQUE (fk_plan_regulation, fk_time_instant_value),
  CONSTRAINT fk_plan_regulation
    FOREIGN KEY (fk_plan_regulation)
      REFERENCES SCHEMANAME.plan_regulation(local_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT fk_time_instant_value
    FOREIGN KEY (fk_time_instant_value)
      REFERENCES SCHEMANAME.time_instant_value(time_instant_uuid)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE SCHEMANAME.plan_guidance_time_instant_value(
  id SERIAL PRIMARY KEY,
  fk_plan_guidance VARCHAR NOT NULL,
  fk_time_instant_value UUID NOT NULL,
  UNIQUE (fk_plan_guidance, fk_time_instant_value),
  CONSTRAINT fk_plan_guidance
    FOREIGN KEY (fk_plan_guidance)
      REFERENCES SCHEMANAME.plan_guidance(local_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT fk_time_instant_value
    FOREIGN KEY (fk_time_instant_value)
      REFERENCES SCHEMANAME.time_instant_value(time_instant_uuid)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE SCHEMANAME.supplementary_information_time_instant_value(
  id SERIAL PRIMARY KEY,
  fk_supplementary_information UUID NOT NULL,
  fk_time_instant_value UUID NOT NULL,
  UNIQUE (fk_supplementary_information, fk_time_instant_value),
  CONSTRAINT fk_supplementary_information
    FOREIGN KEY (fk_supplementary_information)
      REFERENCES SCHEMANAME.supplementary_information(producer_specific_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT fk_time_instant_value
    FOREIGN KEY (fk_time_instant_value)
      REFERENCES SCHEMANAME.time_instant_value(time_instant_uuid)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE SCHEMANAME.time_period_value (
  id SERIAL PRIMARY KEY,
  time_period_uuid UUID DEFAULT uuid_generate_v4() UNIQUE NOT NULL,
  value TSRANGE NOT NULL
);

CREATE TABLE SCHEMANAME.plan_regulation_time_period_value(
  id SERIAL PRIMARY KEY,
  fk_plan_regulation VARCHAR NOT NULL,
  fk_time_period_value UUID NOT NULL,
  UNIQUE (fk_plan_regulation, fk_time_period_value),
  CONSTRAINT fk_plan_regulation
    FOREIGN KEY (fk_plan_regulation)
      REFERENCES SCHEMANAME.plan_regulation(local_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT fk_time_period_value
    FOREIGN KEY (fk_time_period_value)
      REFERENCES SCHEMANAME.time_period_value(time_period_uuid)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE SCHEMANAME.plan_guidance_time_period_value(
  id SERIAL PRIMARY KEY,
  fk_plan_guidance VARCHAR NOT NULL,
  fk_time_period_value UUID NOT NULL,
  UNIQUE (fk_plan_guidance, fk_time_period_value),
  CONSTRAINT fk_plan_guidance
    FOREIGN KEY (fk_plan_guidance)
      REFERENCES SCHEMANAME.plan_guidance(local_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT fk_time_period_value
    FOREIGN KEY (fk_time_period_value)
      REFERENCES SCHEMANAME.time_period_value(time_period_uuid)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE SCHEMANAME.supplementary_information_time_period_value(
  id SERIAL PRIMARY KEY,
  fk_supplementary_information UUID NOT NULL,
  fk_time_period_value UUID NOT NULL,
  UNIQUE (fk_supplementary_information, fk_time_period_value),
  CONSTRAINT fk_supplementary_information
    FOREIGN KEY (fk_supplementary_information)
      REFERENCES SCHEMANAME.supplementary_information(producer_specific_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT fk_time_period_value
    FOREIGN KEY (fk_time_period_value)
      REFERENCES SCHEMANAME.time_period_value(time_period_uuid)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE SCHEMANAME.text_value(
  id SERIAL PRIMARY KEY,
  text_value_uuid UUID DEFAULT uuid_generate_v4() UNIQUE NOT NULL,
  value JSONB NOT NULL CHECK(check_language_string(value)),
  syntax VARCHAR
);

CREATE TABLE SCHEMANAME.plan_regulation_text_value(
  id SERIAL PRIMARY KEY,
  fk_plan_regulation VARCHAR NOT NULL,
  fk_text_value UUID NOT NULL,
  UNIQUE (fk_plan_regulation, fk_text_value),
  CONSTRAINT fk_plan_regulation
    FOREIGN KEY (fk_plan_regulation)
      REFERENCES SCHEMANAME.plan_regulation(local_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT fk_text_value
    FOREIGN KEY (fk_text_value)
      REFERENCES SCHEMANAME.text_value(text_value_uuid)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE SCHEMANAME.plan_guidance_text_value(
  id SERIAL PRIMARY KEY,
  fk_plan_guidance VARCHAR NOT NULL,
  fk_text_value UUID NOT NULL,
  UNIQUE (fk_plan_guidance, fk_text_value),
  CONSTRAINT fk_plan_guidance
    FOREIGN KEY (fk_plan_guidance)
      REFERENCES SCHEMANAME.plan_guidance(local_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT fk_text_value
    FOREIGN KEY (fk_text_value)
      REFERENCES SCHEMANAME.text_value(text_value_uuid)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE SCHEMANAME.supplementary_information_text_value(
  id SERIAL PRIMARY KEY,
  fk_supplementary_information UUID NOT NULL,
  fk_text_value UUID NOT NULL,
  UNIQUE (fk_supplementary_information, fk_text_value),
  CONSTRAINT fk_supplementary_information
    FOREIGN KEY (fk_supplementary_information)
      REFERENCES SCHEMANAME.supplementary_information(producer_specific_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT fk_text_value
    FOREIGN KEY (fk_text_value)
      REFERENCES SCHEMANAME.text_value(text_value_uuid)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE SCHEMANAME.code_value(
  id SERIAL PRIMARY KEY,
  code_value_uuid UUID DEFAULT uuid_generate_v4() UNIQUE NOT NULL,
  value VARCHAR NOT NULL,
  code_list VARCHAR,
  title JSONB CHECK(check_language_string(title))
);

CREATE TABLE SCHEMANAME.plan_regulation_code_value(
  id SERIAL PRIMARY KEY,
  fk_plan_regulation VARCHAR NOT NULL,
  fk_code_value UUID NOT NULL,
  UNIQUE (fk_plan_regulation, fk_code_value),
  CONSTRAINT fk_plan_regulation
    FOREIGN KEY (fk_plan_regulation)
      REFERENCES SCHEMANAME.plan_regulation(local_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT fk_code_value
    FOREIGN KEY (fk_code_value)
      REFERENCES SCHEMANAME.code_value(code_value_uuid)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE SCHEMANAME.plan_guidance_code_value(
  id SERIAL PRIMARY KEY,
  fk_plan_guidance VARCHAR NOT NULL,
  fk_code_value UUID NOT NULL,
  UNIQUE (fk_plan_guidance, fk_code_value),
  CONSTRAINT fk_plan_guidance
    FOREIGN KEY (fk_plan_guidance)
      REFERENCES SCHEMANAME.plan_guidance(local_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT fk_code_value
    FOREIGN KEY (fk_code_value)
      REFERENCES SCHEMANAME.code_value(code_value_uuid)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE SCHEMANAME.supplementary_information_code_value(
  id SERIAL PRIMARY KEY,
  fk_supplementary_information UUID NOT NULL,
  fk_code_value UUID NOT NULL,
  UNIQUE (fk_supplementary_information, fk_code_value),
  CONSTRAINT fk_supplementary_information
    FOREIGN KEY (fk_supplementary_information)
      REFERENCES SCHEMANAME.supplementary_information(producer_specific_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT fk_code_value
    FOREIGN KEY (fk_code_value)
      REFERENCES SCHEMANAME.code_value(code_value_uuid)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE SCHEMANAME.identifier_value(
  id SERIAL PRIMARY KEY,
  identifier_value_uuid UUID DEFAULT uuid_generate_v4() UNIQUE NOT NULL,
  value VARCHAR NOT NULL,
  register_id VARCHAR,
  register_name JSONB CHECK(check_language_string(register_name))
);

CREATE TABLE SCHEMANAME.plan_regulation_identifier_value(
  id SERIAL PRIMARY KEY,
  fk_plan_regulation VARCHAR NOT NULL,
  fk_identifier_value UUID NOT NULL,
  UNIQUE (fk_plan_regulation, fk_identifier_value),
  CONSTRAINT fk_plan_regulation
    FOREIGN KEY (fk_plan_regulation)
      REFERENCES SCHEMANAME.plan_regulation(local_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT fk_identifier_value
    FOREIGN KEY (fk_identifier_value)
      REFERENCES SCHEMANAME.identifier_value(identifier_value_uuid)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE SCHEMANAME.plan_guidance_identifier_value(
  id SERIAL PRIMARY KEY,
  fk_plan_guidance VARCHAR NOT NULL,
  fk_identifier_value UUID NOT NULL,
  UNIQUE (fk_plan_guidance, fk_identifier_value),
  CONSTRAINT fk_plan_guidance
    FOREIGN KEY (fk_plan_guidance)
      REFERENCES SCHEMANAME.plan_guidance(local_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT fk_identifier_value
    FOREIGN KEY (fk_identifier_value)
      REFERENCES SCHEMANAME.identifier_value(identifier_value_uuid)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE SCHEMANAME.supplementary_information_identifier_value(
  id SERIAL PRIMARY KEY,
  fk_supplementary_information UUID NOT NULL,
  fk_identifier_value UUID NOT NULL,
  UNIQUE (fk_supplementary_information, fk_identifier_value),
  CONSTRAINT fk_supplementary_information
    FOREIGN KEY (fk_supplementary_information)
      REFERENCES SCHEMANAME.supplementary_information(producer_specific_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT fk_identifier_value
    FOREIGN KEY (fk_identifier_value)
      REFERENCES SCHEMANAME.identifier_value(identifier_value_uuid)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE SCHEMANAME.geometry_point_value(
  id SERIAL PRIMARY KEY,
  geometry_point_value_uuid UUID DEFAULT uuid_generate_v4() UNIQUE NOT NULL,
  value GEOMETRY(POINT, PROJECTSRID) NOT NULL,
  obligatory BOOLEAN NOT NULL,
  point_rotation FLOAT
);

CREATE INDEX sidx_geometry_point_value_geom
    ON SCHEMANAME.geometry_point_value USING gist
        (value)
    TABLESPACE pg_default;

CREATE TABLE SCHEMANAME.plan_regulation_geometry_point_value(
  id SERIAL PRIMARY KEY,
  fk_plan_regulation VARCHAR NOT NULL,
  fk_geometry_point_value UUID NOT NULL,
  UNIQUE (fk_plan_regulation, fk_geometry_point_value),
  CONSTRAINT fk_plan_regulation
    FOREIGN KEY (fk_plan_regulation)
      REFERENCES SCHEMANAME.plan_regulation(local_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT fk_geometry_point_value
    FOREIGN KEY (fk_geometry_point_value)
      REFERENCES SCHEMANAME.geometry_point_value(geometry_point_value_uuid)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE SCHEMANAME.plan_guidance_geometry_point_value(
  id SERIAL PRIMARY KEY,
  fk_plan_guidance VARCHAR NOT NULL,
  fk_geometry_point_value UUID NOT NULL,
  UNIQUE (fk_plan_guidance, fk_geometry_point_value),
  CONSTRAINT fk_plan_guidance
    FOREIGN KEY (fk_plan_guidance)
      REFERENCES SCHEMANAME.plan_guidance(local_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT fk_geometry_point_value
    FOREIGN KEY (fk_geometry_point_value)
      REFERENCES SCHEMANAME.geometry_point_value(geometry_point_value_uuid)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE SCHEMANAME.supplementary_information_geometry_point_value(
  id SERIAL PRIMARY KEY,
  fk_supplementary_information UUID NOT NULL,
  fk_geometry_point_value UUID NOT NULL,
  UNIQUE (fk_supplementary_information, fk_geometry_point_value),
  CONSTRAINT fk_supplementary_information
    FOREIGN KEY (fk_supplementary_information)
      REFERENCES SCHEMANAME.supplementary_information(producer_specific_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT fk_geometry_point_value
    FOREIGN KEY (fk_geometry_point_value)
      REFERENCES SCHEMANAME.geometry_point_value(geometry_point_value_uuid)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE SCHEMANAME.geometry_line_value(
  id SERIAL PRIMARY KEY,
  geometry_line_value_uuid UUID DEFAULT uuid_generate_v4() UNIQUE NOT NULL,
  value GEOMETRY(MultiLineString, PROJECTSRID) NOT NULL,
  obligatory BOOLEAN NOT NULL
);

CREATE INDEX sidx_geometry_line_value_geom
    ON SCHEMANAME.geometry_line_value USING gist
        (value)
    TABLESPACE pg_default;

CREATE TABLE SCHEMANAME.plan_regulation_geometry_line_value(
  id SERIAL PRIMARY KEY,
  fk_plan_regulation VARCHAR NOT NULL,
  fk_geometry_line_value UUID NOT NULL,
  UNIQUE (fk_plan_regulation, fk_geometry_line_value),
  CONSTRAINT fk_plan_regulation
    FOREIGN KEY (fk_plan_regulation)
      REFERENCES SCHEMANAME.plan_regulation(local_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT fk_geometry_line_value
    FOREIGN KEY (fk_geometry_line_value)
      REFERENCES SCHEMANAME.geometry_line_value(geometry_line_value_uuid)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE SCHEMANAME.plan_guidance_geometry_line_value(
  id SERIAL PRIMARY KEY,
  fk_plan_guidance VARCHAR NOT NULL,
  fk_geometry_line_value UUID NOT NULL,
  UNIQUE (fk_plan_guidance, fk_geometry_line_value),
  CONSTRAINT fk_plan_guidance
    FOREIGN KEY (fk_plan_guidance)
      REFERENCES SCHEMANAME.plan_guidance(local_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT fk_geometry_line_value
    FOREIGN KEY (fk_geometry_line_value)
      REFERENCES SCHEMANAME.geometry_line_value(geometry_line_value_uuid)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE SCHEMANAME.supplementary_information_geometry_line_value(
  id SERIAL PRIMARY KEY,
  fk_supplementary_information UUID NOT NULL,
  fk_geometry_line_value UUID NOT NULL,
  UNIQUE (fk_supplementary_information, fk_geometry_line_value),
  CONSTRAINT fk_supplementary_information
    FOREIGN KEY (fk_supplementary_information)
      REFERENCES SCHEMANAME.supplementary_information(producer_specific_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT fk_geometry_line_value
    FOREIGN KEY (fk_geometry_line_value)
      REFERENCES SCHEMANAME.geometry_line_value(geometry_line_value_uuid)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE SCHEMANAME.geometry_area_value(
  id SERIAL PRIMARY KEY,
  geometry_area_value_uuid UUID DEFAULT uuid_generate_v4() UNIQUE NOT NULL,
  value GEOMETRY(MultiPolygon, PROJECTSRID) NOT NULL,
  obligatory BOOLEAN NOT NULL
);

CREATE INDEX sidx_geometry_area_value_geom
    ON SCHEMANAME.geometry_area_value USING gist
        (value)
    TABLESPACE pg_default;

CREATE TABLE SCHEMANAME.plan_regulation_geometry_area_value(
  id SERIAL PRIMARY KEY,
  fk_plan_regulation VARCHAR NOT NULL,
  fk_geometry_area_value UUID NOT NULL,
  UNIQUE (fk_plan_regulation, fk_geometry_area_value),
  CONSTRAINT fk_plan_regulation
    FOREIGN KEY (fk_plan_regulation)
      REFERENCES SCHEMANAME.plan_regulation(local_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT fk_geometry_area_value
    FOREIGN KEY (fk_geometry_area_value)
      REFERENCES SCHEMANAME.geometry_area_value(geometry_area_value_uuid)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE SCHEMANAME.plan_guidance_geometry_area_value(
  id SERIAL PRIMARY KEY,
  fk_plan_guidance VARCHAR NOT NULL,
  fk_geometry_area_value UUID NOT NULL,
  UNIQUE (fk_plan_guidance, fk_geometry_area_value),
  CONSTRAINT fk_plan_guidance
    FOREIGN KEY (fk_plan_guidance)
      REFERENCES SCHEMANAME.plan_guidance(local_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT fk_geometry_area_value
    FOREIGN KEY (fk_geometry_area_value)
      REFERENCES SCHEMANAME.geometry_area_value(geometry_area_value_uuid)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE SCHEMANAME.supplementary_information_geometry_area_value(
  id SERIAL PRIMARY KEY,
  fk_supplementary_information UUID NOT NULL,
  fk_geometry_area_value UUID NOT NULL,
  UNIQUE (fk_supplementary_information, fk_geometry_area_value),
  CONSTRAINT fk_supplementary_information
    FOREIGN KEY (fk_supplementary_information)
      REFERENCES SCHEMANAME.supplementary_information(producer_specific_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT fk_geometry_area_value
    FOREIGN KEY (fk_geometry_area_value)
      REFERENCES SCHEMANAME.geometry_area_value(geometry_area_value_uuid)
      ON UPDATE CASCADE
      ON DELETE CASCADE
      DEFERRABLE INITIALLY DEFERRED
);
