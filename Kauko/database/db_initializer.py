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

    def __init__(self, iface: QgisInterface, qgs_app: QCoreApplication, dbname: str = None, schema:str = None):
        """Initialize the plugin.

        Args:
            iface (QgisInterface): An interface instance that will be passed to this class
                which provides the hook by which you can manipulate the QGIS application at run time.
            qgs_app (QCoreApplication): A QCoreApplication instance.
            dbname (str, optional): Name of the database to connect to. Defaults to None.
            schema (str, optional): The schema to use. Defaults to None.
        """
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

    def initialize_database(self, connection_name: str, db_name: str) -> bool:
        """Initializes database with parameters given in dialog

        :return: True if successful, False otherwise.
        """
        if not db_name:
            self.msgBar(
                "Yhdistäminen tietokantaan epäonnistui",
                "Tietokannan nimeä ei ole annettu tai PostgreSQL tietokantaa ei ole määritetty",
                level=Qgis.Critical,
                duration=10)
            return False

        set_connection(connection_name)
        params = get_connection_params(self._qgs_app)

        # Ask database username and password if now already given
        if not params.get("user") or not params.get("password"):
            login_form = DbLoginForm(params["user"], params["dbname"])
            if login_form.exec_():
                params["user"] = login_form.usernameLineEdit.text()
                params["password"] = login_form.passwordLineEdit.text()
            else:
                self.msgBar(
                    f"Yhdistäminen tietokantaan {db_name} epäonnistui",
                    "Käyttäjätunnus tai salasana puuttuu.",
                    level=Qgis.Critical,
                    duration=10)
                return False

        # TODO: Remove the "authcfg" parameter (temporary solution)
        params.pop("authcfg", None)

        self._database = Database(params)
        if not self._database.is_valid:
            self.msgBar("Virhe!",
                        f"Yhdistäminen tietokantaan {db_name} epäonnistui",
                        level=Qgis.Critical,
                        duration=10)
            return False
        return True
