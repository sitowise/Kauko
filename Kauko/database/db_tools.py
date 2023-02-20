from typing import Any, Dict, Set, Tuple
from urllib.parse import parse_qs, urlparse

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


def set_connection(connection_name: str) -> None:
    """ Sets connection based on used database name

    :param connnection_name: str
    :return: None
    """
    QSettings().setValue("connection", connection_name)


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
    
    parsed_path = urlparse(path)
    params = parse_qs(parsed_path.query)
    dbname = params.get("dbname", [""])[0]
    project = params.get("project", [""])[0]
    return dbname, project

def get_all_project_schemas(db: Database) -> list:
    """Get the names of schemas containing project in their names.

    :param db: A Database object to connect to the database.
    :return: A list of schema names.
    """
    query = "SELECT schema_name FROM information_schema.schemata WHERE schema_name LIKE '%\_gk%' OR schema_name LIKE '%\_kkj%' ORDER BY schema_name"
    result_set = db.select(query)
    schemas = [schema[0] for schema in result_set]
    return schemas

