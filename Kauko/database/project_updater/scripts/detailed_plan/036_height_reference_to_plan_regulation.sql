CREATE TABLE SCHEMANAME.elevation_range_value (
    id serial4 NOT NULL,
	elevation_range_value_uuid uuid NOT NULL DEFAULT uuid_generate_v4(),
	minimum_value float8 NULL,
	maximum_value float8 NULL,
	unit_of_measure varchar NULL,
    reference_point GEOMETRY(point, PROJECTSRID) NOT NULL,
    verical_reference_system INT NOT NULL,
	CONSTRAINT elevation_range_value_elevation_range_value_uuid_key UNIQUE (elevation_range_value_uuid),
	CONSTRAINT elevation_range_value_pkey PRIMARY KEY (id),
	CONSTRAINT elevation_range_value_value_check CHECK ((minimum_value <= maximum_value)),
    CONSTRAINT elevation_range_vertical_system_fk FOREIGN KEY (verical_reference_system)
        REFERENCES code_lists.finnish_vertical_coordinate_reference_system(value)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);
CREATE INDEX sidx_elevation_range_value_geom ON SCHEMANAME.elevation_range_value USING gist (reference_point);

CREATE TABLE SCHEMANAME.elevation_position_value (
    id serial4 NOT NULL,
	elevation_position_value_uuid uuid NOT NULL DEFAULT uuid_generate_v4(),
	value float8 NOT NULL,
	unit_of_measure varchar NULL,
    reference_point GEOMETRY(point, PROJECTSRID) NOT NULL,
    verical_reference_system INT NOT NULL,
	CONSTRAINT elevation_position_value_elevation_position_value_uuid_key UNIQUE (elevation_position_value_uuid),
	CONSTRAINT elevation_position_value_pkey PRIMARY KEY (id),
    CONSTRAINT elevation_position_value_vertical_system_fk FOREIGN KEY (verical_reference_system)
        REFERENCES code_lists.finnish_vertical_coordinate_reference_system(value)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);
CREATE INDEX sidx_elevation_position_value_geom ON SCHEMANAME.elevation_position_value USING gist (reference_point);

CREATE TABLE SCHEMANAME.plan_guidance_elevation_position_value (
    id serial4 NOT NULL,
	fk_plan_guidance varchar NOT NULL,
	fk_elevation_position_value uuid NOT NULL,
	CONSTRAINT plan_guidance_elevation_position__fk_plan_guidance_fk_elev_p_key UNIQUE (fk_plan_guidance, fk_elevation_position_value),
	CONSTRAINT plan_guidance_elevation_position_value_pkey PRIMARY KEY (id)
);

ALTER TABLE SCHEMANAME.plan_guidance_elevation_position_value
    ADD CONSTRAINT plan_guidance_elevation_position_value_fk_elevation_position_value
    FOREIGN KEY (fk_elevation_position_value)
    REFERENCES SCHEMANAME.elevation_position_value(elevation_position_value_uuid)
    ON DELETE CASCADE
    ON UPDATE CASCADE
    DEFERRABLE INITIALLY DEFERRED;


ALTER TABLE SCHEMANAME.plan_guidance_elevation_position_value
    ADD CONSTRAINT plan_guidance_elevation_position_value_fk_plan_guidance
    FOREIGN KEY (fk_plan_guidance)
    REFERENCES SCHEMANAME.plan_guidance(local_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
    DEFERRABLE INITIALLY DEFERRED;

CREATE TABLE SCHEMANAME.plan_guidance_elevation_range_value (
	id serial4 NOT NULL,
	fk_plan_guidance varchar NOT NULL,
	fk_elevation_range_value uuid NOT NULL,
	CONSTRAINT plan_guidance_elevation_range_value_fk_plan_guidance_fk_elev_ran_key UNIQUE (fk_plan_guidance, fk_elevation_range_value),
	CONSTRAINT plan_guidance_elevation_range_value_pkey PRIMARY KEY (id)
);

ALTER TABLE SCHEMANAME.plan_guidance_elevation_range_value
    ADD CONSTRAINT plan_guidance_elevation_range_value_fk_elevation_range_value
    FOREIGN KEY (fk_elevation_range_value)
    REFERENCES SCHEMANAME.elevation_range_value(elevation_range_value_uuid)
    ON DELETE CASCADE
    ON UPDATE CASCADE
    DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE SCHEMANAME.plan_guidance_elevation_range_value
    ADD CONSTRAINT plan_guidance_elevation_range_value_fk_plan_guidance
    FOREIGN KEY (fk_plan_guidance)
    REFERENCES SCHEMANAME.plan_guidance(local_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
    DEFERRABLE INITIALLY DEFERRED;

CREATE TABLE SCHEMANAME.plan_regulation_elevation_position_value (
    id serial4 NOT NULL,
	fk_plan_regulation varchar NOT NULL,
	fk_elevation_position_value uuid NOT NULL,
	CONSTRAINT plan_regulation_elevation_position__fk_plan_regulation_fk_elev_p_key UNIQUE (fk_plan_regulation, fk_elevation_position_value),
	CONSTRAINT plan_regulation_elevation_position_value_pkey PRIMARY KEY (id)
);

ALTER TABLE SCHEMANAME.plan_regulation_elevation_position_value
    ADD CONSTRAINT plan_regulation_elevation_position_value_fk_elevation_position_value
    FOREIGN KEY (fk_elevation_position_value)
    REFERENCES SCHEMANAME.elevation_position_value(elevation_position_value_uuid)
    ON DELETE CASCADE
    ON UPDATE CASCADE
    DEFERRABLE INITIALLY DEFERRED;


ALTER TABLE SCHEMANAME.plan_regulation_elevation_position_value
    ADD CONSTRAINT plan_regulation_elevation_position_value_fk_plan_regulation
    FOREIGN KEY (fk_plan_regulation)
    REFERENCES SCHEMANAME.plan_regulation(local_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
    DEFERRABLE INITIALLY DEFERRED;

CREATE TABLE SCHEMANAME.plan_regulation_elevation_range_value (
	id serial4 NOT NULL,
	fk_plan_regulation varchar NOT NULL,
	fk_elevation_range_value uuid NOT NULL,
	CONSTRAINT plan_regulation_elevation_range_value_fk_plan_regulation_fk_elev_ran_key UNIQUE (fk_plan_regulation, fk_elevation_range_value),
	CONSTRAINT plan_regulation_elevation_range_value_pkey PRIMARY KEY (id)
);

ALTER TABLE SCHEMANAME.plan_regulation_elevation_range_value
    ADD CONSTRAINT plan_regulation_elevation_range_value_fk_elevation_range_value
    FOREIGN KEY (fk_elevation_range_value)
    REFERENCES SCHEMANAME.elevation_range_value(elevation_range_value_uuid)
    ON DELETE CASCADE
    ON UPDATE CASCADE
    DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE SCHEMANAME.plan_regulation_elevation_range_value
    ADD CONSTRAINT plan_regulation_elevation_range_value_fk_plan_regulation
    FOREIGN KEY (fk_plan_regulation)
    REFERENCES SCHEMANAME.plan_regulation(local_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
    DEFERRABLE INITIALLY DEFERRED;

CREATE TABLE SCHEMANAME.supplementary_information_elevation_position_value (
    id serial4 NOT NULL,
	fk_supplementary_information uuid NOT NULL,
	fk_elevation_position_value uuid NOT NULL,
	CONSTRAINT supplementary_information_elevation_position__fk_supplementary_information_fk_elev_p_key UNIQUE (fk_supplementary_information, fk_elevation_position_value),
	CONSTRAINT supplementary_information_elevation_position_value_pkey PRIMARY KEY (id)
);

ALTER TABLE SCHEMANAME.supplementary_information_elevation_position_value
    ADD CONSTRAINT supplementary_information_elevation_position_value_fk_elevation_position_value
    FOREIGN KEY (fk_elevation_position_value)
    REFERENCES SCHEMANAME.elevation_position_value(elevation_position_value_uuid)
    ON DELETE CASCADE
    ON UPDATE CASCADE
    DEFERRABLE INITIALLY DEFERRED;


ALTER TABLE SCHEMANAME.supplementary_information_elevation_position_value
    ADD CONSTRAINT supplementary_information_elevation_position_value_fk_supplementary_information
    FOREIGN KEY (fk_supplementary_information)
    REFERENCES SCHEMANAME.supplementary_information(producer_specific_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
    DEFERRABLE INITIALLY DEFERRED;

CREATE TABLE SCHEMANAME.supplementary_information_elevation_range_value (
	id serial4 NOT NULL,
	fk_supplementary_information uuid NOT NULL,
	fk_elevation_range_value uuid NOT NULL,
	CONSTRAINT supplementary_information_elevation_range_value_fk_supplementary_information_fk_elev_ran_key UNIQUE (fk_supplementary_information, fk_elevation_range_value),
	CONSTRAINT supplementary_information_elevation_range_value_pkey PRIMARY KEY (id)
);

ALTER TABLE SCHEMANAME.supplementary_information_elevation_range_value
    ADD CONSTRAINT suppl_info_elev_range_value_fk_elevation_range_value
    FOREIGN KEY (fk_elevation_range_value)
    REFERENCES SCHEMANAME.elevation_range_value(elevation_range_value_uuid)
    ON DELETE CASCADE
    ON UPDATE CASCADE
    DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE SCHEMANAME.supplementary_information_elevation_range_value
    ADD CONSTRAINT suppl_info_elev_range_value_fk_supplementary_information
    FOREIGN KEY (fk_supplementary_information)
    REFERENCES SCHEMANAME.supplementary_information(producer_specific_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
    DEFERRABLE INITIALLY DEFERRED;
