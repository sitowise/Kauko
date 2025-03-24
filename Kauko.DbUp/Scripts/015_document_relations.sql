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



-- New tables
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
