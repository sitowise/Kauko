-- RYHTIEXPORT-310: Lisää FK-rajoitteet spatial_plan_main-taulun uusille sarakkeille
--
-- Tarkoitus:
--   Skripti 052 lisäsi spatial_plan_main-tauluun sarakkeet type, digital_origin ja
--   land_administration_authority ilman FK-rajoitteita. Tämä skripti lisää puuttuvat
--   viittaukset koodistotauluihin.
--
-- Esiehdot:
--   - Skripti 052: spatial_plan_main-tauluun lisätty type, digital_origin,
--     land_administration_authority -sarakkeet

ALTER TABLE $SCHEMANAME$.spatial_plan_main
    ADD CONSTRAINT spatial_plan_main_type_fkey FOREIGN KEY (type)
        REFERENCES code_lists.spatial_plan_kind (codevalue) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE RESTRICT
        DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE $SCHEMANAME$.spatial_plan_main
    ADD CONSTRAINT spatial_plan_main_digital_origin_fkey FOREIGN KEY (digital_origin)
        REFERENCES code_lists.digital_origin_kind (codevalue) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE RESTRICT
        DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE $SCHEMANAME$.spatial_plan_main
    ADD CONSTRAINT spatial_plan_main_land_administration_authority_fkey FOREIGN KEY (land_administration_authority)
        REFERENCES code_lists.finnish_municipalities (codevalue) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE RESTRICT;
