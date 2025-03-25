-- New code list: plan_source_data_type
---------------------------------------------------------------

--
-- Name: plan_source_data_type; Type: TABLE; Schema: code_lists; Owner: -
--

CREATE TABLE code_lists.plan_source_data_type (
    id integer PRIMARY KEY,
    codevalue character varying(4) NOT NULL,
    uri character varying(255) NOT NULL,
    preflabel_fi character varying NOT NULL,
    preflabel_sv character varying,
    CONSTRAINT plan_source_data_type_codevalue_key UNIQUE (codevalue),
    CONSTRAINT plan_source_data_type_uri UNIQUE (uri)
);

--
-- Name: plan_source_data_type_id_seq; Type: SEQUENCE; Schema: code_lists; Owner: -
--

CREATE SEQUENCE code_lists.plan_source_data_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

--
-- Name: plan_source_data_type_id_seq; Type: SEQUENCE OWNED BY; Schema: code_lists; Owner: -
--

ALTER SEQUENCE code_lists.plan_source_data_type_id_seq OWNED BY code_lists.plan_source_data_type.id;

--
-- Name: plan_source_data_type id; Type: DEFAULT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.plan_source_data_type ALTER COLUMN id SET DEFAULT nextval('code_lists.plan_source_data_type_id_seq'::regclass);

--
-- Data for Name: plan_source_data_type; Type: TABLE DATA; Schema: code_lists; Owner: -
--

INSERT INTO code_lists.plan_source_data_type (
    id, 
    codevalue, 
    uri, 
    preflabel_fi, 
    preflabel_sv
) VALUES 
(1, '01', 'http://uri.suomi.fi/codelist/rytj/RY_LahtotietoaineistonLaji/code/01', 'Aluerajat', 'Områdesgränser'),
(2, '02', 'http://uri.suomi.fi/codelist/rytj/RY_LahtotietoaineistonLaji/code/02', 'Energia', 'Energi'),
(3, '03', 'http://uri.suomi.fi/codelist/rytj/RY_LahtotietoaineistonLaji/code/03', 'Ihmisten elinolot ja elinympäristö', 'Människors levnadsförhållanden och livsmiljö'),
(4, '04', 'http://uri.suomi.fi/codelist/rytj/RY_LahtotietoaineistonLaji/code/04', 'Ilma ja ilmasto', 'Luft och klimat'),
(5, '05', 'http://uri.suomi.fi/codelist/rytj/RY_LahtotietoaineistonLaji/code/05', 'Kaupunkikuva ja maisema', 'Stadsbild och landskap'),
(6, '06', 'http://uri.suomi.fi/codelist/rytj/RY_LahtotietoaineistonLaji/code/06', 'Kulttuuriympäristö', 'Kulturmiljövärden'),
(7, '07', 'http://uri.suomi.fi/codelist/rytj/RY_LahtotietoaineistonLaji/code/07', 'Liikenne', 'Trafik'),
(8, '08', 'http://uri.suomi.fi/codelist/rytj/RY_LahtotietoaineistonLaji/code/08', 'Luonto ja luonnonvarat', 'Natur och naturresurser'),
(9, '09', 'http://uri.suomi.fi/codelist/rytj/RY_LahtotietoaineistonLaji/code/09', 'Palveluverkko', 'Servicenätverk'),
(10, '10', 'http://uri.suomi.fi/codelist/rytj/RY_LahtotietoaineistonLaji/code/10', 'Maa- ja kallioperä, maanpeite', 'Jord- och bergsmån, landtäcke'),
(11, '11', 'http://uri.suomi.fi/codelist/rytj/RY_LahtotietoaineistonLaji/code/11', 'Pohjakartta', 'Baskarta'),
(12, '12', 'http://uri.suomi.fi/codelist/rytj/RY_LahtotietoaineistonLaji/code/12', 'Rakennukset ja rakenteet', 'Byggnader och konstruktioner'),
(13, '13', 'http://uri.suomi.fi/codelist/rytj/RY_LahtotietoaineistonLaji/code/13', 'Suunnitelmat', 'Planer'),
(14, '1301', 'http://uri.suomi.fi/codelist/rytj/RY_LahtotietoaineistonLaji/code/1301', 'Alueidenkäytön suunnitelmat', 'Områdesanvändningsplaner'),
(15, '1302', 'http://uri.suomi.fi/codelist/rytj/RY_LahtotietoaineistonLaji/code/1302', 'Muut suunnitelmat', 'Annan planer'),
(16, '14', 'http://uri.suomi.fi/codelist/rytj/RY_LahtotietoaineistonLaji/code/14', 'Työpaikat ja elinkeinoelämä', 'Arbetsplatser och näringsliv'),
(17, '15', 'http://uri.suomi.fi/codelist/rytj/RY_LahtotietoaineistonLaji/code/15', 'Vesi- ja jätehuolto', 'Vattenförsörjning och avfallshantering'),
(18, '16', 'http://uri.suomi.fi/codelist/rytj/RY_LahtotietoaineistonLaji/code/16', 'Vesien hoito ja suojelu', 'Vård och skydd av vatten'),
(19, '17', 'http://uri.suomi.fi/codelist/rytj/RY_LahtotietoaineistonLaji/code/17', 'Viestintäverkko', 'Kommunikationsnätverk'),
(20, '18', 'http://uri.suomi.fi/codelist/rytj/RY_LahtotietoaineistonLaji/code/18', 'Virkistys ja viherrakenne', 'Rekreation och grönbyggande'),
(21, '19', 'http://uri.suomi.fi/codelist/rytj/RY_LahtotietoaineistonLaji/code/19', 'Väestö', 'Befolkning'),
(22, '20', 'http://uri.suomi.fi/codelist/rytj/RY_LahtotietoaineistonLaji/code/20', 'Yhdyskuntarakenne', 'Samhällsstruktur'),
(23, '21', 'http://uri.suomi.fi/codelist/rytj/RY_LahtotietoaineistonLaji/code/21', 'Yhdyskuntatalous', 'Samhällsekonomi'),
(24, '22', 'http://uri.suomi.fi/codelist/rytj/RY_LahtotietoaineistonLaji/code/22', 'Muu lähtötietoaineisto', 'Övrigt utgångsdatamaterial');

--
-- Name: plan_source_data_type_id_seq; Type: SEQUENCE SET; Schema: code_lists; Owner: -
--

SELECT pg_catalog.setval('code_lists.plan_source_data_type_id_seq', 24, true);

--
-- Name: plan_source_data_type upsert_plan_source_data_type; Type: TRIGGER; Schema: code_lists; Owner: -
--

CREATE TRIGGER upsert_plan_source_data_type BEFORE INSERT OR UPDATE ON code_lists.plan_source_data_type FOR EACH ROW EXECUTE FUNCTION code_lists.code_url_trigger('http://uri.suomi.fi/codelist/rytj/RY_LahtotietoaineistonLaji/code/');



-- New code list: personal_data_content_type
---------------------------------------------------------------

--
-- Name: personal_data_content_type; Type: TABLE; Schema: code_lists; Owner: -
--

CREATE TABLE code_lists.personal_data_content_type (
    id integer PRIMARY KEY,
    codevalue character varying(4) NOT NULL,
    uri character varying(255) NOT NULL,
    preflabel_fi character varying NOT NULL,
    preflabel_sv character varying,
    description_fi character varying,
    description_sv character varying,
    CONSTRAINT personal_data_content_type_codevalue_key UNIQUE (codevalue),
    CONSTRAINT personal_data_content_type_uri UNIQUE (uri)
);

--
-- Name: personal_data_content_type_id_seq; Type: SEQUENCE; Schema: code_lists; Owner: -
--

CREATE SEQUENCE code_lists.personal_data_content_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

--
-- Name: personal_data_content_type_id_seq; Type: SEQUENCE OWNED BY; Schema: code_lists; Owner: -
--

ALTER SEQUENCE code_lists.personal_data_content_type_id_seq OWNED BY code_lists.personal_data_content_type.id;

--
-- Name: personal_data_content_type id; Type: DEFAULT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.personal_data_content_type ALTER COLUMN id SET DEFAULT nextval('code_lists.personal_data_content_type_id_seq'::regclass);

--
-- Data for Name: personal_data_content_type; Type: TABLE DATA; Schema: code_lists; Owner: -
--

INSERT INTO code_lists.personal_data_content_type (
    id, 
    codevalue, 
    uri, 
    preflabel_fi, 
    preflabel_sv,
    description_fi,
    description_sv
) VALUES 
(1, '1', 'http://uri.suomi.fi/codelist/rytj/henkilotietosisalto/code/1', 'Ei sisällä henkilötietoja', 'Innehåller inga personuppgifter', null, null),
(2, '2', 'http://uri.suomi.fi/codelist/rytj/henkilotietosisalto/code/2', 'Sisältää nimitietoja', 'Innehåller namnuppgifter', 'Esimerkiksi suunnittelijan, päätöksen tekijän, lausunnonantajan tai selvityksen tekijän etu- ja sukunimi. Ei sisällä henkilötunnusta, ei osoitetietoja eikä muita yhteystietoja.', 'Till exempel för- och efternamn på planerare, beslutsfattare, personer som gett ett utlåtande eller gjort en utredning. Innehåller ingen personbeteckning, inga adressuppgifter eller andra kontaktuppgifter.'),
(3, '3', 'http://uri.suomi.fi/codelist/rytj/henkilotietosisalto/code/3', 'Sisältää henkilötietoa, josta henkilö tunnistettavissa', 'Innehåller personuppgifter, på basis av vilka en person kan identifieras', 'Sisältää esimerkiksi henkilötunnuksen tai kotiosoitteen tiedot.', 'Innehåller till exempel uppgifter om personbeteckning eller hemadress.');

--
-- Name: personal_data_content_type_id_seq; Type: SEQUENCE SET; Schema: code_lists; Owner: -
--

SELECT pg_catalog.setval('code_lists.personal_data_content_type_id_seq', 3, true);

--
-- Name: personal_data_content_type upsert_personal_data_content_type; Type: TRIGGER; Schema: code_lists; Owner: -
--

CREATE TRIGGER upsert_personal_data_content_type BEFORE INSERT OR UPDATE ON code_lists.personal_data_content_type FOR EACH ROW EXECUTE FUNCTION code_lists.code_url_trigger('http://uri.suomi.fi/codelist/rytj/henkilotietosisalto/code/');



-- New code list: publicity_category
---------------------------------------------------------------

--
-- Name: publicity_category; Type: TABLE; Schema: code_lists; Owner: -
--

CREATE TABLE code_lists.publicity_category (
    id integer PRIMARY KEY,
    codevalue character varying(4) NOT NULL,
    uri character varying(255) NOT NULL,
    preflabel_fi character varying NOT NULL,
    preflabel_sv character varying,
    CONSTRAINT publicity_category_codevalue_key UNIQUE (codevalue),
    CONSTRAINT publicity_category_uri UNIQUE (uri)
);

--
-- Name: publicity_category_id_seq; Type: SEQUENCE; Schema: code_lists; Owner: -
--

CREATE SEQUENCE code_lists.publicity_category_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

--
-- Name: publicity_category_id_seq; Type: SEQUENCE OWNED BY; Schema: code_lists; Owner: -
--

ALTER SEQUENCE code_lists.publicity_category_id_seq OWNED BY code_lists.publicity_category.id;

--
-- Name: publicity_category id; Type: DEFAULT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.publicity_category ALTER COLUMN id SET DEFAULT nextval('code_lists.publicity_category_id_seq'::regclass);

--
-- Data for Name: publicity_category; Type: TABLE DATA; Schema: code_lists; Owner: -
--

INSERT INTO code_lists.publicity_category (
    id, 
    codevalue, 
    uri, 
    preflabel_fi, 
    preflabel_sv
) VALUES 
(1, '1', 'http://uri.suomi.fi/codelist/rytj/julkisuus/code/1', 'Julkinen asiakirja', 'Offentligt dokument'),
(2, '2', 'http://uri.suomi.fi/codelist/rytj/julkisuus/code/2', 'Sisältää turvaluokiteltua tietoa', 'Innehåller säkerhetsklassificerad information'),
(3, '3', 'http://uri.suomi.fi/codelist/rytj/julkisuus/code/3', 'Sisältää salassapidettävää tietoa', 'Innehåller sekretessbelagd information'),
(4, '4', 'http://uri.suomi.fi/codelist/rytj/julkisuus/code/4', 'Tiedon jakaminen muille kuin viranomaisille vaatii tarkistamista', 'Delning av information till andra än myndigheter kräver granskning');

--
-- Name: publicity_category_id_seq; Type: SEQUENCE SET; Schema: code_lists; Owner: -
--

SELECT pg_catalog.setval('code_lists.publicity_category_id_seq', 4, true);

--
-- Name: publicity_category upsert_publicity_category; Type: TRIGGER; Schema: code_lists; Owner: -
--

CREATE TRIGGER upsert_publicity_category BEFORE INSERT OR UPDATE ON code_lists.publicity_category FOR EACH ROW EXECUTE FUNCTION code_lists.code_url_trigger('http://uri.suomi.fi/codelist/rytj/julkisuus/code/');



-- Add code list personal_data_content_type and publicity_category references to table document
---------------------------------------------------------------

ALTER TABLE $SCHEMANAME$.document ADD CONSTRAINT document_personal_data_content_fkey FOREIGN KEY (personal_data_content)
    REFERENCES code_lists.personal_data_content_type (codevalue) MATCH SIMPLE
    ON UPDATE CASCADE
    ON DELETE RESTRICT;

ALTER TABLE $SCHEMANAME$.document ADD CONSTRAINT document_category_of_publicity_fkey FOREIGN KEY (category_of_publicity)
    REFERENCES code_lists.publicity_category (codevalue) MATCH SIMPLE
    ON UPDATE CASCADE
    ON DELETE RESTRICT;



-- Table additions and changes
---------------------------------------------------------------

-- Table: $SCHEMANAME$.plan_source_data

-- DROP TABLE IF EXISTS $SCHEMANAME$.plan_source_data;

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.plan_source_data
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    local_id text NOT NULL DEFAULT uuid_generate_v4(),
    type character varying(4) NOT NULL,
    name jsonb,
    additional_information_link text,
    geom geometry(Point,$PROJECTSRID$),
    CONSTRAINT plan_source_data_pkey PRIMARY KEY (id),
    CONSTRAINT plan_source_data_local_id_key UNIQUE (local_id),
    CONSTRAINT plan_source_data_type_fk FOREIGN KEY (type)
        REFERENCES code_lists.plan_source_data_type (codevalue) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT plan_source_data_name_check CHECK (check_ryhti_language(name))
);


-- Table: $SCHEMANAME$.spatial_plan_main_plan_source_data

-- DROP TABLE IF EXISTS $SCHEMANAME$.spatial_plan_main_plan_source_data;

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.spatial_plan_main_plan_source_data
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    fk_spatial_plan_main TEXT NOT NULL,
    fk_plan_source_data TEXT NOT NULL,
    CONSTRAINT spatial_plan_main_plan_source_data_pkey PRIMARY KEY (id),
    CONSTRAINT spm_psd_fk_spatial_plan_main_fkey FOREIGN KEY (fk_spatial_plan_main)
        REFERENCES $SCHEMANAME$.spatial_plan_main (local_plan_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT spm_psd_fk_plan_source_data_fkey FOREIGN KEY (fk_plan_source_data)
        REFERENCES $SCHEMANAME$.plan_source_data (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED
);


-- Table: $SCHEMANAME$.plan_source_data_document

-- DROP TABLE IF EXISTS $SCHEMANAME$.plan_source_data_document;

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.plan_source_data_document
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    fk_plan_source_data TEXT NOT NULL,
    fk_document TEXT NOT NULL,
    CONSTRAINT plan_source_data_document_pkey PRIMARY KEY (id),
    CONSTRAINT plan_source_data_document_fk_plan_source_data_fkey FOREIGN KEY (fk_plan_source_data)
        REFERENCES $SCHEMANAME$.plan_source_data (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT plan_source_data_document_fk_document_fkey FOREIGN KEY (fk_document)
        REFERENCES $SCHEMANAME$.document (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED
);


-- Table: $SCHEMANAME$.plan_handling_event_document

-- DROP TABLE IF EXISTS $SCHEMANAME$.plan_handling_event_document;

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.plan_handling_event_document
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    fk_plan_handling_event TEXT NOT NULL,
    fk_document TEXT NOT NULL,
    CONSTRAINT plan_handling_event_document_pkey PRIMARY KEY (id),
    CONSTRAINT plan_handling_event_document_fk_plan_handling_event_fkey FOREIGN KEY (fk_plan_handling_event)
        REFERENCES $SCHEMANAME$.plan_handling_event (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT plan_handling_event_document_fk_document_fkey FOREIGN KEY (fk_document)
        REFERENCES $SCHEMANAME$.document (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED
);


-- Table: $SCHEMANAME$.plan_interaction_event_document

-- DROP TABLE IF EXISTS $SCHEMANAME$.plan_interaction_event_document;

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.plan_interaction_event_document
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    fk_plan_interaction_event TEXT NOT NULL,
    fk_document TEXT NOT NULL,
    CONSTRAINT plan_interaction_event_document_pkey PRIMARY KEY (id),
    CONSTRAINT plan_interaction_event_document_fk_plan_interaction_event_fkey FOREIGN KEY (fk_plan_interaction_event)
        REFERENCES $SCHEMANAME$.plan_interaction_event (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT plan_interaction_event_document_fk_document_fkey FOREIGN KEY (fk_document)
        REFERENCES $SCHEMANAME$.document (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED
);


-- Table: $SCHEMANAME$.plan_decision_document

-- DROP TABLE IF EXISTS $SCHEMANAME$.plan_decision_document;

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.plan_decision_document
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    fk_plan_decision TEXT NOT NULL,
    fk_document TEXT NOT NULL,
    CONSTRAINT plan_decision_document_pkey PRIMARY KEY (id),
    CONSTRAINT plan_decision_document_fk_plan_decision_fkey FOREIGN KEY (fk_plan_decision)
        REFERENCES $SCHEMANAME$.plan_decision (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT plan_decision_document_fk_document_fkey FOREIGN KEY (fk_document)
        REFERENCES $SCHEMANAME$.document (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED
);


-- Table: $SCHEMANAME$.other_plan_document

-- DROP TABLE IF EXISTS $SCHEMANAME$.other_plan_document;

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.other_plan_document
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    local_id TEXT NOT NULL DEFAULT uuid_generate_v4(),
    name jsonb,
    file_key TEXT,
    other_plan_material_link TEXT,
    personal_data_content TEXT NOT NULL,
    category_of_publicity TEXT NOT NULL,
    created timestamp with time zone NOT NULL DEFAULT now(),
    created_by text NOT NULL,
    modified_by text NOT NULL,
    modified_at timestamp with time zone NOT NULL,
    CONSTRAINT other_plan_document_pkey PRIMARY KEY (id),
    CONSTRAINT other_plan_document_local_id_key UNIQUE (local_id),
    CONSTRAINT other_plan_document_personal_data_content_fkey FOREIGN KEY (personal_data_content)
        REFERENCES code_lists.personal_data_content_type (codevalue) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT other_plan_document_category_of_publicity_fkey FOREIGN KEY (category_of_publicity)
        REFERENCES code_lists.publicity_category (codevalue) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT other_plan_document_name_check CHECK (check_ryhti_language(name))
);


-- Trigger: upsert_creator_and_modifier_trigger

-- DROP TRIGGER IF EXISTS upsert_creator_and_modifier_trigger ON $SCHEMANAME$.other_plan_document;

CREATE OR REPLACE TRIGGER upsert_creator_and_modifier_trigger
    BEFORE INSERT OR UPDATE 
    ON $SCHEMANAME$.other_plan_document
    FOR EACH ROW
    EXECUTE FUNCTION $SCHEMANAME$.upsert_creator_and_modifier_trigger();


-- Table: $SCHEMANAME$.spatial_plan_other_plan_document

-- DROP TABLE IF EXISTS $SCHEMANAME$.spatial_plan_other_plan_document;

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.spatial_plan_other_plan_document
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    fk_spatial_plan TEXT NOT NULL,
    fk_other_plan_document TEXT NOT NULL,
    CONSTRAINT sp_other_plan_document_pkey PRIMARY KEY (id),
    CONSTRAINT sp_other_plan_document_fk_spatial_plan_fkey FOREIGN KEY (fk_spatial_plan)
        REFERENCES $SCHEMANAME$.spatial_plan (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT sp_other_plan_document_fk_other_plan_document_fkey FOREIGN KEY (fk_other_plan_document)
        REFERENCES $SCHEMANAME$.other_plan_document (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED
);


-- Table: $SCHEMANAME$.plan_report

-- DROP TABLE IF EXISTS $SCHEMANAME$.plan_report;

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.plan_report
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    local_id TEXT NOT NULL DEFAULT uuid_generate_v4(),
    CONSTRAINT plan_report_pkey PRIMARY KEY (id),
    CONSTRAINT plan_report_local_id_key UNIQUE (local_id)
);


ALTER TABLE $SCHEMANAME$.spatial_plan
    ADD fk_plan_report TEXT,
    ADD CONSTRAINT spatial_plan_fk_plan_report_fkey FOREIGN KEY (fk_plan_report)
    REFERENCES $SCHEMANAME$.plan_report (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE RESTRICT
        DEFERRABLE INITIALLY DEFERRED;


-- Table: $SCHEMANAME$.plan_report_document

-- DROP TABLE IF EXISTS $SCHEMANAME$.plan_report_document;

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.plan_report_document
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    fk_plan_report TEXT NOT NULL,
    fk_document TEXT NOT NULL,
    CONSTRAINT plan_report_document_pkey PRIMARY KEY (id),
    CONSTRAINT plan_report_document_fk_plan_report_fkey FOREIGN KEY (fk_plan_report)
        REFERENCES $SCHEMANAME$.plan_report (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT plan_report_document_fk_document_fkey FOREIGN KEY (fk_document)
        REFERENCES $SCHEMANAME$.document (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED
);

ALTER TABLE $SCHEMANAME$.document DROP COLUMN languages;


-- Table: $SCHEMANAME$.plan_operator_document

-- DROP TABLE IF EXISTS $SCHEMANAME$.plan_operator_document;

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.plan_operator_document
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    fk_plan_operator TEXT NOT NULL,
    fk_document TEXT NOT NULL,
    CONSTRAINT plan_operator_document_pkey PRIMARY KEY (id),
    CONSTRAINT plan_operator_document_fk_plan_operator_fkey FOREIGN KEY (fk_plan_operator)
        REFERENCES $SCHEMANAME$.plan_operator (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT plan_operator_document_fk_document_fkey FOREIGN KEY (fk_document)
        REFERENCES $SCHEMANAME$.document (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED
);

-- Table: $SCHEMANAME$.document_language

-- DROP TABLE IF EXISTS $SCHEMANAME$.document_language;

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.document_language
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    fk_document TEXT NOT NULL,
    fk_language INTEGER NOT NULL,
    CONSTRAINT document_language_pkey PRIMARY KEY (id),
    CONSTRAINT document_language_fk_document_fkey FOREIGN KEY (fk_document)
        REFERENCES $SCHEMANAME$.document (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED,
    CONSTRAINT document_language_fk_language_fkey FOREIGN KEY (fk_language)
        REFERENCES code_lists.ryhti_language (id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
        DEFERRABLE INITIALLY DEFERRED
);

DROP TABLE IF EXISTS $SCHEMANAME$.spatial_plan_commentary_document;
DROP TABLE IF EXISTS $SCHEMANAME$.spatial_plan_commentary;
DROP TABLE IF EXISTS $SCHEMANAME$.patricipation_evalution_plan_document;
DROP TABLE IF EXISTS $SCHEMANAME$.participation_and_evalution_plan;
