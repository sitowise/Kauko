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
        for (conn, db) in connections:
            self.dbComboBox.addItem(conn, db)

    def add_projectComboBox_items(self, projects: list[str]):
        self.projectComboBox.clear()
        for project in projects:
            self.projectComboBox.addItem(project)

    def database_changed(self):
        self.db_changed.emit()

    def on_refreshPushButton_clicked(self):
        self.add_dbComboBox_items()

    def get_connection(self) -> str:
        """
        The name of the selected database connection.
        """
        return self.dbComboBox.currentText()

    def get_db(self) -> str:
        """
        The name of the selected database.
        """
        return self.dbComboBox.currentData()

    def get_project(self) -> str:
        return self.projectComboBox.currentText()
