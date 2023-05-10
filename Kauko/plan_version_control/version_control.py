from enum import Enum
from typing import Dict, List
from ..database.database import Database
from psycopg2 import sql
from psycopg2.extras import DictRow

VALUE_TYPE_COLUMNS = {
    "text_value": ["value", "syntax"],
    "code_value": ["value", "code_list", "title"],
    "geometry_area_value": ["value", "obligatory"],
    "geometry_line_value": ["value", "obligatory"],
    "geometry_point_value": ["value", "obligatory"],
    "identifier_value": ["value", "register_id", "register_name"],
    "numeric_double_value": ["value", "unit_of_measure", "obligatory"],
    "numeric_range": ["minimum_value", "maximum_value", "unit_of_measure"],
    "time_instant_value": ["value"],
    "time_period_value": ["time_period_from", "time_period_to"],
    "elevation_position_value": ["value", "unit_of_measure", "reference_point", "vertical_reference_system"],
    "elevation_range_value": ["minimum_value", "maximum_value", "unit_of_measure", "reference_point", "vertical_reference_system"]
}

class ValueTableType(Enum):
    PLAN_REGULATION = 'plan_regulation'
    PLAN_GUIDANCE = 'plan_guidance'
    SUPPLEMENTARY_INFORMATION = 'supplementary_information'

class VersionControl:
    def __init__(self, db: Database, schema: str) -> None:
        self.db = db
        self.schema = schema

    def create_new_version(self, splan_local_id: str, version_name: str) -> str:
        new_spatial_plan = self.create_new_spatial_plan(splan_local_id, version_name)
        self.create_planners(splan_local_id, new_spatial_plan["local_id"])
        new_zoning_elements = self.create_zoning_elements(splan_local_id, new_spatial_plan["local_id"])
        new_planned_spaces = self.create_planned_spaces(new_zoning_elements)
        new_planning_detail_lines = self.create_planning_detail_lines(new_zoning_elements, new_planned_spaces)
        self.create_describing_lines(new_zoning_elements)
        self.create_describing_texts(new_zoning_elements)
        new_documents = self.create_documents(splan_local_id)
        new_regulations = self.create_regulations(splan_local_id)
        new_regulation_groups = self.create_regulation_groups(splan_local_id)
        new_guidances = self.create_plan_guidances(splan_local_id)
        new_participation_and_evaluation = self.create_participation_and_evalution_plan(splan_local_id, new_spatial_plan["local_id"])
        new_spatial_plan_commentaries = self.create_spatial_plan_commentaries(splan_local_id, new_spatial_plan["local_id"])

        # Create plan regulation relations
        self.create_regulation_relations(new_regulations, splan_local_id, new_spatial_plan["local_id"], new_zoning_elements, new_planned_spaces, new_planning_detail_lines, new_regulation_groups)

        # Create plan guidance relations
        self.create_guidance_relations(new_guidances, splan_local_id, new_spatial_plan["local_id"], new_zoning_elements, new_planned_spaces, new_planning_detail_lines)

        self.create_document_relations(new_documents, splan_local_id, new_spatial_plan["local_id"], new_participation_and_evaluation, new_spatial_plan_commentaries, new_regulations, new_guidances)

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

    def create_documents(self, old_splan_local_id: str) -> Dict[str, DictRow]:
        old_docs = self.db.select(sql.SQL(
            '''
                SELECT {schema}.get_document_local_ids({splan_local_id}) AS local_id;
            ''').format(
                schema=sql.Identifier(self.schema),
                splan_local_id=sql.Literal(old_splan_local_id)
            )
        )

        old_docs = [doc["local_id"] for doc in old_docs]

        new_docs: Dict[str, DictRow] = {}

        for doc in old_docs:
            new_doc = self.db.insert_with_return(sql.SQL(
                '''
                INSERT INTO {schema}.document (
                    identity_id,
                    local_id,
                    namespace,
                    document_identifier,
                    name,
                    additional_information_link,
                    metadata,
                    type
                )
                SELECT
                    identity_id,
                    CONCAT(identity_id, '.', uuid_generate_v4()::text),
                    namespace,
                    document_identifier,
                    name,
                    additional_information_link,
                    metadata,
                    type
                FROM {schema}.document
                WHERE local_id = {old_local_id}
                RETURNING *;
                ''').format(
                    schema=sql.Identifier(self.schema),
                    old_local_id=sql.Literal(doc["local_ids"])
                )
            )
            new_docs[doc["local_id"]] = new_doc[0]

        doc_docs = self.db.select(sql.SQL(
            '''
            SELECT
                referencing_document_local_id,
                referenced_document_local_id
            FROM {schema}.document_document
            WHERE referencing_document_local_id IN ({old_local_ids})
                OR referenced_document_local_id IN ({old_local_ids});
            ''').format(
                schema=sql.Identifier(self.schema),
                old_local_ids=self.format_ids_for_query(old_docs)
            )
        )

        doc_docs = [[d["referencing_document_local_id"], d["referenced_document_local_id"]] for d in doc_docs]
        new_doc_local_ids = self.convert_to_key_dict(new_docs)

        doc_docs = self.convert_keys_to_new(doc_docs, new_doc_local_ids, new_doc_local_ids)

        if len(doc_docs) > 0:
            self.db.insert(sql.SQL(
                '''
                INSERT INTO {schema}.document_document (
                    referencing_document_local_id,
                    referenced_document_local_id
                )
                VALUES {values}
                ''').format(
                    schema=sql.Identifier(self.schema),
                    values=sql.SQL(", ").join(sql.SQL("({})").format(sql.SQL(', ').join(map(sql.Literal, row))) for row in doc_docs)
            ))

        return new_docs


    def create_participation_and_evalution_plan(self, old_splan_local_id: str, new_splan_local_id: str) -> Dict[str, DictRow]:
        old_participation_and_evalution_plans = self.db.select(sql.SQL(
            '''
            SELECT local_id
            FROM {schema}.participation_and_evalution_plan
            WHERE spatial_plan = {old_spatial_plan_local_id}
            ''').format(
                schema=sql.Identifier(self.schema),
                old_spatial_plan_local_id=sql.Literal(old_splan_local_id)
            )
        )

        old_participation_and_evalution_plans = [plan["local_id"] for plan in old_participation_and_evalution_plans]

        new_participation_and_evalution_plans: Dict[str, DictRow] = {}
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
                RETURNING *;
                ''').format(
                    schema=sql.Identifier(self.schema),
                    new_spatial_plan_local_id=sql.Literal(new_splan_local_id),
                    old_participation_and_evalution_plan_local_id=sql.Literal(participation_and_evalution_plan)
                ))
            new_participation_and_evalution_plans[participation_and_evalution_plan] = new_participation_and_evalution_plan[0]

        return new_participation_and_evalution_plans

    def create_spatial_plan_commentaries(self, old_splan_local_id: str, new_splan_local_id: str) -> Dict[str, DictRow]:
        old_commentaries = self.db.select(sql.SQL(
            '''
            SELECT local_id
            FROM {schema}.spatial_plan_commentary
            WHERE spatial_plan = {old_splan_local_id}
            ''').format(
                schema=sql.Identifier(self.schema),
                old_splan_local_id=sql.Literal(old_splan_local_id)
            )
        )

        old_commentaries = [commentary["local_id"] for commentary in old_commentaries]

        new_commentaries: Dict[str, DictRow] = {}

        for commentary in old_commentaries:
            new_commentary = self.db.insert_with_return(sql.SQL(
                '''
                INSERT INTO {schema}.spatial_plan_commentary (
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
                FROM {schema}.spatial_plan_commentary
                WHERE local_id = {old_commentary_local_id}
                RETURNING *;
                ''').format(
                    schema=sql.Identifier(self.schema),
                    new_spatial_plan_local_id=sql.Literal(new_splan_local_id),
                    old_commentary_local_id=sql.Literal(commentary)
                ))
            new_commentaries[commentary] = new_commentary[0]


        return new_commentaries

    def create_regulation_groups(self, old_splan_local_id: str):
        old_regulation_groups = self.db.select(sql.SQL(
            '''
            SELECT {schema}.get_regulation_group_local_ids({old_spatial_plan_local_id}) AS local_id;
            ''').format(
                schema=sql.Identifier(self.schema),
                old_spatial_plan_local_id=sql.Literal(old_splan_local_id)
            )
        )

        old_regulation_groups = [group["local_id"] for group in old_regulation_groups]

        new_regulation_groups: Dict[str, DictRow] = {}

        for group in old_regulation_groups:
            new_regulation_group = self.db.insert_with_return(sql.SQL(
                '''
                INSERT INTO {schema}.plan_regulation_group (
                    local_id,
                    identity_id,
                    namespace,
                    name
                )
                SELECT
                    CONCAT(identity_id, '.', uuid_generate_v4()::text),
                    identity_id,
                    namespace,
                    name
                FROM {schema}.plan_regulation_group
                WHERE local_id = {old_regulation_group_local_id}
                RETURNING *;
                ''').format(
                    schema=sql.Identifier(self.schema),
                    old_regulation_group_local_id=sql.Literal(group)
                ))
            new_regulation_groups[group] = new_regulation_group[0]

        return new_regulation_groups

    def create_regulations(self, old_splan_local_id) -> Dict[str, DictRow]:
        old_regulations = self.db.select(sql.SQL(
            '''
            SELECT {schema}.get_plan_regulation_local_ids({old_spatial_plan_local_id}) AS local_id;
            ''').format(
                schema=sql.Identifier(self.schema),
                old_spatial_plan_local_id=sql.Literal(old_splan_local_id)
            )
        )

        old_regulations = [regulation["local_id"] for regulation in old_regulations]

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
                    old_regulation_local_id=sql.Literal(regulation)
                )
            )
            new_regulations[regulation] = new_regulation[0]


        self.create_values(new_regulations, ValueTableType.PLAN_REGULATION)

        # Duplicate plan_regulation_themes
        for old_regulation_local_id in new_regulations:
            self.db.insert(sql.SQL(
                '''
                INSERT INTO {schema}.plan_regulation_theme (
                    plan_regulation_local_id,
                    theme_code
                )
                SELECT
                    {new_regulation_local_id},
                    theme_code
                FROM {schema}.plan_regulation_theme
                WHERE plan_regulation_local_id = {old_regulation_local_id};
                ''').format(
                    schema=sql.Identifier(self.schema),
                    old_regulation_local_id=sql.Literal(old_regulation_local_id),
                    new_regulation_local_id=sql.Literal(new_regulations[old_regulation_local_id]["local_id"])
            ))

        self.create_supplementary_information(new_regulations)

        return new_regulations

    def insert_guidance_relations(self, table_name: str, element_key: str, new_elements: Dict[str, DictRow], old_guidance_local_ids: List[str], guidance_local_ids: List[Dict[str,str]]) -> None:

        def fetch_relations(table_name: str, element_key: str, old_element_local_ids: str, old_guidance_local_ids: str):
            return self.db.select(sql.SQL(
                f'''
                SELECT
                    {element_key},
                    plan_guidance_local_id
                FROM {{schema}}.{table_name}
                WHERE {element_key} IN ({{old_element_local_ids}})
                    AND plan_guidance_local_id IN ({{old_guidance_local_ids}});
                '''
            ).format(
                schema=sql.Identifier(self.schema),
                old_element_local_ids=old_element_local_ids,
                old_guidance_local_ids=old_guidance_local_ids
            ))

        old_element_local_ids = self.format_ids_for_query(new_elements)
        relations = fetch_relations(table_name, element_key, old_element_local_ids, old_guidance_local_ids)
        relations = [[relation[element_key], relation["plan_guidance_local_id"]] for relation in relations]

        element_local_ids = self.convert_to_key_dict(new_elements)
        relations = self.convert_keys_to_new(relations, element_local_ids, guidance_local_ids)

        if len(relations) > 0:
            self.db.insert(sql.SQL(
                f'''
                INSERT INTO {{schema}}.{table_name} (
                    {element_key},
                    plan_guidance_local_id
                )
                VALUES {{values}}
                '''
            ).format(
                schema=sql.Identifier(self.schema),
                values=self.format_values_for_insert(relations)
            ))

    def create_guidance_relations(
        self,
        new_guidances: Dict[str, DictRow],
        old_spatial_plan_local_id: str,
        new_spatial_plan_local_id: str,
        new_zoning_elements: Dict[str, DictRow],
        new_planned_spaces: Dict[str, DictRow],
        new_planning_detail_lines: Dict[str, DictRow],
    ) -> None:
        old_guidance_local_ids = self.format_ids_for_query(new_guidances)
        guidance_local_ids = self.convert_to_key_dict(new_guidances)

        spatial_plan_relations = self.db.select(sql.SQL(
            '''
            SELECT
                spatial_plan_local_id,
                plan_guidance_local_id
            FROM {schema}.spatial_plan_plan_guidance
            WHERE spatial_plan_local_id = {old_spatial_plan_local_id}
                AND plan_guidance_local_id IN ({old_guidance_local_ids});
            ''').format(
                schema=sql.Identifier(self.schema),
                old_spatial_plan_local_id=sql.Literal(old_spatial_plan_local_id),
                old_guidance_local_ids=old_guidance_local_ids
            )
        )

        spatial_plan_relations = [[relation["spatial_plan_local_id"], relation["plan_guidance_local_id"]] for relation in spatial_plan_relations]
        spatial_plan_local_ids = [{"old_key": old_spatial_plan_local_id, "new_key": new_spatial_plan_local_id}]

        spatial_plan_relations = self.convert_keys_to_new(spatial_plan_relations, spatial_plan_local_ids, guidance_local_ids)

        if len(spatial_plan_relations) > 0:
            self.db.insert(sql.SQL(
                '''
                INSERT INTO {schema}.spatial_plan_plan_guidance (
                    spatial_plan_local_id,
                    plan_guidance_local_id
                )
                VALUES {values}
                ''').format(
                    schema=sql.Identifier(self.schema),
                    values=self.format_values_for_insert(spatial_plan_relations)
                )
            )

        relations_data = [
            ('zoning_element_plan_guidance', 'zoning_element_local_id', new_zoning_elements),
            ('planned_space_plan_guidance', 'planned_space_local_id', new_planned_spaces),
            ('planning_detail_line_plan_guidance', 'planning_detail_line_local_id', new_planning_detail_lines),
        ]

        for table_name, element_key, new_elements in relations_data:
            self.insert_guidance_relations(table_name, element_key, new_elements, old_guidance_local_ids, guidance_local_ids)

    def insert_document_relations(self, table_name: str, element_key: str, new_elements: Dict[str, DictRow], old_document_local_ids: List[str], document_local_ids: List[Dict[str,str]]) -> None:

        def fetch_relations(table_name: str, element_key: str, old_element_local_ids: str, old_document_local_ids: str):
            return self.db.select(sql.SQL(
                f'''
                SELECT
                    {element_key},
                    document_local_id
                FROM {{schema}}.{table_name}
                WHERE {element_key} IN ({{old_element_local_ids}})
                    AND document_local_id IN ({{old_document_local_ids}});
                '''
            ).format(
                schema=sql.Identifier(self.schema),
                old_element_local_ids=old_element_local_ids,
                old_document_local_ids=old_document_local_ids
            ))

        old_element_local_ids = self.format_ids_for_query(new_elements)
        relations = fetch_relations(table_name, element_key, old_element_local_ids, old_document_local_ids)
        relations = [[relation[element_key], relation["document_local_id"]] for relation in relations]

        element_local_ids = self.convert_to_key_dict(new_elements)
        relations = self.convert_keys_to_new(relations, element_local_ids, document_local_ids)

        if len(relations) > 0:
            self.db.insert(sql.SQL(
                f'''
                INSERT INTO {{schema}}.{table_name} (
                    {element_key},
                    document_local_id
                )
                VALUES {{values}}
                '''
            ).format(
                schema=sql.Identifier(self.schema),
                values=self.format_values_for_insert(relations)
            ))

    def create_document_relations(
        self,
        new_documents: Dict[str, DictRow],
        old_spatial_plan_local_id: str,
        new_spatial_plan_local_id: str,
        new_part_eval_plans: Dict[str, DictRow],
        new_splan_commentaries: Dict[str, DictRow],
        new_regulations: Dict[str, DictRow],
        new_guidances: Dict[str, DictRow]
    ) -> None:
        old_document_local_ids = self.format_ids_for_query(new_documents)
        document_local_ids = self.convert_to_key_dict(new_documents)

        spatial_plan_relations = self.db.select(sql.SQL(
            '''
            SELECT
                spatial_plan_local_id,
                document_local_id
            FROM {schema}.spatial_plan_document
            WHERE spatial_plan_local_id = {old_spatial_plan_local_id}
                AND document_local_id IN ({old_document_local_ids});
            ''').format(
                schema=sql.Identifier(self.schema),
                old_spatial_plan_local_id=sql.Literal(old_spatial_plan_local_id),
                old_document_local_ids=old_document_local_ids
            )
        )

        spatial_plan_relations = [[relation["spatial_plan_local_id"], relation["document_local_id"]] for relation in spatial_plan_relations]
        spatial_plan_local_ids = [{"old_key": old_spatial_plan_local_id, "new_key": new_spatial_plan_local_id}]

        spatial_plan_relations = self.convert_keys_to_new(spatial_plan_relations, spatial_plan_local_ids, document_local_ids)

        if len(spatial_plan_relations) > 0:
            self.db.insert(sql.SQL(
                '''
                INSERT INTO {schema}.spatial_plan_document (
                    spatial_plan_local_id,
                    document_local_id
                )
                VALUES {values}
                ''').format(
                    schema=sql.Identifier(self.schema),
                    values=self.format_values_for_insert(spatial_plan_relations)
                )
            )

        relations_data = [
            ('patricipation_evalution_plan_document', 'participation_and_evalution_plan_local_id', new_part_eval_plans),
            ('spatial_plan_commentary_document', 'spatial_plan_commentary_local_id', new_splan_commentaries),
            ('plan_regulation_document', 'plan_regulation_local_id', new_regulations),
            ('plan_guidance_document', 'plan_guidance_local_id', new_guidances)
        ]

        for table_name, element_key, new_elements in relations_data:
            self.insert_document_relations(table_name, element_key, new_elements, old_document_local_ids, document_local_ids)

    def insert_regulation_relations(self, table_name: str, element_key: str, new_elements: Dict[str, DictRow], old_regulation_local_ids: List[str], regulation_local_ids: List[Dict[str, str]]) -> None:

        def fetch_relations(table_name: str, element_key: str, old_element_local_ids: str, old_regulation_local_ids: str):
            return self.db.select(sql.SQL(
                f'''
                SELECT
                    {element_key},
                    plan_regulation_local_id
                FROM {{schema}}.{table_name}
                WHERE {element_key} IN ({{old_element_local_ids}})
                    AND plan_regulation_local_id IN ({{old_regulation_local_ids}});
                '''
            ).format(
                schema=sql.Identifier(self.schema),
                old_element_local_ids=old_element_local_ids,
                old_regulation_local_ids=old_regulation_local_ids
            ))

        old_element_local_ids = self.format_ids_for_query(new_elements)
        relations = fetch_relations(table_name, element_key, old_element_local_ids, old_regulation_local_ids)
        relations = [[relation[element_key], relation["plan_regulation_local_id"]] for relation in relations]

        element_local_ids = self.convert_to_key_dict(new_elements)
        relations = self.convert_keys_to_new(relations, element_local_ids, regulation_local_ids)

        if len(relations) > 0:
            self.db.insert(sql.SQL(
                f'''
                INSERT INTO {{schema}}.{table_name} (
                    {element_key},
                    plan_regulation_local_id
                )
                VALUES {{values}}
                '''
            ).format(
                schema=sql.Identifier(self.schema),
                values=self.format_values_for_insert(relations)
            ))

    def create_regulation_relations(
        self,
        new_regulations: Dict[str, DictRow],
        old_spatial_plan_local_id: str,
        new_spatial_plan_local_id: str,
        new_zoning_elements: Dict[str, DictRow],
        new_planned_spaces: Dict[str, DictRow],
        new_planning_detail_lines: Dict[str, DictRow],
        new_regulation_groups: Dict[str, DictRow]
    ) -> None:
        old_regulation_local_ids = self.format_ids_for_query(new_regulations)
        regulation_local_ids = self.convert_to_key_dict(new_regulations)

        spatial_plan_relations = self.db.select(sql.SQL(
            '''
            SELECT
                spatial_plan_local_id,
                plan_regulation_local_id
            FROM {schema}.spatial_plan_plan_regulation
            WHERE spatial_plan_local_id = {old_spatial_plan_local_id}
                AND plan_regulation_local_id IN ({old_regulation_local_ids});
            ''').format(
                schema=sql.Identifier(self.schema),
                old_spatial_plan_local_id=sql.Literal(old_spatial_plan_local_id),
                old_regulation_local_ids=old_regulation_local_ids
            )
        )

        spatial_plan_relations = [[relation["spatial_plan_local_id"], relation["plan_regulation_local_id"]] for relation in spatial_plan_relations]
        spatial_plan_local_ids = [{"old_key": old_spatial_plan_local_id, "new_key": new_spatial_plan_local_id}]

        spatial_plan_relations = self.convert_keys_to_new(spatial_plan_relations, spatial_plan_local_ids, regulation_local_ids)

        if len(spatial_plan_relations) > 0:
            self.db.insert(sql.SQL(
                '''
                INSERT INTO {schema}.spatial_plan_plan_regulation (
                    spatial_plan_local_id,
                    plan_regulation_local_id
                )
                VALUES {values}
                ''').format(
                    schema=sql.Identifier(self.schema),
                    values=self.format_values_for_insert(spatial_plan_relations)
                )
            )

        relations_data = [
            ('zoning_element_plan_regulation', 'zoning_element_local_id', new_zoning_elements),
            ('planned_space_plan_regulation', 'planned_space_local_id', new_planned_spaces),
            ('planning_detail_line_plan_regulation', 'planning_detail_line_local_id', new_planning_detail_lines),
            ('plan_regulation_group_regulation', 'plan_regulation_group_local_id', new_regulation_groups),
        ]

        for table_name, element_key, new_elements in relations_data:
            self.insert_regulation_relations(table_name, element_key, new_elements, old_regulation_local_ids, regulation_local_ids)

    def create_plan_values(self, plan_items: Dict[str, DictRow], value_type: str, columns: List[str], table_type: ValueTableType) -> Dict[str, DictRow]:
        if not isinstance(table_type, ValueTableType):
            raise ValueError(f"Wrong table type {table_type}. Must be an instance of ValueTableType")

        new_values: Dict[str, DictRow] = {}
        old_values = self.db.select(
            sql.SQL(
                f'''
                SELECT DISTINCT fk_{value_type}
                FROM {{schema}}.{table_type.value}_{value_type}
                WHERE fk_{table_type.value} IN ({{old_item_local_ids}})
                ''').format(
                    schema=sql.Identifier(self.schema),
                    old_item_local_ids=self.format_ids_for_query(plan_items)
            )
        )

        old_values = [item[f"fk_{value_type}"] for item in old_values]

        for value in old_values:
            new_value = self.db.insert_with_return(sql.SQL(
                f'''
                INSERT INTO {{schema}}.{value_type} (
                    {{columns}}
                )
                SELECT
                    {{columns}}
                FROM {{schema}}.{value_type}
                WHERE {value_type}_uuid = {{old_value_uuid}}
                RETURNING *;
                ''').format(
                    schema=sql.Identifier(self.schema),
                    old_value_uuid=sql.Literal(value),
                    columns=sql.SQL(', ').join(sql.Identifier(column) for column in columns)
                )
            )
            new_values[value] = new_value[0]

        plan_values = self.db.select(sql.SQL(
            f'''
            SELECT
                fk_{table_type.value},
                fk_{value_type}
            FROM {{schema}}.{table_type.value}_{value_type}
            WHERE fk_{value_type} IN ({{value_uuids}})
            ''').format(
                schema=sql.Identifier(self.schema),
                value_uuids=self.format_ids_for_query(old_values)
            )
        )

        plan_values = [[d[f"fk_{table_type.value}"], d[f"fk_{value_type}"]] for d in plan_values]
        if (table_type.value == 'supplementary_information'):
            new_item_local_ids = self.convert_to_key_dict(plan_items, 'producer_specific_id')
        else:
            new_item_local_ids = self.convert_to_key_dict(plan_items)
        value_uuids = self.convert_to_key_dict(new_values, f"{value_type}_uuid")

        plan_values = self.convert_keys_to_new(plan_values, new_item_local_ids, value_uuids)

        if len(plan_values) > 0:
            self.db.insert(sql.SQL(
                f'''
                INSERT INTO {{schema}}.{table_type.value}_{value_type} (
                    fk_{table_type.value},
                    fk_{value_type}
                )
                VALUES {{values}}
                ''').format(
                    schema=sql.Identifier(self.schema),
                    values=self.format_values_for_insert(plan_values)
                )
            )

        return new_values


    def create_values(self, new_items: Dict[str, DictRow], table_type: ValueTableType) -> None:
        for value_type in VALUE_TYPE_COLUMNS:
            columns = VALUE_TYPE_COLUMNS[value_type]
            self.create_plan_values(new_items, value_type, columns, table_type)

    def create_supplementary_information(self, regulations: Dict[str, DictRow]):
        old_supplementary_informations = self.db.select(sql.SQL(
            '''
                SELECT
                    producer_specific_id,
                    fk_plan_regulation
                FROM {schema}.supplementary_information
                WHERE fk_plan_regulation IN ({regulation_local_ids})
            ''').format(
                schema=sql.Identifier(self.schema),
                regulation_local_ids=self.format_ids_for_query(regulations)
            ))

        new_supplementary_informations: Dict[str, DictRow] = {}

        for supplementary_information in old_supplementary_informations:
            new_supplementary_information = self.db.insert_with_return(sql.SQL(
                '''
                INSERT INTO {schema}.supplementary_information (
                    type,
                    name,
                    fk_plan_regulation
                )
                SELECT
                    type,
                    name,
                    {regulation_local_id}
                FROM {schema}.supplementary_information
                WHERE producer_specific_id = {producer_specific_id}
                RETURNING *
                ''').format(
                    schema=sql.Identifier(self.schema),
                    regulation_local_id=sql.Literal(regulations[supplementary_information["fk_plan_regulation"]]["local_id"]),
                    producer_specific_id=sql.Literal(supplementary_information["producer_specific_id"])
                )
            )
            new_supplementary_informations[supplementary_information["producer_specific_id"]] = new_supplementary_information[0]

        self.create_values(new_supplementary_informations, ValueTableType.SUPPLEMENTARY_INFORMATION)

        return new_supplementary_informations



    def create_plan_guidances(self, old_splan_local_id: str):
        old_plan_guidances = self.db.select(sql.SQL(
            '''
            SELECT {schema}.get_plan_guidance_local_ids({old_spatial_plan_local_id}) AS local_id
            ''').format(
                schema=sql.Identifier(self.schema),
                old_spatial_plan_local_id=sql.Literal(old_splan_local_id)
            )
        )

        old_plan_guidances = [item["local_id"] for item in old_plan_guidances]

        new_plan_guidances: Dict[str, DictRow] = {}

        for plan_guidance in old_plan_guidances:
            new_plan_guidance = self.db.insert_with_return(sql.SQL(
                '''
                INSERT INTO {schema}.plan_guidance (
                    local_id,
                    identity_id,
                    namespace,
                    name,
                    life_cycle_status,
                    valid_from,
                    valid_to
                )
                SELECT
                    CONCAT(identity_id, '.', uuid_generate_v4()::text),
                    identity_id,
                    namespace,
                    name,
                    life_cycle_status,
                    valid_from,
                    valid_to
                FROM {schema}.plan_guidance
                WHERE local_id = {old_plan_guidance_local_id}
                RETURNING *;
                ''').format(
                    schema=sql.Identifier(self.schema),
                    old_plan_guidance_local_id=sql.Literal(plan_guidance)
                )
            )
            new_plan_guidances[plan_guidance] = new_plan_guidance[0]

        self.create_values(new_plan_guidances, ValueTableType.PLAN_GUIDANCE)

        # Duplicate plan_guidance_themes
        for old_guidance_local_id in new_plan_guidances:
            self.db.insert(sql.SQL(
                '''
                INSERT INTO {schema}.plan_guidance_theme (
                    plan_guidance_local_id,
                    theme_code
                )
                SELECT
                    {new_guidance_local_id},
                    theme_code
                FROM {schema}.plan_regulation_theme
                WHERE plan_regulation_local_id = {old_guidance_local_id};
                ''').format(
                    schema=sql.Identifier(self.schema),
                    old_guidance_local_id=sql.Literal(old_guidance_local_id),
                    new_guidance_local_id=sql.Literal(new_plan_guidances[old_guidance_local_id]["local_id"])
            ))

        return new_plan_guidances



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
                zoning_element_local_ids=self.format_ids_for_query(old_zoning_elements)
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
                planned_space_local_ids=self.format_ids_for_query(old_planned_spaces),
            )
        )

        zoning_element_planned_spaces = [[d["zoning_element_local_id"], d["planned_space_local_id"]] for d in zoning_element_planned_spaces]
        new_zoning_elements_local_ids = self.convert_to_key_dict(zoning_elements)
        planned_space_local_ids = self.convert_to_key_dict(new_planned_spaces)

        zoning_element_planned_spaces = self.convert_keys_to_new(zoning_element_planned_spaces, new_zoning_elements_local_ids, planned_space_local_ids)

        if len(zoning_element_planned_spaces) > 0:
            self.db.insert(sql.SQL(
                '''
                INSERT INTO {schema}.zoning_element_planned_space (
                    zoning_element_local_id,
                    planned_space_local_id)
                VALUES {values}
                ''').format(
                    schema=sql.Identifier(self.schema),
                    values = self.format_values_for_insert(zoning_element_planned_spaces)
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
                zoning_element_local_ids=self.format_ids_for_query(old_zoning_elements)
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
                planning_detail_line_local_ids=self.format_ids_for_query(old_planning_detail_lines),
            )
        )

        zoning_element_planning_detail_lines = [[d["zoning_element_local_id"], d["planning_detail_line_local_id"]] for d in zoning_element_planning_detail_lines]
        new_zoning_elements_local_ids = self.convert_to_key_dict(zoning_elements)
        planning_detail_line_local_ids = self.convert_to_key_dict(new_planning_detail_lines)

        zoning_element_planning_detail_lines = self.convert_keys_to_new(zoning_element_planning_detail_lines, new_zoning_elements_local_ids, planning_detail_line_local_ids)

        if len(zoning_element_planning_detail_lines) > 0:
            self.db.insert(sql.SQL(
                '''
                INSERT INTO {schema}.zoning_element_plan_detail_line (
                    zoning_element_local_id,
                    planning_detail_line_local_id)
                VALUES {values}
                ''').format(
                    schema=sql.Identifier(self.schema),
                    values = self.format_values_for_insert(zoning_element_planning_detail_lines)
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
                planning_detail_line_local_ids=self.format_ids_for_query(old_planning_detail_lines),
            )
        )

        planned_space_planning_detail_lines = [[d["planned_space_local_id"], d["planning_detail_line_local_id"]] for d in planned_space_planning_detail_lines]
        new_planned_space_local_ids = self.convert_to_key_dict(planned_spaces)

        planned_space_planning_detail_lines = self.convert_keys_to_new(planned_space_planning_detail_lines, new_planned_space_local_ids, planning_detail_line_local_ids)

        if len(planned_space_planning_detail_lines) > 0:
            self.db.insert(sql.SQL(
                '''
                INSERT INTO {schema}.planned_space_plan_detail_line (
                    planned_space_local_id,
                    planning_detail_line_local_id)
                VALUES {values}
                ''').format(
                    schema=sql.Identifier(self.schema),
                    values = self.format_values_for_insert(planned_space_planning_detail_lines)
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
                zoning_element_local_ids=self.format_ids_for_query(old_zoning_elements)
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
                describing_line_ids=self.format_ids_for_query(old_describing_lines)
            )
        )

        zoning_element_describing_lines = [[d["zoning_element_local_id"], d["describing_line_id"]] for d in zoning_element_describing_lines]
        new_zoning_elements_local_ids = self.convert_to_key_dict(zoning_elements)
        describing_line_ids = self.convert_to_key_dict(new_describing_lines)

        zoning_element_describing_lines = self.convert_keys_to_new(zoning_element_describing_lines, new_zoning_elements_local_ids, describing_line_ids)

        if len(zoning_element_describing_lines) > 0:
            self.db.insert(sql.SQL(
                '''
                INSERT INTO {schema}.zoning_element_describing_line (
                    zoning_element_local_id,
                    describing_line_id)
                Values {values}
                ''').format(
                    schema=sql.Identifier(self.schema),
                    values = self.format_values_for_insert(zoning_element_describing_lines)
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
                zoning_element_local_ids=self.format_ids_for_query(old_zoning_elements)
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
                describing_text_ids=self.format_ids_for_query(old_describing_texts)
            )
        )

        zoning_element_describing_texts = [[d["zoning_element_local_id"], d["describing_text_id"]] for d in zoning_element_describing_texts]
        new_zoning_elements_local_ids = self.convert_to_key_dict(zoning_elements)
        describing_text_ids = self.convert_to_key_dict(new_describing_texts)

        zoning_element_describing_texts = self.convert_keys_to_new(zoning_element_describing_texts, new_zoning_elements_local_ids, describing_text_ids)

        if len(zoning_element_describing_texts) > 0:
            self.db.insert(sql.SQL(
                '''
                INSERT INTO {schema}.zoning_element_describing_text (
                    zoning_element_local_id,
                    describing_text_id)
                Values {values}
                ''').format(
                    schema=sql.Identifier(self.schema),
                    values = self.format_values_for_insert(zoning_element_describing_texts)
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
            new_key = value[key_name] if key_name is not None else (value.get("local_id") or value["identifier"])
            result.append({"old_key": old_key, "new_key": new_key})
        return result

    @staticmethod
    def format_ids_for_query(elements: Dict[str, DictRow]):
        return (
            sql.SQL(', ').join(sql.Literal(element) for element in elements)
            if elements
            else sql.SQL('NULL')
        )

    @staticmethod
    def format_values_for_insert(value_list_list: List[List[str]]):
        return sql.SQL(', ').join(
        sql.SQL('({})').format(sql.SQL(', ').join(sql.Literal(value) for value in value_list))
        for value_list in value_list_list
    )
