from typing import Dict, List, Tuple

import psycopg2
import psycopg2.extras


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

    def insert(self, query: str) -> bool:
        # TODO: Implement error handling
        # TODO: Implement limiting query to insert
        # TODO: Sanitize query to prevent sql injection in db strings
        """Used to insert to database

        :param query: str
        :return: Boolean
        """
        with psycopg2.connect(**self.params) as conn:
            with conn.cursor(cursor_factory=psycopg2.extras.DictCursor) as cur:
                cur.execute(query)
                return True

    def update(self, query: str) -> bool:
        # TODO: Implement error handling
        # TODO: Implement limiting query to update
        # TODO: Sanitize query to prevent sql injection in db strings
        """Used to update to database

        :param query: str
        :return: Boolean
        """
        with psycopg2.connect(**self.params) as conn:
            with conn.cursor(cursor_factory=psycopg2.extras.DictCursor) as cur:
                cur.execute(query)
                return True

    def select(self, query: str) -> List[psycopg2.extras.DictRow]:
        # TODO: Implement limiting query to select
        # TODO: Sanitize query to prevent sql injection in db strings
        """Used to select from database

        :param query: str
        :return: List of tuples.
        """
        try:
            with psycopg2.connect(**self.params) as conn:
                with conn.cursor(cursor_factory=psycopg2.extras.DictCursor) as cur:
                    cur.execute(query)
                    return cur.fetchall()
        except psycopg2.OperationalError:
            return []

    def get_database_name(self) -> str:
        return self.params["dbname"]
