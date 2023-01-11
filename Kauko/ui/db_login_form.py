import os

from qgis.PyQt import QtWidgets, uic

FROM_CLASS, _ = uic.loadUiType(os.path.join(os.path.dirname(__file__), 'db_login_form.ui'))


class DbLoginForm(QtWidgets.QDialog, FROM_CLASS):

    def __init__(self, username: str, dbname: str, parent=None):

        super(DbLoginForm, self).__init__(parent)
        self.setupUi(self)

        if username is not None:
            self.usernameLineEdit.setText(username)

        if dbname is not None:
            self.labelDbName.setText(dbname)
        else:
            self.labelDbName.setText("Virhe: Tietokannan nimeä ei ole määritetty.")

    def get_login_info(self) -> tuple[str, str]:
        return self.usernameLineEdit.text(), self.passwordLineEdit.text()
