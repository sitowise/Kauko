import logging
import os
from typing import Any, Dict

from qgis.PyQt import uic
from qgis.gui import QgsFileWidget, QgisInterface


from ..database.database import Database
from ..xml.xml_exporter import XMLExporter
from ..constants import KAATIO_API_URL
from ..qgis_plugin_tools.tools.network import post
from ..qgis_plugin_tools.tools.exceptions import QgsPluginNetworkException
from ..qgis_plugin_tools.tools.custom_logging import bar_msg
from .plan_dialog import PlanDialog

FROM_CLASS, _ = uic.loadUiType(os.path.join(
    os.path.dirname(__file__), 'export_plan_dialog.ui'))

LOGGER = logging.getLogger("kauko")

class ExportPlanDialog(PlanDialog, FROM_CLASS):

    def __init__(self, iface: QgisInterface, parent=None):
        super(ExportPlanDialog, self).__init__(iface, parent)
        self.apiUrlLineEdit.setText(KAATIO_API_URL)
        self.exportFileWidget.setStorageMode(QgsFileWidget.StorageMode.GetDirectory)

    def export_plan(self, db: Database, schema: str = None) -> Dict[str, Any]:
        """Export selected plan to XML API. If successful, returned global ids are saved.

        :return: bar_msg to display to the user after running.
        """
        xml_exporter = XMLExporter(db, schema)
        plan_store_url = self.apiUrlLineEdit.text() + "store"
        local_directory = self.exportFileWidget.filePath()

        plan_id = self.get_spatial_plan_id()
        exported_plan = xml_exporter.get_xml(plan_id, local_directory)
        LOGGER.info('XML-tiedosto luotu', extra=bar_msg(exported_plan, duration=10))
        try:
            xml_response = post(plan_store_url, files=[('file', ("plan.xml", exported_plan, "text/xml"))])
            LOGGER.info('Kaavan vienti onnistui!', extra=bar_msg(xml_response, duration=10))
        except QgsPluginNetworkException as e:
            return bar_msg(e.message, duration=10, success=False)
        xml_exporter.save_response(xml_response, local_directory)
        LOGGER.info('Vastaus tallennettu', extra=bar_msg(xml_response, duration=10))
        xml_exporter.update_plan_in_db(plan_id, xml_response)
        return bar_msg("Tunnisteet tallennettu tietokantaan.", duration=10, success=True)
