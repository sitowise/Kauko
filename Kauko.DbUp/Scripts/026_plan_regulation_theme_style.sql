-- New code list: plan_regulation_theme_style
---------------------------------------------------------------

--
-- Name: plan_regulation_theme_style; Type: TABLE; Schema: code_lists; Owner: -
--

DROP TABLE IF EXISTS code_lists.plan_regulation_theme_style;

CREATE TABLE code_lists.plan_regulation_theme_style (
    id integer PRIMARY KEY,
    codevalue character varying(3) NOT NULL,
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
(1, '01', 'Asuinalue vaalea'),
(2, '02', 'Asuinalue tumma'),
(3, '03', 'Keskustatoimintojen alue'),
(4, '04', 'Yleisten rakennusten alue'),
(5, '05', 'Palvelurakennusten alue'),
(6, '06', 'Katu'),
(7, '07', 'Autopaikka-alue'),
(8, '08', 'Katuaukio/tori'),
(9, '09', 'Jalankulun/pyöräilyn alue'),
(10, '10', 'Liikenteen alue'),
(11, '11', 'Pysäköinti/varikko alue'),
(12, '12', 'Erityisalue'),
(13, '13', 'Hautausmaa-alue/suojaviheralue'),
(14, '14', 'Suojelualue'),
(15, '15', 'Maa- ja metsätalousalue M'),
(16, '16', 'Maa- ja metsätalousalue MM'),
(17, '17', 'Maa- ja metsätalousalue MT/MPT'),
(18, '18', 'Maa- ja metsätalousalue ME/MP'),
(19, '19', 'Maa- ja metsätalousalue MU/MY'),
(20, '20', 'Maa- ja metsätalousalue MA'),
(21, '21', 'Vapaa-ajan/matkailun alue'),
(22, '22', 'Teollisuusalue'),
(23, '23', 'Virkistysalue'),
(24, '24', 'Vesialue'),
(25, '25', 'Työpaikkojen alue (yleiskaava)');

--
-- Name: plan_regulation_theme_style_id_seq; Type: SEQUENCE SET; Schema: code_lists; Owner: -
--

SELECT pg_catalog.setval('code_lists.plan_regulation_theme_style_id_seq', 25, true);
