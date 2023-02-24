import os

from qgis.PyQt.QtGui import QStandardItemModel, QStandardItem

from qgis.PyQt import uic
from qgis.PyQt.QtCore import Qt

from ..database.project_updater.project_updater import ProjectUpdater
from ..database.database_handler import create_schema_objects, update_materialized_views
from .project_dialog import ProjectDialog
from typing import List

FROM_CLASS, _ = uic.loadUiType(os.path.join(
    os.path.dirname(__file__), 'update_project_dialog.ui'))


class InitiateUpdateProjectDialog(ProjectDialog, FROM_CLASS):

    def add_projects(self, projects):
        project_list_view = self.projectsListView
        model = QStandardItemModel()
        for project in projects:
            item = QStandardItem(project)
            check = Qt.Unchecked
            item.setCheckState(check)
            item.setCheckable(True)
            model.appendRow(item)

        project_list_view.setModel(model)

    def get_projects(self) -> List[str]:
        projects = []
        model = self.projectsListView.model()

        for i in range(model.rowCount()):
            item = model.item(i)
            if item.isCheckable() and item.checkState() == Qt.Checked:
                projects.append(item.text())
        return projects

    def update_views(self, db):
        update_materialized_views(db, self.get_projects())

    def update_projects(self, db):
        schemas = create_schema_objects(db, self.get_projects())
        project_updater = ProjectUpdater(db, schemas)
        project_updater.execute()

