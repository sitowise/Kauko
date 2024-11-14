import os

from qgis.PyQt import uic, QtWidgets
from qgis.PyQt.QtGui import QRegExpValidator
from qgis.PyQt.QtCore import QRegExp
from qgis.gui import QgisInterface

FROM_CLASS, _ = uic.loadUiType(os.path.join(
    os.path.dirname(__file__), 'new_version_dialog.ui'
))

class NewVersionDialog(QtWidgets.QDialog, FROM_CLASS):

    def __init__(self, iface: QgisInterface, plan_local_id: str, plan_name: str = None, parent=None):
        super(NewVersionDialog, self).__init__(parent)
        self.setupUi(self)
        self.iface = iface
        regexp = QRegExp('[a-zA-ZäöåÄÖÅ0-9.,\s+-]*')
        validator = QRegExpValidator(regexp)
        self.versionNameLineEdit.setValidator(validator)
        self.versionNameLineEdit.textChanged.connect(self.version_name_changed)
        self.plan_local_id = plan_local_id
        self.planNameLineEdit.setText(plan_name)

    def get_version_name(self) -> str:
        return self.versionNameLineEdit.text()

    def version_name_changed(self):
        if len(self.versionNameLineEdit.text()) < 3:
            self.acceptPushButton.setEnabled(False)
        else:
            self.acceptPushButton.setEnabled(True)

    def get_plan_local_id(self) -> str:
        return self.plan_local_id
