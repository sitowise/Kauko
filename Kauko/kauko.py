# -*- coding: utf-8 -*-
"""
/***************************************************************************
 Kauko
                                 A QGIS plugin
 Kauko Työkalut
 Generated by Plugin Builder: http://g-sherman.github.io/Qgis-Plugin-Builder/
                              -------------------
        begin                : 2020-06-22
        git sha              : $Format:%H$
        copyright            : (C) 2023 by Sitowise Oy
        email                : tiketti@sitowise.com
 ***************************************************************************/

/***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 ***************************************************************************/
"""
import os.path
from typing import Callable
import ast

import psycopg2
from psycopg2 import sql
from qgis.core import (Qgis, QgsApplication, QgsProject)
from qgis.gui import QgisInterface
from qgis.PyQt.QtCore import QSettings
from qgis.PyQt.QtGui import QIcon
from qgis.PyQt.QtWidgets import QAction, QMenu, QWidget



from .ui.project_dialog import ProjectDialog

from .constants import KAATIO_API_URL
from .database.database_handler import (get_projects)
from .database.db_initializer import DatabaseInitializer
from .database.db_tools import get_active_connection_and_schema
from .database.project_updater.project_template_writer import write_template
from .database.query_builder import get_query
from .filter_layer import clear_layer_filters
from .qgis_plugin_tools.tools.custom_logging import setup_logger
from .resources import *
from .ui.change_to_unfinished import ChangeToUnfinished
from .ui.delete_project_dialog import InitiateDeleteProjectDialog
from .ui.export_plan_dialog import ExportPlanDialog
from .ui.get_regulations_dialog import InitiateRegulationsDialog
from .ui.open_project_dialog import InitiateOpenProjectDialog
from .ui.schema_creator_dialog import InitiateSchemaDialog
from .ui.select_plan_name_dialog import InitiateSelectPlanNameDialog
from .ui.update_project_dialog import InitiateUpdateProjectDialog
from .ui.version_control_dialog import VersionControlDialog
from .ui.new_version_dialog import NewVersionDialog


setup_logger("kauko")

class Kauko:
    """QGIS Plugin Implementation."""

    def __init__(self, iface: QgisInterface):
        """Constructor.

        :param iface: An interface instance that will be passed to this class
            which provides the hook by which you can manipulate the QGIS
            application at run time.
        :type iface: QgsInterface
        """
        # Save reference to the QGIS interface
        self.iface = iface
        # initialize plugin directory
        self.plugin_dir = os.path.dirname(__file__)

        # Declare instance attributes
        self.actions = []

        self.menu = self.iface.mainWindow().findChild(QMenu, "&Kauko")

        if not self.menu:
            self.menu = QMenu("&Kauko", self.iface.mainWindow().menuBar())
            self.menu.setObjectName("&Kauko")
            actions = self.iface.mainWindow().menuBar().actions()
            last_action = actions[-1]
            self.iface.mainWindow().menuBar().insertMenu(last_action, self.menu)
            if Kauko.is_admin():
                self.admin_menu = self.menu.addMenu("&Admin")



        # Check if plugin was started the first time in current QGIS session
        # Must be set in initGui() to survive plugin reloads
        # this doesn't do anything. self.first_start is never used
        # self.first_start = None

        self.database_initializer = None
        self.connection = None
        self.schema = None

    @staticmethod
    def is_admin():
        s = QSettings()
        s.beginGroup("variables")
        admin = s.value("kauko_admin")
        s.endGroup()
        return False if admin is None else admin.lower() == "true"

    def add_action(
            self,
            icon_path: str,
            text: str,
            callback: Callable,
            enabled_flag: bool = True,
            add_to_menu: bool = True,
            add_to_admin_menu: bool = False,
            add_to_toolbar: bool = True,
            status_tip: str = None,
            whats_this: str = None,
            parent: QWidget = None) -> QAction:
        """Add a toolbar icon to the toolbar.

        :param icon_path: Path to the icon for this action. Can be a resource
            path (e.g. ':/plugins/foo/bar.png') or a normal file system path.

        :param text: Text that should be shown in menu items for this action.

        :param callback: Function to be called when the action is triggered.

        :param enabled_flag: A flag indicating if the action should be enabled
            by default. Defaults to True.

        :param add_to_menu: Flag indicating whether the action should also
            be added to the menu. Defaults to True.

        :param add_to_toolbar: Flag indicating whether the action should also
            be added to the toolbar. Defaults to True.

        :param status_tip: Optional text to show in a popup when mouse pointer
            hovers over the action.

        :param parent: Parent widget for the new action. Defaults None.

        :param whats_this: Optional text to show in the status bar when the
            mouse pointer hovers over the action.

        :returns: The action that was created. Note that the action is also
            added to self.actions list.
        """

        icon = QIcon(icon_path)
        action = QAction(icon, text, parent)
        action.triggered.connect(callback)
        action.setEnabled(enabled_flag)

        if status_tip is not None:
            action.setStatusTip(status_tip)

        if whats_this is not None:
            action.setWhatsThis(whats_this)

        if add_to_toolbar:
            # Adds plugin icon to Plugins toolbar
            self.iface.addToolBarIcon(action)

        if add_to_menu:
            self.menu.addAction(action)
        elif add_to_admin_menu:
            self.admin_menu.addAction(action)


        self.actions.append(action)

        return action

    def initGui(self):
        """Create the menu entries and toolbar icons inside the QGIS GUI."""
        icon_path = None
        if Kauko.is_admin():
            self.add_action(
                icon_path,
                text="Luo uusi työtila",
                callback=self.create_schema,
                parent=self.iface.mainWindow(),
                add_to_toolbar=False,
                add_to_menu=False,
                add_to_admin_menu=True)

            self.add_action(
                icon_path,
                text="Poista työtila",
                callback=self.delete_project,
                parent=self.iface.mainWindow(),
                add_to_toolbar=False,
                add_to_menu=False,
                add_to_admin_menu=True
            )

            self.add_action(
                icon_path,
                text="Päivitä projekti",
                callback=self.update_projects,
                parent=self.iface.mainWindow(),
                add_to_toolbar=False,
                add_to_menu=False,
                add_to_admin_menu=True
            )

            self.add_action(
                icon_path,
                text="Tallenna malliksi",
                callback=self.save_template,
                parent=self.iface.mainWindow(),
                add_to_toolbar=False,
                add_to_menu=False,
                add_to_admin_menu=True
            )

        self.add_action(
            ':/Kauko/icons/mActionFileOpen.svg',
            text='Avaa työtila',
            callback=self.open_project,
            parent=self.iface.mainWindow(),
            add_to_toolbar=False)

        self.add_action(
            ':/Kauko/icons/mActionSharingExport.svg',
            text='Vie tallennuspalveluun',
            callback=self.export_plan,
            parent=self.iface.mainWindow(),
            add_to_toolbar=False)

        self.add_action(
            ':/Kauko/icons/mActionDuplicateLayer.svg',
            text="Kaavan versionhallinta",
            callback=self.version_control,
            parent=self.iface.mainWindow(),
            add_to_toolbar=False
        )

        """ self.add_action(
            icon_path,
            text="Hae määräykset",
            callback=self.get_regulations,
            parent=self.iface.mainWindow(),
            add_to_toolbar=False) """


        """ self.add_action(
            icon_path,
            text="Valitse näytettävä kaava",
            callback=self.show_selected_plan,
            parent=self.iface.mainWindow(),
            add_to_toolbar=False) """

        """ self.add_action(
            icon_path,
            text="Näytä kaikki kaavat",
            callback=clear_layer_filters,
            parent=self.iface.mainWindow(),
            add_to_toolbar=False) """

        """ self.add_action(
            icon_path,
            text="Aseta kaava takaisin keskeneräiseksi",
            callback=self.validity_to_unfinished,
            parent=self.iface.mainWindow(),
            add_to_toolbar=False
        ) """

    def unload(self):
        """Removes the plugin menu item and icon from QGIS GUI."""
        """ for action in self.actions:
            self.iface.removePluginDatabaseMenu(
                self.menu,
                action)
            self.iface.removeToolBarIcon(action) """
        self.menu.clear()
        self.iface.mainWindow().menuBar().removeAction(self.menu.menuAction())
        self.menu.deleteLater()

    def _start(self, require_db: bool=False):
        """
        Sets the current database initializer, database and schema.

        :param require_db: Determines if the command requires an open project.
        """
        if require_db:
            self.connection, self.schema = get_active_connection_and_schema()
            if not self.connection or not self.schema:
                self.iface.messageBar().pushMessage("Virhe!",
                                                "Yksikään projekti ei ole avoinna.",
                                                level=Qgis.Warning, duration=5)
        else:
            self.connection = None
            self.schema = None
        self.database_initializer = \
            DatabaseInitializer(self.iface, QgsApplication.instance(), self.connection, self.schema)

    def _initialize_database(self, dlg: ProjectDialog):
        connection_name, db_name = dlg.get_connection_and_db()
        self.database_initializer.initialize_database(connection_name)
        database = self.database_initializer.database
        try:
            dlg.add_projectComboBox_items(get_projects(database))
        except psycopg2.OperationalError:
            dlg.add_projectComboBox_items(["Ei yhteyttä!"])
        return database

    def create_schema(self):
        self._start()
        dlg = InitiateSchemaDialog(self.iface)
        dlg.show()

        # Run the dialog event loop
        result = dlg.exec_()
        # See if OK was pressed
        if result:
            connection_name, db_name = dlg.get_connection_and_db()
            if self.database_initializer.initialize_database(connection_name):
                database = self.database_initializer.database
                dlg.create_schema(database)

    def open_project(self):
        self._start()
        dlg = InitiateOpenProjectDialog(self.iface)
        self._initialize_database(dlg)
        dlg.db_changed.connect(lambda: self._initialize_database(dlg))

        dlg.show()
        # Run the dialog event loop
        result = dlg.exec_()

        # See if OK was pressed
        if result:
            dlg.open_project()

    def delete_project(self):
        self._start()
        dlg = InitiateDeleteProjectDialog(self.iface)
        self._initialize_database(dlg)
        dlg.db_changed.connect(lambda: self._initialize_database(dlg))

        dlg.show()

        # Run the dialog event loop
        result = dlg.exec_()
        # See if OK was pressed
        if result:
            db = self._initialize_database(dlg)
            dlg.delete_project(db)

    def get_regulations(self):
        self._start(True)
        dlg = InitiateRegulationsDialog(self.iface)
        if not self.database_initializer.initialize_database(self.connection):
            return
        db = self.database_initializer.database

        dlg.add_spatial_plans(db, self.schema)

        dlg.show()

        # Run the dialog event loop
        # See if OK was pressed
        if dlg.exec_():
            dlg.write_regulations(db, self.schema)

    def show_selected_plan(self):
        self._start(True)
        dlg = InitiateSelectPlanNameDialog(self.iface)
        if not self.database_initializer.initialize_database(self.connection):
            return
        db = self.database_initializer.database

        dlg.add_spatial_plans(db, self.schema)

        dlg.show()

        # Run the dialog event loop
        # See if OK was pressed
        if dlg.exec_():
            clear_layer_filters()
            dlg.write_spatial_plan_name_filters(db, QgsProject().instance(),
                                                self.schema)

    def validity_to_unfinished(self):
        self._start(True)
        dlg = ChangeToUnfinished(self.iface)
        if not self.database_initializer.initialize_database(self.connection):
            return
        db = self.database_initializer.database

        dlg.add_spatial_plans(db, self.schema)
        dlg.show()
        if dlg.exec_():
            plan_name = dlg.get_spatial_plan_name()
            query = get_query(self.schema, "/sql_scripts/change_to_unfinished.sql",
                            plan_name=plan_name)
            db.insert(query)
            self.iface.messageBar().pushMessage(f"Kaava {plan_name} muutettu keskeneräiseksi", level=Qgis.Success, duration=5)


    def update_projects(self):
        self.database_initializer = \
            DatabaseInitializer(self.iface, QgsApplication.instance())

        dlg = InitiateUpdateProjectDialog(self.iface)
        def initialize_database():
            connection_name, db_name = dlg.get_connection_and_db()
            self.database_initializer.initialize_database(connection_name)
            db = self.database_initializer.database
            try:
                dlg.add_projects(get_projects(db))
            except psycopg2.OperationalError:
                dlg.add_projects(["Ei yhteyttä!"])

        initialize_database()

        dlg.db_changed.connect(initialize_database)

        dlg.show()
        # Run the dialog event loop
        result = dlg.exec_()

        # See if OK was pressed
        if result:
            dlg.update_projects(self.database_initializer.database)
            self.iface.messageBar().pushMessage(
            "Projektit päivitetty.",
            level=Qgis.Success, duration=5)
        else:
            return

    def save_template(self):
        write_template()
        self.iface.messageBar().pushMessage(
            "Projekti malli luotu.",
            level=Qgis.Success, duration=5)

    def export_plan(self):
        self._start(True)
        dlg = ExportPlanDialog(self.iface)
        if not self.database_initializer.initialize_database(self.connection):
            return
        db = self.database_initializer.database

        dlg.add_spatial_plans(db, self.schema)
        dlg.show()

        plan_store_url = KAATIO_API_URL + "store"
        self.iface.messageBar().pushMessage(plan_store_url,
                                            level=Qgis.Warning, duration=5)
        if dlg.exec_():
            bar_msg = dlg.export_plan(db, self.schema)
            self.iface.messageBar().pushMessage(
                bar_msg["details"],
                level=Qgis.Info if bar_msg["success"] else Qgis.Warning,
                duration=bar_msg["duration"])

    def version_control(self):
        self._start(True)
        dlg = VersionControlDialog(self.iface)
        dlg.new_version_clicked.connect(self.create_new_version)
        if not self.database_initializer.initialize_database(self.connection):
            return
        db = self.database_initializer.database

        plansQuery = sql.SQL(
            '''with version_names_agg as (
            select
                sp.plan_id,
                array_agg(ARRAY[sp.local_id, sp.version_name]) as version_names
            from {schema}.spatial_plan sp
            group by
                sp.plan_id
        ),
        active_plan as (
            select
                sp.plan_id,
                sp.version_name as active_version,
                spls.preflabel_fi as active_lifecycle_status
            from {schema}.spatial_plan sp
            join code_lists.spatial_plan_lifecycle_status spls
                on spls.codevalue = sp.lifecycle_status
            where sp.is_active
        )
        select
            spm."name",
            vna.version_names,
            ap.active_version,
            ap.active_lifecycle_status
        from {schema}.spatial_plan_metadata spm
        join version_names_agg vna on spm.plan_id = vna.plan_id
        join active_plan ap on spm.plan_id = ap.plan_id;
        ''').format(
                schema=sql.Identifier(self.schema)
                )

        plans = db.select(plansQuery)
        dlg.add_versions(plans)

        dlg.show()
        if dlg.exec_():
            pass

    def create_new_version(self, version_name):
        self._start(True)
        dlg = NewVersionDialog(self.iface, version_name)
        dlg.show()

        if dlg.exec_():
            pass
