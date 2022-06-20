DROP VIEW IF EXISTS SCHEMANAME.planning_detail_line_numeric_regulations_view;

CREATE VIEW SCHEMANAME.planning_detail_line_numeric_regulations_view AS
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
SCHEMANAME.planning_detail_line.identifier As planning_detail_line_id
From
SCHEMANAME.numeric_value Inner Join
code_lists.finnish_numeric_value numeric_value_type On SCHEMANAME.numeric_value.value_type =
        numeric_value_type.value Inner Join
code_lists.finnish_area_type area_type On SCHEMANAME.numeric_value.target_type = area_type.value Inner Join
SCHEMANAME.planning_detail_line_numeric_value On SCHEMANAME.numeric_value.numeric_value_id =
        SCHEMANAME.planning_detail_line_numeric_value.numeric_id Inner Join
SCHEMANAME.planning_detail_line On SCHEMANAME.planning_detail_line.planning_object_identifier =
        SCHEMANAME.planning_detail_line_numeric_value.planning_detail_line_id;