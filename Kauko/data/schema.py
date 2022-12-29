from enum import Enum
from typing import List

from data.csv_handler import get_csv_code

class PlanType(Enum):
    master_plan = "master_plan"
    detailed_plan = "detailed_plan"

class Schema:
    def __init__(
        self,
        municipality: str,
        projection: str,
        plan_type: PlanType,
        project_version: str = None,
        schema_version: str = None,
        scripts_to_execute: List[str] = None,
        views_to_execute: List[str] = None,
    ):
        self._municipality = municipality
        self._projection = projection
        self._plan_type = plan_type
        self._project_version = project_version
        self._schema_version = schema_version
        self._scripts_to_execute = scripts_to_execute or []
        self._views_to_execute = views_to_execute or []
        self._update_project = False

    @property
    def name(self) -> str:
        schema_name = f"{self.municipality.lower()}_{self.projection[5:].lower()}"
        return f"{schema_name}_y".lower() if self.plan_type == PlanType.master_plan else schema_name.lower()

    @property
    def srid(self) -> str:
        return str(get_csv_code("/finnish_projections.csv", self.projection))

    @property
    def municipality(self) -> str:
        return self._municipality

    @municipality.setter
    def municipality(self, value: str):
        self._municipality = value

    @property
    def municipality_code(self) -> str:
        return str(get_csv_code("/municipality_codes.csv", self.municipality)) if self.municipality else None

    @property
    def plan_type(self) -> PlanType:
        return self._plan_type

    @plan_type.setter
    def plan_type(self, value: PlanType):
        self._plan_type = value

    @property
    def project_version(self) -> str:
        return self._project_version

    @project_version.setter
    def project_version(self, value: str):
        self._project_version = value

    @property
    def schema_version(self) -> str:
        return self._schema_version

    @schema_version.setter
    def schema_version(self, value: str):
        self._schema_version = value

    @property
    def scripts_to_execute(self) -> List[str]:
        return self._scripts_to_execute

    @scripts_to_execute.setter
    def scripts_to_execute(self, value: List[str]):
        self._scripts_to_execute = value

    @property
    def views_to_execute(self) -> List[str]:
        return self._views_to_execute

    @views_to_execute.setter
    def views_to_execute(self, value: List[str]):
        self._views_to_execute = value

    @property
    def is_new(self) -> bool:
        return not self.project_version

    @property
    def update_project(self) -> bool:
        return self._update_project

    @update_project.setter
    def update_project(self, value: bool):
        self._update_project = value
