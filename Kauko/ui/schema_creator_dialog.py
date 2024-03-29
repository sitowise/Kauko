from qgis.PyQt import uic
from qgis.gui import QgisInterface

from ..data.csv_handler import *
from ..database.database_handler import create_new_schema_and_project
from .project_dialog import ProjectDialog

FROM_CLASS, _ = uic.loadUiType(os.path.join(
    os.path.dirname(__file__), 'schema_creator_dialog.ui'))


class InitiateSchemaDialog(ProjectDialog, FROM_CLASS):

    def __init__(self, iface: QgisInterface, parent=None):

        super(InitiateSchemaDialog, self).__init__(parent)
        self.add_landAdminAuthComboBox_items()
        self.add_projComboBox_items()

    def add_landAdminAuthComboBox_items(self):
        """Add names of municipalities from municipality codelist to combobox"""
        self.landAdminAuthComboBox.clear()
        municipalities = get_csv_names('/municipality_codes.csv')
        for municipality in municipalities:
            self.landAdminAuthComboBox.addItem(municipality)

    def add_projComboBox_items(self):
        """Add name of projections from projection codelist to combobox"""
        self.projComboBox.clear()
        projections = get_csv_names("/finnish_projections.csv")
        for proj in projections:
            self.projComboBox.addItem(proj)

    def get_landAdminAuth(self) -> str:
        return self.landAdminAuthComboBox.currentText()

    def get_projection(self) -> str:
        return self.projComboBox.currentText()

    def get_landAdminAuth_code(self) -> str:
        return get_csv_code('/municipality_codes.csv', self.get_landAdminAuth())

    def get_projection_code(self) -> str:
        return get_csv_code('/finnish_projections.csv', self.get_projection())

    def create_detailed_plan(self) -> bool:
        return self.detailedPlanCheckBox.isChecked()

    def create_master_plan(self) -> bool:
        return self.masterPlanCheckBox.isChecked()

    def create_schema(self, db):
        projection = self.get_projection()
        municipality = self.get_landAdminAuth()
        create_new_schema_and_project(projection, municipality, db, self.create_detailed_plan(), self.create_master_plan())
