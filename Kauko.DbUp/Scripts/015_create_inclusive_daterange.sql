CREATE TYPE inclusive_daterange AS RANGE (
    SUBTYPE = date,
    INCLUSIVE lower_bound,
    INCLUSIVE upper_bound
);