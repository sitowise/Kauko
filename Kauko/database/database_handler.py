from typing import List

import psycopg2
from qgis.core import (Qgis, QgsExpressionContextUtils,
                       QgsProject)
from qgis.PyQt.QtWidgets import QMessageBox
from qgis.utils import iface

from ..constants import (ADD_GEOM_CHECK_SQL, DROP_GEOM_CHECK_SQL,
                         REFRESH_MATERIALIZED_VIEWS)
from ..data.schema import PlanType, Schema
from ..data.tools import parse_filter_ids, parse_value, save_alert_msg
from ..database.database import Database
from ..database.db_tools import (get_active_db_and_schema)
from ..database.project_updater.project_updater import ProjectUpdater
from ..database.query_builder import get_query
from ..errors import SchemaError


def create_new_schema_and_project(
    projection: str,
    municipality: str,
    db: Database,
    create_detailed_plan: bool = False,
    create_master_plan: bool = False) -> None:
    """Creates new schema to initialized database with parameters given in the dialog"""
    if not create_detailed_plan and not create_master_plan:
        iface.messageBar().pushMessage("Virhe!", "Yhtäkään kaavatyyppiä ei ole valittu.",
                                       level=Qgis.Warning,
                                       duration=5)
        return

    project = QgsProject().instance()

    if project.isDirty():
        is_saved = save_alert_msg()
        if is_saved == QMessageBox.Save:
            if not project.write():
                iface.messageBar().pushMessage(
                    "Virhe!", f"Työtilan {project.baseName()}  tallennus epäonnistui.",
                    level=Qgis.Critical,
                    duration=5)
                return
        elif is_saved == QMessageBox.Cancel:
            return

    schemas = []
    if create_detailed_plan:
        schemas.append(
            Schema(
                municipality_name=municipality,
                plan_type=PlanType.detailed_plan,
                projection=projection)
            )
    if create_master_plan:
        schemas.append(
            Schema(
                municipality_name=municipality,
                plan_type=PlanType.master_plan,
                projection=projection)
        )

    project_updater = ProjectUpdater(db, schemas)
    try:
        project_updater.execute()
    except psycopg2.errors.DuplicateSchema:
        iface.messageBar().pushMessage("Virhe!",
                                       "Työtila on jo luotu tietokantaan",
                                       level=Qgis.Warning)
    except psycopg2.errors.InsufficientPrivilege:
        iface.messageBar().pushMessage("Virhe!", "Sinulla ei ole riittäviä "
                                                 "oikeuksia tähän operaatioon. Ota "
                                                 "yhteys järjestelmän ylläpitäjään.",
                                       level=Qgis.Critical, duration=5)

def delete_schema_and_project(db: Database, project_name=None) -> bool:
    """

    :param db: Database object of the database containing the project schema
    :param project_name: Name of the project
    :return: bool true if successful
    """
    if not project_name:
        iface.messageBar().pushMessage("Virhe!", "Projektia ei ole valittu",
                                       level=Qgis.Warning, duration=5)

    msg = QMessageBox()
    msg.setText(f"Haluatko varmasti poistaa työtilan {project_name}?")
    msg.setIcon(QMessageBox.Warning)
    msg.setStandardButtons(QMessageBox.Yes | QMessageBox.No)
    is_deleted = msg.exec_()

    if is_deleted != QMessageBox.Yes:
        return False

    project_query = (
        f"DELETE FROM public.qgis_projects WHERE name LIKE '{project_name}';"
    )
    schema_query = f"DROP SCHEMA {project_name} CASCADE;"
    information_query = (
        f"DELETE FROM public.schema_information WHERE name LIKE '{project_name}';"
    )
    query = project_query + schema_query + information_query
    try:
        db.insert(query)
    except psycopg2.errors.InvalidSchemaName:
        iface.messageBar().pushMessage("Virhe!",
                                        "Projektin nimi on virheellinen",
                                        level=Qgis.Critical,
                                        duration=5)
        return False
    except psycopg2.errors.InsufficientPrivilege:
        iface.messageBar().pushMessage("Virhe!",
                                        "Sinulla ei ole riittäviä oikeuksia tähän operaatioon. Ota "
                                        "yhteyttä ylläpitäjään.",
                                        level=Qgis.Critical, duration=5)
        return False
    iface.messageBar().pushMessage(f"Työtila {project_name} on poistettu onnistuneesti.", level=Qgis.Success, duration=5)

    return True


def add_geom_checks(schema, db):
    if schema[-1] == 'y':
        for query in ADD_GEOM_CHECK_SQL:
            try:
                query = query.replace("schemaname", schema)
                db.insert(query)
            except psycopg2.errors.DuplicateObject:
                pass
            except psycopg2.errors.InvalidSchemaName:
                return False
        return True
    else:
        iface.messageBar().pushMessage("Virhe!",
                                       "Työtila ei ole asemakaavayhdistelmä",
                                       level=Qgis.Warning, duration=5)
        return False


def drop_geom_checks(schema, db):
    for query in DROP_GEOM_CHECK_SQL:
        try:
            query = query.replace("schemaname", schema)
            db.insert(query)
        except psycopg2.errors.UndefinedObject:
            pass
        except psycopg2.errors.InvalidSchemaName:
            return False
    return True


def get_projects(db: Database, only_web=False) -> List[str]:
    projects = []
    query = "SELECT name FROM public.qgis_projects WHERE name LIKE '%web' ORDER BY name;" if only_web else "SELECT name FROM public.qgis_projects ORDER BY name;"
    try:
        raw_projects = db.select(query)
        for project in raw_projects:
            project = ''.join(project)
            projects.append(project)
        return projects
    except psycopg2.errors.UndefinedTable:
        return []


def get_spatial_plan_names(db: Database, schema=None) -> list:
    if schema == "":
        return
    try:
        names = []
        query = f"Select {schema}.spatial_plan.name FROM {schema}.spatial_plan ORDER BY name"
        raw_names = db.select(query)
        for name in raw_names:
            name = name[0]
            name = ' - '.join(name.values())
            names.append(name)
        return names
    except psycopg2.errors.UndefinedColumn:
        iface.messageBar().pushMessage("Virhe!",
                                       f"Skeemassa {schema} ei ole saraketta 'nimi'",
                                       level=Qgis.Warning, duration=5)

    except psycopg2.errors.UndefinedTable:
        iface.messageBar().pushMessage("Virhe!",
                                       f"Skeemaa {schema} ei löytynyt tietokannasta {db.get_database_name()}.",
                                       level=Qgis.Warning, duration=5)


def get_identifiers_for_plan(project: QgsProject, plan_name: str, db: Database,
                             schema: str = None) -> dict:
    if not schema:
        _, schema = get_active_db_and_schema()

    expression_context = QgsExpressionContextUtils()
    project_name = expression_context.projectScope(
        project).variable('project_basename')

    if project_name != schema:
        raise SchemaError()

    query = f"SELECT * FROM {schema}.all_spatial_plan_items WHERE \"Kaavan nimi\" = '{plan_name}'"
    raw_results = db.select(query)
    results = {
        "Kaava": [],
        "Kaavan laatija": [],
        "Kaavan tavoite": [],
        "Kaavan liite": [],
        "Kaavamääräys": [],
        "Maankäyttöalue": [],
        "Numeerinen arvo": [],
        "Kaavan osa-alue": [],
        "Viivamainen tarkennemerkintä": [],
        "Pistemäinen tarkennemerkintä": [],
        "Selittävä teksti": [],
        "Selittävä viiva": []
    }

    for row in raw_results:
        _extracted_from_get_identifiers_for_plan_31(results, row)
    # Delete duplicate items
    for key in results:
        new_list = list(dict.fromkeys(results[key]))
        results[key] = new_list

    parse_filter_ids(results)

    return results

def _extracted_from_get_identifiers_for_plan_31(results, row):
    results["Kaava"].append(row[1])
    results["Kaavan laatija"].append(row[2])
    results["Kaavan tavoite"].append(row[3])
    results["Kaavan liite"].append(row[4])
    results["Maankäyttöalue"].append(row[6])
    results["Kaavan osa-alue"].append(row[9])
    results["Viivamainen tarkennemerkintä"].append(row[12])
    results["Pistemäinen tarkennemerkintä"].append(row[14])
    results["Selittävä teksti"].append(row[16])
    results["Selittävä viiva"].append(row[17])
    results["Kaavamääräys"].extend([row[5], row[8], row[10]])
    results["Numeerinen arvo"].extend([row[7], row[11], row[13], row[15]])


def get_regulations(db: Database, view: str, spatial_plan_name: str,
                    columns=None, schema=None) -> list:
    """Fetches regulations from database for spatial plan

    :param db:
    :param spatial_plan_name:
    :param view: Name of database view as string for regulations
    :param columns: List of the columns for query
    :param schema: Name of the schema as string where project locates
    :return: List containing tuples of query results
    """
    if columns is None:
        columns = ["*"]
    if schema is None:
        iface.messageBar().pushMessage("Virhe", "Työtilaa ei ole annettu",
                                       level=Qgis.Critical, duration=5)

    query = "Select" + ", ".join(
        columns) + " From " + schema + "." + view + " Where \"Kaavan nimi\" = '" + \
            spatial_plan_name + "'"
    return db.select(query)


def move_plan_to_combination(db, schema, plan_name):
    query = f"SELECT planning_object_identifier from {schema}.spatial_plan WHERE name = '{plan_name}'"
    spatial_plan = db.select(query)[0][0]
    results = {
        "spatial_plan": [],
        "contact": [],
        "localized_objective": [],
        "referenced_document": [],
        "regulative_text": [],
        "zoning_element": [],
        "numeric_value": [],
        "planned_space": [],
        "planning_detail_line": [],
        "planning_detail_point": [],
        "describing_text": [],
        "describing_line": []
    }
    query = get_query(schema, "sql_scripts/plan_to_move_ids.sql",
                      plan_name=plan_name)
    raw_results = db.select(query)
    if len(raw_results) > 0:
        for row in raw_results:
            _extracted_from_move_plan_to_combination_24(results, spatial_plan, row)
    else:
        results["spatial_plan"].append(spatial_plan)

    for key in results:
        new_list = list(dict.fromkeys(results[key]))
        results[key] = new_list

    parse_filter_ids(results)

    query = get_query(schema, "sql_scripts/move_plan.sql", layers=results)
    db.insert(query)

def _extracted_from_move_plan_to_combination_24(results, spatial_plan, row):
    results["spatial_plan"].append(spatial_plan)
    results["contact"].append(row[0])
    results["localized_objective"].append(row[1])
    results["referenced_document"].append(row[2])
    results["regulative_text"].append(row[3])
    results["zoning_element"].append(row[4])
    results["numeric_value"].append(row[5])
    results["regulative_text"].append(row[6])
    results["planned_space"].append(row[7])
    results["regulative_text"].append(row[8])
    results["numeric_value"].append(row[9])
    results["planning_detail_line"].append(row[10])
    results["numeric_value"].append(row[11])
    results["planning_detail_point"].append(row[12])
    results["numeric_value"].append(row[13])
    results["describing_text"].append(row[14])
    results["describing_line"].append(row[15])


def change_validity_to_unfinshed(db: Database, schema: str, plan_name: str):
    query = get_query(schema, "/sql_scripts/change_to_unfinished.sql")
    db.insert(query)


def update_materialized_views(db, schemas: list):
    if not schemas:
        return
    for schema in schemas:
        query = get_query(schema, REFRESH_MATERIALIZED_VIEWS)
        db.insert(query)

def create_schema_objects(db: Database, projects: List[str]) -> List[Schema]:
    projects_list =", ".join([f"'{project}'" for project in projects])
    query = (
        f"SELECT name, srid, municipality, is_master_plan\n"
        f"FROM public.schema_information\n"
        f"WHERE name in ({projects_list})"
    )
    result = db.select(query)
    schemas = []
    for row in result:
        srid, municipality, is_master_plan = row[1:]
        plan_type: PlanType = PlanType.master_plan if parse_value(is_master_plan) else PlanType.detailed_plan

        schema = Schema(
            municipality_code=parse_value(municipality),
            plan_type=plan_type,
            srid=parse_value(srid)
        )

        schemas.append(schema)
    return schemas
