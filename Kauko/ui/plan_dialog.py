from typing import Tuple

from qgis.PyQt import QtWidgets
from qgis.gui import QgisInterface

from ..database.database import Database
from ..database.database_handler import get_spatial_plan_ids_and_names

class PlanDialog(QtWidgets.QDialog):

    def __init__(self, iface: QgisInterface, parent=None):
        super(PlanDialog, self).__init__(parent)
        self.setupUi(self)
        self.iface = iface
        self.spatialPlanNameComboBox.currentTextChanged.connect(
            self.enable_accept_button)
    
    def add_spatial_plans(self, db: Database, schema: str = None) -> None:
        """Add spatial plans to combobox"""
        self.spatialPlanNameComboBox.clear()
        spatial_plans = get_spatial_plan_ids_and_names(db, schema)
        for (id, name) in spatial_plans.items():
            self.spatialPlanNameComboBox.addItem(name, id)

    def enable_accept_button(self):
        """Set accept button enabled if spatial plan name is selected"""
        if self.spatialPlanNameComboBox.currentText() != "":
            self.acceptPushButton.setEnabled(True)
        else:
            self.acceptPushButton.setEnabled(False)

    def get_spatial_plan_name(self) -> str:
        return self.spatialPlanNameComboBox.currentText()

    def get_spatial_plan_id(self) -> str:
        return self.spatialPlanNameComboBox.currentData()
