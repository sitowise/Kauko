-- Disable triggers before they are fixed to new keys.
ALTER TABLE SCHEMANAME.spatial_plan DISABLE TRIGGER USER;
ALTER TABLE SCHEMANAME.zoning_element DISABLE TRIGGER USER;
ALTER TABLE SCHEMANAME.planned_space DISABLE TRIGGER USER;
ALTER TABLE SCHEMANAME.planning_detail_point DISABLE TRIGGER USER;
ALTER TABLE SCHEMANAME.planning_detail_line DISABLE TRIGGER USER;

ALTER TABLE SCHEMANAME.spatial_plan
  ADD COLUMN identity_id UUID DEFAULT uuid_generate_v4() NOT NULL UNIQUE,
  ADD COLUMN local_id VARCHAR UNIQUE,
  ADD COLUMN namespace VARCHAR,
  ADD COLUMN reference_id VARCHAR,
  ADD COLUMN latest_change TIMESTAMP DEFAULT now() NOT NULL;

ALTER TABLE SCHEMANAME.spatial_plan
  RENAME COLUMN planning_object_identifier TO producer_specific_id;

ALTER TABLE SCHEMANAME.spatial_plan
  RENAME COLUMN created to storage_time;


CREATE TRIGGER spatial_plan_modified_trigger
  BEFORE INSERT OR UPDATE ON SCHEMANAME.spatial_plan
  FOR EACH ROW EXECUTE PROCEDURE versioned_object_modified_trigger();

UPDATE SCHEMANAME.spatial_plan
  SET local_id = identity_id || '.' || uuid_generate_v4();

CREATE TRIGGER create_spatial_plan_local_id_trigger
  BEFORE INSERT ON SCHEMANAME.spatial_plan
  FOR EACH ROW EXECUTE PROCEDURE create_local_id_trigger();


ALTER TABLE SCHEMANAME.spatial_plan
  ALTER COLUMN local_id SET NOT NULL;

ALTER TABLE SCHEMANAME.zoning_element
  ADD COLUMN identity_id UUID DEFAULT uuid_generate_v4() NOT NULL UNIQUE,
  ADD COLUMN local_id VARCHAR UNIQUE,
  ADD COLUMN namespace VARCHAR,
  ADD COLUMN reference_id VARCHAR,
  ADD COLUMN latest_change TIMESTAMP DEFAULT now() NOT NULL,
  ADD COLUMN spatial_plan VARCHAR,
  ADD CONSTRAINT fk_spatial_plan
    FOREIGN KEY (spatial_plan)
    REFERENCES SCHEMANAME.spatial_plan (local_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
    DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE SCHEMANAME.zoning_element
  RENAME COLUMN planning_object_identifier TO producer_specific_id;
ALTER TABLE SCHEMANAME.zoning_element
  RENAME COLUMN created to storage_time;

CREATE TRIGGER zoning_element_modified_trigger
  BEFORE INSERT OR UPDATE ON SCHEMANAME.zoning_element
  FOR EACH ROW EXECUTE PROCEDURE versioned_object_modified_trigger();

UPDATE SCHEMANAME.spatial_plan
  SET local_id = identity_id || '.' || uuid_generate_v4();

CREATE TRIGGER create_zoning_element_local_id_trigger
  BEFORE INSERT ON SCHEMANAME.zoning_element
  FOR EACH ROW EXECUTE PROCEDURE create_local_id_trigger();

UPDATE SCHEMANAME.zoning_element
  SET spatial_plan = subquery.local_id
  FROM (SELECT local_id, producer_specific_id FROM SCHEMANAME.spatial_plan) AS subquery
  WHERE zoning_element.fk_spatial_plan = subquery.producer_specific_id;

ALTER TABLE SCHEMANAME.zoning_element
  DROP COLUMN fk_spatial_plan,
  ALTER COLUMN spatial_plan SET NOT NULL,
  ALTER COLUMN local_id SET NOT NULL;

ALTER TABLE SCHEMANAME.planned_space
  ADD COLUMN identity_id UUID DEFAULT uuid_generate_v4() NOT NULL UNIQUE,
  ADD COLUMN local_id VARCHAR UNIQUE,
  ADD COLUMN namespace VARCHAR,
  ADD COLUMN reference_id VARCHAR,
  ADD COLUMN latest_change TIMESTAMP DEFAULT now() NOT NULL;

ALTER TABLE SCHEMANAME.planned_space
  RENAME COLUMN planning_object_identifier TO producer_specific_id;
ALTER TABLE SCHEMANAME.planned_space
  RENAME COLUMN created to storage_time;

CREATE TRIGGER planned_space_modified_trigger
  BEFORE INSERT OR UPDATE ON SCHEMANAME.planned_space
  FOR EACH ROW EXECUTE PROCEDURE versioned_object_modified_trigger();

UPDATE SCHEMANAME.planned_space
  SET local_id = identity_id || '.' || uuid_generate_v4();

CREATE TRIGGER create_planend_space_local_id_trigger
  BEFORE INSERT ON SCHEMANAME.planned_space
  FOR EACH ROW EXECUTE PROCEDURE create_local_id_trigger();

ALTER TABLE SCHEMANAME.planned_space
  ALTER COLUMN local_id SET NOT NULL;

ALTER TABLE SCHEMANAME.zoning_element_planned_space
  ADD COLUMN zoning_element_local_id VARCHAR,
  ADD COLUMN planned_space_local_id VARCHAR;

UPDATE SCHEMANAME.zoning_element_planned_space
  SET zoning_element_local_id = subquery.local_id
  FROM (
    SELECT local_id, producer_specific_id
    FROM SCHEMANAME.zoning_element
  ) AS subquery
  WHERE subquery.producer_specific_id = zoning_element_planned_space.zoning_element_id;

UPDATE SCHEMANAME.zoning_element_planned_space
  SET planned_space_local_id = subquery.local_id
  FROM (
    SELECT local_id, producer_specific_id
    FROM SCHEMANAME.planned_space
  ) AS subquery
  WHERE subquery.producer_specific_id = zoning_element_planned_space.planned_space_id;

ALTER TABLE SCHEMANAME.zoning_element_planned_space
  ALTER COLUMN zoning_element_local_id SET NOT NULL,
  ALTER COLUMN planned_space_local_id SET NOT NULL,
  DROP COLUMN zoning_element_id,
  DROP COLUMN planned_space_id,
  ADD CONSTRAINT fk_zoning_element
    FOREIGN KEY (zoning_element_local_id)
    REFERENCES SCHEMANAME.zoning_element (local_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
    DEFERRABLE INITIALLY DEFERRED,
  ADD CONSTRAINT fk_planned_space
    FOREIGN KEY (planned_space_local_id)
    REFERENCES SCHEMANAME.planned_space (local_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
    DEFERRABLE INITIALLY DEFERRED;

CREATE TABLE SCHEMANAME.spatial_plan_commentary (
  id SERIAL PRIMARY KEY,
  producer_specific_id UUID DEFAULT uuid_generate_v4() NOT NULL UNIQUE,
  identity_id UUID DEFAULT uuid_generate_v4() NOT NULL UNIQUE,
  local_id VARCHAR NOT NULL UNIQUE,
  namespace VARCHAR,
  reference_id VARCHAR,
  latest_change TIMESTAMP DEFAULT now() NOT NULL,
  spatial_plan VARCHAR NOT NULL UNIQUE,
  CONSTRAINT fk_spatial_plan
    FOREIGN KEY (spatial_plan)
    REFERENCES SCHEMANAME.spatial_plan (local_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
    DEFERRABLE INITIALLY DEFERRED
);

CREATE TRIGGER spatial_plan_commentary_modified_trigger
  BEFORE INSERT OR UPDATE ON SCHEMANAME.spatial_plan_commentary
  FOR EACH ROW EXECUTE PROCEDURE versioned_object_modified_trigger();

CREATE TRIGGER create_spatial_plan_commentary_local_id_trigger
  BEFORE INSERT ON SCHEMANAME.spatial_plan_commentary
  FOR EACH ROW EXECUTE PROCEDURE create_local_id_trigger();

COMMENT ON TABLE SCHEMANAME.spatial_plan_commentary IS 'The spatial plan commentary is described in this version of the spatial plan model only as a reference to the documents that make up the spatial plan commentary. In future development versions of the data model, the spatial plan commentary can be further structured using this.';

CREATE TABLE SCHEMANAME.participation_and_evalution_plan (
  id SERIAL PRIMARY KEY,
  producer_specific_id UUID DEFAULT uuid_generate_v4() NOT NULL UNIQUE,
  identity_id UUID DEFAULT uuid_generate_v4() NOT NULL UNIQUE,
  local_id VARCHAR NOT NULL UNIQUE,
  namespace VARCHAR,
  reference_id VARCHAR,
  latest_change TIMESTAMP DEFAULT now() NOT NULL,
  spatial_plan VARCHAR NOT NULL UNIQUE,
  CONSTRAINT fk_spatial_plan
    FOREIGN KEY (spatial_plan)
    REFERENCES SCHEMANAME.spatial_plan (local_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
    DEFERRABLE INITIALLY DEFERRED
);

CREATE TRIGGER participation_and_evalution_plan_modified_trigger
  BEFORE INSERT OR UPDATE ON SCHEMANAME.participation_and_evalution_plan
  FOR EACH ROW EXECUTE PROCEDURE versioned_object_modified_trigger();

CREATE TRIGGER create_participation_and_evalution_plan_local_id_trigger
  BEFORE INSERT ON SCHEMANAME.participation_and_evalution_plan
  FOR EACH ROW EXECUTE PROCEDURE create_local_id_trigger();

COMMENT ON TABLE SCHEMANAME.participation_and_evalution_plan IS 'The participation and evaluation plan is described in this version of the spatial plan model only as a reference to the documents that make up the participation and evaluation plan. In future development versions of the data model, the participation and evaluation plan can be further structured using this.';

CREATE TABLE SCHEMANAME.document(
  id SERIAL PRIMARY KEY,
  producer_specific_id UUID DEFAULT uuid_generate_v4() NOT NULL UNIQUE,
  identity_id UUID DEFAULT uuid_generate_v4() NOT NULL UNIQUE,
  local_id VARCHAR NOT NULL UNIQUE,
  namespace VARCHAR,
  reference_id VARCHAR,
  latest_change TIMESTAMP DEFAULT now() NOT NULL,
  document_identifier VARCHAR[],
  name VARCHAR -- TO BE CHANGED TO LANGUAGE STRING, IN NEXT SCRIPTS
);


CREATE TRIGGER document_modified_trigger
  BEFORE INSERT OR UPDATE ON SCHEMANAME.document
  FOR EACH ROW EXECUTE PROCEDURE versioned_object_modified_trigger();

CREATE TRIGGER create_document_local_id_trigger
  BEFORE INSERT ON SCHEMANAME.document
  FOR EACH ROW EXECUTE PROCEDURE create_local_id_trigger();

CREATE TABLE SCHEMANAME.document_document (
  id SERIAL PRIMARY KEY,
  referencing_document_local_id VARCHAR NOT NULL,
  referenced_document_local_id VARCHAR NOT NULL,
  role VARCHAR, -- TO BE CHANGED TO LANGUAGE STRING, IN NEXT SCRIPTS
  CONSTRAINT fk_referencing_document
    FOREIGN KEY (referencing_document_local_id)
    REFERENCES SCHEMANAME.document (local_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
    DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT fk_referenced_document
    FOREIGN KEY (referenced_document_local_id)
    REFERENCES SCHEMANAME.document (local_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
    DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT local_id_check CHECK (referencing_document_local_id <> referenced_document_local_id)
);

CREATE TABLE SCHEMANAME.spatial_plan_commentary_document(
  id SERIAL PRIMARY KEY,
  spatial_plan_commentary_local_id VARCHAR NOT NULL,
  document_local_id VARCHAR NOT NULL,
  CONSTRAINT fk_spatial_plan_commentary
    FOREIGN KEY (spatial_plan_commentary_local_id)
    REFERENCES SCHEMANAME.spatial_plan_commentary (local_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
    DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT fk_document
    FOREIGN KEY (document_local_id)
    REFERENCES SCHEMANAME.document (local_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
    DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE SCHEMANAME.patricipation_evalution_plan_document(
  id SERIAL PRIMARY KEY,
  participation_and_evalution_plan_local_id VARCHAR NOT NULL,
  document_local_id VARCHAR NOT NULL,
  CONSTRAINT fk_participation_and_evalution_plan
    FOREIGN KEY (participation_and_evalution_plan_local_id)
    REFERENCES SCHEMANAME.participation_and_evalution_plan (local_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
    DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT fk_document
    FOREIGN KEY (document_local_id)
    REFERENCES SCHEMANAME.document (local_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
    DEFERRABLE INITIALLY DEFERRED
);