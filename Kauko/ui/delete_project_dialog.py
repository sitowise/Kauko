import os

from qgis.PyQt import QtWidgets, uic
from qgis.PyQt.QtCore import pyqtSignal
from qgis.gui import QgisInterface

from ..database.database_handler import delete_schema_and_project
from ..database.db_tools import get_database_connections

FROM_CLASS, _ = uic.loadUiType(os.path.join(
    os.path.dirname(__file__), 'delete_project_dialog.ui'))


class InitiateDeleteProjectDialog(QtWidgets.QDialog, FROM_CLASS):
    db_changed = pyqtSignal()

    def __init__(self, iface: QgisInterface, parent=None):

        super(InitiateDeleteProjectDialog, self).__init__(parent)
        self.setupUi(self)
        self.iface = iface
        self.dbComboBox.currentTextChanged.connect(self.database_changed)
        self.add_dbComboBox_items()

    def add_dbComboBox_items(self):
        """Add names of available database connections to combobox"""
        self.dbComboBox.clear()
        connections = get_database_connections()
        for conn in connections:
            self.dbComboBox.addItem(conn)

    def add_projectComboBox_items(self, projects):
        self.projectComboBox.clear()
        for project in projects:
            self.projectComboBox.addItem(project)

    def database_changed(self):
        self.db_changed.emit()

    def on_refreshPushButton_clicked(self):
        self.add_dbComboBox_items()

    def get_db(self) -> str:
        return self.dbComboBox.currentText()

    def get_project(self) -> str:
        return self.projectComboBox.currentText()

    def delete_project(self, db) -> bool:
        return delete_schema_and_project(db, self.get_project())
