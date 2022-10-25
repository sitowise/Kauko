CREATE TABLE code_lists.iso_639_language(
    id serial PRIMARY KEY,
    code character varying(3) NOT NULL UNIQUE,
    name character varying(100) NOT NULL,
);

INSERT INTO code_lists.iso_639_language(code, name)
VALUES
  ('aar',	'Afar'),
  ('abk',	'Abkhazian'),
  ('ace',	'Achinese'),
  ('ach',	'Acoli'),
  ('ada',	'Adangme'),
  ('ady',	'Adyghe; Adygei'),
  ('afa',	'Afro-Asiatic languages'),
  ('afh',	'Afrihili'),
  ('afr',	'Afrikaans'),
  ('ain',	'Ainu'),
  ('aka',	'Akan'),
  ('akk',	'Akkadian'),
  ('alb',	'Albanian'),
  ('ale',	'Aleut'),
  ('alg',	'Algonquian languages'),
  ('alt',	'Southern Altai'),
  ('amh',	'Amharic'),
  ('ang',	'English, Old (ca.450-1100)'),
  ('anp',	'Angika'),
  ('apa',	'Apache languages'),
  ('ara',	'Arabic'),
  ('arc',	'Official Aramaic (700-300 BCE); Imperial Aramaic (700-300 BCE)'),
  ('arg',	'Aragonese'),
  ('arm',	'Armenian'),
  ('arn',	'Mapudungun; Mapuche'),
  ('arp',	'Arapaho'),
  ('art',	'Artificial languages'),
  ('arw',	'Arawak'),
  ('asm',	'Assamese'),
  ('ast',	'Asturian; Bable; Leonese; Asturleonese'),
  ('ath',	'Athapascan languages'),
  ('aus',	'Australian languages'),
  ('ava',	'Avaric'),
  ('ave',	'Avestan'),
  ('awa',	'Awadhi'),
  ('aym',	'Aymara'),
  ('aze',	'Azerbaijani'),
  ('bad',	'Banda languages'),
  ('bai',	'Bamileke languages'),
  ('bak',	'Bashkir'),
  ('bal',	'Baluchi'),
  ('bam',	'Bambara'),
  ('ban',	'Balinese'),
  ('baq',	'Basque'),
  ('bas',	'Basa'),
  ('bat',	'Baltic languages'),
  ('bej',	'Beja; Bedawiyet'),
  ('bel',	'Belarusian'),
  ('bem',	'Bemba'),
  ('ben',	'Bengali'),
  ('ber',	'Berber languages'),
  ('bho',	'Bhojpuri'),
  ('bih',	'Bihari languages'),
  ('bik',	'Bikol'),
  ('bin',	'Bini; Edo'),
  ('bis',	'Bislama'),
  ('bla',	'Siksika'),
  ('bnt',	'Bantu languages'),
  ('bos',	'Bosnian'),
  ('bra',	'Braj'),
  ('bre',	'Breton'),
  ('btk',	'Batak languages'),
  ('bua',	'Buriat'),
  ('bug',	'Buginese'),
  ('bul',	'Bulgarian'),
  ('bur',	'Burmese'),
  ('byn',	'Blin; Bilin'),
  ('cad',	'Caddo'),
  ('cai',	'Central American Indian languages'),
  ('car',	'Galibi Carib'),
  ('cat',	'Catalan; Valencian'),
  ('cau',	'Caucasian languages'),
  ('ceb',	'Cebuano'),
  ('cel',	'Celtic languages'),
  ('cha',	'Chamorro'),
  ('chb',	'Chibcha'),
  ('che',	'Chechen'),
  ('chg',	'Chagatai'),
  ('chi',	'Chinese'),
  ('chk',	'Chuukese'),
  ('chm',	'Mari'),
  ('chn',	'Chinook jargon'),
  ('cho',	'Choctaw'),
  ('chp',	'Chipewyan; Dene Suline'),
  ('chr',	'Cherokee'),
  ('chu',	'Church Slavic; Old Slavonic; Church Slavonic; Old Bulgarian; Old Church Slavonic'),
  ('chv',	'Chuvash'),
  ('chy',	'Cheyenne'),
  ('cmc',	'Chamic languages'),
  ('cnr',	'Montenegrin'),
  ('cop',	'Coptic'),
  ('cor',	'Cornish'),
  ('cos',	'Corsican'),
  ('cpe',	'Creoles and pidgins, English based'),
  ('cpf',	'Creoles and pidgins, French-based'),
  ('cpp',	'Creoles and pidgins, Portuguese-based'),
  ('cre',	'Cree'),
  ('crh',	'Crimean Tatar; Crimean Turkish'),
  ('crp',	'Creoles and pidgins'),
  ('csb',	'Kashubian'),
  ('cus',	'Cushitic languages'),
  ('cze',	'Czech'),
  ('dak',	'Dakota'),
  ('dan',	'Danish'),
  ('dar',	'Dargwa'),
  ('day',	'Land Dayak languages'),
  ('del',	'Delaware'),
  ('den',	'Slave (Athapascan)'),
  ('dgr',	'Dogrib'),
  ('din',	'Dinka'),
  ('div',	'Divehi; Dhivehi; Maldivian'),
  ('doi',	'Dogri'),
  ('dra',	'Dravidian languages'),
  ('dsb',	'Lower Sorbian'),
  ('dua',	'Duala'),
  ('dum',	'Dutch, Middle (ca.1050-1350)'),
  ('dut',	'Dutch; Flemish'),
  ('dyu',	'Dyula'),
  ('dzo',	'Dzongkha'),
  ('efi',	'Efik'),
  ('egy',	'Egyptian (Ancient)'),
  ('eka',	'Ekajuk'),
  ('elx',	'Elamite'),
  ('eng',	'English'),
  ('enm',	'English, Middle (1100-1500)'),
  ('epo',	'Esperanto'),
  ('est',	'Estonian'),
  ('ewe',	'Ewe'),
  ('ewo',	'Ewondo'),
  ('fan',	'Fang'),
  ('fao',	'Faroese'),
  ('fat',	'Fanti'),
  ('fij',	'Fijian'),
  ('fil',	'Filipino; Pilipino'),
  ('fin',	'Finnish'),
  ('fiu',	'Finno-Ugrian languages'),
  ('fon',	'Fon'),
  ('fre',	'French'),
  ('frm',	'French, Middle (ca.1400-1600)'),
  ('fro',	'French, Old (842-ca.1400)'),
  ('frr',	'Northern Frisian'),
  ('frs',	'Eastern Frisian'),
  ('fry',	'Western Frisian'),
  ('ful',	'Fulah'),
  ('fur',	'Friulian'),
  ('gaa',	'Ga'),
  ('gay',	'Gayo'),
  ('gba',	'Gbaya'),
  ('gem',	'Germanic languages'),
  ('geo',	'Georgian'),
  ('ger',	'German'),
  ('gez',	'Geez'),
  ('gil',	'Gilbertese'),
  ('gla',	'Gaelic; Scottish Gaelic'),
  ('gle',	'Irish'),
  ('glg',	'Galician'),
  ('glv',	'Manx'),
  ('gmh',	'German, Middle High (ca.1050-1500)'),
  ('goh',	'German, Old High (ca.750-1050)'),
  ('gon',	'Gondi'),
  ('gor',	'Gorontalo'),
  ('got',	'Gothic'),
  ('grb',	'Grebo'),
  ('grc',	'Greek, Ancient (to 1453)'),
  ('gre',	'Greek, Modern (1453-)'),
  ('grn',	'Guarani'),
  ('gsw',	'Swiss German; Alemannic; Alsatian'),
  ('guj',	'Gujarati'),
  ('gwi',	'Gwich''in'),
  ('hai',	'Haida'),
  ('hat',	'Haitian; Haitian Creole'),
  ('hau',	'Hausa'),
  ('haw',	'Hawaiian'),
  ('heb',	'Hebrew'),
  ('her',	'Herero'),
  ('hil',	'Hiligaynon'),
  ('him',	'Himachali languages; Western Pahari languages'),
  ('hin',	'Hindi'),
  ('hit',	'Hittite'),
  ('hmn',	'Hmong; Mong'),
  ('hmo',	'Hiri Motu'),
  ('hrv',	'Croatian'),
  ('hsb',	'Upper Sorbian'),
  ('hun',	'Hungarian'),
  ('hup',	'Hupa'),
  ('iba',	'Iban'),
  ('ibo',	'Igbo'),
  ('ice',	'Icelandic'),
  ('ido',	'Ido'),
  ('iii',	'Sichuan Yi; Nuosu'),
  ('ijo',	'Ijo languages'),
  ('iku',	'Inuktitut'),
  ('ile',	'Interlingue; Occidental'),
  ('ilo',	'Iloko'),
  ('ina',	'Interlingua (International Auxiliary Language Association)'),
  ('inc',	'Indic languages'),
  ('ind',	'Indonesian'),
  ('ine',	'Indo-European languages'),
  ('inh',	'Ingush'),
  ('ipk',	'Inupiaq'),
  ('ira',	'Iranian languages'),
  ('iro',	'Iroquoian languages'),
  ('ita',	'Italian'),
  ('jav',	'Javanese'),
  ('jbo',	'Lojban'),
  ('jpn',	'Japanese'),
  ('jpr',	'Judeo-Persian'),
  ('jrb',	'Judeo-Arabic'),
  ('kaa',	'Kara-Kalpak'),
  ('kab',	'Kabyle'),
  ('kac',	'Kachin; Jingpho'),
  ('kal',	'Kalaallisut; Greenlandic'),
  ('kam',	'Kamba'),
  ('kan',	'Kannada'),
  ('kar',	'Karen languages'),
  ('kas',	'Kashmiri'),
  ('kau',	'Kanuri'),
  ('kaw',	'Kawi'),
  ('kaz',	'Kazakh'),
  ('kbd',	'Kabardian'),
  ('kha',	'Khasi'),
  ('khi',	'Khoisan languages'),
  ('khm',	'Central Khmer'),
  ('kho',	'Khotanese; Sakan'),
  ('kik',	'Kikuyu; Gikuyu'),
  ('kin',	'Kinyarwanda'),
  ('kir',	'Kirghiz; Kyrgyz'),
  ('kmb',	'Kimbundu'),
  ('kok',	'Konkani'),
  ('kom',	'Komi'),
  ('kon',	'Kongo'),
  ('kor',	'Korean'),
  ('kos',	'Kosraean'),
  ('kpe',	'Kpelle'),
  ('krc',	'Karachay-Balkar'),
  ('krl',	'Karelian'),
  ('kro',	'Kru languages'),
  ('kru',	'Kurukh'),
  ('kua',	'Kuanyama; Kwanyama'),
  ('kum',	'Kumyk'),
  ('kur',	'Kurdish'),
  ('kut',	'Kutenai'),
  ('lad',	'Ladino'),
  ('lah',	'Lahnda'),
  ('lam',	'Lamba'),
  ('lao',	'Lao'),
  ('lat',	'Latin'),
  ('lav',	'Latvian'),
  ('lez',	'Lezghian'),
  ('lim',	'Limburgan; Limburger; Limburgish'),
  ('lin',	'Lingala'),
  ('lit',	'Lithuanian'),
  ('lol',	'Mongo'),
  ('loz',	'Lozi'),
  ('ltz',	'Luxembourgish; Letzeburgesch'),
  ('lua',	'Luba-Lulua'),
  ('lub',	'Luba-Katanga'),
  ('lug',	'Ganda'),
  ('lui',	'Luiseno'),
  ('lun',	'Lunda'),
  ('luo',	'Luo (Kenya and Tanzania)'),
  ('lus',	'Lushai'),
  ('mac',	'Macedonian'),
  ('mad',	'Madurese'),
  ('mag',	'Magahi'),
  ('mah',	'Marshallese'),
  ('mai',	'Maithili'),
  ('mak',	'Makasar'),
  ('mal',	'Malayalam'),
  ('man',	'Mandingo'),
  ('mao',	'Maori'),
  ('map',	'Austronesian languages'),
  ('mar',	'Marathi'),
  ('mas',	'Masai'),
  ('may',	'Malay'),
  ('mdf',	'Moksha'),
  ('mdr',	'Mandar'),
  ('men',	'Mende'),
  ('mga',	'Irish, Middle (900-1200)'),
  ('mic',	'Mi''kmaq; Micmac'),
  ('min',	'Minangkabau'),
  ('mis',	'Uncoded languages'),
  ('mkh',	'Mon-Khmer languages'),
  ('mlg',	'Malagasy'),
  ('mlt',	'Maltese'),
  ('mnc',	'Manchu'),
  ('mni',	'Manipuri'),
  ('mno',	'Manobo languages'),
  ('moh',	'Mohawk'),
  ('mon',	'Mongolian'),
  ('mos',	'Mossi'),
  ('mul',	'Multiple languages'),
  ('mun',	'Munda languages'),
  ('mus',	'Creek'),
  ('mwl',	'Mirandese'),
  ('mwr',	'Marwari'),
  ('myn',	'Mayan languages'),
  ('myv',	'Erzya'),
  ('nah',	'Nahuatl languages'),
  ('nai',	'North American Indian languages'),
  ('nap',	'Neapolitan'),
  ('nau',	'Nauru'),
  ('nav',	'Navajo; Navaho'),
  ('nbl',	'Ndebele, South; South Ndebele'),
  ('nde',	'Ndebele, North; North Ndebele'),
  ('ndo',	'Ndonga'),
  ('nds',	'Low German; Low Saxon; German, Low; Saxon, Low'),
  ('nep',	'Nepali'),
  ('new',	'Nepal Bhasa; Newari'),
  ('nia',	'Nias'),
  ('nic',	'Niger-Kordofanian languages'),
  ('niu',	'Niuean'),
  ('nno',	'Norwegian Nynorsk; Nynorsk, Norwegian'),
  ('nob',	'Bokmål, Norwegian; Norwegian Bokmål'),
  ('nog',	'Nogai'),
  ('non',	'Norse, Old'),
  ('nor',	'Norwegian'),
  ('nqo',	'N''Ko'),
  ('nso',	'Pedi; Sepedi; Northern Sotho'),
  ('nub',	'Nubian languages'),
  ('nwc',	'Classical Newari; Old Newari; Classical Nepal Bhasa'),
  ('nya',	'Chichewa; Chewa; Nyanja'),
  ('nym',	'Nyamwezi'),
  ('nyn',	'Nyankole'),
  ('nyo',	'Nyoro'),
  ('nzi',	'Nzima'),
  ('oci',	'Occitan (post 1500)'),
  ('oji',	'Ojibwa'),
  ('ori',	'Oriya'),
  ('orm',	'Oromo'),
  ('osa',	'Osage'),
  ('oss',	'Ossetian; Ossetic'),
  ('ota',	'Turkish, Ottoman (1500-1928)'),
  ('oto',	'Otomian languages'),
  ('paa',	'Papuan languages'),
  ('pag',	'Pangasinan'),
  ('pal',	'Pahlavi'),
  ('pam',	'Pampanga; Kapampangan'),
  ('pan',	'Panjabi; Punjabi'),
  ('pap',	'Papiamento'),
  ('pau',	'Palauan'),
  ('peo',	'Persian, Old (ca.600-400 B.C.)'),
  ('per',	'Persian'),
  ('phi',	'Philippine languages'),
  ('phn',	'Phoenician'),
  ('pli',	'Pali'),
  ('pol',	'Polish'),
  ('pon',	'Pohnpeian'),
  ('por',	'Portuguese'),
  ('pra',	'Prakrit languages'),
  ('pro',	'Provençal, Old (to 1500); Occitan, Old (to 1500)'),
  ('pus',	'Pushto; Pashto'),
  ('que',	'Quechua'),
  ('raj',	'Rajasthani'),
  ('rap',	'Rapanui'),
  ('rar',	'Rarotongan; Cook Islands Maori'),
  ('roa',	'Romance languages'),
  ('roh',	'Romansh'),
  ('rom',	'Romany'),
  ('rum',	'Romanian; Moldavian; Moldovan'),
  ('run',	'Rundi'),
  ('rup',	'Aromanian; Arumanian; Macedo-Romanian'),
  ('rus',	'Russian'),
  ('sad',	'Sandawe'),
  ('sag',	'Sango'),
  ('sah',	'Yakut'),
  ('sai',	'South American Indian languages'),
  ('sal',	'Salishan languages'),
  ('sam',	'Samaritan Aramaic'),
  ('san',	'Sanskrit'),
  ('sas',	'Sasak'),
  ('sat',	'Santali'),
  ('scn',	'Sicilian'),
  ('sco',	'Scots'),
  ('sel',	'Selkup'),
  ('sem',	'Semitic languages'),
  ('sga',	'Irish, Old (to 900)'),
  ('sgn',	'Sign Languages'),
  ('shn',	'Shan'),
  ('sid',	'Sidamo'),
  ('sin',	'Sinhala; Sinhalese'),
  ('sio',	'Siouan languages'),
  ('sit',	'Sino-Tibetan languages'),
  ('sla',	'Slavic languages'),
  ('slo',	'Slovak'),
  ('slv',	'Slovenian'),
  ('sma',	'Southern Sami'),
  ('sme',	'Northern Sami'),
  ('smi',	'Sami languages'),
  ('smj',	'Lule Sami'),
  ('smn',	'Inari Sami'),
  ('smo',	'Samoan'),
  ('sms',	'Skolt Sami'),
  ('sna',	'Shona'),
  ('snd',	'Sindhi'),
  ('snk',	'Soninke'),
  ('sog',	'Sogdian'),
  ('som',	'Somali'),
  ('son',	'Songhai languages'),
  ('sot',	'Sotho, Southern'),
  ('spa',	'Spanish; Castilian'),
  ('srd',	'Sardinian'),
  ('srn',	'Sranan Tongo'),
  ('srp',	'Serbian'),
  ('srr',	'Serer'),
  ('ssa',	'Nilo-Saharan languages'),
  ('ssw',	'Swati'),
  ('suk',	'Sukuma'),
  ('sun',	'Sundanese'),
  ('sus',	'Susu'),
  ('sux',	'Sumerian'),
  ('swa',	'Swahili'),
  ('swe',	'Swedish'),
  ('syc',	'Classical Syriac'),
  ('syr',	'Syriac'),
  ('tah',	'Tahitian'),
  ('tai',	'Tai languages'),
  ('tam',	'Tamil'),
  ('tat',	'Tatar'),
  ('tel',	'Telugu'),
  ('tem',	'Timne'),
  ('ter',	'Tereno'),
  ('tet',	'Tetum'),
  ('tgk',	'Tajik'),
  ('tgl',	'Tagalog'),
  ('tha',	'Thai'),
  ('tib',	'Tibetan'),
  ('tig',	'Tigre'),
  ('tir',	'Tigrinya'),
  ('tiv',	'Tiv'),
  ('tkl',	'Tokelau'),
  ('tlh',	'Klingon; tlhIngan-Hol'),
  ('tli',	'Tlingit'),
  ('tmh',	'Tamashek'),
  ('tog',	'Tonga (Nyasa)'),
  ('ton',	'Tonga (Tonga Islands)'),
  ('tpi',	'Tok Pisin'),
  ('tsi',	'Tsimshian'),
  ('tsn',	'Tswana'),
  ('tso',	'Tsonga'),
  ('tuk',	'Turkmen'),
  ('tum',	'Tumbuka'),
  ('tup',	'Tupi languages'),
  ('tur',	'Turkish'),
  ('tut',	'Altaic languages'),
  ('tvl',	'Tuvalu'),
  ('twi',	'Twi'),
  ('tyv',	'Tuvinian'),
  ('udm',	'Udmurt'),
  ('uga',	'Ugaritic'),
  ('uig',	'Uighur; Uyghur'),
  ('ukr',	'Ukrainian'),
  ('umb',	'Umbundu'),
  ('und',	'Undetermined'),
  ('urd',	'Urdu'),
  ('uzb',	'Uzbek'),
  ('vai',	'Vai'),
  ('ven',	'Venda'),
  ('vie',	'Vietnamese'),
  ('vol',	'Volapük'),
  ('vot',	'Votic'),
  ('wak',	'Wakashan languages'),
  ('wal',	'Wolaitta; Wolaytta'),
  ('war',	'Waray'),
  ('was',	'Washo'),
  ('wel',	'Welsh'),
  ('wen',	'Sorbian languages'),
  ('wln',	'Walloon'),
  ('wol',	'Wolof'),
  ('xal',	'Kalmyk; Oirat'),
  ('xho',	'Xhosa'),
  ('yao',	'Yao'),
  ('yap',	'Yapese'),
  ('yid',	'Yiddish'),
  ('yor',	'Yoruba'),
  ('ypk',	'Yupik languages'),
  ('zap',	'Zapotec'),
  ('zbl',	'Blissymbols; Blissymbolics; Bliss'),
  ('zen',	'Zenaga'),
  ('zgh',	'Standard Moroccan Tamazight'),
  ('zha',	'Zhuang; Chuang'),
  ('znd',	'Zande languages'),
  ('zul',	'Zulu'),
  ('zun',	'Zuni'),
  ('zxx',	'No linguistic content; Not applicable'),
  ('zza',	'Zaza; Dimili; Dimli; Kirdki; Kirmanjki; Zazaki');

CREATE OR REPLACE FUNCTION code_lists.code_url_trigger() RETURNS TRIGGER AS $$
  BEGIN
    IF TG_NARGS > 1 THEN
      RAISE EXCEPTION 'Too many arguments on code_urL_trigger';
    END IF;
    NEW.uri := TG_ARGV[0] || NEW.codevalue;
    RETURN NEW;
  END;
$$ LANGUAGE plpgsql;

CREATE TABLE code_lists.detail_plan_addition_information_kind (
  id SERIAL PRIMARY KEY,
  codevalue VARCHAR(3) NOT NULL UNIQUE,
  uri VARCHAR(255) NOT NULL UNIQUE,
  preflabel_fi VARCHAR NOT NULL,
  preflabel_sv VARCHAR,
  definition_fi VARCHAR,
  definition_sv VARCHAR,
  description_fi VARCHAR,
  description_sv VARCHAR,
);

CREATE TRIGGER code_lists.upsert_url_detail_plan_addition_information_kind
  BEFORE INSERT OR UPDATE ON code_lists.detail_plan_addition_information_kind
  FOR EACH ROW EXECUTE PROCEDURE code_lists.code_url_trigger('http://uri.suomi.fi/codelist/rytj/RY_LisatiedonLaji_AK/code/');

INSERT INTO code_lists.detail_plan_addition_information_kind (codevalue, preflabel_fi, preflabel_sv, definition_fi, description_fi)
VALUES
  ('01', 'Käyttötarkoituksen osuus kerrosalasta', NULL, NULL, 'Kuvaa yhden käyttötarkoituksen osuuden yhden tai usemman rakennuksen sallitusta kerrosalasta'),
  ('02', 'Käyttötarkoituskohdistus', NULL, 'kohdistaa liittyvän kaavamääryksen koskemaan ainoastaan lisätiedon arvona annettuja käyttötarkoituksia', NULL),
  ('03', 'Kohteen geometrian osa', NULL, 'liitetty arvo ilmaisee sen osan liittyvän kohteen geometriasta, jota kaavamääräys koskee.', 'Esim. se osa korttelin tai tontin rajaviivaa, johon rakennukset on rakennettava kiinni, tai osa yhtenä paikkatietokohteena määritellyn liikenneväylän viivaa.'),
  ('04', 'Poisluettava käyttötarkoitus', NULL, NULL, 'Annetut käyttötarkoitukset suljetaan pois kaavamääräyksen kuvaamista sallituista käyttötarkoituksista. Käytetään, mikäli on luontevampaa sulkea tiettyjä yksityiskohtaisia käyttötarkoituksia pois sallittujen joukosta kuin kuvata kaikki sallitut käyttötarkoitukset.'),
  ('05', 'Kulttuurihistoriallinen merkittävyys', 'kulturhistorisk betydelse', 'kohteesta muodostettu käsitys, joka perustuu kohteen kulttuurihistoriallisten arvojen ja kulttuuristen merkitysten analysointiin sekä sen suhteuttamiseen muihin vastaaviin kohteisiin', 'Kulttuurihistoriallinen merkittävyys voi olla kansainvälinen, valtakunnallinen, maakunnallinen, paikallinen tai vähäinen.'),
  ('06', 'Kulttuurihistoriallinen arvotyyppi', NULL, 'Kohteelle määritetyt kulttuurihistorialliset ominaisuudet', 'Kulttuurihistoriallisia ominaisuuksia ovat esimerkiksi rakennustaiteellinen, rakennustekninen, arkkitehtoninen ja maisemallinen.'),
  ('07', 'Kulttuurihistoriallinen tyyppi', NULL, 'Kuvaa kohteen kulttuurihistoriallista käyttötarkoitusta', NULL),
  ('08', 'Kulttuurihistoriallisen merkittävyyden kriteerit', NULL, 'Kuvaa kulttuurihistoriallisen merkittävyyden kriteerejä, joita kohde edustaa.;Merkittävyys voi liittyä edustavuuteen, alkuperäisyyteen, harvinaisuuteen, tyypillisyyteen tai historialliseen merkittävyyteen.'),
  ('09', 'Ympäristöarvon peruste', NULL, NULL, NULL),
  ('10', 'Ympäristö- tai luontoarvon merkittävyys', NULL, NULL, NULL),
  ('11', 'Muu lisätiedon laji', NULL, NULL, NULL),
  ('12', 'Lukumäärä per kerrosneliömetri', NULL, NULL, 'Kuvaa suureen arvon kutakin rakennuksen kerrosneliömetriä kohden.'),
  ('13', 'Lukumäärä per asunto', NULL, NULL, 'Kuvaa suureen arvon kutakin rakennuksen asuntoa kohden.');

CREATE TABLE code_lists.detail_plan_theme (
  id SERIAL PRIMARY KEY,
  codevalue VARCHAR(3) NOT NULL UNIQUE,
  uri VARCHAR(255) NOT NULL UNIQUE,
  preflabel_fi VARCHAR NOT NULL,
  preflabel_sv VARCHAR,
  definition_fi VARCHAR,
  definition_sv VARCHAR,
);

CREATE TRIGGER code_lists.upsert_url_detail_plan_theme
  BEFORE INSERT OR UPDATE ON code_lists.detail_plan_theme
  FOR EACH ROW EXECUTE PROCEDURE code_lists.code_url_trigger('http://uri.suomi.fi/codelist/rytj/RY_Kaavoitusteema_AK/code/');

INSERT INTO code_lists.detail_plan_theme (codevalue, preflabel_fi, preflabel_sv, definition_fi)
VALUES
  ('01', 'Rakennusoikeus', 'byggrätt', 'Oikeus rakentaa määritellylle alueelle'),
  ('02', 'Asuminen', NULL, NULL),
  ('03', 'Palvelut', NULL, NULL),
  ('04', 'Elinkeinot', NULL, NULL),
  ('05', 'Viheralueet ja virkistys', NULL, NULL),
  ('06', 'Kadut', NULL, NULL),
  ('07', 'Kunnallistekniikka', NULL, NULL),
  ('08', 'Liikenneverkko', NULL, NULL),
  ('09', 'Kulttuuriympäristöt', NULL, NULL),
  ('10', 'Suojelu', NULL, NULL),
  ('11', 'Muu kaavoitusteema', NULL, NULL);


CREATE TABLE code_lists.spatial_plan_lifecycle_status (
  id SERIAL PRIMARY KEY,
  codevalue VARCHAR(3) NOT NULL UNIQUE,
  uri VARCHAR(255) NOT NULL UNIQUE,
  preflabel_fi VARCHAR NOT NULL,
  preflabel_sv VARCHAR,
  definition_fi VARCHAR,
  definition_sv VARCHAR,
  description_fi VARCHAR,
  description_sv VARCHAR,
);

CREATE TRIGGER code_lists.upsert_url_spatial_plan_lifecycle_status
  BEFORE INSERT OR UPDATE ON code_lists.spatial_plan_lifecycle_status
  FOR EACH ROW EXECUTE PROCEDURE code_lists.code_url_trigger('http://uri.suomi.fi/codelist/rytj/RY_KaavanElinkaaritila/code/');


INSERT INTO code_lists.spatial_plan_lifecycle_status (codevalue, preflabel_fi, preflabel_sv, definition_fi, description_fi)
VALUES
  ('01', 'Kaavoitusaloite', NULL, 'Kuntaan saapunut kaavoitusaloite', NULL),
  ('02', 'Vireilletullut', NULL, 'Viranomainen on ottanut kaava-asian käsiteltäväksi', NULL),
  ('03', 'Valmistelu', 'beredningsmaterial', NULL, 'Kaavaprosessin vaihe, jossa laaditaan kaavan valmisteluaineisto. Valmisteluaineisto koostuu kaavaehdotuksen tai muun päätösehdotuksen laatimista varten laadituista ja kerätyistä aineistoista.'),
  ('04', 'Kaavaehdotus', 'planförslag', 'Julkisesti nähtäville asetettava ehdotus kaavaksi', NULL),
  ('05', 'Tarkistettu kaavaehdotus', NULL, NULL, NULL),
  ('06', 'Hyväksytty kaava', NULL, 'Toimivaltainen viranomainen on hyväksynyt kaavaehdotuksen', NULL),
  ('07', 'Oikaisukehotuksen alainen', NULL, 'Kaavasta on jätetty oikaisukehotus', NULL),
  ('08', 'Valituksen alainen', NULL, 'Kaavasta on tehty valitus', NULL),
  ('09', 'Oikaisukehotuksen alainen ja valituksen alainen', NULL, 'Kaavasta on jätetty oikaisukehotus ja siitä on tehty valitus', NULL),
  ('10', 'Osittain voimassa', NULL, 'Kaava on kuulutettu osittain voimaan', NULL),
  ('11', 'Voimassa', NULL, 'Kaava on saanut lainvoiman', NULL),
  ('12', 'Kumottu', NULL, 'Kaava on kumottu', NULL),
  ('13', 'Kumoutunut', NULL, 'Kaava on kumoutunut kaavamuutoksen myötä', NULL),
  ('14', 'Rauennut', NULL, 'Kaava on rauennut kaavoitusprosessin keskeyttämisen myötä', NULL),
  ('15', 'Hylätty', NULL, NULL, NULL);

CREATE TABLE code_lists.spatial_plan_kind (
  id SERIAL PRIMARY KEY,
  group VARCHAR,
  codevalue VARCHAR(3) NOT NULL UNIQUE,
  uri VARCHAR(255) NOT NULL UNIQUE,
  preflabel_fi VARCHAR NOT NULL,
  preflabel_sv VARCHAR,
  description_fi VARCHAR,
  description_sv VARCHAR,
);

CREATE TRIGGER code_lists.upsert_url_spatial_plan_kind
  BEFORE INSERT OR UPDATE ON code_lists.spatial_plan_kind
  FOR EACH ROW EXECUTE PROCEDURE code_lists.code_url_trigger('http://uri.suomi.fi/codelist/rytj/RY_Kaavalaji/code/');

INSERT INTO code_lists.spatial_plan_kind (codevalue, group, preflabel_fi, preflabel_sv, description_fi)
VALUES
  ('21', 'Yleiskaava', 'Yleiskaava', 'Generalplan', 'Koko kuntaa tai kunnan osa-aluetta koskeva rajattuja teemoja käsittelevä yleiskaava.'),
  ('22', 'Yleiskaava', 'Vaiheyleiskaava', 'Etappgeneralplan', 'Koko kuntaa tai kunnan osa-aluetta koskeva rajattuja teemoja käsittelevä yleiskaava.'),
  ('23', 'Yleiskaava', 'Osayleiskaava', 'Delgeneralplan', 'Kunnan osa-aluetta koskeva yleiskaava.'),
  ('24', 'Yleiskaava', 'Kuntien yhteinen yleiskaava', 'Gemensam generalplan', 'Kahden tai useamman kunnan aluetta tai osa-aluetta koskeva yleiskaava (MRL 46 §) tai vaiheyleiskaava.'),
  ('25', 'Yleiskaava', 'Oikeusvaikutukseton yleiskaava', 'Generalplan utan rättsverkningar', 'Koko kuntaa tai kunnan osa-aluetta koskeva yleiskaava, jolla ei ole maankäyttö- ja rakennuslaissa tarkoitettuja oikeusvaikutuksia (MRL 45§).'),
  ('26', 'Yleiskaava', 'Maanalainen yleiskaava', NULL, NULL),
  ('31', 'Asemakaava', 'Asemakaava', 'Detaljplan', 'MRL 50 § mukaan laadittu yksityiskohtainen asemakaava tai asemakaavan muutos.'),
  ('32', 'Asemakaava', 'Vaiheasemakaava', 'Etappdetaljplan', 'MRL 50 § mukaan laadittu rajattuja teemoja käsittelevä asemakaava tai asemakaavan muutos,'),
  ('33', 'Asemakaava', 'Ranta-asemakaava', 'Stranddetaljplan', 'Asemakaava, joka laaditaan pääasiassa loma-asutuksen järjestämiseksi'),
  ('34', 'Asemakaava', 'Vaiheranta-asemakaava', 'Etappsranddetaljplan', 'Rajattuja teemoja käsittelevä asemakaava, joka laaditaan pääasiassa loma-asutuksen järjestämiseksi.'),
  ('35', 'Asemakaava', 'Maanalaisten tilojen asemakaava', 'Underjordisk detaljplan', NULL);

CREATE TABLE code_lists.digital_origin_kind (
  id SERIAL PRIMARY KEY,
  codevalue VARCHAR(3) NOT NULL UNIQUE,
  uri VARCHAR(255) NOT NULL UNIQUE,
  preflabel_fi VARCHAR NOT NULL
);

CREATE TRIGGER code_lists.upsert_url_digital_origin_kind
  BEFORE INSERT OR UPDATE ON code_lists.digital_origin_kind
  FOR EACH ROW EXECUTE PROCEDURE code_lists.code_url_trigger('http://uri.suomi.fi/codelist/rytj/RY_DigitaalinenAlkupera/code/');

INSERT INTO code_lists.digital_origin_kind (codevalue, preflabel_fi)
VALUES
  ('01', 'Tietomallin mukaan laadittu'),
  ('02', 'Kokonaan digitoitu'),
  ('03', 'Osittain digitoitu'),
  ('04', 'Rajaus digitoitu');

CREATE TABLE code_lists.ground_relativeness_kind (
  id SERIAL PRIMARY KEY,
  codevalue VARCHAR(3) NOT NULL UNIQUE,
  uri VARCHAR(255) NOT NULL UNIQUE,
  preflabel_fi VARCHAR NOT NULL
);

CREATE TRIGGER code_lists.upsert_url_ground_relativeness_kind
  BEFORE INSERT OR UPDATE ON code_lists.ground_relativeness_kind
  FOR EACH ROW EXECUTE PROCEDURE code_lists.code_url_trigger('http://uri.suomi.fi/codelist/rytj/RY_MaanalaisuudenLaji/code/');

INSERT INTO code_lists.ground_relativeness_kind (codevalue, preflabel_fi)
VALUES
  ('01', 'Maanalainen'),
  ('02', 'Maanpäällinen');

CREATE TABLE code_lists.bindingness_kind (
  id SERIAL PRIMARY KEY,
  codevalue VARCHAR(3) NOT NULL UNIQUE,
  uri VARCHAR(255) NOT NULL UNIQUE,
  preflabel_fi VARCHAR NOT NULL,
  description_fi VARCHAR
);

CREATE TRIGGER code_lists.upsert_url_bindingness_kind
  BEFORE INSERT OR UPDATE ON code_lists.bindingness_kind
  FOR EACH ROW EXECUTE PROCEDURE code_lists.code_url_trigger('http://uri.suomi.fi/codelist/rytj/RY_Sitovuuslaji/code/');

INSERT INTO code_lists.bindingness_kind (codevalue, preflabel_fi, description_fi)
VALUES
  ('01', 'Sitova', 'Kaavamääräyskohteen sijainti on oikeudellisesti sitova.'),
  ('02', 'Ohjeellinen', 'Kaavamääräyskohteen sijainti ei ole oikeudellisesti sitova.');

CREATE TABLE code_list.legal_effectiveness_kind (
  id SERIAL PRIMARY KEY,
  codevalue VARCHAR(3) NOT NULL UNIQUE,
  uri VARCHAR(255) NOT NULL UNIQUE,
  preflabel_fi VARCHAR NOT NULL,
  definition_fi VARCHAR
);

CREATE TRIGGER code_lists.upsert_url_legal_effectiveness_kind
  BEFORE INSERT OR UPDATE ON code_lists.legal_effectiveness_kind
  FOR EACH ROW EXECUTE PROCEDURE code_lists.code_url_trigger('http://uri.suomi.fi/codelist/rytj/RY_OikeusvaikutteisuudenLaji/code/');

INSERT INTO code_lists.legal_effectiveness_kind (codevalue, preflabel_fi, definition_fi)
VALUES
  ('01', 'Oikeusvaikutteinen', 'Päätetyllä maankäyttöasialla vaikutus, joka luo, muuttaa tai kumoaa oikeuden tai velvollisuuden'),
  ('02', 'Oikeusvaikutukseton', 'Päätetyllä maankäyttöasialla ei ole vaikutusta, joka luo, muuttaa tai kumoaa oikeuden tai velvollisuuden');


CREATE TABLE code_lists.detail_plan_regulation_kind(
  id SERIAL PRIMARY KEY,
  codevalue VARCHAR(6) NOT NULL UNIQUE,
  uri VARCHAR(255) NOT NULL UNIQUE,
  preflabel_fi VARCHAR NOT NULL,
  description_fi VARCHAR,
  main_class VARCHAR NOT NULL,
  sub_class VARCHAR
);

CREATE TRIGGER code_lists.upsert_url_detail_plan_regulation_kind
  BEFORE INSERT OR UPDATE ON code_lists.detail_plan_regulation_kind
  FOR EACH ROW EXECUTE PROCEDURE code_lists.code_url_trigger('http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/');

INSERT INTO code_lists.detail_plan_regulation_kind (codevalue, preflabel_fi, description_fi, main_class, sub_class)
VALUES
  ('01', 'Alueen käyttötarkoitus', NULL, 'Alueen käyttötarkoitus', NULL),
  ('0101', 'Asuminen', NULL, 'Alueen käyttötarkoitus', 'Asuminen'),
  ('010101', 'Asuinkerrostaloalue', NULL, 'Alueen käyttötarkoitus', 'Asuminen'),
  ('010102', 'Asuinpientaloalue', NULL, 'Alueen käyttötarkoitus', 'Asuminen'),
  ('010103', 'Rivitalojen ja muiden kytkettyjen asuinrakennusten alue', NULL, 'Alueen käyttötarkoitus', 'Asuminen'),
  ('010104', 'Erillispientaloalue', NULL, 'Alueen käyttötarkoitus', 'Asuminen'),
  ('010105', 'Asumista palveleva yhteiskäyttöinen alue', NULL, 'Alueen käyttötarkoitus', 'Asuminen'),
  ('010106', 'Maatilan talouskeskuksen alue', NULL, 'Alueen käyttötarkoitus', 'Asuminen'),
  ('010107', 'Kyläalue', NULL, 'Alueen käyttötarkoitus', 'Asuminen'),
  ('010108', 'Erityisryhmien palveluasuminen', NULL, 'Alueen käyttötarkoitus', 'Asuminen'),
  ('010109', 'Muu asuminen', NULL, 'Alueen käyttötarkoitus', 'Asuminen'),
  ('0102', 'Keskustatoiminnot', NULL, 'Alueen käyttötarkoitus', 'Keskustatoiminnot'),
  ('010201', 'Keskustatoimintojen alue', NULL, 'Alueen käyttötarkoitus', 'Keskustatoiminnot'),
  ('010202', 'Keskustatoimintojen alakeskus', NULL, 'Alueen käyttötarkoitus', 'Keskustatoiminnot'),
  ('010203', 'Muut keskustatoiminnot', NULL, 'Alueen käyttötarkoitus', 'Keskustatoiminnot'),
  ('0103', 'Liike- ja toimistorakentaminen', NULL, 'Alueen käyttötarkoitus', 'Liike- ja toimistorakentaminen'),
  ('010301', 'Liikerakennusten alue', NULL, 'Alueen käyttötarkoitus', 'Liike- ja toimistorakentaminen'),
  ('010302', 'Toimistorakennusten alue', NULL, 'Alueen käyttötarkoitus', 'Liike- ja toimistorakentaminen'),
  ('010303', 'Toimitilarakennusten alue', NULL, 'Alueen käyttötarkoitus', 'Liike- ja toimistorakentaminen'),
  ('010304', 'Kaupallisten palveluiden alue', NULL, 'Alueen käyttötarkoitus', 'Liike- ja toimistorakentaminen'),
  ('010305', 'Muu liike- ja toimistorakentaminen', NULL, 'Alueen käyttötarkoitus', 'Liike- ja toimistorakentaminen'),
  ('0104', 'Palvelut', NULL, 'Alueen käyttötarkoitus', 'Palvelut'),
  ('010401', 'Palvelurakennusten alue', NULL, 'Alueen käyttötarkoitus', 'Palvelut'),
  ('010402', 'Lähipalveluiden alue', NULL, 'Alueen käyttötarkoitus', 'Palvelut'),
  ('010403', 'Huvi- ja viihdepalveluiden alue', NULL, 'Alueen käyttötarkoitus', 'Palvelut'),
  ('010404', 'Muut palvelut', NULL, 'Alueen käyttötarkoitus', 'Palvelut'),
  ('0105', 'Julkiset palvelut', NULL, 'Alueen käyttötarkoitus', 'Julkiset palvelut'),
  ('010501', 'Julkiset palvelut', NULL, 'Alueen käyttötarkoitus', 'Julkiset palvelut'),
  ('010502', 'Yleisten rakennusten alue', NULL, 'Alueen käyttötarkoitus', 'Julkiset palvelut'),
  ('010503', 'Julkisten lähipalveluiden alue', NULL, 'Alueen käyttötarkoitus', 'Julkiset palvelut'),
  ('010504', 'Hallinto- ja virastorakennusten alue', NULL, 'Alueen käyttötarkoitus', 'Julkiset palvelut'),
  ('010505', 'Opetustoimintaa palvelevien rakennusten alue', NULL, 'Alueen käyttötarkoitus', 'Julkiset palvelut'),
  ('010506', 'Sosiaalitointa ja terveydenhuoltoa palvelevien rakennusten alue', NULL, 'Alueen käyttötarkoitus', 'Julkiset palvelut'),
  ('010507', 'Kulttuuritoimintaa palvelevien rakennusten alue', NULL, 'Alueen käyttötarkoitus', 'Julkiset palvelut'),
  ('010508', 'Museorakennusten alue', NULL, 'Alueen käyttötarkoitus', 'Julkiset palvelut'),
  ('010509', 'Kirkkojen ja muiden seurakunnallisten rakennusten alue', NULL, 'Alueen käyttötarkoitus', 'Julkiset palvelut'),
  ('010510', 'Urheilutoimintaa palvelevien rakennusten alue', NULL, 'Alueen käyttötarkoitus', 'Julkiset palvelut'),
  ('010511', 'Julkisten palveluiden ja hallinnon alue', NULL, 'Alueen käyttötarkoitus', 'Julkiset palvelut'),
  ('010512', 'Muut julkiset palvelut', NULL, 'Alueen käyttötarkoitus', 'Julkiset palvelut'),
  ('0106', 'Työ ja tuotanto', NULL, 'Alueen käyttötarkoitus', 'Työ ja tuotanto'),
  ('010601', 'Työpaikka-alue', NULL, 'Alueen käyttötarkoitus', 'Työ ja tuotanto'),
  ('010602', 'Teollisuusalue', NULL, 'Alueen käyttötarkoitus', 'Työ ja tuotanto'),
  ('010603', 'Varastorakennusten alue', NULL, 'Alueen käyttötarkoitus', 'Työ ja tuotanto'),
  ('010604', 'Alue, jolle saa sijoittaa merkittävän, vaarallisia kemikaaleja valmistavan tai varastoivan laitoksen', NULL, 'Alueen käyttötarkoitus', 'Työ ja tuotanto'),
  ('010605', 'Ympäristövaikutuksiltaan merkittävien teollisuustoimintojen alue', NULL, 'Alueen käyttötarkoitus', 'Työ ja tuotanto'),
  ('010606', 'Kiertotalous', NULL, 'Alueen käyttötarkoitus', 'Työ ja tuotanto'),
  ('010607', 'Ympäristöhäiriötä aiheuttava tuotantotoiminta', NULL, 'Alueen käyttötarkoitus', 'Työ ja tuotanto'),
  ('010608', 'Muu työpaikka- tai tuontantoalue', NULL, 'Alueen käyttötarkoitus', 'Työ ja tuotanto'),
  ('0107', 'Virkistys', NULL, 'Alueen käyttötarkoitus', 'Virkistys'),
  ('010701', 'Virkistysalue', NULL, 'Alueen käyttötarkoitus', 'Virkistys'),
  ('010702', 'Puisto', NULL, 'Alueen käyttötarkoitus', 'Virkistys'),
  ('010703', 'Lähivirkistysalue', NULL, 'Alueen käyttötarkoitus', 'Virkistys'),
  ('010704', 'Leikkipuisto', NULL, 'Alueen käyttötarkoitus', 'Virkistys'),
  ('010705', 'Urheilupalvelujen alue', NULL, 'Alueen käyttötarkoitus', 'Virkistys'),
  ('010706', 'Retkeily- ja ulkoilualue', NULL, 'Alueen käyttötarkoitus', 'Virkistys'),
  ('010707', 'Uimaranta-alue', NULL, 'Alueen käyttötarkoitus', 'Virkistys'),
  ('010708', 'Lähimetsä', NULL, 'Alueen käyttötarkoitus', 'Virkistys'),
  ('010709', 'Muu virkistysalue', NULL, 'Alueen käyttötarkoitus', 'Virkistys'),
  ('0108', 'Loma-asuminen ja matkailu', NULL, 'Alueen käyttötarkoitus', 'Loma-asuminen ja matkailu'),
  ('010801', 'Loma-asuntojen alue', NULL, 'Alueen käyttötarkoitus', 'Loma-asuminen ja matkailu'),
  ('010802', 'Matkailua palvelevien rakennusten alue', NULL, 'Alueen käyttötarkoitus', 'Loma-asuminen ja matkailu'),
  ('010803', 'Leirintäalue', NULL, 'Alueen käyttötarkoitus', 'Loma-asuminen ja matkailu'),
  ('010804', 'Asuntovaunualue', NULL, 'Alueen käyttötarkoitus', 'Loma-asuminen ja matkailu'),
  ('010805', 'Siirtolapuutarha-/palstaviljelyalue', NULL, 'Alueen käyttötarkoitus', 'Loma-asuminen ja matkailu'),
  ('010806', 'Muu loma-asumisen tai matkailun alue', NULL, 'Alueen käyttötarkoitus', 'Loma-asuminen ja matkailu'),
  ('0109', 'Liikenne', NULL, 'Alueen käyttötarkoitus', 'Liikenne'),
  ('010901', 'Liikennealue', NULL, 'Alueen käyttötarkoitus', 'Liikenne'),
  ('010902', 'Yleisen tien alue', NULL, 'Alueen käyttötarkoitus', 'Liikenne'),
  ('010903', 'Rautatieliikenteen alue', NULL, 'Alueen käyttötarkoitus', 'Liikenne'),
  ('010904', 'Lentoliikenteen alue', NULL, 'Alueen käyttötarkoitus', 'Liikenne'),
  ('010905', 'Satama-alue', NULL, 'Alueen käyttötarkoitus', 'Liikenne'),
  ('010906', 'Kanava-alue', NULL, 'Alueen käyttötarkoitus', 'Liikenne'),
  ('010907', 'Venesatama/venevalkama', NULL, 'Alueen käyttötarkoitus', 'Liikenne'),
  ('010908', 'Yleinen pysäköintialue', NULL, 'Alueen käyttötarkoitus', 'Liikenne'),
  ('010909', 'Huoltoasema-alue', NULL, 'Alueen käyttötarkoitus', 'Liikenne'),
  ('010910', 'Henkilöliikenteen terminaalialue', NULL, 'Alueen käyttötarkoitus', 'Liikenne'),
  ('010911', 'Tavaraliikenteen terminaalialue', NULL, 'Alueen käyttötarkoitus', 'Liikenne'),
  ('010912', 'Yleisten pysäköintilaitosten alue', NULL, 'Alueen käyttötarkoitus', 'Liikenne'),
  ('010913', 'Autopaikkojen alue', NULL, 'Alueen käyttötarkoitus', 'Liikenne'),
  ('010914', 'Katualue', NULL, 'Alueen käyttötarkoitus', 'Liikenne'),
  ('010915', 'Muu liikennealue', NULL, 'Alueen käyttötarkoitus', 'Liikenne'),
  ('0110', 'Erityisalueet', NULL, 'Alueen käyttötarkoitus', 'Erityisalueet'),
  ('011001', 'Erityisalue', NULL, 'Alueen käyttötarkoitus', 'Erityisalueet'),
  ('011002', 'Yhdyskuntateknisen huollon alue', NULL, 'Alueen käyttötarkoitus', 'Erityisalueet'),
  ('011003', 'Energiahuollon alue', NULL, 'Alueen käyttötarkoitus', 'Erityisalueet'),
  ('011004', 'Jätteenkäsittelyalue', NULL, 'Alueen käyttötarkoitus', 'Erityisalueet'),
  ('011005', 'Maa-ainesten ottoalue', NULL, 'Alueen käyttötarkoitus', 'Erityisalueet'),
  ('011006', 'Kaivosalue', NULL, 'Alueen käyttötarkoitus', 'Erityisalueet'),
  ('011007', 'Mastoalue', NULL, 'Alueen käyttötarkoitus', 'Erityisalueet'),
  ('011008', 'Ampumarata-alue', NULL, 'Alueen käyttötarkoitus', 'Erityisalueet'),
  ('011009', 'Puolustusvoimien alue', NULL, 'Alueen käyttötarkoitus', 'Erityisalueet'),
  ('011010', 'Hautausmaa-alue', NULL, 'Alueen käyttötarkoitus', 'Erityisalueet'),
  ('011011', 'Suojaviheralue', NULL, 'Alueen käyttötarkoitus', 'Erityisalueet'),
  ('011012', 'Tuulivoimaloiden alue', NULL, 'Alueen käyttötarkoitus', 'Erityisalueet'),
  ('011013', 'Moottorirata', NULL, 'Alueen käyttötarkoitus', 'Erityisalueet'),
  ('011014', 'Maa-ainesten vastaanotto- tai läjitysalue', NULL, 'Alueen käyttötarkoitus', 'Erityisalueet'),
  ('011015', 'Vankila-alue', NULL, 'Alueen käyttötarkoitus', 'Erityisalueet'),
  ('011016', 'Muu erityisalue', NULL, 'Alueen käyttötarkoitus', 'Erityisalueet'),
  ('0111', 'Suojelu', NULL, 'Alueen käyttötarkoitus', 'Suojelu'),
  ('011101', 'Suojelualue', NULL, 'Alueen käyttötarkoitus', 'Suojelu'),
  ('011102', 'Luonnonsuojelualue', NULL, 'Alueen käyttötarkoitus', 'Suojelu'),
  ('011103', 'Muinaismuistoalue', NULL, 'Alueen käyttötarkoitus', 'Suojelu'),
  ('011104', 'Rakennuslainsäädännön nojalla suojeltava alue', NULL, 'Alueen käyttötarkoitus', 'Suojelu'),
  ('011105', 'Rakennussuojelulakien nojalla suojeltu alue', NULL, 'Alueen käyttötarkoitus', 'Suojelu'),
  ('011106', 'Muu suojelualue', NULL, 'Alueen käyttötarkoitus', 'Suojelu'),
  ('0112', 'Maa- ja metsätalous', NULL, 'Alueen käyttötarkoitus', 'Maa- ja metsätalous'),
  ('011201', 'Maa- ja metsätalousalue', NULL, 'Alueen käyttötarkoitus', 'Maa- ja metsätalous'),
  ('011202', 'Maatalousalue', NULL, 'Alueen käyttötarkoitus', 'Maa- ja metsätalous'),
  ('011203', 'Kotieläintalouden suuryksikön alue', NULL, 'Alueen käyttötarkoitus', 'Maa- ja metsätalous'),
  ('011204', 'Puutarha- ja kasvihuonealue', NULL, 'Alueen käyttötarkoitus', 'Maa- ja metsätalous'),
  ('011205', 'Maisemallisesti arvokas peltoalue', NULL, 'Alueen käyttötarkoitus', 'Maa- ja metsätalous'),
  ('011206', 'Poronhoitovaltainen maa- ja metsätalousalue', NULL, 'Alueen käyttötarkoitus', 'Maa- ja metsätalous'),
  ('011207', 'Muu maa- ja metsätalousalue', NULL, 'Alueen käyttötarkoitus', 'Maa- ja metsätalous'),
  ('0113', 'Vesialueet', NULL, 'Alueen käyttötarkoitus', 'Vesialueet'),
  ('011301', 'Vesialue', NULL, 'Alueen käyttötarkoitus', 'Vesialueet'),
  ('011302', 'Muu vesialue', NULL, 'Alueen käyttötarkoitus', 'Vesialueet'),
  ('02', 'Alueen osan käyttötarkoitus', NULL, 'Alueen osan käyttötarkoitus', NULL),
  ('0201', 'Yhdyskuntatekninen käyttö', NULL, 'Alueen osan käyttötarkoitus', 'Yhdyskuntatekninen käyttö'),
  ('020101', 'Johto, putki tai linja', 'Maan alaista tai maan päällistä johtoa, putkea tai linjaa varten varattu alue.', 'Alueen osan käyttötarkoitus', 'Yhdyskuntatekninen käyttö'),
  ('020102', 'Sähkölinja', NULL, 'Alueen osan käyttötarkoitus', 'Yhdyskuntatekninen käyttö'),
  ('020103', 'Kaasulinja', NULL, 'Alueen osan käyttötarkoitus', 'Yhdyskuntatekninen käyttö'),
  ('020104', 'Vesi- tai jätevesitunneli', NULL, 'Alueen osan käyttötarkoitus', 'Yhdyskuntatekninen käyttö'),
  ('020105', 'Vesijohto tai siirtoviemäri', NULL, 'Alueen osan käyttötarkoitus', 'Yhdyskuntatekninen käyttö'),
  ('020106', 'Kaukolämpölinja', NULL, 'Alueen osan käyttötarkoitus', 'Yhdyskuntatekninen käyttö'),
  ('020107', 'Kaukokylmälinja', NULL, 'Alueen osan käyttötarkoitus', 'Yhdyskuntatekninen käyttö'),
  ('020108', 'Tulvapenger', NULL, 'Alueen osan käyttötarkoitus', 'Yhdyskuntatekninen käyttö'),
  ('020109', 'Tulvareitti', NULL, 'Alueen osan käyttötarkoitus', 'Yhdyskuntatekninen käyttö'),
  ('020110', 'Pumppaamo', NULL, 'Alueen osan käyttötarkoitus', 'Yhdyskuntatekninen käyttö'),
  ('020111', 'Muuntamo', NULL, 'Alueen osan käyttötarkoitus', 'Yhdyskuntatekninen käyttö'),
  ('020112', 'Suojavyöhyke', NULL, 'Alueen osan käyttötarkoitus', 'Yhdyskuntatekninen käyttö'),
  ('020113', 'Hulevesijärjestelmä', NULL, 'Alueen osan käyttötarkoitus', 'Yhdyskuntatekninen käyttö'),
  ('020114', 'Hulevesien viivytysallas', NULL, 'Alueen osan käyttötarkoitus', 'Yhdyskuntatekninen käyttö'),
  ('020115', 'Avo-oja', NULL, 'Alueen osan käyttötarkoitus', 'Yhdyskuntatekninen käyttö'),
  ('020116', 'Muu yhdyskuntatekniseen huoltoon liittyvä käyttö', NULL, 'Alueen osan käyttötarkoitus', 'Yhdyskuntatekninen käyttö'),
  ('0202', 'Ulkoalueiden käyttö', NULL, 'Alueen osan käyttötarkoitus', 'Ulkoalueiden käyttö'),
  ('020201', 'Istutettava alueen osa', NULL, 'Alueen osan käyttötarkoitus', 'Ulkoalueiden käyttö'),
  ('020202', 'Leikkialue', NULL, 'Alueen osan käyttötarkoitus', 'Ulkoalueiden käyttö'),
  ('020203', 'Oleskelualue', NULL, 'Alueen osan käyttötarkoitus', 'Ulkoalueiden käyttö'),
  ('020204', 'Puurivi', 'Säilytettävä/istutettava puurivi', 'Alueen osan käyttötarkoitus', 'Ulkoalueiden käyttö'),
  ('020205', 'Muuri', NULL, 'Alueen osan käyttötarkoitus', 'Ulkoalueiden käyttö'),
  ('020206', 'Pengerrys', NULL, 'Alueen osan käyttötarkoitus', 'Ulkoalueiden käyttö'),
  ('020207', 'Muu tontinkäyttöön liittyvä käyttö', NULL, 'Alueen osan käyttötarkoitus', 'Ulkoalueiden käyttö'),
  ('0203', 'Liikennekäyttö', NULL, 'Alueen osan käyttötarkoitus', 'Liikennekäyttö'),
  ('020301', 'Ajoluiska', 'Maanalaisiin tiloihin johtava ajoluiska'),
  ('020302', 'Ajoyhteys', NULL, 'Alueen osan käyttötarkoitus', 'Liikennekäyttö'),
  ('020303', 'Alikulku', 'Kadun tai liikennealueen alittava kevyen liikenteen yhteys', 'Alueen osan käyttötarkoitus', 'Liikennekäyttö'),
  ('020304', 'Auton säilytyspaikka', NULL, 'Alueen osan käyttötarkoitus', 'Liikennekäyttö'),
  ('020305', 'Eritasoristeys', NULL, 'Alueen osan käyttötarkoitus', 'Liikennekäyttö'),
  ('020306', 'Hidaskatu', NULL, 'Alueen osan käyttötarkoitus', 'Liikennekäyttö'),
  ('020307', 'Katuaukio/Tori', NULL, 'Alueen osan käyttötarkoitus', 'Liikennekäyttö'),
  ('020308', 'Liikennetunneli', NULL, 'Alueen osan käyttötarkoitus', 'Liikennekäyttö'),
  ('020309', 'Pelastustie', NULL, 'Alueen osan käyttötarkoitus', 'Liikennekäyttö'),
  ('020310', 'Pihakatu', NULL, 'Alueen osan käyttötarkoitus', 'Liikennekäyttö'),
  ('020311', 'Pysäköintialue', NULL, 'Alueen osan käyttötarkoitus', 'Liikennekäyttö'),
  ('020312', 'Tontille ajo sallittu', NULL, 'Alueen osan käyttötarkoitus', 'Liikennekäyttö'),
  ('020313', 'Ulkoilureitti', NULL, 'Alueen osan käyttötarkoitus', 'Liikennekäyttö'),
  ('020314', 'Varattu alueen sisäiselle huoltoajolle', NULL, 'Alueen osan käyttötarkoitus', 'Liikennekäyttö'),
  ('020315', 'Varattu alueen sisäiselle jalankululle', NULL, 'Alueen osan käyttötarkoitus', 'Liikennekäyttö'),
  ('020316', 'Varattu alueen sisäiselle polkupyöräilylle', NULL, 'Alueen osan käyttötarkoitus', 'Liikennekäyttö'),
  ('020317', 'Varattu huoltoajolle', NULL, 'Alueen osan käyttötarkoitus', 'Liikennekäyttö'),
  ('020318', 'Varattu jalankululle', NULL, 'Alueen osan käyttötarkoitus', 'Liikennekäyttö'),
  ('020319', 'Varattu joukkoliikenteelle', NULL, 'Alueen osan käyttötarkoitus', 'Liikennekäyttö'),
  ('020320', 'Varattu polkypyöräilylle', NULL, 'Alueen osan käyttötarkoitus', 'Liikennekäyttö'),
  ('020321', 'Yleisen tien näkemäalue', NULL, 'Alueen osan käyttötarkoitus', 'Liikennekäyttö'),
  ('020322', 'Yleisen tien suoja-alue', 'Yleisen tien suoja-alueeksi varattu alueen osa', 'Alueen osan käyttötarkoitus', 'Liikennekäyttö'),
  ('020323', 'Ylikulku', 'Kadun tai liikennealueen ylittävä kevyen liikenteen yhteys', 'Alueen osan käyttötarkoitus', 'Liikennekäyttö'),
  ('020324', 'Muu liikennejärjestelmään liittyvä käyttö', NULL, 'Alueen osan käyttötarkoitus', 'Liikennekäyttö'),
  ('0204', 'Virkistyskäyttö', NULL, 'Alueen osan käyttötarkoitus', 'Virkistyskäyttö'),
  ('020401', 'Asuntovaunualue', NULL, 'Alueen osan käyttötarkoitus', 'Virkistyskäyttö'),
  ('020402', 'Frisbeegolf', NULL, 'Alueen osan käyttötarkoitus', 'Virkistyskäyttö'),
  ('020403', 'Golf-väylä', 'Golf-väylä suoja-alueineen', 'Alueen osan käyttötarkoitus', 'Virkistyskäyttö'),
  ('020404', 'Kenttä', NULL, 'Alueen osan käyttötarkoitus', 'Virkistyskäyttö'),
  ('020405', 'Koirapuisto', NULL, 'Alueen osan käyttötarkoitus', 'Virkistyskäyttö'),
  ('020406', 'Mäenlaskupaikka', NULL, 'Alueen osan käyttötarkoitus', 'Virkistyskäyttö'),
  ('020407', 'Ratsastuskenttä', NULL, 'Alueen osan käyttötarkoitus', 'Virkistyskäyttö'),
  ('020408', 'Telttailu', NULL, 'Alueen osan käyttötarkoitus', 'Virkistyskäyttö'),
  ('020409', 'Muu virkistyskäyttö', NULL, 'Alueen osan käyttötarkoitus', 'Virkistyskäyttö'),
  ('0205', 'Maatalouskäyttö', NULL, 'Alueen osan käyttötarkoitus', 'Maatalouskäyttö'),
  ('020501', 'Laidun', NULL, 'Alueen osan käyttötarkoitus', 'Maatalouskäyttö'),
  ('020502', 'Muu maatalouskäyttö', NULL, 'Alueen osan käyttötarkoitus', 'Maatalouskäyttö'),
  ('0206', 'Rakennusalan käyttötarkoitus', 'Rakennuksen käyttötarkoitusta tarkentava kaavamääräys. Käyttötarkoitus ilmaistaan Rakennusluokitus 2018 -koodiston avulla tai tekstiarvona.', 'Alueen osan käyttötarkoitus', 'Rakennusalan käyttötarkoitus'),
  ('0207', 'Muu alueen osan käyttötarkoitus', NULL, 'Alueen osan käyttötarkoitus', 'Muu alueen osan käyttötarkoitus'),
  ('03', 'Rakentamisen määrä', NULL, 'Rakentamisen määrä', NULL),
  ('0301', 'Sallittu kerrosala', 'Sallittu kerrosala kerrosneliömetreinä (m2)', 'Rakentamisen määrä', 'Sallittu kerrosala'),
  ('0302', 'Sallittu rakennustilavuus', 'Rakennuksen sallittu tilavuus kuutiometreinä (m3)', 'Rakentamisen määrä', 'Sallittu rakennustilavuus'),
  ('0303', 'Tehokkuusluku', 'sallitun kerrosalan suhde tontin/rakennuspaikan pinta-alaan', 'Rakentamisen määrä', 'Tehokkuusluku'),
  ('0304', 'Maanpäällinen kerrosluku', NULL, 'Rakentamisen määrä', 'Maanpäällinen kerrosluku'),
  ('0305', 'Maanalainen kerrosluku', NULL, 'Rakentamisen määrä', 'Maanalainen kerrosluku'),
  ('0306', 'Kellarin sallittu kerrosalaosuus', 'ilmaisee kuinka suuren osan rakennuksen suurimman kerroksen alasta saa kellarikerroksessa käyttää kerrosalaan luettavaksi tilaksi.', 'Rakentamisen määrä', 'Kellarin sallittu kerrosalaosuus'),
  ('0307', 'Ullakon sallittu kerrosalaosuus', 'ilmaiseen kuinka suuren osan rakennuksen suurimman kerroksen alasta ullakon tasolla saa käyttää kerrosalaan laskettavaksi tilaksi.', 'Rakentamisen määrä', 'Ullakon sallittu kerrosalaosuus'),
  ('0308', 'Rakennuspaikkojen määrä', 'Ranta-asemakaavassa osoitettavien rakennuspaikkojen määrä', 'Rakentamisen määrä', 'Rakennuspaikkojen määrä'),
  ('0309', 'Lisärakennusoikeus', NULL, 'Rakentamisen määrä', 'Lisärakennusoikeus'),
  ('04', 'Rakennusten sijoitus', NULL, 'Rakennusten sijoitus', NULL),
  ('0401', 'Rakentamisen suhde alueen pinta-alaan', 'Luku osoittaa, kuinka suuren osan alueesta tai rakennusalasta saa käyttää rakentamiseen.', 'Rakennusten sijoitus', 'Rakentamisen suhde alueen pinta-alaan'),
  ('0402', 'Etäisyys naapuritontin rajasta', 'Rakennusten etäisyyden naapuritontin rajasta on oltava vähintään kaavamääräykseen liitetyn numeerisen arvon mukainen.', 'Rakennusten sijoitus', 'Etäisyys naapuritontin rajasta'),
  ('0403', 'Rakennusala', 'asemakaavassa rakentamiselle osoitettu, rajoiltaan määrätty korttelin tai tontin osa', 'Rakennusten sijoitus', 'Rakennusala'),
  ('0404', 'Rakennettava kiinni rajaan', 'Rakennusalan sivu, johon rakennus on rakennettava kiinni', 'Rakennusten sijoitus', 'Rakennettava kiinni rajaan'),
  ('0405', 'Rakennuspaikka', 'Ranta-asemakaavan mukainen rakennuspaikka', 'Rakennusten sijoitus', 'Rakennuspaikka'),
  ('0406', 'Muu rakennusten sijoitukseen liittyvä määräys', NULL, 'Rakennusten sijoitus', 'Muu rakennusten sijoitukseen liittyvä määräys'),
  ('05', 'Rakentamistapa', NULL, 'Rakentamistapa', NULL),
  ('0501', 'Kattokaltevuus', NULL, 'Rakentamistapa', 'Kattokaltevuus'),
  ('0502', 'Uloke', NULL, 'Rakentamistapa', 'Uloke'),
  ('0503', 'Rakennuksen harjansuunta', NULL, 'Rakentamistapa', 'Rakennuksen harjansuunta'),
  ('0504', 'Kulkuaukko', 'Rakennukseen jätettävä kulkuaukko', 'Rakentamistapa', 'Kulkuaukko'),
  ('0505', 'Valokatteinen tila', NULL, 'Rakentamistapa', 'Valokatteinen tila'),
  ('0506', 'Suora uloskäynti porrashuoneista', 'Rakennuksen sivu, jolla tulee olla suora uloskäynti porrashuoneista', 'Rakentamistapa', 'Suora uloskäynti porrashuoneista'),
  ('0507', 'Ei saa rakentaa ikkunoita', 'Rakennusalan sivu, jonka puoleiseen rakennuksen seinään ei saa sijoittaa ikkunoita', 'Rakentamistapa', 'Ei saa rakentaa ikkunoita'),
  ('0508', 'Ääneneristävyys', 'Rakennusalan sivu, jonka puoleisten rakennusten ulkoseinien sekä ikkunoiden ja muiden rakenteiden ääneneristävyyden liikennemelua vastaan on oltava vähintää xx dBA', 'Rakentamistapa', 'Ääneneristävyys'),
  ('0509', 'Parvekkeet sijoitettava rungon sisään', NULL, 'Rakentamistapa', 'Parvekkeet sijoitettava rungon sisään'),
  ('0510', 'Hissi', NULL, 'Rakentamistapa', 'Hissi'),
  ('0511', 'Viherkatto', NULL, 'Rakentamistapa', 'Viherkatto'),
  ('0512', 'Kelluvat asuinrakennukset', 'Rakennukset saa toteuttaa kelluvina', 'Rakentamistapa', 'Kelluvat asuinrakennukset'),
  ('0513', 'Muu rakentamistapaan liittyvä määräys', NULL, 'Rakentamistapa', 'Muu rakentamistapaan liittyvä määräys'),
  ('06', 'Korkeusasema', NULL, 'Korkeusasema', NULL),
  ('0601', 'Maanpinnan korkeusasema', NULL, 'Korkeusasema', 'Maanpinnan korkeusasema'),
  ('0602', 'Rakennuksen vesikaton ylimmän kohdan korkeusasema', NULL, 'Korkeusasema', 'Rakennuksen vesikaton ylimmän kohdan korkeusasema'),
  ('0603', 'Rakennuksen julkisivupinnan ja vesikaton leikkauskohdan korkeusasema', NULL, 'Korkeusasema', 'Rakennuksen julkisivupinnan ja vesikaton leikkauskohdan korkeusasema'),
  ('0604', 'Rakennuksen julkisivun enimmäiskorkeus metreinä', NULL, 'Korkeusasema', 'Rakennuksen julkisivun enimmäiskorkeus metreinä'),
  ('0605', 'Rakennuksen, rakenteiden ja laitteiden ylin korkeusasema', NULL, 'Korkeusasema', 'Rakennuksen, rakenteiden ja laitteiden ylin korkeusasema'),
  ('0606', 'Maanalaisen kohteen korkeusasema', NULL, 'Korkeusasema', 'Maanalaisen kohteen korkeusasema'),
  ('0607', 'Muu korkeusasemaan liittyvä määräys', NULL, 'Korkeusasema', 'Muu korkeusasemaan liittyvä määräys'),
  ('07', 'Ulkoalueet', 'Rakennusten ulkopuoleisten alueiden toteuttaminen', 'Ulkoalueet', NULL),
  ('0701', 'Vihertehokkuus', NULL, 'Ulkoalueet', 'Vihertehokkuus'),
  ('0702', 'Puusto tai kasvillisuus säilytettävä tai korvattava', NULL, 'Ulkoalueet', 'Puusto tai kasvillisuus säilytettävä tai korvattava'),
  ('0703', 'Olemassa oleva puusto säilytettävä', 'Olemassa oleva puusto tulee mahdollisuuksien mukaan säilyttää.', 'Ulkoalueet', 'Olemassa oleva puusto säilytettävä'),
  ('0704', 'Maisema säilytettävä avoimena', NULL, 'Ulkoalueet', 'Maisema säilytettävä avoimena'),
  ('0705', 'Muu ulkoalueiden toteuttamiseen liittyvä määräys', NULL, 'Ulkoalueet', 'Muu ulkoalueiden toteuttamiseen liittyvä määräys'),
  ('08', 'Liikenne', NULL, 'Liikenne', NULL),
  ('0801', 'Ajoneuvoliittymä', NULL, 'Liikenne', 'Ajoneuvoliittymä'),
  ('0802', 'Ajoneuvoliittymän kielto', 'Katualueen rajan osa, jonka kohdalta ei saa järjestää ajoneuvoliittymää', 'Liikenne', 'Ajoneuvoliittymän kielto'),
  ('0803', 'Autopaikkojen määrä', NULL, 'Liikenne', 'Autopaikkojen määrä'),
  ('0804', 'Polkupyöräpysäköinnin määrä', NULL, 'Liikenne', 'Polkupyöräpysäköinnin määrä'),
  ('0805', 'Muu liikenteeseen liittyvä määräys', NULL, 'Liikenne', 'Muu liikenteeseen liittyvä määräys'),
  ('09', 'Ympäristöarvojen vaaliminen', NULL, 'Ympäristöarvojen vaaliminen', NULL),
  ('0901', 'Kulttuurihistoriallisesti arvokas alue tai kohde', NULL, 'Ympäristöarvojen vaaliminen', 'Kulttuurihistoriallisesti arvokas alue tai kohde'),
  ('090101', 'Suojeltava alue tai alueen osa', NULL, 'Ympäristöarvojen vaaliminen', 'Kulttuurihistoriallisesti arvokas alue tai kohde'),
  ('090102', 'Suojeltava rakennus', NULL, 'Ympäristöarvojen vaaliminen', 'Kulttuurihistoriallisesti arvokas alue tai kohde'),
  ('090103', 'Suojeltava rakennelma', NULL, 'Ympäristöarvojen vaaliminen', 'Kulttuurihistoriallisesti arvokas alue tai kohde'),
  ('090104', 'Kiinteä suojeltava kohde', NULL, 'Ympäristöarvojen vaaliminen', 'Kulttuurihistoriallisesti arvokas alue tai kohde'),
  ('090105', 'Kiinteä muinaisjäännös', 'Alue tai alueen osa, jolla sijaitsee muinaismuistolailla rauhoitettu kiinteä muinaisjäännös', 'Ympäristöarvojen vaaliminen', 'Kulttuurihistoriallisesti arvokas alue tai kohde'),
  ('0902', 'Luontoarvoiltaan arvokas alue tai kohde', NULL, 'Ympäristöarvojen vaaliminen', 'Luontoarvoiltaan arvokas alue tai kohde'),
  ('090201', 'Suojeltu puu', NULL, 'Ympäristöarvojen vaaliminen', 'Luontoarvoiltaan arvokas alue tai kohde'),
  ('090202', 'Säilytettävä puu', NULL, 'Ympäristöarvojen vaaliminen', 'Luontoarvoiltaan arvokas alue tai kohde'),
  ('090203', 'Suojeltava vesistö tai vesialue', NULL, 'Ympäristöarvojen vaaliminen', 'Luontoarvoiltaan arvokas alue tai kohde'),
  ('090204', 'Luonnon monimuotoisuuden kannalta tärkeä alue', NULL, 'Ympäristöarvojen vaaliminen', 'Luontoarvoiltaan arvokas alue tai kohde'),
  ('090205', 'Ekologinen yhteys', NULL, 'Ympäristöarvojen vaaliminen', 'Luontoarvoiltaan arvokas alue tai kohde'),
  ('0903', 'Alue, jolla ympäristö säilytetään', NULL, 'Ympäristöarvojen vaaliminen', 'Alue, jolla ympäristö säilytetään'),
  ('0904', 'Alue, jolla on erityistä ulkoilun ohjaamistarvetta', NULL, 'Ympäristöarvojen vaaliminen', 'Alue, jolla on erityistä ulkoilun ohjaamistarvetta'),
  ('10', 'Tonttijako', 'maa-alueen jakautuminen asemakaavassa osoitetuiksi yksiköiksi, joista on muodostettu tai joista on tarkoitus muodostaa tontteja soveltuvalla kiinteistönmuodostustoimituksella', 'Tonttijako', NULL),
  ('1001', 'Sitova tonttijako laadittava', NULL, 'Tonttijako', 'Sitova tonttijako laadittava'),
  ('1002', 'Ohjeellinen kaavan mukainen tontti', NULL, 'Tonttijako', 'Ohjeellinen kaavan mukainen tontti'),
  ('1003', 'Sitovan tonttijaon mukainen tontti', NULL, 'Tonttijako', 'Sitovan tonttijaon mukainen tontti'),
  ('11', 'Yleismääräykset', NULL, 'Yleismääräykset', NULL),
  ('1101', 'Yleismääräys', NULL, 'Yleismääräykset', 'Yleismääräys'),
  ('1102', 'Ajanmukaisuuden arvioinnin aikaraja', 'Asemakaavan ajanmukaisuuden arviointi on tehtävä kaavamääräyksen numeerisen arvon osoittaman vuoden kuluttua kaavan voimaantulosta.', 'Yleismääräykset', 'Ajanmukaisuuden arvioinnin aikaraja'),
  ('1103', 'Aluetta koskee sitovat rakentamistapaohjeet', 'Aluetta koskee sitovat rakennustapaohjeet', 'Yleismääräykset', 'Aluetta koskee sitovat rakentamistapaohjeet'),
  ('1104', 'Aluetta koskee rakentamistapaohjeet', 'Alueelle on laadittu rakentamistapaohjeet', 'Yleismääräykset', 'Aluetta koskee rakentamistapaohjeet'),
  ('12', 'Yhdyskuntatekninen huolto', NULL, 'Yhdyskuntatekninen huolto', NULL),
  ('1201', 'Alin painovoimainen viemäröintitaso', NULL, 'Yhdyskuntatekninen huolto', 'Alin painovoimainen viemäröintitaso'),
  ('1202', 'Aurinkokennojen alin sijoittumistaso', NULL, 'Yhdyskuntatekninen huolto', 'Aurinkokennojen alin sijoittumistaso'),
  ('1203', 'Vaatimus hulevesisuunnitelman laatimisesta', 'Alueelle tulee laatia hulevesisuunnitelma.', 'Yhdyskuntatekninen huolto', 'Vaatimus hulevesisuunnitelman laatimisesta'),
  ('1204', 'Liitettävä kaukolämpöverkkoon', 'Alue on liitettävä kaukolämpöverkkoon.', 'Yhdyskuntatekninen huolto', 'Liitettävä kaukolämpöverkkoon'),
  ('1205', 'Hulevesien imeyttämisen periaate tai vaatimus', 'Hulevesien imeyttämisvaatimus', 'Yhdyskuntatekninen huolto', 'Hulevesien imeyttämisen periaate tai vaatimus'),
  ('1206', 'Muu yhdyskuntatekniseen huoltoon liittyvä määräys', NULL, 'Yhdyskuntatekninen huolto', 'Muu yhdyskuntatekniseen huoltoon liittyvä määräys'),
  ('13', 'Ympäristön ja terveyden suojelu', NULL, 'Ympäristön ja terveyden suojelu', NULL),
  ('1301', 'Pilaantunut maa-alue', 'Alue, jolla on maaperän haitta-aineita', 'Ympäristön ja terveyden suojelu', 'Pilaantunut maa-alue'),
  ('1302', 'Meluaita', NULL, 'Ympäristön ja terveyden suojelu', 'Meluaita'),
  ('1303', 'Meluvalli', NULL, 'Ympäristön ja terveyden suojelu', 'Meluvalli'),
  ('1304', 'Melualue', NULL, 'Ympäristön ja terveyden suojelu', 'Melualue'),
  ('1305', 'Radonhaitta huomioitava', 'Rakentamisessa on huomioitava mahdollinen radonhaitta.', 'Ympäristön ja terveyden suojelu', 'Radonhaitta huomioitava'),
  ('1306', 'Muu ympäristönsuojeluun liittyvä määräys', NULL, 'Ympäristön ja terveyden suojelu', 'Muu ympäristönsuojeluun liittyvä määräys'),
  ('14', 'Nimistö', NULL, 'Nimistö', NULL),
  ('1401', 'Kadun tai tien nimi', NULL, 'Nimistö', 'Kadun tai tien nimi'),
  ('1402', 'Torin tai katuaukion nimi', NULL, 'Nimistö', 'Torin tai katuaukion nimi'),
  ('1403', 'Puiston tai muun yleisen alueen nimi', NULL, 'Nimistö', 'Puiston tai muun yleisen alueen nimi'),
  ('1404', 'Kaupungin- tai kunnanosan nimi', NULL, 'Nimistö', 'Kaupungin- tai kunnanosan nimi'),
  ('1405', 'Korttelinumero', NULL, 'Nimistö', 'Korttelinumero'),
  ('1406', 'Muu nimistö', NULL, 'Nimistö', 'Muu nimistö');



DO $$
DECLARE
    _schema text;
BEGIN
  FOR _schema IN
    SELECT DISTINCT quote_ident(schemaname)
    FROM pg_tables
    WHERE schemaname LIKE '%gk%' OR schemaname LIKE '%kkj%'
  LOOP
    EXECUTE FORMAT('SET search_path to %s, public;', _schema);
    ALTER TABLE spatial_plan
      ADD COLUMN type VARCHAR(3),
      ADD COLUMN digital_origin VARCHAR(3),
      ADD COLUMN ground_relative_position VARCHAR(3),
      ADD COLUMN legal_effectiveness VARCHAR(2) DEFAULT ('01'),
      ADD COLUMN validity_time DATERANGE,
      ADD COLUMN lifecycle_status VARCHAR(3);

    UPDATE spatial_plan as s SET
      type = s2.type
    FROM(
      VALUES
        (1, '31'),
        (3, '32'),
        (2, '33'),
        (4, '34'),
        (5, '35')
    ) as s2(plan_type, type)
    WHERE s2.plan_type = s.plan_type;

    UPDATE spatial_plan as s SET
      digital_origin = s2.digital_origin
    FROM(
      VALUES
        (1, '01'),
        (2, '02'),
        (3, '03'),
        (4, '04')
    ) as s2(origin, digital_origin)
    WHERE s2.origin = s.origin;

    UPDATE spatial_plan
    SET ground_relative_position = '01'
      WHERE type IN ('26', '35');

    UPDATE spatial_plan
    SET ground_relative_position = '02'
      WHERE type NOT IN ('26', '35');

    UPDATE spatial_plan as s SET
      lifecycle_status = s2.lifecycle_status
    FROM(
      VALUES
        (1, '01'),
        (2, '02'),
        (3, '03'),
        (4, '04'),
        (5, '06'),
        (6, '11'),
        (7, '13'),
        (8, '14'),
        (9, '05'),
        (10, '09'),
        (11 '08'),
        (12, '10'),
        (13, '12'),
        (14, '15')
    ) as s2(status, lifecycle_status)
    WHERE s2.status = s.status;

    UPDATE spatial_plan
      SET legal_effectiveness = '01';

    UPDATE spatial_plan
      SET validity_time = DATERANGE(valid_from, valid_to, '[]');

    ALTER TABLE spatial_plan
      DROP COLUMN plan_type,
      DROP COLUMN planning_level,
      DROP COLUMN origin,
      DROP COLUMN status,
      ALTER COLUMN type SET NOT NULL,
      ADD CONSTRAINT spatial_plan_type_fkey FOREIGN KEY (type)
        REFERENCES code_lists.spatial_plan_kind (codevalue)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
        DEFERRABLE INITIALLY DEFERRED,
      ALTER COLUMN digital_origin SET NOT NULL,
      ADD CONSTRAINT spatial_plan_digital_origin_fkey FOREIGN KEY (digital_origin)
        REFERENCES code_lists.digital_origin_kind (codevalue)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
        DEFERRABLE INITIALLY DEFERRED,
      ALTER COLUMN ground_relative_position SET NOT NULL,
      ADD CONSTRAINT spatial_plan_ground_relative_position_fkey FOREIGN KEY (ground_relative_position)
        REFERENCES code_lists.ground_relativeness_kind (codevalue)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
        DEFERRABLE INITIALLY DEFERRED,
      ALTER COLUMN lifecycle_status SET NOT NULL,
      ADD CONSTRAINT spatial_plan_lifecycle_status_fkey FOREIGN KEY (lifecycle_status)
        REFERENCES code_lists.spatial_plan_lifecycle_status (codevalue)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
        DEFERRABLE INITIALLY DEFERRED,
      ALTER COLUMN legal_effectiveness SET NOT NULL,
      ADD CONSTRAINT spatial_plan_legal_effectiveness_fkey FOREIGN KEY (legal_effectiveness)
        REFERENCES code_lists.spatial_plan_legal_effectiveness (codevalue)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
        DEFERRABLE INITIALLY DEFERRED;

    ALTER TABLE zoning_element
      ADD COLUMN bindingness_of_location VARCHAR(3) default ('01'),
      ADD COLUMN ground_relative_position VARCHAR(3),
      ADD COLUMN land_use_kind VARCHAR(6) CHECK (land_use_kind LIKE '01%');

    UPDATE zoning_element SET
      ground_relative_position = '02';

    UPDATE zoning_element SET
      land_use_kind = SELECT codevalue FROM code_lists.finnish_land_use_kind WHERE code = zoning_element.finnish_land_use_kind;

    ALTER TABLE zoning_element
      ALTER COLUMN bindingness_of_location SET NOT NULL,
      ADD CONSTRAINT zoning_element_bindingness_of_location_fkey FOREIGN KEY (bindingness_of_location)
        REFERENCES code_lists.bindingness_of_location_kind (codevalue)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
        DEFERRABLE INITIALLY DEFERRED,
      ALTER COLUMN ground_relative_position SET NOT NULL,
      ADD CONSTRAINT zoning_element_ground_relative_position_fkey FOREIGN KEY (ground_relative_position)
        REFERENCES code_lists.ground_relativeness_kind (codevalue)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
        DEFERRABLE INITIALLY DEFERRED,
      DROP COLUMN finnish_land_use_kind,
      ALTER COLUMN land_use_kind SET NOT NULL,
      ADD CONSTRAINT zoning_element_land_use_kind_fkey FOREIGN KEY (land_use_kind)
        REFERENCES code_lists.detail_plan_regulation_kind (codevalue)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
        DEFERRABLE INITIALLY DEFERRED;

    ALTER TABLE planned_space
      ADD COLUMN bindingness_of_location VARCHAR(3),
      ADD COLUMN ground_relative_position VARCHAR(3);


    UPDATE planned_space as s SET
      bindingness_of_location = s2.bindingness
    FROM(
      VALUES
        (true, '01'),
        (false, '02')
    ) as s2(type, bindingness)
    WHERE s2.type = s.type;

    UPDATE planned_space SET
      ground_relative_position = '02';


    ALTER TABLE planned_space
      DROP COLUMN obligatory,
      ALTER COLUMN bindingness_of_location SET NOT NULL,
      ADD CONSTRAINT planned_space_bindingness_of_location_fkey FOREIGN KEY (bindingness_of_location)
        REFERENCES code_lists.bindingness_kind (codevalue)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
        DEFERRABLE INITIALLY DEFERRED,
      ALTER COLUMN ground_relative_position SET NOT NULL,
      ADD CONSTRAINT planned_space_ground_relative_position_fkey FOREIGN KEY (ground_relative_position)
        REFERENCES code_lists.ground_relativeness_kind (codevalue)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
        DEFERRABLE INITIALLY DEFERRED;
  END LOOP;
END;
$$;

