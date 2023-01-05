CREATE OR REPLACE FUNCTION SCHEMANAME.inherit_validity()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
  WITH sp_inherited_validity AS (
    SELECT
      sp.valid_from AS valid_from,
      sp.valid_to AS valid_to,
      ze.local_id AS local_id
    FROM SCHEMANAME.spatial_plan sp
    INNER JOIN SCHEMANAME.zoning_element ze
      ON sp.local_id = ze.spatial_plan
    WHERE (
      sp.valid_from IS NOT NULL
      AND (
        ze.valid_from IS NULL
        OR ze.valid_from < sp.valid_from
      )
    ) OR (
      sp.valid_to IS NOT NULL
      AND (
        ze.valid_to IS NULL
        OR ze.valid_to > sp.valid_to
      )
    )
  )
  UPDATE SCHEMANAME.zoning_element ze
  SET valid_from = spiv.valid_from,
      valid_to = spiv.valid_to
  FROM sp_inherited_validity spiv
  WHERE spiv.local_id = ze.local_id;

  WITH ze_inherited_validity AS (
    SELECT
      MIN(ze.valid_from) AS valid_from,
      MAX(ze.valid_to) AS valid_to,
      ps.local_id AS local_id
    FROM SCHEMANAME.zoning_element ze
      INNER JOIN SCHEMANAME.zoning_element_planned_space ze_ps
        ON ze_ps.zoning_element_local_id = ze.local_id
      INNER JOIN SCHEMANAME.planned_space ps
        ON ps.local_id = ze_ps.planned_space_local_id
    WHERE (
      ze.valid_from IS NOT NULL
      AND (
        ps.valid_from IS NULL
        OR ps.valid_from < ze.valid_from
      )
    ) OR (
      ze.valid_to IS NOT NULL
      AND (
        ps.valid_to IS NULL
        OR ps.valid_to > ze.valid_to
      )
    )
    GROUP BY ps.local_id
  )
  UPDATE SCHEMANAME.planned_space ps
  SET valid_from = zeiv.valid_from,
      valid_to = zeiv.valid_to
  FROM ze_inherited_validity zeiv
  WHERE zeiv.local_id = ps.local_id;

  RETURN NULL;
END;
$function$
;

CREATE OR REPLACE FUNCTION SCHEMANAME.update_validity()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
  PERFORM SCHEMANAME.refresh_validity();

  CREATE TEMPORARY TABLE temp_spatial_plan AS (
    SELECT
      sp.local_id AS local_id,
      sp.geom AS geom,
      sp.valid_from AS valid_from,
      sp.valid_to AS valid_to,
      sp.validity AS validity,
      sp.validity_time AS validity_time
    FROM SCHEMANAME.spatial_plan sp
    WHERE
      sp.valid_from IS NOT NULL
      AND sp.validity <> 3
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
      ze.local_id AS local_id,
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

    UPDATE SCHEMANAME.planned_space ps
    SET validity = 3
    WHERE public.st_within(ps.geom, public.st_buffer(
      (WITH RECURSIVE zoning_elements(local_id) AS (
        SELECT ze.local_id
        FROM SCHEMANAME.zoning_element ze
        WHERE ze.valid_from IS NOT NULL
          AND ze.validity <> 3
          AND (ze.valid_to IS NULL OR ze.valid_to >= Current_Date)
            EXCEPT
        SELECT ze_ps.zoning_element_local_id
        FROM SCHEMANAME.zoning_element_planned_space ze_ps
        WHERE ze_ps.planned_space_local_id = ps.local_id
    )
      SELECT public.st_union(ze.geom)
      FROM SCHEMANAME.zoning_element ze,
            zoning_elements zes
      WHERE ze.local_id = zes.local_id),
    0.1)) = TRUE
      AND ps.validity <> 3;

    UPDATE SCHEMANAME.planned_space ps
    SET validity = 2
    WHERE public.st_overlaps(ps.geom, public.st_buffer(
      (WITH RECURSIVE zoning_elements(local_id) AS (
        SELECT ze.local_id
        FROM SCHEMANAME.zoning_element ze
        WHERE ze.valid_from IS NOT NULL
          AND ze.validity = 1
          AND (ze.valid_to IS NULL OR ze.valid_to >= Current_Date)
            EXCEPT
        SELECT ze_ps.zoning_element_local_id
        FROM SCHEMANAME.zoning_element_planned_space ze_ps
        WHERE ze_ps.planned_space_local_id = ps.local_id
      )
        SELECT public.st_union(ze.geom)
        FROM SCHEMANAME.zoning_element ze,
              zoning_elements zes
        WHERE zes.local_id = ze.local_id
      ),
        0.1)) = TRUE
      AND ps.validity = 1;

    UPDATE SCHEMANAME.planning_detail_line pdl
    SET validity = 3
    WHERE public.st_within(pdl.geom, public.st_buffer(
      (WITH RECURSIVE zoning_elements(local_id) AS (
        SELECT ze.local_id
        FROM SCHEMANAME.zoning_element ze
        WHERE ze.valid_from IS NOT NULL
          AND ze.validity <> 3
          AND (ze.valid_to IS NULL OR ze.valid_to >= Current_Date)
            EXCEPT
        SELECT ze_pdl.zoning_element_local_id
        FROM SCHEMANAME.zoning_element_plan_detail_line ze_pdl
        WHERE ze_pdl.planning_detail_line_local_id = pdl.local_id
      )
        SELECT public.st_union(ze.geom)
        FROM SCHEMANAME.zoning_element ze,
              zoning_elements zes
        WHERE ze.local_id = zes.local_id
      ),
        0.1)) = TRUE
      AND pdl.validity <> 3;

    UPDATE SCHEMANAME.planning_detail_line pdl
    SET validity = 2
    WHERE public.st_crosses(pdl.geom, public.st_buffer(
      (WITH RECURSIVE zoning_elements(local_id) AS (
        SELECT ze.local_id
        FROM SCHEMANAME.zoning_element ze
        WHERE ze.valid_from IS NOT NULL
          AND ze.validity = 1
          AND (ze.valid_to IS NULL OR ze.valid_to >= Current_Date)
            EXCEPT
        SELECT ze_pdl.zoning_element_local_id
        FROM SCHEMANAME.zoning_element_plan_detail_line ze_pdl
        WHERE ze_pdl.planning_detail_line_local_id = pdl.local_id
      )
        SELECT public.st_union(ze.geom)
        FROM SCHEMANAME.zoning_element ze,
              zoning_elements zes
        WHERE ze.local_id = zes.local_id
      ),
      0.1)) = TRUE
      AND pdl.validity = 1;


    UPDATE SCHEMANAME.describing_line dl
    SET validity = 3
    WHERE public.st_within(dl.geom, public.st_buffer(
      (WITH RECURSIVE zoning_elements(local_id) AS (
        SELECT ze.local_id
        FROM SCHEMANAME.zoning_element ze
        WHERE ze.valid_from IS NOT NULL
          AND ze.validity <> 3
          AND (ze.valid_to IS NULL OR ze.valid_to >= Current_Date)
            EXCEPT
        SELECT ze_dl.zoning_element_local_id
        FROM SCHEMANAME.zoning_element_describing_line ze_dl
        WHERE ze_dl.describing_line_id = dl.identifier
      )
        SELECT public.st_union(ze.geom)
        FROM SCHEMANAME.zoning_element ze,
              zoning_elements zes
        WHERE ze.local_id = zes.local_id
      ),
      0.1)) = TRUE
      AND dl.validity <> 3;

    UPDATE SCHEMANAME.describing_line dl
    SET validity = 2
    WHERE public.st_crosses(dl.geom, public.st_buffer(
      (WITH RECURSIVE zoning_elements(local_id) AS (
        SELECT ze.local_id
        FROM SCHEMANAME.zoning_element ze
        WHERE ze.valid_from IS NOT NULL
          AND ze.validity = 1
          AND (ze.valid_to IS NULL OR ze.valid_to >= Current_Date)
            EXCEPT
        SELECT ze_dl.zoning_element_local_id
        FROM SCHEMANAME.zoning_element_describing_line ze_dl
        WHERE ze_dl.describing_line_id = dl.identifier
      )
        SELECT public.st_union(ze.geom)
        FROM SCHEMANAME.zoning_element ze,
              zoning_elements zes
        WHERE ze.local_id = zes.local_id
      ),
      0.1)) = TRUE
      AND dl.validity = 1;


    UPDATE SCHEMANAME.describing_text dt
    SET validity = 3
    WHERE public.st_within(dt.geom, public.st_buffer(
      (WITH RECURSIVE zoning_elements(local_id) AS (
        SELECT ze.local_id
        FROM SCHEMANAME.zoning_element ze
        WHERE ze.valid_from IS NOT NULL
          AND ze.validity <> 3
          AND (ze.valid_to IS NULL OR ze.valid_to >= Current_Date)
            EXCEPT
        SELECT ze_dt.zoning_element_local_id
        FROM SCHEMANAME.zoning_element_describing_text ze_dt
        WHERE ze_dt.describing_text_id = dt.identifier
      )
        SELECT public.st_union(ze.geom)
        FROM SCHEMANAME.zoning_element ze,
              zoning_elements zes
        WHERE ze.local_id = zes.local_id
      ),
      0.1)) = TRUE
      AND dt.validity <> 3;

    PERFORM SCHEMANAME.refresh_validity();
    RETURN NULL;
END;
$function$
;

CREATE OR REPLACE FUNCTION SCHEMANAME.validate_zoning_element_validity_dates(valid_from date, valid_to date, spatial_plan character varying)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
DECLARE
  sp_valid_from DATE;
  sp_valid_to DATE;
  is_valid BOOLEAN := TRUE;
BEGIN
  SELECT sp.valid_from, sp.valid_to
  INTO sp_valid_from, sp_valid_to
  FROM SCHEMANAME.spatial_plan sp
  WHERE sp.local_id = spatial_plan;

  IF valid_from IS NOT NULL AND valid_to IS NOT NULL AND valid_from > valid_to THEN
    is_valid := FALSE;
  ELSIF valid_from IS NOT NULL AND sp_valid_from IS NOT NULL AND valid_from < sp_valid_from THEN
    is_valid := FALSE;
  ELSIF valid_to IS NOT NULL AND sp_valid_to IS NOT NULL AND valid_to > sp_valid_to THEN
    is_valid := FALSE;
  END IF;

  RETURN is_valid;
END;
$function$
;