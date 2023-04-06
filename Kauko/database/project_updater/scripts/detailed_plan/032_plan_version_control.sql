CREATE TABLE SCHEMANAME.spatial_plan_metadata (
    id SERIAL PRIMARY KEY,
    plan_id TEXT UNIQUE NOT NULL,
    "name" TEXT NOT NULL,
    created TIMESTAMP NOT NULL DEFAULT NOW()
);


-- DROP wrong identity_id unique constraints
DROP INDEX IF EXISTS SCHEMANAME.spatial_plan_identity_id_key;
DROP INDEX IF EXISTS SCHEMANAME.document_identity_id_key;
DROP INDEX IF EXISTS SCHEMANAME.participation_and_evalution_plan_identity_id_key;
DROP INDEX IF EXISTS SCHEMANAME.planned_space_identity_id_key;
DROP INDEX IF EXISTS SCHEMANAME.planner_identity_id_key;
DROP INDEX IF EXISTS SCHEMANAME.planning_detail_line_identity_id_key;
DROP INDEX IF EXISTS SCHEMANAME.spatial_plan_commentary_identity_id_key;
DROP INDEX IF EXISTS SCHEMANAME.zoning_element_identity_id_key;

--EXAMPLE:
CREATE OR REPLACE FUNCTION SCHEMANAME.create_new_spatial_plan_version(p_spatial_plan_local_id varchar)
RETURNS VOID AS $$
DECLARE
    new_spatial_plan_local_id varchar;
    new_elements RECORD;
BEGIN
    -- 1. Create a new spatial_plan version with same plan_id
    INSERT INTO SCHEMANAME.spatial_plan (geom, plan_id)
    SELECT geom, plan_id
    FROM SCHEMANAME.spatial_plan
    WHERE local_id = p_spatial_plan_local_id
    RETURNING local_id INTO new_spatial_plan_local_id;
        -- 2. Clone zoning_element, planned_space and their relations
    FOR new_elements IN
        SELECT old_zoning.local_id AS old_zoning_element_local_id,
            new_zoning.local_id AS new_zoning_element_local_id,
            old_space.local_id AS old_planned_space_local_id,
            new_space.local_id AS new_planned_space_local_id
        FROM SCHEMANAME.zoning_element AS old_zoning
        JOIN LATERAL (
            INSERT INTO SCHEMANAME.zoning_element (geom, spatial_plan)
            VALUES (old_zoning.geom, new_spatial_plan_local_id)
            RETURNING local_id
        ) AS new_zoning ON TRUE
        JOIN SCHEMANAME.zoning_element_planned_space AS zeps
        ON zeps.zoning_element_local_id = old_zoning.local_id
        JOIN SCHEMANAME.planned_space AS old_space
        ON old_space.local_id = zeps.planned_space_local_id
        JOIN LATERAL (
            INSERT INTO SCHEMANAME.planned_space (uuid, spatial_plan)
            VALUES (old_space.uuid, new_spatial_plan_local_id)
            RETURNING local_id
        ) AS new_space ON TRUE
        WHERE old_zoning.spatial_plan = p_spatial_plan_local_id
    LOOP
        INSERT INTO SCHEMANAME.zoning_element_planned_space (zoning_element_local_id, planned_space_local_id)
        VALUES (new_elements.new_zoning_element_local_id, new_elements.new_planned_space_local_id);
    END LOOP;
END;
$$ LANGUAGE plpgsql;




ALTER TABLE SCHEMANAME.spatial_plan
    ADD COLMUN is_active BOOLEAN DEFAULT FALSE,
    ADD COLUMN version_name TEXT;

UPDATE SCHEMANAME.spatial_plan
    SET plan_id = uuid_generate_v4()::text
    WHERE plan_id IS NULL;

INSERT INTO SCHEMANAME.spatial_plan_metadata (plan_id, "name", created)
    SELECT DISTINCT
        plan_id,
        "name" ->> 'fi',
        created
    FROM SCHEMANAME.spatial_plan;

UPDATE SCHEMANAME.spatial_plan sp
    SET version_name = "name" ->> 'fi',
        is_active = TRUE;

ALTER TABLE SCHEMANAME.spatial_plan
    ALTER COLUMN plan_id SET NOT NULL,
    ALTER COLMUN is_active SET NOT NULL,
    ALTER COLUMN version_name SET NOT NULL,
    ALTER COLUMN plan_id SET DEFAULT uuid_generate_v4()::text,
    ADD CONSTRAINT spatial_plan_metadata_id_fk FOREIGN KEY (plan_id)
        REFERENCES SCHEMANAME.spatial_plan_metadata (plan_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
        DEFERRABLE INITIALLY DEFERRED;

CREATE UNIQUE INDEX active_version_idx
ON SCHEMANAME.spatial_plan (identity_id)
WHERE is_active;

CREATE OR REPLACE FUNCTION create_new_spatial_plan()
RETURNS TRIGGER
AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM SCHEMANAME.spatial_plan_metadata
        WHERE plan_id = NEW.plan_id
    ) THEN
        INSERT INTO SCHEMANAME.spatial_plan_metadata (plan_id, "name", created)
        VALUES (NEW.plan_id, "name" ->> 'fi', NOW());
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER create_new_spatial_plan
BEFORE INSERT ON SCHEMANAME.spatial_plan
FOR EACH ROW
EXECUTE PROCEDURE create_new_spatial_plan();

CREATE OR REPLACE FUNCTION SCHEMANAME.create_new_spatial_plan_version(
    p_plan_id SCHEMANAME.spatial_plan_metadata.plan_id%TYPE,
    p_version_name TEXT,
    p_from_version SCHEMANAME.spatial_plan.local_id%TYPE)
RETURNS BOOLEAN
AS $$
DECLARE
    v_from_spatial_plan SCHEMANAME.spatial_plan%ROWTYPE;
    v_new_spatial_plan SCHEMANAME.spatial_plan%ROWTYPE;
    v_old_zoning_element_id SCHEMANAME.zoning_element.local_id%TYPE;
    v_new_zoning_element_id SCHEMANAME.zoning_element.local_id%TYPE;
    v_new_planned_space_id SCHEMANAME.planned_space.local_id%TYPE;
    v_old_planned_space_id SCHEMANAME.planned_space.local_id%TYPE;
    v_created_planned_spaces (TEXT, TEXT)[]; 
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM SCHEMANAME.spatial_plan
        WHERE local_id = p_from_version
        AND plan_id = p_plan_id
    ) THEN
        RAISE EXCEPTION 'Version % doesn''t exists for spatial_plan', p_from_version;
    END IF;

    SELECT *
    FROM SCHEMANAME.spatial_plan
    WHERE local_id = p_from_version
    LIMIT 1 INTO v_from_spatial_plan;

    INSERT INTO SCHEMANAME.spatial_plan (
        identity_id,
        geom,
        plan_id,
        approval_time,
        approved_by,
        epsg,
        vertical_coordinate_system,
        land_administration_authority,
        "language",
        valid_from,
        valid_to,
        is_released,
        "type",
        digital_origin,
        ground_relative_position,
        legal_effectiveness,
        validity_time,
        lifecycle_status,
        "name",
        initiation_time,
        version_name
    )
    SELECT 
        identity_id,
        geom,
        plan_id,
        approval_time,
        approved_by,
        epsg,
        vertical_coordinate_system,
        land_administration_authority,
        "language",
        valid_from,
        valid_to,
        is_released,
        "type",
        digital_origin,
        ground_relative_position,
        legal_effectiveness,
        validity_time,
        lifecycle_status,
        "name",
        initiation_time,
        p_version_name
    FROM SCHEMANAME.spatial_plan sp
    WHERE sp.local_id = v_from_spatial_plan.local_id
    RETURNING * INTO v_new_spatial_plan;

    INSERT INTO SCHEMANAME.zoning_element (
        identity_id,
        geom,
        localized_name,
        "name",
        "type",
        up_to_dateness,
        valid_from,
        valid_to,
        block_number,
        parcel_number,
        bindingness_of_location,
        ground_relative_position,
        land_use_kind,
        spatial_plan,
        validity_time,
        lifecycle_status)
    SELECT
        identity_id,
        geom,
        localized_name,
        "name",
        "type",
        up_to_dateness,
        valid_from,
        valid_to,
        block_number,
        parcel_number,
        bindingness_of_location,
        ground_relative_position,
        land_use_kind,
        v_new_spatial_plan.local_id,
        validity_time,
        lifecycle_status
    FROM SCHEMANAME.zoning_element ze
    WHERE ze.local_id = v_old_zoning_element_id;


    FOR v_old_zoning_element_id IN (
        SELECT local_id
        FROM SCHEMANAME.zoning_element
        WHERE spatial_plan = v_from_spatial_plan.local_id
    )
    LOOP
        INSERT INTO SCHEMANAME.zoning_element (
        identity_id,
        geom,
        localized_name,
        "name",
        "type",
        up_to_dateness,
        valid_from,
        valid_to,
        block_number,
        parcel_number,
        bindingness_of_location,
        ground_relative_position,
        land_use_kind,
        spatial_plan,
        validity_time,
        lifecycle_status)
        SELECT
            identity_id,
            geom,
            localized_name,
            "name",
            "type",
            up_to_dateness,
            valid_from,
            valid_to,
            block_number,
            parcel_number,
            bindingness_of_location,
            ground_relative_position,
            land_use_kind,
            v_new_spatial_plan.local_id,
            validity_time,
            lifecycle_status
        FROM SCHEMANAME.zoning_element ze
        WHERE ze.local_id = v_old_zoning_element_id
        RETURNING local_id INTO v_new_zoning_element_id;

        FOR v_old_planned_space_id IN (
            SELECT DISTINCT planned_space_local_id
            FROM SCHEMANAME.zoning_element_planned_space
            WHERE zoning_element_local_id = v_old_zoning_element_id
        )
        LOOP
            IF NOT v_old_planned_space_id = ANY(v_created_planned_spaces) THEN
            INSERT INTO SCHEMANAME.planned_space (
                geom,
                "type",
                valid_from,
                valid_to,
                bindingness_of_location,
                ground_relative_position,
                validity_time,
                lifecycle_status
            ) SELECT
                geom,
                "type",
                valid_from,
                valid_to,
                bindingness_of_location,
                ground_relative_position,
                validity_time,
                lifecycle_status
            FROM SCHEMANAME.planned_space ps
            WHERE ps.local_id = v_old_planned_space_id
            RETURNING local_id INTO v_new_planned_space_id;

            INSERT INTO SCHEMANAME.zoning_element_planned_space (
                zoning_element_local_id,
                planned_space_local_id
            ) VALUES (
                v_new_zoning_element_id,
                v_new_planned_space_id
            );
        END LOOP;
    
    END LOOP;

END;
