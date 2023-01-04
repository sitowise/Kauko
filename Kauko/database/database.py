from typing import List, Tuple
from xmlrpc.client import Boolean

import psycopg2


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

    def insert(self, query: str) -> Boolean:
        # TODO: Implement error handling
        """Used to insert to database

        :param query: str
        :return: Boolean
        """
        with psycopg2.connect(**self.params) as conn:
            with conn.cursor() as cur:
                cur.execute(query)
                return True

    def select(self, query: str) -> List[Tuple]:
        """Used to select from database

        :param query: str
        :return: List of tuples.
        """
        try:
            with psycopg2.connect(**self.params) as conn:
                with conn.cursor() as cur:
                    cur.execute(query)
                    return cur.fetchall()
        except psycopg2.OperationalError:
            return []

    def get_database_name(self) -> str:
        return self.params["dbname"]
