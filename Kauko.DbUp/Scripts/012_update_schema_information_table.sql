ALTER TABLE public.schema_information
  DROP CONSTRAINT check_combination;

ALTER TABLE public.schema_information
  RENAME column combination TO is_master_plan;

ALTER TABLE public.schema_information
  ADD CONSTRAINT check_is_master_plan CHECK (
    CASE
      WHEN name like '%y' AND is_master_plan IS TRUE
        THEN TRUE
      WHEN name not like '%y' AND is_master_plan IS FALSE
        THEN TRUE
      ELSE FALSE
    END
  );