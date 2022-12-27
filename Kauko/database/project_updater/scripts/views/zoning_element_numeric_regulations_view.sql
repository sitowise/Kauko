DROP VIEW IF EXISTS SCHEMANAME.zoning_element_numeric_regulations_view;

CREATE VIEW SCHEMANAME.zoning_element_numeric_regulations_view AS (
    Select
        Row_Number() Over () As id,
        SCHEMANAME.numeric_value.localized_name,
        SCHEMANAME.numeric_value.value,
        numeric_value_type.description As numeric_type,
        area_type.description As area_type,
        Case
            When SCHEMANAME.numeric_value.obligatory Is True
            Then 'Sitova'::Text
            Else 'Ei sitova'::Text
        End As obligatory,
        SCHEMANAME.numeric_value.description_fi As description_fi,
        SCHEMANAME.numeric_value.description_se As description_sv,
        SCHEMANAME.zoning_element.identifier As zoning_element_id
    From
        SCHEMANAME.numeric_value Inner Join
        code_lists.finnish_numeric_value numeric_value_type On SCHEMANAME.numeric_value.value_type =
                numeric_value_type.value Inner Join
        code_lists.finnish_area_type area_type On SCHEMANAME.numeric_value.target_type = area_type.value
        Inner Join
        SCHEMANAME.zoning_element_numeric_value On SCHEMANAME.zoning_element_numeric_value.numeric_id =
                SCHEMANAME.numeric_value.numeric_value_id Inner Join
        SCHEMANAME.zoning_element On SCHEMANAME.zoning_element_numeric_value.zoning_id =
                SCHEMANAME.zoning_element.planning_object_identifier
);