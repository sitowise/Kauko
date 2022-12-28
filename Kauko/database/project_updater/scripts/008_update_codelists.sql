ALTER TABLE SCHEMANAME.spatial_plan
      ADD COLUMN "type" VARCHAR(3),
      ADD COLUMN digital_origin VARCHAR(3),
      ADD COLUMN ground_relative_position VARCHAR(3),
      ADD COLUMN legal_effectiveness VARCHAR(2) DEFAULT ('01'),
      ADD COLUMN validity_time DATERANGE,
      ADD COLUMN lifecycle_status VARCHAR(3);

UPDATE SCHEMANAME.spatial_plan as s SET
  "type" = s2."type"
FROM(
  VALUES
    (1, '31'),
    (3, '32'),
    (2, '33'),
    (4, '34'),
    (5, '35')
) as s2(plan_type, "type")
WHERE s2.plan_type = s.plan_type;

UPDATE SCHEMANAME.spatial_plan as s SET
  digital_origin = s2.digital_origin
FROM(
  VALUES
    (1, '01'),
    (2, '02'),
    (3, '03'),
    (4, '04')
) as s2(origin, digital_origin)
WHERE s2.origin = s.origin;

UPDATE SCHEMANAME.spatial_plan
SET ground_relative_position = '01'
  WHERE "type" IN ('26', '35');

UPDATE SCHEMANAME.spatial_plan
SET ground_relative_position = '02'
  WHERE "type" NOT IN ('26', '35');

UPDATE SCHEMANAME.spatial_plan as s SET
  lifecycle_status = s2.lifecycle_status
FROM(
  VALUES
    (1, '01'),
    (2, '02'),
    (3, '03'),
    (4, '04'),
    (5, '06'),
    (6, '11'),
    (7, '13'),
    (8, '14'),
    (9, '05'),
    (10, '09'),
    (11, '08'),
    (12, '10'),
    (13, '12'),
    (14, '15')
) as s2(status, lifecycle_status)
WHERE s2.status = s.status;

UPDATE SCHEMANAME.spatial_plan
  SET legal_effectiveness = '01';

UPDATE SCHEMANAME.spatial_plan
  SET validity_time = DATERANGE(valid_from, valid_to, '[)')
  WHERE valid_from IS NOT NULL;

ALTER TABLE SCHEMANAME.spatial_plan
  DROP COLUMN plan_type,
  DROP COLUMN planning_level,
  DROP COLUMN origin,
  DROP COLUMN status,
  ALTER COLUMN type SET NOT NULL,
  ADD CONSTRAINT spatial_plan_type_fkey FOREIGN KEY (type)
    REFERENCES code_lists.spatial_plan_kind (codevalue)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
    DEFERRABLE INITIALLY DEFERRED,
  ALTER COLUMN digital_origin SET NOT NULL,
  ADD CONSTRAINT spatial_plan_digital_origin_fkey FOREIGN KEY (digital_origin)
    REFERENCES code_lists.digital_origin_kind (codevalue)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
    DEFERRABLE INITIALLY DEFERRED,
  ALTER COLUMN ground_relative_position SET NOT NULL,
  ADD CONSTRAINT spatial_plan_ground_relative_position_fkey FOREIGN KEY (ground_relative_position)
    REFERENCES code_lists.ground_relativeness_kind (codevalue)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
    DEFERRABLE INITIALLY DEFERRED,
  ALTER COLUMN lifecycle_status SET NOT NULL,
  ADD CONSTRAINT spatial_plan_lifecycle_status_fkey FOREIGN KEY (lifecycle_status)
    REFERENCES code_lists.spatial_plan_lifecycle_status (codevalue)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
    DEFERRABLE INITIALLY DEFERRED,
  ALTER COLUMN legal_effectiveness SET NOT NULL,
  ADD CONSTRAINT spatial_plan_legal_effectiveness_fkey FOREIGN KEY (legal_effectiveness)
    REFERENCES code_lists.legal_effectiveness_kind(codevalue)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
    DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE SCHEMANAME.zoning_element
  ADD COLUMN bindingness_of_location VARCHAR(3) default ('01'),
  ADD COLUMN ground_relative_position VARCHAR(3),
  ADD COLUMN land_use_kind VARCHAR(6) CHECK (land_use_kind LIKE '01%');

UPDATE SCHEMANAME.zoning_element SET
  ground_relative_position = '02';

UPDATE SCHEMANAME.zoning_element SET
  land_use_kind = land_use_kind_codes.codevalue
  FROM (SELECT codevalue, code FROM code_lists.finnish_land_use_kind) AS land_use_kind_codes
  WHERE land_use_kind_codes.code = zoning_element.finnish_land_use_kind;

ALTER TABLE SCHEMANAME.zoning_element
  ALTER COLUMN bindingness_of_location SET NOT NULL,
  ADD CONSTRAINT zoning_element_bindingness_of_location_fkey FOREIGN KEY (bindingness_of_location)
    REFERENCES code_lists.bindingness_kind(codevalue)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
    DEFERRABLE INITIALLY DEFERRED,
  ALTER COLUMN ground_relative_position SET NOT NULL,
  ADD CONSTRAINT zoning_element_ground_relative_position_fkey FOREIGN KEY (ground_relative_position)
    REFERENCES code_lists.ground_relativeness_kind (codevalue)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
    DEFERRABLE INITIALLY DEFERRED,
  DROP COLUMN finnish_land_use_kind,
  ALTER COLUMN land_use_kind SET NOT NULL,
  ADD CONSTRAINT zoning_element_land_use_kind_fkey FOREIGN KEY (land_use_kind)
    REFERENCES code_lists.detail_plan_regulation_kind (codevalue)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
    DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE SCHEMANAME.planned_space
  ADD COLUMN bindingness_of_location VARCHAR(3),
  ADD COLUMN ground_relative_position VARCHAR(3);


UPDATE SCHEMANAME.planned_space as s SET
  bindingness_of_location = s2.code
FROM(
  VALUES
    (true, '01'),
    (false, '02')
) as s2(bindingness, code)
WHERE s2.bindingness = s.obligatory;

UPDATE SCHEMANAME.planned_space SET
  ground_relative_position = '02';


ALTER TABLE SCHEMANAME.planned_space
  DROP COLUMN obligatory,
  ALTER COLUMN bindingness_of_location SET NOT NULL,
  ADD CONSTRAINT planned_space_bindingness_of_location_fkey FOREIGN KEY (bindingness_of_location)
    REFERENCES code_lists.bindingness_kind (codevalue)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
    DEFERRABLE INITIALLY DEFERRED,
  ALTER COLUMN ground_relative_position SET NOT NULL,
  ADD CONSTRAINT planned_space_ground_relative_position_fkey FOREIGN KEY (ground_relative_position)
    REFERENCES code_lists.ground_relativeness_kind (codevalue)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
    DEFERRABLE INITIALLY DEFERRED;