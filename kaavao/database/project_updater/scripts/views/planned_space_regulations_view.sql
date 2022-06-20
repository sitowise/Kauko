DROP VIEW IF EXISTS SCHEMANAME.planned_space_regulations_view;

CREATE VIEW SCHEMANAME.planned_space_regulations_view AS
Select
    Row_Number() Over () As id,
    regulation_type.description As type,
    SCHEMANAME.regulative_text.description_fi As regulation_fi,
    SCHEMANAME.regulative_text.description_se As regulation_sv,
    code_lists.validity_type.description As validity,
    SCHEMANAME.planned_space.identifier As planned_space_id
From
    code_lists.finnish_regulative_text_type regulation_type Inner Join
    SCHEMANAME.regulative_text On SCHEMANAME.regulative_text.type = regulation_type.value Inner Join
    code_lists.validity_type On SCHEMANAME.regulative_text.validity = code_lists.validity_type.value Inner Join
    SCHEMANAME.planned_space_regulation On SCHEMANAME.regulative_text.regulative_id =
            SCHEMANAME.planned_space_regulation.planned_space_id Inner Join
    SCHEMANAME.planned_space On SCHEMANAME.planned_space.planning_object_identifier =
            SCHEMANAME.planned_space_regulation.planned_space_id;