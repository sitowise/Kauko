from typing import List
import psycopg2
from PyQt5.QtWidgets import QMessageBox
from qgis.core import QgsProject, Qgis, QgsApplication, \
    QgsExpressionContextUtils
from qgis.utils import iface

from ..database.project_updater.project_updater import ProjectUpdater
from ..data.schema import Schema
from ..errors import SchemaError
from ..constants import ADD_GEOM_CHECK_SQL, \
    DROP_GEOM_CHECK_SQL, REFRESH_MATERIALIZED_VIEWS
from ..data.csv_handler import get_csv_code
from ..data.tools import parse_value, save_alert_msg, parse_filter_ids
from ..database.database import Database
from ..database.db_tools import get_new_schema_name, get_connection_params, \
    get_active_db_and_schema
from ..database.query_builder import get_query



def create_new_schema_and_project(projection, municipality, db) -> None:
    """Creates new schema to initialized database with parameters given in the dialog"""
    project = QgsProject().instance()

    if project.isDirty():
        is_saved = save_alert_msg()
        if is_saved == QMessageBox.Save:
            if not project.write():
                iface.messageBar().pushMessage("Virhe!", "Työtilan " +
                                               project.baseName() +
                                               " tallennus epäonnistui.",
                                               level=Qgis.Critical,
                                               duration=5)
                return
        elif is_saved == QMessageBox.Cancel:
            return

    srid = str(get_csv_code('/finnish_projections.csv', projection))
    municipality_code = str(
        get_csv_code('/municipality_codes.csv', municipality))

    schemas = [
        Schema(
            get_new_schema_name(municipality, projection, True),
            srid,
            municipality_code,
            True,
        ),
        Schema(
            get_new_schema_name(municipality, projection, False),
            srid,
            municipality_code,
            False)
    ]

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
    if project_name[-1] == 'y':
        combination_project_name = project_name
        project_name = project_name[0:-2]
    else:
        combination_project_name = project_name + "_y"
    msg = QMessageBox()
    msg.setText(
        "Haluatko varmasti poistaa työtilat " + project_name + " ja " + combination_project_name + "?")
    msg.setIcon(QMessageBox.Warning)
    msg.setStandardButtons(QMessageBox.Yes | QMessageBox.No)
    is_deleted = msg.exec_()
    if is_deleted != QMessageBox.Yes:
        return False

    for name in [project_name, combination_project_name]:
        project_query = "DELETE FROM public.qgis_projects WHERE name LIKE '" + \
                        name + "'"
        schema_query = "DROP SCHEMA " + name + " CASCADE"
        information_query = "DELETE FROM public.schema_information WHERE name LIKE '" + name + "'"
        try:
            db.insert(project_query)
            db.insert(information_query)
            try:
                db.insert(schema_query)
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
    iface.messageBar().pushMessage(
        "Työtilat " + project_name + " ja " + combination_project_name +
        " poistettu onnistuneesti.", level=Qgis.Success, duration=5)
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


def get_projects(db, only_web=False) -> list:
    projects = []
    if not only_web:
        query = "SELECT name FROM public.qgis_projects ORDER BY name;"
    else:
        query = "SELECT name FROM public.qgis_projects " \
                "WHERE name LIKE '%web' ORDER BY name;"
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
        query = "Select " + schema + ".spatial_plan.name From " + schema + \
                ".spatial_plan ORDER BY name"
        raw_names = db.select(query)
        for name in raw_names:
            name = ''.join(name)
            names.append(name)
        return names
    except psycopg2.errors.UndefinedColumn:
        iface.messageBar().pushMessage("Virhe!", "Skeemassa " + schema +
                                       " ei ole saraketta 'nimi'",
                                       level=Qgis.Warning,
                                       duration=5)
    except psycopg2.errors.UndefinedTable:
        iface.messageBar().pushMessage("Virhe!",
                                       "Skeemaa " + schema + " ei löytynyt tietokannasta " +
                                       db.get_database_name() + ".",
                                       level=Qgis.Warning,
                                       duration=5)


def get_identifiers_for_plan(project: QgsProject, plan_name: str, db: Database,
                             schema: str = None) -> dict:
    if not schema:
        _, schema = get_active_db_and_schema()

    expression_context = QgsExpressionContextUtils()
    project_name = expression_context.projectScope(
        project).variable('project_basename')

    if project_name != schema:
        raise SchemaError()

    query = "SELECT * FROM " + schema + ".all_spatial_plan_items Where \"Kaavan nimi\" = '" + plan_name + "'"
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
    query = "SELECT planning_object_identifier from " + schema + \
            ".spatial_plan WHERE name = '" + plan_name + "'"
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
    projects_list = "("
    is_first = True
    for project in projects:
        if is_first:
            projects_list += "'" + project + "'"
            is_first = False
        else:
            projects_list += ", '" + project + "'"
    projects_list += ")"
    query = "SELECT name, srid, municipality, combination\n" \
            "FROM public.schema_information\n" \
            "WHERE name in " + projects_list
    result = db.select(query)
    schemas = []
    for row in result:
        schema = Schema(
            parse_value(row[0]),
            parse_value(row[1]),
            parse_value(row[2]),
            parse_value(row[3])
            )
        schemas.append(schema)
    return schemas
