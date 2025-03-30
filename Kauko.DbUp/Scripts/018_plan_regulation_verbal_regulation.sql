-- New code list: verbal_regulation
---------------------------------------------------------------

--
-- Name: verbal_regulation; Type: TABLE; Schema: code_lists; Owner: -
--

CREATE TABLE code_lists.verbal_regulation (
    id integer PRIMARY KEY,
    codevalue character varying NOT NULL,
    uri character varying(255) NOT NULL,
    preflabel_fi character varying NOT NULL,
    preflabel_sv character varying,
    preflabel_en character varying,
    description_fi character varying,
    description_sv character varying,
    description_en character varying,
    main_class character varying,
    CONSTRAINT verbal_regulation_codevalue_key UNIQUE (codevalue),
    CONSTRAINT verbal_regulation_uri_key UNIQUE (uri)
);

--
-- Name: verbal_regulation_id_seq; Type: SEQUENCE; Schema: code_lists; Owner: -
--

CREATE SEQUENCE code_lists.verbal_regulation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

--
-- Name: verbal_regulation_id_seq; Type: SEQUENCE OWNED BY; Schema: code_lists; Owner: -
--

ALTER SEQUENCE code_lists.verbal_regulation_id_seq OWNED BY code_lists.verbal_regulation.id;

--
-- Name: verbal_regulation id; Type: DEFAULT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.verbal_regulation ALTER COLUMN id SET DEFAULT nextval('code_lists.verbal_regulation_id_seq'::regclass);

--
-- Data for Name: verbal_regulation; Type: TABLE DATA; Schema: code_lists; Owner: -
--

INSERT INTO code_lists.verbal_regulation (
    id, 
    codevalue, 
    uri, 
    main_class, 
    preflabel_en, 
    preflabel_fi, 
    preflabel_sv, 
    description_en, 
    description_fi, 
    description_sv
) VALUES 
(1, 'rakentamistapa', 'http://uri.suomi.fi/codelist/rytj/RY_Sanallisen_Kaavamaarayksen_Laji/code/rakentamistapa', NULL, 'Construction method', 'Rakentamistapa', 'Byggnadssätt', 'The code is used to categorize textual plan regulations concerning the construction method.', 'Koodilla luokitellaan rakentamistapaa koskevia tekstimuotoisia kaavamääräyksiä.', 'Med koden klassificeras planbestämmelser i textformat.'),
(2, 'perustaminen', 'http://uri.suomi.fi/codelist/rytj/RY_Sanallisen_Kaavamaarayksen_Laji/code/perustaminen', 'rakentamistapa', 'Foundation', 'Perustaminen', 'Grundande', 'The code is used to categorize textual plan regulations concerning the construction method, which concern the foundation of the building or the type of foundation.', 'Koodilla luokitellaan rakentamistapaa koskevia tekstimuotoisia kaavamääräyksiä, jotka koskevat rakennuksen perustamista tai perustamistapaa.', 'Med koden klassificeras planbestämmelser som gäller byggnadssättet och grundande.'),
(3, 'julkisivut', 'http://uri.suomi.fi/codelist/rytj/RY_Sanallisen_Kaavamaarayksen_Laji/code/julkisivut', 'rakentamistapa', 'Facades', 'Julkisivut', 'Fasad', 'The code is used to categorize textual plan regulations concerning the construction method, which apply to the facades of the building.', 'Koodilla luokitellaan rakentamistapaa koskevia tekstimuotoisia kaavamääräyksiä, jotka koskevat rakennuksen julkisivuja.', 'Med koden klassificeras planbestämmelser som gäller fasad.'),
(4, 'korjausrakentaminen', 'http://uri.suomi.fi/codelist/rytj/RY_Sanallisen_Kaavamaarayksen_Laji/code/korjausrakentaminen', 'rakentamistapa', 'Renovation construction', 'Korjausrakentaminen', 'Ombyggnad', 'The code is used to categorize textual plan regulations concerning the construction method, which concern renovation construction and its control.', 'Koodilla luokitellaan rakentamistapaa koskevia tekstimuotoisia kaavamääräyksiä, jotka liittyvät korjausrakentamiseen ja sen ohjaukseen.', 'Med koden klassificeras planbestämmelser som gäller Ombyggnad.'),
(5, 'maarayksenTyyppi', 'http://uri.suomi.fi/codelist/rytj/RY_Sanallisen_Kaavamaarayksen_Laji/code/maarayksenTyyppi', NULL, 'Type of regulation', 'Määräyksen tyyppi', 'Slag av bestämmelse', 'A structural header level code that is not used as such.', 'Jäsentävä otsikkotason koodi, jota ei sellaisenaan käytetä.', 'Strukturerande kod på rubriknivå som inte används som sådan.'),
(6, 'suojelumaarays', 'http://uri.suomi.fi/codelist/rytj/RY_Sanallisen_Kaavamaarayksen_Laji/code/suojelumaarays', 'maarayksenTyyppi', 'Protection regulation', 'Suojelumääräys', 'Skyddsbestämmelse', 'The code is used to categorize supplementary protection plan regulations.', 'Koodilla luokitellaan täydentäviä suojelua koskevia kaavamääräyksiä.', 'Med koden klassificeras kompletterande planbestämmelser.'),
(7, 'suunnittelumaarays', 'http://uri.suomi.fi/codelist/rytj/RY_Sanallisen_Kaavamaarayksen_Laji/code/suunnittelumaarays', 'maarayksenTyyppi', 'Planning regulation', 'Suunnittelumääräys', 'Planeringsbestämmelse', 'The code is used to categorize textual plan regulations concerning more detailed planning.', 'Koodilla luokitellaan tarkempaa suunnittelua koskevat kaavamääräykset.', 'Med koden klassificeras planbestämmelser som gäller noggrannare planering.'),
(8, 'rakentamismaarays', 'http://uri.suomi.fi/codelist/rytj/RY_Sanallisen_Kaavamaarayksen_Laji/code/rakentamismaarays', 'maarayksenTyyppi', 'Building regulation', 'Rakentamismääräys', 'Byggnadsbestämmelse', 'The code is used to categorize textual plan regulations concerning the construction method.', 'Koodilla luokitellaan rakentamisen tapaa koskevat tekstimuotoiset kaavamääräykset.', 'Med koden klassificeras planbestämmelser som gäller byggnadssätt.'),
(9, 'kehittamisperiaate', 'http://uri.suomi.fi/codelist/rytj/RY_Sanallisen_Kaavamaarayksen_Laji/code/kehittamisperiaate', NULL, 'Development principle', 'Kehittämisperiaate', 'Utvecklingsprincip', 'The code is used to categorize the plan regulations describing the development principles.', 'Koodilla luokitellaan kehittämisperiaatteita kuvaavat kaavamääräykset.', 'Med koden klassificeras planbestämmelser som beskriver utvecklingsprincipen.'),
(10, 'ymparistohairiot', 'http://uri.suomi.fi/codelist/rytj/RY_Sanallisen_Kaavamaarayksen_Laji/code/ymparistohairiot', NULL, 'Environmental disturbances', 'Ympäristöhäiriöt', 'Miljöstörningar', 'The code is used to categorize textual plan regulations concerning general environmental disturbances for which a more specific sub-code has not been defined.', 'Koodilla luokitellaan tekstimuotoiset kaavamääräykset koskien yleisiä ympäristöhäiriöitä, joille ei ole tarkempaa alakoodia määritelty.', 'Med koden klassificeras planbestämmelser som gäller allmänna miljöstörningar för vilka ingen närmare underkod har fastställts.'),
(11, 'melu', 'http://uri.suomi.fi/codelist/rytj/RY_Sanallisen_Kaavamaarayksen_Laji/code/melu', 'ymparistohairiot', 'Noise', 'Melu', 'Buller', 'The code is used to categorize textual plan regulations concerning noise or risk of noise, taking these into account and preparing for them.', 'Koodin avulla luokitellaan melua tai sen riskiä ja näiden huomiointia ja näihin varautumista koskevat tekstimuotoiset kaavamääräykset.', 'Med koden klassificeras planbestämmelser som gäller buller.'),
(12, 'tarina', 'http://uri.suomi.fi/codelist/rytj/RY_Sanallisen_Kaavamaarayksen_Laji/code/tarina', 'ymparistohairiot', 'Vibration', 'Tärinä', 'Vibration', 'The code is used to categorize textual plan regulations concerning vibration or risk of vibration, taking these into account and preparing for them.', 'Koodin avulla luokitellaan tärinää tai sen riskiä ja näiden huomiointia ja näihin varautumista koskevat tekstimuotoiset kaavamääräykset.', 'Med koden klassificeras planbestämmelser som gäller vibrationer.'),
(13, 'tulva', 'http://uri.suomi.fi/codelist/rytj/RY_Sanallisen_Kaavamaarayksen_Laji/code/tulva', 'ymparistohairiot', 'Flooding', 'Tulva', 'Översvämning', 'The code is used to categorize textual plan regulations concerning risk of flooding, taking it into account and preparing for it.', 'Koodin avulla luokitellaan tulvavaaraa, sen huomiointia ja siihen varautumista koskevat tekstimuotoiset kaavamääräykset.', 'Med koden klassificeras planbestämmelser som gäller risk för översvämning.'),
(14, 'liikenne', 'http://uri.suomi.fi/codelist/rytj/RY_Sanallisen_Kaavamaarayksen_Laji/code/liikenne', NULL, 'Transportation', 'Liikenne', 'Trafik', 'The code is used to categorize textual plan regulations concerning traffic.', 'Koodin avulla luokitellaan liikennettä koskevat tekstimuotoiset kaavamääräykset.', 'Med koden klassificeras planbestämmelser som gäller trafik.'),
(15, 'pysakointi', 'http://uri.suomi.fi/codelist/rytj/RY_Sanallisen_Kaavamaarayksen_Laji/code/pysakointi', 'liikenne', 'Parking', 'Pysäköinti', 'Parkering', 'The code is used to categorize textual plan regulations concerning parking.', 'Koodin avulla luokitellaan pysäköintiä koskevat tekstimuotoiset kaavamääräykset.', 'Med koden klassificeras planbestämmelser som gäller parkering.'),
(16, 'henkiloautoilu', 'http://uri.suomi.fi/codelist/rytj/RY_Sanallisen_Kaavamaarayksen_Laji/code/henkiloautoilu', 'liikenne', 'Passenger cars', 'Henkilöautoilu', 'Personbilstrafik', 'The code is used to categorize textual plan regulations concerning passenger cars.', 'Koodin avulla luokitellaan henkilöautoilua koskevat tekstimuotoiset kaavamääräykset.', 'Med koden klassificeras planbestämmelser som gäller personbilstrafik.'),
(17, 'joukkoliikenne', 'http://uri.suomi.fi/codelist/rytj/RY_Sanallisen_Kaavamaarayksen_Laji/code/joukkoliikenne', 'liikenne', 'Public transport', 'Joukkoliikenne', 'Kollektivtrafik', 'The code is used to categorize textual plan regulations concerning public transport.', 'Koodin avulla luokitellaan joukkoliikennettä koskevat tekstimuotoiset kaavamääräykset.', 'Med koden klassificeras planbestämmelser som gäller kollektivtrafik.'),
(18, 'jalankulku', 'http://uri.suomi.fi/codelist/rytj/RY_Sanallisen_Kaavamaarayksen_Laji/code/jalankulku', 'liikenne', 'Walking', 'Jalankulku', 'Gångtrafik', 'The code is used to categorize textual plan regulations concerning walking.', 'Koodin avulla luokitellaan jalankulkua koskevat tekstimuotoiset kaavamääräykset.', 'Med koden klassificeras planbestämmelser som gäller gångtrafik.'),
(19, 'pyoraily', 'http://uri.suomi.fi/codelist/rytj/RY_Sanallisen_Kaavamaarayksen_Laji/code/pyoraily', 'liikenne', 'Cycling', 'Pyöräily', 'Cykling', 'The code is used to categorize textual plan regulations concerning cycling.', 'Koodin avulla luokitellaan pyöräilyä koskevat tekstimuotoiset kaavamääräykset.', 'Med koden klassificeras planbestämmelser som gäller cykeltrafik.'),
(20, 'kevytLiikenne', 'http://uri.suomi.fi/codelist/rytj/RY_Sanallisen_Kaavamaarayksen_Laji/code/kevytLiikenne', 'liikenne', 'Walking and cycling', 'Kevyt liikenne', 'Lätt trafik', 'The code can be used to categorize textual plan regulations for walking and cycling as well as other traffic similar from the land use perspective (such as electric scooters).', 'Koodilla voidaan luokitella sekä jalankulkua, pyöräilyä että muuta näihin maankäytön näkökulmasta rinnastuvaa liikennettä (esim. sähköpotkulaudat) koskevia tekstimuotoisia kaavamääräyksiä.', 'Med koden klassificeras planbestämmelser som gäller såväl gångtrafik, cykeltrafik som annan trafik som är jämförbar till dessa ur synvinkeln markanvändning (till exempel elsparkcyklar).'),
(21, 'yhdyskuntatekniikka', 'http://uri.suomi.fi/codelist/rytj/RY_Sanallisen_Kaavamaarayksen_Laji/code/yhdyskuntatekniikka', NULL, 'Civil engineering', 'Yhdyskuntatekniikka', 'Samhällsteknik', 'The code is used to categorize textual plan regulations concerning civil engineering.', 'Koodin avulla luokitellaan yhdyskuntatekniikkaa koskevat tekstimuotoiset kaavamääräykset.', 'Med koden klassificeras planbestämmelser som gäller samhällsteknik.'),
(22, 'hulevedet', 'http://uri.suomi.fi/codelist/rytj/RY_Sanallisen_Kaavamaarayksen_Laji/code/hulevedet', 'yhdyskuntatekniikka', 'Stormwater', 'Hulevedet', 'Dagvatten', 'The code is used to categorize textual plan regulations concerning the management or treatment of stormwater.', 'Koodin avulla luokitellaan hulevesien ohjaamista tai käsittelyä koskevat tekstimuotoiset kaavamääräykset.', 'Med koden klassificeras planbestämmelser som gäller styrning eller hantering av dagvatten.'),
(23, 'jatehuolto', 'http://uri.suomi.fi/codelist/rytj/RY_Sanallisen_Kaavamaarayksen_Laji/code/jatehuolto', 'yhdyskuntatekniikka', 'Waste management', 'Jätehuolto', 'Avfallshantering', 'The code is used to categorize textual plan regulations concerning waste management.', 'Koodin avulla luokitellaan jätehuoltoa koskevat tekstimuotoiset kaavamääräykset.', 'Med koden klassificeras planbestämmelser som gäller avfallshantering.'),
(24, 'vesihuolto', 'http://uri.suomi.fi/codelist/rytj/RY_Sanallisen_Kaavamaarayksen_Laji/code/vesihuolto', 'yhdyskuntatekniikka', 'Water supply', 'Vesihuolto', 'Vattenförsörjning', 'The code is used to categorize textual plan regulations concerning water supply.', 'Koodin avulla luokitellaan vesihuoltoa koskevat tekstimuotoiset kaavamääräykset.', 'Med koden klassificeras planbestämmelser som gäller vattenförsörjning.'),
(25, 'ymparistoarvot', 'http://uri.suomi.fi/codelist/rytj/RY_Sanallisen_Kaavamaarayksen_Laji/code/ymparistoarvot', NULL, 'Environmental values', 'Ympäristöarvot', 'Miljövärden', 'The code is used to categorize textual plan regulations concerning environmental values.', 'Koodin avulla luokitellaan ympäristöarvoja koskevat tekstimuotoiset kaavamääräykset.', 'Med koden klassificeras planbestämmelser som gäller miljövärden.'),
(26, 'kulttuuriymparisto', 'http://uri.suomi.fi/codelist/rytj/RY_Sanallisen_Kaavamaarayksen_Laji/code/kulttuuriymparisto', 'ymparistoarvot', 'Cultural environment', 'Kulttuuriympäristö', 'Kulturmiljö', 'The code is used to categorize textual plan regulations concerning the cultural environment.', 'Koodin avulla luokitellaan kulttuuriympäristöä koskevat tekstimuotoiset kaavamääräykset.', 'Med koden klassificeras planbestämmelser som gäller kulturmiljö.'),
(27, 'maisema', 'http://uri.suomi.fi/codelist/rytj/RY_Sanallisen_Kaavamaarayksen_Laji/code/maisema', 'ymparistoarvot', 'Landscape', 'Maisema', 'Landskap', 'The code is used to categorize textual plan regulations concerning landscape values, landscape management and taking these into account.', 'Koodin avulla luokitellaan maisema-arvoja, maisemien hoitoa ja näiden huomioimista koskevat tekstimuotoiset kaavamääräykset.', 'Med koden klassificeras planbestämmelser som gäller landskapsvärden, landskapsskötsel och beaktande av dessa.'),
(28, 'luontoarvot', 'http://uri.suomi.fi/codelist/rytj/RY_Sanallisen_Kaavamaarayksen_Laji/code/luontoarvot', 'ymparistoarvot', 'Natural values', 'Luontoarvot', 'Naturvärden', 'The code is used to categorize textual plan regulations concerning natural values, their management and taking these into account.', 'Koodin avulla luokitellaan luontoarvoja, luontoarvojen hoitoa ja näiden huomioimista koskevat tekstimuotoiset kaavamääräykset.', 'Med koden klassificeras planbestämmelser som gäller naturvärden, skötsel av naturvärden och beaktande av dessa.'),
(29, 'biodiversiteetti', 'http://uri.suomi.fi/codelist/rytj/RY_Sanallisen_Kaavamaarayksen_Laji/code/biodiversiteetti', 'ymparistoarvot', 'Biodiversity', 'Biodiversiteetti', 'Biodiversitet', 'The code is used to categorize textual plan regulations concerning biodiversity, its management and taking these into account.', 'Koodin avulla luokitellaan biodiversiteettiä, biodiversiteetin hoitoa ja näiden huomioimista koskevat tekstimuotoiset kaavamääräykset.', 'Med koden klassificeras planbestämmelser som gäller biodiversitet, skötsel av biodiversitet och beaktande av dessa.'),
(30, 'ennallistaminen', 'http://uri.suomi.fi/codelist/rytj/RY_Sanallisen_Kaavamaarayksen_Laji/code/ennallistaminen', 'ymparistoarvot', 'Restoration', 'Ennallistaminen', 'Restaurering', 'The code is used to categorize textual plan regulations concerning the restoration of nature.', 'Koodin avulla luokitellaan luontoarvojen ennallistamista koskevat tekstimuotoiset kaavamääräykset.', 'Med koden klassificeras planbestämmelser som gäller återställande av naturvärden.'),
(31, 'yhdyskuntarakenteenOhjaus', 'http://uri.suomi.fi/codelist/rytj/RY_Sanallisen_Kaavamaarayksen_Laji/code/yhdyskuntarakenteenOhjaus', NULL, 'Control of community structure', 'Yhdyskuntarakenteen ohjaus', 'Styrning av samhällsstrukturen', 'The code is used to categorize textual plan regulations concerning the control of community structure.', 'Koodin avulla luokitellaan yhdyskuntarakenteen ohjausta koskevat tekstimuotoiset kaavamääräykset.', 'Med koden klassificeras planbestämmelser som gäller styrning av samhällsstrukturen.'),
(32, 'kaupanOhjaus', 'http://uri.suomi.fi/codelist/rytj/RY_Sanallisen_Kaavamaarayksen_Laji/code/kaupanOhjaus', 'yhdyskuntarakenteenOhjaus', 'Control of trade', 'Kaupan ohjaus', 'Styrning av handel', 'The code is used to categorize textual plan regulations concerning the control of retail trade.', 'Koodin avulla luokitellaan vähittäiskaupan ohjaamista koskevat tekstimuotoiset kaavamääräykset.', 'Med koden klassificeras planbestämmelser som gäller styrning av detaljhandel.'),
(33, 'taydennysrakentaminen', 'http://uri.suomi.fi/codelist/rytj/RY_Sanallisen_Kaavamaarayksen_Laji/code/taydennysrakentaminen', 'yhdyskuntarakenteenOhjaus', 'Complementary building', 'Täydennysrakentaminen', 'Kompletteringsbyggande', 'The code is used to categorize textual plan regulations concerning the construction method, which are connected to complementary building and its control.', 'Koodilla luokitellaan rakentamistapaa koskevia tekstimuotoisia kaavamääräyksiä.', 'Med koden klassificeras planbestämmelser som gäller kompleteringsbyggande.'),
(34, 'virkistys', 'http://uri.suomi.fi/codelist/rytj/RY_Sanallisen_Kaavamaarayksen_Laji/code/virkistys', NULL, 'Recreation', 'Virkistys', 'Rekreation', 'The code is used to categorize textual plan regulations concerning recreation.', 'Koodin avulla luokitellaan virkitystä koskevat tekstimuotoiset kaavamääräykset.', 'Med koden klassificeras planbestämmelser som gäller rekreation.'),
(35, 'esteettomyys', 'http://uri.suomi.fi/codelist/rytj/RY_Sanallisen_Kaavamaarayksen_Laji/code/esteettomyys', NULL, 'Accessibility', 'Esteettömyys', 'Tillgänglighet', 'The code is used to categorize textual plan regulations concerning accessibility.', 'Koodin avulla annoitoidaan esteettömyyttä koskevat tekstimuotoiset kaavamääräykset.', 'Med koden klassificeras planbestämmelser som gäller tillgänglighet.'),
(36, 'ilmastonmuutos', 'http://uri.suomi.fi/codelist/rytj/RY_Sanallisen_Kaavamaarayksen_Laji/code/ilmastonmuutos', NULL, 'Climate change', 'Ilmastonmuutos', 'Klimatförändringen', 'The code is used to categorize textual plan regulations concerning climate change mitigation and adaptation.', 'Koodia käytetään annotoimaan sekä ilmastonmuutoksen hillintää että sopeutumista koskevia tekstimuotoisia kaavamääräyksiä.', 'Koden används för att klassificeras planbestämmelser som gäller klimatförändringen.'),
(37, 'rakennusoikeus', 'http://uri.suomi.fi/codelist/rytj/RY_Sanallisen_Kaavamaarayksen_Laji/code/rakennusoikeus', NULL, 'Permitted building volume', 'Rakennusoikeus', 'Byggrätt', 'The code is only used to categorize textual plan regulations relating to permitted building volume.', 'Koodilla luokitellaan rakennusoikeuteen liittyviä tekstimuotoisia kaavamääräyksiä.', 'Med koden klassificeras planbestämmelser som gäller byggrätten.'),
(38, 'lisarakennusoikeus', 'http://uri.suomi.fi/codelist/rytj/RY_Sanallisen_Kaavamaarayksen_Laji/code/lisarakennusoikeus', 'rakennusoikeus', 'Extended permitted building volume', 'Lisärakennusoikeus', 'Tillbyggnadsrätt', 'The code is only used to categorize textual plan regulations relating to extended permitted building volume.', 'Koodilla luokitellaan lisärakennusoikeuteen liittyviä tekstimuotoisia kaavamääräyksiä.', 'Med koden klassificeras planbestämmelser som gäller tillbyggnadsrätten.'),
(39, 'tontinKaytto', 'http://uri.suomi.fi/codelist/rytj/RY_Sanallisen_Kaavamaarayksen_Laji/code/tontinKaytto', NULL, 'Use of the plot', 'Tontin käyttö', 'Tomtanvändning', 'The code is used to categorize textual plan regulations concerning the use of the plot.', 'Koodin avulla luokitellaan tontin käyttöä koskevat tekstimuotoiset kaavamääräykset.', 'Med koden klassificeras planbestämmelser som gäller tomtanvändning.');

--
-- Name: verbal_regulation_id_seq; Type: SEQUENCE SET; Schema: code_lists; Owner: -
--

SELECT pg_catalog.setval('code_lists.verbal_regulation_id_seq', 39, true);

--
-- Name: verbal_regulation upsert_verbal_regulation; Type: TRIGGER; Schema: code_lists; Owner: -
--

CREATE TRIGGER upsert_verbal_regulation BEFORE INSERT OR UPDATE ON code_lists.verbal_regulation FOR EACH ROW EXECUTE FUNCTION code_lists.code_url_trigger('http://uri.suomi.fi/codelist/rytj/RY_Sanallisen_Kaavamaarayksen_Laji/code/');



-- New link table between plan_regulation and verbal_regulation
---------------------------------------------------------------

-- Table: $SCHEMANAME$.plan_regulation_verbal_regulation

-- DROP TABLE IF EXISTS $SCHEMANAME$.plan_regulation_verbal_regulation;

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.plan_regulation_verbal_regulation
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    fk_plan_regulation TEXT NOT NULL,
    fk_verbal_regulation TEXT NOT NULL,
    CONSTRAINT plan_regulation_verbal_regulation_pkey PRIMARY KEY (id),
    CONSTRAINT plan_regulation_verbal_regulation_key UNIQUE (fk_plan_regulation, fk_verbal_regulation),
    CONSTRAINT plan_regulation_verbal_regulation_fk_plan_regulation_fkey FOREIGN KEY (fk_plan_regulation)
        REFERENCES $SCHEMANAME$.plan_regulation (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT plan_regulation_verbal_regulation_fk_verbal_regulation_fkey FOREIGN KEY (fk_verbal_regulation)
        REFERENCES code_lists.verbal_regulation (codevalue) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE NO ACTION
        DEFERRABLE INITIALLY DEFERRED
);
