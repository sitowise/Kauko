-- Table: $SCHEMANAME$.plan_guidance

ALTER TABLE $SCHEMANAME$.plan_guidance
ADD COLUMN fk_code_value uuid;
ALTER TABLE $SCHEMANAME$.plan_guidance
ADD CONSTRAINT plan_guidance_fk_code_value FOREIGN KEY (fk_code_value)
        REFERENCES $SCHEMANAME$.code_value (code_value_uuid) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE $SCHEMANAME$.plan_guidance
ADD COLUMN fk_elevation_position_value uuid;
ALTER TABLE $SCHEMANAME$.plan_guidance
ADD CONSTRAINT plan_guidance_fk_elevation_position_value FOREIGN KEY (fk_elevation_position_value)
        REFERENCES $SCHEMANAME$.elevation_position_value (elevation_position_value_uuid) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE $SCHEMANAME$.plan_guidance
ADD COLUMN fk_elevation_range_value uuid;
ALTER TABLE $SCHEMANAME$.plan_guidance
ADD CONSTRAINT plan_guidance_fk_elevation_range_value FOREIGN KEY (fk_elevation_range_value)
        REFERENCES $SCHEMANAME$.elevation_range_value (elevation_range_value_uuid) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE $SCHEMANAME$.plan_guidance
ADD COLUMN fk_geometry_area_value uuid;
ALTER TABLE $SCHEMANAME$.plan_guidance
ADD CONSTRAINT plan_guidance_fk_geometry_area_value FOREIGN KEY (fk_geometry_area_value)
        REFERENCES $SCHEMANAME$.geometry_area_value (geometry_area_value_uuid) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE $SCHEMANAME$.plan_guidance
ADD COLUMN fk_geometry_line_value uuid;
ALTER TABLE $SCHEMANAME$.plan_guidance
ADD CONSTRAINT plan_guidance_fk_geometry_line_value FOREIGN KEY (fk_geometry_line_value)
        REFERENCES $SCHEMANAME$.geometry_line_value (geometry_line_value_uuid) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE $SCHEMANAME$.plan_guidance
ADD COLUMN fk_geometry_point_value uuid;
ALTER TABLE $SCHEMANAME$.plan_guidance
ADD CONSTRAINT plan_guidance_fk_geometry_point_value FOREIGN KEY (fk_geometry_point_value)
        REFERENCES $SCHEMANAME$.geometry_point_value (geometry_point_value_uuid) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE $SCHEMANAME$.plan_guidance
ADD COLUMN fk_numeric_double_value uuid;
ALTER TABLE $SCHEMANAME$.plan_guidance
ADD CONSTRAINT plan_guidance_fk_numeric_double_value FOREIGN KEY (fk_numeric_double_value)
        REFERENCES $SCHEMANAME$.numeric_double_value (numeric_double_value_uuid) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE $SCHEMANAME$.plan_guidance
ADD COLUMN fk_numeric_range uuid;
ALTER TABLE $SCHEMANAME$.plan_guidance
ADD CONSTRAINT plan_guidance_fk_numeric_range FOREIGN KEY (fk_numeric_range)
        REFERENCES $SCHEMANAME$.numeric_range (numeric_range_uuid) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE $SCHEMANAME$.plan_guidance
ADD COLUMN fk_text_value uuid;
ALTER TABLE $SCHEMANAME$.plan_guidance
ADD CONSTRAINT plan_guidance_fk_text_value FOREIGN KEY (fk_text_value)
        REFERENCES $SCHEMANAME$.text_value (text_value_uuid) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE $SCHEMANAME$.plan_guidance
ADD COLUMN fk_time_instant_value uuid;
ALTER TABLE $SCHEMANAME$.plan_guidance
ADD CONSTRAINT plan_guidance_fk_time_instant_value FOREIGN KEY (fk_time_instant_value)
        REFERENCES $SCHEMANAME$.time_instant_value (time_instant_uuid) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE $SCHEMANAME$.plan_guidance
ADD COLUMN fk_time_period_value uuid;
ALTER TABLE $SCHEMANAME$.plan_guidance
ADD CONSTRAINT plan_guidance_fk_time_period_value FOREIGN KEY (fk_time_period_value)
        REFERENCES $SCHEMANAME$.time_period_value (time_period_uuid) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE $SCHEMANAME$.plan_guidance
ADD CONSTRAINT ensure_one_fk
CHECK (
    num_nonnulls(
        fk_code_value, 
        fk_elevation_position_value,
        fk_elevation_range_value,
        fk_geometry_area_value,
        fk_geometry_line_value,
        fk_geometry_point_value,
        fk_numeric_double_value,
        fk_numeric_range,
        fk_text_value,
        fk_time_instant_value,
        fk_time_period_value
    ) = 1
);

-- Table: $SCHEMANAME$.plan_regulation

ALTER TABLE $SCHEMANAME$.plan_regulation
ADD COLUMN fk_code_value uuid;
ALTER TABLE $SCHEMANAME$.plan_regulation
ADD CONSTRAINT plan_regulation_fk_code_value FOREIGN KEY (fk_code_value)
        REFERENCES $SCHEMANAME$.code_value (code_value_uuid) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE $SCHEMANAME$.plan_regulation
ADD COLUMN fk_elevation_position_value uuid;
ALTER TABLE $SCHEMANAME$.plan_regulation
ADD CONSTRAINT plan_regulation_fk_elevation_position_value FOREIGN KEY (fk_elevation_position_value)
        REFERENCES $SCHEMANAME$.elevation_position_value (elevation_position_value_uuid) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE $SCHEMANAME$.plan_regulation
ADD COLUMN fk_elevation_range_value uuid;
ALTER TABLE $SCHEMANAME$.plan_regulation
ADD CONSTRAINT plan_regulation_fk_elevation_range_value FOREIGN KEY (fk_elevation_range_value)
        REFERENCES $SCHEMANAME$.elevation_range_value (elevation_range_value_uuid) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE $SCHEMANAME$.plan_regulation
ADD COLUMN fk_geometry_area_value uuid;
ALTER TABLE $SCHEMANAME$.plan_regulation
ADD CONSTRAINT plan_regulation_fk_geometry_area_value FOREIGN KEY (fk_geometry_area_value)
        REFERENCES $SCHEMANAME$.geometry_area_value (geometry_area_value_uuid) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE $SCHEMANAME$.plan_regulation
ADD COLUMN fk_geometry_line_value uuid;
ALTER TABLE $SCHEMANAME$.plan_regulation
ADD CONSTRAINT plan_regulation_fk_geometry_line_value FOREIGN KEY (fk_geometry_line_value)
        REFERENCES $SCHEMANAME$.geometry_line_value (geometry_line_value_uuid) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE $SCHEMANAME$.plan_regulation
ADD COLUMN fk_geometry_point_value uuid;
ALTER TABLE $SCHEMANAME$.plan_regulation
ADD CONSTRAINT plan_regulation_fk_geometry_point_value FOREIGN KEY (fk_geometry_point_value)
        REFERENCES $SCHEMANAME$.geometry_point_value (geometry_point_value_uuid) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE $SCHEMANAME$.plan_regulation
ADD COLUMN fk_numeric_double_value uuid;
ALTER TABLE $SCHEMANAME$.plan_regulation
ADD CONSTRAINT plan_regulation_fk_numeric_double_value FOREIGN KEY (fk_numeric_double_value)
        REFERENCES $SCHEMANAME$.numeric_double_value (numeric_double_value_uuid) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE $SCHEMANAME$.plan_regulation
ADD COLUMN fk_numeric_range uuid;
ALTER TABLE $SCHEMANAME$.plan_regulation
ADD CONSTRAINT plan_regulation_fk_numeric_range FOREIGN KEY (fk_numeric_range)
        REFERENCES $SCHEMANAME$.numeric_range (numeric_range_uuid) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE $SCHEMANAME$.plan_regulation
ADD COLUMN fk_text_value uuid;
ALTER TABLE $SCHEMANAME$.plan_regulation
ADD CONSTRAINT plan_regulation_fk_text_value FOREIGN KEY (fk_text_value)
        REFERENCES $SCHEMANAME$.text_value (text_value_uuid) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE $SCHEMANAME$.plan_regulation
ADD COLUMN fk_time_instant_value uuid;
ALTER TABLE $SCHEMANAME$.plan_regulation
ADD CONSTRAINT plan_regulation_fk_time_instant_value FOREIGN KEY (fk_time_instant_value)
        REFERENCES $SCHEMANAME$.time_instant_value (time_instant_uuid) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE $SCHEMANAME$.plan_regulation
ADD COLUMN fk_time_period_value uuid;
ALTER TABLE $SCHEMANAME$.plan_regulation
ADD CONSTRAINT plan_regulation_fk_time_period_value FOREIGN KEY (fk_time_period_value)
        REFERENCES $SCHEMANAME$.time_period_value (time_period_uuid) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE $SCHEMANAME$.plan_regulation
ADD CONSTRAINT ensure_one_fk
CHECK (
    num_nonnulls(
        fk_code_value, 
        fk_elevation_position_value,
        fk_elevation_range_value,
        fk_geometry_area_value,
        fk_geometry_line_value,
        fk_geometry_point_value,
        fk_numeric_double_value,
        fk_numeric_range,
        fk_text_value,
        fk_time_instant_value,
        fk_time_period_value
    ) = 1
);

-- Table: $SCHEMANAME$.supplementary_information

ALTER TABLE $SCHEMANAME$.supplementary_information
ADD COLUMN fk_code_value uuid;
ALTER TABLE $SCHEMANAME$.supplementary_information
ADD CONSTRAINT supplementary_information_fk_code_value FOREIGN KEY (fk_code_value)
        REFERENCES $SCHEMANAME$.code_value (code_value_uuid) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE $SCHEMANAME$.supplementary_information
ADD COLUMN fk_elevation_position_value uuid;
ALTER TABLE $SCHEMANAME$.supplementary_information
ADD CONSTRAINT supplementary_information_fk_elevation_position_value FOREIGN KEY (fk_elevation_position_value)
        REFERENCES $SCHEMANAME$.elevation_position_value (elevation_position_value_uuid) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE $SCHEMANAME$.supplementary_information
ADD COLUMN fk_elevation_range_value uuid;
ALTER TABLE $SCHEMANAME$.supplementary_information
ADD CONSTRAINT supplementary_information_fk_elevation_range_value FOREIGN KEY (fk_elevation_range_value)
        REFERENCES $SCHEMANAME$.elevation_range_value (elevation_range_value_uuid) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE $SCHEMANAME$.supplementary_information
ADD COLUMN fk_geometry_area_value uuid;
ALTER TABLE $SCHEMANAME$.supplementary_information
ADD CONSTRAINT supplementary_information_fk_geometry_area_value FOREIGN KEY (fk_geometry_area_value)
        REFERENCES $SCHEMANAME$.geometry_area_value (geometry_area_value_uuid) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE $SCHEMANAME$.supplementary_information
ADD COLUMN fk_geometry_line_value uuid;
ALTER TABLE $SCHEMANAME$.supplementary_information
ADD CONSTRAINT supplementary_information_fk_geometry_line_value FOREIGN KEY (fk_geometry_line_value)
        REFERENCES $SCHEMANAME$.geometry_line_value (geometry_line_value_uuid) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE $SCHEMANAME$.supplementary_information
ADD COLUMN fk_geometry_point_value uuid;
ALTER TABLE $SCHEMANAME$.supplementary_information
ADD CONSTRAINT supplementary_information_fk_geometry_point_value FOREIGN KEY (fk_geometry_point_value)
        REFERENCES $SCHEMANAME$.geometry_point_value (geometry_point_value_uuid) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE $SCHEMANAME$.supplementary_information
ADD COLUMN fk_numeric_double_value uuid;
ALTER TABLE $SCHEMANAME$.supplementary_information
ADD CONSTRAINT supplementary_information_fk_numeric_double_value FOREIGN KEY (fk_numeric_double_value)
        REFERENCES $SCHEMANAME$.numeric_double_value (numeric_double_value_uuid) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE $SCHEMANAME$.supplementary_information
ADD COLUMN fk_numeric_range uuid;
ALTER TABLE $SCHEMANAME$.supplementary_information
ADD CONSTRAINT supplementary_information_fk_numeric_range FOREIGN KEY (fk_numeric_range)
        REFERENCES $SCHEMANAME$.numeric_range (numeric_range_uuid) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE $SCHEMANAME$.supplementary_information
ADD COLUMN fk_text_value uuid;
ALTER TABLE $SCHEMANAME$.supplementary_information
ADD CONSTRAINT supplementary_information_fk_text_value FOREIGN KEY (fk_text_value)
        REFERENCES $SCHEMANAME$.text_value (text_value_uuid) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE $SCHEMANAME$.supplementary_information
ADD COLUMN fk_time_instant_value uuid;
ALTER TABLE $SCHEMANAME$.supplementary_information
ADD CONSTRAINT supplementary_information_fk_time_instant_value FOREIGN KEY (fk_time_instant_value)
        REFERENCES $SCHEMANAME$.time_instant_value (time_instant_uuid) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE $SCHEMANAME$.supplementary_information
ADD COLUMN fk_time_period_value uuid;
ALTER TABLE $SCHEMANAME$.supplementary_information
ADD CONSTRAINT supplementary_information_fk_time_period_value FOREIGN KEY (fk_time_period_value)
        REFERENCES $SCHEMANAME$.time_period_value (time_period_uuid) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE $SCHEMANAME$.supplementary_information
ADD CONSTRAINT ensure_one_fk
CHECK (
    num_nonnulls(
        fk_code_value, 
        fk_elevation_position_value,
        fk_elevation_range_value,
        fk_geometry_area_value,
        fk_geometry_line_value,
        fk_geometry_point_value,
        fk_numeric_double_value,
        fk_numeric_range,
        fk_text_value,
        fk_time_instant_value,
        fk_time_period_value
    ) = 1
);

-- Table: $SCHEMANAME$.planner

ALTER TABLE $SCHEMANAME$.planner
RENAME TO plan_operator;
ALTER TABLE $SCHEMANAME$.plan_operator
RENAME COLUMN name TO last_name;


ALTER TABLE $SCHEMANAME$.plan_operator
ADD COLUMN first_name TEXT;
ALTER TABLE $SCHEMANAME$.plan_operator
ADD COLUMN organization_name TEXT;
ALTER TABLE $SCHEMANAME$.plan_operator
ADD COLUMN business_id TEXT;


-- Table: $SCHEMANAME$.document

ALTER TABLE $SCHEMANAME$.document
ADD COLUMN personal_data_content TEXT NOT NULL;
ALTER TABLE $SCHEMANAME$.document
ADD COLUMN category_of_publicity TEXT NOT NULL;
ALTER TABLE $SCHEMANAME$.document
ADD COLUMN accessibility BOOLEAN;
ALTER TABLE $SCHEMANAME$.document
ADD COLUMN retention_time TEXT NOT NULL;
ALTER TABLE $SCHEMANAME$.document
ADD COLUMN confirmation_date DATE;
ALTER TABLE $SCHEMANAME$.document
ADD COLUMN file_id UUID;
ALTER TABLE $SCHEMANAME$.document
ADD COLUMN languages JSONB;
ALTER TABLE $SCHEMANAME$.document
ADD COLUMN document_specification JSONB;
ALTER TABLE $SCHEMANAME$.document
ADD COLUMN descriptor JSONB[];


-- Table: $SCHEMANAME$.plan_regulation

ALTER TABLE $SCHEMANAME$.plan_regulation
ADD COLUMN value VARCHAR(255) NOT NULL;


-- Table: $SCHEMANAME$.plan_group

ALTER TABLE $SCHEMANAME$.plan_regulation_group
ADD COLUMN letter_identifier VARCHAR(255);
ALTER TABLE $SCHEMANAME$.plan_regulation_group
ADD COLUMN color_number VARCHAR(255);

-- Table: $SCHEMANAME$.spatial_plan

ALTER TABLE $SCHEMANAME$.spatial_plan
ADD COLUMN fk_plan_decision TEXT,
ADD CONSTRAINT spatial_plan_fk_plan_decision_fkey FOREIGN KEY (fk_plan_decision)
        REFERENCES $SCHEMANAME$.plan_decision (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE RESTRICT;
