UPDATE code_lists.detail_plan_regulation_kind SET sub_class = codevalue
WHERE coalesce(sub_class, '') = '';
