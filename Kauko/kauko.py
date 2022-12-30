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

import psycopg2
from qgis.core import (Qgis, QgsApplication, QgsCoordinateReferenceSystem,
                       QgsProject)
from qgis.gui import QgisInterface
from qgis.PyQt.QtCore import QSettings
from qgis.PyQt.QtGui import QIcon
from qgis.PyQt.QtWidgets import QAction, QMenu, QMessageBox, QWidget

from .constants import NUMBER_OF_GEOM_CHECKS_SQL
from .data.tools import parse_value
from .database.database_handler import (add_geom_checks, drop_geom_checks,
                                        get_projects, get_spatial_plan_names)
from .database.db_initializer import DatabaseInitializer
from .database.db_tools import get_active_db_and_schema
from .database.project_updater.project_template_writer import write_template
from .database.query_builder import get_query
from .filter_layer import clear_layer_filters
from .project_handler import open_project
from .resources import *
from .ui.change_to_unfinished import ChangeToUnfinished
from .ui.delete_project_dialog import InitiateDeleteProjectDialog
from .ui.get_regulations_dialog import InitiateRegulationsDialog
from .ui.move_plan_dialog import MovePlanDialog
from .ui.open_project_dialog import InitiateOpenProjectDialog
from .ui.schema_creator_dialog import InitiateSchemaDialog
from .ui.select_plan_name_dialog import InitiateSelectPlanNameDialog
from .ui.update_project_dialog import InitiateUpdateProjectDialog


def is_admin():
    s = QSettings()
    s.beginGroup("variables")
    admin = s.value("kauko_admin")
    s.endGroup()
    return admin.lower() == "true"



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
            if is_admin():
                self.admin_menu = self.menu.addMenu("&Admin")



        # Check if plugin was started the first time in current QGIS session
        # Must be set in initGui() to survive plugin reloads
        self.first_start = None

        self.database_initializer = None

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
        icon_path = ':/plugins/Kauko/logo.png'
        if is_admin():
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
            icon_path,
            text='Avaa työtila',
            callback=self.open_project,
            parent=self.iface.mainWindow(),
            add_to_toolbar=False)


        """ self.add_action(
            icon_path,
            text="Hae määräykset",
            callback=self.get_regulations,
            parent=self.iface.mainWindow(),
            add_to_toolbar=False) """

        """ self.add_action(
            icon_path,
            text="Aseta asemakaavayhdistelmän muokkaus päälle/pois päältä",
            callback=self.set_editing,
            parent=self.iface.mainWindow(),
            add_to_toolbar=False
        ) """

        """ self.add_action(
            icon_path,
            text="Siirrä asemakaavayhdistelmään",
            callback=self.move_plan,
            parent=self.iface.mainWindow(),
            add_to_toolbar=False
        ) """

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

        """ self.add_action(
            icon_path,
            text="Korjaa työtilan topologia",
            callback=self.fix_topology,
            parent=self.iface.mainWindow(),
            add_to_toolbar=False
        ) """

        # will be set False in run()
        self.first_start = True

    def unload(self):
        """Removes the plugin menu item and icon from QGIS GUI."""
        """ for action in self.actions:
            self.iface.removePluginDatabaseMenu(
                self.menu,
                action)
            self.iface.removeToolBarIcon(action) """
        self.menu.clear()
        self.iface.mainWindow().menuBar().removeAction(self.menu.menuAction())


    def create_schema(self):
        self.database_initializer = \
            DatabaseInitializer(self.iface, QgsApplication.instance())

        # Create the dialog with elements (after translation) and keep reference
        # Only create GUI ONCE in callback, so that it will only load when the plugin is started
        if self.first_start:
            self.first_start = False
        dlg = InitiateSchemaDialog(self.iface)
        dlg.show()

        # Run the dialog event loop
        result = dlg.exec_()
        # See if OK was pressed
        if result and self.database_initializer.initialize_database(dlg.get_db()):
            database = self.database_initializer.database
            dlg.create_schema(database)

    def open_project(self):
        self.database_initializer = \
            DatabaseInitializer(self.iface, QgsApplication.instance())

        # Create the dialog with elements (after translation) and keep reference
        # Only create GUI ONCE in callback, so that it will only load when the plugin is started
        if self.first_start:
            self.first_start = False

        dlg = InitiateOpenProjectDialog(self.iface)

        def initialize_database():
            self.database_initializer.initialize_database(dlg.get_db())
            database = self.database_initializer.database
            try:
                dlg.add_projectComboBox_items(get_projects(database))
            except psycopg2.OperationalError:
                dlg.add_projectComboBox_items(["Ei yhteyttä!"])

        initialize_database()
        dlg.db_changed.connect(initialize_database)

        dlg.show()
        # Run the dialog event loop
        result = dlg.exec_()

        # See if OK was pressed
        if result:
            dlg.open_project()

    def delete_project(self):
        self.database_initializer = \
            DatabaseInitializer(self.iface, QgsApplication.instance())

        # Create the dialog with elements (after translation) and keep reference
        # Only create GUI ONCE in callback, so that it will only load when the plugin is started
        if self.first_start:
            self.first_start = False

        dlg = InitiateDeleteProjectDialog(self.iface)

        def initialize_database():
            self.database_initializer.initialize_database(dlg.get_db())
            database = self.database_initializer.database
            try:
                dlg.add_projectComboBox_items(get_projects(database))
            except psycopg2.OperationalError:
                dlg.add_projectComboBox_items(["Ei yhteyttä!"])
            return database

        initialize_database()
        dlg.db_changed.connect(initialize_database)

        dlg.show()

        # Run the dialog event loop
        result = dlg.exec_()
        # See if OK was pressed
        if result:
            db = initialize_database()
            if dlg.delete_project(db):
                self.iface.messageBar().pushMessage(
                    "Työtila poistettu onnistuneesti",
                    level=Qgis.Success, duration=5)

    def get_regulations(self):
        dbname, schema = get_active_db_and_schema()
        if not dbname or not schema:
            self.iface.messageBar().pushMessage("Virhe!",
                                                "Yksikään projekti ei ole avoinna.",
                                                level=Qgis.Warning, duration=5)
            return
        self.database_initializer = \
            DatabaseInitializer(self.iface, QgsApplication.instance())

        # Create the dialog with elements (after translation) and keep reference
        # Only create GUI ONCE in callback, so that it will only load when the plugin is started
        if self.first_start:
            self.first_start = False

        dlg = InitiateRegulationsDialog(self.iface)
        if not self.database_initializer.initialize_database(dbname):
            return
        db = self.database_initializer.database
        dlg.add_spatial_plan_names(get_spatial_plan_names(db, schema))

        dlg.show()

        # Run the dialog event loop
        # See if OK was pressed
        if dlg.exec_():
            dlg.write_regulations(db, schema)

    def show_selected_plan(self):
        dbname, schema = get_active_db_and_schema()
        if len(schema) == 0:
            self.iface.messageBar().pushMessage("Virhe!",
                                                "Yksikään projekti ei ole avoinna.",
                                                level=Qgis.Warning, duration=5)
            return
        self.database_initializer = \
            DatabaseInitializer(self.iface, QgsApplication.instance(), dbname,
                                schema)

        # Create the dialog with elements (after translation) and keep reference
        # Only create GUI ONCE in callback, so that it will only load when the plugin is started
        if self.first_start:
            self.first_start = False

        dlg = InitiateSelectPlanNameDialog(self.iface)
        if not self.database_initializer.initialize_database(dbname):
            return
        db = self.database_initializer.database

        spatial_plans = get_spatial_plan_names(db, schema)
        dlg.add_spatial_plan_names(spatial_plans)

        dlg.show()

        # Run the dialog event loop
        # See if OK was pressed
        if dlg.exec_():
            clear_layer_filters()
            dlg.write_spatial_plan_name_filters(db, QgsProject().instance(),
                                                schema)

    def set_editing(self):
        dbname, schema = get_active_db_and_schema()
        if not dbname and not schema:
            self.iface.messageBar().pushMessage("Virhe!",
                                                "Yksikään projekti ei ole avoinna.",
                                                level=Qgis.Warning, duration=5)
            return
        elif schema[-1] != 'y':
            self.iface.messageBar().pushMessage("Virhe!",
                                                "Työtila ei ole asemakaavayhdistelmä",
                                                level=Qgis.Warning, duration=5)
            return
        self.database_initializer = \
            DatabaseInitializer(self.iface, QgsApplication.instance(), dbname)
        db = self.database_initializer.database
        query = NUMBER_OF_GEOM_CHECKS_SQL.replace("schemaname", schema)
        checks = db.select(query)[0][0]
        msg = QMessageBox()
        msg.setStandardButtons(QMessageBox.Yes | QMessageBox.No)
        msg.setIcon(QMessageBox.Question)
        if checks == 0:
            msg.setText("Haluatko laittaa muokkauksen päälle?")
            if msg.exec_():
                drop_geom_checks(schema, db)
        else:
            msg.setText("Haluatko lopettaa muokkauksen?")
            if msg.exec_():
                add_geom_checks(schema, db)

    def move_plan(self):
        dbname, schema = get_active_db_and_schema()
        if not dbname and not schema:
            self.iface.messageBar().pushMessage("Virhe!",
                                                "Yksikään projekti ei ole avoinna.",
                                                level=Qgis.Warning, duration=5)
            return
        elif schema[-1] == 'y':
            self.iface.messageBar().pushMessage("Virhe!",
                                                "Työtila on asemakaavayhdistelmä",
                                                level=Qgis.Warning, duration=5)
            return

        self.database_initializer = \
                DatabaseInitializer(self.iface, QgsApplication.instance(), dbname,
                                schema)
        dlg = MovePlanDialog(self.iface)
        if not self.database_initializer.initialize_database(dbname):
            return
        db = self.database_initializer.database
        spatial_plans = get_spatial_plan_names(db, schema)
        dlg.add_spatial_plan_names(spatial_plans)
        dlg.show()
        if dlg.exec_():
            if not drop_geom_checks(f"{schema}_y", db):
                return
            dlg.move_plan(db, schema)
            srid = self.iface.mapCanvas().mapSettings().destinationCrs().authid()[5:]
            if open_project(f"{schema}_y"):
                QgsProject().instance().setCrs(
                    QgsCoordinateReferenceSystem(int(srid)))

    def validity_to_unfinished(self):
        dbname, schema = get_active_db_and_schema()
        if not dbname and not schema:
            self.iface.messageBar().pushMessage("Virhe!",
                                                "Yksikään projekti ei ole avoinna.",
                                                level=Qgis.Warning, duration=5)
            return
        self.database_initializer = \
                DatabaseInitializer(self.iface, QgsApplication.instance(), dbname,
                                schema)
        dlg = ChangeToUnfinished(self.iface)
        if not self.database_initializer.initialize_database(dbname):
            return
        db = self.database_initializer.database
        spatial_plans = get_spatial_plan_names(db, schema)
        dlg.add_spatial_plan_names(spatial_plans)
        dlg.show()
        if dlg.exec_():
            plan_name = dlg.get_spatial_plan_name()
            query = get_query(schema, "/sql_scripts/change_to_unfinished.sql",
                            plan_name=plan_name)
            db.insert(query)
            self.iface.messageBar().pushMessage(f"Kaava {plan_name} muutettu keskeneräiseksi", level=Qgis.Success, duration=5)

    def fix_topology(self):
        dbname, schema = get_active_db_and_schema()
        if not dbname and not schema:
            self.iface.messageBar().pushMessage("Virhe!",
                                                "Yksikään projekti ei ole avoinna.",
                                                level=Qgis.Warning, duration=5)
            return
        self.database_initializer = \
            DatabaseInitializer(self.iface, QgsApplication.instance(), dbname,
                                schema)
        db = self.database_initializer.database
        query = get_query(schema, "/sql_scripts/fix_topology.sql")
        db.insert(query)
        self.iface.messageBar().pushMessage("Kaavan topologia korjattu.",
                                            level=Qgis.Success, duration=5)

    def update_projects(self):
        self.database_initializer = \
            DatabaseInitializer(self.iface, QgsApplication.instance())

        dlg = InitiateUpdateProjectDialog(self.iface)

        def initialize_database():
            self.database_initializer.initialize_database(dlg.get_db())
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
