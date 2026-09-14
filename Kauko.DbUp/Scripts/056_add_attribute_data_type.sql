-- New codelist: attribute_data_type
---------------------------------------
-- Enumerates the fifteen value formats a plan_regulation or
-- supplementary_information row can carry. Recorded on the owner row rather
-- than on the value tables, so a single column always identifies the format
-- regardless of which value table is populated.

CREATE TABLE IF NOT EXISTS code_lists.attribute_data_type (
    codevalue text PRIMARY KEY
);

INSERT INTO code_lists.attribute_data_type (codevalue) VALUES
    ('LocalizedText'),
    ('Text'),
    ('Numeric'),
    ('NumericRange'),
    ('PositiveNumeric'),
    ('PositiveNumericRange'),
    ('Decimal'),
    ('DecimalRange'),
    ('PositiveDecimal'),
    ('PositiveDecimalRange'),
    ('Code'),
    ('Identifier'),
    ('SpotElevation'),
    ('TimePeriod'),
    ('TimePeriodDateOnly')
ON CONFLICT DO NOTHING;


-- Add data_type to plan_regulation
-------------------------------------
-- Nullable for now: existing rows have no recorded format. See the
-- follow-up migration that tightens ensure_one_fk once these are backfilled.

ALTER TABLE $SCHEMANAME$.plan_regulation
    ADD COLUMN IF NOT EXISTS data_type text NULL;

ALTER TABLE $SCHEMANAME$.plan_regulation
    ADD CONSTRAINT plan_regulation_fk_data_type FOREIGN KEY (data_type)
    REFERENCES code_lists.attribute_data_type (codevalue) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE NO ACTION
        DEFERRABLE INITIALLY DEFERRED;


-- Add data_type to supplementary_information
------------------------------------------------

ALTER TABLE $SCHEMANAME$.supplementary_information
    ADD COLUMN IF NOT EXISTS data_type text NULL;

ALTER TABLE $SCHEMANAME$.supplementary_information
    ADD CONSTRAINT supplementary_information_fk_data_type FOREIGN KEY (data_type)
    REFERENCES code_lists.attribute_data_type (codevalue) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE NO ACTION
        DEFERRABLE INITIALLY DEFERRED;
