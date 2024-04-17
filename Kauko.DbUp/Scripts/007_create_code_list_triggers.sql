-- FUNCTION: code_lists.code_url_trigger()

-- DROP FUNCTION IF EXISTS code_lists.code_url_trigger();

CREATE OR REPLACE FUNCTION code_lists.code_url_trigger()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$

  BEGIN
    IF TG_NARGS > 1 THEN
      RAISE EXCEPTION 'Too many arguments on code_url_trigger';
    END IF;
    NEW.uri := TG_ARGV[0] || NEW.codevalue;
    RETURN NEW;
  END;
$BODY$;

-- Trigger: upsert_url_detail_plan_regulation_kind

-- DROP TRIGGER IF EXISTS upsert_url_detail_plan_regulation_kind ON code_lists.detail_plan_regulation_kind;

CREATE OR REPLACE TRIGGER upsert_url_detail_plan_regulation_kind
    BEFORE INSERT OR UPDATE 
    ON code_lists.detail_plan_regulation_kind
    FOR EACH ROW
    EXECUTE FUNCTION code_lists.code_url_trigger('http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/');
	

-- Trigger: upsert_master_plan_regulation_kind

-- DROP TRIGGER IF EXISTS upsert_master_plan_regulation_kind ON code_lists.master_plan_regulation_kind;

CREATE OR REPLACE TRIGGER upsert_master_plan_regulation_kind
    BEFORE INSERT OR UPDATE 
    ON code_lists.master_plan_regulation_kind
    FOR EACH ROW
    EXECUTE FUNCTION code_lists.code_url_trigger('http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/');
	

-- Trigger: upsert_url_spatial_plan_lifecycle_status

-- DROP TRIGGER IF EXISTS upsert_url_spatial_plan_lifecycle_status ON code_lists.spatial_plan_lifecycle_status;

CREATE OR REPLACE TRIGGER upsert_url_spatial_plan_lifecycle_status
    BEFORE INSERT OR UPDATE 
    ON code_lists.spatial_plan_lifecycle_status
    FOR EACH ROW
    EXECUTE FUNCTION code_lists.code_url_trigger('http://uri.suomi.fi/codelist/rytj/RY_KaavanElinkaaritila/code/');
	
-- Trigger: upsert_url_bindingness_kind

-- DROP TRIGGER IF EXISTS upsert_url_bindingness_kind ON code_lists.bindingness_kind;

CREATE OR REPLACE TRIGGER upsert_url_bindingness_kind
    BEFORE INSERT OR UPDATE 
    ON code_lists.bindingness_kind
    FOR EACH ROW
    EXECUTE FUNCTION code_lists.code_url_trigger('http://uri.suomi.fi/codelist/rytj/RY_Sitovuuslaji/code/');
	
-- Trigger: upsert_url_detail_plan_addition_information_kind

-- DROP TRIGGER IF EXISTS upsert_url_detail_plan_addition_information_kind ON code_lists.detail_plan_addition_information_kind;

CREATE OR REPLACE TRIGGER upsert_url_detail_plan_addition_information_kind
    BEFORE INSERT OR UPDATE 
    ON code_lists.detail_plan_addition_information_kind
    FOR EACH ROW
    EXECUTE FUNCTION code_lists.code_url_trigger('http://uri.suomi.fi/codelist/rytj/RY_LisatiedonLaji_AK/code/');
	
-- Trigger: upsert_url_detail_plan_theme

-- DROP TRIGGER IF EXISTS upsert_url_detail_plan_theme ON code_lists.detail_plan_theme;

CREATE OR REPLACE TRIGGER upsert_url_detail_plan_theme
    BEFORE INSERT OR UPDATE 
    ON code_lists.detail_plan_theme
    FOR EACH ROW
    EXECUTE FUNCTION code_lists.code_url_trigger('http://uri.suomi.fi/codelist/rytj/RY_Kaavoitusteema_AK/code/');

-- Trigger: upsert_url_digital_origin_kind

-- DROP TRIGGER IF EXISTS upsert_url_digital_origin_kind ON code_lists.digital_origin_kind;

CREATE OR REPLACE TRIGGER upsert_url_digital_origin_kind
    BEFORE INSERT OR UPDATE 
    ON code_lists.digital_origin_kind
    FOR EACH ROW
    EXECUTE FUNCTION code_lists.code_url_trigger('http://uri.suomi.fi/codelist/rytj/RY_DigitaalinenAlkupera/code/');
	
-- Trigger: upsert_url_document_kind_kind

-- DROP TRIGGER IF EXISTS upsert_url_document_kind_kind ON code_lists.document_kind;

CREATE OR REPLACE TRIGGER upsert_url_document_kind_kind
    BEFORE INSERT OR UPDATE 
    ON code_lists.document_kind
    FOR EACH ROW
    EXECUTE FUNCTION code_lists.code_url_trigger('http://uri.suomi.fi/codelist/rytj/RY_AsiakirjanLaji_YKAK/code/');
	
-- Trigger: upsert_url_finnish_municipalities

-- DROP TRIGGER IF EXISTS upsert_url_finnish_municipalities ON code_lists.finnish_municipalities;

CREATE OR REPLACE TRIGGER upsert_url_finnish_municipalities
    BEFORE INSERT OR UPDATE 
    ON code_lists.finnish_municipalities
    FOR EACH ROW
    EXECUTE FUNCTION code_lists.code_url_trigger('http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/');
	
-- Trigger: upsert_url_ground_relativeness_kind

-- DROP TRIGGER IF EXISTS upsert_url_ground_relativeness_kind ON code_lists.ground_relativeness_kind;

CREATE OR REPLACE TRIGGER upsert_url_ground_relativeness_kind
    BEFORE INSERT OR UPDATE 
    ON code_lists.ground_relativeness_kind
    FOR EACH ROW
    EXECUTE FUNCTION code_lists.code_url_trigger('http://uri.suomi.fi/codelist/rytj/RY_MaanalaisuudenLaji/code/');
	
-- Trigger: upsert_url_legal_effectiveness_kind

-- DROP TRIGGER IF EXISTS upsert_url_legal_effectiveness_kind ON code_lists.legal_effectiveness_kind;

CREATE OR REPLACE TRIGGER upsert_url_legal_effectiveness_kind
    BEFORE INSERT OR UPDATE 
    ON code_lists.legal_effectiveness_kind
    FOR EACH ROW
    EXECUTE FUNCTION code_lists.code_url_trigger('http://uri.suomi.fi/codelist/rytj/RY_OikeusvaikutteisuudenLaji/code/');
	
-- Trigger: upsert_master_plan_envrionmental_change_kind

-- DROP TRIGGER IF EXISTS upsert_master_plan_envrionmental_change_kind ON code_lists.master_plan_envrionmental_change_kind;

CREATE OR REPLACE TRIGGER upsert_master_plan_envrionmental_change_kind
    BEFORE INSERT OR UPDATE 
    ON code_lists.master_plan_envrionmental_change_kind
    FOR EACH ROW
    EXECUTE FUNCTION code_lists.code_url_trigger('http://uri.suomi.fi/codelist/rytj/RY_ymparistomuutoksenLaji_YK/code/');
	
-- Trigger: upsert_master_plan_theme

-- DROP TRIGGER IF EXISTS upsert_master_plan_theme ON code_lists.master_plan_theme;

CREATE OR REPLACE TRIGGER upsert_master_plan_theme
    BEFORE INSERT OR UPDATE 
    ON code_lists.master_plan_theme
    FOR EACH ROW
    EXECUTE FUNCTION code_lists.code_url_trigger('http://uri.suomi.fi/codelist/rytj/RY_Kaavoitusteema_YK/code/');
	
-- Trigger: upsert_url_spatial_plan_kind

-- DROP TRIGGER IF EXISTS upsert_url_spatial_plan_kind ON code_lists.spatial_plan_kind;

CREATE OR REPLACE TRIGGER upsert_url_spatial_plan_kind
    BEFORE INSERT OR UPDATE 
    ON code_lists.spatial_plan_kind
    FOR EACH ROW
    EXECUTE FUNCTION code_lists.code_url_trigger('http://uri.suomi.fi/codelist/rytj/RY_Kaavalaji/code/');
	

