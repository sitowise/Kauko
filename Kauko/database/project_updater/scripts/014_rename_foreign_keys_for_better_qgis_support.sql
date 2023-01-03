ALTER TABLE SCHEMANAME.participation_and_evalution_plan
  RENAME CONSTRAINT "fk_spatial_plan" TO "participation_and_evalution_plan_fk_spatial_plan";

ALTER TABLE SCHEMANAME.patricipation_evalution_plan_document
  RENAME CONSTRAINT "fk_document" TO "patricipation_evalution_plan_document_fk_document";
ALTER TABLE SCHEMANAME.patricipation_evalution_plan_document
  RENAME CONSTRAINT "fk_participation_and_evalution_plan" TO "patricipation_evalution_plan_document_fk_participation_and_evalution_plan";

ALTER TABLE SCHEMANAME.plan_guidance
  RENAME CONSTRAINT "fk_life_cycle_status" TO "plan_guidance_fk_life_cycle_status";

ALTER TABLE SCHEMANAME.plan_guidance_code_value
  RENAME CONSTRAINT "fk_code_value" TO "plan_guidance_code_value_fk_code_value";
ALTER TABLE SCHEMANAME.plan_guidance_code_value
  RENAME CONSTRAINT "fk_plan_guidance" TO "plan_guidance_code_value_fk_plan_guidance";

ALTER TABLE SCHEMANAME.plan_guidance_document
  RENAME CONSTRAINT "fk_document" TO "plan_guidance_document_fk_document";
ALTER TABLE SCHEMANAME.plan_guidance_document
  RENAME CONSTRAINT "fk_plan_guidance" TO "plan_guidance_document_fk_plan_guidance";

ALTER TABLE SCHEMANAME.plan_guidance_geometry_area_value
  RENAME CONSTRAINT "fk_geometry_area_value" TO "plan_guidance_geometry_area_value_fk_geometry_area_value";
ALTER TABLE SCHEMANAME.plan_guidance_geometry_area_value
  RENAME CONSTRAINT "fk_plan_guidance" TO "plan_guidance_geometry_area_value_fk_plan_guidance";

ALTER TABLE SCHEMANAME.plan_guidance_geometry_point_value
  RENAME CONSTRAINT "fk_geometry_point_value" TO "plan_guidance_geometry_point_value_fk_geometry_point_value";
ALTER TABLE SCHEMANAME.plan_guidance_geometry_point_value
  RENAME CONSTRAINT "fk_plan_guidance" TO "plan_guidance_geometry_point_value_fk_plan_guidance";

ALTER TABLE SCHEMANAME.plan_guidance_geometry_line_value
  RENAME CONSTRAINT "fk_geometry_line_value" TO "plan_guidance_geometry_line_value_fk_geometry_line_value";
ALTER TABLE SCHEMANAME.plan_guidance_geometry_line_value
  RENAME CONSTRAINT "fk_plan_guidance" TO "plan_guidance_geometry_line_value_fk_plan_guidance";

ALTER TABLE SCHEMANAME.plan_guidance_identifier_value
  RENAME CONSTRAINT "fk_identifier_value" TO "plan_guidance_identifier_value_fk_identifier_value";
ALTER TABLE SCHEMANAME.plan_guidance_identifier_value
  RENAME CONSTRAINT "fk_plan_guidance" TO "plan_guidance_identifier_value_fk_plan_guidance";

ALTER TABLE SCHEMANAME.plan_guidance_numeric_double_value
  RENAME CONSTRAINT "fk_numeric_double_value" TO "plan_guidance_numeric_double_value_fk_numeric_double_value";
ALTER TABLE SCHEMANAME.plan_guidance_numeric_double_value
  RENAME CONSTRAINT "fk_plan_guidance" TO "plan_guidance_numeric_double_value_fk_plan_guidance";

ALTER TABLE SCHEMANAME.plan_guidance_numeric_range
  RENAME CONSTRAINT "fk_numeric_range" TO "plan_guidance_numeric_range_fk_numeric_range";
ALTER TABLE SCHEMANAME.plan_guidance_numeric_range
  RENAME CONSTRAINT "fk_plan_guidance" TO "plan_guidance_numeric_range_fk_plan_guidance";

ALTER TABLE SCHEMANAME.plan_guidance_text_value
  RENAME CONSTRAINT "fk_plan_guidance" TO "plan_guidance_text_value_fk_plan_guidance";
ALTER TABLE SCHEMANAME.plan_guidance_text_value
  RENAME CONSTRAINT "fk_text_value" TO "plan_guidance_text_value_fk_text_value";

ALTER TABLE SCHEMANAME.plan_guidance_theme
  RENAME CONSTRAINT "fk_plan_guidance" TO "plan_guidance_theme_fk_plan_guidance";
ALTER TABLE SCHEMANAME.plan_guidance_theme
  RENAME CONSTRAINT "fk_theme" TO "plan_guidance_theme_fk_theme";

ALTER TABLE SCHEMANAME.plan_guidance_time_instant_value
  RENAME CONSTRAINT "fk_plan_guidance" TO "plan_guidance_time_instant_value_fk_plan_guidance";
ALTER TABLE SCHEMANAME.plan_guidance_time_instant_value
  RENAME CONSTRAINT "fk_time_instant_value" TO "plan_guidance_time_instant_value_fk_time_instant_value";

ALTER TABLE SCHEMANAME.plan_guidance_time_period_value
  RENAME CONSTRAINT "fk_plan_guidance" TO "plan_guidance_time_period_value_fk_plan_guidance";
ALTER TABLE SCHEMANAME.plan_guidance_time_period_value
  RENAME CONSTRAINT "fk_time_period_value" TO "plan_guidance_time_period_value_fk_time_period_value";

ALTER TABLE SCHEMANAME.plan_regulation
  RENAME CONSTRAINT "fk_life_cycle_status" TO "plan_regulation_fk_life_cycle_status";
ALTER TABLE SCHEMANAME.plan_regulation
  RENAME CONSTRAINT "fk_type" TO "plan_regulation_fk_type";

ALTER TABLE SCHEMANAME.plan_regulation_code_value
  RENAME CONSTRAINT "fk_code_value" TO "plan_regulation_code_value_fk_code_value";
ALTER TABLE SCHEMANAME.plan_regulation_code_value
  RENAME CONSTRAINT "fk_plan_regulation" TO "plan_regulation_code_value_fk_plan_regulation";

ALTER TABLE SCHEMANAME.plan_regulation_document
  RENAME CONSTRAINT "fk_document" TO "plan_regulation_document_fk_document";
ALTER TABLE SCHEMANAME.plan_regulation_document
  RENAME CONSTRAINT "fk_plan_regulation" TO "plan_regulation_document_fk_plan_regulation";

ALTER TABLE SCHEMANAME.plan_regulation_geometry_area_value
  RENAME CONSTRAINT "fk_geometry_area_value" TO "plan_regulation_geometry_area_value_fk_geometry_area_value";
ALTER TABLE SCHEMANAME.plan_regulation_geometry_area_value
  RENAME CONSTRAINT "fk_plan_regulation" TO "plan_regulation_geometry_area_value_fk_plan_regulation";

ALTER TABLE SCHEMANAME.plan_regulation_geometry_point_value
  RENAME CONSTRAINT "fk_geometry_point_value" TO "plan_regulation_geometry_point_value_fk_geometry_point_value";
ALTER TABLE SCHEMANAME.plan_regulation_geometry_point_value
  RENAME CONSTRAINT "fk_plan_regulation" TO "plan_regulation_geometry_point_value_fk_plan_regulation";

ALTER TABLE SCHEMANAME.plan_regulation_geometry_line_value
  RENAME CONSTRAINT "fk_geometry_line_value" TO "plan_regulation_geometry_line_value_fk_geometry_line_value";
ALTER TABLE SCHEMANAME.plan_regulation_geometry_line_value
  RENAME CONSTRAINT "fk_plan_regulation" TO "plan_regulation_geometry_line_value_fk_plan_regulation";

ALTER TABLE SCHEMANAME.plan_regulation_identifier_value
  RENAME CONSTRAINT "fk_identifier_value" TO "plan_regulation_identifier_value_fk_identifier_value";
ALTER TABLE SCHEMANAME.plan_regulation_identifier_value
  RENAME CONSTRAINT "fk_plan_regulation" TO "plan_regulation_identifier_value_fk_plan_regulation";

ALTER TABLE SCHEMANAME.plan_regulation_numeric_double_value
  RENAME CONSTRAINT "fk_numeric_double_value" TO "plan_regulation_numeric_double_value_fk_numeric_double_value";
ALTER TABLE SCHEMANAME.plan_regulation_numeric_double_value
  RENAME CONSTRAINT "fk_plan_regulation" TO "plan_regulation_numeric_double_value_fk_plan_regulation";

ALTER TABLE SCHEMANAME.plan_regulation_numeric_range
  RENAME CONSTRAINT "fk_numeric_range" TO "plan_regulation_numeric_range_fk_numeric_range";
ALTER TABLE SCHEMANAME.plan_regulation_numeric_range
  RENAME CONSTRAINT "fk_plan_regulation" TO "plan_regulation_numeric_range_fk_plan_regulation";

ALTER TABLE SCHEMANAME.plan_regulation_text_value
  RENAME CONSTRAINT "fk_plan_regulation" TO "plan_regulation_text_value_fk_plan_regulation";
ALTER TABLE SCHEMANAME.plan_regulation_text_value
  RENAME CONSTRAINT "fk_text_value" TO "plan_regulation_text_value_fk_text_value";

ALTER TABLE SCHEMANAME.plan_regulation_theme
  RENAME CONSTRAINT "fk_plan_regulation" TO "plan_regulation_theme_fk_plan_regulation";
ALTER TABLE SCHEMANAME.plan_regulation_theme
  RENAME CONSTRAINT "fk_theme" TO "plan_regulation_theme_fk_theme";

ALTER TABLE SCHEMANAME.plan_regulation_time_instant_value
  RENAME CONSTRAINT "fk_plan_regulation" TO "plan_regulation_time_instant_value_fk_plan_regulation";
ALTER TABLE SCHEMANAME.plan_regulation_time_instant_value
  RENAME CONSTRAINT "fk_time_instant_value" TO "plan_regulation_time_instant_value_fk_time_instant_value";

ALTER TABLE SCHEMANAME.plan_regulation_time_period_value
  RENAME CONSTRAINT "fk_plan_regulation" TO "plan_regulation_time_period_value_fk_plan_regulation";
ALTER TABLE SCHEMANAME.plan_regulation_time_period_value
  RENAME CONSTRAINT "fk_time_period_value" TO "plan_regulation_time_period_value_fk_time_period_value";

ALTER TABLE SCHEMANAME.plan_regulation_group_regulation
  RENAME CONSTRAINT "fk_plan_regulation_group" TO "plan_regulation_group_regulation_fk_plan_regulation_group";
ALTER TABLE SCHEMANAME.plan_regulation_group_regulation
  RENAME CONSTRAINT "fk_plan_regulation" TO "plan_regulation_group_regulation_fk_plan_regulation";

ALTER TABLE SCHEMANAME.planned_space_plan_detail_line
  RENAME CONSTRAINT "fk_planned_space" TO "planned_space_plan_detail_line_fk_planned_space";
ALTER TABLE SCHEMANAME.planned_space_plan_detail_line
  RENAME CONSTRAINT "fk_planning_detail_line" TO "planned_space_plan_detail_line_fk_planning_detail_line";

ALTER TABLE SCHEMANAME.planned_space_plan_guidance
  RENAME CONSTRAINT "fk_plan_guidance" TO "planned_space_plan_guidance_fk_plan_guidance";
ALTER TABLE SCHEMANAME.planned_space_plan_guidance
  RENAME CONSTRAINT "fk_planned_space" TO "planned_space_plan_guidance_fk_planned_space";

ALTER TABLE SCHEMANAME.planned_space_plan_regulation
  RENAME CONSTRAINT "fk_planned_space" TO "planned_space_plan_regulation_fk_planned_space";
ALTER TABLE SCHEMANAME.planned_space_plan_regulation
  RENAME CONSTRAINT "fk_plan_regulation" TO "planned_space_plan_regulation_fk_plan_regulation";

ALTER TABLE SCHEMANAME.planned_space_plan_regulation_group
  RENAME CONSTRAINT "fk_plan_regulation_group" TO "planned_space_plan_regulation_group_fk_plan_regulation_group";
ALTER TABLE SCHEMANAME.planned_space_plan_regulation_group
  RENAME CONSTRAINT "fk_planned_space" TO "planned_space_plan_regulation_group_fk_planned_space";

ALTER TABLE SCHEMANAME.planner
  RENAME CONSTRAINT "spatial_plan_contact_fkey" TO "planner_fk_spatial_plan";

ALTER TABLE SCHEMANAME.planning_detail_line_plan_guidance
  RENAME CONSTRAINT "fk_plan_guidance" TO "planning_detail_line_plan_guidance_fk_plan_guidance";
ALTER TABLE SCHEMANAME.planning_detail_line_plan_guidance
  RENAME CONSTRAINT "fk_planning_detail_line" TO "planning_detail_line_plan_guidance_fk_planning_detail_line";

ALTER TABLE SCHEMANAME.planning_detail_line_plan_regulation
  RENAME CONSTRAINT "fk_plan_regulation" TO "planning_detail_line_plan_regulation_fk_plan_regulation";
ALTER TABLE SCHEMANAME.planning_detail_line_plan_regulation
  RENAME CONSTRAINT "fk_planning_detail_line" TO "planning_detail_line_plan_regulation_fk_planning_detail_line";

ALTER TABLE SCHEMANAME.planning_detail_line_plan_regulation_group
  RENAME CONSTRAINT "fk_plan_regulation_group" TO "planning_detail_line_plan_regulation_group_fk_plan_regulation_group";
ALTER TABLE SCHEMANAME.planning_detail_line_plan_regulation_group
  RENAME CONSTRAINT "fk_planning_detail_line" TO "planning_detail_line_plan_regulation_group_fk_planning_detail_line";

ALTER TABLE SCHEMANAME.spatial_plan_commentary
  RENAME CONSTRAINT "fk_spatial_plan" TO "spatial_plan_commentary_fk_spatial_plan";

ALTER TABLE SCHEMANAME.spatial_plan_commentary_document
  RENAME CONSTRAINT "fk_document" TO "spatial_plan_commentary_document_fk_document";
ALTER TABLE SCHEMANAME.spatial_plan_commentary_document
  RENAME CONSTRAINT "fk_spatial_plan_commentary" TO "spatial_plan_commentary_document_fk_spatial_plan_commentary";

ALTER TABLE SCHEMANAME.spatial_plan_plan_guidance
  RENAME CONSTRAINT "fk_plan_guidance" TO "spatial_plan_plan_guidance_fk_plan_guidance";
ALTER TABLE SCHEMANAME.spatial_plan_plan_guidance
  RENAME CONSTRAINT "fk_spatial_plan" TO "spatial_plan_plan_guidance_fk_spatial_plan";

ALTER TABLE SCHEMANAME.spatial_plan_plan_regulation
  RENAME CONSTRAINT "fk_plan_regulation" TO "spatial_plan_plan_regulation_fk_plan_regulation";
ALTER TABLE SCHEMANAME.spatial_plan_plan_regulation
  RENAME CONSTRAINT "fk_spatial_plan" TO "spatial_plan_plan_regulation_fk_spatial_plan";

ALTER TABLE SCHEMANAME.supplementary_information
  RENAME CONSTRAINT "fk_plan_regulation" TO "supplementary_information_fk_plan_regulation";
ALTER TABLE SCHEMANAME.supplementary_information
  RENAME CONSTRAINT "fk_type" TO "supplementary_information_fk_type";

ALTER TABLE SCHEMANAME.supplementary_information_code_value
  RENAME CONSTRAINT "fk_code_value" TO "supplementary_information_code_value_fk_code_value";
ALTER TABLE SCHEMANAME.supplementary_information_code_value
  RENAME CONSTRAINT "fk_supplementary_information" TO "supplementary_information_code_value_fk_supplementary_information";

ALTER TABLE SCHEMANAME.supplementary_information_geometry_area_value
  RENAME CONSTRAINT "fk_geometry_area_value" TO "supplementary_information_geometry_area_value_fk_geometry_area_value";
ALTER TABLE SCHEMANAME.supplementary_information_geometry_area_value
  RENAME CONSTRAINT "fk_supplementary_information" TO "supplementary_information_geometry_area_value_fk_supplementary_information";

ALTER TABLE SCHEMANAME.supplementary_information_geometry_point_value
  RENAME CONSTRAINT "fk_geometry_point_value" TO "supplementary_information_geometry_point_value_fk_geometry_point_value";
ALTER TABLE SCHEMANAME.supplementary_information_geometry_point_value
  RENAME CONSTRAINT "fk_supplementary_information" TO "supplementary_information_geometry_point_value_fk_supplementary_information";

ALTER TABLE SCHEMANAME.supplementary_information_geometry_line_value
  RENAME CONSTRAINT "fk_geometry_line_value" TO "supplementary_information_geometry_line_value_fk_geometry_line_value";
ALTER TABLE SCHEMANAME.supplementary_information_geometry_line_value
  RENAME CONSTRAINT "fk_supplementary_information" TO "supplementary_information_geometry_line_value_fk_supplementary_information";

ALTER TABLE SCHEMANAME.supplementary_information_identifier_value
  RENAME CONSTRAINT "fk_identifier_value" TO "supplementary_information_identifier_value_fk_identifier_value";
ALTER TABLE SCHEMANAME.supplementary_information_identifier_value
  RENAME CONSTRAINT "fk_supplementary_information" TO "supplementary_information_identifier_value_fk_supplementary_information";

ALTER TABLE SCHEMANAME.supplementary_information_numeric_double_value
  RENAME CONSTRAINT "fk_numeric_double_value" TO "supplementary_information_numeric_double_value_fk_numeric_double_value";
ALTER TABLE SCHEMANAME.supplementary_information_numeric_double_value
  RENAME CONSTRAINT "fk_supplementary_information" TO "supplementary_information_numeric_double_value_fk_supplementary_information";

ALTER TABLE SCHEMANAME.supplementary_information_numeric_range
  RENAME CONSTRAINT "fk_numeric_range" TO "supplementary_information_numeric_range_fk_numeric_range";
ALTER TABLE SCHEMANAME.supplementary_information_numeric_range
  RENAME CONSTRAINT "fk_supplementary_information" TO "supplementary_information_numeric_range_fk_supplementary_information";

ALTER TABLE SCHEMANAME.supplementary_information_text_value
  RENAME CONSTRAINT "fk_supplementary_information" TO "supplementary_information_text_value_fk_supplementary_information";
ALTER TABLE SCHEMANAME.supplementary_information_text_value
  RENAME CONSTRAINT "fk_text_value" TO "supplementary_information_text_value_fk_text_value";

ALTER TABLE SCHEMANAME.supplementary_information_time_instant_value
  RENAME CONSTRAINT "fk_supplementary_information" TO "supplementary_information_time_instant_value_fk_supplementary_information";
ALTER TABLE SCHEMANAME.supplementary_information_time_instant_value
  RENAME CONSTRAINT "fk_time_instant_value" TO "supplementary_information_time_instant_value_fk_time_instant_value";

ALTER TABLE SCHEMANAME.supplementary_information_time_period_value
  RENAME CONSTRAINT "fk_supplementary_information" TO "supplementary_information_time_period_value_fk_supplementary_information";
ALTER TABLE SCHEMANAME.supplementary_information_time_period_value
  RENAME CONSTRAINT "fk_time_period_value" TO "supplementary_information_time_period_value_fk_time_period_value";

ALTER TABLE SCHEMANAME.zoning_element
  RENAME CONSTRAINT "fk_spatial_plan" TO "zoning_element_fk_spatial_plan";
ALTER TABLE SCHEMANAME.zoning_element
  RENAME CONSTRAINT "zoning_element_bindingness_of_location_fkey" TO "zoning_element_fk_bindingness_of_location";
ALTER TABLE SCHEMANAME.zoning_element
  RENAME CONSTRAINT "zoning_element_ground_relative_position_fkey" TO "zoning_element_fk_ground_relative_position";
ALTER TABLE SCHEMANAME.zoning_element
  RENAME CONSTRAINT "zoning_element_land_use_kind_fkey" TO "zoning_element_fk_land_use_kind";

ALTER TABLE SCHEMANAME.zoning_element_describing_line
  RENAME CONSTRAINT "describing_line_zoning_element_fk" TO "zoning_element_describing_line_fk_describing_line";
ALTER TABLE SCHEMANAME.zoning_element_describing_line
  RENAME CONSTRAINT "zoning_element_fk" TO "zoning_element_describing_line_fk_zoning_element";

ALTER TABLE SCHEMANAME.zoning_element_describing_text
  RENAME CONSTRAINT "describing_text_zoning_element_fk" TO "zoning_element_describing_text_fk_describing_text";
ALTER TABLE SCHEMANAME.zoning_element_describing_text
  RENAME CONSTRAINT "zoning_element_fk" TO "zoning_element_describing_text_fk_zoning_element";

ALTER TABLE SCHEMANAME.zoning_element_plan_detail_line
  RENAME CONSTRAINT "fk_planning_detail_line" TO "zoning_element_plan_detail_line_fk_planning_detail_line";
ALTER TABLE SCHEMANAME.zoning_element_plan_detail_line
  RENAME CONSTRAINT "fk_zoning_element" TO "zoning_element_plan_detail_line_fk_zoning_element";

ALTER TABLE SCHEMANAME.zoning_element_plan_guidance
  RENAME CONSTRAINT "fk_plan_guidance" TO "zoning_element_plan_guidance_fk_plan_guidance";
ALTER TABLE SCHEMANAME.zoning_element_plan_guidance
  RENAME CONSTRAINT "fk_zoning_element" TO "zoning_element_plan_guidance_fk_zoning_element";

ALTER TABLE SCHEMANAME.zoning_element_plan_regulation
  RENAME CONSTRAINT "fk_plan_regulation" TO "zoning_element_plan_regulation_fk_plan_regulation";
ALTER TABLE SCHEMANAME.zoning_element_plan_regulation
  RENAME CONSTRAINT "fk_zoning_element" TO "zoning_element_plan_regulation_fk_zoning_element";

ALTER TABLE SCHEMANAME.zoning_element_plan_regulation_group
  RENAME CONSTRAINT "fk_plan_regulation_group" TO "zoning_element_plan_regulation_group_fk_plan_regulation_group";
ALTER TABLE SCHEMANAME.zoning_element_plan_regulation_group
  RENAME CONSTRAINT "fk_zoning_element" TO "zoning_element_plan_regulation_group_fk_zoning_element";

ALTER TABLE SCHEMANAME.zoning_element_planned_space
  RENAME CONSTRAINT "fk_planned_space" TO "zoning_element_planned_space_fk_planned_space";
ALTER TABLE SCHEMANAME.zoning_element_planned_space
  RENAME CONSTRAINT "fk_zoning_element" TO "zoning_element_planned_space_fk_zoning_element";