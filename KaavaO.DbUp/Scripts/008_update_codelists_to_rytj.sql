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

INSERT INTO code_lists.finnish_regulative_text_type (value, description, codevalue)
VALUES (38, 'Leikkialue', '020202');
INSERT INTO code_lists.finnish_regulative_text_type (value, description, codevalue)
VALUES (39, 'Oleskelualue', '020203');
INSERT INTO code_lists.finnish_regulative_text_type (value, description, codevalue)
VALUES (40, 'Varattu huoltoajolle', '020317');
INSERT INTO code_lists.finnish_regulative_text_type (value, description, codevalue)
VALUES (41, 'Varattu jalankululle', '020318');
INSERT INTO code_lists.finnish_regulative_text_type (value, description, codevalue)
VALUES (42, 'Varattu polkypyöräilylle', '020320');
INSERT INTO code_lists.finnish_regulative_text_type (value, description, codevalue)
VALUES (43, 'Tontille ajo sallittu', '020312');
INSERT INTO code_lists.finnish_regulative_text_type (value, description, codevalue)
VALUES (44, 'Sähkölinja', '020102');
INSERT INTO code_lists.finnish_regulative_text_type (value, description, codevalue)
VALUES (45, 'Kaasulinja', '020103');
INSERT INTO code_lists.finnish_regulative_text_type (value, description, codevalue)
VALUES (46, 'Vesi- tai jätevesitunneli', '020104');
INSERT INTO code_lists.finnish_regulative_text_type (value, description, codevalue)
VALUES (47, 'Vesijohto tai siirtoviemäri', '020105');
INSERT INTO code_lists.finnish_regulative_text_type (value, description, codevalue)
VALUES (48, 'Kaukolämpölinja', '020106');
INSERT INTO code_lists.finnish_regulative_text_type (value, description, codevalue)
VALUES (49, 'Kaukokylmälinja', '020107');
INSERT INTO code_lists.finnish_regulative_text_type (value, description, codevalue)
VALUES (50, 'Tulvapenger', '020108');
INSERT INTO code_lists.finnish_regulative_text_type (value, description, codevalue)
VALUES (51, 'Tulvareitti', '020109');
INSERT INTO code_lists.finnish_regulative_text_type (value, description, codevalue)
VALUES (52, 'Pumppaamo', '020110');
INSERT INTO code_lists.finnish_regulative_text_type (value, description, codevalue)
VALUES (53, 'Muuntamo', '020111');
INSERT INTO code_lists.finnish_regulative_text_type (value, description, codevalue)
VALUES (54, 'Suojavyöhyke', '020112');
INSERT INTO code_lists.finnish_regulative_text_type (value, description, codevalue)
VALUES (55, 'Hulevesijärjestelmä', '020113');
INSERT INTO code_lists.finnish_regulative_text_type (value, description, codevalue)
VALUES (56, 'Hulevesien viivytysallas', '020114');
INSERT INTO code_lists.finnish_regulative_text_type (value, description, codevalue)
VALUES (57, 'Avo-oja', '020115');
INSERT INTO code_lists.finnish_regulative_text_type (value, description, codevalue)
VALUES (58, 'Muu yhdyskuntatekniseen huoltoon liittyvä käyttö', '020116');
INSERT INTO code_lists.finnish_regulative_text_type (value, description, codevalue)
VALUES (59, 'Kadun tai liikennealueen alittava kevyen liikenteen yhteys', '020303');
INSERT INTO code_lists.finnish_regulative_text_type (value, description, codevalue)
VALUES (60, 'Eritasoristeys', '020305');
INSERT INTO code_lists.finnish_regulative_text_type (value, description, codevalue)
VALUES (61, 'Hidaskatu', '020306');
INSERT INTO code_lists.finnish_regulative_text_type (value, description, codevalue)
VALUES (62, 'Katuaukio/Tori', '020307');
INSERT INTO code_lists.finnish_regulative_text_type (value, description, codevalue)
VALUES (63, 'Pelastustie', '020309');
INSERT INTO code_lists.finnish_regulative_text_type (value, description, codevalue)
VALUES (64, 'Pihakatu', '020310');
INSERT INTO code_lists.finnish_regulative_text_type (value, description, codevalue)
VALUES (65, 'Kadun tai liikennealueen ylittävä kevyen liikenteen yhteys', '020323');
INSERT INTO code_lists.finnish_regulative_text_type (value, description, codevalue)
VALUES (66, 'Varattu alueen sisäiselle jalankululle', '020315');
INSERT INTO code_lists.finnish_regulative_text_type (value, description, codevalue)
VALUES (67, 'Varattu alueen sisäiselle polkupyöräilylle', '020316');
INSERT INTO code_lists.finnish_regulative_text_type (value, description, codevalue)
VALUES (68, 'Muu liikennejärjestelmään liittyvä käyttö', '020324');
INSERT INTO code_lists.finnish_regulative_text_type (value, description, codevalue)
VALUES (69, 'Asuntovaunualue', '020401');
INSERT INTO code_lists.finnish_regulative_text_type (value, description, codevalue)
VALUES (70, 'Frisbeegolf', '020402');
INSERT INTO code_lists.finnish_regulative_text_type (value, description, codevalue)
VALUES (71, 'Golf-väylä', '020403');
INSERT INTO code_lists.finnish_regulative_text_type (value, description, codevalue)
VALUES (72, 'Kenttä', '020404');
INSERT INTO code_lists.finnish_regulative_text_type (value, description, codevalue)
VALUES (73, 'Koirapuisto', '020405');
INSERT INTO code_lists.finnish_regulative_text_type (value, description, codevalue)
VALUES (74, 'Mäenlaskupaikka', '020406');
INSERT INTO code_lists.finnish_regulative_text_type (value, description, codevalue)
VALUES (75, 'Ratsastuskenttä', '020407');
INSERT INTO code_lists.finnish_regulative_text_type (value, description, codevalue)
VALUES (76, 'Telttailu', '020408');
INSERT INTO code_lists.finnish_regulative_text_type (value, description, codevalue)
VALUES (77, 'Muu virkistyskäyttö', '020409');
INSERT INTO code_lists.finnish_regulative_text_type (value, description, codevalue)
VALUES (78, 'Laidun', '020501');
INSERT INTO code_lists.finnish_regulative_text_type (value, description, codevalue)
VALUES (79, 'Muu maatalouskäyttö', '020502');
INSERT INTO code_lists.finnish_regulative_text_type (value, description, codevalue)
VALUES (80, 'Rakennusalan käyttötarkoitus. Rakennusluokitus 2018 -koodiston avulla tai tekstiarvona.', '0206');
INSERT INTO code_lists.finnish_regulative_text_type (value, description, codevalue)
VALUES (81, 'Muu tontinkäyttöön liittyvä käyttö', '020207');
INSERT INTO code_lists.finnish_regulative_text_type (value, description, codevalue)
VALUES (82, 'Pengerrys', '020206');

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


-- Remove deprecated codes
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
    UPDATE regulative_text
    SET type = 1,
      description_fi = concat_ws(' ', 'Rakennukseen jätettävä kulkuaukko.', description_fi)
    WHERE type = 5;
    UPDATE regulative_text
    SET type = 1,
      description_fi = concat_ws(' ', 'Maanalainen tila.', description_fi)
    WHERE type = 7;
    UPDATE regulative_text
    SET type = 1,
      description_fi = concat_ws(' ', 'Maanalainen väestönsuojaksi tarkoitettu tila.', description_fi)
    WHERE type = 8;
    UPDATE regulative_text
    SET type = 1,
      description_fi = concat_ws(' ', 'Maanalainen yleinen pysäköintilaitos.', description_fi)
    WHERE type = 8;
    UPDATE regulative_text
    SET type = 80,
      description_fi = concat_ws(' ', 'Rakennusala, jolle saa sijoittaa lasten päiväkodin.', description_fi)
    WHERE type = 8;
    UPDATE regulative_text
    SET type = 80,
      description_fi = concat_ws(' ', 'Rakennusala, jolle saa sijoittaa myymälän.', description_fi)
    WHERE type = 8;
    UPDATE regulative_text
    SET type = 80,
      description_fi = concat_ws(' ', 'Rakennusala, jolle saa sijoittaa maatilan talouskeskuksen.', description_fi)
    WHERE type = 8;
    UPDATE regulative_text
    SET type = 80,
      description_fi = concat_ws(' ', 'Rakennusala, jolle saa sijoittaa talousrakennuksen.', description_fi)
    WHERE type = 8;
    UPDATE regulative_text
    SET type = 1,
      description_fi = concat_ws(' ', 'Alue, jolle saa sijoittaa polttoaineen jakeluaseman.', description_fi)
    WHERE type = 8;
    UPDATE regulative_text
    SET type = 1,
      description_fi = concat_ws(' ', 'Uloke.', description_fi)
    WHERE type = 8;
    UPDATE regulative_text
    SET type = 1,
      description_fi = concat_ws(' ', 'Valokatteinen tila.', description_fi)
    WHERE type = 8;
    UPDATE regulative_text
    SET type = 68,
      description_fi = concat_ws(' ', 'Yleiseen tiehen kuuluva jalankulku- ja polkupyörätie.', description_fi)
    WHERE type = 8;
    UPDATE regulative_text
    SET type = 37,
      description_fi = concat_ws(' ', 'Maanalaista johtoa varten varattu alueen osa.', description_fi)
    WHERE type = 8;
    UPDATE regulative_text
    SET type = 1,
      description_fi = concat_ws(' ', 'Alue on varattu kunnan tarpeisiin.', description_fi)
    WHERE type = 8;
    UPDATE regulative_text
    SET type = 1,
      description_fi = concat_ws(' ', 'Alue on varattu valtion tarpeisiin.', description_fi)
    WHERE type = 8;
    UPDATE regulative_text
    SET type = 1,
      description_fi = concat_ws(' ', 'Yhteiskäyttöalue.', description_fi)
    WHERE type = 8;
    UPDATE regulative_text
    SET type = 1,
      description_fi = concat_ws(' ', 'Suojeltava alueen osa.', description_fi)
    WHERE type = 8;
    UPDATE regulative_text
    SET type = 1,
      description_fi = concat_ws(' ', 'Alueen osa, jolla sijaitsee luonnonsuojelulain mukainen luonnonsuojelualue tai -kohde.', description_fi)
    WHERE type = 8;
    UPDATE regulative_text
    SET type = 1,
      description_fi = concat_ws(' ', 'Suojeltava rakennus.', description_fi)
    WHERE type = 8;
    UPDATE regulative_text
    SET type = 1,
      description_fi = concat_ws(' ', 'Rakennussuojelulain nojalla suojeltu rakennus.', description_fi)
    WHERE type = 8;
    UPDATE regulative_text
    SET type = 37,
      description_fi = concat_ws(' ', 'Maan päällistä johtoa varten varattu alueen osa.', description_fi)
    WHERE type = 8;

    DECLARE
      _regulative_text regulative_text%ROWTYPE;
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
        WHERE type = 38 OR type = 39;
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
END;
$$ LANGUAGE plpgsql;

UPDATE code_lists.finnish_regulative_text_type
SET uri = CONCAT('http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/', codevalue);