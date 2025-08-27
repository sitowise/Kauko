ALTER TABLE raasepori_gk24.plan_regulation_group 
 ALTER COLUMN group_number DROP IDENTITY IF EXISTS,
 ALTER COLUMN group_number DROP NOT NULL,
 ALTER COLUMN group_number DROP DEFAULT;
