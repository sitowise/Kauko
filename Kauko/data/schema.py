from enum import Enum
from typing import List

from .csv_handler import get_csv_code, get_csv_value


class PlanType(Enum):
    master_plan = "master_plan"
    detailed_plan = "detailed_plan"

class Schema:
    def __init__(
        self,
        plan_type: PlanType,
        municipality_name: str = None,
        municipality_code: str = None,
        projection: str = None,
        srid: str = None,
        project_version: str = None,
        schema_version: str = None,
        scripts_to_execute: List[str] = None,
        views_to_execute: List[str] = None,
    ):
        if not projection and not srid:
            raise ValueError("Either projection or srid must be given")
        if projection and srid:
            raise ValueError("Only one of projection or srid must be given")
        self._srid = None
        self._projection = None
        if projection:
            self.projection = projection
        else:
            self.srid = srid
        if not municipality_code and not municipality_name:
            raise ValueError("Either municipality_code or municipality_name must be given")
        if municipality_code and municipality_name:
            raise ValueError("Only one of municipality_code or municipality_name must be given")
        self._municipality_code = None
        self._municipality_name = None
        if municipality_name:
            self.municipality_name = municipality_name
        else:
            self.municipality_code = municipality_code
        self._plan_type = plan_type
        self._project_version = project_version
        self._schema_version = schema_version
        self._scripts_to_execute = scripts_to_execute or []
        self._views_to_execute = views_to_execute or []
        self._update_project = False

    @property
    def name(self) -> str:
        schema_name = f"{self.municipality_name.lower()}_{self.projection[5:].lower()}"
        return f"{schema_name}_y".lower() if self.plan_type == PlanType.master_plan else schema_name.lower()

    @property
    def srid(self) -> str:
        return self._srid

    @srid.setter
    def srid(self, value: str):
        self._srid = value
        projection = get_csv_value("/finnish_projections.csv", value)
        if self._projection is None or self._projection != projection:
            self._projection = projection

    @property
    def projection(self) -> str:
        return self._projection

    @projection.setter
    def projection(self, value: str):
        self._projection = value
        srid = str(get_csv_code("/finnish_projections.csv", value))
        if self._srid is None or self._srid != srid:
            self._srid = srid

    @property
    def municipality_name(self) -> str:
        return self._municipality_name

    @municipality_name.setter
    def municipality_name(self, value: str):
        self._municipality_name = value
        municipality_code = str(get_csv_code("/municipality_codes.csv", value))
        if self._municipality_code is None or self._municipality_code != municipality_code:
            self._municipality_code = municipality_code


    @property
    def municipality_code(self) -> str:
        return self._municipality_code

    @municipality_code.setter
    def municipality_code(self, value: str):
        self._municipality_code = value
        municipality = get_csv_value("/municipality_codes.csv", value)
        if self._municipality_name is None or self._municipality_name != municipality:
            self._municipality_name = municipality

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
