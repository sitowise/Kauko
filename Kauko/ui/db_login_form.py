import os

from qgis.PyQt import QtWidgets, uic

FROM_CLASS, _ = uic.loadUiType(os.path.join(os.path.dirname(__file__), 'db_login_form.ui'))


class DbLoginForm(QtWidgets.QDialog, FROM_CLASS):

    def __init__(self, username, password, parent=None):

        super(DbLoginForm, self).__init__(parent)
        self.setupUi(self)

        if username is not None:
            self.usernameLineEdit.setText(username)

        if password is not None:
            self.passwordLineEdit.setText(password)
