-- Trigger: check_update

-- DROP TRIGGER IF EXISTS check_update ON public.schema_information;

CREATE OR REPLACE TRIGGER check_update
    BEFORE INSERT OR UPDATE OF schema_version, project_version
    ON public.schema_information
    FOR EACH ROW
    EXECUTE FUNCTION public.check_update();
	
