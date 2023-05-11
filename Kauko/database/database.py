import logging
from typing import Dict, List, Tuple

import psycopg2
import psycopg2.extras
from psycopg2.extensions import register_adapter
from psycopg2.sql import Composed


LOGGER = logging.getLogger("kauko")


class IllegalOperation(Exception):
    pass


# This is needed for insert to automatically cast dict to json
register_adapter(dict, psycopg2.extras.Json)


class Database:
    """Tools to control database"""

    def __init__(self, parameters: dict):
        self.params = parameters

    def is_valid(self) -> bool:
        """Check whether database connection is successful

        :return: bool
        """
        try:
            with psycopg2.connect(**self.params):
                return True
        except psycopg2.OperationalError:
            return False

    def insert(self, query: Composed | str, vars: Tuple = ()) -> bool:
        # TODO: Implement error handling
        # TODO: Implement limiting query to insert
        """Used to insert to database

        :param query: Composed | str
        :param vars: Values to pass to query
        :return: Boolean
        """
        LOGGER.info("trying to insert")
        LOGGER.info(query)
        LOGGER.info(vars)
        with psycopg2.connect(**self.params) as conn:
            with conn.cursor(cursor_factory=psycopg2.extras.DictCursor) as cur:
                # if not cur.mogrify(query, vars).lower().startswith("insert"):
                #     raise IllegalOperation()
                if not vars:
                    cur.execute(query)
                else:
                    cur.execute(query, vars)
                return True

    def insert_with_return(self, query: str) -> List[psycopg2.extras.DictRow]:
        try:
            with psycopg2.connect(**self.params) as conn:
                with conn.cursor(cursor_factory=psycopg2.extras.DictCursor) as cur:
                    cur.execute(query)
                    return cur.fetchall()
        except psycopg2.OperationalError:
            return []

    def update(self, query: Composed | str, vars: Tuple = ()) -> bool:
        # TODO: Implement error handling
        # TODO: Implement limiting query to update
        """Used to update to database

        :param query: Composed | str
        :param vars: Values to pass to query
        :return: Boolean
        """
        LOGGER.info("trying to update")
        LOGGER.info(query)
        LOGGER.info(vars)
        with psycopg2.connect(**self.params) as conn:
            with conn.cursor(cursor_factory=psycopg2.extras.DictCursor) as cur:
                if not vars:
                    cur.execute(query)
                else:
                    cur.execute(query, vars)
                return True

    def select(self, query: str) -> List[psycopg2.extras.DictRow]:
        # TODO: Sanitize query to prevent sql injection in db strings
        """Used to select from database

        :param query: str
        :return: List of tuples.
        """
        if not query.lower().startswith("select"):
            raise IllegalOperation()
        try:
            with psycopg2.connect(**self.params) as conn:
                with conn.cursor(cursor_factory=psycopg2.extras.DictCursor) as cur:
                    cur.execute(query)
                    return cur.fetchall()
        except psycopg2.OperationalError:
            return []

    def get_database_name(self) -> str:
        return self.params["dbname"]
