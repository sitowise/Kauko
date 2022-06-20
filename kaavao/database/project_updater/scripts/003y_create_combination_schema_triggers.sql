create function SCHEMANAME.remove_expired() returns trigger
    language plpgsql
as
$$
BEGIN
    DELETE
    From SCHEMANAME.regulative_text
    Where SCHEMANAME.regulative_text.validity = 3;

    DELETE
    From SCHEMANAME.planned_space
    Where SCHEMANAME.planned_space.planning_object_identifier In (
        Select SCHEMANAME.zoning_element_planned_space.planned_space_id
        From SCHEMANAME.zoning_element
                 Right Join SCHEMANAME.zoning_element_planned_space
                            On SCHEMANAME.zoning_element.planning_object_identifier =
                               SCHEMANAME.zoning_element_planned_space.zoning_element_id
        Where SCHEMANAME.zoning_element.validity = 3
    );

    DELETE
    From SCHEMANAME.planning_detail_line
    Where SCHEMANAME.planning_detail_line.planning_object_identifier In (
        Select SCHEMANAME.zoning_element_plan_detail_line.plan_detail_line_id
        From SCHEMANAME.zoning_element
                 Right Join SCHEMANAME.zoning_element_plan_detail_line
                            On SCHEMANAME.zoning_element.planning_object_identifier =
                               SCHEMANAME.zoning_element_plan_detail_line.zoning_id
        Where SCHEMANAME.zoning_element.validity = 3);

    DELETE
    From SCHEMANAME.planning_detail_point
    Where SCHEMANAME.planning_detail_point.planning_object_identifier In (
        Select SCHEMANAME.zoning_element_plan_detail_point.plan_detail_point_id
        From SCHEMANAME.zoning_element
                 Right Join SCHEMANAME.zoning_element_plan_detail_point
                            On SCHEMANAME.zoning_element.planning_object_identifier =
                               SCHEMANAME.zoning_element_plan_detail_point.zoning_id
        Where SCHEMANAME.zoning_element.validity = 3);

    DELETE
    From SCHEMANAME.describing_line
    Where SCHEMANAME.describing_line.identifier In (
        Select SCHEMANAME.zoning_element_describing_line.describing_line_id
        From SCHEMANAME.zoning_element
                 Right Join
             SCHEMANAME.zoning_element_describing_line On SCHEMANAME.zoning_element.planning_object_identifier =
                                                           SCHEMANAME.zoning_element_describing_line.zoning_id
        Where SCHEMANAME.zoning_element.validity = 3);

    DELETE
    From SCHEMANAME.describing_text
    Where SCHEMANAME.describing_text.identifier In
          (Select SCHEMANAME.zoning_element_describing_text.describing_text_id
           From SCHEMANAME.zoning_element
                    Right Join
                SCHEMANAME.zoning_element_describing_text On SCHEMANAME.zoning_element.planning_object_identifier =
                                                              SCHEMANAME.zoning_element_describing_text.zoning_id
           Where SCHEMANAME.zoning_element.validity = 3);


    if
        exists(Select ST_Union(ST_Buffer(SCHEMANAME.zoning_element.geom, 0.1))
               From SCHEMANAME.zoning_element
                        Inner Join
                    SCHEMANAME.zoning_element_planned_space On SCHEMANAME.zoning_element.planning_object_identifier =
                                                                SCHEMANAME.zoning_element_planned_space.zoning_element_id
                        Inner Join
                    SCHEMANAME.planned_space On SCHEMANAME.zoning_element_planned_space.planned_space_id =
                                                 SCHEMANAME.planned_space.planning_object_identifier
               Where SCHEMANAME.zoning_element.validity = 3
                 And ST_Within(SCHEMANAME.planned_space.geom, St_Buffer(SCHEMANAME.zoning_element.geom, 1)) = False
            )
    THEN
        UPDATE SCHEMANAME.planned_space
        SET geom =
                St_Difference(
                        SCHEMANAME.planned_space.geom,
                        (Select ST_Union(ST_Buffer(SCHEMANAME.zoning_element.geom, 0.1))
                         From SCHEMANAME.zoning_element
                                  Inner Join
                              SCHEMANAME.zoning_element_planned_space
                              On SCHEMANAME.zoning_element.planning_object_identifier =
                                 SCHEMANAME.zoning_element_planned_space.zoning_element_id
                                  Inner Join
                              SCHEMANAME.planned_space On SCHEMANAME.zoning_element_planned_space.planned_space_id =
                                                           SCHEMANAME.planned_space.planning_object_identifier
                         Where SCHEMANAME.zoning_element.validity = 3
                           And ST_Within(SCHEMANAME.planned_space.geom,
                                         St_Buffer(SCHEMANAME.zoning_element.geom, 1)) = False
                        )
                    );
    END if;

    if
        exists(Select ST_Union(ST_Buffer(SCHEMANAME.zoning_element.geom, 0.1))
               From SCHEMANAME.zoning_element
                        Right Join
                    SCHEMANAME.zoning_element_plan_detail_line
                    On SCHEMANAME.zoning_element.planning_object_identifier =
                       SCHEMANAME.zoning_element_plan_detail_line.zoning_id
                        Inner Join
                    SCHEMANAME.planning_detail_line
                    On SCHEMANAME.zoning_element_plan_detail_line.plan_detail_line_id =
                       SCHEMANAME.planning_detail_line.planning_object_identifier
               Where SCHEMANAME.zoning_element.validity = 3
                 And ST_Within(planning_detail_line.geom, St_Buffer(SCHEMANAME.zoning_element.geom, 1)) = False
            )
    THEN
        UPDATE SCHEMANAME.planned_space
        SET geom =
                St_Difference(
                        SCHEMANAME.planning_detail_line.geom,
                        (Select ST_Union(ST_Buffer(SCHEMANAME.zoning_element.geom, 0.1))
                         From SCHEMANAME.zoning_element
                                  Right Join
                              SCHEMANAME.zoning_element_plan_detail_line
                              On SCHEMANAME.zoning_element.planning_object_identifier =
                                 SCHEMANAME.zoning_element_plan_detail_line.zoning_id
                                  Inner Join
                              SCHEMANAME.planning_detail_line
                              On SCHEMANAME.zoning_element_plan_detail_line.plan_detail_line_id =
                                 SCHEMANAME.planning_detail_line.planning_object_identifier
                         Where SCHEMANAME.zoning_element.validity = 3
                           And ST_Within(planning_detail_line.geom, St_Buffer(SCHEMANAME.zoning_element.geom, 1)) =
                               False
                        )
                    );
    END IF;

    IF
        exists(Select ST_Union(ST_Buffer(SCHEMANAME.zoning_element.geom, 0.1))
               From SCHEMANAME.zoning_element
                        Right Join
                    SCHEMANAME.zoning_element_describing_line
                    On SCHEMANAME.zoning_element.planning_object_identifier =
                       SCHEMANAME.zoning_element_describing_line.zoning_id
                        Inner Join
                    SCHEMANAME.describing_line On SCHEMANAME.zoning_element_describing_line.describing_line_id =
                                                   SCHEMANAME.describing_line.identifier
               Where SCHEMANAME.zoning_element.validity = 3
                 And ST_Within(SCHEMANAME.describing_line.geom, St_Buffer(SCHEMANAME.zoning_element.geom, 1)) = False
            )
    THEN
        UPDATE SCHEMANAME.describing_line
        SET geom =
                St_Difference(
                        SCHEMANAME.describing_line.geom,
                        (Select ST_Union(ST_Buffer(SCHEMANAME.zoning_element.geom, 0.1))
                         From SCHEMANAME.zoning_element
                                  Right Join
                              SCHEMANAME.zoning_element_describing_line
                              On SCHEMANAME.zoning_element.planning_object_identifier =
                                 SCHEMANAME.zoning_element_describing_line.zoning_id
                                  Inner Join
                              SCHEMANAME.describing_line
                              On SCHEMANAME.zoning_element_describing_line.describing_line_id =
                                 SCHEMANAME.describing_line.identifier
                         Where SCHEMANAME.zoning_element.validity = 3
                           And ST_Within(SCHEMANAME.describing_line.geom,
                                         St_Buffer(SCHEMANAME.zoning_element.geom, 1)) = False
                        )
                    );
    END IF;


    DELETE
    FROM SCHEMANAME.zoning_element
        USING SCHEMANAME.spatial_plan
    WHERE (
            spatial_plan.validity = 3 AND
            ST_Within(zoning_element.geom, St_Buffer(spatial_plan.geom, 1))
        )
       OR (
        zoning_element.validity = 3
        );

    DELETE
    FROM SCHEMANAME.spatial_plan
    WHERE spatial_plan.validity = 3;

    RETURN NEW;
END;
$$;


grant execute on function SCHEMANAME.remove_expired() to qgis_admin;

grant execute on function SCHEMANAME.remove_expired() to qgis_editor;

create trigger z_remove_expired
    after insert or update
        of valid_from, valid_to, validity
    on SCHEMANAME.spatial_plan
execute procedure SCHEMANAME.remove_expired();

create trigger z_remove_expired
    after insert or update
        of valid_from, valid_to, validity
    on SCHEMANAME.zoning_element
    when (pg_trigger_depth() < 1)
execute procedure SCHEMANAME.remove_expired();

create trigger z_remove_expired
    after insert or update
        of validity
    on SCHEMANAME.planned_space
    when (pg_trigger_depth() < 1)
execute procedure SCHEMANAME.remove_expired();

create trigger z_remove_expired
    after insert or update
        of validity
    on SCHEMANAME.planning_detail_line
    when (pg_trigger_depth() < 1)
execute procedure SCHEMANAME.remove_expired();

create trigger z_remove_expired
    after insert or update
        of validity
    on SCHEMANAME.planning_detail_point
    when (pg_trigger_depth() < 1)
execute procedure SCHEMANAME.remove_expired();

create trigger z_remove_expired
    after insert or update
        of validity
    on SCHEMANAME.describing_line
    when (pg_trigger_depth() < 1)
execute procedure SCHEMANAME.remove_expired();

create trigger z_remove_expired
    after insert or update
        of validity
    on SCHEMANAME.describing_text
    when (pg_trigger_depth() < 1)
execute procedure SCHEMANAME.remove_expired();
