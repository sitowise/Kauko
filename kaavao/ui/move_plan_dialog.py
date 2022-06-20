import os

from qgis.PyQt import QtWidgets, uic
from qgis.gui import QgisInterface

from ..database.database_handler import move_plan_to_combination

FROM_CLASS, _ = uic.loadUiType(os.path.join(
    os.path.dirname(__file__), 'move_plan_dialog.ui'))


class MovePlanDialog(QtWidgets.QDialog, FROM_CLASS):

    def __init__(self, iface: QgisInterface, parent=None):
        super(MovePlanDialog, self).__init__(parent)
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

    def move_plan(self, db, schema):
        plan_name = self.get_spatial_plan_name()
        move_plan_to_combination(db, schema, plan_name)
