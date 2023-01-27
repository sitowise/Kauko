ALTER TABLE SCHEMANAME.spatial_plan
  DROP COLUMN validity;

CREATE OR REPLACE FUNCTION "SCHEMANAME".update_validity()
    RETURNS TRIGGER
    LANGUAGE plpgsql
AS $BODY$
BEGIN
  PERFORM SCHEMANAME.refresh_validity();

  CREATE TEMPORARY TABLE temp_spatial_plan AS (
    SELECT
      sp.local_id AS local_id,
      sp.geom AS geom,
      sp.valid_from AS valid_from,
      sp.valid_to AS valid_to,
      sp.lifecycle_status AS lifecycle_status,
      sp.validity_time AS validity_time
    FROM SCHEMANAME.spatial_plan sp
    WHERE
      sp.valid_from IS NOT NULL
      AND sp.lifecycle_status NOT IN (12, 13, 14, 15)
      AND (sp.valid_to IS NULL OR sp.valid_to >= Current_Date)
    );

    WITH spatial_plan_valid_from AS (
      SELECT
        Max(temp_spatial_plan.valid_from) AS max_valid_from,
        sp.local_id AS local_id
      FROM
        SCHEMANAME.spatial_plan sp,
        temp_spatial_plan
      WHERE
        st_intersects(sp.geom, temp_spatial_plan.geom) = TRUE
        AND st_touches(sp.geom, temp_spatial_plan.geom) = FALSE
      GROUP BY sp.local_id
    )
    UPDATE SCHEMANAME.spatial_plan sp
    SET
      validity = 3,
      valid_to = spvf.max_valid_from
    FROM spatial_plan_valid_from spvf
    WHERE
      sp.local_id = spvf.local_id
      AND (
        sp.validity <> 3
        AND (
          sp.valid_to IS NULL
          OR sp.valid_to >= Current_Date)
        AND st_within(
          sp.geom,
          st_buffer(
            (SELECT
              st_union(temp_spatial_plan.geom)
            FROM temp_spatial_plan
            WHERE temp_spatial_plan.local_id <> sp.local_id
            AND temp_spatial_plan.valid_from > sp.valid_from),
            0.1
          )
        ) = TRUE
      );

    UPDATE SCHEMANAME.spatial_plan sp
    SET validity = 2
    WHERE
      sp.validity = 1
      AND (
        sp.valid_to IS NULL OR
        sp.valid_to >= Current_Date)
      AND st_overlaps(
        sp.geom,
        st_buffer(
          (
            SELECT st_union(temp_spatial_plan.geom)
            FROM temp_spatial_plan
            WHERE temp_spatial_plan.local_id <> sp.local_id
              AND temp_spatial_plan.valid_from > sp.valid_from
              AND temp_spatial_plan.validity = 1
          ), 0.1
        )
      ) = TRUE;

    DROP TABLE temp_spatial_plan;

    CREATE TEMPORARY TABLE temp_zoning_element AS
    SELECT
      ze.planning_object_identifier AS planning_object_identifier,
      ze.geom AS geom,
      ze.valid_from AS valid_from,
      ze.validity AS validity,
      ze.spatial_plan AS spatial_plan
    FROM SCHEMANAME.zoning_element ze
    WHERE ze.valid_from IS NOT NULL
      AND ze.validity <> 3
      AND (ze.valid_to IS NULL OR ze.valid_to >= Current_Date);

    WITH zoning_element_valid_from AS (
      SELECT
        Max(temp_zoning_element.valid_from) AS max_valid_from,
        ze.local_id AS local_id
      FROM SCHEMANAME.zoning_element ze,
            temp_zoning_element
      WHERE st_intersects(ze.geom, temp_zoning_element.geom) = TRUE
        AND st_touches(ze.geom, temp_zoning_element.geom) = FALSE
      GROUP BY ze.local_id
    )
    UPDATE SCHEMANAME.zoning_element ze
    SET validity = 3,
        valid_to = zevf.max_valid_from
    FROM zoning_element_valid_from zevf
    WHERE ze.local_id = zevf.local_id
      AND ze.validity <> 3
      AND (ze.valid_to IS NULL OR
        ze.valid_to >= Current_Date)
      AND st_within(
        ze.geom,
        st_buffer(
          (
            SELECT st_union(temp_zoning_element.geom)
            FROM temp_zoning_element
            WHERE temp_zoning_element.local_id <> ze.local_id
              AND temp_zoning_element.valid_from > ze.valid_from
          ), 0.1
        )
      ) = TRUE;

    UPDATE SCHEMANAME.zoning_element ze
    SET validity = 2
    WHERE ze.validity = 1
      AND (ze.valid_to IS NULL OR
          ze.valid_to >= Current_Date)
      AND st_overlaps(
        ze.geom,
        st_buffer(
          (
            SELECT st_union(temp_zoning_element.geom)
            FROM temp_zoning_element
            WHERE temp_zoning_element.local_id <> ze.local_id
              AND temp_zoning_element.spatial_plan <> ze.spatial_plan
              AND temp_zoning_element.valid_from > ze.valid_from
              AND temp_zoning_element.validity = 1
          ), -0.1
        )
      ) = TRUE;

    DROP TABLE temp_zoning_element;

    WITH zoning_elements AS (
      SELECT ze.local_id, ze.geom
      FROM SCHEMANAME.zoning_element ze
      WHERE
        ze.valid_from IS NOT NULL
        AND ze.validity <> 3
        AND (ze.valid_to IS NULL OR ze.valid_to >= Current_Date)
      EXCEPT
      SELECT ze.zoning_element_local_id, ze.geom
      FROM SCHEMANAME.zoning_element_planned_space ze
      WHERE ze.planned_space_local_id = ps.local_id
    )
    UPDATE SCHEMANAME.planned_space ps
    SET validity = 3
    WHERE
      st_within(
        ps.geom,
        st_buffer(
          (SELECT st_union(ze.geom) FROM zoning_elements ze),
          0.1
        )
      ) = TRUE
      AND ps.validity <> 3;

    WITH zoning_elements AS (
      SELECT ze.local_id, ze.geom
      FROM SCHEMANAME.zoning_element ze
      WHERE
        ze.valid_from IS NOT NULL
        AND ze.validity = 1
        AND (ze.valid_to IS NULL OR ze.valid_to >= Current_Date)
      EXCEPT
      SELECT ze.zoning_element_local_id, ze.geom
      FROM SCHEMANAME.zoning_element_planned_space ze
      WHERE ze.planned_space_local_id = ps.local_id
    )
    UPDATE SCHEMANAME.planned_space ps
    SET validity = 2
    WHERE
      st_overlaps(
        ps.geom,
        st_buffer(
          (SELECT st_union(ze.geom) FROM zoning_elements ze),
          0.1
        )
      ) = TRUE
      AND ps.validity = 1;

    WITH zoning_elements AS (
      SELECT ze.local_id, ze.geom
      FROM SCHEMANAME.zoning_element ze
      WHERE
        ze.valid_from IS NOT NULL
        AND ze.validity <> 3
        AND (ze.valid_to IS NULL OR ze.valid_to >= Current_Date)
      EXCEPT
      SELECT ze.zoning_element_local_id, ze.geom
      FROM SCHEMANAME.zoning_element_plan_detail_line ze
      WHERE ze.planning_detail_line_local_id = pdl.local_id
    )
    UPDATE SCHEMANAME.planning_detail_line pdl
    SET validity = 3
    WHERE
      st_within(
        pdl.geom,
        st_buffer(
          (SELECT st_union(ze.geom) FROM zoning_elements ze),
          0.1
        )
      ) = TRUE
      AND pdl.validity <> 3;

    WITH zoning_elements AS (
      SELECT ze.local_id, ze.geom
      FROM SCHEMANAME.zoning_element ze
      WHERE
        ze.valid_from IS NOT NULL
        AND ze.validity = 1
        AND (ze.valid_to IS NULL OR ze.valid_to >= Current_Date)
      EXCEPT
      SELECT ze.zoning_element_local_id, ze.geom
      FROM SCHEMANAME.zoning_element_plan_detail_line ze
      WHERE ze.planning_detail_line_local_id = pdl.local_id
    )
    UPDATE SCHEMANAME.planning_detail_line pdl
    SET validity = 2
    WHERE
      st_crosses(
        pdl.geom,
        st_buffer(
          (SELECT st_union(ze.geom) FROM zoning_elements ze),
          0.1
        )
      ) = TRUE
      AND pdl.validity = 1;

    WITH zoning_elements AS (
      SELECT ze.local_id, ze.geom
      FROM SCHEMANAME.zoning_element ze
      WHERE
        ze.valid_from IS NOT NULL
        AND ze.validity <> 3
        AND (ze.valid_to IS NULL OR ze.valid_to >= Current_Date)
      EXCEPT
      SELECT ze.zoning_element_local_id, ze.geom
      FROM SCHEMANAME.zoning_element_describing_line ze
      WHERE ze.describing_line_id = dl.identifier
    )
    UPDATE SCHEMANAME.describing_line dl
    SET validity = 3
    WHERE
      st_within(
        dl.geom,
        st_buffer(
          (SELECT st_union(ze.geom) FROM zoning_elements ze),
          0.1
        )
      ) = TRUE
      AND dl.validity <> 3;

    WITH zoning_elements AS (
      SELECT ze.local_id, ze.geom
      FROM SCHEMANAME.zoning_element ze
      WHERE
        ze.valid_from IS NOT NULL
        AND ze.validity = 1
        AND (ze.valid_to IS NULL OR ze.valid_to >= Current_Date)
      EXCEPT
      SELECT ze.zoning_element_local_id, ze.geom
      FROM SCHEMANAME.zoning_element_describing_line ze
      WHERE ze.describing_line_id = dl.identifier
    )
    UPDATE SCHEMANAME.describing_line dl
    SET validity = 2
    WHERE
      st_crosses(
        dl.geom,
        st_buffer(
          (SELECT st_union(ze.geom) FROM zoning_elements ze),
          0.1
        )
      ) = TRUE
      AND dl.validity = 1;

    WITH zoning_elements AS (
      SELECT ze.local_id, ze.geom
      FROM SCHEMANAME.zoning_element ze
      WHERE
        ze.valid_from IS NOT NULL
        AND ze.validity <> 3
        AND (ze.valid_to IS NULL OR ze.valid_to >= Current_Date)
      EXCEPT
      SELECT ze.zoning_element_local_id, ze.geom
      FROM SCHEMANAME.zoning_element_describing_text ze
      WHERE ze.describing_text_id = dt.identifier
    )
    UPDATE SCHEMANAME.describing_text dt
    SET validity = 3
    WHERE
      st_within(
        dt.geom,
        st_buffer(
          (SELECT st_union(ze.geom) FROM zoning_elements ze),
          0.1
        )
      ) = TRUE
      AND dt.validity <> 3;

    PERFORM SCHEMANAME.refresh_validity();
    RETURN NULL;
END;
$BODY$;