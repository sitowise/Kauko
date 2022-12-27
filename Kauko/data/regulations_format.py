DEFAULT_REGULATION_COLUMNS = ['"Kaavan nimi"', '"Määräys suomeksi"', '"Määräys ruotsiksi"', '"Määräyksen tyyppi"']

DEFAULT_NUMERIC_REGULATION_COLUMNS = ['"Kaavan nimi"', '"Arvo"', '"Määräys suomeksi"', '"Määräys ruotsiksi"',
                                      '"Arvon tyyppi"', '"Kaavamerkintä"']

ZONING_ELEMENT_REGULATION_COLUMNS = DEFAULT_NUMERIC_REGULATION_COLUMNS.append("Kaavamerkintä")

REGULATION_FORMATS = [
    {
        "title": "Kaavan määräykset;;;;;\n".encode('utf-8-sig'),
        "sql_view": "spatial_plan_regulations",
        "columns": DEFAULT_REGULATION_COLUMNS,
        "empty_columns": 2,
        "empty_line": True
    },
    {
        "title": "Maankäyttöalueen määräykset;;;;;\n".encode('utf-8-sig'),
        "sql_view": "zoning_element_regulations",
        "columns": ZONING_ELEMENT_REGULATION_COLUMNS,
        "empty_columns": 1,
        "empty_line": False
    },
    {
        "title": "Maankäyttöalueen numeeriset määräykset;;;;;\n".encode('utf-8-sig'),
        "sql_view": "zoning_element_numeric_values",
        "columns": DEFAULT_NUMERIC_REGULATION_COLUMNS,
        "empty_columns": 0,
        "empty_line": True
    },
    {
        "title": "Kaavan osa-alueen määräykset;;;;;\n".encode('utf-8-sig'),
        "sql_view": "planned_space_regulations",
        "columns": DEFAULT_REGULATION_COLUMNS,
        "empty_columns": 2,
        "empty_line": False
    },
    {
        "title": "Kaavan osa-alueen numeeriset määräykset;;;;;\n".encode('utf-8-sig'),
        "sql_view": "planned_space_numeric_values",
        "columns": DEFAULT_NUMERIC_REGULATION_COLUMNS,
        "empty_columns": 0,
        "empty_line": True
    },
    {
        "title": "Viivamaisen tarkennemerkinnän numeeriset määräykset;;;;;\n".encode('utf-8-sig'),
        "sql_view": "planning_detail_line_numeric_values",
        "columns": DEFAULT_NUMERIC_REGULATION_COLUMNS,
        "empty_columns": 0,
        "empty_line": True
    },
    {
        "title": "Pistemäisen tarkennemerkinnän numeeriset määräykset;;;;;\n".encode('utf-8-sig'),
        "sql_view": "planning_detail_point_numeric_values",
        "columns": DEFAULT_NUMERIC_REGULATION_COLUMNS,
        "empty_columns": 0,
        "empty_line": True
    }
]
