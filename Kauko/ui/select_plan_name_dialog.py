import os

from qgis.PyQt import uic

from ..filter_layer import filter_layers_by_spatial_plan_name
from .plan_dialog import PlanDialog

FROM_CLASS, _ = uic.loadUiType(os.path.join(
    os.path.dirname(__file__), 'select_plan_name_dialog.ui'))


class InitiateSelectPlanNameDialog(PlanDialog, FROM_CLASS):

    def write_spatial_plan_name_filters(self, db, project, schema):
        plan_name = self.get_spatial_plan_name()
        filter_layers_by_spatial_plan_name(project, plan_name, db, schema)
