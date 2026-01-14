DROP TABLE code_lists.data_type;
DROP TABLE code_lists.finnish_area_type;
DROP TABLE code_lists.finnish_document_role;
DROP TABLE code_lists.finnish_document_type;
DROP TABLE code_lists.finnish_informative_feature_type;
DROP TABLE code_lists.finnish_land_use_kind;
DROP TABLE code_lists.finnish_language;
DROP TABLE code_lists.finnish_municipality_codes;
DROP TABLE code_lists.finnish_numeric_value;
DROP TABLE code_lists.finnish_ordinance_process;
DROP TABLE code_lists.finnish_ordinance_process_step;
DROP TABLE code_lists.finnish_plan_description;
DROP TABLE code_lists.finnish_planned_space_type;
DROP TABLE code_lists.finnish_planning_detail_line_type;
DROP TABLE code_lists.finnish_planning_detail_point_type;
DROP TABLE code_lists.finnish_regulative_text_type;
DROP TABLE code_lists.finnish_spatial_plan_level;
DROP TABLE code_lists.finnish_spatial_plan_origin;
DROP TABLE code_lists.finnish_spatial_plan_status;
DROP TABLE code_lists.finnish_spatial_plan_type;
DROP TABLE code_lists.finnish_up_to_dateness;
DROP TABLE code_lists.finnish_zoning_element_type;
DROP TABLE code_lists.master_plan_additional_information_kind;
DROP TABLE code_lists.master_plan_envrionmental_change_kind;
DROP TABLE code_lists.master_plan_regulation_kind;
DROP TABLE code_lists.master_plan_theme;
DROP TABLE code_lists.validity_type;

-- Fix missing foreign keys and remove unused language column
ALTER TABLE $SCHEMANAME$.spatial_plan ADD CONSTRAINT spatial_plan_approved_by_fkey FOREIGN KEY (approved_by) REFERENCES code_lists.finnish_spatial_plan_approved_by(value) ON DELETE RESTRICT ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE $SCHEMANAME$.spatial_plan ADD CONSTRAINT spatial_vertical_coordinate_reference_system_fkey FOREIGN KEY (vertical_coordinate_system) REFERENCES code_lists.finnish_vertical_coordinate_reference_system(value) ON DELETE RESTRICT ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE $SCHEMANAME$.describing_line ADD CONSTRAINT describing_line_type_fkey FOREIGN KEY (type) REFERENCES code_lists.describing_line_type(value) ON DELETE RESTRICT ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE $SCHEMANAME$.spatial_plan
DROP COLUMN IF EXISTS "language";

