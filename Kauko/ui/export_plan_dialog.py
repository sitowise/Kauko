import os
from typing import List

from qgis.PyQt import QtWidgets, uic
from qgis.gui import QgisInterface

from ..xml.xml_exporter import export_plan
from ..constants import KAATIO_API_URL
from ..qgis_plugin_tools.tools.network import post

FROM_CLASS, _ = uic.loadUiType(os.path.join(
    os.path.dirname(__file__), 'export_plan_dialog.ui'))

class ExportPlanDialog(QtWidgets.QDialog, FROM_CLASS):

    def __init__(self, iface: QgisInterface, parent=None):
        super(ExportPlanDialog, self).__init__(parent)
        self.setupUi(self)
        self.iface = iface
        self.spatialPlanNameComboBox.currentTextChanged.connect(
            self.enable_accept_button)
        self.apiUrlLineEdit.setText(KAATIO_API_URL)

    def add_spatial_plan_names(self, names: List[str]) -> None:
        """Add spatial plans names to combobox

        :param names: list of spatial plan names
        :return: None
        """
        self.spatialPlanNameComboBox.clear()
        for name in names:
            self.spatialPlanNameComboBox.addItem(name)

    def enable_accept_button(self):
        """Set accept button enabled if spatial plan name is selected"""
        if self.spatialPlanNameComboBox.currentText() != "":
            self.acceptPushButton.setEnabled(True)
        else:
            self.acceptPushButton.setEnabled(False)

    def get_spatial_plan_name(self) -> str:
        return self.spatialPlanNameComboBox.currentText()

    def export_plan(self, db, schema):
        plan_name = self.get_spatial_plan_name()
        exported_plan = export_plan(plan_name)
        plan_store_url = KAATIO_API_URL + "store"
        post(plan_store_url, files={'file': b""})


