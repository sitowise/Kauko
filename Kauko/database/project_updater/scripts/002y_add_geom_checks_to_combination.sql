ALTER TABLE SCHEMANAME.spatial_plan
  ADD CONSTRAINT spatial_plan_geom_check CHECK (ST_isvalid(geom));

ALTER TABLE SCHEMANAME.planning_detail_line 
  ADD CONSTRAINT planning_detail_line_geom_check CHECK (ST_isvalid(geom));

ALTER TABLE SCHEMANAME.planning_detail_point 
  ADD CONSTRAINT planning_detail_point_geom_check CHECK (ST_isvalid(geom));

ALTER TABLE SCHEMANAME.planned_space 
  ADD CONSTRAINT planned_space_geom_check CHECK (ST_isvalid(geom));

ALTER TABLE SCHEMANAME.zoning_element
  ADD CONSTRAINT zoning_element_geom_check CHECK (ST_isvalid(geom));