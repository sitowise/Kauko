ALTER TABLE SCHEMANAME."document"
  ADD COLUMN additional_information_link VARCHAR,
  ADD COLUMN metadata VARCHAR,
  ADD COLUMN "type" VARCHAR;

UPDATE SCHEMANAME."document" SET "type" = '99';

ALTER TABLE SCHEMANAME."document"
  ALTER COLUMN "type" SET NOT NULL;

ALTER TABLE SCHEMANAME."document"
  ADD CONSTRAINT fk_document_type
  FOREIGN KEY ("type")
  REFERENCES code_lists.document_kind ("type")
  ON DELETE RESTRICT
  ON UPDATE CASCADE;