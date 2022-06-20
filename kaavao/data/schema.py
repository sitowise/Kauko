class Schema:
    def __init__(
    self, name: str, srid: int, municipality: int, combination: bool
    ) -> None:
        self.__name = name
        self.__srid = srid
        self.__municipality = municipality
        self.__combination = combination

    @property
    def name(self):
        return self.__name
  
    @property
    def srid(self):
        return self.__srid

    @property
    def municipality(self):
        return self.__municipality

    @property
    def combination(self):
        return self.__combination
