#!/usr/bin/env python
# -*- coding: utf-8 -*-

import glob
from typing import List

from qgis_plugin_tools.infrastructure.plugin_maker import PluginMaker

"""
#################################################
# Edit the following to match the plugin
#################################################
"""

py_files = [
    fil
    for fil in glob.glob("**/*.py", recursive=True)
    if "test/" not in fil and "test\\" not in fil
]
extras = [
    fil
    for fil in glob.glob("**/*.csv", recursive=True)
    if "test/" not in fil or "test\\" not in fil
]
print(py_files)
print(extras)
locales = ["fi"]
profile = "kaatio"
ui_files = list(glob.glob("**/*.ui", recursive=True))
resources = list(glob.glob("**/*.qrc", recursive=True))
# extra_dirs = ["icons", "data"]
compiled_resources: List[str] = []

PluginMaker(
    py_files=py_files,
    ui_files=ui_files,
    resources=resources,
    #extra_dirs=extra_dirs,
    extras=extras,
    compiled_resources=compiled_resources,
    locales=locales,
    profile=profile,
)