create function SCHEMANAME.remove_expired() returns trigger
    language plpgsql
as
$$
BEGIN
    DELETE
    From SCHEMANAME.regulative_text rt
    Where rt.validity = 3;

    DELETE
    From SCHEMANAME.planned_space ps
    Where ps.planning_object_identifier In (
        Select ze_ps.planned_space_id
        From SCHEMANAME.zoning_element ze
            Right Join SCHEMANAME.zoning_element_planned_space ze_ps
                On ze.planning_object_identifier =
                    ze_ps.zoning_element_id
        Where ze.validity = 3
    );

    DELETE
    From SCHEMANAME.planning_detail_line pdl
    Where pdl.planning_object_identifier In (
        Select ze_pdl.plan_detail_line_id
        From SCHEMANAME.zoning_element ze
            Right Join SCHEMANAME.zoning_element_plan_detail_line ze_pdl
                On ze.planning_object_identifier =
                    ze_pdl.zoning_id
        Where ze.validity = 3);

    DELETE
    From SCHEMANAME.planning_detail_point pdp
    Where pdp.planning_object_identifier In (
        Select ze_pdp.plan_detail_point_id
        From SCHEMANAME.zoning_element ze
            Right Join SCHEMANAME.zoning_element_plan_detail_point ze_pdp
                On ze.planning_object_identifier =
                    ze_pdp.zoning_id
        Where ze.validity = 3);

    DELETE
    From SCHEMANAME.describing_line dl
    Where dl.identifier In (
        Select ze_dl.describing_line_id
        From SCHEMANAME.zoning_element ze
            Right Join SCHEMANAME.zoning_element_describing_line ze_dl
                On ze.planning_object_identifier =
                    ze_dl.zoning_id
        Where ze.validity = 3);

    DELETE
    From SCHEMANAME.describing_text dt
    Where dt.identifier In
        (Select ze_dt.describing_text_id
        From SCHEMANAME.zoning_element ze
            Right Join SCHEMANAME.zoning_element_describing_text ze_dt
                On ze.planning_object_identifier =
                    ze_dt.zoning_id
        Where ze.validity = 3);


    IF EXISTS(
        Select ST_Union(ST_Buffer(ze.geom, 0.1))
        From SCHEMANAME.zoning_element ze
            Inner Join SCHEMANAME.zoning_element_planned_space ze_ps
                On ze.planning_object_identifier =
                    ze_ps.zoning_element_id
            Inner Join SCHEMANAME.planned_space ps
                On ze_ps.planned_space_id =
                    ps.planning_object_identifier
        Where ze.validity = 3
            And ST_Within(ps.geom, St_Buffer(ze.geom, 1)) = False
    )
    THEN
        UPDATE SCHEMANAME.planned_space ps
        SET geom =
            St_Difference(
                ps.geom,
                (Select ST_Union(ST_Buffer(ze.geom, 0.1))
                From SCHEMANAME.zoning_element ze
                    Inner Join SCHEMANAME.zoning_element_planned_space ze_ps
                        On ze.planning_object_identifier =
                            ze_ps.zoning_element_id
                    Inner Join SCHEMANAME.planned_space ps
                        On ze_ps.planned_space_id =
                            ps.planning_object_identifier
                Where ze.validity = 3
                    And ST_Within(ps.geom,
                        St_Buffer(ze.geom, 1)) = False)
            );
    END if;

    IF EXISTS(
        Select ST_Union(ST_Buffer(ze.geom, 0.1))
        From SCHEMANAME.zoning_element ze
            Right Join SCHEMANAME.zoning_element_plan_detail_line ze_pdl
                On ze.planning_object_identifier =
                    ze_pdl.zoning_id
            Inner Join SCHEMANAME.planning_detail_line pdl
                On ze_pdl.plan_detail_line_id =
                    pdl.planning_object_identifier
            Where ze.validity = 3
                And ST_Within(pdl.geom, St_Buffer(ze.geom, 1)) = False

    )
    THEN
        UPDATE SCHEMANAME.planning_detail_line pdl
        SET geom =
            St_Difference(
                pdl.geom,
                (Select ST_Union(ST_Buffer(ze.geom, 0.1))
                From SCHEMANAME.zoning_element ze
                Right Join SCHEMANAME.zoning_element_plan_detail_line ze_pdl
                    On ze.planning_object_identifier =
                        ze_pdl.zoning_id
                Inner Join SCHEMANAME.planning_detail_line pdl2
                    On ze_pdl.plan_detail_line_id =
                        pdl2.planning_object_identifier
                Where ze.validity = 3
                    And ST_Within(pdl2.geom, St_Buffer(ze.geom, 1)) = False)
            );
    END IF;

    IF EXISTS(
        Select ST_Union(ST_Buffer(ze.geom, 0.1))
        From SCHEMANAME.zoning_element ze
            Right Join SCHEMANAME.zoning_element_describing_line ze_dl
                On ze.planning_object_identifier =
                    ze_dl.zoning_id
            Inner Join SCHEMANAME.describing_line dl
                On ze_dl.describing_line_id =
                    dl.identifier
        Where ze.validity = 3
            And ST_Within(dl.geom, St_Buffer(ze.geom, 1)) = False

    )
    THEN
        UPDATE SCHEMANAME.describing_line dl
        SET geom =
            St_Difference(
                dl.geom,
                (Select ST_Union(ST_Buffer(ze.geom, 0.1))
                From SCHEMANAME.zoning_element ze
                    Right Join SCHEMANAME.zoning_element_describing_line ze_dl
                        On ze.planning_object_identifier =
                            ze_dl.zoning_id
                    Inner Join SCHEMANAME.describing_line dl2
                        On ze_dl.describing_line_id =
                            dl2.identifier
                Where ze.validity = 3
                    And ST_Within(dl2.geom,
                        St_Buffer(ze.geom, 1)) = False)
            );
    END IF;


    DELETE
    FROM SCHEMANAME.zoning_element ze
        USING SCHEMANAME.spatial_plan sp
    WHERE (
            sp.validity = 3 AND
            ST_Within(ze.geom, St_Buffer(sp.geom, 1))
        )
        OR (
            ze.validity = 3
        );

    DELETE
    FROM SCHEMANAME.spatial_plan sp
    WHERE sp.validity = 3;

    RETURN NEW;
END;
$$;



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
