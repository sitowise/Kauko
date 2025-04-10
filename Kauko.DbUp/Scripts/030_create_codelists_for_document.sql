CREATE TABLE code_lists.document_kind (
	id serial4 NOT NULL,
	codevalue varchar(2) NOT NULL,
	uri varchar(255) NOT NULL,
	preflabel_fi varchar NOT NULL,
	preflabel_sv varchar NULL,
	definition_fi varchar NULL,
	description_fi varchar NULL,
	CONSTRAINT document_kind_codevalue_key UNIQUE (codevalue),
	CONSTRAINT document_kind_pkey PRIMARY KEY (id),
	CONSTRAINT document_kind_uri_key UNIQUE (uri)
);

DELETE FROM code_lists.document_kind;

INSERT INTO code_lists.document_kind
(codevalue, preflabel_fi, preflabel_sv, definition_fi, description_fi)
VALUES
  ('01', 'Hakemus', 'Ansökan', NULL, 'Kaava-asiaan liittyvä hakemus, esimerkiksi kaavoitusaloite tai -hakemus.'),
  ('02', 'Havainnekuva', 'Visualiseringsbild', 'Kaavaa havainnollistava visualisointi', NULL),
  ('03', 'Kaavakartta', 'Plankarta', NULL, 'Juridisen kaavakartan sähköinen versio. Esimerkiksi vanhan, digitoidun kaavakartan skannattu versio.'),
  ('04', 'Kaavamääräykset', 'Planbestämmelser', NULL, NULL),
  ('05', 'Kaavakartta ja kaavamääräykset', 'Plankarta och planbestämmelser', NULL, NULL),
  ('06', 'Kaavaselostus', 'Planbeskrivning', NULL, NULL),
  ('07', 'Karttaliite', 'Kartbilaga', NULL, 'Kaavaan liitetty karttaa esittävä dokumentti.'),
  ('08', 'Kirje', 'Brev', NULL, NULL),
  ('09', 'Kuulutus', 'Kungörelse', NULL, NULL),
  ('10', 'Lausunto', 'Utlåtande', 'asiakirja tai asiakirjojen muodostama kokonaisuus, jolla lausuntopyynnön saanut toimija esittää näkemyksensä tarkastelun kohteesta asiankäsittelyn aikana', NULL),
  ('11', 'Mielipide', 'Åsikt', 'osallisen tai yhteisön jäsenen esittämä kannanotto viranomaisen valmisteluaineistoon', NULL),
  ('12', 'Muistio', 'Promemoria', NULL, NULL),
  ('13', 'Muistutus', 'Anmärkning', 'asianosaisen esittämä kannanotto kaavaehdotukseen', NULL),
  ('14', 'Osallistumis- ja arviointisuunnitelma', 'Plan för deltagande och bedömning', NULL, NULL),
  ('15', 'Päätös', 'Beslut', NULL, NULL),
  ('16', 'Pöytäkirja', 'Protokoll', NULL, NULL),
  ('17', 'Raportti', 'Rapport', 'Raportti voi olla esimerkiksi yhteenveto vuorovaikutustapahtumasta tai -tapahtumien kokonaisuudesta.', 'Asiakirja, joka sisältää yhteenvedon kaavan valmisteluun liittyvästä asiasta.'),
  ('18', 'Selvitys', 'Utredning', 'Kaavan laadinnassa hyödynnetyt selvitykset. Selvityksiä voivat olla esimerkiksi luonto-, maisema-, kulttuuriperintö-, liikenne- tai palveluverkkoselvitykset.', NULL),
  ('19', 'Sopimus', 'Avtal', NULL, NULL),
  ('20', 'Suunnitelma', 'Plan', 'Kaavatyöhön liittyvä erillinen suunnitelma, esimerkiksi katujen tai yleisten alueiden suunnitelma', NULL),
  ('21', 'Suunnitteluohje', 'Planeringsanvisning', 'Suunnitteluohje voi olla esimerkiksi rakentamistapaohje tai lähiympäristön suunnitteluohje.', 'Kaavan suunnitteluratkaisuja täydentävä ohjeistus jatkosuunnittelua varten.'),
  ('22', 'Valitus', 'Besvär', NULL, NULL),
  ('23', 'Vastine', 'Bemötande', NULL, NULL),
  ('99', 'Muu asiakirja', 'Annan handling', NULL, NULL);

CREATE TABLE code_lists.document_retention_time (
id int4 GENERATED ALWAYS AS IDENTITY NOT NULL,
codevalue varchar(6) NOT NULL,
uri varchar(255) NOT NULL,
preflabel_fi varchar NOT NULL,
preflabel_sv varchar NULL,
CONSTRAINT document_retention_time_codevalue_key UNIQUE (codevalue),
CONSTRAINT document_retention_time_pkey PRIMARY KEY (id),
CONSTRAINT document_retention_time_uri_key UNIQUE (uri)
);

CREATE TRIGGER upsert_url_document_retention_time BEFORE
INSERT
    OR
UPDATE
    ON
    code_lists.document_retention_time FOR EACH ROW EXECUTE FUNCTION code_lists.code_url_trigger('http://uri.suomi.fi/codelist/rytj/sailytysaika/code/');

INSERT INTO code_lists.document_retention_time (codevalue, preflabel_fi, preflabel_sv)
VALUES
  ('01', 'Säilytetään pysyvästi', 'Förvaras varaktigt'),
  ('02', 'Säilytetään määräajan', 'Förvaras en viss tid'),
  ('0201', '2 vuotta', '2 år'),
  ('020101', '2 vuotta päätöksen lainvoimaisuuspäivästä', 'Datum när beslutet vinner laga kraft'),
  ('020102', '2 vuotta päätöksen antopäivästä', 'Datum när beslutet meddelats'),
  ('0202', '5 vuotta', '5 år'),
  ('020201', '5 vuotta päätöksen lainvoimaisuuspäivästä', 'Datum när beslutet vinner laga kraft'),
  ('020202', '5 vuotta päätöksen antopäivästä', 'Datum när beslutet meddelats'),
  ('0203', '10 vuotta', '10 år'),
  ('020301', '10 vuotta päätöksen lainvoimaisuuspäivästä', 'Datum när beslutet vinner laga kraft'),
  ('020302', '10 vuotta päätöksen antopäivästä', 'Datum när beslutet meddelats'),
  ('0204', '15 vuotta', '15 år'),
  ('020401', '15 vuotta päätöksen lainvoimaisuuspäivästä', 'Datum när beslutet vinner laga kraft'),
  ('020402', '15 vuotta päätöksen antopäivästä', 'Datum när beslutet meddelats');

ALTER TABLE $SCHEMANAME$.document
  ADD CONSTRAINT document_document_retention_time_fk
    FOREIGN KEY (retention_time)
    REFERENCES code_lists.document_retention_time(codevalue);