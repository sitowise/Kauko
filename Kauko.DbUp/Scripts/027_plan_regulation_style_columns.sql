-- Add style column

ALTER TABLE $SCHEMANAME$.zoning_element
    ADD style text,
    ADD CONSTRAINT zoning_element_style_fkey FOREIGN KEY (style)
    REFERENCES code_lists.plan_regulation_theme_style (codevalue) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE NO ACTION
        DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE code_lists.detail_plan_regulation_kind
    ADD style text,
    ADD CONSTRAINT detail_plan_regulation_kind_style_fkey FOREIGN KEY (style)
    REFERENCES code_lists.plan_regulation_theme_style (codevalue) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE RESTRICT;

-- Add styles for detail_plan_regulation_kind
-- TODO
