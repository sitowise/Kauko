import os
from typing import List

from qgis.PyQt import uic, QtWidgets
from qgis.gui import QgisInterface

from psycopg2.extras import DictRow


FROM_CLASS, _ = uic.loadUiType(os.path.join(
    os.path.dirname(__file__), 'version_control_dialog.ui'))

class VersionControlDialog(QtWidgets.QDialog, FROM_CLASS):

    def __init__(self, iface: QgisInterface, parent=None):
        super(VersionControlDialog, self).__init__(parent)
        self.setupUi(self)
        self.iface = iface
        self.versions: List[DictRow] = []
        self.spatialPlanNameComboBox.currentTextChanged.connect(self.plan_changed)

    def add_versions(self, versions: List[DictRow]):
        self.versions = versions
        self.spatialPlanNameComboBox.clear()
        for version in self.versions:
            self.spatialPlanNameComboBox.addItem(version['name'])

    def plan_changed(self):
        current_plan = self.get_current_plan()
        current_version = self.find_version_by_name(current_plan)
        self.versionComboBox.clear()
        if current_version is None:
            self.currentVersionLineEdit.setText('')
            self.currentLifecycleLineEdit.setText('')
            return
        self.currentVersionLineEdit.setText(current_version['active_version'])
        self.currentLifecycleLineEdit.setText(current_version['active_lifecycle_status'])
        self.versionComboBox.addItems(current_version['version_names'])

    def get_current_plan(self) -> str:
        return self.spatialPlanNameComboBox.currentText()

    def find_version_by_name(self, name: str) -> DictRow:
        for version in self.versions:
            if version['name'] == name:
                return version
        return None

