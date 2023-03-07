import os
from typing import List

from qgis.PyQt.QtWidgets import QFileDialog
from qgis.PyQt import uic
from qgis.gui import QgisInterface

from ..data.regulations_writer import write_regulations_file
from .plan_dialog import PlanDialog

FROM_CLASS, _ = uic.loadUiType(os.path.join(
    os.path.dirname(__file__), 'get_regulations_dialog.ui'))


class InitiateRegulationsDialog(PlanDialog, FROM_CLASS):

    def __init__(self, iface: QgisInterface, parent=None):
        super(InitiateRegulationsDialog, self).__init__(iface, parent)
        self.filePathLineEdit.textChanged.connect(self.enable_accept_button)
        self.filePathLineEdit.clear()
        self.fileDialogPushButton.clicked.connect(self.select_output_file)

    def select_output_file(self):
        """Used to set save directory for the output file"""
        options = QFileDialog.Options()
        file_name, _ = QFileDialog.getSaveFileName(self, "Valitse tallennussijainti", "", "csv (*.csv)",
                                                   options=options)
        if file_name:
            self.filePathLineEdit.setText(file_name)

    def get_file_path(self) -> str:
        return self.filePathLineEdit.text()

    def write_regulations(self, db, schema):
        write_regulations_file(db, self.get_spatial_plan_name(), schema, self.get_file_path())
