import xml.etree.ElementTree as ET
import os
from os import listdir
from os.path import isfile, join

from qgis.core import QgsProject


PROJECT_TEMPALATE_PATH = f'{os.path.dirname(os.path.abspath(__file__))}/projects/'

def write_template():
    current_schema = get_current_schema()
    create_temp_project()
    project_tree = ET.parse(f'{PROJECT_TEMPALATE_PATH}000_temp.qgs')
    project_root = project_tree.getroot()
    parse_project(project_root, current_schema)
    project_tree.write(PROJECT_TEMPALATE_PATH + get_template_name())
    os.remove(f'{PROJECT_TEMPALATE_PATH}000_temp.qgs')


def parse_project(root, current_schema):
    projections_to_overwrite = [
            spatialref
            for spatialref in root.iter('spatialrefsys') ## TODO: Doesn't work :(
            if spatialref.find('wkt').text
        ]

    for spatialref in projections_to_overwrite:
        to_remove = list(spatialref)
        for elem in to_remove:
            spatialref.remove(elem)
        spatialref.text = "SPATIALREFSYS"


    for element in root.iter('*'):
        if element.tag == "datasource" and element.text:
            text = element.text
            text = text.replace(current_schema, "SCHEMANAME")
            if "dbname=" in text:
                text = replace_with_const(text, "dbname=", " ", "'DATABASE''")
            if "srid=" in text:
                text = replace_with_const(text, "srid=", " ", "PROJECTSRID")
            if "host=" in text:
                text = replace_with_const(text, "host=", " ", "HOST")
            if "authcfg=" in text:
                text = replace_with_const(text, "authcfg=", " ", "AUTHCFG")
            element.text = text
            continue


        for key in element.attrib:
            attr = element.attrib[key]

            if current_schema in attr:
                attr = attr.replace(current_schema, "SCHEMANAME")

            if "srid=" in attr:
                attr = replace_with_const(attr, "srid=", " ", "PROJECTSRID")

            if "dbname=" in attr:
                attr = replace_with_const(attr, "dbname=", " ", "'DATABASE''")

            if "host=" in attr:
                attr = replace_with_const(attr, "host=", " ", "HOST")

            if "authcfg=" in attr:
                attr = replace_with_const(attr, "authcfg=", " ", "AUTHCFG")

            if key == "crs" and len(attr) > 0:
                attr = "AUTHID"

            element.attrib[key] = attr

def replace_with_const(source: str, start: str, end:str, const: str) -> str:
    start_index = source.index(start) + len(start)
    end_index = source.index(end, start_index)
    return source[:start_index] + const + source[end_index:]


def create_temp_project() -> None:
    project = QgsProject.instance()
    project.write(f'{PROJECT_TEMPALATE_PATH}000_temp.qgs')


def get_current_schema() -> str:
    project = QgsProject.instance()
    filename = project.fileName()
    index = filename.index("project=") + len("project=")
    return filename[index:]


def get_template_name() -> str:
    projects = [f for f in listdir(PROJECT_TEMPALATE_PATH) if isfile(join(PROJECT_TEMPALATE_PATH, f))]
    projects.sort()
    newest_project = projects[-1]
    new_index = int(newest_project[:3]) + 1
    return f"{str(new_index).zfill(3)}_project_template.qgs"



