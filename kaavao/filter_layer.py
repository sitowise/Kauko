from qgis.core import QgsProject, Qgis
from qgis.utils import iface

from .database.database_handler import get_identifiers_for_plan
from .errors import SchemaError
from .database.database import Database


def clear_layer_filters():
    """Clears subset strings from all the project layers"""
    project = QgsProject().instance()
    file_name = project.fileName()
    if file_name != '':
        layers = QgsProject().instance().mapLayers().values()
        for layer in layers:
            layer.setSubsetString("")
    else:
        iface.messageBar().pushMessage("Virhe!", "Yksikään projekti ei ole avoinna.",
                                       level=Qgis.Warning, duration=5)


def filter_layers_by_spatial_plan_name(project: QgsProject, plan_name, db: Database, schema: str = None):
    """Add filters to layers to show only selected plan"""
    try:
        identifiers = get_identifiers_for_plan(project, plan_name, db, schema)
    except SchemaError:
        iface.messageBar().pushMessage("Virhe!",
                                       "Valittu skeema ei vastaa projektia.",
                                       duration=5, level=Qgis.Warning)
        return

    write_id_layer_filter(project, identifiers, "Kaava")
    write_id_layer_filter(project, identifiers, "Kaavan laatija", "identifier")
    write_id_layer_filter(project, identifiers, "Kaavan tavoite", "identifier")
    write_id_layer_filter(project, identifiers, "Kaavan liite", "identifier")
    write_id_layer_filter(project, identifiers, "Kaavamääräys", "regulative_id")
    write_id_layer_filter(project, identifiers, "Maankäyttöalue")
    write_id_layer_filter(project, identifiers, "Numeerinen arvo", "numeric_value_id")
    write_id_layer_filter(project, identifiers, "Kaavan osa-alue")
    write_id_layer_filter(project, identifiers, "Viivamainen tarkennemerkintä")
    write_id_layer_filter(project, identifiers, "Pistemäinen tarkennemerkintä")
    write_id_layer_filter(project, identifiers, "Selittävä teksti", "identifier")
    write_id_layer_filter(project, identifiers, "Selittävä viiva", "identifier")


def write_id_layer_filter(project, results, layer_name: str,
                          id_field: str = "planning_object_identifier"):
    try:
        layer = project.mapLayersByName(layer_name)[0]
        if len(results[layer_name]) > 0:
            current_subset = layer.subsetString()
            if len(current_subset) == 0 or current_subset == "false":
                layer.setSubsetString(
                    (
                        (
                            '"'
                            + id_field
                            + "\" IN ("
                            + ", ".join(
                                "'" + str(layer_id) + "'"
                                for layer_id in results[layer_name]
                            )
                        )
                        + ")"
                    )
                )

            elif current_subset.find(id_field) >= 0:
                start = current_subset.find(id_field) + len(id_field + '" IN ("')
                new_items = ", ".join("'" + layer_id + "'" for layer_id in results[layer_name])
                if (current_subset.find(id_field + '" IN("")')) != -1:  # Check if filter is not empty
                    new_items = new_items + ", "
                layer.setSubsetString(current_subset[:start] + new_items + current_subset[start:])
            else:
                new_subset = '"' + id_field + "\" IN (" + ", ".join(
                    ["'" + layer_id + "'" for layer_id in
                     results[layer_name]]) + ")"
                layer.setSubsetString(current_subset + " AND " + new_subset)
        else:
            layer.setSubsetString("false")
    except (KeyError, IndexError):
        iface.messageBar().pushMessage("Virhe",
                                       "Tasoa " + layer_name + " ei löytynyt",
                                       duration=5, level=Qgis.Warning)


def write_layer_validity_filter(validity: int):
    validity_layers = [
        "Kaava", "Maankäyttöalue", "Kaavan osa-alue", "Viivamainen tarkennemerkintä", "Pistemäinen tarkennemerkintä",
        "Selittävä viiva", "Selittävä teksti", "Kaavan liite"
    ]
    for layer_name in validity_layers:
        try:
            layer = QgsProject().instance().mapLayersByName(layer_name)
            current_subset = layer.subsetString()
            if len(current_subset) == 0 or current_subset == "false":
                layer.setSubsetString(
                    '"validity" = ' + str(validity)
                )
            elif current_subset.find("validity") >= 0:
                replace_index = current_subset.find("validity") + len('validity" = ')
                layer.setSubsetString(current_subset[:replace_index] + str(validity) +
                                      current_subset[replace_index + 1:])
            else:
                new_subset = '"validity" = ' + str(validity)
                layer.setSubsetString(current_subset + " AND " + new_subset)
        except (KeyError, IndexError):
            iface.messageBar().pushMessage("Virhe",
                                           "Tasoa " + layer_name + " ei löytynyt",
                                           duration=5, level=Qgis.Warning)
