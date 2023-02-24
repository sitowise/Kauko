import os

from qgis.PyQt import uic
from ..project_handler import open_project
from .project_dialog import ProjectDialog

FROM_CLASS, _ = uic.loadUiType(os.path.join(
    os.path.dirname(__file__), 'open_project_dialog.ui'))

class InitiateOpenProjectDialog(ProjectDialog, FROM_CLASS):

    def open_project(self):
        open_project(self.get_project())
