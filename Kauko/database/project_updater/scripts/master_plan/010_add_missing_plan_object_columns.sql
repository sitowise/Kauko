ALTER TABLE SCHEMANAME.zoning_element
  ADD COLUMN environmental_change_nature VARCHAR(2);

ALTER TABLE SCHEMANAME.zoning_element
  ADD CONSTRAINT zoning_element_environmental_change_nature_fk FOREIGN KEY (environmental_change_nature)
  REFERENCES code_lists.master_plan_envrionmental_change_kind (codevalue)
  ON UPDATE CASCADE
  ON DELETE RESTRICT;

UPDATE SCHEMANAME.zoning_element
  SET environmental_change_nature = '02';

ALTER TABLE SCHEMANAME.zoning_element
  ALTER COLUMN environmental_change_nature SET NOT NULL;

ALTER TABLE SCHEMANAME.planned_space
  ADD COLUMN environmental_change_nature VARCHAR(2);

ALTER TABLE SCHEMANAME.planned_space
  ADD CONSTRAINT planned_space_environmental_change_nature_fk FOREIGN KEY (environmental_change_nature)
  REFERENCES code_lists.master_plan_envrionmental_change_kind (codevalue)
  ON UPDATE CASCADE
  ON DELETE RESTRICT;

UPDATE SCHEMANAME.planned_space
  SET environmental_change_nature = '02';

ALTER TABLE SCHEMANAME.planned_space
  ALTER COLUMN environmental_change_nature SET NOT NULL;

ALTER TABLE SCHEMANAME.planning_detail_line
  ADD COLUMN bindingness_of_location VARCHAR(2),
  ADD COLUMN ground_relative_position VARCHAR(2),
  ADD COLUMN environmental_change_nature VARCHAR(2);

ALTER TABLE SCHEMANAME.planning_detail_line
  ADD CONSTRAINT planning_detail_line_bindingness_of_location_fk FOREIGN KEY (bindingness_of_location)
  REFERENCES code_lists.bindingness_kind (codevalue)
  ON UPDATE CASCADE
  ON DELETE RESTRICT,
  ADD CONSTRAINT planning_detail_line_ground_relative_position_fk FOREIGN KEY (ground_relative_position)
  REFERENCES code_lists.ground_relativeness_kind (codevalue)
  ON UPDATE CASCADE
  ON DELETE RESTRICT,
  ADD CONSTRAINT planning_detail_line_environmental_change_nature_fk FOREIGN KEY (environmental_change_nature)
  REFERENCES code_lists.master_plan_envrionmental_change_kind (codevalue)
  ON UPDATE CASCADE
  ON DELETE RESTRICT;

UPDATE SCHEMANAME.planning_detail_line
SET bindingness_of_location =
  CASE
    WHEN obligatory IS TRUE THEN '01'
    WHEN obligatory IS FALSE THEN '02'
  END
WHERE obligatory IS NOT NULL;

ALTER TABLE SCHEMANAME.planning_detail_line
  DROP COLUMN obligatory;

UPDATE SCHEMANAME.planning_detail_line
  SET
    ground_relative_position = '02',
    environmental_change_nature = '02';

ALTER TABLE SCHEMANAME.planning_detail_line
  ALTER COLUMN bindingness_of_location SET NOT NULL,
  ALTER COLUMN ground_relative_position SET NOT NULL,
  ALTER COLUMN environmental_change_nature SET NOT NULL;
