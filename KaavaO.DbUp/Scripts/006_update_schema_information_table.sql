ALTER TABLE public.schema_information
    RENAME version TO schema_version;

ALTER TABLE public.schema_information
    ADD COLUMN project_version character(4);

ALTER TABLE public.schema_information
    ADD COLUMN schema_updated timestamp(6);

ALTER TABLE public.schema_information
    ADD COLUMN project_updated timestamp(6);

CREATE FUNCTION public.check_update()
    RETURNS trigger
    LANGUAGE 'plpgsql'
     NOT LEAKPROOF
AS
$$
BEGIN
IF (TG_OP = 'INSERT') THEN
    IF (NEW.schema_version IS NOT NULL) THEN
        NEW.schema_updated := CURRENT_TIMESTAMP;
    END IF;
    IF (NEW.PROJECT_version IS NOT NULL) THEN
        NEW.project_updated := CURRENT_TIMESTAMP;
    END IF;
END IF;
IF (TG_OP = 'UPDATE') THEN
    IF NEW.schema_version IS DISTINCT FROM OLD.schema_version THEN
        NEW.schema_updated := current_timestamp;
    END IF;
    IF NEW.project_version IS DISTINCT FROM OLD.project_version THEN
        NEW.project_updated := current_timestamp;
    END IF;
END IF;
RETURN NEW;
END;
$$;

create trigger check_update
    BEFORE insert or update
        of schema_version, project_version
    on public.schema_information
    FOR EACH ROW
execute procedure public.check_update()
