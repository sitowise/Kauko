from typing import Any, Dict, List, Set, Tuple

from qgis.PyQt.QtCore import QSettings, QCoreApplication
from qgis.core import QgsAuthMethodConfig, QgsProject

from .database import Database
from ..constants import *


def get_database_connections() -> Set[Tuple]:
    """Returns names of all PostGis connections and their databases saved to QGis

    :return: set[Tuple]
    """
    s = QSettings()
    s.beginGroup(PG_CONNECTIONS)
    connections = s.childGroups()
    tuples = set()
    for connection in connections:
        s.beginGroup(connection)
        tuples.add((connection, s.value("database")))
        s.endGroup()
    s.endGroup()
    return tuples


def get_new_schema_name(municipality: str, projection: str, is_master_plan: bool) -> str:
    """Return name for the schema in the right format

    :param municipality: str
    :param projection: str e.g. ESPG:3875
    :param is_combination: bool
    :return: str
    """
    schema_name = f'{municipality.lower()}_{projection[5:].lower()}'
    return f'{schema_name}_y'.lower() if is_master_plan else schema_name.lower()


def set_connection(db_name: str) -> None:
    """ Sets connection based on used database name

    :param db_name: str
    :return: None
    """
    # We have to find the connection with the right database name.
    # TODO: If there are several connections with a database of the same name,
    # then we're out of luck. There's no way to find out the right
    # connection and auth settings based on database name alone :(
    s = QSettings()
    s.beginGroup(PG_CONNECTIONS)
    for connection in s.childGroups():
        s.beginGroup(f"{PG_CONNECTIONS}/{connection}")
        database = s.value("database")
        s.endGroup()
        if database == db_name:
            # found the connection with the right database
            break
    QSettings().setValue("connection", connection)


def get_connection_name() -> str:
    """Return the name of used connection

    :return: str
    """
    return QSettings().value('connection', "", str)


def get_connection_params(qgs_app: QCoreApplication) -> Dict[str, Any]:
    """Get database connection parameters from QGIS settings.

    Args:
        qgs_app (QCoreApplication): A QCoreApplication instance.

    Returns:
        Dict[str, Any]: A dictionary of connection parameters.
    """
    from ..data.tools import parse_value

    # Read connection parameters from QGIS settings
    s = QSettings()
    s.beginGroup(f"{PG_CONNECTIONS}/{get_connection_name()}")
    auth_cfg_id = parse_value(s.value("authcfg"))
    username_saved = parse_value(s.value("saveUsername"))
    password_saved = parse_value(s.value("savePassword"))

    params = {"authcfg": auth_cfg_id}
    for qgs_key, psyc_key in QGS_SETTINGS_PSYCOPG2_PARAM_MAP.items():
        params[psyc_key] = parse_value(s.value(qgs_key))
    s.endGroup()

    # Clear username and password if not saved in settings
    if not username_saved:
        params["user"] = None
    if not password_saved:
        params["password"] = None

    # Check if an authcfg ID is specified and get username and password from auth config if valid
    if auth_cfg_id:
        auth_config = QgsAuthMethodConfig()
        qgs_app.authManager().loadAuthenticationConfig(auth_cfg_id, auth_config, True)
        if auth_config.isValid():
            params["user"] = auth_config.configMap().get("username")
            params["password"] = auth_config.configMap().get("password")
        else:
            # TODO: Handle invalid auth config
            pass

    return params


def get_active_db_and_schema() -> Tuple[str, str]:
    """Get database and schema name for current project

    :return: database name, schema name
    """
    path = QgsProject().instance().fileName()

    if len(path) <= 0:
        return "", ""

    start = path.find("dbname=")
    start += len("dbname=")
    end = path.find('&', start)
    dbname = path[start:end] if end != -1 else path[start:]
    start = path.find("project=")
    start += len("project=")
    end = path.find('&', start)
    schema = path[start:end] if end != -1 else path[start:]
    return dbname, schema


def get_all_project_schemas(db: Database) -> list:
    """Get the name of schemas which contain project

    :param db: Database object
    :return: list of schema names
    """
    schemas = []
    query = "SELECT schema_name FROM information_schema.schemata ORDER BY schema_name"
    raw_schemas = db.select(query)
    for schema in raw_schemas:
        schema = ''.join(schema)
        if "_gk" in schema or "_kkj" in schema:
            schemas.append(schema)
    return schemas


def get_table_columns(table: str, db: Database, schema: str = None) -> List[str]:
    """Get all column names of the specified table

    :param table: Table name
    :param db: Database object
    :param schema: Schema
    :return: List of column names
    """
    query = f"SELECT column_name FROM information_schema.columns WHERE table_schema='{schema}' AND table_name='{table}';"
    rows = db.select(query)
    return [row[0] for row in rows]
