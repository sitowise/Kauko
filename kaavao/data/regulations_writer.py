from qgis.core import Qgis
from qgis.utils import iface

from typing import List

from .regulations_format import REGULATION_FORMATS
from ..data.tools import query_results_to_str_list
from ..database.database_handler import get_regulations


def write_regulations_file(db, spatial_plan_name, schema, file_path) -> None:
    """Used to write csv file containing all regular and numeric regulations for given spatial plan

    Output csv contains 6 columns so the format will be "a;b;c;d;e;f". File should be written using 'utf-8-sig'
    encoding so e.g. excel will understand scandinavian letters.
    """
    try:
        with open(file_path, 'wb') as output_file:
            empty_line = ";;;;;\n"
            empty_line = empty_line.encode('utf-8-sig')

            def write_regulations(regulations_to_write: List[tuple]):
                """Used to write sql results to output csv file.

                :param regulations_to_write: Sql results in list of tuples
                :return: None
                """
                regulations_to_write = query_results_to_str_list(
                    regulations_to_write)
                try:
                    for regulation in regulations_to_write:
                        line = ';'.join(regulation) + ";" + '\n'
                        line = line.encode('utf-8-sig')
                        output_file.write(line)
                    output_file.write(empty_line)  # Blank line
                except TypeError:
                    output_file.write(empty_line)  # Blank line

            for regulation_format in REGULATION_FORMATS:
                regulations = get_regulations(db, regulation_format["sql_view"], spatial_plan_name,
                                              regulation_format["columns"], schema)
                output_file.write(regulation_format["title"])
                output_file.write((';'.join(regulation_format["columns"]).replace('"', '') +
                                   regulation_format["empty_columns"] * ";").encode('utf-8-sig'))
                write_regulations(regulations)
                if regulation_format["empty_line"]:
                    output_file.write(empty_line)

    except OSError:
        iface.messageBar().pushMessage("Virhe", "Tiedoston kirjoittaminen epäonnistui.", level=Qgis.Critical)
