-- SCHEMANAME.code_value definition



CREATE TABLE SCHEMANAME.code_value (
	id serial4 NOT NULL,
	code_value_uuid uuid NOT NULL DEFAULT uuid_generate_v4(),
	value varchar NOT NULL,
	code_list varchar NULL,
	title jsonb NULL,
	CONSTRAINT code_value_code_value_uuid_key UNIQUE (code_value_uuid),
	CONSTRAINT code_value_pkey PRIMARY KEY (id),
	CONSTRAINT code_value_title_check CHECK (check_language_string(title))
);


-- SCHEMANAME.describing_line definition



CREATE TABLE SCHEMANAME.describing_line (
	identifier serial4 NOT NULL,
	geom public.geometry(multilinestring, PROJECTSRID) NOT NULL,
	"type" int4 NOT NULL,
	validity int4 NOT NULL DEFAULT 4,
	CONSTRAINT describing_line_pkey PRIMARY KEY (identifier)
);
CREATE INDEX sidx_describing_line_geom ON SCHEMANAME.describing_line USING gist (geom);


-- SCHEMANAME.describing_text definition



CREATE TABLE SCHEMANAME.describing_text (
	identifier serial4 NOT NULL,
	created timestamp NOT NULL DEFAULT now(),
	geom public.geometry(point, PROJECTSRID) NOT NULL,
	"text" varchar NOT NULL,
	label_x float8 NULL,
	label_y float8 NULL,
	label_rotation float8 NULL,
	callouts bool NOT NULL DEFAULT true,
	big_letters bool NULL,
	validity int4 NOT NULL DEFAULT 4,
	CONSTRAINT describing_text_pkey PRIMARY KEY (identifier),
	CONSTRAINT describing_text_validity_check CHECK ((validity <> 2))
);
CREATE INDEX sidx_describing_text_geom ON SCHEMANAME.describing_text USING gist (geom);



-- SCHEMANAME."document" definition



CREATE TABLE SCHEMANAME."document" (
	id serial4 NOT NULL,
	producer_specific_id uuid NOT NULL DEFAULT uuid_generate_v4(),
	identity_id uuid NOT NULL DEFAULT uuid_generate_v4(),
	local_id varchar NOT NULL,
	"namespace" varchar NULL,
	reference_id varchar NULL,
	latest_change timestamp NOT NULL DEFAULT now(),
	storage_time timestamp NOT NULL DEFAULT now(),
	document_identifier varchar NULL,
	"name" jsonb NULL,
	CONSTRAINT document_identity_id_key UNIQUE (identity_id),
	CONSTRAINT document_local_id_key UNIQUE (local_id),
	CONSTRAINT document_name_check CHECK (check_language_string(name)),
	CONSTRAINT document_pkey PRIMARY KEY (id),
	CONSTRAINT document_producer_specific_id_key UNIQUE (producer_specific_id)
);


-- SCHEMANAME.geometry_area_value definition



CREATE TABLE SCHEMANAME.geometry_area_value (
	id serial4 NOT NULL,
	geometry_area_value_uuid uuid NOT NULL DEFAULT uuid_generate_v4(),
	value public.geometry(multipolygon, PROJECTSRID) NOT NULL,
	obligatory bool NOT NULL,
	CONSTRAINT geometry_area_value_geometry_area_value_uuid_key UNIQUE (geometry_area_value_uuid),
	CONSTRAINT geometry_area_value_pkey PRIMARY KEY (id)
);
CREATE INDEX sidx_geometry_area_value_geom ON SCHEMANAME.geometry_area_value USING gist (value);


-- SCHEMANAME.geometry_line_value definition



CREATE TABLE SCHEMANAME.geometry_line_value (
	id serial4 NOT NULL,
	geometry_line_value_uuid uuid NOT NULL DEFAULT uuid_generate_v4(),
	value public.geometry(multilinestring, PROJECTSRID) NOT NULL,
	obligatory bool NOT NULL,
	CONSTRAINT geometry_line_value_geometry_line_value_uuid_key UNIQUE (geometry_line_value_uuid),
	CONSTRAINT geometry_line_value_pkey PRIMARY KEY (id)
);
CREATE INDEX sidx_geometry_line_value_geom ON SCHEMANAME.geometry_line_value USING gist (value);


-- SCHEMANAME.geometry_point_value definition



CREATE TABLE SCHEMANAME.geometry_point_value (
	id serial4 NOT NULL,
	geometry_point_value_uuid uuid NOT NULL DEFAULT uuid_generate_v4(),
	value public.geometry(point, PROJECTSRID) NOT NULL,
	obligatory bool NOT NULL,
	point_rotation float8 NULL,
	CONSTRAINT geometry_point_value_geometry_point_value_uuid_key UNIQUE (geometry_point_value_uuid),
	CONSTRAINT geometry_point_value_pkey PRIMARY KEY (id)
);
CREATE INDEX sidx_geometry_point_value_geom ON SCHEMANAME.geometry_point_value USING gist (value);


-- SCHEMANAME.identifier_value definition



CREATE TABLE SCHEMANAME.identifier_value (
	id serial4 NOT NULL,
	identifier_value_uuid uuid NOT NULL DEFAULT uuid_generate_v4(),
	value varchar NOT NULL,
	register_id varchar NULL,
	register_name jsonb NULL,
	CONSTRAINT identifier_value_identifier_value_uuid_key UNIQUE (identifier_value_uuid),
	CONSTRAINT identifier_value_pkey PRIMARY KEY (id),
	CONSTRAINT identifier_value_register_name_check CHECK (check_language_string(register_name))
);


-- SCHEMANAME.numeric_double_value definition



CREATE TABLE SCHEMANAME.numeric_double_value (
	id serial4 NOT NULL,
	numeric_double_value_uuid uuid NOT NULL DEFAULT uuid_generate_v4(),
	value float8 NOT NULL,
	unit_of_measure varchar NULL,
	obligatory bool NOT NULL,
	CONSTRAINT numeric_double_value_numeric_double_value_uuid_key UNIQUE (numeric_double_value_uuid),
	CONSTRAINT numeric_double_value_pkey PRIMARY KEY (id)
);


-- SCHEMANAME.numeric_range definition



CREATE TABLE SCHEMANAME.numeric_range (
	id serial4 NOT NULL,
	numeric_range_uuid uuid NOT NULL DEFAULT uuid_generate_v4(),
	minimum_value float8 NULL,
	maximum_value float8 NULL,
	unit_of_measure varchar NULL,
	CONSTRAINT numeric_range_numeric_range_uuid_key UNIQUE (numeric_range_uuid),
	CONSTRAINT numeric_range_pkey PRIMARY KEY (id),
	CONSTRAINT numeric_range_value_check CHECK ((minimum_value <= maximum_value))
);


-- SCHEMANAME.plan_regulation_group definition



CREATE TABLE SCHEMANAME.plan_regulation_group (
	id serial4 NOT NULL,
	local_id varchar NOT NULL,
	identity_id uuid NOT NULL DEFAULT uuid_generate_v4(),
	"namespace" varchar NULL,
	reference_id varchar NULL,
	latest_change timestamp NOT NULL DEFAULT now(),
	producer_specific_id uuid NULL DEFAULT uuid_generate_v4(),
	storage_time timestamp NOT NULL DEFAULT now(),
	"name" jsonb NULL,
	group_number int4 NOT NULL,
	CONSTRAINT plan_regulation_group_local_id_key UNIQUE (local_id),
	CONSTRAINT plan_regulation_group_name_check CHECK (check_language_string(name)),
	CONSTRAINT plan_regulation_group_pkey PRIMARY KEY (id)
);




-- SCHEMANAME.planning_detail_line definition



CREATE TABLE SCHEMANAME.planning_detail_line (
	identifier serial4 NOT NULL,
	producer_specific_id uuid NOT NULL DEFAULT uuid_generate_v4(),
	storage_time timestamp NOT NULL DEFAULT now(),
	geom public.geometry(multilinestring, PROJECTSRID) NOT NULL,
	"type" int4 NOT NULL,
	type_description varchar NULL,
	obligatory bool NOT NULL,
	validity int4 NOT NULL DEFAULT 4,
	identity_id uuid NOT NULL DEFAULT uuid_generate_v4(),
	local_id varchar NOT NULL,
	"namespace" varchar NULL,
	reference_id varchar NULL,
	latest_change timestamp NOT NULL DEFAULT now(),
	CONSTRAINT planning_detail_line_identity_id_key UNIQUE (identity_id),
	CONSTRAINT planning_detail_line_local_id_key UNIQUE (local_id),
	CONSTRAINT planning_detail_line_pkey PRIMARY KEY (identifier),
	CONSTRAINT planning_detail_line_planning_object_identifier_key UNIQUE (producer_specific_id)
);
CREATE INDEX sidx_planning_detail_line_geom ON SCHEMANAME.planning_detail_line USING gist (geom);



-- SCHEMANAME.regulative_text definition



CREATE TABLE SCHEMANAME.regulative_text (
	identifier serial4 NOT NULL,
	regulative_id uuid NOT NULL DEFAULT uuid_generate_v4(),
	"type" int4 NOT NULL,
	description_fi varchar NULL,
	description_se varchar NULL,
	validity int4 NOT NULL DEFAULT 1,
	CONSTRAINT regulative_text_pkey PRIMARY KEY (identifier),
	CONSTRAINT regulative_text_regulative_id_key UNIQUE (regulative_id)
);


-- SCHEMANAME.text_value definition



CREATE TABLE SCHEMANAME.text_value (
	id serial4 NOT NULL,
	text_value_uuid uuid NOT NULL DEFAULT uuid_generate_v4(),
	value jsonb NOT NULL,
	syntax varchar NULL,
	CONSTRAINT text_value_pkey PRIMARY KEY (id),
	CONSTRAINT text_value_text_value_uuid_key UNIQUE (text_value_uuid),
	CONSTRAINT text_value_value_check CHECK (check_language_string(value))
);


-- SCHEMANAME.time_instant_value definition



CREATE TABLE SCHEMANAME.time_instant_value (
	id serial4 NOT NULL,
	time_instant_uuid uuid NOT NULL DEFAULT uuid_generate_v4(),
	value timestamp NOT NULL,
	CONSTRAINT time_instant_value_pkey PRIMARY KEY (id),
	CONSTRAINT time_instant_value_time_instant_uuid_key UNIQUE (time_instant_uuid)
);


-- SCHEMANAME.time_period_value definition



CREATE TABLE SCHEMANAME.time_period_value (
	id serial4 NOT NULL,
	time_period_uuid uuid NOT NULL DEFAULT uuid_generate_v4(),
	value tsrange NOT NULL,
	time_period_from timestamp NULL,
	time_period_to timestamp NULL,
	CONSTRAINT time_period_value_pkey PRIMARY KEY (id),
	CONSTRAINT time_period_value_time_period_uuid_key UNIQUE (time_period_uuid)
);



-- SCHEMANAME.document_document definition



CREATE TABLE SCHEMANAME.document_document (
	id serial4 NOT NULL,
	referencing_document_local_id varchar NOT NULL,
	referenced_document_local_id varchar NOT NULL,
	"role" jsonb NULL,
	CONSTRAINT document_document_pkey PRIMARY KEY (id),
	CONSTRAINT document_document_role_check CHECK (check_language_string(role)),
	CONSTRAINT local_id_check CHECK (((referencing_document_local_id)::text <> (referenced_document_local_id)::text)),
	CONSTRAINT fk_referenced_document FOREIGN KEY (referenced_document_local_id)
  REFERENCES SCHEMANAME."document"(local_id)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED,
	CONSTRAINT fk_referencing_document FOREIGN KEY (referencing_document_local_id)
  REFERENCES SCHEMANAME."document"(local_id)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED
);


-- SCHEMANAME.planning_detail_line_plan_regulation_group definition



CREATE TABLE SCHEMANAME.planning_detail_line_plan_regulation_group (
	id serial4 NOT NULL,
	planning_detail_line_local_id varchar NOT NULL,
	plan_regulation_group_local_id varchar NOT NULL,
	CONSTRAINT planning_detail_line_plan_reg_planning_detail_line_local_id_key UNIQUE (planning_detail_line_local_id, plan_regulation_group_local_id),
	CONSTRAINT planning_detail_line_plan_regulation_group_pkey PRIMARY KEY (id),
	CONSTRAINT planning_detail_line_plan_regulation_group_fk_plan_regulation_g FOREIGN KEY (plan_regulation_group_local_id) REFERENCES SCHEMANAME.plan_regulation_group(local_id)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED,
	CONSTRAINT planning_detail_line_plan_regulation_group_fk_planning_detail_l FOREIGN KEY (planning_detail_line_local_id) REFERENCES SCHEMANAME.planning_detail_line(local_id)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED
);


-- SCHEMANAME.participation_and_evalution_plan definition



CREATE TABLE SCHEMANAME.participation_and_evalution_plan (
	id serial4 NOT NULL,
	producer_specific_id uuid NOT NULL DEFAULT uuid_generate_v4(),
	identity_id uuid NOT NULL DEFAULT uuid_generate_v4(),
	local_id varchar NOT NULL,
	"namespace" varchar NULL,
	reference_id varchar NULL,
	latest_change timestamp NOT NULL DEFAULT now(),
	storage_time timestamp NOT NULL DEFAULT now(),
	spatial_plan varchar NOT NULL,
	CONSTRAINT participation_and_evalution_plan_identity_id_key UNIQUE (identity_id),
	CONSTRAINT participation_and_evalution_plan_local_id_key UNIQUE (local_id),
	CONSTRAINT participation_and_evalution_plan_pkey PRIMARY KEY (id),
	CONSTRAINT participation_and_evalution_plan_producer_specific_id_key UNIQUE (producer_specific_id),
	CONSTRAINT participation_and_evalution_plan_spatial_plan_key UNIQUE (spatial_plan)
);




-- SCHEMANAME.patricipation_evalution_plan_document definition



CREATE TABLE SCHEMANAME.patricipation_evalution_plan_document (
	id serial4 NOT NULL,
	participation_and_evalution_plan_local_id varchar NOT NULL,
	document_local_id varchar NOT NULL,
	"role" jsonb NULL,
	CONSTRAINT patricipation_evalution_plan_document_pkey PRIMARY KEY (id),
	CONSTRAINT patricipation_evalution_plan_document_role_check CHECK (check_language_string(role))
);


-- SCHEMANAME.plan_guidance definition



CREATE TABLE SCHEMANAME.plan_guidance (
	id serial4 NOT NULL,
	local_id varchar NOT NULL,
	identity_id uuid NOT NULL DEFAULT uuid_generate_v4(),
	"namespace" varchar NULL,
	reference_id varchar NULL,
	latest_change timestamp NOT NULL DEFAULT now(),
	producer_specific_id uuid NULL DEFAULT uuid_generate_v4(),
	storage_time timestamp NOT NULL DEFAULT now(),
	"name" jsonb NULL,
	life_cycle_status varchar NOT NULL,
	validity_time daterange NULL,
	valid_from date NULL,
	valid_to date NULL,
	CONSTRAINT plan_guidance_local_id_key UNIQUE (local_id),
	CONSTRAINT plan_guidance_name_check CHECK (check_language_string(name)),
	CONSTRAINT plan_guidance_pkey PRIMARY KEY (id)
);


-- SCHEMANAME.plan_guidance_code_value definition



CREATE TABLE SCHEMANAME.plan_guidance_code_value (
	id serial4 NOT NULL,
	fk_plan_guidance varchar NOT NULL,
	fk_code_value uuid NOT NULL,
	CONSTRAINT plan_guidance_code_value_fk_plan_guidance_fk_code_value_key UNIQUE (fk_plan_guidance, fk_code_value),
	CONSTRAINT plan_guidance_code_value_pkey PRIMARY KEY (id)
);


-- SCHEMANAME.plan_guidance_document definition



CREATE TABLE SCHEMANAME.plan_guidance_document (
	id serial4 NOT NULL,
	plan_guidance_local_id varchar NOT NULL,
	document_local_id varchar NOT NULL,
	"role" jsonb NULL,
	CONSTRAINT plan_guidance_document_pkey PRIMARY KEY (id),
	CONSTRAINT plan_guidance_document_plan_guidance_local_id_document_loca_key UNIQUE (plan_guidance_local_id, document_local_id),
	CONSTRAINT plan_guidance_document_role_check CHECK (check_language_string(role))
);


-- SCHEMANAME.plan_guidance_geometry_area_value definition



CREATE TABLE SCHEMANAME.plan_guidance_geometry_area_value (
	id serial4 NOT NULL,
	fk_plan_guidance varchar NOT NULL,
	fk_geometry_area_value uuid NOT NULL,
	CONSTRAINT plan_guidance_geometry_area_v_fk_plan_guidance_fk_geometry__key UNIQUE (fk_plan_guidance, fk_geometry_area_value),
	CONSTRAINT plan_guidance_geometry_area_value_pkey PRIMARY KEY (id)
);


-- SCHEMANAME.plan_guidance_geometry_line_value definition



CREATE TABLE SCHEMANAME.plan_guidance_geometry_line_value (
	id serial4 NOT NULL,
	fk_plan_guidance varchar NOT NULL,
	fk_geometry_line_value uuid NOT NULL,
	CONSTRAINT plan_guidance_geometry_line_v_fk_plan_guidance_fk_geometry__key UNIQUE (fk_plan_guidance, fk_geometry_line_value),
	CONSTRAINT plan_guidance_geometry_line_value_pkey PRIMARY KEY (id)
);


-- SCHEMANAME.plan_guidance_geometry_point_value definition



CREATE TABLE SCHEMANAME.plan_guidance_geometry_point_value (
	id serial4 NOT NULL,
	fk_plan_guidance varchar NOT NULL,
	fk_geometry_point_value uuid NOT NULL,
	CONSTRAINT plan_guidance_geometry_point__fk_plan_guidance_fk_geometry__key UNIQUE (fk_plan_guidance, fk_geometry_point_value),
	CONSTRAINT plan_guidance_geometry_point_value_pkey PRIMARY KEY (id)
);


-- SCHEMANAME.plan_guidance_identifier_value definition



CREATE TABLE SCHEMANAME.plan_guidance_identifier_value (
	id serial4 NOT NULL,
	fk_plan_guidance varchar NOT NULL,
	fk_identifier_value uuid NOT NULL,
	CONSTRAINT plan_guidance_identifier_valu_fk_plan_guidance_fk_identifie_key UNIQUE (fk_plan_guidance, fk_identifier_value),
	CONSTRAINT plan_guidance_identifier_value_pkey PRIMARY KEY (id)
);


-- SCHEMANAME.plan_guidance_numeric_double_value definition



CREATE TABLE SCHEMANAME.plan_guidance_numeric_double_value (
	id serial4 NOT NULL,
	fk_plan_guidance varchar NOT NULL,
	fk_numeric_double_value uuid NOT NULL,
	CONSTRAINT plan_guidance_numeric_double__fk_plan_guidance_fk_numeric_d_key UNIQUE (fk_plan_guidance, fk_numeric_double_value),
	CONSTRAINT plan_guidance_numeric_double_value_pkey PRIMARY KEY (id)
);


-- SCHEMANAME.plan_guidance_numeric_range definition



CREATE TABLE SCHEMANAME.plan_guidance_numeric_range (
	id serial4 NOT NULL,
	fk_plan_guidance varchar NOT NULL,
	fk_numeric_range uuid NOT NULL,
	CONSTRAINT plan_guidance_numeric_range_fk_plan_guidance_fk_numeric_ran_key UNIQUE (fk_plan_guidance, fk_numeric_range),
	CONSTRAINT plan_guidance_numeric_range_pkey PRIMARY KEY (id)
);


-- SCHEMANAME.plan_guidance_text_value definition



CREATE TABLE SCHEMANAME.plan_guidance_text_value (
	id serial4 NOT NULL,
	fk_plan_guidance varchar NOT NULL,
	fk_text_value uuid NOT NULL,
	CONSTRAINT plan_guidance_text_value_fk_plan_guidance_fk_text_value_key UNIQUE (fk_plan_guidance, fk_text_value),
	CONSTRAINT plan_guidance_text_value_pkey PRIMARY KEY (id)
);


-- SCHEMANAME.plan_guidance_theme definition



CREATE TABLE SCHEMANAME.plan_guidance_theme (
	id serial4 NOT NULL,
	plan_guidance_local_id varchar NOT NULL,
	theme_code varchar NOT NULL,
	CONSTRAINT plan_guidance_theme_pkey PRIMARY KEY (id),
	CONSTRAINT plan_guidance_theme_plan_guidance_local_id_theme_code_key UNIQUE (plan_guidance_local_id, theme_code)
);


-- SCHEMANAME.plan_guidance_time_instant_value definition



CREATE TABLE SCHEMANAME.plan_guidance_time_instant_value (
	id serial4 NOT NULL,
	fk_plan_guidance varchar NOT NULL,
	fk_time_instant_value uuid NOT NULL,
	CONSTRAINT plan_guidance_time_instant_va_fk_plan_guidance_fk_time_inst_key UNIQUE (fk_plan_guidance, fk_time_instant_value),
	CONSTRAINT plan_guidance_time_instant_value_pkey PRIMARY KEY (id)
);


-- SCHEMANAME.plan_guidance_time_period_value definition



CREATE TABLE SCHEMANAME.plan_guidance_time_period_value (
	id serial4 NOT NULL,
	fk_plan_guidance varchar NOT NULL,
	fk_time_period_value uuid NOT NULL,
	CONSTRAINT plan_guidance_time_period_val_fk_plan_guidance_fk_time_peri_key UNIQUE (fk_plan_guidance, fk_time_period_value),
	CONSTRAINT plan_guidance_time_period_value_pkey PRIMARY KEY (id)
);


-- SCHEMANAME.plan_regulation definition



CREATE TABLE SCHEMANAME.plan_regulation (
	id serial4 NOT NULL,
	local_id varchar NOT NULL,
	identity_id uuid NOT NULL DEFAULT uuid_generate_v4(),
	"namespace" varchar NULL,
	reference_id varchar NULL,
	latest_change timestamp NOT NULL DEFAULT now(),
	producer_specific_id uuid NULL DEFAULT uuid_generate_v4(),
	storage_time timestamp NOT NULL DEFAULT now(),
	"name" jsonb NULL,
	"type" varchar NOT NULL,
	life_cycle_status varchar NOT NULL,
	validity_time daterange NULL,
	valid_from date NULL,
	valid_to date NULL,
	CONSTRAINT plan_regulation_local_id_key UNIQUE (local_id),
	CONSTRAINT plan_regulation_name_check CHECK (check_language_string(name)),
	CONSTRAINT plan_regulation_pkey PRIMARY KEY (id)
);




-- SCHEMANAME.plan_regulation_code_value definition



CREATE TABLE SCHEMANAME.plan_regulation_code_value (
	id serial4 NOT NULL,
	fk_plan_regulation varchar NOT NULL,
	fk_code_value uuid NOT NULL,
	CONSTRAINT plan_regulation_code_value_fk_plan_regulation_fk_code_value_key UNIQUE (fk_plan_regulation, fk_code_value),
	CONSTRAINT plan_regulation_code_value_pkey PRIMARY KEY (id)
);


-- SCHEMANAME.plan_regulation_document definition



CREATE TABLE SCHEMANAME.plan_regulation_document (
	id serial4 NOT NULL,
	plan_regulation_local_id varchar NOT NULL,
	document_local_id varchar NOT NULL,
	"role" jsonb NULL,
	CONSTRAINT plan_regulation_document_pkey PRIMARY KEY (id),
	CONSTRAINT plan_regulation_document_plan_regulation_local_id_document__key UNIQUE (plan_regulation_local_id, document_local_id),
	CONSTRAINT plan_regulation_document_role_check CHECK (check_language_string(role))
);


-- SCHEMANAME.plan_regulation_geometry_area_value definition



CREATE TABLE SCHEMANAME.plan_regulation_geometry_area_value (
	id serial4 NOT NULL,
	fk_plan_regulation varchar NOT NULL,
	fk_geometry_area_value uuid NOT NULL,
	CONSTRAINT plan_regulation_geometry_area_fk_plan_regulation_fk_geometr_key UNIQUE (fk_plan_regulation, fk_geometry_area_value),
	CONSTRAINT plan_regulation_geometry_area_value_pkey PRIMARY KEY (id)
);


-- SCHEMANAME.plan_regulation_geometry_line_value definition



CREATE TABLE SCHEMANAME.plan_regulation_geometry_line_value (
	id serial4 NOT NULL,
	fk_plan_regulation varchar NOT NULL,
	fk_geometry_line_value uuid NOT NULL,
	CONSTRAINT plan_regulation_geometry_line_fk_plan_regulation_fk_geometr_key UNIQUE (fk_plan_regulation, fk_geometry_line_value),
	CONSTRAINT plan_regulation_geometry_line_value_pkey PRIMARY KEY (id)
);


-- SCHEMANAME.plan_regulation_geometry_point_value definition



CREATE TABLE SCHEMANAME.plan_regulation_geometry_point_value (
	id serial4 NOT NULL,
	fk_plan_regulation varchar NOT NULL,
	fk_geometry_point_value uuid NOT NULL,
	CONSTRAINT plan_regulation_geometry_poin_fk_plan_regulation_fk_geometr_key UNIQUE (fk_plan_regulation, fk_geometry_point_value),
	CONSTRAINT plan_regulation_geometry_point_value_pkey PRIMARY KEY (id)
);


-- SCHEMANAME.plan_regulation_group_regulation definition



CREATE TABLE SCHEMANAME.plan_regulation_group_regulation (
	id serial4 NOT NULL,
	plan_regulation_group_local_id varchar NOT NULL,
	plan_regulation_local_id varchar NOT NULL,
	CONSTRAINT plan_regulation_group_regulat_plan_regulation_group_local_i_key UNIQUE (plan_regulation_group_local_id, plan_regulation_local_id),
	CONSTRAINT plan_regulation_group_regulation_pkey PRIMARY KEY (id)
);


-- SCHEMANAME.plan_regulation_identifier_value definition



CREATE TABLE SCHEMANAME.plan_regulation_identifier_value (
	id serial4 NOT NULL,
	fk_plan_regulation varchar NOT NULL,
	fk_identifier_value uuid NOT NULL,
	CONSTRAINT plan_regulation_identifier_va_fk_plan_regulation_fk_identif_key UNIQUE (fk_plan_regulation, fk_identifier_value),
	CONSTRAINT plan_regulation_identifier_value_pkey PRIMARY KEY (id)
);


-- SCHEMANAME.plan_regulation_numeric_double_value definition



CREATE TABLE SCHEMANAME.plan_regulation_numeric_double_value (
	id serial4 NOT NULL,
	fk_plan_regulation varchar NOT NULL,
	fk_numeric_double_value uuid NOT NULL,
	CONSTRAINT plan_regulation_numeric_doubl_fk_plan_regulation_fk_numeric_key UNIQUE (fk_plan_regulation, fk_numeric_double_value),
	CONSTRAINT plan_regulation_numeric_double_value_pkey PRIMARY KEY (id)
);


-- SCHEMANAME.plan_regulation_numeric_range definition



CREATE TABLE SCHEMANAME.plan_regulation_numeric_range (
	id serial4 NOT NULL,
	fk_plan_regulation varchar NOT NULL,
	fk_numeric_range uuid NOT NULL,
	CONSTRAINT plan_regulation_numeric_range_fk_plan_regulation_fk_numeric_key UNIQUE (fk_plan_regulation, fk_numeric_range),
	CONSTRAINT plan_regulation_numeric_range_pkey PRIMARY KEY (id)
);


-- SCHEMANAME.plan_regulation_supplementary_information definition



CREATE TABLE SCHEMANAME.plan_regulation_supplementary_information (
	id serial4 NOT NULL,
	fk_plan_regulation varchar NOT NULL,
	fk_supplementary_information uuid NOT NULL,
	CONSTRAINT plan_regulation_supplementary_fk_plan_regulation_fk_supplem_key UNIQUE (fk_plan_regulation, fk_supplementary_information),
	CONSTRAINT plan_regulation_supplementary_information_pkey PRIMARY KEY (id)
);


-- SCHEMANAME.plan_regulation_text_value definition



CREATE TABLE SCHEMANAME.plan_regulation_text_value (
	id serial4 NOT NULL,
	fk_plan_regulation varchar NOT NULL,
	fk_text_value uuid NOT NULL,
	CONSTRAINT plan_regulation_text_value_fk_plan_regulation_fk_text_value_key UNIQUE (fk_plan_regulation, fk_text_value),
	CONSTRAINT plan_regulation_text_value_pkey PRIMARY KEY (id)
);


-- SCHEMANAME.plan_regulation_theme definition



CREATE TABLE SCHEMANAME.plan_regulation_theme (
	id serial4 NOT NULL,
	plan_regulation_local_id varchar NOT NULL,
	theme_code varchar NOT NULL,
	CONSTRAINT plan_regulation_theme_pkey PRIMARY KEY (id),
	CONSTRAINT plan_regulation_theme_plan_regulation_local_id_theme_code_key UNIQUE (plan_regulation_local_id, theme_code)
);


-- SCHEMANAME.plan_regulation_time_instant_value definition



CREATE TABLE SCHEMANAME.plan_regulation_time_instant_value (
	id serial4 NOT NULL,
	fk_plan_regulation varchar NOT NULL,
	fk_time_instant_value uuid NOT NULL,
	CONSTRAINT plan_regulation_time_instant__fk_plan_regulation_fk_time_in_key UNIQUE (fk_plan_regulation, fk_time_instant_value),
	CONSTRAINT plan_regulation_time_instant_value_pkey PRIMARY KEY (id)
);


-- SCHEMANAME.plan_regulation_time_period_value definition



CREATE TABLE SCHEMANAME.plan_regulation_time_period_value (
	id serial4 NOT NULL,
	fk_plan_regulation varchar NOT NULL,
	fk_time_period_value uuid NOT NULL,
	CONSTRAINT plan_regulation_time_period_v_fk_plan_regulation_fk_time_pe_key UNIQUE (fk_plan_regulation, fk_time_period_value),
	CONSTRAINT plan_regulation_time_period_value_pkey PRIMARY KEY (id)
);


-- SCHEMANAME.planned_space definition



CREATE TABLE SCHEMANAME.planned_space (
	identifier serial4 NOT NULL,
	producer_specific_id uuid NOT NULL DEFAULT uuid_generate_v4(),
	geom public.geometry(multipolygon, PROJECTSRID) NOT NULL,
	storage_time timestamp NOT NULL DEFAULT now(),
	"type" int4 NOT NULL,
	validity int4 NOT NULL DEFAULT 4,
	valid_from date NULL,
	valid_to date NULL,
	bindingness_of_location varchar(3) NOT NULL,
	ground_relative_position varchar(3) NOT NULL,
	identity_id uuid NOT NULL DEFAULT uuid_generate_v4(),
	local_id varchar NOT NULL,
	"namespace" varchar NULL,
	reference_id varchar NULL,
	latest_change timestamp NOT NULL DEFAULT now(),
	validity_time daterange NULL,
	CONSTRAINT planned_space_date_check CHECK (
CASE
    WHEN ((valid_from IS NOT NULL) AND (valid_to IS NULL)) THEN true
    WHEN ((valid_from IS NOT NULL) AND (valid_to > valid_from)) THEN true
    WHEN ((valid_from IS NULL) AND (valid_to IS NULL)) THEN true
    ELSE false
END),
	CONSTRAINT planned_space_identity_id_key UNIQUE (identity_id),
	CONSTRAINT planned_space_local_id_key UNIQUE (local_id),
	CONSTRAINT planned_space_pkey PRIMARY KEY (identifier),
	CONSTRAINT planned_space_planning_object_identifier_key UNIQUE (producer_specific_id)
);
CREATE INDEX sidx_planned_space_geom ON SCHEMANAME.planned_space USING gist (geom);



-- SCHEMANAME.planned_space_plan_detail_line definition



CREATE TABLE SCHEMANAME.planned_space_plan_detail_line (
	identifier int4 NOT NULL GENERATED ALWAYS AS IDENTITY,
	planned_space_local_id varchar NOT NULL,
	planning_detail_line_local_id varchar NOT NULL,
	CONSTRAINT planned_space_detail_line_pkey PRIMARY KEY (identifier)
);


-- SCHEMANAME.planned_space_plan_guidance definition



CREATE TABLE SCHEMANAME.planned_space_plan_guidance (
	id serial4 NOT NULL,
	planned_space_local_id varchar NOT NULL,
	plan_guidance_local_id varchar NOT NULL,
	CONSTRAINT planned_space_plan_guidance_pkey PRIMARY KEY (id),
	CONSTRAINT planned_space_plan_guidance_planned_space_local_id_plan_gui_key UNIQUE (planned_space_local_id, plan_guidance_local_id)
);


-- SCHEMANAME.planned_space_plan_regulation definition



CREATE TABLE SCHEMANAME.planned_space_plan_regulation (
	id serial4 NOT NULL,
	planned_space_local_id varchar NOT NULL,
	plan_regulation_local_id varchar NOT NULL,
	CONSTRAINT planned_space_plan_regulation_pkey PRIMARY KEY (id),
	CONSTRAINT planned_space_plan_regulation_planned_space_local_id_plan__key1 UNIQUE (planned_space_local_id, plan_regulation_local_id)
);


-- SCHEMANAME.planned_space_plan_regulation_group definition



CREATE TABLE SCHEMANAME.planned_space_plan_regulation_group (
	id serial4 NOT NULL,
	planned_space_local_id varchar NOT NULL,
	plan_regulation_group_local_id varchar NOT NULL,
	CONSTRAINT planned_space_plan_regulation_group_pkey PRIMARY KEY (id),
	CONSTRAINT planned_space_plan_regulation_planned_space_local_id_plan_r_key UNIQUE (planned_space_local_id, plan_regulation_group_local_id)
);


-- SCHEMANAME.planner definition



CREATE TABLE SCHEMANAME.planner (
	identifier serial4 NOT NULL,
	"name" varchar NOT NULL,
	fk_spatial_plan uuid NOT NULL,
	professional_title jsonb NULL,
	"role" jsonb NULL,
	CONSTRAINT contact_name_check CHECK (((name)::text <> ''::text)),
	CONSTRAINT contact_pkey PRIMARY KEY (identifier),
	CONSTRAINT planner_professional_title_check CHECK (check_language_string(professional_title)),
	CONSTRAINT planner_role_check CHECK (check_language_string(role))
);


-- SCHEMANAME.planning_detail_line_plan_guidance definition



CREATE TABLE SCHEMANAME.planning_detail_line_plan_guidance (
	id serial4 NOT NULL,
	planning_detail_line_local_id varchar NOT NULL,
	plan_guidance_local_id varchar NOT NULL,
	CONSTRAINT planning_detail_line_plan_gui_planning_detail_line_local_id_key UNIQUE (planning_detail_line_local_id, plan_guidance_local_id),
	CONSTRAINT planning_detail_line_plan_guidance_pkey PRIMARY KEY (id)
);


-- SCHEMANAME.planning_detail_line_plan_regulation definition



CREATE TABLE SCHEMANAME.planning_detail_line_plan_regulation (
	id serial4 NOT NULL,
	planning_detail_line_local_id varchar NOT NULL,
	plan_regulation_local_id varchar NOT NULL,
	CONSTRAINT planning_detail_line_plan_reg_planning_detail_line_local_i_key1 UNIQUE (planning_detail_line_local_id, plan_regulation_local_id),
	CONSTRAINT planning_detail_line_plan_regulation_pkey PRIMARY KEY (id)
);


-- SCHEMANAME.spatial_plan definition



CREATE TABLE SCHEMANAME.spatial_plan (
	identifier serial4 NOT NULL,
	producer_specific_id uuid NOT NULL DEFAULT uuid_generate_v4(),
	geom public.geometry(multipolygon, PROJECTSRID) NOT NULL,
	storage_time timestamp NOT NULL DEFAULT now(),
	plan_id varchar NULL,
	approval_time date NULL,
	approved_by int4 NULL,
	epsg bpchar(9) NOT NULL DEFAULT 'EPSG:PROJECTSRID'::bpchar,
	vertical_coordinate_system int4 NULL,
	land_administration_authority bpchar(3) NOT NULL DEFAULT 'MUNICIPALITYCODE'::bpchar,
	"language" int4 NOT NULL,
	valid_from date NULL,
	valid_to date NULL,
	validity int4 NOT NULL DEFAULT 4,
	is_released bool NOT NULL DEFAULT false,
	"type" varchar(3) NOT NULL,
	digital_origin varchar(3) NOT NULL,
	ground_relative_position varchar(3) NOT NULL,
	legal_effectiveness varchar(2) NOT NULL DEFAULT '01'::character varying,
	validity_time daterange NULL,
	lifecycle_status varchar(3) NOT NULL,
	"name" jsonb NOT NULL,
	identity_id uuid NOT NULL DEFAULT uuid_generate_v4(),
	local_id varchar NOT NULL,
	"namespace" varchar NULL,
	reference_id varchar NULL,
	latest_change timestamp NOT NULL DEFAULT now(),
	initiation_time date NULL,
	CONSTRAINT date_check CHECK (
CASE
    WHEN ((approval_time IS NULL) AND (valid_from IS NULL) AND (valid_to IS NULL)) THEN true
    WHEN ((approval_time IS NOT NULL) AND (valid_from IS NULL) AND (valid_to IS NULL)) THEN true
    WHEN ((approval_time <= valid_from) AND (valid_to IS NULL)) THEN true
    WHEN ((approval_time <= valid_from) AND (valid_from < valid_to)) THEN true
    ELSE false
END),
	CONSTRAINT epsg_check CHECK ((epsg ~ '^EPSG:PROJECTSRID$'::text)),
	CONSTRAINT land_administration_authority_check CHECK ((land_administration_authority ~ '^[0-9]{3}$'::text)),
	CONSTRAINT spatial_plan_approval_check CHECK (
CASE
    WHEN ((approval_time IS NULL) AND (approved_by IS NOT NULL)) THEN false
    WHEN ((approval_time IS NOT NULL) AND (approved_by IS NULL)) THEN false
    ELSE true
END),
	CONSTRAINT spatial_plan_identity_id_key UNIQUE (identity_id),
	CONSTRAINT spatial_plan_local_id_key UNIQUE (local_id),
	CONSTRAINT spatial_plan_name_check CHECK (check_language_string(name)),
	CONSTRAINT spatial_plan_pkey PRIMARY KEY (identifier),
	CONSTRAINT spatial_plan_planning_object_identifier_key UNIQUE (producer_specific_id)
);
CREATE INDEX sidx_spatial_plan_geom ON SCHEMANAME.spatial_plan USING gist (geom);




-- SCHEMANAME.spatial_plan_commentary definition



CREATE TABLE SCHEMANAME.spatial_plan_commentary (
	id serial4 NOT NULL,
	producer_specific_id uuid NOT NULL DEFAULT uuid_generate_v4(),
	identity_id uuid NOT NULL DEFAULT uuid_generate_v4(),
	local_id varchar NOT NULL,
	"namespace" varchar NULL,
	reference_id varchar NULL,
	latest_change timestamp NOT NULL DEFAULT now(),
	storage_time timestamp NOT NULL DEFAULT now(),
	spatial_plan varchar NOT NULL,
	CONSTRAINT spatial_plan_commentary_identity_id_key UNIQUE (identity_id),
	CONSTRAINT spatial_plan_commentary_local_id_key UNIQUE (local_id),
	CONSTRAINT spatial_plan_commentary_pkey PRIMARY KEY (id),
	CONSTRAINT spatial_plan_commentary_producer_specific_id_key UNIQUE (producer_specific_id),
	CONSTRAINT spatial_plan_commentary_spatial_plan_key UNIQUE (spatial_plan)
);




-- SCHEMANAME.spatial_plan_commentary_document definition



CREATE TABLE SCHEMANAME.spatial_plan_commentary_document (
	id serial4 NOT NULL,
	spatial_plan_commentary_local_id varchar NOT NULL,
	document_local_id varchar NOT NULL,
	"role" jsonb NULL,
	CONSTRAINT spatial_plan_commentary_document_pkey PRIMARY KEY (id),
	CONSTRAINT spatial_plan_commentary_document_role_check CHECK (check_language_string(role))
);


-- SCHEMANAME.spatial_plan_plan_guidance definition



CREATE TABLE SCHEMANAME.spatial_plan_plan_guidance (
	id serial4 NOT NULL,
	spatial_plan_local_id varchar NOT NULL,
	plan_guidance_local_id varchar NOT NULL,
	CONSTRAINT spatial_plan_plan_guidance_pkey PRIMARY KEY (id),
	CONSTRAINT spatial_plan_plan_guidance_spatial_plan_local_id_plan_guida_key UNIQUE (spatial_plan_local_id, plan_guidance_local_id)
);


-- SCHEMANAME.spatial_plan_plan_regulation definition



CREATE TABLE SCHEMANAME.spatial_plan_plan_regulation (
	id serial4 NOT NULL,
	spatial_plan_local_id varchar NOT NULL,
	plan_regulation_local_id varchar NOT NULL,
	CONSTRAINT spatial_plan_plan_regulation_pkey PRIMARY KEY (id),
	CONSTRAINT spatial_plan_plan_regulation_spatial_plan_local_id_plan_reg_key UNIQUE (spatial_plan_local_id, plan_regulation_local_id)
);


-- SCHEMANAME.supplementary_information definition



CREATE TABLE SCHEMANAME.supplementary_information (
	id serial4 NOT NULL,
	producer_specific_id uuid NULL DEFAULT uuid_generate_v4(),
	"type" varchar NOT NULL,
	"name" jsonb NULL,
	fk_plan_regulation varchar NOT NULL,
	CONSTRAINT supplementary_information_name_check CHECK (check_language_string(name)),
	CONSTRAINT supplementary_information_pkey PRIMARY KEY (id),
	CONSTRAINT supplementary_information_producer_specific_id_key UNIQUE (producer_specific_id)
);


-- SCHEMANAME.supplementary_information_code_value definition



CREATE TABLE SCHEMANAME.supplementary_information_code_value (
	id serial4 NOT NULL,
	fk_supplementary_information uuid NOT NULL,
	fk_code_value uuid NOT NULL,
	CONSTRAINT supplementary_information_cod_fk_supplementary_information__key UNIQUE (fk_supplementary_information, fk_code_value),
	CONSTRAINT supplementary_information_code_value_pkey PRIMARY KEY (id)
);


-- SCHEMANAME.supplementary_information_geometry_area_value definition



CREATE TABLE SCHEMANAME.supplementary_information_geometry_area_value (
	id serial4 NOT NULL,
	fk_supplementary_information uuid NOT NULL,
	fk_geometry_area_value uuid NOT NULL,
	CONSTRAINT supplementary_information_geo_fk_supplementary_information_key2 UNIQUE (fk_supplementary_information, fk_geometry_area_value),
	CONSTRAINT supplementary_information_geometry_area_value_pkey PRIMARY KEY (id)
);


-- SCHEMANAME.supplementary_information_geometry_line_value definition



CREATE TABLE SCHEMANAME.supplementary_information_geometry_line_value (
	id serial4 NOT NULL,
	fk_supplementary_information uuid NOT NULL,
	fk_geometry_line_value uuid NOT NULL,
	CONSTRAINT supplementary_information_geo_fk_supplementary_information_key1 UNIQUE (fk_supplementary_information, fk_geometry_line_value),
	CONSTRAINT supplementary_information_geometry_line_value_pkey PRIMARY KEY (id)
);


-- SCHEMANAME.supplementary_information_geometry_point_value definition



CREATE TABLE SCHEMANAME.supplementary_information_geometry_point_value (
	id serial4 NOT NULL,
	fk_supplementary_information uuid NOT NULL,
	fk_geometry_point_value uuid NOT NULL,
	CONSTRAINT supplementary_information_geo_fk_supplementary_information__key UNIQUE (fk_supplementary_information, fk_geometry_point_value),
	CONSTRAINT supplementary_information_geometry_point_value_pkey PRIMARY KEY (id)
);


-- SCHEMANAME.supplementary_information_identifier_value definition



CREATE TABLE SCHEMANAME.supplementary_information_identifier_value (
	id serial4 NOT NULL,
	fk_supplementary_information uuid NOT NULL,
	fk_identifier_value uuid NOT NULL,
	CONSTRAINT supplementary_information_ide_fk_supplementary_information__key UNIQUE (fk_supplementary_information, fk_identifier_value),
	CONSTRAINT supplementary_information_identifier_value_pkey PRIMARY KEY (id)
);


-- SCHEMANAME.supplementary_information_numeric_double_value definition



CREATE TABLE SCHEMANAME.supplementary_information_numeric_double_value (
	id serial4 NOT NULL,
	fk_supplementary_information uuid NOT NULL,
	fk_numeric_double_value uuid NOT NULL,
	CONSTRAINT supplementary_information_num_fk_supplementary_information__key UNIQUE (fk_supplementary_information, fk_numeric_double_value),
	CONSTRAINT supplementary_information_numeric_double_value_pkey PRIMARY KEY (id)
);


-- SCHEMANAME.supplementary_information_numeric_range definition



CREATE TABLE SCHEMANAME.supplementary_information_numeric_range (
	id serial4 NOT NULL,
	fk_supplementary_information uuid NOT NULL,
	fk_numeric_range uuid NOT NULL,
	CONSTRAINT supplementary_information_num_fk_supplementary_information_key1 UNIQUE (fk_supplementary_information, fk_numeric_range),
	CONSTRAINT supplementary_information_numeric_range_pkey PRIMARY KEY (id)
);


-- SCHEMANAME.supplementary_information_text_value definition



CREATE TABLE SCHEMANAME.supplementary_information_text_value (
	id serial4 NOT NULL,
	fk_supplementary_information uuid NOT NULL,
	fk_text_value uuid NOT NULL,
	CONSTRAINT supplementary_information_tex_fk_supplementary_information__key UNIQUE (fk_supplementary_information, fk_text_value),
	CONSTRAINT supplementary_information_text_value_pkey PRIMARY KEY (id)
);


-- SCHEMANAME.supplementary_information_time_instant_value definition



CREATE TABLE SCHEMANAME.supplementary_information_time_instant_value (
	id serial4 NOT NULL,
	fk_supplementary_information uuid NOT NULL,
	fk_time_instant_value uuid NOT NULL,
	CONSTRAINT supplementary_information_tim_fk_supplementary_information__key UNIQUE (fk_supplementary_information, fk_time_instant_value),
	CONSTRAINT supplementary_information_time_instant_value_pkey PRIMARY KEY (id)
);


-- SCHEMANAME.supplementary_information_time_period_value definition



CREATE TABLE SCHEMANAME.supplementary_information_time_period_value (
	id serial4 NOT NULL,
	fk_supplementary_information uuid NOT NULL,
	fk_time_period_value uuid NOT NULL,
	CONSTRAINT supplementary_information_tim_fk_supplementary_information_key1 UNIQUE (fk_supplementary_information, fk_time_period_value),
	CONSTRAINT supplementary_information_time_period_value_pkey PRIMARY KEY (id)
);


-- SCHEMANAME.zoning_element definition



CREATE TABLE SCHEMANAME.zoning_element (
	identifier serial4 NOT NULL,
	producer_specific_id uuid NOT NULL DEFAULT uuid_generate_v4(),
	geom public.geometry(multipolygon, PROJECTSRID) NOT NULL,
	storage_time timestamp NOT NULL DEFAULT now(),
	localized_name varchar NOT NULL,
	"name" varchar NULL,
	"type" int4 NOT NULL,
	up_to_dateness int4 NOT NULL,
	valid_from date NULL,
	valid_to date NULL,
	block_number varchar NULL,
	parcel_number varchar NULL,
	validity int4 NOT NULL DEFAULT 4,
	bindingness_of_location varchar(3) NOT NULL DEFAULT '01'::character varying,
	ground_relative_position varchar(3) NOT NULL,
	land_use_kind varchar(6) NOT NULL,
	identity_id uuid NOT NULL DEFAULT uuid_generate_v4(),
	local_id varchar NOT NULL,
	"namespace" varchar NULL,
	reference_id varchar NULL,
	latest_change timestamp NOT NULL DEFAULT now(),
	spatial_plan varchar NULL,
	validity_time daterange NULL,
	CONSTRAINT validate_validity_dates CHECK (SCHEMANAME.validate_zoning_element_validity_dates(valid_from, valid_to, spatial_plan)),
	CONSTRAINT zoning_date_check CHECK (
CASE
    WHEN ((valid_from IS NOT NULL) AND (valid_to IS NULL)) THEN true
    WHEN ((valid_from IS NOT NULL) AND (valid_to > valid_from)) THEN true
    WHEN ((valid_from IS NULL) AND (valid_to IS NULL)) THEN true
    ELSE false
END),
	CONSTRAINT zoning_element_identity_id_key UNIQUE (identity_id),
	CONSTRAINT zoning_element_land_use_kind_check CHECK (((land_use_kind)::text ~~ '01%'::text)),
	CONSTRAINT zoning_element_local_id_key UNIQUE (local_id),
	CONSTRAINT zoning_element_pkey PRIMARY KEY (identifier),
	CONSTRAINT zoning_element_planning_object_identifier_key UNIQUE (producer_specific_id)
);
CREATE INDEX sidx_zoning_element_geom ON SCHEMANAME.zoning_element USING gist (geom);


-- SCHEMANAME.zoning_element_describing_line definition



CREATE TABLE SCHEMANAME.zoning_element_describing_line (
	identifier int4 NOT NULL GENERATED ALWAYS AS IDENTITY,
	describing_line_id int4 NOT NULL,
	zoning_element_local_id varchar NULL,
	CONSTRAINT zoning_element_describing_line_pkey PRIMARY KEY (identifier)
);


-- SCHEMANAME.zoning_element_describing_text definition



CREATE TABLE SCHEMANAME.zoning_element_describing_text (
	identifier int4 NOT NULL GENERATED ALWAYS AS IDENTITY,
	describing_text_id int4 NOT NULL,
	zoning_element_local_id varchar NULL,
	CONSTRAINT zoning_element_describing_text_pkey PRIMARY KEY (identifier)
);


-- SCHEMANAME.zoning_element_plan_detail_line definition



CREATE TABLE SCHEMANAME.zoning_element_plan_detail_line (
	identifier int4 NOT NULL GENERATED ALWAYS AS IDENTITY,
	zoning_element_local_id varchar NOT NULL,
	planning_detail_line_local_id varchar NOT NULL,
	CONSTRAINT zoning_element_plan_detail_line_pkey PRIMARY KEY (identifier)
);


-- SCHEMANAME.zoning_element_plan_guidance definition



CREATE TABLE SCHEMANAME.zoning_element_plan_guidance (
	id serial4 NOT NULL,
	zoning_element_local_id varchar NOT NULL,
	plan_guidance_local_id varchar NOT NULL,
	CONSTRAINT zoning_element_plan_guidance_pkey PRIMARY KEY (id),
	CONSTRAINT zoning_element_plan_guidance_zoning_element_local_id_plan_g_key UNIQUE (zoning_element_local_id, plan_guidance_local_id)
);


-- SCHEMANAME.zoning_element_plan_regulation definition



CREATE TABLE SCHEMANAME.zoning_element_plan_regulation (
	id serial4 NOT NULL,
	zoning_element_local_id varchar NOT NULL,
	plan_regulation_local_id varchar NOT NULL,
	CONSTRAINT zoning_element_plan_regulatio_zoning_element_local_id_plan_key1 UNIQUE (zoning_element_local_id, plan_regulation_local_id),
	CONSTRAINT zoning_element_plan_regulation_pkey PRIMARY KEY (id)
);


-- SCHEMANAME.zoning_element_plan_regulation_group definition



CREATE TABLE SCHEMANAME.zoning_element_plan_regulation_group (
	id serial4 NOT NULL,
	zoning_element_local_id varchar NOT NULL,
	plan_regulation_group_local_id varchar NOT NULL,
	CONSTRAINT zoning_element_plan_regulatio_zoning_element_local_id_plan__key UNIQUE (zoning_element_local_id, plan_regulation_group_local_id),
	CONSTRAINT zoning_element_plan_regulation_group_pkey PRIMARY KEY (id)
);


-- SCHEMANAME.zoning_element_planned_space definition



CREATE TABLE SCHEMANAME.zoning_element_planned_space (
	identifier int4 NOT NULL GENERATED ALWAYS AS IDENTITY,
	zoning_element_local_id varchar NOT NULL,
	planned_space_local_id varchar NOT NULL,
	CONSTRAINT zoning_element_planned_space_pkey PRIMARY KEY (identifier)
);


-- SCHEMANAME.participation_and_evalution_plan foreign keys

ALTER TABLE SCHEMANAME.participation_and_evalution_plan
  ADD CONSTRAINT participation_and_evalution_plan_fk_spatial_plan
  FOREIGN KEY (spatial_plan)
  REFERENCES SCHEMANAME.spatial_plan(local_id)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;


-- SCHEMANAME.patricipation_evalution_plan_document foreign keys

ALTER TABLE SCHEMANAME.patricipation_evalution_plan_document
  ADD CONSTRAINT patricipation_evalution_plan_document_fk_document
  FOREIGN KEY (document_local_id)
  REFERENCES SCHEMANAME."document"(local_id)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE SCHEMANAME.patricipation_evalution_plan_document
  ADD CONSTRAINT patricipation_evalution_plan_document_fk_participation_and_eval
  FOREIGN KEY (participation_and_evalution_plan_local_id)
  REFERENCES SCHEMANAME.participation_and_evalution_plan(local_id)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;


-- SCHEMANAME.plan_guidance foreign keys

ALTER TABLE SCHEMANAME.plan_guidance
  ADD CONSTRAINT plan_guidance_fk_life_cycle_status
  FOREIGN KEY (life_cycle_status)
  REFERENCES code_lists.spatial_plan_lifecycle_status(codevalue)
  ON DELETE RESTRICT
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;


-- SCHEMANAME.plan_guidance_code_value foreign keys

ALTER TABLE SCHEMANAME.plan_guidance_code_value
  ADD CONSTRAINT plan_guidance_code_value_fk_code_value
  FOREIGN KEY (fk_code_value)
  REFERENCES SCHEMANAME.code_value(code_value_uuid)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE SCHEMANAME.plan_guidance_code_value
  ADD CONSTRAINT plan_guidance_code_value_fk_plan_guidance
  FOREIGN KEY (fk_plan_guidance)
  REFERENCES SCHEMANAME.plan_guidance(local_id)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;


-- SCHEMANAME.plan_guidance_document foreign keys

ALTER TABLE SCHEMANAME.plan_guidance_document
  ADD CONSTRAINT plan_guidance_document_fk_document
  FOREIGN KEY (document_local_id)
  REFERENCES SCHEMANAME."document"(local_id)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE SCHEMANAME.plan_guidance_document
  ADD CONSTRAINT plan_guidance_document_fk_plan_guidance
  FOREIGN KEY (plan_guidance_local_id)
  REFERENCES SCHEMANAME.plan_guidance(local_id)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;


-- SCHEMANAME.plan_guidance_geometry_area_value foreign keys

ALTER TABLE SCHEMANAME.plan_guidance_geometry_area_value
  ADD CONSTRAINT plan_guidance_geometry_area_value_fk_geometry_area_value
  FOREIGN KEY (fk_geometry_area_value)
  REFERENCES SCHEMANAME.geometry_area_value(geometry_area_value_uuid)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE SCHEMANAME.plan_guidance_geometry_area_value
  ADD CONSTRAINT plan_guidance_geometry_area_value_fk_plan_guidance
  FOREIGN KEY (fk_plan_guidance)
  REFERENCES SCHEMANAME.plan_guidance(local_id)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;


-- SCHEMANAME.plan_guidance_geometry_line_value foreign keys

ALTER TABLE SCHEMANAME.plan_guidance_geometry_line_value
  ADD CONSTRAINT plan_guidance_geometry_line_value_fk_geometry_line_value
  FOREIGN KEY (fk_geometry_line_value)
  REFERENCES SCHEMANAME.geometry_line_value(geometry_line_value_uuid)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE SCHEMANAME.plan_guidance_geometry_line_value
  ADD CONSTRAINT plan_guidance_geometry_line_value_fk_plan_guidance
  FOREIGN KEY (fk_plan_guidance)
  REFERENCES SCHEMANAME.plan_guidance(local_id)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;


-- SCHEMANAME.plan_guidance_geometry_point_value foreign keys

ALTER TABLE SCHEMANAME.plan_guidance_geometry_point_value
  ADD CONSTRAINT plan_guidance_geometry_point_value_fk_geometry_point_value
  FOREIGN KEY (fk_geometry_point_value)
  REFERENCES SCHEMANAME.geometry_point_value(geometry_point_value_uuid)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE SCHEMANAME.plan_guidance_geometry_point_value
  ADD CONSTRAINT plan_guidance_geometry_point_value_fk_plan_guidance
  FOREIGN KEY (fk_plan_guidance)
  REFERENCES SCHEMANAME.plan_guidance(local_id)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;


-- SCHEMANAME.plan_guidance_identifier_value foreign keys

ALTER TABLE SCHEMANAME.plan_guidance_identifier_value
  ADD CONSTRAINT plan_guidance_identifier_value_fk_identifier_value
  FOREIGN KEY (fk_identifier_value)
  REFERENCES SCHEMANAME.identifier_value(identifier_value_uuid)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE SCHEMANAME.plan_guidance_identifier_value
  ADD CONSTRAINT plan_guidance_identifier_value_fk_plan_guidance
  FOREIGN KEY (fk_plan_guidance)
  REFERENCES SCHEMANAME.plan_guidance(local_id)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;


-- SCHEMANAME.plan_guidance_numeric_double_value foreign keys

ALTER TABLE SCHEMANAME.plan_guidance_numeric_double_value
  ADD CONSTRAINT plan_guidance_numeric_double_value_fk_numeric_double_value
  FOREIGN KEY (fk_numeric_double_value)
  REFERENCES SCHEMANAME.numeric_double_value(numeric_double_value_uuid)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE SCHEMANAME.plan_guidance_numeric_double_value
  ADD CONSTRAINT plan_guidance_numeric_double_value_fk_plan_guidance
  FOREIGN KEY (fk_plan_guidance)
  REFERENCES SCHEMANAME.plan_guidance(local_id)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;


-- SCHEMANAME.plan_guidance_numeric_range foreign keys

ALTER TABLE SCHEMANAME.plan_guidance_numeric_range
  ADD CONSTRAINT plan_guidance_numeric_range_fk_numeric_range
  FOREIGN KEY (fk_numeric_range)
  REFERENCES SCHEMANAME.numeric_range(numeric_range_uuid)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE SCHEMANAME.plan_guidance_numeric_range
  ADD CONSTRAINT plan_guidance_numeric_range_fk_plan_guidance
  FOREIGN KEY (fk_plan_guidance)
  REFERENCES SCHEMANAME.plan_guidance(local_id)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;


-- SCHEMANAME.plan_guidance_text_value foreign keys

ALTER TABLE SCHEMANAME.plan_guidance_text_value
  ADD CONSTRAINT plan_guidance_text_value_fk_plan_guidance
  FOREIGN KEY (fk_plan_guidance)
  REFERENCES SCHEMANAME.plan_guidance(local_id)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE SCHEMANAME.plan_guidance_text_value
  ADD CONSTRAINT plan_guidance_text_value_fk_text_value
  FOREIGN KEY (fk_text_value)
  REFERENCES SCHEMANAME.text_value(text_value_uuid)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;


-- SCHEMANAME.plan_guidance_theme foreign keys

ALTER TABLE SCHEMANAME.plan_guidance_theme
  ADD CONSTRAINT plan_guidance_theme_fk_plan_guidance
  FOREIGN KEY (plan_guidance_local_id)
  REFERENCES SCHEMANAME.plan_guidance(local_id)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE SCHEMANAME.plan_guidance_theme
  ADD CONSTRAINT plan_guidance_theme_fk_theme
  FOREIGN KEY (theme_code)
  REFERENCES code_lists.master_plan_theme(codevalue)
  ON DELETE RESTRICT
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;


-- SCHEMANAME.plan_guidance_time_instant_value foreign keys

ALTER TABLE SCHEMANAME.plan_guidance_time_instant_value
  ADD CONSTRAINT plan_guidance_time_instant_value_fk_plan_guidance
  FOREIGN KEY (fk_plan_guidance)
  REFERENCES SCHEMANAME.plan_guidance(local_id)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE SCHEMANAME.plan_guidance_time_instant_value
  ADD CONSTRAINT plan_guidance_time_instant_value_fk_time_instant_value
  FOREIGN KEY (fk_time_instant_value)
  REFERENCES SCHEMANAME.time_instant_value(time_instant_uuid)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;


-- SCHEMANAME.plan_guidance_time_period_value foreign keys

ALTER TABLE SCHEMANAME.plan_guidance_time_period_value
  ADD CONSTRAINT plan_guidance_time_period_value_fk_plan_guidance
  FOREIGN KEY (fk_plan_guidance)
  REFERENCES SCHEMANAME.plan_guidance(local_id)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE SCHEMANAME.plan_guidance_time_period_value
  ADD CONSTRAINT plan_guidance_time_period_value_fk_time_period_value
  FOREIGN KEY (fk_time_period_value)
  REFERENCES SCHEMANAME.time_period_value(time_period_uuid)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;


-- SCHEMANAME.plan_regulation foreign keys

ALTER TABLE SCHEMANAME.plan_regulation
  ADD CONSTRAINT plan_regulation_fk_life_cycle_status
  FOREIGN KEY (life_cycle_status)
  REFERENCES code_lists.spatial_plan_lifecycle_status(codevalue)
  ON DELETE RESTRICT
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE SCHEMANAME.plan_regulation
  ADD CONSTRAINT plan_regulation_fk_type
  FOREIGN KEY ("type")
  REFERENCES code_lists.master_plan_regulation_kind(codevalue)
  ON DELETE RESTRICT
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;


-- SCHEMANAME.plan_regulation_code_value foreign keys

ALTER TABLE SCHEMANAME.plan_regulation_code_value
  ADD CONSTRAINT plan_regulation_code_value_fk_code_value
  FOREIGN KEY (fk_code_value)
  REFERENCES SCHEMANAME.code_value(code_value_uuid)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE SCHEMANAME.plan_regulation_code_value
  ADD CONSTRAINT plan_regulation_code_value_fk_plan_regulation
  FOREIGN KEY (fk_plan_regulation)
  REFERENCES SCHEMANAME.plan_regulation(local_id)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;


-- SCHEMANAME.plan_regulation_document foreign keys

ALTER TABLE SCHEMANAME.plan_regulation_document
  ADD CONSTRAINT plan_regulation_document_fk_document
  FOREIGN KEY (document_local_id)
  REFERENCES SCHEMANAME."document"(local_id)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE SCHEMANAME.plan_regulation_document
  ADD CONSTRAINT plan_regulation_document_fk_plan_regulation
  FOREIGN KEY (plan_regulation_local_id)
  REFERENCES SCHEMANAME.plan_regulation(local_id)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;


-- SCHEMANAME.plan_regulation_geometry_area_value foreign keys

ALTER TABLE SCHEMANAME.plan_regulation_geometry_area_value
  ADD CONSTRAINT plan_regulation_geometry_area_value_fk_geometry_area_value
  FOREIGN KEY (fk_geometry_area_value)
  REFERENCES SCHEMANAME.geometry_area_value(geometry_area_value_uuid)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE SCHEMANAME.plan_regulation_geometry_area_value
  ADD CONSTRAINT plan_regulation_geometry_area_value_fk_plan_regulation
  FOREIGN KEY (fk_plan_regulation)
  REFERENCES SCHEMANAME.plan_regulation(local_id)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;


-- SCHEMANAME.plan_regulation_geometry_line_value foreign keys

ALTER TABLE SCHEMANAME.plan_regulation_geometry_line_value
  ADD CONSTRAINT plan_regulation_geometry_line_value_fk_geometry_line_value
  FOREIGN KEY (fk_geometry_line_value)
  REFERENCES SCHEMANAME.geometry_line_value(geometry_line_value_uuid)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE SCHEMANAME.plan_regulation_geometry_line_value
  ADD CONSTRAINT plan_regulation_geometry_line_value_fk_plan_regulation
  FOREIGN KEY (fk_plan_regulation)
  REFERENCES SCHEMANAME.plan_regulation(local_id)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;


-- SCHEMANAME.plan_regulation_geometry_point_value foreign keys

ALTER TABLE SCHEMANAME.plan_regulation_geometry_point_value
  ADD CONSTRAINT plan_regulation_geometry_point_value_fk_geometry_point_value
  FOREIGN KEY (fk_geometry_point_value)
  REFERENCES SCHEMANAME.geometry_point_value(geometry_point_value_uuid)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE SCHEMANAME.plan_regulation_geometry_point_value
  ADD CONSTRAINT plan_regulation_geometry_point_value_fk_plan_regulation
  FOREIGN KEY (fk_plan_regulation)
  REFERENCES SCHEMANAME.plan_regulation(local_id)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;


-- SCHEMANAME.plan_regulation_group_regulation foreign keys

ALTER TABLE SCHEMANAME.plan_regulation_group_regulation
  ADD CONSTRAINT plan_regulation_group_regulation_fk_plan_regulation
  FOREIGN KEY (plan_regulation_local_id)
  REFERENCES SCHEMANAME.plan_regulation(local_id)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE SCHEMANAME.plan_regulation_group_regulation
  ADD CONSTRAINT plan_regulation_group_regulation_fk_plan_regulation_group
  FOREIGN KEY (plan_regulation_group_local_id)
  REFERENCES SCHEMANAME.plan_regulation_group(local_id)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;


-- SCHEMANAME.plan_regulation_identifier_value foreign keys

ALTER TABLE SCHEMANAME.plan_regulation_identifier_value
  ADD CONSTRAINT plan_regulation_identifier_value_fk_identifier_value
  FOREIGN KEY (fk_identifier_value)
  REFERENCES SCHEMANAME.identifier_value(identifier_value_uuid)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE SCHEMANAME.plan_regulation_identifier_value
  ADD CONSTRAINT plan_regulation_identifier_value_fk_plan_regulation
  FOREIGN KEY (fk_plan_regulation)
  REFERENCES SCHEMANAME.plan_regulation(local_id)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;


-- SCHEMANAME.plan_regulation_numeric_double_value foreign keys

ALTER TABLE SCHEMANAME.plan_regulation_numeric_double_value
  ADD CONSTRAINT plan_regulation_numeric_double_value_fk_numeric_double_value
  FOREIGN KEY (fk_numeric_double_value)
  REFERENCES SCHEMANAME.numeric_double_value(numeric_double_value_uuid)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE SCHEMANAME.plan_regulation_numeric_double_value
  ADD CONSTRAINT plan_regulation_numeric_double_value_fk_plan_regulation
  FOREIGN KEY (fk_plan_regulation)
  REFERENCES SCHEMANAME.plan_regulation(local_id)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;


-- SCHEMANAME.plan_regulation_numeric_range foreign keys

ALTER TABLE SCHEMANAME.plan_regulation_numeric_range
  ADD CONSTRAINT plan_regulation_numeric_range_fk_numeric_range
  FOREIGN KEY (fk_numeric_range)
  REFERENCES SCHEMANAME.numeric_range(numeric_range_uuid)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE SCHEMANAME.plan_regulation_numeric_range
  ADD CONSTRAINT plan_regulation_numeric_range_fk_plan_regulation
  FOREIGN KEY (fk_plan_regulation)
  REFERENCES SCHEMANAME.plan_regulation(local_id)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;


-- SCHEMANAME.plan_regulation_supplementary_information foreign keys

ALTER TABLE SCHEMANAME.plan_regulation_supplementary_information
  ADD CONSTRAINT fk_plan_regulation
  FOREIGN KEY (fk_plan_regulation)
  REFERENCES SCHEMANAME.plan_regulation(local_id)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE SCHEMANAME.plan_regulation_supplementary_information
  ADD CONSTRAINT fk_supplementary_information
  FOREIGN KEY (fk_supplementary_information)
  REFERENCES SCHEMANAME.supplementary_information(producer_specific_id)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;


-- SCHEMANAME.plan_regulation_text_value foreign keys

ALTER TABLE SCHEMANAME.plan_regulation_text_value
  ADD CONSTRAINT plan_regulation_text_value_fk_plan_regulation
  FOREIGN KEY (fk_plan_regulation)
  REFERENCES SCHEMANAME.plan_regulation(local_id)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE SCHEMANAME.plan_regulation_text_value
  ADD CONSTRAINT plan_regulation_text_value_fk_text_value
  FOREIGN KEY (fk_text_value)
  REFERENCES SCHEMANAME.text_value(text_value_uuid)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;


-- SCHEMANAME.plan_regulation_theme foreign keys

ALTER TABLE SCHEMANAME.plan_regulation_theme
  ADD CONSTRAINT plan_regulation_theme_fk_plan_regulation
  FOREIGN KEY (plan_regulation_local_id)
  REFERENCES SCHEMANAME.plan_regulation(local_id)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE SCHEMANAME.plan_regulation_theme
  ADD CONSTRAINT plan_regulation_theme_fk_theme
  FOREIGN KEY (theme_code)
  REFERENCES code_lists.master_plan_theme(codevalue)
  ON DELETE RESTRICT
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;


-- SCHEMANAME.plan_regulation_time_instant_value foreign keys

ALTER TABLE SCHEMANAME.plan_regulation_time_instant_value
  ADD CONSTRAINT plan_regulation_time_instant_value_fk_plan_regulation
  FOREIGN KEY (fk_plan_regulation)
  REFERENCES SCHEMANAME.plan_regulation(local_id)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE SCHEMANAME.plan_regulation_time_instant_value
  ADD CONSTRAINT plan_regulation_time_instant_value_fk_time_instant_value
  FOREIGN KEY (fk_time_instant_value)
  REFERENCES SCHEMANAME.time_instant_value(time_instant_uuid)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;


-- SCHEMANAME.plan_regulation_time_period_value foreign keys

ALTER TABLE SCHEMANAME.plan_regulation_time_period_value
  ADD CONSTRAINT plan_regulation_time_period_value_fk_plan_regulation
  FOREIGN KEY (fk_plan_regulation)
  REFERENCES SCHEMANAME.plan_regulation(local_id)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE SCHEMANAME.plan_regulation_time_period_value
  ADD CONSTRAINT plan_regulation_time_period_value_fk_time_period_value
  FOREIGN KEY (fk_time_period_value)
  REFERENCES SCHEMANAME.time_period_value(time_period_uuid)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;


-- SCHEMANAME.planned_space foreign keys

ALTER TABLE SCHEMANAME.planned_space
  ADD CONSTRAINT planned_space_bindingness_of_location_fkey
  FOREIGN KEY (bindingness_of_location)
  REFERENCES code_lists.bindingness_kind(codevalue)
  ON DELETE RESTRICT
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE SCHEMANAME.planned_space
  ADD CONSTRAINT planned_space_ground_relative_position_fkey
  FOREIGN KEY (ground_relative_position)
  REFERENCES code_lists.ground_relativeness_kind(codevalue)
  ON DELETE RESTRICT
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;


-- SCHEMANAME.planned_space_plan_detail_line foreign keys

ALTER TABLE SCHEMANAME.planned_space_plan_detail_line
  ADD CONSTRAINT planned_space_plan_detail_line_fk_planned_space
  FOREIGN KEY (planned_space_local_id)
  REFERENCES SCHEMANAME.planned_space(local_id)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE SCHEMANAME.planned_space_plan_detail_line
  ADD CONSTRAINT planned_space_plan_detail_line_fk_planning_detail_line
  FOREIGN KEY (planning_detail_line_local_id)
  REFERENCES SCHEMANAME.planning_detail_line(local_id)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;


-- SCHEMANAME.planned_space_plan_guidance foreign keys

ALTER TABLE SCHEMANAME.planned_space_plan_guidance
  ADD CONSTRAINT planned_space_plan_guidance_fk_plan_guidance
  FOREIGN KEY (plan_guidance_local_id)
  REFERENCES SCHEMANAME.plan_guidance(local_id)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE SCHEMANAME.planned_space_plan_guidance
  ADD CONSTRAINT planned_space_plan_guidance_fk_planned_space
  FOREIGN KEY (planned_space_local_id)
  REFERENCES SCHEMANAME.planned_space(local_id)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;


-- SCHEMANAME.planned_space_plan_regulation foreign keys

ALTER TABLE SCHEMANAME.planned_space_plan_regulation
  ADD CONSTRAINT planned_space_plan_regulation_fk_plan_regulation
  FOREIGN KEY (plan_regulation_local_id)
  REFERENCES SCHEMANAME.plan_regulation(local_id)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE SCHEMANAME.planned_space_plan_regulation
  ADD CONSTRAINT planned_space_plan_regulation_fk_planned_space
  FOREIGN KEY (planned_space_local_id)
  REFERENCES SCHEMANAME.planned_space(local_id)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;


-- SCHEMANAME.planned_space_plan_regulation_group foreign keys

ALTER TABLE SCHEMANAME.planned_space_plan_regulation_group
  ADD CONSTRAINT planned_space_plan_regulation_group_fk_plan_regulation_group
  FOREIGN KEY (plan_regulation_group_local_id)
  REFERENCES SCHEMANAME.plan_regulation_group(local_id)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE SCHEMANAME.planned_space_plan_regulation_group
  ADD CONSTRAINT planned_space_plan_regulation_group_fk_planned_space
  FOREIGN KEY (planned_space_local_id)
  REFERENCES SCHEMANAME.planned_space(local_id)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;


-- SCHEMANAME.planner foreign keys

ALTER TABLE SCHEMANAME.planner
  ADD CONSTRAINT planner_fk_spatial_plan
  FOREIGN KEY (fk_spatial_plan)
  REFERENCES SCHEMANAME.spatial_plan(producer_specific_id)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED;


-- SCHEMANAME.planning_detail_line_plan_guidance foreign keys

ALTER TABLE SCHEMANAME.planning_detail_line_plan_guidance
  ADD CONSTRAINT planning_detail_line_plan_guidance_fk_plan_guidance
  FOREIGN KEY (plan_guidance_local_id)
  REFERENCES SCHEMANAME.plan_guidance(local_id)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE SCHEMANAME.planning_detail_line_plan_guidance
  ADD CONSTRAINT planning_detail_line_plan_guidance_fk_planning_detail_line
  FOREIGN KEY (planning_detail_line_local_id)
  REFERENCES SCHEMANAME.planning_detail_line(local_id)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;


-- SCHEMANAME.planning_detail_line_plan_regulation foreign keys

ALTER TABLE SCHEMANAME.planning_detail_line_plan_regulation
  ADD CONSTRAINT planning_detail_line_plan_regulation_fk_plan_regulation
  FOREIGN KEY (plan_regulation_local_id)
  REFERENCES SCHEMANAME.plan_regulation(local_id)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE SCHEMANAME.planning_detail_line_plan_regulation
  ADD CONSTRAINT planning_detail_line_plan_regulation_fk_planning_detail_line
  FOREIGN KEY (planning_detail_line_local_id)
  REFERENCES SCHEMANAME.planning_detail_line(local_id)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;


-- SCHEMANAME.spatial_plan foreign keys

ALTER TABLE SCHEMANAME.spatial_plan
  ADD CONSTRAINT spatial_plan_digital_origin_fkey
  FOREIGN KEY (digital_origin)
  REFERENCES code_lists.digital_origin_kind(codevalue)
  ON DELETE RESTRICT
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE SCHEMANAME.spatial_plan
  ADD CONSTRAINT spatial_plan_ground_relative_position_fkey
  FOREIGN KEY (ground_relative_position)
  REFERENCES code_lists.ground_relativeness_kind(codevalue)
  ON DELETE RESTRICT
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE SCHEMANAME.spatial_plan
  ADD CONSTRAINT spatial_plan_legal_effectiveness_fkey
  FOREIGN KEY (legal_effectiveness)
  REFERENCES code_lists.legal_effectiveness_kind(codevalue)
  ON DELETE RESTRICT
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE SCHEMANAME.spatial_plan
  ADD CONSTRAINT spatial_plan_lifecycle_status_fkey
  FOREIGN KEY (lifecycle_status)
  REFERENCES code_lists.spatial_plan_lifecycle_status(codevalue)
  ON DELETE RESTRICT
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE SCHEMANAME.spatial_plan
  ADD CONSTRAINT spatial_plan_type_fkey
  FOREIGN KEY ("type")
  REFERENCES code_lists.spatial_plan_kind(codevalue)
  ON DELETE RESTRICT
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;


-- SCHEMANAME.spatial_plan_commentary foreign keys

ALTER TABLE SCHEMANAME.spatial_plan_commentary
  ADD CONSTRAINT spatial_plan_commentary_fk_spatial_plan
  FOREIGN KEY (spatial_plan)
  REFERENCES SCHEMANAME.spatial_plan(local_id)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;


-- SCHEMANAME.spatial_plan_commentary_document foreign keys

ALTER TABLE SCHEMANAME.spatial_plan_commentary_document
  ADD CONSTRAINT spatial_plan_commentary_document_fk_document
  FOREIGN KEY (document_local_id)
  REFERENCES SCHEMANAME."document"(local_id)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE SCHEMANAME.spatial_plan_commentary_document
  ADD CONSTRAINT spatial_plan_commentary_document_fk_spatial_plan_commentary
  FOREIGN KEY (spatial_plan_commentary_local_id)
  REFERENCES SCHEMANAME.spatial_plan_commentary(local_id)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;


-- SCHEMANAME.spatial_plan_plan_guidance foreign keys

ALTER TABLE SCHEMANAME.spatial_plan_plan_guidance
  ADD CONSTRAINT spatial_plan_plan_guidance_fk_plan_guidance
  FOREIGN KEY (plan_guidance_local_id)
  REFERENCES SCHEMANAME.plan_guidance(local_id)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE SCHEMANAME.spatial_plan_plan_guidance
  ADD CONSTRAINT spatial_plan_plan_guidance_fk_spatial_plan
  FOREIGN KEY (spatial_plan_local_id)
  REFERENCES SCHEMANAME.spatial_plan(local_id)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;


-- SCHEMANAME.spatial_plan_plan_regulation foreign keys

ALTER TABLE SCHEMANAME.spatial_plan_plan_regulation
  ADD CONSTRAINT spatial_plan_plan_regulation_fk_plan_regulation
  FOREIGN KEY (plan_regulation_local_id)
  REFERENCES SCHEMANAME.plan_regulation(local_id)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE SCHEMANAME.spatial_plan_plan_regulation
  ADD CONSTRAINT spatial_plan_plan_regulation_fk_spatial_plan
  FOREIGN KEY (spatial_plan_local_id)
  REFERENCES SCHEMANAME.spatial_plan(local_id)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;


-- SCHEMANAME.supplementary_information foreign keys

ALTER TABLE SCHEMANAME.supplementary_information
  ADD CONSTRAINT supplementary_information_fk_plan_regulation
  FOREIGN KEY (fk_plan_regulation)
  REFERENCES SCHEMANAME.plan_regulation(local_id)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE SCHEMANAME.supplementary_information
  ADD CONSTRAINT supplementary_information_fk_type
  FOREIGN KEY ("type")
  REFERENCES code_lists.master_plan_addition_information_kind(codevalue)
  ON DELETE RESTRICT
  ON UPDATE CASCADE;


-- SCHEMANAME.supplementary_information_code_value foreign keys

ALTER TABLE SCHEMANAME.supplementary_information_code_value
  ADD CONSTRAINT supplementary_information_code_value_fk_code_value
  FOREIGN KEY (fk_code_value)
  REFERENCES SCHEMANAME.code_value(code_value_uuid)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE SCHEMANAME.supplementary_information_code_value
  ADD CONSTRAINT supplementary_information_code_value_fk_supplementary_informati
  FOREIGN KEY (fk_supplementary_information)
  REFERENCES SCHEMANAME.supplementary_information(producer_specific_id)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;


-- SCHEMANAME.supplementary_information_geometry_area_value foreign keys

ALTER TABLE SCHEMANAME.supplementary_information_geometry_area_value
  ADD CONSTRAINT supplementary_information_geometry_area_value_fk_geometry_area_
  FOREIGN KEY (fk_geometry_area_value)
  REFERENCES SCHEMANAME.geometry_area_value(geometry_area_value_uuid)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE SCHEMANAME.supplementary_information_geometry_area_value
  ADD CONSTRAINT supplementary_information_geometry_area_value_fk_supplementary_
  FOREIGN KEY (fk_supplementary_information)
  REFERENCES SCHEMANAME.supplementary_information(producer_specific_id)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;


-- SCHEMANAME.supplementary_information_geometry_line_value foreign keys

ALTER TABLE SCHEMANAME.supplementary_information_geometry_line_value
  ADD CONSTRAINT supplementary_information_geometry_line_value_fk_geometry_line_
  FOREIGN KEY (fk_geometry_line_value)
  REFERENCES SCHEMANAME.geometry_line_value(geometry_line_value_uuid)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE SCHEMANAME.supplementary_information_geometry_line_value
  ADD CONSTRAINT supplementary_information_geometry_line_value_fk_supplementary_
  FOREIGN KEY (fk_supplementary_information)
  REFERENCES SCHEMANAME.supplementary_information(producer_specific_id)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;


-- SCHEMANAME.supplementary_information_geometry_point_value foreign keys

ALTER TABLE SCHEMANAME.supplementary_information_geometry_point_value
  ADD CONSTRAINT supplementary_information_geometry_point_value_fk_geometry_poin
  FOREIGN KEY (fk_geometry_point_value)
  REFERENCES SCHEMANAME.geometry_point_value(geometry_point_value_uuid)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE SCHEMANAME.supplementary_information_geometry_point_value
  ADD CONSTRAINT supplementary_information_geometry_point_value_fk_supplementary
  FOREIGN KEY (fk_supplementary_information)
  REFERENCES SCHEMANAME.supplementary_information(producer_specific_id)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;


-- SCHEMANAME.supplementary_information_identifier_value foreign keys

ALTER TABLE SCHEMANAME.supplementary_information_identifier_value
  ADD CONSTRAINT supplementary_information_identifier_value_fk_identifier_value
  FOREIGN KEY (fk_identifier_value)
  REFERENCES SCHEMANAME.identifier_value(identifier_value_uuid)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE SCHEMANAME.supplementary_information_identifier_value
  ADD CONSTRAINT supplementary_information_identifier_value_fk_supplementary_inf
  FOREIGN KEY (fk_supplementary_information)
  REFERENCES SCHEMANAME.supplementary_information(producer_specific_id)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;


-- SCHEMANAME.supplementary_information_numeric_double_value foreign keys

ALTER TABLE SCHEMANAME.supplementary_information_numeric_double_value
  ADD CONSTRAINT supplementary_information_numeric_double_value_fk_numeric_doubl
  FOREIGN KEY (fk_numeric_double_value)
  REFERENCES SCHEMANAME.numeric_double_value(numeric_double_value_uuid)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE SCHEMANAME.supplementary_information_numeric_double_value
  ADD CONSTRAINT supplementary_information_numeric_double_value_fk_supplementary
  FOREIGN KEY (fk_supplementary_information)
  REFERENCES SCHEMANAME.supplementary_information(producer_specific_id)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;


-- SCHEMANAME.supplementary_information_numeric_range foreign keys

ALTER TABLE SCHEMANAME.supplementary_information_numeric_range
  ADD CONSTRAINT supplementary_information_numeric_range_fk_numeric_range
  FOREIGN KEY (fk_numeric_range)
  REFERENCES SCHEMANAME.numeric_range(numeric_range_uuid)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE SCHEMANAME.supplementary_information_numeric_range
  ADD CONSTRAINT supplementary_information_numeric_range_fk_supplementary_inform
  FOREIGN KEY (fk_supplementary_information)
  REFERENCES SCHEMANAME.supplementary_information(producer_specific_id)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;


-- SCHEMANAME.supplementary_information_text_value foreign keys

ALTER TABLE SCHEMANAME.supplementary_information_text_value
  ADD CONSTRAINT supplementary_information_text_value_fk_supplementary_informati
  FOREIGN KEY (fk_supplementary_information)
  REFERENCES SCHEMANAME.supplementary_information(producer_specific_id)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE SCHEMANAME.supplementary_information_text_value
  ADD CONSTRAINT supplementary_information_text_value_fk_text_value
  FOREIGN KEY (fk_text_value)
  REFERENCES SCHEMANAME.text_value(text_value_uuid)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;


-- SCHEMANAME.supplementary_information_time_instant_value foreign keys

ALTER TABLE SCHEMANAME.supplementary_information_time_instant_value
  ADD CONSTRAINT supplementary_information_time_instant_value_fk_supplementary_i
  FOREIGN KEY (fk_supplementary_information)
  REFERENCES SCHEMANAME.supplementary_information(producer_specific_id)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE SCHEMANAME.supplementary_information_time_instant_value
  ADD CONSTRAINT supplementary_information_time_instant_value_fk_time_instant_va
  FOREIGN KEY (fk_time_instant_value)
  REFERENCES SCHEMANAME.time_instant_value(time_instant_uuid)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;


-- SCHEMANAME.supplementary_information_time_period_value foreign keys

ALTER TABLE SCHEMANAME.supplementary_information_time_period_value
  ADD CONSTRAINT supplementary_information_time_period_value_fk_supplementary_in
  FOREIGN KEY (fk_supplementary_information)
  REFERENCES SCHEMANAME.supplementary_information(producer_specific_id)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE SCHEMANAME.supplementary_information_time_period_value
  ADD CONSTRAINT supplementary_information_time_period_value_fk_time_period_valu
  FOREIGN KEY (fk_time_period_value)
  REFERENCES SCHEMANAME.time_period_value(time_period_uuid)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;


-- SCHEMANAME.zoning_element foreign keys

ALTER TABLE SCHEMANAME.zoning_element
  ADD CONSTRAINT zoning_element_fk_bindingness_of_location
  FOREIGN KEY (bindingness_of_location)
  REFERENCES code_lists.bindingness_kind(codevalue)
  ON DELETE RESTRICT
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE SCHEMANAME.zoning_element
  ADD CONSTRAINT zoning_element_fk_ground_relative_position
  FOREIGN KEY (ground_relative_position)
  REFERENCES code_lists.ground_relativeness_kind(codevalue)
  ON DELETE RESTRICT
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE SCHEMANAME.zoning_element
  ADD CONSTRAINT zoning_element_fk_land_use_kind
  FOREIGN KEY (land_use_kind)
  REFERENCES code_lists.master_plan_regulation_kind(codevalue)
  ON DELETE RESTRICT
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE SCHEMANAME.zoning_element
  ADD CONSTRAINT zoning_element_fk_spatial_plan
  FOREIGN KEY (spatial_plan)
  REFERENCES SCHEMANAME.spatial_plan(local_id)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;


-- SCHEMANAME.zoning_element_describing_line foreign keys

ALTER TABLE SCHEMANAME.zoning_element_describing_line
  ADD CONSTRAINT zoning_element_describing_line_fk_describing_line
  FOREIGN KEY (describing_line_id)
  REFERENCES SCHEMANAME.describing_line(identifier)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE SCHEMANAME.zoning_element_describing_line
  ADD CONSTRAINT zoning_element_describing_line_fk_zoning_element
  FOREIGN KEY (zoning_element_local_id)
  REFERENCES SCHEMANAME.zoning_element(local_id);


-- SCHEMANAME.zoning_element_describing_text foreign keys

ALTER TABLE SCHEMANAME.zoning_element_describing_text
  ADD CONSTRAINT zoning_element_describing_text_fk_describing_text
  FOREIGN KEY (describing_text_id)
  REFERENCES SCHEMANAME.describing_text(identifier)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE SCHEMANAME.zoning_element_describing_text
  ADD CONSTRAINT zoning_element_describing_text_fk_zoning_element
  FOREIGN KEY (zoning_element_local_id)
  REFERENCES SCHEMANAME.zoning_element(local_id);


-- SCHEMANAME.zoning_element_plan_detail_line foreign keys

ALTER TABLE SCHEMANAME.zoning_element_plan_detail_line
  ADD CONSTRAINT zoning_element_plan_detail_line_fk_planning_detail_line
  FOREIGN KEY (planning_detail_line_local_id)
  REFERENCES SCHEMANAME.planning_detail_line(local_id)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE SCHEMANAME.zoning_element_plan_detail_line
  ADD CONSTRAINT zoning_element_plan_detail_line_fk_zoning_element
  FOREIGN KEY (zoning_element_local_id)
  REFERENCES SCHEMANAME.zoning_element(local_id)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;


-- SCHEMANAME.zoning_element_plan_guidance foreign keys

ALTER TABLE SCHEMANAME.zoning_element_plan_guidance
  ADD CONSTRAINT zoning_element_plan_guidance_fk_plan_guidance
  FOREIGN KEY (plan_guidance_local_id)
  REFERENCES SCHEMANAME.plan_guidance(local_id)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE SCHEMANAME.zoning_element_plan_guidance
  ADD CONSTRAINT zoning_element_plan_guidance_fk_zoning_element
  FOREIGN KEY (zoning_element_local_id)
  REFERENCES SCHEMANAME.zoning_element(local_id)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;


-- SCHEMANAME.zoning_element_plan_regulation foreign keys

ALTER TABLE SCHEMANAME.zoning_element_plan_regulation
  ADD CONSTRAINT zoning_element_plan_regulation_fk_plan_regulation
  FOREIGN KEY (plan_regulation_local_id)
  REFERENCES SCHEMANAME.plan_regulation(local_id)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE SCHEMANAME.zoning_element_plan_regulation
  ADD CONSTRAINT zoning_element_plan_regulation_fk_zoning_element
  FOREIGN KEY (zoning_element_local_id)
  REFERENCES SCHEMANAME.zoning_element(local_id)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;


-- SCHEMANAME.zoning_element_plan_regulation_group foreign keys

ALTER TABLE SCHEMANAME.zoning_element_plan_regulation_group
  ADD CONSTRAINT zoning_element_plan_regulation_group_fk_plan_regulation_group
  FOREIGN KEY (plan_regulation_group_local_id)
  REFERENCES SCHEMANAME.plan_regulation_group(local_id)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE SCHEMANAME.zoning_element_plan_regulation_group
  ADD CONSTRAINT zoning_element_plan_regulation_group_fk_zoning_element
  FOREIGN KEY (zoning_element_local_id)
  REFERENCES SCHEMANAME.zoning_element(local_id)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;


-- SCHEMANAME.zoning_element_planned_space foreign keys

ALTER TABLE SCHEMANAME.zoning_element_planned_space
  ADD CONSTRAINT zoning_element_planned_space_fk_planned_space
  FOREIGN KEY (planned_space_local_id)
  REFERENCES SCHEMANAME.planned_space(local_id)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE SCHEMANAME.zoning_element_planned_space
  ADD CONSTRAINT zoning_element_planned_space_fk_zoning_element
  FOREIGN KEY (zoning_element_local_id)
  REFERENCES SCHEMANAME.zoning_element(local_id)
  ON DELETE CASCADE
  ON UPDATE CASCADE
  DEFERRABLE INITIALLY DEFERRED;