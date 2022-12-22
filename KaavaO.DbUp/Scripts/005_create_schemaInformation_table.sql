CREATE TABLE IF NOT EXISTS public.schema_information
(
  identifier integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 ),
  name character varying NOT NULL,
  srid integer NOT NULL,
  municipality integer NOT NULL,
  combination boolean NOT NULL,
  created date NOT NULL DEFAULT now(),
  version character(4),
  PRIMARY KEY (identifier),
  CONSTRAINT name_unique UNIQUE (name),
  CONSTRAINT check_combination CHECK (
    CASE
      WHEN name like '%y' AND combination IS TRUE
        THEN TRUE
      WHEN name not like '%y' AND combination IS FALSE
        THEN TRUE
      ELSE FALSE
    END
  )
);