from qgis.core import Qgis
from qgis.gui import QgisInterface
from qgis.PyQt.QtCore import QCoreApplication
from qgis.PyQt.QtWidgets import QMessageBox

from ..ui.db_login_form import DbLoginForm
from .database import Database
from .db_tools import (get_active_db_and_schema, get_connection_params,
                       set_connection)


def save_alert_msg():
    _, project = get_active_db_and_schema()
    msg = QMessageBox()
    msg.setText(f"Haluatko tallentaa työtilan {project}?")
    msg.setIcon(QMessageBox.Warning)
    msg.setStandardButtons(QMessageBox.Save | QMessageBox.Discard | QMessageBox.Cancel)
    return msg.exec_()


class DatabaseInitializer:
    """Used to initialize PostGis database and interact with it."""

    def __init__(self, iface: QgisInterface, qgs_app: QCoreApplication,
                 dbname=None, schema=None):
        self._iface = iface
        self._qgs_app = qgs_app
        self.msgBar = self._iface.messageBar().pushMessage
        self._database = None
        self.schema = schema
        if dbname:
            self.initialize_database(dbname)

    @property
    def database(self) -> Database:
        return self._database

    def initialize_database(self, db_name=None) -> bool:
        """Initializes database with parameters given in dialog

        :return: True if successful else false
        """
        if db_name is None:
            self.msgBar(
                "Yhdistäminen tietokantaan epäonnistui",
                "Tietokannan nimeä ei ole anettu",
                level=Qgis.Critical)
            return False
        set_connection(db_name)
        parameters = get_connection_params(self._qgs_app)

        # Ask database username and password if now already given
        if parameters["user"] is None or parameters["password"] is None:
            login_form = DbLoginForm(parameters["user"],
                                     parameters["password"])
            if login_form.exec_():
                parameters["user"] = login_form.usernameLineEdit.text()
                parameters["password"] = login_form.passwordLineEdit.text()
            else:
                self.msgBar(
                    "Yhdistäminen tietokantaan epäonnistui",
                    "Käyttäjätunnus tai salasana puuttuu.",
                    level=Qgis.Critical)
            return False

        parameters.pop('authcfg', None)  # TODO: TEMPORARY SOLUTION!
        self._database = Database(parameters)

        if self._database.is_valid:
            return True

        self.msgBar("Virhe!",
                    "Yhdistäminen tietokantaan epäonnistui",
                    level=Qgis.Critical)
        return False
