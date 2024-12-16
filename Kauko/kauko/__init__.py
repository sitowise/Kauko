import os
from typing import TYPE_CHECKING

from kauko.qgis_plugin_tools.infrastructure.debugging import (
    setup_debugpy,
    setup_ptvsd,  # noqa F401
    setup_pydevd,  # noqa F401
)

if TYPE_CHECKING:
    from qgis.gui import QgisInterface

setup_debugpy()


def classFactory(iface: "QgisInterface"):  # noqa N802
    from kauko.plugin import Plugin

    return Plugin()
