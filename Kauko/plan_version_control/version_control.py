from typing import Dict, List
from ..database.database import Database
from psycopg2 import sql
from psycopg2.extras import DictRow


class VersionControl:
    def __init__(self, db: Database, schema: str) -> None:
        self.db = db
        self.schema = schema

    def create_new_version(self, splan_local_id: str, version_name: str) -> str:
        new_spatial_plan = self.create_new_spatial_plan(splan_local_id, version_name)
        new_planners = self.create_planners(splan_local_id, new_spatial_plan["local_id"])
        new_zoning_elements = self.create_zoning_elements(splan_local_id, new_spatial_plan["local_id"])
        new_planned_spaces = self.create_planned_spaces(new_zoning_elements)
        new_planning_detail_lines = self.create_planning_detail_lines(new_zoning_elements, new_planned_spaces)
        new_describing_lines = self.create_describing_lines(new_zoning_elements)
        new_describing_texts = self.create_describing_texts(new_zoning_elements)

        return new_spatial_plan["local_id"]

    def create_new_spatial_plan(self, old_splan_local_id: str, new_version_name) -> DictRow:
        return self.db.insert_with_return(sql.SQL('''
            INSERT INTO {schema}.spatial_plan (
                identity_id,
                geom,
                plan_id,
                approval_time,
                approved_by,
                epsg,
                vertical_coordinate_system,
                land_administration_authority,
                "language",
                valid_from,
                valid_to,
                is_released,
                "type",
                digital_origin,
                ground_relative_position,
                legal_effectiveness,
                validity_time,
                lifecycle_status,
                "name",
                initiation_time,
                version_name,
                is_active
            )
            SELECT
                identity_id,
                geom,
                plan_id,
                approval_time,
                approved_by,
                epsg,
                vertical_coordinate_system,
                land_administration_authority,
                "language",
                valid_from,
                valid_to,
                is_released,
                "type",
                digital_origin,
                ground_relative_position,
                legal_effectiveness,
                validity_time,
                lifecycle_status,
                "name",
                initiation_time,
                {new_version_name},
                false
            FROM {schema}.spatial_plan sp
            WHERE local_id = {old_local_id}
            RETURNING *;
            ''').format(
                schema=sql.Identifier(self.schema),
                old_local_id=sql.Literal(old_splan_local_id),
                new_version_name=sql.Literal(new_version_name)
                ))[0]

    def create_planners(self, old_splan_local_id:str, new_splan_local_id: str) -> List[DictRow]:
        return self.db.insert_with_return(sql.SQL(
            '''
            INSERT INTO {schema}.planner (
                name,
                professional_title,
                role,
                identity_id,
                namespace,
                fk_spatial_plan
            )
            SELECT
                name,
                professional_title,
                role,
                identity_id,
                namespace,
                {new_fk_spatial_plan}
            FROM {schema}.planner
            WHERE fk_spatial_plan = {old_fk_spatial_plan}
            RETURNING *;
            ''').format(
                schema=sql.Identifier(self.schema),
                old_fk_spatial_plan=sql.Literal(old_splan_local_id),
                new_fk_spatial_plan=sql.Literal(new_splan_local_id)
            ))

    def create_participation_and_evalution_plan(self, old_splan_local_id: str, new_splan_local_id: str) -> DictRow:
        old_participation_and_evalution_plans = self.db.select(sql.SQL(
            '''
            SELECT local_id
            FROM {schema}.participation_and_evalution_plan
            WHERE spatial_plan = {old_spatial_plan_local_id}
            RETURNING *;
            ''').format(
                schema=sql.Identifier(self.schema),
                old_spatial_plan_local_id=sql.Literal(old_splan_local_id)
            )
        )

        new_participation_and_evalution_plans = {}
        for participation_and_evalution_plan in old_participation_and_evalution_plans:
            new_participation_and_evalution_plan = self.db.insert_with_return(sql.SQL(
                '''
                INSERT INTO {schema}.participation_and_evalution_plan (
                    local_id,
                    identity_id,
                    namespace,
                    spatial_plan
                )
                SELECT
                    CONCAT(identity_id, '.', uuid_generate_v4()::text),
                    identity_id,
                    namespace,
                    {new_spatial_plan_local_id}
                FROM {schema}.participation_and_evalution_plan
                WHERE local_id = {old_participation_and_evalution_plan_local_id}
                RETRUNING *;
                ''').format(
                    schema=sql.Identifier(self.schema),
                    new_spatial_plan_local_id=sql.Literal(new_splan_local_id),
                    old_participation_and_evalution_plan_local_id=sql.Literal(participation_and_evalution_plan["local_id"])
                ))
            new_participation_and_evalution_plans[participation_and_evalution_plan["local_id"]] = new_participation_and_evalution_plan[0]

    def create_regulations(self, old_splan_local_id, new_splan_local_id) -> Dict[str, DictRow]:
        old_regulations = self.db.select(sql.SQL(
            '''
            SELECT DISTINCT zer.plan_regulation_local_id AS local_id
            FROM {schema}.zoning_element_plan_regulation AS zer
            JOIN {schema}.zoning_element AS ze ON ze.local_id = zer.zoning_element_local_id
            WHERE ze.spatial_plan = {old_spatial_plan_local_id}

            UNION

            SELECT DISTINCT psr.plan_regulation_group_local_id AS local_id
            FROM {schema}.zoning_element_planned_space AS zeps
            JOIN {schema}.planned_space_plan_regulation_group AS psr ON psr.planned_space_local_id = zeps.planned_space_local_id
            JOIN {schema}.zoning_element AS ze ON ze.local_id = zeps.zoning_element_local_id
            WHERE ze.spatial_plan = {old_spatial_plan_local_id}

            UNION

            SELECT DISTINCT pdlr.plan_regulation_local_id AS local_id
            FROM {schema}.zoning_element_plan_detail_line AS zedl
            JOIN {schema}.planning_detail_line_plan_regulation AS pdlr ON pdlr.planning_detail_line_local_id = zedl.planning_detail_line_local_id
            JOIN {schema}.zoning_element AS ze ON ze.local_id = zedl.zoning_element_local_id
            WHERE ze.spatial_plan = {old_spatial_plan_local_id}

            UNION

            SELECT DISTINCT prgr.plan_regulation_local_id AS local_id
            FROM {schema}.zoning_element ze
            JOIN {schema}.zoning_element_plan_regulation_group zeprg ON zeprg.zoning_element_local_id = ze.local_id
            JOIN {schema}.plan_regulation_group_regulation prgr ON prgr.plan_regulation_group_local_id = zeprg.plan_regulation_group_local_id
            WHERE ze.spatial_plan = {old_spatial_plan_local_id}

            UNION

            SELECT DISTINCT prgr.plan_regulation_local_id AS local_id
            FROM {schema}.zoning_element ze
            JOIN {schema}.zoning_element_planned_space zeps ON zeps.zoning_element_local_id = ze.local_id
            JOIN {schema}.planned_space_plan_regulation_group psprg ON zeps.planned_space_local_id = psprg.planned_space_local_id
            JOIN {schema}.plan_regulation_group_regulation prgr ON prgr.plan_regulation_group_local_id = psprg.plan_regulation_group_local_id
            WHERE ze.spatial_plan = {old_spatial_plan_local_id}

            UNION

            SELECT DISTINCT prgr.plan_regulation_local_id AS local_id
            FROM {schema}.zoning_element ze
            JOIN {schema}.zoning_element_plan_detail_line zepdl ON zepdl.zoning_element_local_id = ze.local_id
            JOIN {schema}.planning_detail_line_plan_regulation_group pdlprg ON zepdl.planning_detail_line_local_id = pdlprg.planning_detail_line_local_id
            JOIN {schema}.plan_regulation_group_regulation prgr ON pdlprg.plan_regulation_group_local_id = prgr.plan_regulation_group_local_id
            WHERE ze.spatial_plan = {old_spatial_plan_local_id}
            RETURNING *;
            ''').format(
                schema=sql.Identifier(self.schema),
                old_spatial_plan_local_id=sql.Literal(old_splan_local_id)
            )
        )

        new_regulations: Dict[str, DictRow] = {}
        for regulation in old_regulations:
            new_regulation = self.db.insert_with_return(sql.SQL(
                '''
                INSERT INTO {schema}.plan_regulation (
                    local_id,
                    identity_id,
                    namespace,
                    name,
                    type,
                    life_cycle_status,
                    valid_from,
                    valid_to
                )
                SELECT
                    CONCAT(identity_id, '.', uuid_generate_v4()::text),
                    identity_id,
                    namespace,
                    name,
                    type,
                    life_cycle_status,
                    valid_from,
                    valid_to
                FROM {schema}.plan_regulation
                WHERE local_id = {old_regulation_local_id}
                RETURNING *;
                ''').format(
                    schema=sql.Identifier(self.schema),
                    old_regulation_local_id=sql.Literal(regulation["local_id"])
                )
            )
            new_regulations[regulation["local_id"]] = new_regulation[0]

        self.create_plan_regulation_text_values(new_regulations)
        self.create_plan_regulation_code_values(new_regulations)
        self.create_plan_regulation_geometry_area_values(new_regulations)
        self.create_plan_regulation_geometry_line_values(new_regulations)
        self.create_plan_regulation_geometry_point_values(new_regulations)
        self.create_plan_regulation_identifier_values(new_regulations)
        self.create_plan_regulation_double_values(new_regulations)
        self.create_plan_regulation_numeric_range_values(new_regulations)
        self.create_plan_regulation_time_instant_values(new_regulations)
        self.create_plan_regulation_time_period_values(new_regulations)

        return new_regulations

    def create_plan_regulation_values(self, plan_regulations: Dict[str, DictRow], value_type: str, columns: List[str]) -> Dict[str, DictRow]:
        new_values: Dict[str, DictRow] = {}
        old_values = self.db.select(
            sql.SQL(
                f'''
                SELECT DISTINCT fk_{value_type}_value
                FROM {{schema}}.plan_regulation_{value_type}_value
                WHERE fk_plan_regulation IN ({{old_regulation_local_ids}})
                ''').format(
                    schema=sql.Identifier(self.schema),
                    old_regulation_local_ids=sql.SQL(', ').join(sql.Literal(regulation_local_id) for regulation_local_id in plan_regulations)
            )
        )

        old_values = [item[f"fk_{value_type}_value"] for item in old_values]

        for value in old_values:
            new_value = self.db.insert_with_return(sql.SQL(
                f'''
                INSERT INTO {{schema}}.{value_type}_value (
                    {{columns}}
                )
                SELECT
                    {{columns}}
                FROM {{schema}}.{value_type}_value
                WHERE {value_type}_value_uuid = {{old_{value_type}_value_uuid}}
                RETURNING *;
                ''').format(
                    schema=sql.Identifier(self.schema),
                    old_value_uuid=sql.Literal(value),
                    columns=sql.SQL(', ').join(sql.Identifier(column) for column in columns)
                )
            )
            new_values[value] = new_value[0]

        plan_regulation_values = self.db.select(sql.SQL(
            f'''
            SELECT
                fk_plan_regulation,
                fk_{value_type}_value
            FROM {{schema}}.plan_regulation_{value_type}_value
            WHERE fk_{value_type}_value IN ({{value_uuids}})
            ''').format(
                schema=sql.Identifier(self.schema),
                value_uuids=sql.SQL(', ').join(sql.Literal(value_uuid) for value_uuid in old_values)
            )
        )

        plan_regulation_values = [[d["fk_plan_regulation"], d[f"fk_{value_type}_value"]] for d in plan_regulation_values]
        new_regulation_local_ids = self.convert_to_key_dict(plan_regulations)
        value_uuids = self.convert_to_key_dict(new_values, f"{value_type}_value_uuid")

        plan_regulation_values = self.convert_keys_to_new(plan_regulation_values, new_regulation_local_ids, value_uuids)

        self.db.insert(sql.SQL(
            f'''
            INSERT INTO {{schema}}.plan_regulation_{value_type}_value (
                fk_plan_regulation,
                fk_{value_type}_value
            )
            VALUES {{values}}
            ''').format(
                schema=sql.Identifier(self.schema),
                values=sql.SQL(", ").join(sql.SQL("({})").format(sql.SQL(', ').join(map(sql.Literal, row))) for row in plan_regulation_values)
            )
        )

        return new_values


    def create_plan_regulation_text_values(self, plan_regulations: Dict[str, DictRow]) -> Dict[str, DictRow]:
        columns = ["value", "syntax"]
        return self.create_plan_regulation_values(plan_regulations, "text", columns)

    def create_plan_regulation_code_values(self, plan_regulations: Dict[str, DictRow]) -> Dict[str, DictRow]:
        columns = ["value", "code_list", "title"]
        return self.create_plan_regulation_values(plan_regulations, "code", columns)

    def create_plan_regulation_geometry_area_values(self, plan_regulations: Dict[str, DictRow]) -> Dict[str, DictRow]:
        columns = ["value", "obligatory"]
        return self.create_plan_regulation_values(plan_regulations, "geometry_area", columns)

    def create_plan_regulation_geometry_line_values(self, plan_regulations: Dict[str, DictRow]) -> Dict[str, DictRow]:
        columns = ["value", "obligatory"]
        return self.create_plan_regulation_values(plan_regulations, "geometry_line", columns)

    def create_plan_regulation_geometry_point_values(self, plan_regulations: Dict[str, DictRow]) -> Dict[str, DictRow]:
        columns = ["value", "obligatory"]
        return self.create_plan_regulation_values(plan_regulations, "geometry_point", columns)

    def create_plan_regulation_identifier_values(self, plan_regulations: Dict[str, DictRow]) -> Dict[str, DictRow]:
        columns = ["value", "register_id", "register_name"]
        return self.create_plan_regulation_values(plan_regulations, "identifier", columns)

    def create_plan_regulation_double_values(self, plan_regulations: Dict[str, DictRow]) -> Dict[str, DictRow]:
        columns = ["value", "unit_of_measure", "obligatory"]
        return self.create_plan_regulation_values(plan_regulations, "numeric_double", columns)

    def create_plan_regulation_numeric_range_values(self, plan_regulations: Dict[str, DictRow]) -> Dict[str, DictRow]:
        columns = ["minimum_value", "maximum_value", "unit_of_measure"]
        return self.create_plan_regulation_values(plan_regulations, "numeric_range", columns)

    def create_plan_regulation_time_instant_values(self, plan_regulations: Dict[str, DictRow]) -> Dict[str, DictRow]:
        columns = ["value"]
        return self.create_plan_regulation_values(plan_regulations, "time_instant", columns)

    def create_plan_regulation_time_period_values(self, plan_regulations: Dict[str, DictRow]) -> Dict[str, DictRow]:
        columns = ["time_period_from", "time_period_to"]
        return self.create_plan_regulation_values(plan_regulations, "time_period", columns)

    def create_zoning_elements(self, old_splan_local_id, new_splan_local_id) -> Dict[str, DictRow]:
        old_zoning_elements = self.db.select(sql.SQL(
        '''
        SELECT local_id
        FROM {schema}.zoning_element
        WHERE spatial_plan = {old_spatial_plan_local_id}
        ''').format(
            schema=sql.Identifier(self.schema),
            old_spatial_plan_local_id=sql.Literal(old_splan_local_id)
        ))

        new_zoning_elements = {}
        for zoning_element in old_zoning_elements:
            new_zoning_element = self.db.insert_with_return(sql.SQL(
                '''
                INSERT INTO {schema}.zoning_element (
                local_id,
                identity_id,
                geom,
                localized_name,
                "name",
                "type",
                up_to_dateness,
                valid_from,
                valid_to,
                block_number,
                parcel_number,
                bindingness_of_location,
                ground_relative_position,
                land_use_kind,
                spatial_plan,
                validity_time,
                lifecycle_status,
                is_active
                )
                SELECT
                    CONCAT(identity_id, '.', uuid_generate_v4()::text),
                    identity_id,
                    geom,
                    localized_name,
                    "name",
                    "type",
                    up_to_dateness,
                    valid_from,
                    valid_to,
                    block_number,
                    parcel_number,
                    bindingness_of_location,
                    ground_relative_position,
                    land_use_kind,
                    {new_spatial_plan_local_id},
                    validity_time,
                    lifecycle_status,
                    false
                FROM {schema}.zoning_element
                WHERE local_id = {zoning_element_local_id}
                RETURNING *;
                ''').format(
                    schema=sql.Identifier(self.schema),
                    new_spatial_plan_local_id=sql.Literal(new_splan_local_id),
                    zoning_element_local_id=sql.Literal(zoning_element["local_id"])
                ))
            new_zoning_elements[zoning_element["local_id"]] = new_zoning_element[0]

        return new_zoning_elements

    def create_planned_spaces(self, zoning_elements: Dict[str, DictRow]) -> Dict[str, DictRow]:
        old_zoning_elements = list(zoning_elements.keys())
        old_planned_spaces = self.db.select(sql.SQL(
            '''
            SELECT DISTINCT zeps.planned_space_local_id
            FROM {schema}.zoning_element_planned_space zeps
            WHERE zeps.zoning_element_local_id IN ({zoning_element_local_ids})
            ''').format(
                schema=sql.Identifier(self.schema),
                zoning_element_local_ids=sql.SQL(', ').join(sql.Literal(zoning_element_local_id) for zoning_element_local_id in old_zoning_elements)
            )
        )

        old_planned_spaces =  [item["planned_space_local_id"] for item in old_planned_spaces]

        new_planned_spaces: Dict[str, DictRow] = {}

        for planned_space in old_planned_spaces:
            new_planned_space = self.db.insert_with_return(sql.SQL(
                '''
                INSERT INTO {schema}.planned_space (
                    geom,
                    valid_from,
                    valid_to,
                    bindingness_of_location,
                    ground_relative_position,
                    identity_id,
                    namespace,
                    lifecycle_status,
                    is_active
                )
                SELECT
                    geom,
                    valid_from,
                    valid_to,
                    bindingness_of_location,
                    ground_relative_position,
                    identity_id,
                    namespace,
                    lifecycle_status,
                    false
                FROM {schema}.planned_space
                WHERE local_id = {planned_space_local_id}
                RETURNING *;
                ''').format(
                    schema=sql.Identifier(self.schema),
                    planned_space_local_id=sql.Literal(planned_space)
                )
            )
            new_planned_spaces[planned_space] = new_planned_space[0]

        zoning_element_planned_spaces = self.db.select(sql.SQL(
            '''
            SELECT
            zoning_element_local_id,
            planned_space_local_id
            FROM {schema}.zoning_element_planned_space
            WHERE planned_space_local_id IN ({planned_space_local_ids})
            ''').format(
                schema=sql.Identifier(self.schema),
                planned_space_local_ids=sql.SQL(', ').join(sql.Literal(planned_space_local_id) for planned_space_local_id in old_planned_spaces),
            )
        )

        zoning_element_planned_spaces = [[d["zoning_element_local_id"], d["planned_space_local_id"]] for d in zoning_element_planned_spaces]
        new_zoning_elements_local_ids = self.convert_to_key_dict(zoning_elements)
        planned_space_local_ids = self.convert_to_key_dict(new_planned_spaces)

        zoning_element_planned_spaces = self.convert_keys_to_new(zoning_element_planned_spaces, new_zoning_elements_local_ids, planned_space_local_ids)

        self.db.insert(sql.SQL(
            '''
            INSERT INTO {schema}.zoning_element_planned_space (
                zoning_element_local_id,
                planned_space_local_id)
            VALUES {values}
            ''').format(
                schema=sql.Identifier(self.schema),
                values = sql.SQL(", ").join(sql.SQL("({})").format(sql.SQL(', ').join(map(sql.Literal, row))) for row in zoning_element_planned_spaces)
            )
        )

        return new_planned_spaces

    def create_planning_detail_lines(self, zoning_elements: Dict[str, DictRow], planned_spaces: Dict[str, DictRow]) -> Dict[str, DictRow]:
        old_zoning_elements = list(zoning_elements.keys())
        old_planning_detail_lines = self.db.select(sql.SQL(
            '''
            SELECT DISTINCT planning_detail_line_local_id
            FROM {schema}.zoning_element_plan_detail_line zeps
            WHERE zeps.zoning_element_local_id IN ({zoning_element_local_ids})
            ''').format(
                schema=sql.Identifier(self.schema),
                zoning_element_local_ids=sql.SQL(', ').join(sql.Literal(zoning_element_local_id) for zoning_element_local_id in old_zoning_elements)
            )
        )

        old_planning_detail_lines =  [item["planning_detail_line_local_id"] for item in old_planning_detail_lines]

        new_planning_detail_lines: Dict[str, DictRow] = {}

        for planning_detail_line in old_planning_detail_lines:
            new_planning_detail_line = self.db.insert_with_return(sql.SQL(
                '''
                INSERT INTO {schema}.planning_detail_line (
                    geom,
                    identity_id,
                    namespace,
                    bindingness_of_location,
                    ground_relative_position,
                    lifecycle_status,
                    name,
                    is_active
                )
                SELECT
                    geom,
                    identity_id,
                    namespace,
                    bindingness_of_location,
                    ground_relative_position,
                    lifecycle_status,
                    name,
                    false
                FROM {schema}.planning_detail_line
                WHERE local_id = {planning_detail_line_local_id}
                RETURNING *;
                ''').format(
                    schema=sql.Identifier(self.schema),
                    planning_detail_line_local_id=sql.Literal(planning_detail_line)
                )
            )
            new_planning_detail_lines[planning_detail_line] = new_planning_detail_line[0]

        zoning_element_planning_detail_lines = self.db.select(sql.SQL(
            '''
            SELECT
            zoning_element_local_id,
            planning_detail_line_local_id
            FROM {schema}.zoning_element_plan_detail_line
            WHERE planning_detail_line_local_id IN ({planning_detail_line_local_ids})
            ''').format(
                schema=sql.Identifier(self.schema),
                planning_detail_line_local_ids=sql.SQL(', ').join(sql.Literal(planned_space_local_id) for planned_space_local_id in old_planning_detail_lines),
            )
        )

        zoning_element_planning_detail_lines = [[d["zoning_element_local_id"], d["planning_detail_line_local_id"]] for d in zoning_element_planning_detail_lines]
        new_zoning_elements_local_ids = self.convert_to_key_dict(zoning_elements)
        planning_detail_line_local_ids = self.convert_to_key_dict(new_planning_detail_lines)

        zoning_element_planning_detail_lines = self.convert_keys_to_new(zoning_element_planning_detail_lines, new_zoning_elements_local_ids, planning_detail_line_local_ids)

        self.db.insert(sql.SQL(
            '''
            INSERT INTO {schema}.zoning_element_plan_detail_line (
                zoning_element_local_id,
                planning_detail_line_local_id)
            VALUES {values}
            ''').format(
                schema=sql.Identifier(self.schema),
                values = sql.SQL(", ").join(sql.SQL("({})").format(sql.SQL(', ').join(map(sql.Literal, row))) for row in zoning_element_planning_detail_lines)
            )
        )

        planned_space_planning_detail_lines = self.db.select(sql.SQL(
            '''
            SELECT
            planned_space_local_id,
            planning_detail_line_local_id
            FROM {schema}.planned_space_plan_detail_line
            WHERE planning_detail_line_local_id IN ({planning_detail_line_local_ids})
            ''').format(
                schema=sql.Identifier(self.schema),
                planning_detail_line_local_ids=sql.SQL(', ').join(sql.Literal(planned_space_local_id) for planned_space_local_id in old_planning_detail_lines),
            )
        )

        planned_space_planning_detail_lines = [[d["planned_space_local_id"], d["planning_detail_line_local_id"]] for d in planned_space_planning_detail_lines]
        new_planned_space_local_ids = self.convert_to_key_dict(planned_spaces)

        planned_space_planning_detail_lines = self.convert_keys_to_new(planned_space_planning_detail_lines, new_planned_space_local_ids, planning_detail_line_local_ids)

        self.db.insert(sql.SQL(
            '''
            INSERT INTO {schema}.planned_space_plan_detail_line (
                planned_space_local_id,
                planning_detail_line_local_id)
            VALUES {values}
            ''').format(
                schema=sql.Identifier(self.schema),
                values = sql.SQL(", ").join(sql.SQL("({})").format(sql.SQL(', ').join(map(sql.Literal, row))) for row in planned_space_planning_detail_lines)
            )
        )

        return new_planning_detail_lines

    def create_describing_lines(self, zoning_elements: Dict[str, DictRow]) -> Dict[str, DictRow]:
        old_zoning_elements = list(zoning_elements.keys())
        old_describing_lines = self.db.select(sql.SQL(
            '''
            SELECT DISTINCT describing_line_id
            FROM {schema}.zoning_element_describing_line zedl
            WHERE zedl.zoning_element_local_id IN ({zoning_element_local_ids})
            ''').format(
                schema=sql.Identifier(self.schema),
                zoning_element_local_ids=sql.SQL(', ').join(sql.Literal(zoning_element_local_id) for zoning_element_local_id in old_zoning_elements)
            ))

        old_describing_lines = [item["describing_line_id"] for item in old_describing_lines]

        new_describing_lines: Dict[str, DictRow] = {}

        for describing_line in old_describing_lines:
            new_describing_line = self.db.insert_with_return(sql.SQL(
                '''
                INSERT INTO {schema}.describing_line (
                    geom,
                    type,
                    lifecycle_status,
                    is_active
                )
                SELECT
                    geom,
                    type,
                    lifecycle_status,
                    false
                FROM {schema}.describing_line
                WHERE identifier = {describing_line_identifier}
                RETURNING *;
                ''').format(
                    schema=sql.Identifier(self.schema),
                    describing_line_identifier=sql.Literal(describing_line)
                )
            )
            new_describing_lines[describing_line] = new_describing_line[0]

        zoning_element_describing_lines = self.db.select(sql.SQL(
            '''
            SELECT
            zoning_element_local_id,
            describing_line_id
            FROM {schema}.zoning_element_describing_line
            WHERE describing_line_id IN ({describing_line_ids})
            ''').format(
                schema=sql.Identifier(self.schema),
                describing_line_ids=sql.SQL(', ').join(sql.Literal(describing_line_id) for describing_line_id in old_describing_lines)
            )
        )

        zoning_element_describing_lines = [[d["zoning_element_local_id"], d["describing_line_id"]] for d in zoning_element_describing_lines]
        new_zoning_elements_local_ids = self.convert_to_key_dict(zoning_elements)
        describing_line_ids = self.convert_to_key_dict(new_describing_lines)

        zoning_element_describing_lines = self.convert_keys_to_new(zoning_element_describing_lines, new_zoning_elements_local_ids, describing_line_ids)

        self.db.insert(sql.SQL(
            '''
            INSERT INTO {schema}.zoning_element_describing_line (
                zoning_element_local_id,
                describing_line_id)
            Values {values}
            ''').format(
                schema=sql.Identifier(self.schema),
                values = sql.SQL(", ").join(sql.SQL("({})").format(sql.SQL(', ').join(map(sql.Literal, row))) for row in zoning_element_describing_lines)
            )
        )

        return new_describing_lines

    def create_describing_texts(self, zoning_elements: Dict[str, DictRow]) -> Dict[str, DictRow]:
        old_zoning_elements = list(zoning_elements.keys())
        old_describing_texts = self.db.select(sql.SQL(
            '''
            SELECT DISTINCT describing_text_id
            FROM {schema}.zoning_element_describing_text zedt
            WHERE zedt.zoning_element_local_id IN ({zoning_element_local_ids})
            ''').format(
                schema=sql.Identifier(self.schema),
                zoning_element_local_ids=sql.SQL(', ').join(sql.Literal(zoning_element_local_id) for zoning_element_local_id in old_zoning_elements)
            ))

        old_describing_texts = [item["describing_text_id"] for item in old_describing_texts]

        new_describing_texts: Dict[str, DictRow] = {}

        for describing_text in old_describing_texts:
            new_describing_line = self.db.insert_with_return(sql.SQL(
                '''
                INSERT INTO {schema}.describing_text (
                    geom,
                    text,
                    label_x,
                    label_y,
                    label_rotation,
                    callouts,
                    big_letters,
                    lifecycle_status,
                    is_active
                )
                SELECT
                    geom,
                    text,
                    label_x,
                    label_y,
                    label_rotation,
                    callouts,
                    big_letters,
                    lifecycle_status,
                    false
                FROM {schema}.describing_text
                WHERE identifier = {describing_text_identifier}
                RETURNING *;
                ''').format(
                    schema=sql.Identifier(self.schema),
                    describing_text_identifier=sql.Literal(describing_text)
                )
            )
            new_describing_texts[describing_text] = new_describing_line[0]

        zoning_element_describing_texts = self.db.select(sql.SQL(
            '''
            SELECT
            zoning_element_local_id,
            describing_text_id
            FROM {schema}.zoning_element_describing_text
            WHERE describing_text_id IN ({describing_text_ids})
            ''').format(
                schema=sql.Identifier(self.schema),
                describing_text_ids=sql.SQL(', ').join(sql.Literal(describing_text_id) for describing_text_id in old_describing_texts)
            )
        )

        zoning_element_describing_texts = [[d["zoning_element_local_id"], d["describing_text_id"]] for d in zoning_element_describing_texts]
        new_zoning_elements_local_ids = self.convert_to_key_dict(zoning_elements)
        describing_text_ids = self.convert_to_key_dict(new_describing_texts)

        zoning_element_describing_texts = self.convert_keys_to_new(zoning_element_describing_texts, new_zoning_elements_local_ids, describing_text_ids)

        self.db.insert(sql.SQL(
            '''
            INSERT INTO {schema}.zoning_element_describing_text (
                zoning_element_local_id,
                describing_text_id)
            Values {values}
            ''').format(
                schema=sql.Identifier(self.schema),
                values = sql.SQL(", ").join(sql.SQL("({})").format(sql.SQL(', ').join(map(sql.Literal, row))) for row in zoning_element_describing_texts)
            )
        )

        return new_describing_texts

    @staticmethod
    def convert_keys_to_new(data: List[List[str]], table_a_keys: List[Dict[str, str]], table_b_keys: List[Dict[str, str]]) -> List[List[str]]:
        table_a_key_map = {key["old_key"]: key["new_key"] for key in table_a_keys}
        table_b_key_map = {key["old_key"]: key["new_key"] for key in table_b_keys}
        merged_key_map = table_a_key_map | table_b_key_map
        return [[merged_key_map[item[0]], merged_key_map[item[1]]] for item in data]

    @staticmethod
    def convert_to_key_dict(keys: Dict[str, DictRow], key_name: str = None) -> List[Dict[str, str]]:
        result = []
        for old_key, value in keys.items():
            new_key = value.get(key_name) or value["local_id"] if value.get("local_id") else value["identifier"]
            result.append({"old_key": old_key, "new_key": new_key})
        return result
