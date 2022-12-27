CREATE OR REPLACE FUNCTION versioned_object_modified_trigger() RETURNS TRIGGER AS $$
  BEGIN
    NEW.latest_change := now();
    IF TG_OP = 'INSERT' THEN
      NEW.storage_time := now();
    ELSIF TG_OP = 'UPDATE' THEN
      NEW.storage_time = OLD.storage_time;
    END IF;
    RETURN NEW;
  END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION create_local_id_trigger() RETURNS TRIGGER AS $$
  BEGIN
    IF NEW.local_id IS NULL THEN
      NEW.local_id := NEW.identity_id || '.' || uuid_generate_v4();
    END IF;
    RETURN NEW;
  END;
$$ LANGUAGE plpgsql;