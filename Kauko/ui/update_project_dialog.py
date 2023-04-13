from ..database.project_updater.project_updater import ProjectUpdater
import os

from qgis.PyQt.QtGui import QStandardItemModel, QStandardItem

from qgis.PyQt import QtWidgets, uic
from qgis.PyQt.QtCore import pyqtSignal, Qt
from qgis.gui import QgisInterface

from ..database.database_handler import create_schema_objects, update_materialized_views
from ..database.db_tools import get_database_connections
from typing import List, Tuple

FROM_CLASS, _ = uic.loadUiType(os.path.join(
    os.path.dirname(__file__), 'update_project_dialog.ui'))


class InitiateUpdateProjectDialog(QtWidgets.QDialog, FROM_CLASS):
    db_changed = pyqtSignal()

    def __init__(self, iface: QgisInterface, parent=None):

        super(InitiateUpdateProjectDialog, self).__init__(parent)
        self.setupUi(self)
        self.iface = iface
        self.dbComboBox.currentTextChanged.connect(self.database_changed)
        self.add_dbComboBox_items()

    def add_dbComboBox_items(self):
        """Add names of available database connections to combobox"""
        self.dbComboBox.clear()
        connections = get_database_connections()
        for (db, conn) in connections.items():
            self.dbComboBox.addItem(conn, db)

    def add_projects(self, projects):
        project_list_view = self.projectsListView
        model = QStandardItemModel()
        for project in projects:
            item = QStandardItem(project)
            check = Qt.Unchecked
            item.setCheckState(check)
            item.setCheckable(True)
            model.appendRow(item)

        project_list_view.setModel(model)

    def database_changed(self):
        self.db_changed.emit()

    def on_refreshPushButton_clicked(self):
        self.add_dbComboBox_items()

    def get_connection_and_db(self) -> Tuple[str,str]:
        """
        The name of the selected connection and database.
        """
        return self.dbComboBox.currentText(), self.dbComboBox.currentData()

    def get_projects(self) -> List[str]:
        projects = []
        model = self.projectsListView.model()

        for i in range(model.rowCount()):
            item = model.item(i)
            if item.isCheckable() and item.checkState() == Qt.Checked:
                projects.append(item.text())
        return projects


    def update_views(self, db):
        update_materialized_views(db, self.get_projects())

    def update_projects(self, db):
        schemas = create_schema_objects(db, self.get_projects())
        project_updater = ProjectUpdater(db, schemas)
        project_updater.execute()

