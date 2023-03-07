import os

from qgis.PyQt import uic

from ..database.database_handler import move_plan_to_combination
from .plan_dialog import PlanDialog

FROM_CLASS, _ = uic.loadUiType(os.path.join(
    os.path.dirname(__file__), 'move_plan_dialog.ui'))


class MovePlanDialog(PlanDialog, FROM_CLASS):

    def move_plan(self, db, schema):
        plan_name = self.get_spatial_plan_name()
        move_plan_to_combination(db, schema, plan_name)
