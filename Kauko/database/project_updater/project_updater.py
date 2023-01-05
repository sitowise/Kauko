import fnmatch
import os
from typing import Dict, List

import psycopg2
from qgis.core import Qgis, QgsMessageLog

from ...data.schema import PlanType, Schema
from ...database.database import Database
from ...database.query_builder import get_query
from ...project_handler import create_or_update_project


class ProjectUpdater:

    def __init__(self, db: Database, schemas: List[Schema]) -> None:
        self.base_path = os.path.dirname(os.path.abspath(__file__))
        self._db = db
        self._schemas: Dict[str, Schema] = {schema.name: schema for schema in schemas}
        self._scripts: Dict[PlanType, List[str]] = {}
        self._view_scripts: Dict[PlanType, List[str]] = {}
        self._newest_project: Dict[PlanType, str] = {}

    def execute(self):
        self.__get_scripts()
        self.__get_schema_and_project_versions()
        self.__initialize_projects()
        self.__update_scripts_to_execute()
        self.__get_view_scripts()
        self.__get_newest_project()
        self.__get_projects_to_update()
        self.update_schemas()
        self.update_projects()

    def __get_schema_and_project_versions(self) -> None:
        query = "SELECT name, schema_version, project_version FROM public.schema_information"
        results = self._db.select(query)
        for result in results:
            name, schema_version, project_version = result
            if name in self._schemas:
                self._schemas[name].schema_version = schema_version.strip()
                self._schemas[name].project_version = project_version.strip()

    def __get_scripts(self):
        script_paths = {
            PlanType.detailed_plan: 'scripts/detailed_plan',
            PlanType.master_plan: 'scripts/master_plan'
        }

        for plan_type, path in script_paths.items():
            full_path = os.path.join(self.base_path, path)
            self._scripts[plan_type] = sorted([f for f in os.listdir(full_path) if os.path.isfile(os.path.join(full_path, f))])

    def __get_newest_project(self) -> None:
        project_paths: Dict[PlanType, str] = {
            PlanType.detailed_plan: 'projects/detailed_plan',
            PlanType.master_plan: 'projects/master_plan'
        }

        for plan_type, path in project_paths.items():
            full_path = os.path.join(self.base_path, path)
            scripts = [f for f in os.listdir(full_path) if os.path.isfile(os.path.join(full_path, f))]
            try:
                self._newest_project[plan_type] = sorted(scripts)[-1]
            except IndexError:
                self._newest_project[plan_type] = None

    def __initialize_projects(self) -> None:
        for schema in self._schemas.values():
            if schema.is_new:
                query = self.__get_initialize_project_query(schema)
                if self._db.insert(query):
                    self.__logger(f"Initialized project {schema.name}", Qgis.Info)

    def __get_initialize_project_query(self, schema: Schema) -> str:
        is_master_plan = "TRUE" if schema.plan_type == PlanType.master_plan else "FALSE"
        query = """
        INSERT INTO public.schema_information(name, srid, municipality, is_master_plan)
        VALUES ('{name}', {srid}, '{municipality}', {master_plan});
        CREATE SCHEMA IF NOT EXISTS {name};
        CREATE TABLE IF NOT EXISTS {name}.versions(
            identifier integer NOT NULL GENERATED ALWAYS AS IDENTITY (INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9999) PRIMARY KEY,
            scriptname character varying NOT NULL UNIQUE,
            applied timestamp(6) NOT NULL DEFAULT now());
        """
        return query.format(
            name=schema.name,
            srid=schema.srid,
            municipality=schema.municipality_code,
            master_plan=is_master_plan)

    def __mark_script_as_executed(self, schema: Schema, scriptname: str) -> None:
        schema_version_index = scriptname[:scriptname.index('_')]
        query = (
            f"INSERT INTO {schema.name}.versions(scriptname) "
            f"VALUES ('{schema_version_index}');"
        )
        query += (
            "UPDATE public.schema_information "
            f"SET schema_version = '{schema_version_index}'"
            f" WHERE name = '{schema.name}';"
        )
        self._db.insert(query)
        self.__logger(
            f"Executed script {scriptname} for schema {schema.name}", Qgis.Info
        )
        schema.schema_version = schema_version_index

    def __update_scripts_to_execute(self):
        for schema in self._schemas.values():
            plan_type = schema.plan_type
            if schema.schema_version:
                pattern_str = f'{schema.schema_version}*'
                newest_script = fnmatch.filter(self._scripts[plan_type], pattern_str)[0]
                if newest_script == self._scripts[plan_type][-1]:
                    continue
                script_index = self._scripts[plan_type].index(newest_script) + 1
                scripts = self._scripts[plan_type][script_index:]
            else:
                scripts = self._scripts[plan_type]

            schema.scripts_to_execute = sorted(scripts)

    def __get_view_scripts(self):
        script_paths = {
            PlanType.detailed_plan: 'scripts/detailed_plan/views',
            PlanType.master_plan: 'scripts/master_plan/views'
        }
        for plan_type, path in script_paths.items():
            full_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), path)
            self._view_scripts[plan_type] = [f for f in os.listdir(full_path) if os.path.isfile(os.path.join(full_path, f))]


    def __get_projects_to_update(self):
        for schema in self._schemas.values():
            if schema.is_new:
                schema.update_project = True

            elif not fnmatch.fnmatch(self._newest_project[schema.plan_type], f'{schema.project_version}*'):
                schema.update_project = True

            else:
                schema.update_project = False

    def update_schemas(self):
        script_paths = {
            PlanType.master_plan: '/project_updater/scripts/master_plan/',
            PlanType.detailed_plan: '/project_updater/scripts/detailed_plan/'
        }

        for schema in self._schemas.values():
            for script in schema.scripts_to_execute:
                filename = f'{script_paths[schema.plan_type]}{script}'
                query = get_query(schema.name, filename,
                schema.srid, schema.municipality_code)
                if self._db.insert(query):
                    self.__mark_script_as_executed(schema, script)
            for view in schema.views_to_execute:
                filename = f'/project_updater/scripts/views/{view}'
                query = get_query(schema.name, filename, schema.srid, schema.municipality_code)
                try:
                    self._db.insert(query)
                except psycopg2.Error as err:
                    self.__logger(f'Failed to execute script {view}; {err}', Qgis.Critical)


    def update_projects(self):
        for schema in self._schemas.values():
            if not schema.update_project:
                continue
            if create_or_update_project(
                self._db,
                schema.name,
                schema.srid,
                self._newest_project[schema.plan_type],
                schema.plan_type,
                True,
                schema.is_new
            ):
                if schema.is_new:
                    self.__logger(f"Created project file for {schema.name}", Qgis.Info)
                else:
                    self.__logger(f"Updated project file for {schema.name}", Qgis.Info)

    def __logger(self, msg: str, level=Qgis.Info):
        QgsMessageLog.logMessage(msg, "Project updater", level)
