CREATE OR REPLACE FUNCTION SCHEMANAME.refresh_plan_regulations_point_view()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
    BEGIN REFRESH MATERIALIZED VIEW SCHEMANAME.plan_regulations_point_view;
    RETURN NULL;
END $$;
-- when regulation type changes:
CREATE TRIGGER plan_regulation_refresh_point_view
AFTER
INSERT
    OR
UPDATE
    OR DELETE ON SCHEMANAME.plan_regulation FOR EACH ROW
    WHEN (
        old.type IS DISTINCT
        FROM new.type
    ) EXECUTE PROCEDURE SCHEMANAME.refresh_plan_regulations_point_view();
-- when geometries change:
CREATE TRIGGER geometry_point_value_refresh_point_view
AFTER
INSERT
    OR
UPDATE
    OR DELETE ON SCHEMANAME.geometry_point_value FOR EACH ROW
    WHEN (
        old.value IS DISTINCT
        FROM new.value
    ) EXECUTE PROCEDURE SCHEMANAME.refresh_plan_regulations_point_view();
-- when values are linked to regulations:
CREATE TRIGGER plan_regulation_geometry_point_value_refresh_point_view
AFTER
UPDATE
    OR
INSERT
    OR DELETE ON SCHEMANAME.plan_regulation_geometry_point_value FOR EACH STATEMENT EXECUTE PROCEDURE SCHEMANAME.refresh_plan_regulations_point_view();
CREATE TRIGGER plan_regulation_text_value_refresh_line_view
AFTER
UPDATE
    OR
INSERT
    OR DELETE ON SCHEMANAME.plan_regulation_text_value FOR EACH STATEMENT EXECUTE PROCEDURE SCHEMANAME.refresh_plan_regulations_line_view();
CREATE TRIGGER plan_regulation_numeric_double_value_refresh_line_view
AFTER
UPDATE
    OR
INSERT
    OR DELETE ON SCHEMANAME.plan_regulation_numeric_double_value FOR EACH STATEMENT EXECUTE PROCEDURE SCHEMANAME.refresh_plan_regulations_line_view();
CREATE TRIGGER plan_regulation_numeric_range_refresh_line_view
AFTER
UPDATE
    OR
INSERT
    OR DELETE ON SCHEMANAME.plan_regulation_numeric_range FOR EACH STATEMENT EXECUTE PROCEDURE SCHEMANAME.refresh_plan_regulations_line_view();
CREATE TRIGGER plan_regulation_code_value_refresh_line_view
AFTER
UPDATE
    OR
INSERT
    OR DELETE ON SCHEMANAME.plan_regulation_code_value FOR EACH STATEMENT EXECUTE PROCEDURE SCHEMANAME.refresh_plan_regulations_line_view();
-- when supplementary informations change:
CREATE TRIGGER supplementary_information_refresh_line_view
AFTER
UPDATE
    OR
INSERT
    OR DELETE ON SCHEMANAME.supplementary_information FOR EACH STATEMENT EXECUTE PROCEDURE SCHEMANAME.refresh_plan_regulations_line_view();
-- when values are linked to supplementary informations:
CREATE TRIGGER supplementary_information_numeric_range_refresh_line_view
AFTER
UPDATE
    OR
INSERT
    OR DELETE ON SCHEMANAME.supplementary_information_numeric_range FOR EACH STATEMENT EXECUTE PROCEDURE SCHEMANAME.refresh_plan_regulations_line_view();
-- when values change:
CREATE TRIGGER text_value_refresh_line_view
AFTER
UPDATE
    OR
INSERT
    OR DELETE ON SCHEMANAME.text_value FOR EACH STATEMENT EXECUTE PROCEDURE SCHEMANAME.refresh_plan_regulations_line_view();
CREATE TRIGGER numeric_double_value_refresh_line_view
AFTER
UPDATE
    OR
INSERT
    OR DELETE ON SCHEMANAME.numeric_double_value FOR EACH STATEMENT EXECUTE PROCEDURE SCHEMANAME.refresh_plan_regulations_line_view();
CREATE TRIGGER numeric_range_refresh_line_view
AFTER
UPDATE
    OR
INSERT
    OR DELETE ON SCHEMANAME.numeric_range FOR EACH STATEMENT EXECUTE PROCEDURE SCHEMANAME.refresh_plan_regulations_line_view();
CREATE TRIGGER code_value_refresh_line_view
AFTER
UPDATE
    OR
INSERT
    OR DELETE ON SCHEMANAME.code_value FOR EACH STATEMENT EXECUTE PROCEDURE SCHEMANAME.refresh_plan_regulations_line_view();


CREATE OR REPLACE FUNCTION SCHEMANAME.refresh_plan_regulations_line_view()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN REFRESH MATERIALIZED VIEW SCHEMANAME.plan_regulations_line_view;
RETURN NULL;
END $$;
-- when regulation type changes:
CREATE TRIGGER plan_regulation_refresh_line_view
AFTER
INSERT
    OR
UPDATE
    OR DELETE ON SCHEMANAME.plan_regulation FOR EACH ROW
    WHEN (
        old.type IS DISTINCT
        FROM new.type
    ) EXECUTE PROCEDURE SCHEMANAME.refresh_plan_regulations_line_view();
-- when geometries change:
CREATE TRIGGER planning_detail_line_refresh_line_view
AFTER
INSERT
    OR
UPDATE
    OR DELETE ON SCHEMANAME.planning_detail_line FOR EACH ROW
    WHEN (
        old.geom IS DISTINCT
        FROM new.geom
    ) EXECUTE PROCEDURE SCHEMANAME.refresh_plan_regulations_line_view();
CREATE TRIGGER geometry_line_value_refresh_line_view
AFTER
INSERT
    OR
UPDATE
    OR DELETE ON SCHEMANAME.geometry_line_value FOR EACH ROW
    WHEN (
        old.value IS DISTINCT
        FROM new.value
    ) EXECUTE PROCEDURE SCHEMANAME.refresh_plan_regulations_line_view();
-- when regulations are linked to geometries:
CREATE TRIGGER planning_detail_line_plan_regulation_refresh_line_view
AFTER
UPDATE
    OR
INSERT
    OR DELETE ON SCHEMANAME.planning_detail_line_plan_regulation FOR EACH STATEMENT EXECUTE PROCEDURE SCHEMANAME.refresh_plan_regulations_line_view();
-- when values are linked to regulations:
CREATE TRIGGER plan_regulation_geometry_line_value_refresh_line_view
AFTER
UPDATE
    OR
INSERT
    OR DELETE ON SCHEMANAME.plan_regulation_geometry_line_value FOR EACH STATEMENT EXECUTE PROCEDURE SCHEMANAME.refresh_plan_regulations_line_view();
CREATE TRIGGER plan_regulation_text_value_refresh_line_view
AFTER
UPDATE
    OR
INSERT
    OR DELETE ON SCHEMANAME.plan_regulation_text_value FOR EACH STATEMENT EXECUTE PROCEDURE SCHEMANAME.refresh_plan_regulations_line_view();
CREATE TRIGGER plan_regulation_numeric_double_value_refresh_line_view
AFTER
UPDATE
    OR
INSERT
    OR DELETE ON SCHEMANAME.plan_regulation_numeric_double_value FOR EACH STATEMENT EXECUTE PROCEDURE SCHEMANAME.refresh_plan_regulations_line_view();
CREATE TRIGGER plan_regulation_numeric_range_refresh_line_view
AFTER
UPDATE
    OR
INSERT
    OR DELETE ON SCHEMANAME.plan_regulation_numeric_range FOR EACH STATEMENT EXECUTE PROCEDURE SCHEMANAME.refresh_plan_regulations_line_view();
CREATE TRIGGER plan_regulation_code_value_refresh_line_view
AFTER
UPDATE
    OR
INSERT
    OR DELETE ON SCHEMANAME.plan_regulation_code_value FOR EACH STATEMENT EXECUTE PROCEDURE SCHEMANAME.refresh_plan_regulations_line_view();
-- when supplementary informations change:
CREATE TRIGGER supplementary_information_refresh_line_view
AFTER
UPDATE
    OR
INSERT
    OR DELETE ON SCHEMANAME.supplementary_information FOR EACH STATEMENT EXECUTE PROCEDURE SCHEMANAME.refresh_plan_regulations_line_view();
-- when values are linked to supplementary informations:
CREATE TRIGGER supplementary_information_numeric_range_refresh_line_view
AFTER
UPDATE
    OR
INSERT
    OR DELETE ON SCHEMANAME.supplementary_information_numeric_range FOR EACH STATEMENT EXECUTE PROCEDURE SCHEMANAME.refresh_plan_regulations_line_view();
-- when values change:
CREATE TRIGGER text_value_refresh_line_view
AFTER
UPDATE
    OR
INSERT
    OR DELETE ON SCHEMANAME.text_value FOR EACH STATEMENT EXECUTE PROCEDURE SCHEMANAME.refresh_plan_regulations_line_view();
CREATE TRIGGER numeric_double_value_refresh_line_view
AFTER
UPDATE
    OR
INSERT
    OR DELETE ON SCHEMANAME.numeric_double_value FOR EACH STATEMENT EXECUTE PROCEDURE SCHEMANAME.refresh_plan_regulations_line_view();
CREATE TRIGGER numeric_range_refresh_line_view
AFTER
UPDATE
    OR
INSERT
    OR DELETE ON SCHEMANAME.numeric_range FOR EACH STATEMENT EXECUTE PROCEDURE SCHEMANAME.refresh_plan_regulations_line_view();
CREATE TRIGGER code_value_refresh_line_view
AFTER
UPDATE
    OR
INSERT
    OR DELETE ON SCHEMANAME.code_value FOR EACH STATEMENT EXECUTE PROCEDURE SCHEMANAME.refresh_plan_regulations_line_view();


CREATE OR REPLACE FUNCTION SCHEMANAME.refresh_plan_regulations_area_view()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN REFRESH MATERIALIZED VIEW SCHEMANAME.plan_regulations_area_view;
RETURN NULL;
END $$;
-- when regulation type changes:
CREATE TRIGGER plan_regulation_refresh_area_view
AFTER
INSERT
    OR
UPDATE
    OR DELETE ON SCHEMANAME.plan_regulation FOR EACH ROW
    WHEN (
        old.type IS DISTINCT
        FROM new.type
    ) EXECUTE PROCEDURE SCHEMANAME.refresh_plan_regulations_area_view();
-- when geometries change:
CREATE TRIGGER spatial_plan_refresh_area_view
AFTER
INSERT
    OR
UPDATE
    OR DELETE ON SCHEMANAME.spatial_plan FOR EACH ROW
    WHEN (
        old.geom IS DISTINCT
        FROM new.geom
    ) EXECUTE PROCEDURE SCHEMANAME.refresh_plan_regulations_area_view();
CREATE TRIGGER zoning_element_refresh_area_view
AFTER
INSERT
    OR
UPDATE
    OR DELETE ON SCHEMANAME.zoning_element FOR EACH ROW
    WHEN (
        old.geom IS DISTINCT
        FROM new.geom
    ) EXECUTE PROCEDURE SCHEMANAME.refresh_plan_regulations_area_view();
CREATE TRIGGER planned_space_refresh_area_view
AFTER
INSERT
    OR
UPDATE
    OR DELETE ON SCHEMANAME.planned_space FOR EACH ROW
    WHEN (
        old.geom IS DISTINCT
        FROM new.geom
    ) EXECUTE PROCEDURE SCHEMANAME.refresh_plan_regulations_area_view();
CREATE TRIGGER geometry_area_value_refresh_area_view
AFTER
INSERT
    OR
UPDATE
    OR DELETE ON SCHEMANAME.geometry_area_value FOR EACH ROW
    WHEN (
        old.value IS DISTINCT
        FROM new.value
    ) EXECUTE PROCEDURE SCHEMANAME.refresh_plan_regulations_area_view();
-- when regulations are linked to geometries:
CREATE TRIGGER spatial_plan_plan_regulation_refresh_area_view
AFTER
UPDATE
    OR
INSERT
    OR DELETE ON SCHEMANAME.spatial_plan_plan_regulation FOR EACH STATEMENT EXECUTE PROCEDURE SCHEMANAME.refresh_plan_regulations_area_view();
CREATE TRIGGER zoning_element_plan_regulation_refresh_area_view
AFTER
UPDATE
    OR
INSERT
    OR DELETE ON SCHEMANAME.zoning_element_plan_regulation FOR EACH STATEMENT EXECUTE PROCEDURE SCHEMANAME.refresh_plan_regulations_area_view();
CREATE TRIGGER planned_space_plan_regulation_refresh_area_view
AFTER
UPDATE
    OR
INSERT
    OR DELETE ON SCHEMANAME.planned_space_plan_regulation FOR EACH STATEMENT EXECUTE PROCEDURE SCHEMANAME.refresh_plan_regulations_area_view();
-- when values are linked to regulations:
CREATE TRIGGER plan_regulation_geometry_area_value_refresh_area_view
AFTER
UPDATE
    OR
INSERT
    OR DELETE ON SCHEMANAME.plan_regulation_geometry_area_value FOR EACH STATEMENT EXECUTE PROCEDURE SCHEMANAME.refresh_plan_regulations_area_view();
CREATE TRIGGER plan_regulation_text_value_refresh_area_view
AFTER
UPDATE
    OR
INSERT
    OR DELETE ON SCHEMANAME.plan_regulation_text_value FOR EACH STATEMENT EXECUTE PROCEDURE SCHEMANAME.refresh_plan_regulations_area_view();
CREATE TRIGGER plan_regulation_numeric_double_value_refresh_area_view
AFTER
UPDATE
    OR
INSERT
    OR DELETE ON SCHEMANAME.plan_regulation_numeric_double_value FOR EACH STATEMENT EXECUTE PROCEDURE SCHEMANAME.refresh_plan_regulations_area_view();
CREATE TRIGGER plan_regulation_numeric_range_refresh_area_view
AFTER
UPDATE
    OR
INSERT
    OR DELETE ON SCHEMANAME.plan_regulation_numeric_range FOR EACH STATEMENT EXECUTE PROCEDURE SCHEMANAME.refresh_plan_regulations_area_view();
CREATE TRIGGER plan_regulation_code_value_refresh_area_view
AFTER
UPDATE
    OR
INSERT
    OR DELETE ON SCHEMANAME.plan_regulation_code_value FOR EACH STATEMENT EXECUTE PROCEDURE SCHEMANAME.refresh_plan_regulations_area_view();
-- when supplementary informations change:
CREATE TRIGGER supplementary_information_refresh_area_view
AFTER
UPDATE
    OR
INSERT
    OR DELETE ON SCHEMANAME.supplementary_information FOR EACH STATEMENT EXECUTE PROCEDURE SCHEMANAME.refresh_plan_regulations_area_view();
-- when values are linked to supplementary informations:
CREATE TRIGGER supplementary_information_numeric_range_refresh_area_view
AFTER
UPDATE
    OR
INSERT
    OR DELETE ON SCHEMANAME.supplementary_information_numeric_range FOR EACH STATEMENT EXECUTE PROCEDURE SCHEMANAME.refresh_plan_regulations_area_view();
-- when values change:
CREATE TRIGGER text_value_refresh_area_view
AFTER
UPDATE
    OR
INSERT
    OR DELETE ON SCHEMANAME.text_value FOR EACH STATEMENT EXECUTE PROCEDURE SCHEMANAME.refresh_plan_regulations_area_view();
CREATE TRIGGER numeric_double_value_refresh_area_view
AFTER
UPDATE
    OR
INSERT
    OR DELETE ON SCHEMANAME.numeric_double_value FOR EACH STATEMENT EXECUTE PROCEDURE SCHEMANAME.refresh_plan_regulations_area_view();
CREATE TRIGGER numeric_range_refresh_area_view
AFTER
UPDATE
    OR
INSERT
    OR DELETE ON SCHEMANAME.numeric_range FOR EACH STATEMENT EXECUTE PROCEDURE SCHEMANAME.refresh_plan_regulations_area_view();
CREATE TRIGGER code_value_refresh_area_view
AFTER
UPDATE
    OR
INSERT
    OR DELETE ON SCHEMANAME.code_value FOR EACH STATEMENT EXECUTE PROCEDURE SCHEMANAME.refresh_plan_regulations_area_view();
