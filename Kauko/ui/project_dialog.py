from typing import Tuple
from qgis.PyQt import QtWidgets
from qgis.PyQt.QtCore import pyqtSignal
from qgis.gui import QgisInterface

from ..database.db_tools import get_database_connections

class ProjectDialog(QtWidgets.QDialog):
    db_changed = pyqtSignal()

    def __init__(self, iface: QgisInterface, parent=None):

        super(ProjectDialog, self).__init__(parent)
        self.setupUi(self)
        self.iface = iface
        self.dbComboBox.currentTextChanged.connect(self.database_changed)
        self.add_dbComboBox_items()

    def add_dbComboBox_items(self):
        """Add names of available database connections and databases to combobox"""
        self.dbComboBox.clear()
        connections = get_database_connections()
        for (db, conn) in connections.items():
            self.dbComboBox.addItem(conn, db)

    def add_projectComboBox_items(self, projects: list[str]):
        self.projectComboBox.clear()
        for project in projects:
            self.projectComboBox.addItem(project)

    def database_changed(self):
        self.db_changed.emit()

    def on_refreshPushButton_clicked(self):
        self.add_dbComboBox_items()

    def get_connection_and_db(self) -> Tuple[str,str]:
        """
        The name of the selected connection and database.
        """
        return self.dbComboBox.currentText(), self.dbComboBox.currentData()

    def get_project(self) -> str:
        return self.projectComboBox.currentText()
