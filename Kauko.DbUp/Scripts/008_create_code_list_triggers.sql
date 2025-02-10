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

--
-- Name: master_plan_additional_information_kind upsert_master_plan_additional_information_kind; Type: TRIGGER; Schema: code_lists; Owner: -
--

CREATE TRIGGER upsert_master_plan_additional_information_kind BEFORE INSERT OR UPDATE ON code_lists.master_plan_additional_information_kind FOR EACH ROW EXECUTE FUNCTION code_lists.code_url_trigger('http://uri.suomi.fi/codelist/rytj/RY_LisatiedonLaji_YK/code/');


--
-- Name: master_plan_envrionmental_change_kind upsert_master_plan_envrionmental_change_kind; Type: TRIGGER; Schema: code_lists; Owner: -
--

CREATE TRIGGER upsert_master_plan_envrionmental_change_kind BEFORE INSERT OR UPDATE ON code_lists.master_plan_envrionmental_change_kind FOR EACH ROW EXECUTE FUNCTION code_lists.code_url_trigger('http://uri.suomi.fi/codelist/rytj/RY_ymparistomuutoksenLaji_YK/code/');


--
-- Name: master_plan_regulation_kind upsert_master_plan_regulation_kind; Type: TRIGGER; Schema: code_lists; Owner: -
--

CREATE TRIGGER upsert_master_plan_regulation_kind BEFORE INSERT OR UPDATE ON code_lists.master_plan_regulation_kind FOR EACH ROW EXECUTE FUNCTION code_lists.code_url_trigger('http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/');


--
-- Name: master_plan_theme upsert_master_plan_theme; Type: TRIGGER; Schema: code_lists; Owner: -
--

CREATE TRIGGER upsert_master_plan_theme BEFORE INSERT OR UPDATE ON code_lists.master_plan_theme FOR EACH ROW EXECUTE FUNCTION code_lists.code_url_trigger('http://uri.suomi.fi/codelist/rytj/RY_Kaavoitusteema_YK/code/');


--
-- Name: bindingness_kind upsert_url_bindingness_kind; Type: TRIGGER; Schema: code_lists; Owner: -
--

CREATE TRIGGER upsert_url_bindingness_kind BEFORE INSERT OR UPDATE ON code_lists.bindingness_kind FOR EACH ROW EXECUTE FUNCTION code_lists.code_url_trigger('http://uri.suomi.fi/codelist/rytj/RY_Sitovuuslaji/code/');


--
-- Name: detail_plan_addition_information_kind upsert_url_detail_plan_addition_information_kind; Type: TRIGGER; Schema: code_lists; Owner: -
--

CREATE TRIGGER upsert_url_detail_plan_addition_information_kind BEFORE INSERT OR UPDATE ON code_lists.detail_plan_addition_information_kind FOR EACH ROW EXECUTE FUNCTION code_lists.code_url_trigger('http://uri.suomi.fi/codelist/rytj/RY_LisatiedonLaji_AK/code/');


--
-- Name: detail_plan_regulation_kind upsert_url_detail_plan_regulation_kind; Type: TRIGGER; Schema: code_lists; Owner: -
--

CREATE TRIGGER upsert_url_detail_plan_regulation_kind BEFORE INSERT OR UPDATE ON code_lists.detail_plan_regulation_kind FOR EACH ROW EXECUTE FUNCTION code_lists.code_url_trigger('http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji/code/');


--
-- Name: detail_plan_theme upsert_url_detail_plan_theme; Type: TRIGGER; Schema: code_lists; Owner: -
--

CREATE TRIGGER upsert_url_detail_plan_theme BEFORE INSERT OR UPDATE ON code_lists.detail_plan_theme FOR EACH ROW EXECUTE FUNCTION code_lists.code_url_trigger('http://uri.suomi.fi/codelist/rytj/RY_Kaavoitusteema_AK/code/');


--
-- Name: digital_origin_kind upsert_url_digital_origin_kind; Type: TRIGGER; Schema: code_lists; Owner: -
--

CREATE TRIGGER upsert_url_digital_origin_kind BEFORE INSERT OR UPDATE ON code_lists.digital_origin_kind FOR EACH ROW EXECUTE FUNCTION code_lists.code_url_trigger('http://uri.suomi.fi/codelist/rytj/RY_DigitaalinenAlkupera/code/');


--
-- Name: document_kind upsert_url_document_kind_kind; Type: TRIGGER; Schema: code_lists; Owner: -
--

CREATE TRIGGER upsert_url_document_kind_kind BEFORE INSERT OR UPDATE ON code_lists.document_kind FOR EACH ROW EXECUTE FUNCTION code_lists.code_url_trigger('http://uri.suomi.fi/codelist/rytj/RY_AsiakirjanLaji_YKAK/code/');


--
-- Name: finnish_municipalities upsert_url_finnish_municipalities; Type: TRIGGER; Schema: code_lists; Owner: -
--

CREATE TRIGGER upsert_url_finnish_municipalities BEFORE INSERT OR UPDATE ON code_lists.finnish_municipalities FOR EACH ROW EXECUTE FUNCTION code_lists.code_url_trigger('http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/');


--
-- Name: ground_relativeness_kind upsert_url_ground_relativeness_kind; Type: TRIGGER; Schema: code_lists; Owner: -
--

CREATE TRIGGER upsert_url_ground_relativeness_kind BEFORE INSERT OR UPDATE ON code_lists.ground_relativeness_kind FOR EACH ROW EXECUTE FUNCTION code_lists.code_url_trigger('http://uri.suomi.fi/codelist/rytj/RY_MaanalaisuudenLaji/code/');


--
-- Name: legal_effectiveness_kind upsert_url_legal_effectiveness_kind; Type: TRIGGER; Schema: code_lists; Owner: -
--

CREATE TRIGGER upsert_url_legal_effectiveness_kind BEFORE INSERT OR UPDATE ON code_lists.legal_effectiveness_kind FOR EACH ROW EXECUTE FUNCTION code_lists.code_url_trigger('http://uri.suomi.fi/codelist/rytj/RY_OikeusvaikutteisuudenLaji/code/');


--
-- Name: spatial_plan_kind upsert_url_spatial_plan_kind; Type: TRIGGER; Schema: code_lists; Owner: -
--

CREATE TRIGGER upsert_url_spatial_plan_kind BEFORE INSERT OR UPDATE ON code_lists.spatial_plan_kind FOR EACH ROW EXECUTE FUNCTION code_lists.code_url_trigger('http://uri.suomi.fi/codelist/rytj/RY_Kaavalaji/code/');


--
-- Name: spatial_plan_lifecycle_status upsert_url_spatial_plan_lifecycle_status; Type: TRIGGER; Schema: code_lists; Owner: -
--

CREATE TRIGGER upsert_url_spatial_plan_lifecycle_status BEFORE INSERT OR UPDATE ON code_lists.spatial_plan_lifecycle_status FOR EACH ROW EXECUTE FUNCTION code_lists.code_url_trigger('http://uri.suomi.fi/codelist/rytj/RY_KaavanElinkaaritila/code/');


--
-- Name: plan_interaction_event_type upsert_plan_interaction_event_type; Type: TRIGGER; Schema: code_lists; Owner: -
--

CREATE TRIGGER upsert_plan_interaction_event_type BEFORE INSERT OR UPDATE ON code_lists.plan_interaction_event_type FOR EACH ROW EXECUTE FUNCTION code_lists.code_url_trigger('http://uri.suomi.fi/codelist/rytj/RY_KaavanVuorovaikutustapahtumanLaji/code/');


--
-- Name: plan_handling_event_type upsert_plan_handling_event_type; Type: TRIGGER; Schema: code_lists; Owner: -
--

CREATE TRIGGER upsert_plan_handling_event_type BEFORE INSERT OR UPDATE ON code_lists.plan_handling_event_type FOR EACH ROW EXECUTE FUNCTION code_lists.code_url_trigger('http://uri.suomi.fi/codelist/rytj/kaavakastap/code/');


--
-- Name: decision_name upsert_plan_decision_name; Type: TRIGGER; Schema: code_lists; Owner: -
--

CREATE TRIGGER upsert_plan_decision_name BEFORE INSERT OR UPDATE ON code_lists.plan_decision_name FOR EACH ROW EXECUTE FUNCTION code_lists.code_url_trigger('http://uri.suomi.fi/codelist/rytj/kaavpaatnimi/code/');


--
-- Name: decision_name upsert_plan_decision_maker_type; Type: TRIGGER; Schema: code_lists; Owner: -
--

CREATE TRIGGER upsert_plan_decision_maker_type BEFORE INSERT OR UPDATE ON code_lists.plan_decision_maker_type FOR EACH ROW EXECUTE FUNCTION code_lists.code_url_trigger('http://uri.suomi.fi/codelist/rytj/PaatoksenTekija/code/');
