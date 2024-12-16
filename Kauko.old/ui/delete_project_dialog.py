import os

from qgis.PyQt import uic
from .project_dialog import ProjectDialog

from ..database.database import Database
from ..database.database_handler import delete_schema_and_project

FROM_CLASS, _ = uic.loadUiType(os.path.join(
    os.path.dirname(__file__), 'delete_project_dialog.ui'))


class InitiateDeleteProjectDialog(ProjectDialog, FROM_CLASS):

    def delete_project(self, db: Database) -> bool:
        return delete_schema_and_project(db, self.get_project())
