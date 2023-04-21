import os

from qgis.PyQt import uic
from qgis.gui import QgisInterface
from .plan_dialog import PlanDialog

FROM_CLASS, _ = uic.loadUiType(os.path.join(
    os.path.dirname(__file__), 'version_control_dialog.ui'))

class VersionControlDialog(PlanDialog, FROM_CLASS):

    def __init__(self, iface: QgisInterface, parent=None):
        super(VersionControlDialog, self).__init__(iface, parent)

    