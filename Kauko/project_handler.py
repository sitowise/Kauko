from datetime import datetime
import os
import binascii
import io
import zipfile
from zipfile import ZipFile

from qgis.PyQt.QtWidgets import QMessageBox
from qgis.core import QgsProject, QgsApplication, QgsMessageLog, Qgis


from .data.csv_handler import format_spatial_ref
from .constants import PROJECT_TEMPLATE_FOLDER
from .data.tools import save_alert_msg
from .database.database import Database
from .database.db_tools import get_connection_params


def create_project_file(project_name: str, srid, template: str):
    with open(os.path.dirname(os.path.abspath(__file__)) + PROJECT_TEMPLATE_FOLDER + template, 'r', encoding='utf-8') as f:
        template_file = f.read()
    project = format_project(template_file, project_name, srid)
    files = {
        'file.qgs': project.encode(),
        'file.qgd': ''.encode()
    }
    new_zip = io.BytesIO()
    with ZipFile(new_zip, "a", zipfile.ZIP_DEFLATED, False) as zip_file:
        for file_name, data in files.items():
            zip_file.writestr(file_name, io.BytesIO(data).getvalue())
    return binascii.hexlify(new_zip.getvalue())


def create_or_update_project(
    db: Database,
    project_name: str,
    srid: str,
    template: str,
    open_after_create: bool = True,
    is_new: bool = True,
) -> bool:
    is_succeed = False
    project = create_project_file(project_name, srid, template)
    now = datetime.now()
    date_str = now.strftime("%Y-%m-%d %H:%M:%S.%f")
    metadata = '{"last_modified_time": "' + date_str + '", "last_modified_user": "dev_admin"}'
    if is_new:
        query = (
            "INSERT INTO public.qgis_projects (name,metadata,content) "
            f"VALUES ('{project_name}', '{metadata}', decode('{project.decode('utf-8')}', 'hex'));"
        )
    else:
        query = (
            "UPDATE public.qgis_projects "
            f"SET metadata = '{metadata}', content = decode('{project.decode('utf-8')}', 'hex') "
            f"WHERE name = '{project_name}';"
        )
    query += (
        f"UPDATE public.schema_information SET project_version = '{template[:template.index('_')]}' "
        f"WHERE name = '{project_name}';"
    )
    if db.insert(query):
        is_succeed = True
    if open_after_create:
        open_project(project_name)
    return is_succeed


def format_project(proj_file, project_name, srid):
    conn_params = get_connection_params(QgsApplication.instance())
    spatialref = format_spatial_ref(srid)
    proj_file = proj_file.replace("SPATIALREFSYS", spatialref)
    proj_file = proj_file.replace("SCHEMANAME", project_name)
    proj_file = proj_file.replace("PROJECTSRID", srid)
    proj_file = proj_file.replace("AUTHID", "EPSG:" + srid)
    proj_file = proj_file.replace("DATABASE", conn_params["dbname"])
    proj_file = proj_file.replace("HOST", conn_params["host"])
    proj_file = proj_file.replace("AUTHCFG", conn_params["authcfg"])
    return proj_file


def open_project(project_name=None):
    project = QgsProject().instance()
    if project.isDirty():
        is_saved = save_alert_msg()
        if is_saved == QMessageBox.Save:
            project.write()
        if is_saved == QMessageBox.Cancel:
            return
    if not project_name:
        return  # TODO
    param = get_connection_params(QgsApplication.instance())
    uri = 'postgresql://' + param["host"] + ':' + param["port"] + \
          '?authcfg=' + param["authcfg"] + '&sslmode=disable&dbname=' + \
          param["dbname"] + '&schema=public&project=' + project_name
    return project.read(uri)
