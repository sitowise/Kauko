GRANT USAGE ON SCHEMA SCHEMANAME TO qgis_viewer;
GRANT SELECT ON ALL TABLES IN SCHEMA SCHEMANAME TO qgis_viewer;
ALTER DEFAULT PRIVILEGES IN SCHEMA SCHEMANAME
    GRANT SELECT ON TABLES TO qgis_viewer;
