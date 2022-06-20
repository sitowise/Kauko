import os

from PyQt5.QtWidgets import QFileDialog
from qgis.PyQt import QtWidgets, uic
from qgis.gui import QgisInterface

from ..data.regulations_writer import write_regulations_file

FROM_CLASS, _ = uic.loadUiType(os.path.join(
    os.path.dirname(__file__), 'get_regulations_dialog.ui'))


class InitiateRegulationsDialog(QtWidgets.QDialog, FROM_CLASS):

    def __init__(self, iface: QgisInterface, parent=None):
        super(InitiateRegulationsDialog, self).__init__(parent)
        self.setupUi(self)
        self.iface = iface
        self.spatialPlanNameComboBox.currentTextChanged.connect(self.enable_accept_button)
        self.filePathLineEdit.textChanged.connect(self.enable_accept_button)
        self.filePathLineEdit.clear()
        self.fileDialogPushButton.clicked.connect(self.select_output_file)

    def add_spatial_plan_names(self, items: [str]) -> None:
        """Adds names of given spatial plans to combobox

        :param items: list of spatial plan names
        :return: None
        """
        self.spatialPlanNameComboBox.clear()
        for item in items:
            self.spatialPlanNameComboBox.addItem(item)

    def select_output_file(self):
        """Used to set save directory for the output file"""
        options = QFileDialog.Options()
        file_name, _ = QFileDialog.getSaveFileName(self, "Valitse tallennussijainti", "", "csv (*.csv)",
                                                   options=options)
        if file_name:
            self.filePathLineEdit.setText(file_name)

    def enable_accept_button(self):
        """Set accept button enabled if spatial plan name is selected"""
        if self.spatialPlanNameComboBox.currentText() != "" and \
                self.filePathLineEdit.text() != "":
            self.acceptPushButton.setEnabled(True)
        else:
            self.acceptPushButton.setEnabled(False)

    def get_spatial_plan_name(self) -> str:
        return self.spatialPlanNameComboBox.currentText()

    def get_file_path(self) -> str:
        return self.filePathLineEdit.text()

    def write_regulations(self, db, schema):
        write_regulations_file(db, self.get_spatial_plan_name(), schema, self.get_file_path())
