from typing import Dict, List
from ..database.database import Database
from psycopg2 import sql
from psycopg2.extras import DictRow


class VersionControl:
    def __init__(self, db: Database, schema: str) -> None:
        self.db = db
        self.schema = schema

    def create_new_version(self, splan_local_id: str, version_name: str) -> str:
        splan = self.db.insert_with_return(sql.SQL('''
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
                old_local_id=sql.Literal(splan_local_id),
                new_version_name=sql.Literal(version_name)
                ))[0]

        new_zoning_elements = self.create_zoning_elements(splan_local_id, splan["local_id"])

        new_planned_spaces = self.create_planned_spaces(new_zoning_elements)

        new_planning_detail_lines = self.create_planning_detail_lines(new_zoning_elements, new_planned_spaces)

        new_describing_lines = self.create_describing_lines(new_zoning_elements)

        new_describing_texts = self.create_describing_texts(new_zoning_elements)

        return splan["local_id"]

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

    def convert_keys_to_new(self, data: List[List[str]], table_a_keys: List[Dict[str, str]], table_b_keys: List[Dict[str, str]]) -> List[List[str]]:
        table_a_key_map = {key["old_key"]: key["new_key"] for key in table_a_keys}
        table_b_key_map = {key["old_key"]: key["new_key"] for key in table_b_keys}
        merged_key_map = table_a_key_map | table_b_key_map
        return [[merged_key_map[item[0]], merged_key_map[item[1]]] for item in data]

    def convert_to_key_dict(self, keys: Dict[str, DictRow]) -> List[Dict[str, str]]:
        result = []
        for k, v in keys.items():
            new_key = v["local_id"] if v.get("local_id") is not None else v["identifier"]
            result.append({"old_key": k, "new_key": new_key})
        return result





