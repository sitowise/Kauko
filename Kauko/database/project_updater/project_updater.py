import fnmatch
import psycopg2
import os
from os import listdir
from os.path import isfile, join
from typing import Dict, List
from qgis.core import QgsMessageLog, Qgis
from ...project_handler import create_or_update_project
from ...database.query_builder import get_query
from ...data.schema import Schema
from ...database.database import Database

class ProjectUpdater:

    def __init__(self, db: Database, schemas: List[Schema]) -> None:
        self.__db = db
        self.__schemas = schemas
        self.__schema_versions: Dict[Schema, str] = {
            schema: '' for schema in self.__schemas
            }
        self.__project_versions: Dict[Schema, str] = {
            schema: '' for schema in self.__schemas
        }
        self.__scripts_to_execute: Dict[Schema, List[str]] = {}
        self.__projects_to_update: Dict[Schema, bool] = {}
        self.__scripts: List[str] = []
        self.__views: List[str] = []
        self.__newest_project: str

    def execute(self):
        self.__get_scripts()
        self.__get_executed_scripts()
        self.__initialize_projects()
        self.__get_scripts_to_execute()
        self.__get_view_scripts_to_execute()
        self.__get_newest_project()
        self.__get_projects_to_update()
        self.update_schemas()
        self.update_projects()

    def __get_executed_scripts(self) -> None:
        query: str = \
            "SELECT name, schema_version, project_version " + \
            "FROM public.schema_information"
        results = self.__db.select(query)
        for result in results:
            for schema in self.__schemas:
                if result[0] == schema.name:
                    self.__schema_versions[schema] = result[1].strip()
                    self.__project_versions[schema] = result[2].strip()
                    break

    def __get_scripts(self):
        script_path = f'{os.path.dirname(os.path.abspath(__file__))}/scripts/'
        self.__scripts = [f for f in listdir(script_path) if isfile(join(script_path, f)) ]
        self.__scripts.sort()

    def __get_newest_project(self):
        project_path = f'{os.path.dirname(os.path.abspath(__file__))}/projects/'
        projects = [f for f in listdir(project_path) if isfile(join(project_path, f))]
        projects.sort()
        self.__newest_project = projects[-1]

    def __initialize_projects(self):
        for schema in self.__schema_versions:
            if not self.__schema_versions[schema]:
                query = self.__get_initialize_project_query(schema)
                if self.__db.insert(query):
                    self.__logger(f"Initialized project {schema.name}", Qgis.Info)

    def __get_initialize_project_query(self, schema: Schema) -> str:
        combination = "TRUE" if schema.combination else "FALSE"
        query = \
        "INSERT INTO public.schema_information(" + \
            "name, srid, municipality, combination) " + \
            "VALUES ('"+ schema.name + "', " + schema.srid + ", '" + \
                schema.municipality + "', " + combination + ");"
        query += '\nCREATE SCHEMA ' + schema.name + ';'
        query += '\nCREATE TABLE IF NOT EXISTS ' + schema.name + '.versions(' + \
            'identifier integer NOT NULL GENERATED ALWAYS AS IDENTITY ' \
            '( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9999 ),' + \
            'scriptname character varying NOT NULL,' + \
            'applied timestamp(6) NOT NULL DEFAULT now(),' + \
            'PRIMARY KEY (identifier),' + \
            'CONSTRAINT scriptname_unique UNIQUE (scriptname));'
        return query
        
    def __mark_script_as_executed(self, schema: Schema, scriptname: str):
        schema_version_index = scriptname[:scriptname.index('_')]
        query = (
            f"INSERT INTO {schema.name}.versions(scriptname) "
            + "VALUES ('"
            + schema_version_index
            + "');"
        )

        query += "UPDATE public.schema_information SET schema_version = '" + schema_version_index + "'" \
            " WHERE name = '" + schema.name + "';"
        self.__db.insert(query)
        self.__logger(
            f"Executed script {scriptname} for schema {schema.name}", Qgis.Info
        )

        self.__schema_versions[Schema] = schema_version_index


    def __get_scripts_to_execute(self):
        for schema in self.__schema_versions:
            if self.__schema_versions[schema]:
                pattern_str = f'{self.__schema_versions[schema]}*'
                newest_script = fnmatch.filter(self.__scripts, pattern_str)[0]
                if newest_script == self.__scripts[-1]:
                    self.__scripts_to_execute[schema] = []
                    return
                index = self.__scripts.index(newest_script) + 1
                if schema.combination:
                    self.__scripts_to_execute[schema] = [
                        script for script in self.__scripts[index:]
                        if script[:script.index('_')][-1] != 'd'
                    ]
                else:
                    self.__scripts_to_execute[schema] = [
                        script for script in self.__scripts[index:] if
                        script[:script.index('_')][-1] != 'y'
                    ]
                self.__scripts_to_execute[schema] = self.__scripts[index:]
            elif schema.combination:
                self.__scripts_to_execute[schema] = [
                    script for script in self.__scripts if
                    script[:script.index('_')][-1] != 'd'
                ]
            else:
                self.__scripts_to_execute[schema] = [
                    script for script in self.__scripts if
                    script[:script.index('_')][-1] != 'y'
                ]
            self.__scripts_to_execute[schema].sort()
    
    def __get_view_scripts_to_execute(self):
        script_path = f'{os.path.dirname(os.path.abspath(__file__))}/scripts/views'
        self.__views = [f for f in listdir(script_path) if isfile(join(script_path, f)) ]
        

    def __get_projects_to_update(self):
        for schema in self.__project_versions:
            if not self.__project_versions[schema]:
                self.__projects_to_update[schema] = True
            else:
                current_project = f'{self.__project_versions[schema]}*'
                if not fnmatch.fnmatch(self.__newest_project, current_project):
                    self.__projects_to_update[schema] = False                    

    def update_schemas(self):
        for schema in self.__scripts_to_execute:
            for script in self.__scripts_to_execute[schema]:
                filename = f'/project_updater/scripts/{script}'
                query = get_query(schema.name, filename,
                schema.srid, schema.municipality)
                if self.__db.insert(query):
                    self.__mark_script_as_executed(schema, script)
            for view in self.__views:
                filename = f'/project_updater/scripts/views/{view}'
                query = get_query(schema.name, filename, schema.srid, schema.municipality)
                try:
                    self.__db.insert(query)
                except psycopg2.Error as err:
                    self.__logger(f'Failed to execute script {view}; {err}', Qgis.Critical)


    def update_projects(self):
        for schema in self.__projects_to_update:
            is_new = self.__projects_to_update[schema]
            if create_or_update_project(
                self.__db, schema.name, schema.srid, self.__newest_project, is_new, is_new):
                self.__logger(f"Created project file for {schema.name}", Qgis.Info)

    def __logger(self, msg: str, level=Qgis.Info):
        QgsMessageLog.logMessage(msg, "Project updater", level)
                