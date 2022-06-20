import os

from qgis.PyQt import QtWidgets, uic
from qgis.gui import QgisInterface

from ..filter_layer import filter_layers_by_spatial_plan_name

FROM_CLASS, _ = uic.loadUiType(os.path.join(
    os.path.dirname(__file__), 'select_plan_name_dialog.ui'))


class InitiateSelectPlanNameDialog(QtWidgets.QDialog, FROM_CLASS):

    def __init__(self, iface: QgisInterface, parent=None):
        super(InitiateSelectPlanNameDialog, self).__init__(parent)
        self.setupUi(self)
        self.iface = iface
        self.spatialPlanNameComboBox.currentTextChanged.connect(
            self.enable_accept_button)

    def add_spatial_plan_names(self, names: [str]) -> None:
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

    def write_spatial_plan_name_filters(self, db, project, schema):
        plan_name = self.get_spatial_plan_name()
        filter_layers_by_spatial_plan_name(project, plan_name, db, schema)
