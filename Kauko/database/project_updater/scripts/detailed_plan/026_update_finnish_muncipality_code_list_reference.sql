ALTER TABLE SCHEMANAME.spatial_plan
    ADD CONSTRAINT fk_finnish_muncipality FOREIGN KEY (land_administration_authority)
    REFERENCES code_lists.finnish_municipality (codevalue)
    ON UPDATE CASCADE
    ON DELETE RESTRICT;
