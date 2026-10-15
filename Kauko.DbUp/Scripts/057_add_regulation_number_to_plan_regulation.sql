-- Optional regulation number of a plan regulation, stored as given in the source data.
ALTER TABLE $SCHEMANAME$.plan_regulation
    ADD COLUMN IF NOT EXISTS regulation_number text;
