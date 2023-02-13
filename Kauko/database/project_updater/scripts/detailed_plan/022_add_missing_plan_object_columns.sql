ALTER TABLE SCHEMANAME.planning_detail_line
  ADD COLUMN bindingness_of_location VARCHAR(2),
  ADD COLUMN ground_relative_position VARCHAR(2);

ALTER TABLE SCHEMANAME.planning_detail_line
  ADD CONSTRAINT planning_detail_line_bindingness_of_location_fk FOREIGN KEY (bindingness_of_location)
  REFERENCES code_lists.bindingness_kind (codevalue)
  ON UPDATE CASCADE
  ON DELETE RESTRICT,
  ADD CONSTRAINT planning_detail_line_ground_relative_position_fk FOREIGN KEY (ground_relative_position)
  REFERENCES code_lists.ground_relativeness_kind (codevalue)
  ON UPDATE CASCADE
  ON DELETE RESTRICT;

UPDATE SCHEMANAME.planning_detail_line
SET bindingness_of_location =
  CASE
    WHEN obligatory IS TRUE THEN '01'
    WHEN obligatory IS FALSE THEN '02'
    ELSE RAISE EXCEPTION 'Invalid value for obligatory'
  END;

ALTER TABLE SCHEMANAME.planning_detail_line
  DROP COLUMN obligatory;

UPDATE SCHEMANAME.planning_detail_line
  SET ground_relative_position = '02'
  WHERE ground_relative_position IS NULL;

ALTER TABLE SCHEMANAME.planning_detail_line
  ALTER COLUMN bindingness_of_location SET NOT NULL,
  ALTER COLUMN ground_relative_position SET NOT NULL;
