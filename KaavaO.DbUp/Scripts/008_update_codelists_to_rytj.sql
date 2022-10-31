-- UPDATE WRONG CODES
UPDATE code_lists.finnish_land_use_kind
SET codevalue = '010301'
WHERE codevalue = '101301';

UPDATE code_lists.finnish_land_use_kind
SET codevalue = '010302'
WHERE codevalue = '101302';

UPDATE code_lists.finnish_land_use_kind
SET codevalue = '010303'
WHERE codevalue = '101303';

UPDATE code_lists.finnish_land_use_kind
SET codevalue = '010305'
WHERE codevalue = '101305';

UPDATE code_lists.finnish_land_use_kind
SET codevalue = '010401'
WHERE codevalue = '10401';

UPDATE code_lists.finnish_land_use_kind
SET codevalue = '010402'
WHERE codevalue = '10402';

UPDATE code_lists.finnish_land_use_kind
SET codevalue = '010403'
WHERE codevalue = '10403';

UPDATE code_lists.finnish_land_use_kind
SET codevalue = '010404'
WHERE codevalue = '10404';

ALTER TABLE code_lists.finnish_land_use_kind
ADD COLUMN uri varchar;


-- ADD URIs TO CODES
UPDATE code_lists.finnish_land_use_kind
SET uri = CONCAT('http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/', codevalue);

-- NEW CODES FOR REGULATIVE TYPES
ALTER TABLE code_lists.finnish_regulative_text_type
ADD COLUMN codevalue varchar;

ALTER TABLE code_lists.finnish_regulative_text_type
ADD COLUMN uri varchar;


INSERT INTO
  code_lists.finnish_regulative_text_type (value, description, codevalue)
VALUES
  (38, 'Leikkialue', '020202'),
  (39, 'Oleskelualue', '020203'),
  (40, 'Varattu huoltoajolle', '020317'),
  (41, 'Varattu jalankululle', '020318'),
  (42, 'Varattu polkypyöräilylle', '020320'),
  (43, 'Tontille ajo sallittu', '020312'),
  (44, 'Sähkölinja', '020102'),
  (45, 'Kaasulinja', '020103'),
  (46, 'Vesi- tai jätevesitunneli', '020104'),
  (47, 'Vesijohto tai siirtoviemäri', '020105'),
  (48, 'Kaukolämpölinja', '020106'),
  (49, 'Kaukokylmälinja', '020107'),
  (50, 'Tulvapenger', '020108'),
  (51, 'Tulvareitti', '020109'),
  (52, 'Pumppaamo', '020110'),
  (53, 'Muuntamo', '020111'),
  (54, 'Suojavyöhyke', '020112'),
  (55, 'Hulevesijärjestelmä', '020113'),
  (56, 'Hulevesien viivytysallas', '020114'),
  (57, 'Avo-oja', '020115'),
  (58, 'Muu yhdyskuntatekniseen huoltoon liittyvä käyttö', '020116'),
  (59, 'Kadun tai liikennealueen alittava kevyen liikenteen yhteys', '020303'),
  (60, 'Eritasoristeys', '020305'),
  (61, 'Hidaskatu', '020306'),
  (62, 'Katuaukio/Tori', '020307'),
  (63, 'Pelastustie', '020309'),
  (64, 'Pihakatu', '020310'),
  (65, 'Kadun tai liikennealueen ylittävä kevyen liikenteen yhteys', '020323'),
  (66, 'Varattu alueen sisäiselle jalankululle', '020315'),
  (67, 'Varattu alueen sisäiselle polkupyöräilylle', '020316'),
  (68, 'Muu liikennejärjestelmään liittyvä käyttö', '020324'),
  (69, 'Asuntovaunualue', '020401'),
  (70, 'Frisbeegolf', '020402'),
  (71, 'Golf-väylä', '020403'),
  (72, 'Kenttä', '020404'),
  (73, 'Koirapuisto', '020405'),
  (74, 'Mäenlaskupaikka', '020406'),
  (75, 'Ratsastuskenttä', '020407'),
  (76, 'Telttailu', '020408'),
  (77, 'Muu virkistyskäyttö', '020409'),
  (78, 'Laidun', '020501'),
  (79, 'Muu maatalouskäyttö', '020502'),
  (80, 'Rakennusalan käyttötarkoitus. Rakennusluokitus 2018 -koodiston avulla tai tekstiarvona.', '0206'),
  (81, 'Muu tontinkäyttöön liittyvä käyttö', '020207'),
  (82, 'Pengerrys', '020206'),

  (83, 'Rakennettava kiinni rajaan', '0404'),
  (84, 'Muu rakennusten sijoitukseen liittyvä määräys', '0406'),
  (85, 'Rakennuksen sivu, jolla tulee olla suora uloskäynti porrashuoneista', '0506'),
  (86, 'Rakennusalan sivu, jonka puoleiseen rakennuksen seinään ei saa sijoittaa ikkunoita', '0507'),
  (87, 'Parvekkeet sijoitettava rungon sisään', '0509'),
  (88, 'Hissi', '0510'),
  (89, 'Viherkatto', '0511'),
  (90, 'Kelluvat asuinrakennukset', '0512'),
  (91, 'Muu rakentamistapaan liittyvä määräys', '0513'),
  (92, 'Puusto tai kasvillisuus säilytettävä tai korvattava', '0702'),
  (93, 'Olemassa oleva puusto säilytettävä', '0703'),
  (94, 'Maisema säilytettävä avoimena', '0704'),
  (95, 'Suojeltava rakennelma', '090103'),
  (96, 'Kiinteä suojeltava kohde', '090104'),
  (97, 'Alue tai alueen osa, jolla sijaitsee muinaismuistolailla rauhoitettu kiinteä muinaisjäännös', '090105'),
  (98, 'Suojeltava vesistö tai vesialue', '090203'),
  (99, 'Luonnon monimuotoisuuden kannalta tärkeä alue', '090204'),
  (100, 'Ekologinen yhteys', '090205'),
  (101, 'Alue, jolla ympäristö säilytetään', '0903'),
  (102, 'Alue, jolla on erityistä ulkoilun ohjaamistarvetta', '0904'),
  (103, 'Yleismääräys', '1101'),
  (104, 'Vaatimus hulevesisuunnitelman laatimisesta', '1203'),
  (105, 'Liitettävä kaukolämpöverkkoon', '1204'),
  (106, 'Hulevesien imeyttämisen periaate tai vaatimus', '1205'),
  (107, 'Muu yhdyskuntatekniseen huoltoon liittyvä määräys', '1206'),
  (108, 'Pilaantunut maa-alue', '1301'),
  (109, 'Meluaita', '1302'),
  (110, 'Meluvalli', '1303'),
  (111, 'Melualue', '1304'),
  (112, 'Radonhaitta huomioitava', '1305'),
  (113, 'Muu ympäristönsuojeluun liittyvä määräys', '1306');


UPDATE code_lists.finnish_regulative_text_type
SET codevalue = '0207', description = 'Muu alueen osan käyttötarkoitus'
WHERE value = 1;
UPDATE code_lists.finnish_regulative_text_type
SET codevalue = '020304', description = 'Auton säilytyspaikka'
WHERE value = 2;
UPDATE code_lists.finnish_regulative_text_type
SET codevalue = '020311', description = 'Pysäköintialue'
WHERE value = 3;
UPDATE code_lists.finnish_regulative_text_type
SET codevalue = '020201'
WHERE value = 4;
UPDATE code_lists.finnish_regulative_text_type
SET codevalue = '020301'
WHERE value = 6;
UPDATE code_lists.finnish_regulative_text_type
SET codevalue = '020308'
WHERE value = 10;
UPDATE code_lists.finnish_regulative_text_type
SET codevalue = '020319', description = 'Varattu joukkoliikenteelle'
WHERE value = 23;
UPDATE code_lists.finnish_regulative_text_type
SET codevalue = '020302'
WHERE value = 24;
UPDATE code_lists.finnish_regulative_text_type
SET codevalue = '020314', description = 'Varattu alueen sisäiselle huoltoajolle'
WHERE value = 25;
UPDATE code_lists.finnish_regulative_text_type
SET codevalue = '020322', description = 'Yleisen tien suoja-alue'
WHERE value = 26;
UPDATE code_lists.finnish_regulative_text_type
SET codevalue = '020321', description = 'Yleisen tien näkemäalue'
WHERE value = 27;
UPDATE code_lists.finnish_regulative_text_type
SET codevalue = '020101', description = 'Maan alaista tai maan päällistä johtoa, putkea tai linjaa varten varattu alue.'
WHERE value = 37;
UPDATE code_lists.finnish_regulative_text_type
SET codevalue = '0504'
WHERE value = 5;
UPDATE code_lists.finnish_regulative_text_type
SET codevalue = '0502'
WHERE value = 16;
UPDATE code_lists.finnish_regulative_text_type
SET codevalue = '0505'
WHERE value = 17;
UPDATE code_lists.finnish_regulative_text_type
SET codevalue = '090101'
WHERE value = 32;
UPDATE code_lists.finnish_regulative_text_type
SET codevalue = '090102'
WHERE value = 34;


-- Remove deprecated codes
DO $$
DECLARE
    _schema text;
BEGIN
  FOR _schema IN
    SELECT DISTINCT quote_ident(schemaname)
    FROM pg_tables
    WHERE schemaname LIKE '%gk%' OR schemaname LIKE '%kkj%'
  LOOP --LOOPING TROUGH EVERY KAAVAO SCHEMA
    EXECUTE FORMAT('SET search_path to %s, public;', _schema);
    -- UPDATE regulative_text TABLES TO NEW CODES
    UPDATE regulative_text
    SET
      type = 1,
      description_fi = concat_ws(' ', 'Maanalainen tila.', description_fi)
    WHERE type = 7;
    UPDATE regulative_text
    SET
      type = 1,
      description_fi = concat_ws(' ', 'Maanalainen väestönsuojaksi tarkoitettu tila.', description_fi)
      WHERE type = 8;
    UPDATE regulative_text
    SET
      type = 1,
      description_fi = concat_ws(' ', 'Maanalainen yleinen pysäköintilaitos.', description_fi)
    WHERE type = 9;
    UPDATE regulative_text
    SET
      type = 80,
      description_fi = concat_ws(' ', 'Rakennusala, jolle saa sijoittaa lasten päiväkodin.', description_fi)
    WHERE type = 11;
    UPDATE regulative_text
    SET
      type = 80,
      description_fi = concat_ws(' ', 'Rakennusala, jolle saa sijoittaa myymälän.', description_fi)
    WHERE type = 12;
    UPDATE regulative_text
    SET
      type = 80,
      description_fi = concat_ws(' ', 'Rakennusala, jolle saa sijoittaa maatilan talouskeskuksen.', description_fi)
    WHERE type = 13;
    UPDATE regulative_text
    SET
      type = 80,
      description_fi = concat_ws(' ', 'Rakennusala, jolle saa sijoittaa talousrakennuksen.', description_fi)
    WHERE type = 14;
    UPDATE regulative_text
    SET
      type = 1,
      description_fi = concat_ws(' ', 'Alue, jolle saa sijoittaa polttoaineen jakeluaseman.', description_fi)
    WHERE type = 15;
    UPDATE regulative_text
    SET
      type = 68,
      description_fi = concat_ws(' ', 'Yleiseen tiehen kuuluva jalankulku- ja polkupyörätie.', description_fi)
    WHERE type = 22;
    UPDATE regulative_text
    SET
      type = 37,
      description_fi = concat_ws(' ', 'Maanalaista johtoa varten varattu alueen osa.', description_fi)
    WHERE type = 28;
    UPDATE regulative_text
    SET
      type = 1,
      description_fi = concat_ws(' ', 'Alue on varattu kunnan tarpeisiin.', description_fi)
    WHERE type = 29;
    UPDATE regulative_text
    SET
      type = 1,
      description_fi = concat_ws(' ', 'Alue on varattu valtion tarpeisiin.', description_fi)
    WHERE type = 30;
    UPDATE regulative_text
    SET
      type = 1,
      description_fi = concat_ws(' ', 'Yhteiskäyttöalue.', description_fi)
    WHERE type = 31;
    UPDATE regulative_text
    SET
      type = 1,
      description_fi = concat_ws(' ', 'Alueen osa, jolla sijaitsee luonnonsuojelulain mukainen luonnonsuojelualue tai -kohde.', description_fi)
    WHERE type = 33;
    UPDATE regulative_text
    SET
      type = 34,
      description_fi = concat_ws(' ', 'Rakennussuojelulain nojalla suojeltu rakennus.', description_fi)
    WHERE type = 35;
    UPDATE regulative_text
    SET
      type = 37,
      description_fi = concat_ws(' ', 'Maan päällistä johtoa varten varattu alueen osa.', description_fi)
    WHERE type = 36;

    DECLARE
      _regulative_text RECORD;
      _uuid uuid;
      _new_regulative_ids uuid[];
      _new_uuid uuid;
    BEGIN
      FOR _regulative_text IN
        SELECT *
        FROM regulative_text
        WHERE type = 18
      LOOP
        EXECUTE FORMAT('INSERT INTO regulative_text(type, description_fi, validity) VALUES (38, %L, %L)', _regulative_text.description_fi, _regulative_text.validity);
        EXECUTE FORMAT('INSERT INTO regulative_text(type, description_fi, validity) VALUES (39, %L, %L)', _regulative_text.description_fi, _regulative_text.validity);
        SELECT array_agg(regulative_id) INTO _new_regulative_ids
        FROM regulative_text
        WHERE type in(38, 39);
        FOR _uuid IN
          SELECT spatial_plan_id
          FROM spatial_plan_regulation
          WHERE regulative_id = _regulative_text.regulative_id
        LOOP
          FOREACH _new_uuid IN ARRAY _new_regulative_ids
          LOOP
            EXECUTE FORMAT('INSERT INTO spatial_plan_regulation(spatial_plan_id, regulative_id) VALUES (%L, %L)', _uuid, _new_uuid);
          END LOOP;
        END LOOP;
        EXECUTE FORMAT('DELETE FROM spatial_plan_regulation WHERE regulative_id = %L', _regulative_text.regulative_id);
        FOR _uuid IN
          SELECT zoning_element_id
          FROM zoning_element_regulation
          WHERE regulative_id = _regulative_text.regulative_id
        LOOP
          FOREACH _new_uuid IN ARRAY _new_regulative_ids
          LOOP
            EXECUTE FORMAT('INSERT INTO zoning_element_regulation(zoning_element_id, regulative_id) VALUES (%L, %L)', _uuid, _new_uuid);
          END LOOP;
        END LOOP;
        EXECUTE FORMAT('DELETE FROM zoning_element_regulation WHERE regulative_id = %L', _regulative_text.regulative_id);
        FOR _uuid IN
          SELECT planned_space_id
          FROM planned_space_regulation
          WHERE regulative_id = _regulative_text.regulative_id
        LOOP
          FOREACH _new_uuid IN ARRAY _new_regulative_ids
          LOOP
            EXECUTE FORMAT('INSERT INTO planned_space_regulation(planned_space_id, regulative_id) VALUES (%L, %L)', _uuid, _new_uuid);
          END LOOP;
        END LOOP;
        EXECUTE FORMAT('DELETE FROM planned_space_regulation WHERE regulative_id = %L', _regulative_text.regulative_id);
      END LOOP;
      EXECUTE FORMAT('DELETE FROM regulative_text WHERE type = %L', 18);

      FOR _regulative_text IN
        SELECT *
        FROM regulative_text
        WHERE type = 19
      LOOP
        EXECUTE FORMAT('INSERT INTO regulative_text(type, description_fi, validity) VALUES (41, %L, %L)', _regulative_text.description_fi, _regulative_text.validity);
        EXECUTE FORMAT('INSERT INTO regulative_text(type, description_fi, validity) VALUES (42, %L, %L)', _regulative_text.description_fi, _regulative_text.validity);
        SELECT array_agg(regulative_id) INTO _new_regulative_ids
        FROM regulative_text
        WHERE type = 41 OR type = 42;
        FOR _uuid IN
          SELECT spatial_plan_id
          FROM spatial_plan_regulation
          WHERE regulative_id = _regulative_text.regulative_id
        LOOP
          FOREACH _new_uuid IN ARRAY _new_regulative_ids
          LOOP
            EXECUTE FORMAT('INSERT INTO spatial_plan_regulation(spatial_plan_id, regulative_id) VALUES (%L, %L)', _uuid, _new_uuid);
          END LOOP;
        END LOOP;
        EXECUTE FORMAT('DELETE FROM spatial_plan_regulation WHERE regulative_id = %L', _regulative_text.regulative_id);
        FOR _uuid IN
          SELECT zoning_element_id
          FROM zoning_element_regulation
          WHERE regulative_id = _regulative_text.regulative_id
        LOOP
          FOREACH _new_uuid IN ARRAY _new_regulative_ids
          LOOP
            EXECUTE FORMAT('INSERT INTO zoning_element_regulation(zoning_element_id, regulative_id) VALUES (%L, %L)', _uuid, _new_uuid);
          END LOOP;
        END LOOP;
        EXECUTE FORMAT('DELETE FROM zoning_element_regulation WHERE regulative_id = %L', _regulative_text.regulative_id);
        FOR _uuid IN
          SELECT planned_space_id
          FROM planned_space_regulation
          WHERE regulative_id = _regulative_text.regulative_id
        LOOP
          FOREACH _new_uuid IN ARRAY _new_regulative_ids
          LOOP
            EXECUTE FORMAT('INSERT INTO planned_space_regulation(planned_space_id, regulative_id) VALUES (%L, %L)', _uuid, _new_uuid);
          END LOOP;
        END LOOP;
        EXECUTE FORMAT('DELETE FROM planned_space_regulation WHERE regulative_id = %L', _regulative_text.regulative_id);
      END LOOP;
      EXECUTE FORMAT('DELETE FROM regulative_text WHERE type = %L', 19);

      FOR _regulative_text IN
        SELECT *
        FROM regulative_text
        WHERE type = 20
      LOOP
        EXECUTE FORMAT('INSERT INTO regulative_text(type, description_fi, validity) VALUES (40, %L, %L)', _regulative_text.description_fi, _regulative_text.validity);
        EXECUTE FORMAT('INSERT INTO regulative_text(type, description_fi, validity) VALUES (41, %L, %L)', _regulative_text.description_fi, _regulative_text.validity);
        EXECUTE FORMAT('INSERT INTO regulative_text(type, description_fi, validity) VALUES (42, %L, %L)', _regulative_text.description_fi, _regulative_text.validity);
        SELECT array_agg(regulative_id) INTO _new_regulative_ids
        FROM regulative_text
        WHERE type in (40, 41, 42);
        FOR _uuid IN
          SELECT spatial_plan_id
          FROM spatial_plan_regulation
          WHERE regulative_id = _regulative_text.regulative_id
        LOOP
          FOREACH _new_uuid IN ARRAY _new_regulative_ids
          LOOP
            EXECUTE FORMAT('INSERT INTO spatial_plan_regulation(spatial_plan_id, regulative_id) VALUES (%L, %L)', _uuid, _new_uuid);
          END LOOP;
        END LOOP;
        EXECUTE FORMAT('DELETE FROM spatial_plan_regulation WHERE regulative_id = %L', _regulative_text.regulative_id);
        FOR _uuid IN
          SELECT zoning_element_id
          FROM zoning_element_regulation
          WHERE regulative_id = _regulative_text.regulative_id
        LOOP
          FOREACH _new_uuid IN ARRAY _new_regulative_ids
          LOOP
            EXECUTE FORMAT('INSERT INTO zoning_element_regulation(zoning_element_id, regulative_id) VALUES (%L, %L)', _uuid, _new_uuid);
          END LOOP;
        END LOOP;
        EXECUTE FORMAT('DELETE FROM zoning_element_regulation WHERE regulative_id = %L', _regulative_text.regulative_id);
        FOR _uuid IN
          SELECT planned_space_id
          FROM planned_space_regulation
          WHERE regulative_id = _regulative_text.regulative_id
        LOOP
          FOREACH _new_uuid IN ARRAY _new_regulative_ids
          LOOP
            EXECUTE FORMAT('INSERT INTO planned_space_regulation(planned_space_id, regulative_id) VALUES (%L, %L)', _uuid, _new_uuid);
          END LOOP;
        END LOOP;
        EXECUTE FORMAT('DELETE FROM planned_space_regulation WHERE regulative_id = %L', _regulative_text.regulative_id);
      END LOOP;
      EXECUTE FORMAT('DELETE FROM regulative_text WHERE type = %L', 20);

      FOR _regulative_text IN
        SELECT *
        FROM regulative_text
        WHERE type = 21
      LOOP
        EXECUTE FORMAT('INSERT INTO regulative_text(type, description_fi, validity) VALUES (41, %L, %L)', _regulative_text.description_fi, _regulative_text.validity);
        EXECUTE FORMAT('INSERT INTO regulative_text(type, description_fi, validity) VALUES (42, %L, %L)', _regulative_text.description_fi, _regulative_text.validity);
        EXECUTE FORMAT('INSERT INTO regulative_text(type, description_fi, validity) VALUES (43, %L, %L)', _regulative_text.description_fi, _regulative_text.validity);
        SELECT array_agg(regulative_id) INTO _new_regulative_ids
        FROM regulative_text
        WHERE type in (41, 42, 43);
        FOR _uuid IN
          SELECT spatial_plan_id
          FROM spatial_plan_regulation
          WHERE regulative_id = _regulative_text.regulative_id
        LOOP
          FOREACH _new_uuid IN ARRAY _new_regulative_ids
          LOOP
            EXECUTE FORMAT('INSERT INTO spatial_plan_regulation(spatial_plan_id, regulative_id) VALUES (%L, %L)', _uuid, _new_uuid);
          END LOOP;
        END LOOP;
        EXECUTE FORMAT('DELETE FROM spatial_plan_regulation WHERE regulative_id = %L', _regulative_text.regulative_id);
        FOR _uuid IN
          SELECT zoning_element_id
          FROM zoning_element_regulation
          WHERE regulative_id = _regulative_text.regulative_id
        LOOP
          FOREACH _new_uuid IN ARRAY _new_regulative_ids
          LOOP
            EXECUTE FORMAT('INSERT INTO zoning_element_regulation(zoning_element_id, regulative_id) VALUES (%L, %L)', _uuid, _new_uuid);
          END LOOP;
        END LOOP;
        EXECUTE FORMAT('DELETE FROM zoning_element_regulation WHERE regulative_id = %L', _regulative_text.regulative_id);
        FOR _uuid IN
          SELECT planned_space_id
          FROM planned_space_regulation
          WHERE regulative_id = _regulative_text.regulative_id
        LOOP
          FOREACH _new_uuid IN ARRAY _new_regulative_ids
          LOOP
            EXECUTE FORMAT('INSERT INTO planned_space_regulation(planned_space_id, regulative_id) VALUES (%L, %L)', _uuid, _new_uuid);
          END LOOP;
        END LOOP;
        EXECUTE FORMAT('DELETE FROM planned_space_regulation WHERE regulative_id = %L', _regulative_text.regulative_id);
      END LOOP;
      EXECUTE FORMAT('DELETE FROM regulative_text WHERE type = %L', 21);
    END;
  END LOOP;
END$$ LANGUAGE plpgsql;

DELETE FROM code_lists.finnish_regulative_text_type
WHERE value in (7, 8, 9, 11, 12, 13, 14, 15, 18, 19, 20, 21, 22, 28, 29, 30, 31, 33, 35, 36);

UPDATE code_lists.finnish_regulative_text_type
SET uri = CONCAT('http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/', codevalue);

-- NEW CODES FOR NUMERIC TYPES
ALTER TABLE code_lists.finnish_numeric_value
ADD COLUMN codevalue varchar;

ALTER TABLE code_lists.finnish_numeric_value
ADD COLUMN uri varchar;

INSERT INTO code_lists.finnish_numeric_value(value, codevalue, description)
VALUES
  (22, '03', 'Rakentamisen määrä'),
  (23, '0301', 'Sallittu kerrosala'),
  (24, '0302', 'Sallittu rakennustilavuus'),
  (25, '0305', 'Maanalainen kerrosluku'),
  (26, '0308', 'Rakennuspaikkojen määrä'),
  (27, '0402', 'Etäisyys naapuritontin rajasta'),
  (28, '0403', 'Rakennusala'),
  (29, '06', 'Korkeusasema'),
  (30, '0606', 'Maanalaisen kohteen korkeusasema'),
  (31, '0607', 'Muu korkeusasemaan liittyvä määräys'),
  (32, '0701', 'Vihertehokkuus'),
  (33, '0803', 'Autopaikkojen määrä'),
  (34, '0804', 'Polkupyöräpysäköinnin määrä'),
  (35, '1102', 'Ajanmukaisuuden arvioinnin aikaraja'),
  (36, '1201', 'Alin painovoimainen viemäröintitaso'),
  (37, '1202', 'Aurinkokennojen alin sijoittumistaso'),
  (38, '0805', 'Muu liikenteeseen liittyvä määräys');

UPDATE code_lists.finnish_numeric_value
SET codevalue = '0301'
WHERE value = 1;
UPDATE code_lists.finnish_numeric_value
SET codevalue = '0303'
WHERE value = 3;
UPDATE code_lists.finnish_numeric_value
SET codevalue = '0304'
WHERE value = 4;
UPDATE code_lists.finnish_numeric_value
SET codevalue = '0501'
WHERE value = 5;
UPDATE code_lists.finnish_numeric_value
SET codevalue = '0306'
WHERE value = 8;
UPDATE code_lists.finnish_numeric_value
SET codevalue = '0307'
WHERE value = 9;
UPDATE code_lists.finnish_numeric_value
SET codevalue = '0601'
WHERE value = 12;
UPDATE code_lists.finnish_numeric_value
SET codevalue = '0602'
WHERE value = 13;
UPDATE code_lists.finnish_numeric_value
SET codevalue = '0603'
WHERE value = 14;
UPDATE code_lists.finnish_numeric_value
SET codevalue = '0604'
WHERE value = 15;
UPDATE code_lists.finnish_numeric_value
SET codevalue = '0605'
WHERE value = 16;
UPDATE code_lists.finnish_numeric_value
SET codevalue = '0309'
WHERE value = 20;
UPDATE code_lists.finnish_numeric_value
SET codevalue = '0401'
WHERE value = 21;
