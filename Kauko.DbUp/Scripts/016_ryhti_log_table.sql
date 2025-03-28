-- New code list: ryhti_transfer_status
---------------------------------------------------------------

--
-- Name: ryhti_transfer_status; Type: TABLE; Schema: code_lists; Owner: -
--

CREATE TABLE code_lists.ryhti_transfer_status (
    id integer PRIMARY KEY,
    codevalue integer NOT NULL,
    preflabel_fi character varying NOT NULL,
    preflabel_sv character varying,
    preflabel_en character varying,
    CONSTRAINT ryhti_transfer_status_codevalue_key UNIQUE (codevalue)
);

--
-- Name: ryhti_transfer_status_id_seq; Type: SEQUENCE; Schema: code_lists; Owner: -
--

CREATE SEQUENCE code_lists.ryhti_transfer_status_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

--
-- Name: ryhti_transfer_status_id_seq; Type: SEQUENCE OWNED BY; Schema: code_lists; Owner: -
--

ALTER SEQUENCE code_lists.ryhti_transfer_status_id_seq OWNED BY code_lists.ryhti_transfer_status.id;

--
-- Name: ryhti_transfer_status id; Type: DEFAULT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.ryhti_transfer_status ALTER COLUMN id SET DEFAULT nextval('code_lists.ryhti_transfer_status_id_seq'::regclass);

--
-- Data for Name: ryhti_transfer_status; Type: TABLE DATA; Schema: code_lists; Owner: -
--

INSERT INTO code_lists.ryhti_transfer_status (
    id, 
    codevalue, 
    preflabel_fi, 
    preflabel_sv, 
    preflabel_en
) VALUES 
(1, 0, 'siirrossa virheitä', 'fel i överföringen', 'errors in transfer'),
(2, 1, 'siirto onnistui', 'överföringen lyckades', 'transfer succeeded'),
(3, 2, 'siirtosovelluksen sisäinen virhe', 'internt fel i överföringsapplikationen', 'internal error in transfer application');

--
-- Name: ryhti_transfer_status_id_seq; Type: SEQUENCE SET; Schema: code_lists; Owner: -
--

SELECT pg_catalog.setval('code_lists.ryhti_transfer_status_id_seq', 3, true);



-- Ryhti transfer log table
---------------------------------------------------------------

-- Table: $SCHEMANAME$.ryhti_log

-- DROP TABLE IF EXISTS $SCHEMANAME$.ryhti_log;

CREATE TABLE IF NOT EXISTS $SCHEMANAME$.ryhti_log
(
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    transfer_id uuid NOT NULL,
    transfer_type text,
    transfer_status integer,
    timestamp timestamp with time zone NOT NULL,
    user_id uuid NOT NULL,
    message jsonb,
    request jsonb,
    fk_spatial_plan text NOT NULL,
    CONSTRAINT ryhti_log_transfer_status_fkey FOREIGN KEY (transfer_status)
        REFERENCES code_lists.ryhti_transfer_status (codevalue) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT ryhti_log_fk_spatial_plan_fkey FOREIGN KEY (fk_spatial_plan)
        REFERENCES $SCHEMANAME$.spatial_plan (local_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE RESTRICT
        DEFERRABLE INITIALLY DEFERRED
);
