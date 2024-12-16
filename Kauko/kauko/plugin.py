from __future__ import annotations

from typing import TYPE_CHECKING, Callable, List

from psycopg2 import sql
from qgis.core import Qgis, QgsApplication, QgsPointXY
from qgis.gui import QgsMapToolEmitPoint
from qgis.PyQt.QtCore import QCoreApplication, QEventLoop, Qt, QTranslator
from qgis.PyQt.QtGui import QIcon
from qgis.PyQt.QtWidgets import QAction, QMenu, QMessageBox, QWidget
from qgis.utils import iface

from kauko.database.db_initializer import DatabaseInitializer
from kauko.database.db_tools import get_active_connection_and_schema
from kauko.plan_version_control.version_control import VersionControl
from kauko.qgis_plugin_tools.tools.custom_logging import setup_logger, teardown_logger
from kauko.qgis_plugin_tools.tools.i18n import setup_translation
from kauko.qgis_plugin_tools.tools.resources import plugin_name
from kauko.resources.ui.ui.new_version_dialog import NewVersionDialog
from kauko.resources.ui.ui.version_control_dialog import VersionControlDialog

from .database.database import Database

if TYPE_CHECKING:
    from psycopg2.extras import DictRow


class Plugin:
    """QGIS Plugin Implementation."""

    name = plugin_name()

    def __init__(self) -> None:
        """setup_logger(Plugin.name)"""

        # initialize locale
        locale, file_path = setup_translation()
        if file_path:
            self.translator = QTranslator()
            self.translator.load(file_path)
            # noinspection PyCallByClass
            QCoreApplication.installTranslator(self.translator)
        else:
            pass

        self.actions: list[QAction] = []

        self.menu = iface.mainWindow().findChild(QMenu, "&Kauko")

        if not self.menu:
            self.menu = QMenu("&Kauko", iface.mainWindow().menuBar())
            self.menu.setObjectName("&Kauko")
            actions = iface.mainWindow().menuBar().actions()
            last_action = actions[-1]
            iface.mainWindow().menuBar().insertMenu(last_action, self.menu)

        self.database_initializer = None
        self.connection = None
        self.schema = None

    def add_action(
        self,
        icon_path: str,
        text: str,
        callback: Callable,
        *,
        enabled_flag: bool = True,
        add_to_menu: bool = True,
        add_to_toolbar: bool = True,
        status_tip: str | None = None,
        whats_this: str | None = None,
        parent: QWidget | None = None,
    ) -> QAction:
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
        :rtype: QAction
        """

        icon = QIcon(icon_path)
        action = QAction(icon, text, parent)
        # noinspection PyUnresolvedReferences
        action.triggered.connect(callback)
        action.setEnabled(enabled_flag)

        if status_tip is not None:
            action.setStatusTip(status_tip)

        if whats_this is not None:
            action.setWhatsThis(whats_this)

        if add_to_toolbar:
            # Adds plugin icon to Plugins toolbar
            iface.addToolBarIcon(action)

        if add_to_menu:
            self.menu.addAction(action)

        self.actions.append(action)

        return action

    def initGui(self) -> None:  # noqa N802
        """Create the menu entries and toolbar icons inside the QGIS GUI."""
        self.add_action(
            ":/kauko/icons/mActionDuplicateLayer.svg",
            text="Kaavan versionhallinta",
            callback=self.version_control,
            parent=iface.mainWindow(),
            add_to_toolbar=False,
        )

    def onClosePlugin(self) -> None:  # noqa N802
        """Cleanup necessary items here when plugin dockwidget is closed"""

    def unload(self) -> None:
        """teardown_logger(Plugin.name)"""
        self.menu.clear()
        """iface.mainWindow().menuBar().removeAction(self.menu.menuAction())"""
        """self.menu.deleteLater()"""

    def _start(self, require_db: bool = False):
        """
        Sets the current database initializer, database and schema.

        :param require_db: Determines if the command requires an open project.
        """
        if require_db:
            self.connection, self.schema = get_active_connection_and_schema()
            if not self.connection or not self.schema:
                iface.messageBar().pushMessage(
                    "Virhe!",
                    "Yksikään projekti ei ole avoinna.",
                    level=Qgis.Warning,
                    duration=5,
                )
        else:
            self.connection = None
            self.schema = None
        self.database_initializer = DatabaseInitializer(iface, QgsApplication.instance(), self.connection, self.schema)

    def version_control(self):
        self._start(True)
        dlg = VersionControlDialog(iface)
        dlg.setWindowFlags(Qt.WindowStaysOnTopHint)
        dlg.new_version_clicked.connect(self.create_new_version)

        def change_active_plan(point: QgsPointXY):
            plan_names = self._get_current_plan_name(point, db)
            dlg.set_current_plan(plan_names)

        def delete_version(plan_name: str, version_name: str, version_local_id: str) -> None:
            confirm_delete = show_delete_version_confirmation_dialog(plan_name, version_name)

            if confirm_delete != QMessageBox.Yes:
                return

            if delete_version_from_database(self.schema, db, version_local_id):
                iface.messageBar().pushMessage("Versio poistettu.", level=Qgis.Success, duration=5)
            else:
                iface.messageBar().pushMessage("Version poisto epäonnistui.", level=Qgis.Critical, duration=5)

            plans = self._get_plans(db)
            dlg.add_versions(plans)

        def locate_map():
            canvas = iface.mapCanvas()
            point_tool = QgsMapToolEmitPoint(canvas)
            point_tool.canvasClicked.connect(change_active_plan)
            event_loop = QEventLoop()
            point_tool.canvasClicked.connect(event_loop.quit)
            canvas.setMapTool(point_tool)

            # Run the event loop
            event_loop.exec_()

        def show_delete_version_confirmation_dialog(plan_name: str, version_name: str) -> int:
            msg = QMessageBox()
            msg.setWindowTitle("Poista versio")
            msg.setText(
                f"Haluatko varmasti poistaa version '{version_name}' kaavasta {plan_name}? Tätä toimintoa ei voida peruuttaa."
            )
            msg.setIcon(QMessageBox.Warning)
            msg.setStandardButtons(QMessageBox.Yes | QMessageBox.No)
            return msg.exec_()

        def delete_version_from_database(schema: str, db: Database, version_local_id: str) -> bool:
            delete_query = sql.SQL(
                """
                DELETE FROM {schema}.spatial_plan
                WHERE local_id = {local_id}
                AND is_active = FALSE
                """
            ).format(schema=sql.Identifier(schema), local_id=sql.Literal(version_local_id))
            return db.update(delete_query)

        dlg.locate_map_clicked.connect(locate_map)
        dlg.delete_version_clicked.connect(delete_version)

        if not self.database_initializer.initialize_database(self.connection):
            return

        db = self.database_initializer.database
        plans = self._get_plans(db)
        dlg.add_versions(plans)

        dlg.show()

        if dlg.exec_():
            old_local_id, new_local_id = dlg.get_old_and_new_version()
            self.change_active_plan(db, old_local_id, new_local_id)

    def create_new_version(self, version_name, local_id):
        self._start(True)
        dlg = NewVersionDialog(iface, local_id, version_name)
        if not self.database_initializer.initialize_database(self.connection):
            return
        db = self.database_initializer.database
        dlg.show()

        if dlg.exec_():
            self._create_version(db, dlg)

    def _get_current_plan_name(self, point: QgsPointXY, db: Database) -> DictRow[str, str]:
        query = sql.SQL(
            """
            SELECT
            spm."name" ->> 'fin' as name_fi,
            spm."name" ->> 'swe' as name_sv
            FROM {schema}.spatial_plan_main spm
            JOIN {schema}.spatial_plan sp ON sp.local_plan_id = spm.local_plan_id
            WHERE ST_Intersects(sp.geom, ST_SetSRID(ST_MakePoint({x}, {y}), ST_SRID(sp.geom)))
            AND is_active = TRUE
            """
        ).format(schema=sql.Identifier(self.schema), x=sql.Literal(point.x()), y=sql.Literal(point.y()))
        return db.select(query)[0]

    def _create_version(self, db, dlg):
        version_control = VersionControl(db, self.schema)
        version_name = dlg.get_version_name()
        old_local_id = dlg.get_plan_local_id()
        new_local_id = version_control.create_new_version(old_local_id, version_name)
        self.change_active_plan(db, old_local_id, new_local_id)
        iface.messageBar().pushMessage("Uusi versio luotu.", level=Qgis.Success, duration=5)

    def _get_plans(self, db: Database) -> List[DictRow]:
        plansQuery = sql.SQL(
            """with version_names_agg as (
            select
                sp.local_plan_id,
                array_agg(ARRAY[sp.local_id, sp.version_name]) as version_names
            from {schema}.spatial_plan sp
            group by
                sp.local_plan_id
        ),
        active_plan as (
            select
                sp.local_plan_id,
                sp.version_name as active_version,
                sp.local_id as active_local_id,
                spls.preflabel_fi as active_lifecycle_status
            from {schema}.spatial_plan sp
            join code_lists.spatial_plan_lifecycle_status spls
                on spls.codevalue = sp.lifecycle_status
            where sp.is_active
        )
        select
            spm.name,
            spm."name" ->> 'fin' as name_fi,
            spm."name" ->> 'swe' as name_sv,
            vna.version_names,
            ap.active_version,
            ap.active_lifecycle_status,
            ap.active_local_id
        from {schema}.spatial_plan_main spm
        join version_names_agg vna on spm.local_plan_id = vna.local_plan_id
        join active_plan ap on spm.local_plan_id = ap.local_plan_id;
        """
        ).format(schema=sql.Identifier(self.schema))

        return db.select(plansQuery)
