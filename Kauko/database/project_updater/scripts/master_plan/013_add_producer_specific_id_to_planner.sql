ALTER TABLE SCHEMANAME.planner
    ADD COLUMN producer_specific_id UUID DEFAULT uuid_generate_v4() NOT NULL;