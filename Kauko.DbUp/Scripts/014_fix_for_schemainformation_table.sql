ALTER TABLE public.schema_information
  ALTER COLUMN municipality SET DATA TYPE VARCHAR(3) USING
    CASE
      WHEN municipality < 100 THEN '0' || municipality
      ELSE municipality::VARCHAR
    END;