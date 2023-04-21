import os

from qgis.PyQt import uic, QtWidgets
from qgis.gui import QgisInterface

FROM_CLASS, _ = uic.loadUiType(os.path.join(
    os.path.dirname(__file__), 'new_version_dialog.ui'
))

class NewVersionDialog(QtWidgets.QDialog, FROM_CLASS):

    def __init__(self, iface: QgisInterface, parent=None):
        super(NewVersionDialog, self).__init__(iface, parent)
        self.setupUi(self)
        self.iface = iface
