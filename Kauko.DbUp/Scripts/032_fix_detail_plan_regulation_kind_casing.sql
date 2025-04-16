-- Fix casiong in trigger
DROP TRIGGER upsert_url_detail_plan_regulation_kind
  ON code_lists.detail_plan_regulation_kind;

CREATE TRIGGER upsert_url_detail_plan_regulation_kind
  BEFORE INSERT OR UPDATE
  ON code_lists.detail_plan_regulation_kind
  FOR EACH ROW
  EXECUTE FUNCTION code_lists.code_url_trigger(
    'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/'
  );


-- Fix uri casing in detail_plan_regulation_kind using trigger
UPDATE code_lists.detail_plan_regulation_kind
    SET codevalue = codevalue;
