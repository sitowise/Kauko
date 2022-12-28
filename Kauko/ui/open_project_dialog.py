import os

from qgis.PyQt import QtWidgets, uic
from qgis.PyQt.QtCore import pyqtSignal
from qgis.gui import QgisInterface

from ..database.db_tools import get_database_connections
from ..project_handler import open_project

FROM_CLASS, _ = uic.loadUiType(os.path.join(
    os.path.dirname(__file__), 'open_project_dialog.ui'))


class InitiateOpenProjectDialog(QtWidgets.QDialog, FROM_CLASS):
    db_changed = pyqtSignal()

    def __init__(self, iface: QgisInterface, parent=None):

        super(InitiateOpenProjectDialog, self).__init__(parent)
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

    def open_project(self):
        open_project(self.get_project())
