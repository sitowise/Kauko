ALTER TABLE SCHEMANAME.elevation_range_value
    ADD COLUMN is_active BOOLEAN NOT NULL DEFAULT TRUE;
ALTER TABLE SCHEMANAME.elevation_position_value
    ADD COLUMN is_active BOOLEAN NOT NULL DEFAULT TRUE;

CREATE OR REPLACE FUNCTION SCHEMANAME.update_active_plan(p_old_active_plan_local_id varchar, p_new_active_plan_local_id varchar)
RETURNS void AS $$
DECLARE
    v_old_plan_regulation_local_ids varchar[];
    v_old_plan_guidance_local_ids varchar[];
    v_new_plan_regulation_local_ids varchar[];
    v_new_plan_guidance_local_ids varchar[];
BEGIN
    IF NOT EXISTS(SELECT 1 FROM SCHEMANAME.spatial_plan WHERE local_id = p_old_active_plan_local_id LIMIT 1) THEN
        RAISE EXCEPTION 'Old active plan does not exist';
    END IF;

    IF NOT EXISTS(SELECT 1 FROM SCHEMANAME.spatial_plan WHERE local_id = p_new_active_plan_local_id LIMIT 1) THEN
        RAISE EXCEPTION 'New active plan does not exist';
    END IF;

    IF NOT (SELECT is_active FROM SCHEMANAME.spatial_plan WHERE local_id = p_old_active_plan_local_id LIMIT 1) THEN
        RAISE EXCEPTION 'Old active plan is not active';
    END IF;

    -- Deactivate old active plan
    UPDATE SCHEMANAME.spatial_plan
    SET is_active = FALSE
    WHERE local_id = p_old_active_plan_local_id;

    UPDATE SCHEMANAME.zoning_element
    SET is_active = FALSE
    WHERE spatial_plan = p_old_active_plan_local_id;

    UPDATE SCHEMANAME.planned_space ps
    SET is_active = FALSE
    FROM SCHEMANAME.zoning_element_planned_space zeps
    JOIN SCHEMANAME.zoning_element ze
        ON ze.local_id = zeps.zoning_element_local_id
    WHERE ze.spatial_plan = p_old_active_plan_local_id
    AND ps.local_id = zeps.planned_space_local_id;

    UPDATE SCHEMANAME.planning_detail_line pdl
    SET is_active = FALSE
    FROM SCHEMANAME.zoning_element_plan_detail_line zepdl
    JOIN SCHEMANAME.zoning_element ze
        ON ze.local_id = zepdl.zoning_element_local_id
    WHERE ze.spatial_plan = p_old_active_plan_local_id
    AND pdl.local_id = zepdl.planning_detail_line_local_id;

    UPDATE SCHEMANAME.describing_line dl
    SET is_active = FALSE
    FROM SCHEMANAME.zoning_element_describing_line zedl
    JOIN SCHEMANAME.zoning_element ze
        ON ze.local_id = zedl.zoning_element_local_id
    WHERE ze.spatial_plan = p_old_active_plan_local_id
    AND dl.identifier = zedl.describing_line_id;

    UPDATE SCHEMANAME.describing_text dt
    SET is_active = FALSE
    FROM SCHEMANAME.zoning_element_describing_text zedt
    JOIN SCHEMANAME.zoning_element ze
        ON ze.local_id = zedt.zoning_element_local_id
    WHERE ze.spatial_plan = p_old_active_plan_local_id
    AND dt.identifier = zedt.describing_text_id;

    SELECT ARRAY(SELECT SCHEMANAME.get_plan_regulation_local_ids(p_old_active_plan_local_id))
    INTO v_old_plan_regulation_local_ids;

    SELECT ARRAY(SELECT SCHEMANAME.get_plan_guidance_local_ids(p_old_active_plan_local_id))
    INTO v_old_plan_guidance_local_ids;

    UPDATE SCHEMANAME.geometry_area_value gav
    SET is_active = FALSE
    FROM SCHEMANAME.plan_regulation_geometry_area_value prgav
    WHERE gav.geometry_area_value_uuid = prgav.fk_geometry_area_value
    AND prgav.fk_plan_regulation = ANY(v_old_plan_regulation_local_ids);

    UPDATE SCHEMANAME.geometry_area_value gav
    SET is_active = FALSE
    FROM SCHEMANAME.plan_guidance_geometry_area_value pggav
    WHERE gav.geometry_area_value_uuid = pggav.fk_geometry_area_value
    AND pggav.fk_plan_guidance = ANY(v_old_plan_guidance_local_ids);

    UPDATE SCHEMANAME.geometry_area_value gav
    SET is_active = FALSE
    FROM SCHEMANAME.plan_regulation pr
    JOIN SCHEMANAME.plan_regulation_supplementary_information prsi
        ON prsi.fk_plan_regulation = pr.local_id
    JOIN SCHEMANAME.supplementary_information_geometry_area_value sigav
        ON sigav.fk_supplementary_information = prsi.fk_supplementary_information
    WHERE gav.geometry_area_value_uuid = sigav.fk_geometry_area_value
    AND pr.local_id = ANY(v_old_plan_regulation_local_ids);

    UPDATE SCHEMANAME.geometry_line_value glv
    SET is_active = FALSE
    FROM SCHEMANAME.plan_regulation_geometry_line_value prglv
    WHERE glv.geometry_line_value_uuid = prglv.fk_geometry_line_value
    AND prglv.fk_plan_regulation = ANY(v_old_plan_regulation_local_ids);

    UPDATE SCHEMANAME.geometry_line_value glv
    SET is_active = FALSE
    FROM SCHEMANAME.plan_guidance_geometry_line_value pgglv
    WHERE glv.geometry_line_value_uuid = pgglv.fk_geometry_line_value
    AND pgglv.fk_plan_guidance = ANY(v_old_plan_guidance_local_ids);

    UPDATE SCHEMANAME.geometry_line_value glv
    SET is_active = FALSE
    FROM SCHEMANAME.plan_regulation pr
    JOIN SCHEMANAME.plan_regulation_supplementary_information prsi
        ON prsi.fk_plan_regulation = pr.local_id
    JOIN SCHEMANAME.supplementary_information_geometry_line_value siglv
        ON siglv.fk_supplementary_information = prsi.fk_supplementary_information
    WHERE glv.geometry_line_value_uuid = siglv.fk_geometry_line_value
    AND pr.local_id = ANY(v_old_plan_regulation_local_ids);

    UPDATE SCHEMANAME.geometry_point_value gpv
    SET is_active = FALSE
    FROM SCHEMANAME.plan_regulation_geometry_point_value prgpv
    WHERE gpv.geometry_point_value_uuid = prgpv.fk_geometry_point_value
    AND prgpv.fk_plan_regulation = ANY(v_old_plan_regulation_local_ids);

    UPDATE SCHEMANAME.geometry_point_value gpv
    SET is_active = FALSE
    FROM SCHEMANAME.plan_guidance_geometry_point_value pggpv
    WHERE gpv.geometry_point_value_uuid = pggpv.fk_geometry_point_value
    AND pggpv.fk_plan_guidance = ANY(v_old_plan_guidance_local_ids);

    UPDATE SCHEMANAME.geometry_point_value gpv
    SET is_active = FALSE
    FROM SCHEMANAME.plan_regulation pr
    JOIN SCHEMANAME.plan_regulation_supplementary_information prsi
        ON prsi.fk_plan_regulation = pr.local_id
    JOIN SCHEMANAME.supplementary_information_geometry_point_value sigpv
        ON sigpv.fk_supplementary_information = prsi.fk_supplementary_information
    WHERE gpv.geometry_point_value_uuid = sigpv.fk_geometry_point_value
    AND pr.local_id = ANY(v_old_plan_regulation_local_ids);


    UPDATE SCHEMANAME.elevation_position_value epv
    SET is_active = FALSE
    FROM SCHEMANAME.plan_regulation_elevation_position_value prepv
    WHERE epv.elevation_position_value_uuid = prepv.fk_elevation_position_value
    AND prepv.fk_plan_regulation = ANY(v_old_plan_regulation_local_ids);

    UPDATE SCHEMANAME.elevation_position_value epv
    SET is_active = FALSE
    FROM SCHEMANAME.plan_guidance_elevation_position_value pgepv
    WHERE epv.elevation_position_value_uuid = pgepv.fk_elevation_position_value
    AND pgepv.fk_plan_guidance = ANY(v_old_plan_guidance_local_ids);

    UPDATE SCHEMANAME.elevation_position_value epv
    SET is_active = FALSE
    FROM SCHEMANAME.plan_regulation pr
    JOIN SCHEMANAME.plan_regulation_supplementary_information prsi
        ON prsi.fk_plan_regulation = pr.local_id
    JOIN SCHEMANAME.supplementary_information_elevation_position_value siepv
        ON siepv.fk_supplementary_information = prsi.fk_supplementary_information
    WHERE epv.elevation_position_value_uuid = siepv.fk_elevation_position_value
    AND pr.local_id = ANY(v_old_plan_regulation_local_ids);

    UPDATE SCHEMANAME.elevation_range_value erv
    SET is_active = FALSE
    FROM SCHEMANAME.plan_regulation_elevation_range_value prerv
    WHERE erv.elevation_range_value_uuid = prerv.fk_elevation_range_value
    AND prerv.fk_plan_regulation = ANY(v_old_plan_regulation_local_ids);

    UPDATE SCHEMANAME.elevation_range_value erv
    SET is_active = FALSE
    FROM SCHEMANAME.plan_guidance_elevation_range_value pgerv
    WHERE erv.elevation_range_value_uuid = pgerv.fk_elevation_range_value
    AND pgerv.fk_plan_guidance = ANY(v_old_plan_guidance_local_ids);

    UPDATE SCHEMANAME.elevation_range_value erv
    SET is_active = FALSE
    FROM SCHEMANAME.plan_regulation pr
    JOIN SCHEMANAME.plan_regulation_supplementary_information prsi
        ON prsi.fk_plan_regulation = pr.local_id
    JOIN SCHEMANAME.supplementary_information_elevation_range_value sierv
        ON sierv.fk_supplementary_information = prsi.fk_supplementary_information
    WHERE erv.elevation_range_value_uuid = sierv.fk_elevation_range_value
    AND pr.local_id = ANY(v_old_plan_regulation_local_ids);

    -- Activate new plan
    UPDATE SCHEMANAME.spatial_plan
    SET is_active = TRUE
    WHERE local_id = p_new_active_plan_local_id;

    UPDATE SCHEMANAME.zoning_element
    SET is_active = TRUE
    WHERE spatial_plan = p_new_active_plan_local_id;

    UPDATE SCHEMANAME.planned_space ps
    SET is_active = TRUE
    FROM SCHEMANAME.zoning_element_planned_space zeps
    JOIN SCHEMANAME.zoning_element ze
        ON ze.local_id = zeps.zoning_element_local_id
    WHERE ze.spatial_plan = p_new_active_plan_local_id
    AND ps.local_id = zeps.planned_space_local_id;

    UPDATE SCHEMANAME.planning_detail_line pdl
    SET is_active = TRUE
    FROM SCHEMANAME.zoning_element_plan_detail_line zepdl
    JOIN SCHEMANAME.zoning_element ze
        ON ze.local_id = zepdl.zoning_element_local_id
    WHERE ze.spatial_plan = p_new_active_plan_local_id
    AND pdl.local_id = zepdl.planning_detail_line_local_id;

    UPDATE SCHEMANAME.describing_line dl
    SET is_active = TRUE
    FROM SCHEMANAME.zoning_element_describing_line zedl
    JOIN SCHEMANAME.zoning_element ze
        ON ze.local_id = zedl.zoning_element_local_id
    WHERE ze.spatial_plan = p_new_active_plan_local_id
    AND dl.identifier = zedl.describing_line_id;

    UPDATE SCHEMANAME.describing_text dt
    SET is_active = TRUE
    FROM SCHEMANAME.zoning_element_describing_text zedt
    JOIN SCHEMANAME.zoning_element ze
        ON ze.local_id = zedt.zoning_element_local_id
    WHERE ze.spatial_plan = p_new_active_plan_local_id
    AND dt.identifier = zedt.describing_text_id;

    SELECT ARRAY(SELECT SCHEMANAME.get_plan_regulation_local_ids(p_old_active_plan_local_id))
    INTO v_new_plan_regulation_local_ids;

    SELECT ARRAY(SELECT SCHEMANAME.get_plan_guidance_local_ids(p_old_active_plan_local_id))
    INTO v_new_plan_guidance_local_ids;

    UPDATE SCHEMANAME.geometry_area_value gav
    SET is_active = TRUE
    FROM SCHEMANAME.plan_regulation_geometry_area_value prgav
    WHERE gav.geometry_area_value_uuid = prgav.fk_geometry_area_value
    AND prgav.fk_plan_regulation = ANY(v_new_plan_regulation_local_ids);

    UPDATE SCHEMANAME.geometry_area_value gav
    SET is_active = TRUE
    FROM SCHEMANAME.plan_guidance_geometry_area_value pggav
    WHERE gav.geometry_area_value_uuid = pggav.fk_geometry_area_value
    AND pggav.fk_plan_guidance = ANY(v_new_plan_guidance_local_ids);

    UPDATE SCHEMANAME.geometry_area_value gav
    SET is_active = TRUE
    FROM SCHEMANAME.plan_regulation pr
    JOIN SCHEMANAME.plan_regulation_supplementary_information prsi
        ON prsi.fk_plan_regulation = pr.local_id
    JOIN SCHEMANAME.supplementary_information_geometry_area_value sigav
        ON sigav.fk_supplementary_information = prsi.fk_supplementary_information
    WHERE gav.geometry_area_value_uuid = sigav.fk_geometry_area_value
    AND pr.local_id = ANY(v_new_plan_regulation_local_ids);

    UPDATE SCHEMANAME.geometry_line_value glv
    SET is_active = TRUE
    FROM SCHEMANAME.plan_regulation_geometry_line_value prglv
    WHERE glv.geometry_line_value_uuid = prglv.fk_geometry_line_value
    AND prglv.fk_plan_regulation = ANY(v_new_plan_regulation_local_ids);

    UPDATE SCHEMANAME.geometry_line_value glv
    SET is_active = TRUE
    FROM SCHEMANAME.plan_guidance_geometry_line_value pgglv
    WHERE glv.geometry_line_value_uuid = pgglv.fk_geometry_line_value
    AND pgglv.fk_plan_guidance = ANY(v_new_plan_guidance_local_ids);

    UPDATE SCHEMANAME.geometry_line_value glv
    SET is_active = TRUE
    FROM SCHEMANAME.plan_regulation pr
    JOIN SCHEMANAME.plan_regulation_supplementary_information prsi
        ON prsi.fk_plan_regulation = pr.local_id
    JOIN SCHEMANAME.supplementary_information_geometry_line_value siglv
        ON siglv.fk_supplementary_information = prsi.fk_supplementary_information
    WHERE glv.geometry_line_value_uuid = siglv.fk_geometry_line_value
    AND pr.local_id = ANY(v_new_plan_regulation_local_ids);

    UPDATE SCHEMANAME.geometry_point_value gpv
    SET is_active = TRUE
    FROM SCHEMANAME.plan_regulation_geometry_point_value prgpv
    WHERE gpv.geometry_point_value_uuid = prgpv.fk_geometry_point_value
    AND prgpv.fk_plan_regulation = ANY(v_new_plan_regulation_local_ids);

    UPDATE SCHEMANAME.geometry_point_value gpv
    SET is_active = TRUE
    FROM SCHEMANAME.plan_guidance_geometry_point_value pggpv
    WHERE gpv.geometry_point_value_uuid = pggpv.fk_geometry_point_value
    AND pggpv.fk_plan_guidance = ANY(v_new_plan_guidance_local_ids);

    UPDATE SCHEMANAME.geometry_point_value gpv
    SET is_active = TRUE
    FROM SCHEMANAME.plan_regulation pr
    JOIN SCHEMANAME.plan_regulation_supplementary_information prsi
        ON prsi.fk_plan_regulation = pr.local_id
    JOIN SCHEMANAME.supplementary_information_geometry_point_value sigpv
        ON sigpv.fk_supplementary_information = prsi.fk_supplementary_information
    WHERE gpv.geometry_point_value_uuid = sigpv.fk_geometry_point_value
    AND pr.local_id = ANY(v_new_plan_regulation_local_ids);

    UPDATE SCHEMANAME.elevation_position_value epv
    SET is_active = TRUE
    FROM SCHEMANAME.plan_regulation_elevation_position_value prepv
    WHERE epv.elevation_position_value_uuid = prepv.fk_elevation_position_value
    AND prepv.fk_plan_regulation = ANY(v_new_plan_regulation_local_ids);

    UPDATE SCHEMANAME.elevation_position_value epv
    SET is_active = TRUE
    FROM SCHEMANAME.plan_guidance_elevation_position_value pgepv
    WHERE epv.elevation_position_value_uuid = pgepv.fk_elevation_position_value
    AND pgepv.fk_plan_guidance = ANY(v_new_plan_guidance_local_ids);

    UPDATE SCHEMANAME.elevation_position_value epv
    SET is_active = TRUE
    FROM SCHEMANAME.plan_regulation pr
    JOIN SCHEMANAME.plan_regulation_supplementary_information prsi
        ON prsi.fk_plan_regulation = pr.local_id
    JOIN SCHEMANAME.supplementary_information_elevation_position_value siepv
        ON siepv.fk_supplementary_information = prsi.fk_supplementary_information
    WHERE epv.elevation_position_value_uuid = siepv.fk_elevation_position_value
    AND pr.local_id = ANY(v_new_plan_regulation_local_ids);

    UPDATE SCHEMANAME.elevation_range_value erv
    SET is_active = TRUE
    FROM SCHEMANAME.plan_regulation_elevation_range_value prerv
    WHERE erv.elevation_range_value_uuid = prerv.fk_elevation_range_value
    AND prerv.fk_plan_regulation = ANY(v_new_plan_regulation_local_ids);

    UPDATE SCHEMANAME.elevation_range_value erv
    SET is_active = TRUE
    FROM SCHEMANAME.plan_guidance_elevation_range_value pgerv
    WHERE erv.elevation_range_value_uuid = pgerv.fk_elevation_range_value
    AND pgerv.fk_plan_guidance = ANY(v_new_plan_guidance_local_ids);

    UPDATE SCHEMANAME.elevation_range_value erv
    SET is_active = TRUE
    FROM SCHEMANAME.plan_regulation pr
    JOIN SCHEMANAME.plan_regulation_supplementary_information prsi
        ON prsi.fk_plan_regulation = pr.local_id
    JOIN SCHEMANAME.supplementary_information_elevation_range_value sierv
        ON sierv.fk_supplementary_information = prsi.fk_supplementary_information
    WHERE erv.elevation_range_value_uuid = sierv.fk_elevation_range_value
    AND pr.local_id = ANY(v_new_plan_regulation_local_ids);
END;
$$ LANGUAGE plpgsql;
