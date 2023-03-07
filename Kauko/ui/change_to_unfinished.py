import os

from qgis.PyQt import uic

from ..database.database_handler import change_validity_to_unfinshed
from .plan_dialog import PlanDialog

FROM_CLASS, _ = uic.loadUiType(os.path.join(
    os.path.dirname(__file__), 'change_to_unfinished.ui'))

class ChangeToUnfinished(PlanDialog, FROM_CLASS):

    def change_validity(self, db, schema):
        plan_name = self.get_spatial_plan_name()
        change_validity_to_unfinshed(db, schema, plan_name)
