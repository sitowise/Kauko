DROP VIEW IF EXISTS SCHEMANAME.spatial_plan_regulations_view;

CREATE VIEW SCHEMANAME.spatial_plan_regulations_view AS
Select
    Row_Number() Over () As id,
    regulation_type.description As type,
    SCHEMANAME.regulative_text.description_fi As regulation_fi,
    SCHEMANAME.regulative_text.description_se As regulation_sv,
    code_lists.validity_type.description As validity,
    SCHEMANAME.spatial_plan.identifier As spatial_plan_id
From
    code_lists.finnish_regulative_text_type regulation_type Inner Join
    SCHEMANAME.regulative_text On SCHEMANAME.regulative_text.type = regulation_type.value Inner Join
    SCHEMANAME.spatial_plan_regulation On SCHEMANAME.spatial_plan_regulation.regulative_id =
            SCHEMANAME.regulative_text.regulative_id Inner Join
    code_lists.validity_type On SCHEMANAME.regulative_text.validity = code_lists.validity_type.value Inner Join
    SCHEMANAME.spatial_plan On SCHEMANAME.spatial_plan.planning_object_identifier =
            SCHEMANAME.spatial_plan_regulation.spatial_plan_id;