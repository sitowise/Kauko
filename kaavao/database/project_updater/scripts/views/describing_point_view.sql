DROP VIEW IF EXISTS SCHEMANAME.describing_point_view;

CREATE OR REPLACE VIEW SCHEMANAME.describing_point_view AS
(
    Select Distinct
        describing_text.identifier,
        describing_text.created,
        spatial_plan.land_administration_authority::Integer As municipality_db_code,
        describing_text.geom,
        describing_text."text",
        Case
            When describing_text.label_x Is Not Null
            Then describing_text.label_x
            Else ST_X(describing_text.geom)
        End As label_x,
        Case
            When describing_text.label_y Is Not Null
            Then describing_text.label_y
            Else ST_Y(describing_text.geom)
        End As label_y,
        Case
            When describing_text.label_x Is Not Null
            Then describing_text.label_x - ST_X(describing_text.geom)
            Else 0
        End As label_displacement_x,
        Case
            When describing_text.label_y Is Not Null
            Then describing_text.label_y - ST_Y(describing_text.geom)
            Else 0
        End As label_displacement_y,
        Case
            When describing_text.label_rotation Is Not Null
            Then Round(describing_text.label_rotation::Numeric, 2)::Float8
            Else 0
        End As label_rotation,
        describing_text.callouts,
        Case
            When describing_text.callouts Is True And describing_text.label_x Is
                Not Null And describing_text.label_y Is Not Null
            Then ST_MakeLine(describing_text.geom,
                St_SetSRID(ST_Point(describing_text.label_x,
                describing_text.label_y), ST_SRID(describing_text.geom)))
            Else Null
        End As callout_geom,
        describing_text.big_letters,
        describing_text.validity,
        validity_type.value As validity_fi,
        Null As validity_sv
    From
        SCHEMANAME.spatial_plan Inner Join
        SCHEMANAME.zoning_element On SCHEMANAME.zoning_element.fk_spatial_plan =
                SCHEMANAME.spatial_plan.planning_object_identifier Inner Join
        SCHEMANAME.zoning_element_describing_text On SCHEMANAME.zoning_element_describing_text.zoning_id
                = SCHEMANAME.zoning_element.planning_object_identifier Inner Join
        SCHEMANAME.describing_text On SCHEMANAME.zoning_element_describing_text.describing_text_id =
                SCHEMANAME.describing_text.identifier Inner Join
        code_lists.validity_type On code_lists.validity_type.value =
                SCHEMANAME.describing_text.validity
    Where
        spatial_plan.is_released Is True
);

