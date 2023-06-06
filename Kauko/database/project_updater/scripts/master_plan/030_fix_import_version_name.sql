CREATE OR REPLACE FUNCTION SCHEMANAME.insert_version_name()
RETURNS TRIGGER AS $$
BEGIN
    IF (NEW.version_name IS NULL) THEN
        CASE NEW."language"
            WHEN 1 THEN NEW.version_name := NEW.name ->> 'fin';
            WHEN 2 THEN NEW.version_name := NEW.name ->> 'swe';
            WHEN 3 THEN NEW.version_name := NEW.name ->> 'fin';
        END CASE;

        NEW.version_name := NEW.version_name || '_import_' || to_char(now(), 'YYYY-MM-DDHH24:MI:SS');
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER insert_version_name_trigger
BEFORE INSERT ON SCHEMANAME.spatial_plan
FOR EACH ROW
WHEN (NEW.version_name IS NULL)
EXECUTE PROCEDURE SCHEMANAME.insert_version_name();

