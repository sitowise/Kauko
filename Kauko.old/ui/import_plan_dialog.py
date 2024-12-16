import logging
import os
from typing import Any, Dict

from qgis.PyQt import QtWidgets, uic
from qgis.gui import QgsFileWidget, QgisInterface


from ..database.database import Database
from ..xml.xml_importer import XMLImporter
from ..constants import KAATIO_API_URL
from ..qgis_plugin_tools.tools.network import post
from ..qgis_plugin_tools.tools.exceptions import QgsPluginNetworkException
from ..qgis_plugin_tools.tools.custom_logging import bar_msg
from .plan_dialog import PlanDialog

FROM_CLASS, _ = uic.loadUiType(os.path.join(
    os.path.dirname(__file__), 'import_plan_dialog.ui'))

LOGGER = logging.getLogger("kauko")

class ImportPlanDialog(QtWidgets.QDialog, FROM_CLASS):

    def __init__(self, iface: QgisInterface, parent=None):
        super(ImportPlanDialog, self).__init__(parent)
        self.setupUi(self)
        self.iface = iface
        self.importFileWidget.fileChanged.connect(
            self.enable_accept_button)
        self.importFileWidget.setStorageMode(QgsFileWidget.StorageMode.GetFile)

    def enable_accept_button(self):
        """Set accept button enabled if file is selected"""
        if self.importFileWidget.filePath() != "":
            self.acceptPushButton.setEnabled(True)
        else:
            self.acceptPushButton.setEnabled(False)

    def import_plan(self, db: Database, schema: str = None) -> Dict[str, Any]:
        """Import selected XML file to Kauko database.

        :return: bar_msg to display to the user after running.
        """
        xml_importer = XMLImporter(db, schema)
        xml_file = self.importFileWidget.filePath()

        # plan_id = self.get_spatial_plan_id()
        # exported_plan = xml_exporter.get_xml(plan_id, local_directory)
        # LOGGER.info('XML-tiedosto luotu', extra=bar_msg(exported_plan, duration=10))
        # try:
        #     xml_response = post(plan_store_url, files=[('file', ("plan.xml", exported_plan, "text/xml"))])
        #     LOGGER.info('Kaavan vienti onnistui!', extra=bar_msg(xml_response, duration=10))
        # except QgsPluginNetworkException as e:
        #    return bar_msg(e.message, duration=10, success=False)
        xml_importer.save_xml(xml_file)
        # LOGGER.info('Vastaus tallennettu', extra=bar_msg(xml_response, duration=10))
        # xml_exporter.update_ids_in_db(xml_response)
        return bar_msg("Kaava tuotu tietokantaan.", duration=10, success=True)
