import os
from typing import List, Tuple

from qgis.PyQt import uic, QtWidgets
from qgis.PyQt.QtCore import pyqtSignal
from qgis.gui import QgisInterface

from psycopg2.extras import DictRow


FROM_CLASS, _ = uic.loadUiType(os.path.join(
    os.path.dirname(__file__), 'version_control_dialog.ui'))

class VersionControlDialog(QtWidgets.QDialog, FROM_CLASS):
    new_version_clicked = pyqtSignal(str, str)

    def __init__(self, iface: QgisInterface, parent=None):
        super(VersionControlDialog, self).__init__(parent)
        self.setupUi(self)
        self.iface = iface
        self.active_local_id: str = None
        self.versions: List[DictRow] = []
        self.spatialPlanNameComboBox.currentTextChanged.connect(self.plan_changed)
        self.versionComboBox.currentTextChanged.connect(self.version_changed)
        self.createNewPushButton.clicked.connect(self.create_new_version)


    def create_new_version(self):
        self.new_version_clicked.emit(self.get_current_plan(), self.get_current_version_local_id())

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
        self.active_local_id = current_version['active_local_id']
        self.currentVersionLineEdit.setText(current_version['active_version'])
        self.currentLifecycleLineEdit.setText(current_version['active_lifecycle_status'])
        for version in current_version['version_names']:
            self.versionComboBox.addItem(version[1], version[0])

    def get_current_plan(self) -> str:
        return self.spatialPlanNameComboBox.currentText()

    def get_current_version(self) -> str:
        return self.versionComboBox.currentText()

    def get_current_version_local_id(self) -> str:
        return self.versionComboBox.currentData()

    def find_version_by_name(self, name: str) -> DictRow:
        for version in self.versions:
            if version['name'] == name:
                return version
        return None

    def get_old_and_new_version(self) -> Tuple[str, str]:
        return self.active_local_id, self.get_current_version_local_id()

    def version_changed(self):
        current_version = self.get_current_version()

        if current_version is not None:
            self.createNewPushButton.setEnabled(True)
        else:
            self.createNewPushButton.setEnabled(False)

        is_current_version = current_version == self.currentVersionLineEdit.text()
        self.acceptPushButton.setEnabled(not is_current_version)


