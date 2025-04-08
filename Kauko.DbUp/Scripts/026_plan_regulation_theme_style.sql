-- New code list: plan_regulation_theme_style
---------------------------------------------------------------

--
-- Name: plan_regulation_theme_style; Type: TABLE; Schema: code_lists; Owner: -
--

DROP TABLE IF EXISTS code_lists.plan_regulation_theme_style;

CREATE TABLE code_lists.plan_regulation_theme_style (
    id integer PRIMARY KEY,
    codevalue character varying NOT NULL,
    style text NOT NULL,
    CONSTRAINT plan_regulation_theme_style_codevalue_key UNIQUE (codevalue),
    CONSTRAINT plan_regulation_theme_style_style_key UNIQUE (style)
);

--
-- Name: plan_regulation_theme_style_id_seq; Type: SEQUENCE; Schema: code_lists; Owner: -
--

DROP SEQUENCE IF EXISTS code_lists.plan_regulation_theme_style_id_seq;

CREATE SEQUENCE code_lists.plan_regulation_theme_style_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

--
-- Name: plan_regulation_theme_style_id_seq; Type: SEQUENCE OWNED BY; Schema: code_lists; Owner: -
--

ALTER SEQUENCE code_lists.plan_regulation_theme_style_id_seq OWNED BY code_lists.plan_regulation_theme_style.id;

--
-- Name: plan_regulation_theme_style id; Type: DEFAULT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.plan_regulation_theme_style ALTER COLUMN id SET DEFAULT nextval('code_lists.plan_regulation_theme_style_id_seq'::regclass);

--
-- Data for Name: plan_regulation_theme_style; Type: TABLE DATA; Schema: code_lists; Owner: -
--

INSERT INTO code_lists.plan_regulation_theme_style (
    id, 
    codevalue, 
    style
) VALUES 
(1, 'asuinalueVaalea', 'Asuinalue vaalea'),
(2, 'asuinalueTumma', 'Asuinalue tumma'),
(3, 'keskustatoimintojenAlue', 'Keskustatoimintojen alue'),
(4, 'yleistenRakennustenAlue', 'Yleisten rakennusten alue'),
(5, 'palvelurakennustenAlue', 'Palvelurakennusten alue'),
(6, 'katu', 'Katu'),
(7, 'autopaikkaAlue', 'Autopaikka-alue'),
(8, 'katuaukioTori', 'Katuaukio/tori'),
(9, 'jalankulunPyorailynAlue', 'Jalankulun/pyöräilyn alue'),
(10, 'liikenteenAlue', 'Liikenteen alue'),
(11, 'pysakointiVarikkoAlue', 'Pysäköinti/varikko alue'),
(12, 'erityisalue', 'Erityisalue'),
(13, 'hautausmaaAlueSuojaviheralue', 'Hautausmaa-alue/suojaviheralue'),
(14, 'suojelualue', 'Suojelualue'),
(15, 'maaJaMetsatalousalueM', 'Maa- ja metsätalousalue M'),
(16, 'maaJaMetsatalousalueMM', 'Maa- ja metsätalousalue MM'),
(17, 'maaJaMetsatalousalueMTMPT', 'Maa- ja metsätalousalue MT/MPT'),
(18, 'maaJaMetsatalousalueMEMP', 'Maa- ja metsätalousalue ME/MP'),
(19, 'maaJaMetsatalousalueMUMY', 'Maa- ja metsätalousalue MU/MY'),
(20, 'maaJaMetsatalousalueMA', 'Maa- ja metsätalousalue MA'),
(21, 'vapaaAjanMatkailunAlue', 'Vapaa-ajan/matkailun alue'),
(22, 'teollisuusalue', 'Teollisuusalue'),
(23, 'virkistysalue', 'Virkistysalue'),
(24, 'vesialue', 'Vesialue'),
(25, 'tyopaikkojenAlueYleiskaava', 'Työpaikkojen alue (yleiskaava)');

--
-- Name: plan_regulation_theme_style_id_seq; Type: SEQUENCE SET; Schema: code_lists; Owner: -
--

SELECT pg_catalog.setval('code_lists.plan_regulation_theme_style_id_seq', 25, true);
