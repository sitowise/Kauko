-- Add style column

ALTER TABLE $SCHEMANAME$.zoning_element
    ADD style text,
    ADD CONSTRAINT zoning_element_style_fkey FOREIGN KEY (style)
    REFERENCES code_lists.plan_regulation_theme_style (codevalue) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE NO ACTION
        DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE code_lists.detail_plan_regulation_kind
    ADD style text,
    ADD CONSTRAINT detail_plan_regulation_kind_style_fkey FOREIGN KEY (style)
    REFERENCES code_lists.plan_regulation_theme_style (codevalue) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE RESTRICT;

-- Add styles for detail_plan_regulation_kind
UPDATE code_lists.detail_plan_regulation_kind SET style = 'asuinalueVaalea' WHERE id = 1;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'asuinalueVaalea' WHERE id = 2;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'asuinalueVaalea' WHERE id = 3;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'asuinalueVaalea' WHERE id = 4;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'asuinalueTumma' WHERE id = 5;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'asuinalueVaalea' WHERE id = 6;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'asuinalueVaalea' WHERE id = 7;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'asuinalueVaalea' WHERE id = 8;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'asuinalueVaalea' WHERE id = 9;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'palvelurakennustenAlue' WHERE id = 18;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'keskustatoimintojenAlue' WHERE id = 10;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'tyopaikkojenAlueYleiskaava' WHERE id = 12;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'palvelurakennustenAlue' WHERE id = 13;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'palvelurakennustenAlue' WHERE id = 14;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'palvelurakennustenAlue' WHERE id = 15;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'palvelurakennustenAlue' WHERE id = 16;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'palvelurakennustenAlue' WHERE id = 17;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'palvelurakennustenAlue' WHERE id = 19;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'palvelurakennustenAlue' WHERE id = 20;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'yleistenRakennustenAlue' WHERE id = 21;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'yleistenRakennustenAlue' WHERE id = 22;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'yleistenRakennustenAlue' WHERE id = 23;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'yleistenRakennustenAlue' WHERE id = 24;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'yleistenRakennustenAlue' WHERE id = 25;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'yleistenRakennustenAlue' WHERE id = 26;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'yleistenRakennustenAlue' WHERE id = 27;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'teollisuusalue' WHERE id = 28;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'teollisuusalue' WHERE id = 29;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'vapaaAjanMatkailunAlue' WHERE id = 30;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'vapaaAjanMatkailunAlue' WHERE id = 31;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'vapaaAjanMatkailunAlue' WHERE id = 32;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'vapaaAjanMatkailunAlue' WHERE id = 33;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'vapaaAjanMatkailunAlue' WHERE id = 34;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'vapaaAjanMatkailunAlue' WHERE id = 35;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'vapaaAjanMatkailunAlue' WHERE id = 36;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'virkistysalue' WHERE id = 37;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'virkistysalue' WHERE id = 38;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'virkistysalue' WHERE id = 39;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'virkistysalue' WHERE id = 40;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'virkistysalue' WHERE id = 41;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'virkistysalue' WHERE id = 42;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'virkistysalue' WHERE id = 44;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'virkistysalue' WHERE id = 45;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'maaJaMetsatalousalueM' WHERE id = 52;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'maaJaMetsatalousalueMUMY' WHERE id = 53;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'maaJaMetsatalousalueMUMY' WHERE id = 54;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'maaJaMetsatalousalueMTMPT' WHERE id = 55;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'maaJaMetsatalousalueMTMPT' WHERE id = 56;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'maaJaMetsatalousalueMM' WHERE id = 57;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'maaJaMetsatalousalueMEMP' WHERE id = 58;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'erityisalue' WHERE id = 66;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'maaJaMetsatalousalueMEMP' WHERE id = 59;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'erityisalue' WHERE id = 61;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'erityisalue' WHERE id = 62;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'erityisalue' WHERE id = 65;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'erityisalue' WHERE id = 67;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'erityisalue' WHERE id = 69;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'erityisalue' WHERE id = 70;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'erityisalue' WHERE id = 71;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'erityisalue' WHERE id = 72;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'erityisalue' WHERE id = 73;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'erityisalue' WHERE id = 74;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'erityisalue' WHERE id = 80;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'erityisalue' WHERE id = 81;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'hautausmaaAlueSuojaviheralue' WHERE id = 84;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'hautausmaaAlueSuojaviheralue' WHERE id = 85;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'liikenteenAlue' WHERE id = 86;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'liikenteenAlue' WHERE id = 87;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'liikenteenAlue' WHERE id = 88;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'pysakointiVarikkoAlue' WHERE id = 118;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'pysakointiVarikkoAlue' WHERE id = 119;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'pysakointiVarikkoAlue' WHERE id = 120;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'liikenteenAlue' WHERE id = 122;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'pysakointiVarikkoAlue' WHERE id = 131;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'liikenteenAlue' WHERE id = 141;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'pysakointiVarikkoAlue' WHERE id = 132;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'pysakointiVarikkoAlue' WHERE id = 136;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'liikenteenAlue' WHERE id = 138;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'liikenteenAlue' WHERE id = 139;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'liikenteenAlue' WHERE id = 140;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'liikenteenAlue' WHERE id = 142;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'vesialue' WHERE id = 146;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'suojelualue' WHERE id = 152;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'suojelualue' WHERE id = 153;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'suojelualue' WHERE id = 157;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'katu' WHERE id = 98;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'suojelualue' WHERE id = 149;
UPDATE code_lists.detail_plan_regulation_kind SET style = 'suojelualue' WHERE id = 150;

-- update main_class for two codes in detail_plan_regulation_kind
UPDATE code_lists.detail_plan_regulation_kind SET main_class = 'Alueen käyttötarkoitus' WHERE id IN (149,150);
