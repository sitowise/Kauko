import csv
import os

from typing import List

from qgis.core import Qgis, QgsMessageLog

from ..exceptions import SpatialNotFoundException
from ..constants import SPATIALREFSYS

# Create function that takes a filename of a csv file and returns a list of dicts

def logger(message: str, header:str, level=Qgis.Info) -> None:
    """Used to log messages to QGIS log

    :param message: str
    :param header: str
    :param level: int
    :return: None
    """
    QgsMessageLog.logMessage(message, header, level)

def read_csv(filename: str) -> List[dict]:
    """Used to read csv file and convert it to list of dicts

    :param filename: str
    :return: list of dicts
    """

    csv_file = []
    try:
        with open(os.path.dirname(os.path.abspath(__file__)) + filename,
                 newline='') as csvfile:
            csv_reader = csv.DictReader(csvfile, delimiter=',')
            csv_file.extend(
                {'code': row['code'], 'name': row['name']}
                for row in csv_reader
            )
    except FileNotFoundError:
        logger(f'File not found: {filename}', 'CSV Handler', Qgis.Critical)
    except PermissionError:
        logger(f'Permission denied: {filename}', 'CSV Handler', Qgis.Critical)
    except csv.Error as e:
        logger(f'Error reading csv file: {filename}', 'CSV Handler', Qgis.Critical)
        logger(f'Error: {e}', 'CSV Handler', Qgis.Critical)
    except Exception:
        logger(f'Unknown error reading csv file: {filename}', 'CSV Handler', Qgis.Critical)
    return csv_file


def get_csv_names(filename: str) -> list:
    """Used to get values from the csv codelist

    :param filename: str
    :return: list
    """
    csv_file = read_csv(filename)
    return [row['name'] for row in csv_file]


def get_csv_code(filename: str, name: str) -> str:
    """Used to get the key from the csv codelist for given value

    :param filename: str
    :param name: str
    :return: str
    """
    csv_file = read_csv(filename)
    for row in csv_file:
        if name == row['name']:
            return row['code']


def read_spatial_ref_csv(srid):
    try:
        with open(os.path.dirname(os.path.abspath(__file__)) + '/spatialref.csv', newline='') as csvfile:
            csv_reader = csv.DictReader(csvfile, delimiter=';')
            for row in csv_reader:
                if row['srid'] == srid:
                    return row
        raise SpatialNotFoundException()
    except OSError:
        # TODO
        pass


def format_spatial_ref(srid):
    spatialref = SPATIALREFSYS
    spatialdata = read_spatial_ref_csv(srid)

    spatialref = spatialref.replace("WKT", spatialdata["wkt"])
    spatialref = spatialref.replace("PROJ4", spatialdata["proj4"])
    spatialref = spatialref.replace("SRSID", spatialdata["srsid"])
    spatialref = spatialref.replace("SRID", spatialdata["srid"])
    spatialref = spatialref.replace("AUTHID", spatialdata["authid"])
    spatialref = spatialref.replace("DESCRIPTION", spatialdata["description"])
    spatialref = spatialref.replace("PROJECTIONACRONYM", spatialdata["projectionacronym"])
    spatialref = spatialref.replace("ELLIPSOIDACRONYM", spatialdata["ellipsoidacronym"])
    spatialref = spatialref.replace("GEOGRAPHICFLAG", spatialdata["geographicflag"])

    return spatialref
