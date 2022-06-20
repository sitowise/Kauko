from qgis.core import QgsProject, QgsDataSourceUri

from ..data.tools import parse_layer_source
from ..database.db_tools import get_active_db_and_schema


def create_project(file: str):
    project = QgsProject().instance()
    project.write(file)


def set_connection(host: str, port: str, db: str, username: str, password: str) -> QgsDataSourceUri:
    uri = QgsDataSourceUri()
    uri.setParam('host', host)
    uri.setParam('port', port)
    uri.setDatabase(db)
    uri.setUsername(username)
    uri.setParam('password', password)
    return uri


def set_new_layer_sources(file: str, host: str, port: str, username: str, password: str):
    db, _ = get_active_db_and_schema()
    create_project(file)
    uri = set_connection(host, port, db, username, password)
    layers = QgsProject().instance().mapLayers().values()
    for layer in layers:
        params = parse_layer_source(layer.source())
        uri.setDataSource(params["schema"], params["table"], params["geom"], None, params["key"])
        layer.setDataSource(uri.uri(False), layer.name(), 'postgres')
