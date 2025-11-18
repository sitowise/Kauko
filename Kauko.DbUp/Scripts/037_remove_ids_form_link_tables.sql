-- decision_document
ALTER TABLE $SCHEMANAME$.decision_document DROP CONSTRAINT IF EXISTS decision_document_pkey;
ALTER TABLE $SCHEMANAME$.decision_document DROP COLUMN IF EXISTS id;
ALTER TABLE $SCHEMANAME$.decision_document ADD CONSTRAINT decision_document_pkey PRIMARY KEY (decision_local_id, document_local_id);

-- document_document
ALTER TABLE $SCHEMANAME$.document_document DROP CONSTRAINT IF EXISTS document_document_pkey;
ALTER TABLE $SCHEMANAME$.document_document DROP COLUMN IF EXISTS id;
ALTER TABLE $SCHEMANAME$.document_document ADD CONSTRAINT document_document_pkey PRIMARY KEY (referencing_document_local_id, referenced_document_local_id);

-- document_language
ALTER TABLE $SCHEMANAME$.document_language DROP CONSTRAINT IF EXISTS document_language_pkey;
ALTER TABLE $SCHEMANAME$.document_language DROP COLUMN IF EXISTS id;
ALTER TABLE $SCHEMANAME$.document_language ADD CONSTRAINT document_language_pkey PRIMARY KEY (fk_document, fk_language);

-- plan_decision_document
ALTER TABLE $SCHEMANAME$.plan_decision_document DROP CONSTRAINT IF EXISTS plan_decision_document_pkey;
ALTER TABLE $SCHEMANAME$.plan_decision_document DROP COLUMN IF EXISTS id;
ALTER TABLE $SCHEMANAME$.plan_decision_document ADD CONSTRAINT plan_decision_document_pkey PRIMARY KEY (fk_plan_decision, fk_document);

-- plan_decision_statutes
ALTER TABLE $SCHEMANAME$.plan_decision_statutes DROP CONSTRAINT IF EXISTS plan_decision_statutes_pkey;
ALTER TABLE $SCHEMANAME$.plan_decision_statutes DROP COLUMN IF EXISTS id;
ALTER TABLE $SCHEMANAME$.plan_decision_statutes ADD CONSTRAINT plan_decision_statutes_pkey PRIMARY KEY (statute_local_id, decision_local_id);

-- plan_guidance_document
ALTER TABLE $SCHEMANAME$.plan_guidance_document DROP CONSTRAINT IF EXISTS plan_guidance_document_pkey;
ALTER TABLE $SCHEMANAME$.plan_guidance_document DROP COLUMN IF EXISTS id;
ALTER TABLE $SCHEMANAME$.plan_guidance_document ADD CONSTRAINT plan_guidance_document_pkey PRIMARY KEY (plan_guidance_local_id, document_local_id);

-- plan_guidance_theme
ALTER TABLE $SCHEMANAME$.plan_guidance_theme DROP CONSTRAINT IF EXISTS plan_guidance_theme_pkey;
ALTER TABLE $SCHEMANAME$.plan_guidance_theme DROP COLUMN IF EXISTS id;
ALTER TABLE $SCHEMANAME$.plan_guidance_theme ADD CONSTRAINT plan_guidance_theme_pkey PRIMARY KEY (plan_guidance_local_id, theme_code);

-- plan_handling_event_document
ALTER TABLE $SCHEMANAME$.plan_handling_event_document DROP CONSTRAINT IF EXISTS plan_handling_event_document_pkey;
ALTER TABLE $SCHEMANAME$.plan_handling_event_document DROP COLUMN IF EXISTS id;
ALTER TABLE $SCHEMANAME$.plan_handling_event_document ADD CONSTRAINT plan_handling_event_document_pkey PRIMARY KEY (fk_plan_handling_event, fk_document);

-- plan_interaction_event_document
ALTER TABLE $SCHEMANAME$.plan_interaction_event_document DROP CONSTRAINT IF EXISTS plan_interaction_event_document_pkey;
ALTER TABLE $SCHEMANAME$.plan_interaction_event_document DROP COLUMN IF EXISTS id;
ALTER TABLE $SCHEMANAME$.plan_interaction_event_document ADD CONSTRAINT plan_interaction_event_document_pkey PRIMARY KEY (fk_plan_interaction_event, fk_document);

-- plan_operator_document
ALTER TABLE $SCHEMANAME$.plan_operator_document DROP CONSTRAINT IF EXISTS plan_operator_document_pkey;
ALTER TABLE $SCHEMANAME$.plan_operator_document DROP COLUMN IF EXISTS id;
ALTER TABLE $SCHEMANAME$.plan_operator_document ADD CONSTRAINT plan_operator_document_pkey PRIMARY KEY (fk_plan_operator, fk_document);

-- plan_regulation_document
ALTER TABLE $SCHEMANAME$.plan_regulation_document DROP CONSTRAINT IF EXISTS plan_regulation_document_pkey;
ALTER TABLE $SCHEMANAME$.plan_regulation_document DROP COLUMN IF EXISTS id;
ALTER TABLE $SCHEMANAME$.plan_regulation_document ADD CONSTRAINT plan_regulation_document_pkey PRIMARY KEY (plan_regulation_local_id, document_local_id);

-- plan_regulation_group_regulation
ALTER TABLE $SCHEMANAME$.plan_regulation_group_regulation DROP CONSTRAINT IF EXISTS plan_regulation_group_regulation_pkey;
ALTER TABLE $SCHEMANAME$.plan_regulation_group_regulation DROP COLUMN IF EXISTS id;
ALTER TABLE $SCHEMANAME$.plan_regulation_group_regulation ADD CONSTRAINT plan_regulation_group_regulation_pkey PRIMARY KEY (plan_regulation_group_local_id, plan_regulation_local_id);

-- plan_regulation_supplementary_information
ALTER TABLE $SCHEMANAME$.plan_regulation_supplementary_information DROP CONSTRAINT IF EXISTS plan_regulation_supplementary_information_pkey;
ALTER TABLE $SCHEMANAME$.plan_regulation_supplementary_information DROP COLUMN IF EXISTS id;
ALTER TABLE $SCHEMANAME$.plan_regulation_supplementary_information ADD CONSTRAINT plan_regulation_supplementary_information_pkey PRIMARY KEY (fk_plan_regulation, fk_supplementary_information);

-- plan_regulation_theme
ALTER TABLE $SCHEMANAME$.plan_regulation_theme DROP CONSTRAINT IF EXISTS plan_regulation_theme_pkey;
ALTER TABLE $SCHEMANAME$.plan_regulation_theme DROP COLUMN IF EXISTS id;
ALTER TABLE $SCHEMANAME$.plan_regulation_theme ADD CONSTRAINT plan_regulation_theme_pkey PRIMARY KEY (plan_regulation_local_id, theme_code);

-- plan_regulation_verbal_regulation
ALTER TABLE $SCHEMANAME$.plan_regulation_verbal_regulation DROP CONSTRAINT IF EXISTS plan_regulation_verbal_regulation_pkey;
ALTER TABLE $SCHEMANAME$.plan_regulation_verbal_regulation DROP COLUMN IF EXISTS id;
ALTER TABLE $SCHEMANAME$.plan_regulation_verbal_regulation ADD CONSTRAINT plan_regulation_verbal_regulation_pkey PRIMARY KEY (fk_plan_regulation, fk_verbal_regulation);

-- plan_report_document
ALTER TABLE $SCHEMANAME$.plan_report_document DROP CONSTRAINT IF EXISTS plan_report_document_pkey;
ALTER TABLE $SCHEMANAME$.plan_report_document DROP COLUMN IF EXISTS id;
ALTER TABLE $SCHEMANAME$.plan_report_document ADD CONSTRAINT plan_report_document_pkey PRIMARY KEY (fk_plan_report, fk_document);

-- plan_source_data_document
ALTER TABLE $SCHEMANAME$.plan_source_data_document DROP CONSTRAINT IF EXISTS plan_source_data_document_pkey;
ALTER TABLE $SCHEMANAME$.plan_source_data_document DROP COLUMN IF EXISTS id;
ALTER TABLE $SCHEMANAME$.plan_source_data_document ADD CONSTRAINT plan_source_data_document_pkey PRIMARY KEY (fk_plan_source_data, fk_document);

-- planned_space_plan_detail_line
ALTER TABLE $SCHEMANAME$.planned_space_plan_detail_line DROP CONSTRAINT IF EXISTS planned_space_plan_detail_line_pkey;
ALTER TABLE $SCHEMANAME$.planned_space_plan_detail_line DROP COLUMN IF EXISTS id;
ALTER TABLE $SCHEMANAME$.planned_space_plan_detail_line ADD CONSTRAINT planned_space_plan_detail_line_pkey PRIMARY KEY (fk_planned_space, fk_planning_detail_line);

-- planned_space_plan_detail_point
ALTER TABLE $SCHEMANAME$.planned_space_plan_detail_point DROP CONSTRAINT IF EXISTS planned_space_plan_detail_point_pkey;
ALTER TABLE $SCHEMANAME$.planned_space_plan_detail_point DROP COLUMN IF EXISTS id;
ALTER TABLE $SCHEMANAME$.planned_space_plan_detail_point ADD CONSTRAINT planned_space_plan_detail_point_pkey PRIMARY KEY (fk_planned_space, fk_planning_detail_point);

-- planned_space_plan_regulation_group
ALTER TABLE $SCHEMANAME$.planned_space_plan_regulation_group DROP CONSTRAINT IF EXISTS planned_space_plan_regulation_group_pkey;
ALTER TABLE $SCHEMANAME$.planned_space_plan_regulation_group DROP COLUMN IF EXISTS id;
ALTER TABLE $SCHEMANAME$.planned_space_plan_regulation_group ADD CONSTRAINT planned_space_plan_regulation_group_pkey PRIMARY KEY (planned_space_local_id, plan_regulation_group_local_id);

-- planning_detail_line_plan_regulation_group
ALTER TABLE $SCHEMANAME$.planning_detail_line_plan_regulation_group DROP CONSTRAINT IF EXISTS planning_detail_line_plan_regulation_group_pkey;
ALTER TABLE $SCHEMANAME$.planning_detail_line_plan_regulation_group DROP COLUMN IF EXISTS id;
ALTER TABLE $SCHEMANAME$.planning_detail_line_plan_regulation_group ADD CONSTRAINT planning_detail_line_plan_regulation_group_pkey PRIMARY KEY (planning_detail_line_local_id, plan_regulation_group_local_id);

-- planning_detail_point_plan_regulation_group
ALTER TABLE $SCHEMANAME$.planning_detail_point_plan_regulation_group DROP CONSTRAINT IF EXISTS planning_detail_point_plan_regulation_group_pkey;
ALTER TABLE $SCHEMANAME$.planning_detail_point_plan_regulation_group DROP COLUMN IF EXISTS id;
ALTER TABLE $SCHEMANAME$.planning_detail_point_plan_regulation_group ADD CONSTRAINT planning_detail_point_plan_regulation_group_pkey PRIMARY KEY (planning_detail_point_local_id, plan_regulation_group_local_id);

-- spatial_plan_document
ALTER TABLE $SCHEMANAME$.spatial_plan_document DROP CONSTRAINT IF EXISTS spatial_plan_document_pkey;
ALTER TABLE $SCHEMANAME$.spatial_plan_document DROP COLUMN IF EXISTS id;
ALTER TABLE $SCHEMANAME$.spatial_plan_document ADD CONSTRAINT spatial_plan_document_pkey PRIMARY KEY (spatial_plan_local_id, document_local_id);

-- spatial_plan_interaction_event
ALTER TABLE $SCHEMANAME$.spatial_plan_interaction_event DROP CONSTRAINT IF EXISTS spatial_plan_interaction_event_pkey;
ALTER TABLE $SCHEMANAME$.spatial_plan_interaction_event DROP COLUMN IF EXISTS id;
ALTER TABLE $SCHEMANAME$.spatial_plan_interaction_event ADD CONSTRAINT spatial_plan_interaction_event_pkey PRIMARY KEY (fk_plan_interaction_event, fk_spatial_plan);

-- spatial_plan_main_plan_source_data
ALTER TABLE $SCHEMANAME$.spatial_plan_main_plan_source_data DROP CONSTRAINT IF EXISTS spatial_plan_main_plan_source_data_pkey;
ALTER TABLE $SCHEMANAME$.spatial_plan_main_plan_source_data DROP COLUMN IF EXISTS id;
ALTER TABLE $SCHEMANAME$.spatial_plan_main_plan_source_data ADD CONSTRAINT spatial_plan_main_plan_source_data_pkey PRIMARY KEY (fk_spatial_plan_main, fk_plan_source_data);

-- spatial_plan_other_plan_document
ALTER TABLE $SCHEMANAME$.spatial_plan_other_plan_document DROP CONSTRAINT IF EXISTS spatial_plan_other_plan_document_pkey;
ALTER TABLE $SCHEMANAME$.spatial_plan_other_plan_document DROP COLUMN IF EXISTS id;
ALTER TABLE $SCHEMANAME$.spatial_plan_other_plan_document ADD CONSTRAINT spatial_plan_other_plan_document_pkey PRIMARY KEY (fk_spatial_plan, fk_other_plan_document);

-- spatial_plan_plan_regulation_group
ALTER TABLE $SCHEMANAME$.spatial_plan_plan_regulation_group DROP CONSTRAINT IF EXISTS spatial_plan_plan_regulation_group_pkey;
ALTER TABLE $SCHEMANAME$.spatial_plan_plan_regulation_group DROP COLUMN IF EXISTS id;
ALTER TABLE $SCHEMANAME$.spatial_plan_plan_regulation_group ADD CONSTRAINT spatial_plan_plan_regulation_group_pkey PRIMARY KEY (fk_spatial_plan, fk_plan_regulation_group);

-- spatial_plan_planner
ALTER TABLE $SCHEMANAME$.spatial_plan_planner DROP CONSTRAINT IF EXISTS spatial_plan_planner_pkey;
ALTER TABLE $SCHEMANAME$.spatial_plan_planner DROP COLUMN IF EXISTS id;
ALTER TABLE $SCHEMANAME$.spatial_plan_planner ADD CONSTRAINT spatial_plan_planner_pkey PRIMARY KEY (fk_spatial_plan, fk_plan_operator);

-- zoning_element_describing_line
ALTER TABLE $SCHEMANAME$.zoning_element_describing_line DROP CONSTRAINT IF EXISTS zoning_element_describing_line_pkey;
ALTER TABLE $SCHEMANAME$.zoning_element_describing_line DROP COLUMN IF EXISTS id;
ALTER TABLE $SCHEMANAME$.zoning_element_describing_line ADD CONSTRAINT zoning_element_describing_line_pkey PRIMARY KEY (describing_line_id, zoning_element_local_id);

-- zoning_element_describing_text
ALTER TABLE $SCHEMANAME$.zoning_element_describing_text DROP CONSTRAINT IF EXISTS zoning_element_describing_text_pkey;
ALTER TABLE $SCHEMANAME$.zoning_element_describing_text DROP COLUMN IF EXISTS id;
ALTER TABLE $SCHEMANAME$.zoning_element_describing_text ADD CONSTRAINT zoning_element_describing_text_pkey PRIMARY KEY (describing_text_id, zoning_element_local_id);

-- zoning_element_plan_detail_line
ALTER TABLE $SCHEMANAME$.zoning_element_plan_detail_line DROP CONSTRAINT IF EXISTS zoning_element_plan_detail_line_pkey;
ALTER TABLE $SCHEMANAME$.zoning_element_plan_detail_line DROP COLUMN IF EXISTS id;
ALTER TABLE $SCHEMANAME$.zoning_element_plan_detail_line ADD CONSTRAINT zoning_element_plan_detail_line_pkey PRIMARY KEY (zoning_element_local_id, planning_detail_line_local_id);

-- zoning_element_plan_detail_point
ALTER TABLE $SCHEMANAME$.zoning_element_plan_detail_point DROP CONSTRAINT IF EXISTS zoning_element_plan_detail_point_pkey;
ALTER TABLE $SCHEMANAME$.zoning_element_plan_detail_point DROP COLUMN IF EXISTS id;
ALTER TABLE $SCHEMANAME$.zoning_element_plan_detail_point ADD CONSTRAINT zoning_element_plan_detail_point_pkey PRIMARY KEY (zoning_element_local_id, planning_detail_point_local_id);

-- zoning_element_plan_regulation_group
ALTER TABLE $SCHEMANAME$.zoning_element_plan_regulation_group DROP CONSTRAINT IF EXISTS zoning_element_plan_regulation_group_pkey;
ALTER TABLE $SCHEMANAME$.zoning_element_plan_regulation_group DROP COLUMN IF EXISTS id;
ALTER TABLE $SCHEMANAME$.zoning_element_plan_regulation_group ADD CONSTRAINT zoning_element_plan_regulation_group_pkey PRIMARY KEY (zoning_element_local_id, plan_regulation_group_local_id);

-- zoning_element_planned_space
ALTER TABLE $SCHEMANAME$.zoning_element_planned_space DROP CONSTRAINT IF EXISTS zoning_element_planned_space_pkey;
ALTER TABLE $SCHEMANAME$.zoning_element_planned_space DROP COLUMN IF EXISTS id;
ALTER TABLE $SCHEMANAME$.zoning_element_planned_space ADD CONSTRAINT zoning_element_planned_space_pkey PRIMARY KEY (zoning_element_local_id, planned_space_local_id);
