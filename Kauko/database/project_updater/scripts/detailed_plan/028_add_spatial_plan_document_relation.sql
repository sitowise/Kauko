CREATE TABLE SCHEMANAME.spatial_plan_document(
  id SERIAL PRIMARY KEY,
  spatial_plan_local_id VARCHAR NOT NULL,
  document_local_id VARCHAR NOT NULL,
  "role" JSONB CHECK(check_language_string(role)),
  CONSTRAINT fk_spatial_plan
    FOREIGN KEY (spatial_plan_local_id)
    REFERENCES SCHEMANAME.spatial_plan (local_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
    DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT fk_document
    FOREIGN KEY (document_local_id)
    REFERENCES SCHEMANAME."document" (local_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
    DEFERRABLE INITIALLY DEFERRED
);
