from typing import Tuple

from PyQt5.QtCore import QSettings, QCoreApplication
from qgis.core import QgsAuthMethodConfig, QgsProject

from .database import Database
from ..constants import *


def get_database_connections() -> set:
    """Returns names of all PostGis connections saved to QGis

    :return: set
    """
    s = QSettings()
    s.beginGroup(PG_CONNECTIONS)
    keys = s.allKeys()
    s.endGroup()
    return {key.split('/')[0] for key in keys if '/' in key}


def get_new_schema_name(municipality: str, projection: str, is_combination: bool) -> str:
    """Return name for the schema in the right format

    :param municipality: str
    :param projection: str e.g. ESPG:3875
    :param is_combination: bool
    :return: str
    """
    schema_name = municipality.lower() + '_' + projection[5:].lower()
    if is_combination:
        return (schema_name + '_y').lower()
    else:
        return schema_name.lower()


def set_connection(db_name: str) -> None:
    """ Sets connection as database name to QSettings

    :param db_name: str
    :return: None
    """
    QSettings().setValue('connection', db_name)


def get_connection_name() -> str:
    """Return the name of used database

    :return: str
    """
    return QSettings().value('connection', "", str)


def get_connection_params(qgs_app: QCoreApplication) -> dict:
    """Returns database connection parameters

    :param qgs_app
    :return: dict
    """
    from ..data.tools import parse_value
    s = QSettings()
    s.beginGroup(f"{PG_CONNECTIONS}/{get_connection_name()}")
    auth_cfg_id = parse_value(s.value("authcfg"))
    username_saved = parse_value(s.value("saveUsername"))
    password_saved = parse_value(s.value("savePassword"))

    params = {"authcfg": auth_cfg_id}

    for qgs_key, psyc_key in QGS_SETTINGS_PSYCOPG2_PARAM_MAP.items():
        params[psyc_key] = parse_value(s.value(qgs_key))

    s.endGroup()

    if not username_saved:
        params["user"] = None
    if not password_saved:
        params["password"] = None

    if auth_cfg_id is not None and auth_cfg_id != "":
        auth_config = QgsAuthMethodConfig()
        qgs_app.authManager().loadAuthenticationConfig(auth_cfg_id, auth_config, True)

        if auth_config.isValid():
            params["user"] = auth_config.configMap().get("username")
            params["password"] = auth_config.configMap().get("password")
        else:
            # TODO
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
