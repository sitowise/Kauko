-- Index: sidx_describing_line_geom

-- DROP INDEX IF EXISTS $SCHEMANAME$.sidx_describing_line_geom;

CREATE INDEX IF NOT EXISTS sidx_describing_line_geom
    ON $SCHEMANAME$.describing_line USING gist
    (geom)
    TABLESPACE pg_default;


-- Index: sidx_describing_text_geom

-- DROP INDEX IF EXISTS $SCHEMANAME$.sidx_describing_text_geom;

CREATE INDEX IF NOT EXISTS sidx_describing_text_geom
    ON $SCHEMANAME$.describing_text USING gist
    (geom)
    TABLESPACE pg_default;



-- Index: sidx_elevation_position_value_geom

-- DROP INDEX IF EXISTS $SCHEMANAME$.sidx_elevation_position_value_geom;

CREATE INDEX IF NOT EXISTS sidx_elevation_position_value_geom
    ON $SCHEMANAME$.elevation_position_value USING gist
    (reference_point)
    TABLESPACE pg_default;


-- Index: sidx_elevation_range_value_geom

-- DROP INDEX IF EXISTS $SCHEMANAME$.sidx_elevation_range_value_geom;

CREATE INDEX IF NOT EXISTS sidx_elevation_range_value_geom
    ON $SCHEMANAME$.elevation_range_value USING gist
    (reference_point)
    TABLESPACE pg_default;


-- Index: sidx_geometry_area_value_geom

-- DROP INDEX IF EXISTS $SCHEMANAME$.sidx_geometry_area_value_geom;

CREATE INDEX IF NOT EXISTS sidx_geometry_area_value_geom
    ON $SCHEMANAME$.geometry_area_value USING gist
    (value)
    TABLESPACE pg_default;



-- Index: sidx_geometry_line_value_geom

-- DROP INDEX IF EXISTS $SCHEMANAME$.sidx_geometry_line_value_geom;

CREATE INDEX IF NOT EXISTS sidx_geometry_line_value_geom
    ON $SCHEMANAME$.geometry_line_value USING gist
    (value)
    TABLESPACE pg_default;


-- Index: sidx_geometry_point_value_geom

-- DROP INDEX IF EXISTS $SCHEMANAME$.sidx_geometry_point_value_geom;

CREATE INDEX IF NOT EXISTS sidx_geometry_point_value_geom
    ON $SCHEMANAME$.geometry_point_value USING gist
    (value)
    TABLESPACE pg_default;


-- Index: sidx_planned_space_geom

-- DROP INDEX IF EXISTS $SCHEMANAME$.sidx_planned_space_geom;

CREATE INDEX IF NOT EXISTS sidx_planned_space_geom
    ON $SCHEMANAME$.planned_space USING gist
    (geom)
    TABLESPACE pg_default;


-- Index: sidx_planning_detail_line_geom

-- DROP INDEX IF EXISTS $SCHEMANAME$.sidx_planning_detail_line_geom;

CREATE INDEX IF NOT EXISTS sidx_planning_detail_line_geom
    ON $SCHEMANAME$.planning_detail_line USING gist
    (geom)
    TABLESPACE pg_default;


-- Index: active_version_idx

-- DROP INDEX IF EXISTS $SCHEMANAME$.active_version_idx;

CREATE UNIQUE INDEX IF NOT EXISTS active_version_idx
    ON $SCHEMANAME$.spatial_plan USING btree
    (identity_id ASC NULLS LAST)
    TABLESPACE pg_default
    WHERE is_active;
-- Index: sidx_spatial_plan_geom

-- DROP INDEX IF EXISTS $SCHEMANAME$.sidx_spatial_plan_geom;

CREATE INDEX IF NOT EXISTS sidx_spatial_plan_geom
    ON $SCHEMANAME$.spatial_plan USING gist
    (geom)
    TABLESPACE pg_default;


-- Index: sidx_zoning_element_geom

-- DROP INDEX IF EXISTS $SCHEMANAME$.sidx_zoning_element_geom;

CREATE INDEX IF NOT EXISTS sidx_zoning_element_geom
    ON $SCHEMANAME$.zoning_element USING gist
    (geom)
    TABLESPACE pg_default;

