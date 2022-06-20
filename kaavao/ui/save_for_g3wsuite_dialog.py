import os

from PyQt5.QtWidgets import QFileDialog
from qgis.PyQt import QtWidgets, uic
from qgis.gui import QgisInterface

from ..database.project_for_web import set_new_layer_sources

FROM_CLASS, _ = uic.loadUiType(os.path.join(
    os.path.dirname(__file__), 'save_for_g3wsuite_dialog.ui'))


class SaveForWebDialog(QtWidgets.QDialog, FROM_CLASS):

    def __init__(self, iface: QgisInterface, parent=None):
        super(SaveForWebDialog, self).__init__(parent)
        self.setupUi(self)
        self.iface = iface

        self.filePathLineEdit.textChanged.connect(self.enable_accept_button)
        self.lineEditHost.textChanged.connect(self.enable_accept_button)
        self.lineEditPort.textChanged.connect(self.enable_accept_button)
        self.lineEditUsername.textChanged.connect(self.enable_accept_button)
        self.lineEditPassword.textChanged.connect(self.enable_accept_button)

        self.filePathLineEdit.clear()
        self.fileDialogPushButton.clicked.connect(self.select_output_file)

    def select_output_file(self):
        """Used to set save directory for the output file"""
        options = QFileDialog.Options()
        file_name, _ = QFileDialog.getSaveFileName(self, "Valitse tallennussijainti", "", "QGIS-tiedostot (*.qgs)",
                                                   options=options)
        if file_name:
            self.filePathLineEdit.setText(file_name)

    def enable_accept_button(self):
        """Set accept button enabled if spatial plan name is selected"""
        if self.filePathLineEdit.text() != "" and self.lineEditHost.text() != "" and self.lineEditPort.text() != ""\
                and self.lineEditDatabase.text() != "" and self.lineEditUsername.text() != "" and \
                self.lineEditPassword.text != "":
            self.acceptPushButton.setEnabled(True)
        else:
            self.acceptPushButton.setEnabled(False)

    def get_file_path(self) -> str:
        return self.filePathLineEdit.text()

    def get_connection_params(self):
        return {
            "host": self.lineEditHost.text(),
            "port": self.lineEditPort.text(),
            "database": self.lineEditDatabase.text(),
            "username": self.lineEditUsername.text(),
            "password": self.lineEditPassword.text()
        }

    def change_sources(self):
        params = self.get_connection_params()
        file = self.get_file_path()
        set_new_layer_sources(file, params["host"], params["port"], params["username"], params["password"])
