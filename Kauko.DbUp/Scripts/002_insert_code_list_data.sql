--
-- PostgreSQL database dump
--

-- Dumped from database version 13.14 (Ubuntu 13.14-1.pgdg20.04+1)
-- Dumped by pg_dump version 15.5

--
-- Name: code_url_trigger(); Type: FUNCTION; Schema: code_lists; Owner: -
--

CREATE FUNCTION code_lists.code_url_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  BEGIN
    IF TG_NARGS > 1 THEN
      RAISE EXCEPTION 'Too many arguments on code_url_trigger';
    END IF;
    NEW.uri := TG_ARGV[0] || NEW.codevalue;
    RETURN NEW;
  END;
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: bindingness_kind; Type: TABLE; Schema: code_lists; Owner: -
--

CREATE TABLE code_lists.bindingness_kind (
    id integer NOT NULL,
    codevalue character varying(3) NOT NULL,
    uri character varying(255) NOT NULL,
    preflabel_fi character varying NOT NULL,
    description_fi character varying
);


--
-- Name: bindingness_kind_id_seq; Type: SEQUENCE; Schema: code_lists; Owner: -
--

CREATE SEQUENCE code_lists.bindingness_kind_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bindingness_kind_id_seq; Type: SEQUENCE OWNED BY; Schema: code_lists; Owner: -
--

ALTER SEQUENCE code_lists.bindingness_kind_id_seq OWNED BY code_lists.bindingness_kind.id;


--
-- Name: describing_line_type; Type: TABLE; Schema: code_lists; Owner: -
--

CREATE TABLE code_lists.describing_line_type (
    identifier integer NOT NULL,
    value integer NOT NULL,
    description character varying NOT NULL
);


--
-- Name: describing_line_type_identifier_seq; Type: SEQUENCE; Schema: code_lists; Owner: -
--

CREATE SEQUENCE code_lists.describing_line_type_identifier_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: describing_line_type_identifier_seq; Type: SEQUENCE OWNED BY; Schema: code_lists; Owner: -
--

ALTER SEQUENCE code_lists.describing_line_type_identifier_seq OWNED BY code_lists.describing_line_type.identifier;


--
-- Name: detail_plan_addition_information_kind; Type: TABLE; Schema: code_lists; Owner: -
--

CREATE TABLE code_lists.detail_plan_addition_information_kind (
    id integer NOT NULL,
    codevalue character varying(3) NOT NULL,
    uri character varying(255) NOT NULL,
    preflabel_fi character varying NOT NULL,
    preflabel_sv character varying,
    definition_fi character varying,
    definition_sv character varying,
    description_fi character varying,
    description_sv character varying
);


--
-- Name: detail_plan_addition_information_kind_id_seq; Type: SEQUENCE; Schema: code_lists; Owner: -
--

CREATE SEQUENCE code_lists.detail_plan_addition_information_kind_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: detail_plan_addition_information_kind_id_seq; Type: SEQUENCE OWNED BY; Schema: code_lists; Owner: -
--

ALTER SEQUENCE code_lists.detail_plan_addition_information_kind_id_seq OWNED BY code_lists.detail_plan_addition_information_kind.id;


--
-- Name: detail_plan_regulation_kind; Type: TABLE; Schema: code_lists; Owner: -
--

CREATE TABLE code_lists.detail_plan_regulation_kind (
    id integer NOT NULL,
    codevalue character varying NOT NULL,
    uri character varying(255) NOT NULL,
    preflabel_fi character varying NOT NULL,
    preflabel_sv character varying,
    description_fi character varying,
    shortname character varying,
    main_class character varying NOT NULL,
    sub_class character varying
);


--
-- Name: detail_plan_regulation_kind_id_seq; Type: SEQUENCE; Schema: code_lists; Owner: -
--

CREATE SEQUENCE code_lists.detail_plan_regulation_kind_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: detail_plan_regulation_kind_id_seq; Type: SEQUENCE OWNED BY; Schema: code_lists; Owner: -
--

ALTER SEQUENCE code_lists.detail_plan_regulation_kind_id_seq OWNED BY code_lists.detail_plan_regulation_kind.id;


--
-- Name: detail_plan_theme; Type: TABLE; Schema: code_lists; Owner: -
--

CREATE TABLE code_lists.detail_plan_theme (
    id integer NOT NULL,
    codevalue character varying(3) NOT NULL,
    uri character varying(255) NOT NULL,
    preflabel_fi character varying NOT NULL,
    preflabel_sv character varying,
    definition_fi character varying,
    definition_sv character varying
);


--
-- Name: detail_plan_theme_id_seq; Type: SEQUENCE; Schema: code_lists; Owner: -
--

CREATE SEQUENCE code_lists.detail_plan_theme_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: detail_plan_theme_id_seq; Type: SEQUENCE OWNED BY; Schema: code_lists; Owner: -
--

ALTER SEQUENCE code_lists.detail_plan_theme_id_seq OWNED BY code_lists.detail_plan_theme.id;


--
-- Name: digital_origin_kind; Type: TABLE; Schema: code_lists; Owner: -
--

CREATE TABLE code_lists.digital_origin_kind (
    id integer NOT NULL,
    codevalue character varying(3) NOT NULL,
    uri character varying(255) NOT NULL,
    preflabel_fi character varying NOT NULL
);


--
-- Name: digital_origin_kind_id_seq; Type: SEQUENCE; Schema: code_lists; Owner: -
--

CREATE SEQUENCE code_lists.digital_origin_kind_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: digital_origin_kind_id_seq; Type: SEQUENCE OWNED BY; Schema: code_lists; Owner: -
--

ALTER SEQUENCE code_lists.digital_origin_kind_id_seq OWNED BY code_lists.digital_origin_kind.id;


--
-- Name: document_kind; Type: TABLE; Schema: code_lists; Owner: -
--

CREATE TABLE code_lists.document_kind (
    id integer NOT NULL,
    codevalue character varying(2) NOT NULL,
    uri character varying(255) NOT NULL,
    preflabel_fi character varying NOT NULL,
    preflabel_sv character varying,
    definition_fi character varying,
    description_fi character varying
);


--
-- Name: document_kind_id_seq; Type: SEQUENCE; Schema: code_lists; Owner: -
--

CREATE SEQUENCE code_lists.document_kind_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: document_kind_id_seq; Type: SEQUENCE OWNED BY; Schema: code_lists; Owner: -
--

ALTER SEQUENCE code_lists.document_kind_id_seq OWNED BY code_lists.document_kind.id;


--
-- Name: finnish_area_type; Type: TABLE; Schema: code_lists; Owner: -
--

CREATE TABLE code_lists.finnish_area_type (
    identifier integer NOT NULL,
    value integer NOT NULL,
    description character varying NOT NULL
);


--
-- Name: finnish_area_type_identifier_seq; Type: SEQUENCE; Schema: code_lists; Owner: -
--

CREATE SEQUENCE code_lists.finnish_area_type_identifier_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: finnish_area_type_identifier_seq; Type: SEQUENCE OWNED BY; Schema: code_lists; Owner: -
--

ALTER SEQUENCE code_lists.finnish_area_type_identifier_seq OWNED BY code_lists.finnish_area_type.identifier;


--
-- Name: finnish_document_role; Type: TABLE; Schema: code_lists; Owner: -
--

CREATE TABLE code_lists.finnish_document_role (
    identifier integer NOT NULL,
    value integer NOT NULL,
    description character varying NOT NULL
);


--
-- Name: finnish_document_role_identifier_seq; Type: SEQUENCE; Schema: code_lists; Owner: -
--

CREATE SEQUENCE code_lists.finnish_document_role_identifier_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: finnish_document_role_identifier_seq; Type: SEQUENCE OWNED BY; Schema: code_lists; Owner: -
--

ALTER SEQUENCE code_lists.finnish_document_role_identifier_seq OWNED BY code_lists.finnish_document_role.identifier;


--
-- Name: finnish_document_type; Type: TABLE; Schema: code_lists; Owner: -
--

CREATE TABLE code_lists.finnish_document_type (
    identifier integer NOT NULL,
    value integer NOT NULL,
    description character varying NOT NULL,
    codevalue character varying
);


--
-- Name: finnish_document_type_identifier_seq; Type: SEQUENCE; Schema: code_lists; Owner: -
--

CREATE SEQUENCE code_lists.finnish_document_type_identifier_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: finnish_document_type_identifier_seq; Type: SEQUENCE OWNED BY; Schema: code_lists; Owner: -
--

ALTER SEQUENCE code_lists.finnish_document_type_identifier_seq OWNED BY code_lists.finnish_document_type.identifier;


--
-- Name: finnish_informative_feature_type; Type: TABLE; Schema: code_lists; Owner: -
--

CREATE TABLE code_lists.finnish_informative_feature_type (
    identifier integer NOT NULL,
    value integer NOT NULL,
    description character varying NOT NULL
);


--
-- Name: finnish_informative_feature_type_identifier_seq; Type: SEQUENCE; Schema: code_lists; Owner: -
--

CREATE SEQUENCE code_lists.finnish_informative_feature_type_identifier_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: finnish_informative_feature_type_identifier_seq; Type: SEQUENCE OWNED BY; Schema: code_lists; Owner: -
--

ALTER SEQUENCE code_lists.finnish_informative_feature_type_identifier_seq OWNED BY code_lists.finnish_informative_feature_type.identifier;


--
-- Name: finnish_land_use_kind; Type: TABLE; Schema: code_lists; Owner: -
--

CREATE TABLE code_lists.finnish_land_use_kind (
    identifier integer NOT NULL,
    code character varying NOT NULL,
    "group" character varying NOT NULL,
    label character varying NOT NULL,
    mark character varying,
    codevalue character varying,
    uri character varying
);


--
-- Name: finnish_land_use_kind_identifier_seq; Type: SEQUENCE; Schema: code_lists; Owner: -
--

CREATE SEQUENCE code_lists.finnish_land_use_kind_identifier_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: finnish_land_use_kind_identifier_seq; Type: SEQUENCE OWNED BY; Schema: code_lists; Owner: -
--

ALTER SEQUENCE code_lists.finnish_land_use_kind_identifier_seq OWNED BY code_lists.finnish_land_use_kind.identifier;


--
-- Name: finnish_language; Type: TABLE; Schema: code_lists; Owner: -
--

CREATE TABLE code_lists.finnish_language (
    identifier integer NOT NULL,
    value integer NOT NULL,
    description character varying NOT NULL
);


--
-- Name: finnish_language_identifier_seq; Type: SEQUENCE; Schema: code_lists; Owner: -
--

CREATE SEQUENCE code_lists.finnish_language_identifier_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: finnish_language_identifier_seq; Type: SEQUENCE OWNED BY; Schema: code_lists; Owner: -
--

ALTER SEQUENCE code_lists.finnish_language_identifier_seq OWNED BY code_lists.finnish_language.identifier;


--
-- Name: finnish_municipalities; Type: TABLE; Schema: code_lists; Owner: -
--

CREATE TABLE code_lists.finnish_municipalities (
    id integer NOT NULL,
    codevalue character varying(3) NOT NULL,
    uri character varying(255) NOT NULL,
    preflabel_fi character varying NOT NULL,
    preflabel_sv character varying
);


--
-- Name: finnish_municipalities_id_seq; Type: SEQUENCE; Schema: code_lists; Owner: -
--

CREATE SEQUENCE code_lists.finnish_municipalities_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: finnish_municipalities_id_seq; Type: SEQUENCE OWNED BY; Schema: code_lists; Owner: -
--

ALTER SEQUENCE code_lists.finnish_municipalities_id_seq OWNED BY code_lists.finnish_municipalities.id;


--
-- Name: finnish_municipality_codes; Type: TABLE; Schema: code_lists; Owner: -
--

CREATE TABLE code_lists.finnish_municipality_codes (
    identifier integer NOT NULL,
    code character varying NOT NULL,
    name character varying NOT NULL
);


--
-- Name: finnish_municipality_codes_identifier_seq; Type: SEQUENCE; Schema: code_lists; Owner: -
--

CREATE SEQUENCE code_lists.finnish_municipality_codes_identifier_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: finnish_municipality_codes_identifier_seq; Type: SEQUENCE OWNED BY; Schema: code_lists; Owner: -
--

ALTER SEQUENCE code_lists.finnish_municipality_codes_identifier_seq OWNED BY code_lists.finnish_municipality_codes.identifier;


--
-- Name: finnish_numeric_value; Type: TABLE; Schema: code_lists; Owner: -
--

CREATE TABLE code_lists.finnish_numeric_value (
    identifier integer NOT NULL,
    value integer NOT NULL,
    description character varying NOT NULL,
    type character varying,
    codevalue character varying,
    uri character varying
);


--
-- Name: finnish_numeric_value_identifier_seq; Type: SEQUENCE; Schema: code_lists; Owner: -
--

CREATE SEQUENCE code_lists.finnish_numeric_value_identifier_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: finnish_numeric_value_identifier_seq; Type: SEQUENCE OWNED BY; Schema: code_lists; Owner: -
--

ALTER SEQUENCE code_lists.finnish_numeric_value_identifier_seq OWNED BY code_lists.finnish_numeric_value.identifier;


--
-- Name: finnish_ordinance_process; Type: TABLE; Schema: code_lists; Owner: -
--

CREATE TABLE code_lists.finnish_ordinance_process (
    identifier integer NOT NULL,
    value integer NOT NULL,
    description character varying NOT NULL
);


--
-- Name: finnish_ordinance_process_identifier_seq; Type: SEQUENCE; Schema: code_lists; Owner: -
--

CREATE SEQUENCE code_lists.finnish_ordinance_process_identifier_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: finnish_ordinance_process_identifier_seq; Type: SEQUENCE OWNED BY; Schema: code_lists; Owner: -
--

ALTER SEQUENCE code_lists.finnish_ordinance_process_identifier_seq OWNED BY code_lists.finnish_ordinance_process.identifier;


--
-- Name: finnish_ordinance_process_step; Type: TABLE; Schema: code_lists; Owner: -
--

CREATE TABLE code_lists.finnish_ordinance_process_step (
    identifier integer NOT NULL,
    value integer NOT NULL,
    description character varying NOT NULL
);


--
-- Name: finnish_ordinance_process_step_identifier_seq; Type: SEQUENCE; Schema: code_lists; Owner: -
--

CREATE SEQUENCE code_lists.finnish_ordinance_process_step_identifier_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: finnish_ordinance_process_step_identifier_seq; Type: SEQUENCE OWNED BY; Schema: code_lists; Owner: -
--

ALTER SEQUENCE code_lists.finnish_ordinance_process_step_identifier_seq OWNED BY code_lists.finnish_ordinance_process_step.identifier;


--
-- Name: finnish_plan_description; Type: TABLE; Schema: code_lists; Owner: -
--

CREATE TABLE code_lists.finnish_plan_description (
    identifier integer NOT NULL,
    value character varying NOT NULL,
    description character varying NOT NULL
);


--
-- Name: finnish_plan_description_identifier_seq; Type: SEQUENCE; Schema: code_lists; Owner: -
--

CREATE SEQUENCE code_lists.finnish_plan_description_identifier_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: finnish_plan_description_identifier_seq; Type: SEQUENCE OWNED BY; Schema: code_lists; Owner: -
--

ALTER SEQUENCE code_lists.finnish_plan_description_identifier_seq OWNED BY code_lists.finnish_plan_description.identifier;


--
-- Name: finnish_planned_space_type; Type: TABLE; Schema: code_lists; Owner: -
--

CREATE TABLE code_lists.finnish_planned_space_type (
    identifier integer NOT NULL,
    value integer NOT NULL,
    description character varying NOT NULL
);


--
-- Name: finnish_planned_space_type_identifier_seq; Type: SEQUENCE; Schema: code_lists; Owner: -
--

CREATE SEQUENCE code_lists.finnish_planned_space_type_identifier_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: finnish_planned_space_type_identifier_seq; Type: SEQUENCE OWNED BY; Schema: code_lists; Owner: -
--

ALTER SEQUENCE code_lists.finnish_planned_space_type_identifier_seq OWNED BY code_lists.finnish_planned_space_type.identifier;


--
-- Name: finnish_planning_detail_line_type; Type: TABLE; Schema: code_lists; Owner: -
--

CREATE TABLE code_lists.finnish_planning_detail_line_type (
    identifier integer NOT NULL,
    value integer NOT NULL,
    description character varying NOT NULL
);


--
-- Name: finnish_planning_detail_line_type_identifier_seq; Type: SEQUENCE; Schema: code_lists; Owner: -
--

CREATE SEQUENCE code_lists.finnish_planning_detail_line_type_identifier_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: finnish_planning_detail_line_type_identifier_seq; Type: SEQUENCE OWNED BY; Schema: code_lists; Owner: -
--

ALTER SEQUENCE code_lists.finnish_planning_detail_line_type_identifier_seq OWNED BY code_lists.finnish_planning_detail_line_type.identifier;


--
-- Name: finnish_planning_detail_point_type; Type: TABLE; Schema: code_lists; Owner: -
--

CREATE TABLE code_lists.finnish_planning_detail_point_type (
    identifier integer NOT NULL,
    value integer NOT NULL,
    description character varying NOT NULL
);


--
-- Name: finnish_planning_detail_point_type_identifier_seq; Type: SEQUENCE; Schema: code_lists; Owner: -
--

CREATE SEQUENCE code_lists.finnish_planning_detail_point_type_identifier_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: finnish_planning_detail_point_type_identifier_seq; Type: SEQUENCE OWNED BY; Schema: code_lists; Owner: -
--

ALTER SEQUENCE code_lists.finnish_planning_detail_point_type_identifier_seq OWNED BY code_lists.finnish_planning_detail_point_type.identifier;


--
-- Name: finnish_regulative_text_type; Type: TABLE; Schema: code_lists; Owner: -
--

CREATE TABLE code_lists.finnish_regulative_text_type (
    identifier integer NOT NULL,
    value integer NOT NULL,
    description character varying NOT NULL,
    codevalue character varying,
    uri character varying
);


--
-- Name: finnish_regulative_text_type_identifier_seq; Type: SEQUENCE; Schema: code_lists; Owner: -
--

CREATE SEQUENCE code_lists.finnish_regulative_text_type_identifier_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: finnish_regulative_text_type_identifier_seq; Type: SEQUENCE OWNED BY; Schema: code_lists; Owner: -
--

ALTER SEQUENCE code_lists.finnish_regulative_text_type_identifier_seq OWNED BY code_lists.finnish_regulative_text_type.identifier;


--
-- Name: finnish_spatial_plan_approved_by; Type: TABLE; Schema: code_lists; Owner: -
--

CREATE TABLE code_lists.finnish_spatial_plan_approved_by (
    identifier integer NOT NULL,
    value integer NOT NULL,
    description character varying NOT NULL
);


--
-- Name: finnish_spatial_plan_approved_by_identifier_seq; Type: SEQUENCE; Schema: code_lists; Owner: -
--

CREATE SEQUENCE code_lists.finnish_spatial_plan_approved_by_identifier_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: finnish_spatial_plan_approved_by_identifier_seq; Type: SEQUENCE OWNED BY; Schema: code_lists; Owner: -
--

ALTER SEQUENCE code_lists.finnish_spatial_plan_approved_by_identifier_seq OWNED BY code_lists.finnish_spatial_plan_approved_by.identifier;


--
-- Name: finnish_spatial_plan_level; Type: TABLE; Schema: code_lists; Owner: -
--

CREATE TABLE code_lists.finnish_spatial_plan_level (
    identifier integer NOT NULL,
    value integer NOT NULL,
    description character varying NOT NULL
);


--
-- Name: finnish_spatial_plan_level_identifier_seq; Type: SEQUENCE; Schema: code_lists; Owner: -
--

CREATE SEQUENCE code_lists.finnish_spatial_plan_level_identifier_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: finnish_spatial_plan_level_identifier_seq; Type: SEQUENCE OWNED BY; Schema: code_lists; Owner: -
--

ALTER SEQUENCE code_lists.finnish_spatial_plan_level_identifier_seq OWNED BY code_lists.finnish_spatial_plan_level.identifier;


--
-- Name: finnish_spatial_plan_origin; Type: TABLE; Schema: code_lists; Owner: -
--

CREATE TABLE code_lists.finnish_spatial_plan_origin (
    identifier integer NOT NULL,
    value integer NOT NULL,
    description character varying NOT NULL,
    codevalue character varying
);


--
-- Name: finnish_spatial_plan_origin_identifier_seq; Type: SEQUENCE; Schema: code_lists; Owner: -
--

CREATE SEQUENCE code_lists.finnish_spatial_plan_origin_identifier_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: finnish_spatial_plan_origin_identifier_seq; Type: SEQUENCE OWNED BY; Schema: code_lists; Owner: -
--

ALTER SEQUENCE code_lists.finnish_spatial_plan_origin_identifier_seq OWNED BY code_lists.finnish_spatial_plan_origin.identifier;


--
-- Name: finnish_spatial_plan_status; Type: TABLE; Schema: code_lists; Owner: -
--

CREATE TABLE code_lists.finnish_spatial_plan_status (
    identifier integer NOT NULL,
    value integer NOT NULL,
    description character varying NOT NULL,
    codevalue character varying
);


--
-- Name: finnish_spatial_plan_status_identifier_seq; Type: SEQUENCE; Schema: code_lists; Owner: -
--

CREATE SEQUENCE code_lists.finnish_spatial_plan_status_identifier_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: finnish_spatial_plan_status_identifier_seq; Type: SEQUENCE OWNED BY; Schema: code_lists; Owner: -
--

ALTER SEQUENCE code_lists.finnish_spatial_plan_status_identifier_seq OWNED BY code_lists.finnish_spatial_plan_status.identifier;


--
-- Name: finnish_spatial_plan_type; Type: TABLE; Schema: code_lists; Owner: -
--

CREATE TABLE code_lists.finnish_spatial_plan_type (
    identifier integer NOT NULL,
    value integer NOT NULL,
    description character varying NOT NULL,
    codevalue character varying
);


--
-- Name: finnish_spatial_plan_type_identifier_seq; Type: SEQUENCE; Schema: code_lists; Owner: -
--

CREATE SEQUENCE code_lists.finnish_spatial_plan_type_identifier_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: finnish_spatial_plan_type_identifier_seq; Type: SEQUENCE OWNED BY; Schema: code_lists; Owner: -
--

ALTER SEQUENCE code_lists.finnish_spatial_plan_type_identifier_seq OWNED BY code_lists.finnish_spatial_plan_type.identifier;


--
-- Name: finnish_up_to_dateness; Type: TABLE; Schema: code_lists; Owner: -
--

CREATE TABLE code_lists.finnish_up_to_dateness (
    identifier integer NOT NULL,
    value integer NOT NULL,
    description character varying NOT NULL
);


--
-- Name: finnish_up_to_dateness_identifier_seq; Type: SEQUENCE; Schema: code_lists; Owner: -
--

CREATE SEQUENCE code_lists.finnish_up_to_dateness_identifier_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: finnish_up_to_dateness_identifier_seq; Type: SEQUENCE OWNED BY; Schema: code_lists; Owner: -
--

ALTER SEQUENCE code_lists.finnish_up_to_dateness_identifier_seq OWNED BY code_lists.finnish_up_to_dateness.identifier;


--
-- Name: finnish_vertical_coordinate_reference_system; Type: TABLE; Schema: code_lists; Owner: -
--

CREATE TABLE code_lists.finnish_vertical_coordinate_reference_system (
    identifier integer NOT NULL,
    value integer NOT NULL,
    description character varying NOT NULL
);


--
-- Name: finnish_vertical_coordinate_reference_system_identifier_seq; Type: SEQUENCE; Schema: code_lists; Owner: -
--

CREATE SEQUENCE code_lists.finnish_vertical_coordinate_reference_system_identifier_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: finnish_vertical_coordinate_reference_system_identifier_seq; Type: SEQUENCE OWNED BY; Schema: code_lists; Owner: -
--

ALTER SEQUENCE code_lists.finnish_vertical_coordinate_reference_system_identifier_seq OWNED BY code_lists.finnish_vertical_coordinate_reference_system.identifier;


--
-- Name: finnish_zoning_element_type; Type: TABLE; Schema: code_lists; Owner: -
--

CREATE TABLE code_lists.finnish_zoning_element_type (
    identifier integer NOT NULL,
    value integer NOT NULL,
    description character varying NOT NULL
);


--
-- Name: finnish_zoning_element_type_identifier_seq; Type: SEQUENCE; Schema: code_lists; Owner: -
--

CREATE SEQUENCE code_lists.finnish_zoning_element_type_identifier_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: finnish_zoning_element_type_identifier_seq; Type: SEQUENCE OWNED BY; Schema: code_lists; Owner: -
--

ALTER SEQUENCE code_lists.finnish_zoning_element_type_identifier_seq OWNED BY code_lists.finnish_zoning_element_type.identifier;


--
-- Name: ground_relativeness_kind; Type: TABLE; Schema: code_lists; Owner: -
--

CREATE TABLE code_lists.ground_relativeness_kind (
    id integer NOT NULL,
    codevalue character varying(3) NOT NULL,
    uri character varying(255) NOT NULL,
    preflabel_fi character varying NOT NULL
);


--
-- Name: ground_relativeness_kind_id_seq; Type: SEQUENCE; Schema: code_lists; Owner: -
--

CREATE SEQUENCE code_lists.ground_relativeness_kind_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ground_relativeness_kind_id_seq; Type: SEQUENCE OWNED BY; Schema: code_lists; Owner: -
--

ALTER SEQUENCE code_lists.ground_relativeness_kind_id_seq OWNED BY code_lists.ground_relativeness_kind.id;


--
-- Name: ryhti_language; Type: TABLE; Schema: code_lists; Owner: -
--

CREATE TABLE code_lists.ryhti_language (
    id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
    code character varying(3) NOT NULL,
    name character varying(100) NOT NULL
);


--
-- Name: legal_effectiveness_kind; Type: TABLE; Schema: code_lists; Owner: -
--

CREATE TABLE code_lists.legal_effectiveness_kind (
    id integer NOT NULL,
    codevalue character varying(3) NOT NULL,
    uri character varying(255) NOT NULL,
    preflabel_fi character varying NOT NULL,
    definition_fi character varying
);


--
-- Name: legal_effectiveness_kind_id_seq; Type: SEQUENCE; Schema: code_lists; Owner: -
--

CREATE SEQUENCE code_lists.legal_effectiveness_kind_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: legal_effectiveness_kind_id_seq; Type: SEQUENCE OWNED BY; Schema: code_lists; Owner: -
--

ALTER SEQUENCE code_lists.legal_effectiveness_kind_id_seq OWNED BY code_lists.legal_effectiveness_kind.id;


--
-- Name: master_plan_additional_information_kind; Type: TABLE; Schema: code_lists; Owner: -
--

CREATE TABLE code_lists.master_plan_additional_information_kind (
    id integer NOT NULL,
    codevalue character varying(6) NOT NULL,
    uri character varying(255) NOT NULL,
    preflabel_fi character varying NOT NULL,
    definition_fi character varying,
    description_fi character varying
);


--
-- Name: master_plan_additional_information_kind_id_seq; Type: SEQUENCE; Schema: code_lists; Owner: -
--

CREATE SEQUENCE code_lists.master_plan_additional_information_kind_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: master_plan_additional_information_kind_id_seq; Type: SEQUENCE OWNED BY; Schema: code_lists; Owner: -
--

ALTER SEQUENCE code_lists.master_plan_additional_information_kind_id_seq OWNED BY code_lists.master_plan_additional_information_kind.id;


--
-- Name: master_plan_envrionmental_change_kind; Type: TABLE; Schema: code_lists; Owner: -
--

CREATE TABLE code_lists.master_plan_envrionmental_change_kind (
    id integer NOT NULL,
    codevalue character varying(3) NOT NULL,
    uri character varying(255) NOT NULL,
    preflabel_fi character varying NOT NULL,
    preflabel_sv character varying,
    description_fi character varying,
    description_sv character varying
);


--
-- Name: master_plan_envrionmental_change_kind_id_seq; Type: SEQUENCE; Schema: code_lists; Owner: -
--

CREATE SEQUENCE code_lists.master_plan_envrionmental_change_kind_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: master_plan_envrionmental_change_kind_id_seq; Type: SEQUENCE OWNED BY; Schema: code_lists; Owner: -
--

ALTER SEQUENCE code_lists.master_plan_envrionmental_change_kind_id_seq OWNED BY code_lists.master_plan_envrionmental_change_kind.id;


--
-- Name: master_plan_regulation_kind; Type: TABLE; Schema: code_lists; Owner: -
--

CREATE TABLE code_lists.master_plan_regulation_kind (
    id integer NOT NULL,
    codevalue character varying(6) NOT NULL,
    uri character varying(255) NOT NULL,
    preflabel_fi character varying NOT NULL,
    definition_fi character varying,
    description_fi character varying,
    main_class character varying NOT NULL,
    sub_class character varying
);


--
-- Name: master_plan_regulation_kind_id_seq; Type: SEQUENCE; Schema: code_lists; Owner: -
--

CREATE SEQUENCE code_lists.master_plan_regulation_kind_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: master_plan_regulation_kind_id_seq; Type: SEQUENCE OWNED BY; Schema: code_lists; Owner: -
--

ALTER SEQUENCE code_lists.master_plan_regulation_kind_id_seq OWNED BY code_lists.master_plan_regulation_kind.id;


--
-- Name: master_plan_theme; Type: TABLE; Schema: code_lists; Owner: -
--

CREATE TABLE code_lists.master_plan_theme (
    id integer NOT NULL,
    codevalue character varying(3) NOT NULL,
    uri character varying(255) NOT NULL,
    preflabel_fi character varying NOT NULL,
    preflabel_sv character varying,
    definition_fi character varying,
    definition_sv character varying
);


--
-- Name: master_plan_theme_id_seq; Type: SEQUENCE; Schema: code_lists; Owner: -
--

CREATE SEQUENCE code_lists.master_plan_theme_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: master_plan_theme_id_seq; Type: SEQUENCE OWNED BY; Schema: code_lists; Owner: -
--

ALTER SEQUENCE code_lists.master_plan_theme_id_seq OWNED BY code_lists.master_plan_theme.id;


--
-- Name: spatial_plan_kind; Type: TABLE; Schema: code_lists; Owner: -
--

CREATE TABLE code_lists.spatial_plan_kind (
    id integer NOT NULL,
    kind_group character varying,
    codevalue character varying(3) NOT NULL,
    uri character varying(255) NOT NULL,
    preflabel_fi character varying NOT NULL,
    preflabel_sv character varying,
    description_fi character varying,
    description_sv character varying
);


--
-- Name: spatial_plan_kind_id_seq; Type: SEQUENCE; Schema: code_lists; Owner: -
--

CREATE SEQUENCE code_lists.spatial_plan_kind_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: spatial_plan_kind_id_seq; Type: SEQUENCE OWNED BY; Schema: code_lists; Owner: -
--

ALTER SEQUENCE code_lists.spatial_plan_kind_id_seq OWNED BY code_lists.spatial_plan_kind.id;


--
-- Name: spatial_plan_lifecycle_status; Type: TABLE; Schema: code_lists; Owner: -
--

CREATE TABLE code_lists.spatial_plan_lifecycle_status (
    id integer NOT NULL,
    codevalue character varying(3) NOT NULL,
    uri character varying(255) NOT NULL,
    preflabel_fi character varying NOT NULL,
    preflabel_sv character varying,
    definition_fi character varying,
    definition_sv character varying,
    description_fi character varying,
    description_sv character varying
);


--
-- Name: spatial_plan_lifecycle_status_id_seq; Type: SEQUENCE; Schema: code_lists; Owner: -
--

CREATE SEQUENCE code_lists.spatial_plan_lifecycle_status_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: spatial_plan_lifecycle_status_id_seq; Type: SEQUENCE OWNED BY; Schema: code_lists; Owner: -
--

ALTER SEQUENCE code_lists.spatial_plan_lifecycle_status_id_seq OWNED BY code_lists.spatial_plan_lifecycle_status.id;


--
-- Name: validity_type; Type: TABLE; Schema: code_lists; Owner: -
--

CREATE TABLE code_lists.validity_type (
    identifier integer NOT NULL,
    value integer NOT NULL,
    description character varying NOT NULL
);


--
-- Name: validity_type_identifier_seq; Type: SEQUENCE; Schema: code_lists; Owner: -
--

CREATE SEQUENCE code_lists.validity_type_identifier_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: validity_type_identifier_seq; Type: SEQUENCE OWNED BY; Schema: code_lists; Owner: -
--

ALTER SEQUENCE code_lists.validity_type_identifier_seq OWNED BY code_lists.validity_type.identifier;


--
-- Name: data_type; Type: TABLE; Schema: code_lists; Owner: -
--

CREATE TABLE code_lists.data_type (
    id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
    value integer NOT NULL,
    description character varying NOT NULL
);


--
-- Name: plan_interaction_event_type; Type: TABLE; Schema: code_lists; Owner: -
--

CREATE TABLE code_lists.plan_interaction_event_type (
    id integer PRIMARY KEY,
    codevalue character varying(3) NOT NULL,
    uri character varying(255) NOT NULL,
    preflabel_fi character varying NOT NULL,
    preflabel_sv character varying,
    preflabel_en character varying,
    CONSTRAINT plan_interaction_event_type_codevalue_key UNIQUE (codevalue),
    CONSTRAINT plan_interaction_event_type_uri UNIQUE (uri)
);


--
-- Name: plan_interaction_event_type_id_seq; Type: SEQUENCE; Schema: code_lists; Owner: -
--

CREATE SEQUENCE code_lists.plan_interaction_event_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: plan_interaction_event_type_id_seq; Type: SEQUENCE OWNED BY; Schema: code_lists; Owner: -
--

ALTER SEQUENCE code_lists.plan_interaction_event_type_id_seq OWNED BY code_lists.plan_interaction_event_type.id;


--
-- Name: plan_interaction_event_type id; Type: DEFAULT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.plan_interaction_event_type ALTER COLUMN id SET DEFAULT nextval('code_lists.plan_interaction_event_type_id_seq'::regclass);


--
-- Name: plan_handling_event_type; Type: TABLE; Schema: code_lists; Owner: -
--

CREATE TABLE code_lists.plan_handling_event_type (
    id integer PRIMARY KEY,
    codevalue character varying(3) NOT NULL,
    uri character varying(255) NOT NULL,
    preflabel_fi character varying NOT NULL,
    preflabel_sv character varying,
    preflabel_en character varying,
    CONSTRAINT plan_handling_event_type_codevalue_key UNIQUE (codevalue),
    CONSTRAINT plan_handling_event_type_uri UNIQUE (uri)
);


--
-- Name: plan_handling_event_type_id_seq; Type: SEQUENCE; Schema: code_lists; Owner: -
--

CREATE SEQUENCE code_lists.plan_handling_event_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: plan_handling_event_type_id_seq; Type: SEQUENCE OWNED BY; Schema: code_lists; Owner: -
--

ALTER SEQUENCE code_lists.plan_handling_event_type_id_seq OWNED BY code_lists.plan_handling_event_type.id;


--
-- Name: plan_handling_event_type id; Type: DEFAULT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.plan_handling_event_type ALTER COLUMN id SET DEFAULT nextval('code_lists.plan_handling_event_type_id_seq'::regclass);


--
-- Name: plan_decision_name; Type: TABLE; Schema: code_lists; Owner: -
--

CREATE TABLE code_lists.plan_decision_name (
    id integer PRIMARY KEY,
    codevalue character varying(3) NOT NULL,
    uri character varying(255) NOT NULL,
    preflabel_fi character varying NOT NULL,
    preflabel_sv character varying,
    preflabel_en character varying,
    description_fi character varying,
    description_sv character varying,
    description_en character varying,
    CONSTRAINT plan_decision_name_codevalue_key UNIQUE (codevalue),
    CONSTRAINT plan_decision_name_uri UNIQUE (uri)
);


--
-- Name: plan_decision_name_id_seq; Type: SEQUENCE; Schema: code_lists; Owner: -
--

CREATE SEQUENCE code_lists.plan_decision_name_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: plan_decision_name_id_seq; Type: SEQUENCE OWNED BY; Schema: code_lists; Owner: -
--

ALTER SEQUENCE code_lists.plan_decision_name_id_seq OWNED BY code_lists.plan_decision_name.id;


--
-- Name: plan_decision_name id; Type: DEFAULT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.plan_decision_name ALTER COLUMN id SET DEFAULT nextval('code_lists.plan_decision_name_id_seq'::regclass);



--
-- Name: plan_decision_maker_type; Type: TABLE; Schema: code_lists; Owner: -
--

CREATE TABLE code_lists.plan_decision_maker_type (
    id integer PRIMARY KEY,
    codevalue character varying(3) NOT NULL,
    uri character varying(255) NOT NULL,
    preflabel_fi character varying NOT NULL,
    preflabel_sv character varying,
    preflabel_en character varying,
    description_fi character varying,
    description_sv character varying,
    description_en character varying,
    CONSTRAINT plan_decision_maker_type_codevalue_key UNIQUE (codevalue),
    CONSTRAINT plan_decision_maker_type_uri UNIQUE (uri)
);


--
-- Name: plan_decision_maker_type_id_seq; Type: SEQUENCE; Schema: code_lists; Owner: -
--

CREATE SEQUENCE code_lists.plan_decision_maker_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: plan_decision_maker_type_id_seq; Type: SEQUENCE OWNED BY; Schema: code_lists; Owner: -
--

ALTER SEQUENCE code_lists.plan_decision_maker_type_id_seq OWNED BY code_lists.plan_decision_maker_type.id;


--
-- Name: plan_decision_maker_type id; Type: DEFAULT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.plan_decision_maker_type ALTER COLUMN id SET DEFAULT nextval('code_lists.plan_decision_maker_type_id_seq'::regclass);


--
-- Name: bindingness_kind id; Type: DEFAULT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.bindingness_kind ALTER COLUMN id SET DEFAULT nextval('code_lists.bindingness_kind_id_seq'::regclass);


--
-- Name: describing_line_type identifier; Type: DEFAULT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.describing_line_type ALTER COLUMN identifier SET DEFAULT nextval('code_lists.describing_line_type_identifier_seq'::regclass);


--
-- Name: detail_plan_addition_information_kind id; Type: DEFAULT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.detail_plan_addition_information_kind ALTER COLUMN id SET DEFAULT nextval('code_lists.detail_plan_addition_information_kind_id_seq'::regclass);


--
-- Name: detail_plan_regulation_kind id; Type: DEFAULT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.detail_plan_regulation_kind ALTER COLUMN id SET DEFAULT nextval('code_lists.detail_plan_regulation_kind_id_seq'::regclass);


--
-- Name: detail_plan_theme id; Type: DEFAULT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.detail_plan_theme ALTER COLUMN id SET DEFAULT nextval('code_lists.detail_plan_theme_id_seq'::regclass);


--
-- Name: digital_origin_kind id; Type: DEFAULT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.digital_origin_kind ALTER COLUMN id SET DEFAULT nextval('code_lists.digital_origin_kind_id_seq'::regclass);


--
-- Name: document_kind id; Type: DEFAULT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.document_kind ALTER COLUMN id SET DEFAULT nextval('code_lists.document_kind_id_seq'::regclass);


--
-- Name: finnish_area_type identifier; Type: DEFAULT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.finnish_area_type ALTER COLUMN identifier SET DEFAULT nextval('code_lists.finnish_area_type_identifier_seq'::regclass);


--
-- Name: finnish_document_role identifier; Type: DEFAULT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.finnish_document_role ALTER COLUMN identifier SET DEFAULT nextval('code_lists.finnish_document_role_identifier_seq'::regclass);


--
-- Name: finnish_document_type identifier; Type: DEFAULT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.finnish_document_type ALTER COLUMN identifier SET DEFAULT nextval('code_lists.finnish_document_type_identifier_seq'::regclass);


--
-- Name: finnish_informative_feature_type identifier; Type: DEFAULT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.finnish_informative_feature_type ALTER COLUMN identifier SET DEFAULT nextval('code_lists.finnish_informative_feature_type_identifier_seq'::regclass);


--
-- Name: finnish_land_use_kind identifier; Type: DEFAULT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.finnish_land_use_kind ALTER COLUMN identifier SET DEFAULT nextval('code_lists.finnish_land_use_kind_identifier_seq'::regclass);


--
-- Name: finnish_language identifier; Type: DEFAULT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.finnish_language ALTER COLUMN identifier SET DEFAULT nextval('code_lists.finnish_language_identifier_seq'::regclass);


--
-- Name: finnish_municipalities id; Type: DEFAULT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.finnish_municipalities ALTER COLUMN id SET DEFAULT nextval('code_lists.finnish_municipalities_id_seq'::regclass);


--
-- Name: finnish_municipality_codes identifier; Type: DEFAULT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.finnish_municipality_codes ALTER COLUMN identifier SET DEFAULT nextval('code_lists.finnish_municipality_codes_identifier_seq'::regclass);


--
-- Name: finnish_numeric_value identifier; Type: DEFAULT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.finnish_numeric_value ALTER COLUMN identifier SET DEFAULT nextval('code_lists.finnish_numeric_value_identifier_seq'::regclass);


--
-- Name: finnish_ordinance_process identifier; Type: DEFAULT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.finnish_ordinance_process ALTER COLUMN identifier SET DEFAULT nextval('code_lists.finnish_ordinance_process_identifier_seq'::regclass);


--
-- Name: finnish_ordinance_process_step identifier; Type: DEFAULT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.finnish_ordinance_process_step ALTER COLUMN identifier SET DEFAULT nextval('code_lists.finnish_ordinance_process_step_identifier_seq'::regclass);


--
-- Name: finnish_plan_description identifier; Type: DEFAULT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.finnish_plan_description ALTER COLUMN identifier SET DEFAULT nextval('code_lists.finnish_plan_description_identifier_seq'::regclass);


--
-- Name: finnish_planned_space_type identifier; Type: DEFAULT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.finnish_planned_space_type ALTER COLUMN identifier SET DEFAULT nextval('code_lists.finnish_planned_space_type_identifier_seq'::regclass);


--
-- Name: finnish_planning_detail_line_type identifier; Type: DEFAULT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.finnish_planning_detail_line_type ALTER COLUMN identifier SET DEFAULT nextval('code_lists.finnish_planning_detail_line_type_identifier_seq'::regclass);


--
-- Name: finnish_planning_detail_point_type identifier; Type: DEFAULT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.finnish_planning_detail_point_type ALTER COLUMN identifier SET DEFAULT nextval('code_lists.finnish_planning_detail_point_type_identifier_seq'::regclass);


--
-- Name: finnish_regulative_text_type identifier; Type: DEFAULT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.finnish_regulative_text_type ALTER COLUMN identifier SET DEFAULT nextval('code_lists.finnish_regulative_text_type_identifier_seq'::regclass);


--
-- Name: finnish_spatial_plan_approved_by identifier; Type: DEFAULT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.finnish_spatial_plan_approved_by ALTER COLUMN identifier SET DEFAULT nextval('code_lists.finnish_spatial_plan_approved_by_identifier_seq'::regclass);


--
-- Name: finnish_spatial_plan_level identifier; Type: DEFAULT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.finnish_spatial_plan_level ALTER COLUMN identifier SET DEFAULT nextval('code_lists.finnish_spatial_plan_level_identifier_seq'::regclass);


--
-- Name: finnish_spatial_plan_origin identifier; Type: DEFAULT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.finnish_spatial_plan_origin ALTER COLUMN identifier SET DEFAULT nextval('code_lists.finnish_spatial_plan_origin_identifier_seq'::regclass);


--
-- Name: finnish_spatial_plan_status identifier; Type: DEFAULT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.finnish_spatial_plan_status ALTER COLUMN identifier SET DEFAULT nextval('code_lists.finnish_spatial_plan_status_identifier_seq'::regclass);


--
-- Name: finnish_spatial_plan_type identifier; Type: DEFAULT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.finnish_spatial_plan_type ALTER COLUMN identifier SET DEFAULT nextval('code_lists.finnish_spatial_plan_type_identifier_seq'::regclass);


--
-- Name: finnish_up_to_dateness identifier; Type: DEFAULT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.finnish_up_to_dateness ALTER COLUMN identifier SET DEFAULT nextval('code_lists.finnish_up_to_dateness_identifier_seq'::regclass);


--
-- Name: finnish_vertical_coordinate_reference_system identifier; Type: DEFAULT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.finnish_vertical_coordinate_reference_system ALTER COLUMN identifier SET DEFAULT nextval('code_lists.finnish_vertical_coordinate_reference_system_identifier_seq'::regclass);


--
-- Name: finnish_zoning_element_type identifier; Type: DEFAULT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.finnish_zoning_element_type ALTER COLUMN identifier SET DEFAULT nextval('code_lists.finnish_zoning_element_type_identifier_seq'::regclass);


--
-- Name: ground_relativeness_kind id; Type: DEFAULT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.ground_relativeness_kind ALTER COLUMN id SET DEFAULT nextval('code_lists.ground_relativeness_kind_id_seq'::regclass);


--
-- Name: legal_effectiveness_kind id; Type: DEFAULT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.legal_effectiveness_kind ALTER COLUMN id SET DEFAULT nextval('code_lists.legal_effectiveness_kind_id_seq'::regclass);


--
-- Name: master_plan_additional_information_kind id; Type: DEFAULT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.master_plan_additional_information_kind ALTER COLUMN id SET DEFAULT nextval('code_lists.master_plan_additional_information_kind_id_seq'::regclass);


--
-- Name: master_plan_envrionmental_change_kind id; Type: DEFAULT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.master_plan_envrionmental_change_kind ALTER COLUMN id SET DEFAULT nextval('code_lists.master_plan_envrionmental_change_kind_id_seq'::regclass);


--
-- Name: master_plan_regulation_kind id; Type: DEFAULT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.master_plan_regulation_kind ALTER COLUMN id SET DEFAULT nextval('code_lists.master_plan_regulation_kind_id_seq'::regclass);


--
-- Name: master_plan_theme id; Type: DEFAULT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.master_plan_theme ALTER COLUMN id SET DEFAULT nextval('code_lists.master_plan_theme_id_seq'::regclass);


--
-- Name: spatial_plan_kind id; Type: DEFAULT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.spatial_plan_kind ALTER COLUMN id SET DEFAULT nextval('code_lists.spatial_plan_kind_id_seq'::regclass);


--
-- Name: spatial_plan_lifecycle_status id; Type: DEFAULT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.spatial_plan_lifecycle_status ALTER COLUMN id SET DEFAULT nextval('code_lists.spatial_plan_lifecycle_status_id_seq'::regclass);


--
-- Name: validity_type identifier; Type: DEFAULT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.validity_type ALTER COLUMN identifier SET DEFAULT nextval('code_lists.validity_type_identifier_seq'::regclass);


--
-- Data for Name: bindingness_kind; Type: TABLE DATA; Schema: code_lists; Owner: -
--

INSERT INTO code_lists.bindingness_kind VALUES (1, '01', 'http://uri.suomi.fi/codelist/rytj/RY_Sitovuuslaji/code/01', 'Sitova', 'Kaavamääräyskohteen sijainti on oikeudellisesti sitova.');
INSERT INTO code_lists.bindingness_kind VALUES (2, '02', 'http://uri.suomi.fi/codelist/rytj/RY_Sitovuuslaji/code/02', 'Ohjeellinen', 'Kaavamääräyskohteen sijainti ei ole oikeudellisesti sitova.');


--
-- Data for Name: describing_line_type; Type: TABLE DATA; Schema: code_lists; Owner: -
--

INSERT INTO code_lists.describing_line_type VALUES (1, 1, 'Viiva');
INSERT INTO code_lists.describing_line_type VALUES (2, 2, 'Katkoviiva');
INSERT INTO code_lists.describing_line_type VALUES (3, 3, 'Paksu viiva');
INSERT INTO code_lists.describing_line_type VALUES (4, 4, 'Paksu katkoviiva');
INSERT INTO code_lists.describing_line_type VALUES (5, 5, 'Johtoalueen viiva');


--
-- Data for Name: detail_plan_addition_information_kind; Type: TABLE DATA; Schema: code_lists; Owner: -
--

INSERT INTO code_lists.detail_plan_addition_information_kind VALUES (1, '01', 'http://uri.suomi.fi/codelist/rytj/RY_LisatiedonLaji_AK/code/01', 'Käyttötarkoituksen osuus kerrosalasta', NULL, NULL, NULL, 'Kuvaa yhden käyttötarkoituksen osuuden yhden tai usemman rakennuksen sallitusta kerrosalasta', NULL);
INSERT INTO code_lists.detail_plan_addition_information_kind VALUES (2, '02', 'http://uri.suomi.fi/codelist/rytj/RY_LisatiedonLaji_AK/code/02', 'Käyttötarkoituskohdistus', NULL, 'kohdistaa liittyvän kaavamääryksen koskemaan ainoastaan lisätiedon arvona annettuja käyttötarkoituksia', NULL, NULL, NULL);
INSERT INTO code_lists.detail_plan_addition_information_kind VALUES (3, '03', 'http://uri.suomi.fi/codelist/rytj/RY_LisatiedonLaji_AK/code/03', 'Kohteen geometrian osa', NULL, 'liitetty arvo ilmaisee sen osan liittyvän kohteen geometriasta, jota kaavamääräys koskee.', NULL, 'Esim. se osa korttelin tai tontin rajaviivaa, johon rakennukset on rakennettava kiinni, tai osa yhtenä paikkatietokohteena määritellyn liikenneväylän viivaa.', NULL);
INSERT INTO code_lists.detail_plan_addition_information_kind VALUES (4, '04', 'http://uri.suomi.fi/codelist/rytj/RY_LisatiedonLaji_AK/code/04', 'Poisluettava käyttötarkoitus', NULL, NULL, NULL, 'Annetut käyttötarkoitukset suljetaan pois kaavamääräyksen kuvaamista sallituista käyttötarkoituksista. Käytetään, mikäli on luontevampaa sulkea tiettyjä yksityiskohtaisia käyttötarkoituksia pois sallittujen joukosta kuin kuvata kaikki sallitut käyttötarkoitukset.', NULL);
INSERT INTO code_lists.detail_plan_addition_information_kind VALUES (5, '05', 'http://uri.suomi.fi/codelist/rytj/RY_LisatiedonLaji_AK/code/05', 'Kulttuurihistoriallinen merkittävyys', 'kulturhistorisk betydelse', 'kohteesta muodostettu käsitys, joka perustuu kohteen kulttuurihistoriallisten arvojen ja kulttuuristen merkitysten analysointiin sekä sen suhteuttamiseen muihin vastaaviin kohteisiin', NULL, 'Kulttuurihistoriallinen merkittävyys voi olla kansainvälinen, valtakunnallinen, maakunnallinen, paikallinen tai vähäinen.', NULL);
INSERT INTO code_lists.detail_plan_addition_information_kind VALUES (6, '06', 'http://uri.suomi.fi/codelist/rytj/RY_LisatiedonLaji_AK/code/06', 'Kulttuurihistoriallinen arvotyyppi', NULL, 'Kohteelle määritetyt kulttuurihistorialliset ominaisuudet', NULL, 'Kulttuurihistoriallisia ominaisuuksia ovat esimerkiksi rakennustaiteellinen, rakennustekninen, arkkitehtoninen ja maisemallinen.', NULL);
INSERT INTO code_lists.detail_plan_addition_information_kind VALUES (7, '07', 'http://uri.suomi.fi/codelist/rytj/RY_LisatiedonLaji_AK/code/07', 'Kulttuurihistoriallinen tyyppi', NULL, 'Kuvaa kohteen kulttuurihistoriallista käyttötarkoitusta', NULL, NULL, NULL);
INSERT INTO code_lists.detail_plan_addition_information_kind VALUES (8, '08', 'http://uri.suomi.fi/codelist/rytj/RY_LisatiedonLaji_AK/code/08', 'Kulttuurihistoriallisen merkittävyyden kriteerit', NULL, 'Kuvaa kulttuurihistoriallisen merkittävyyden kriteerejä, joita kohde edustaa.', NULL, 'Merkittävyys voi liittyä edustavuuteen, alkuperäisyyteen, harvinaisuuteen, tyypillisyyteen tai historialliseen merkittävyyteen.', NULL);
INSERT INTO code_lists.detail_plan_addition_information_kind VALUES (9, '09', 'http://uri.suomi.fi/codelist/rytj/RY_LisatiedonLaji_AK/code/09', 'Ympäristöarvon peruste', NULL, NULL, NULL, NULL, NULL);
INSERT INTO code_lists.detail_plan_addition_information_kind VALUES (10, '10', 'http://uri.suomi.fi/codelist/rytj/RY_LisatiedonLaji_AK/code/10', 'Ympäristö- tai luontoarvon merkittävyys', NULL, NULL, NULL, NULL, NULL);
INSERT INTO code_lists.detail_plan_addition_information_kind VALUES (11, '11', 'http://uri.suomi.fi/codelist/rytj/RY_LisatiedonLaji_AK/code/11', 'Muu lisätiedon laji', NULL, NULL, NULL, NULL, NULL);
INSERT INTO code_lists.detail_plan_addition_information_kind VALUES (12, '12', 'http://uri.suomi.fi/codelist/rytj/RY_LisatiedonLaji_AK/code/12', 'Lukumäärä per kerrosneliömetri', NULL, NULL, NULL, 'Kuvaa suureen arvon kutakin rakennuksen kerrosneliömetriä kohden.', NULL);
INSERT INTO code_lists.detail_plan_addition_information_kind VALUES (13, '13', 'http://uri.suomi.fi/codelist/rytj/RY_LisatiedonLaji_AK/code/13', 'Lukumäärä per asunto', NULL, NULL, NULL, 'Kuvaa suureen arvon kutakin rakennuksen asuntoa kohden.', NULL);


--
-- Data for Name: detail_plan_regulation_kind; Type: TABLE DATA; Schema: code_lists; Owner: -
--

INSERT INTO code_lists.detail_plan_regulation_kind (id, codevalue, uri, main_class, sub_class, preflabel_fi, preflabel_sv, description_fi, shortname) VALUES 
(1, 'asumisenAlue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/asumisenAlue', 'Alueen käyttötarkoitus','','Asumisen alue','Område för boende', 'Ilmaisee, että kaavakohde kuvaa asumisen rakennuksille tai asunnoille tarkoitetun alueen. Käytetään asemakaavoissa ilmaisemaan asuinrakennusten alueita, joille voidaan rakentaa eri tyyppisiä asuinrakennuksia. Maakunta- ja yleiskaavoissa käytetään ilmaisemaan asuntoalueita, jolla kerrosalasta pääosa on tarkoitettu asumiseen. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue.Kaavamääräyksen lyhyt nimi: A (AK ja YK) & AA (MK)', 'A'),
(2, 'asuinpientaloalue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/asuinpientaloalue', 'Alueen käyttötarkoitus','asumisenAlue','Asuinpientaloalue','Område för småhus', 'Ilmaisee, että kaavakohde kuvaa asuinpientaloille tarkoitetun alueen. Käytetään asemakaavoissa ilmaisemaan, että alueelle voidaan erilaisia pientaloja eli rivitaloja, kytkettyjä pientaloja ja erillisiä pientaloja asumistarkoituksiin. Käytetään yleiskaavoissa ilmaisemaan pientalovaltaista asuntoaluetta. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue.', 'AP'),
(3, 'erillistenAsuinpientalojenAlue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/erillistenAsuinpientalojenAlue', 'Alueen käyttötarkoitus','asumisenAlue','Erillisten asuinpientalojen alue','Område för fristående småhus', 'Ilmaisee, että kaavakohde kuvaa erillisille asuinpientaloille tarkoitetun alueen eli alueen, jolle on ja/tai sille voidaan rakentaa yksi- tai kaksiasuntoisia pientaloja (omakotitaloja Rakennusluokituksen 2018 mukainen koodiarvo 0110 tai paritaloja Rakennusluokituksen 2018 mukainen koodiarvo 0111) asumistarkoituksiin. Mikäli halutaan, että kullekin rakennuspaikalle saa rakentaa vain yhden asuinrakennuksen, tulee kaavakohteeseen liittää sanallinen määräys asiasta. Kaavamääräyslaji ei ota kantaa asuntojen omistusmuotoon eli siihen onko kyseessä yhtiömuotoinen erillistalo. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue.', 'AO'),
(4, 'rivitalojenJaMuidenKytkettyjenAsuinpientalojenAlue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/rivitalojenJaMuidenKytkettyjenAsuinpientalojenAlue', 'Alueen käyttötarkoitus','asumisenAlue','Rivitalojen ja muiden kytkettyjen asuinpientalojen alue','Område för radhus och andra kopplade bostadshus', 'Ilmaisee, että kaavakohde kuvaa rivitaloille ja muille kytketyille asuinpientaloille tarkoitetun alueen. Kattaa rivitalot (Rakennusluokituksen 2018 mukainen koodiarvo  0112), joita ovat pientalot, joissa on vähintään kolme rinnakkaista asuinhuoneistoa ja joissa eri asuinhuoneistoihin kuuluvia tiloja ei ole päällekkäin. Rivitalot koostuvat kolmesta tai useammasta yhteen rakennetusta asuinhuoneistosta ja muusta asukkaiden käytössä olevasta huonetilasta. Muita kytkettyjä asuinpientaloja ovat esimerkiksi autokatoksin tai varastoin toisiinsa kytketyt asuinpientalot. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue.', 'AR'),
(5, 'asuinkerrostaloalue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/asuinkerrostaloalue', 'Alueen käyttötarkoitus','asumisenAlue','Asuinkerrostaloalue','Område för flervåningshus', 'Ilmaisee, että kaavakohde kuvaa asuinkerrostaloille (Rakennusluokituksen 2018 mukainen koodiarvo  0121) tarkoitetun alueen. Asuinkerrostaloja ovat vähintään kaksikerroksiset asuinrakennukset, joissa eri asuinhuoneistoihin kuuluvia tiloja on päällekkäin. Käytetään yleiskaavoissa ilmaisemaan kerrostalovaltaista asuntoaluetta eli asumisen käyttöön varattavaa aluetta, jolla asuinkerrosalasta pääosa halutaan ohjata sijoittumaan kerrostaloihin. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue.', 'AK'),
(6, 'asumistaPalvelevaYhteiskayttoinenAlue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/asumistaPalvelevaYhteiskayttoinenAlue', 'Alueen käyttötarkoitus','asumisenAlue','Asumista palveleva yhteiskäyttöinen alue','Område i sambruk som betjänar boendet', 'Ilmaisee, että kaavakohde kuvaa asumista palvelevan yhteiskäyttöisen alueen, jolle voidaan rakentaa esimerkiksi vähäinen asuntoalueen omaan tarpeeseen tarkoitettu lämpökeskus tai asuntoalueen yhteispalvelujen, kuten pesulan tai varastojen tarvitsemia tiloja. Mikäli halutaan ilmaista, että alueelle saa sijoittua kaupallisten ja julkisten palvelujen tiloja tulisi tähän ensisijaisesti käyttää niille tarkoitettua kaavamääräyslajikoodia. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue.', 'AH'),
(7, 'maatilanTalouskeskuksenAlue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/maatilanTalouskeskuksenAlue', 'Alueen käyttötarkoitus','asumisenAlue','Maatilan talouskeskuksen alue','Område för en lantbrukslägenhets driftscentrum', 'Ilmaisee, että kaavakohde kuvaa aluetta, jolla on tai johon voidaan rakentaa tilan päärakennuksen ja sen yhteydessä olevien talousrakennusten muodostama kokonaisuus. Tähän kokonaisuuteen voi kuulua maatilan asuin-, tuotanto- ja varastorakennuksia. Eläinsuojien rakentaminen maatilan talouskeskuksen alueelle on sallittua, mutta kaavakohteet, joiden alueella sallitaan kotieläintalouden suuryksiköiden rakentaminen tulisi  ilmaistaan sille tarkoitetulla kaavamääräyslajikoodilla. Silloin kun maatilan talouskeskukselle ei haluta muodostaa omaa aluevarausta, voidaan se osoittaa esimerkiksi maa- ja metsätalousvaltaiselle alueelle merkityllä am-rakennusalalla eli kaavamääräyksellä, jonka tyypiksi on määritelty osa-alue. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue. Yleiskaavoissa koodi voi liittyä myös kaavakohteisiin, joiden geometria on piste.', 'AM'),
(8, 'kylaAlue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/kylaAlue', 'Alueen käyttötarkoitus','asumisenAlue','Kyläalue','Byområde', 'Ilmaisee, että kaavakohde kuvaa kyläalueen. Kyläalueelle voi sijoittua asutusta, maatalouden tilakeskuksia, palveluja ja työtiloja. Mikäli kyläalueella on tarvetta erillisten maatilojen talouskeskusten osoittamiseen, tulisi ensisijaisesti käyttää kaavamääräyslajia maatilan talouskeskuksen alue. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue tai piste.', 'AT'),
(9, 'taajamatoimintojenAlue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/taajamatoimintojenAlue', 'Alueen käyttötarkoitus','','Taajamatoimintojen alue','Område för tätortsfunktioner', 'Ilmaisee, että kaavakohde kuvaa taajamatoimintojen alueen. Taajamatoimintojen alue kattaa laajasti kaikki taajamissa esiintyvät toiminnot, ellei niitä ole toimintojen seudullisen merkittävyyden tai muun ylikunnallisen ohjaustarpeen vuoksi tarpeellista ilmaista erikseen tarkemmin niitä kuvaavalla kaavamääräyslaji-koodilla. Taajamatoimintojen alueet voivat sisältää sekä rakennettuja alueita että taajaman laajentumisen vaatimia alueita. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue.', 'A'),
(10, 'keskustatoimintojenAlue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/keskustatoimintojenAlue', 'Alueen käyttötarkoitus','taajamatoimintojenAlue','Keskustatoimintojen alue','Område för centrumfunktioner', 'Ilmaisee, että kaavakohde kuvaa keskustatoimintojen alueen, joka voi kattaa laajasti eri tyyppisiä asumisen ja toimitilojen käyttötarkoituksia, kuten palvelu- ja liikerakentamista sekä hallintoa. Keskustatoimintojen alueella tarkoitetaan myös MRL 71 d §:n mukaista keskustatoimintojen aluetta. Keskustatoimintojen alue vaatii asemakaavoissa yleensä tarkkaa suunnittelua, toteuttamista,  määrätietoista ohjausta sekä esimerkiksi paikallisiin ominaisuuksiin ja tavoitteisiin perustuvia tarkempia sanallisia kaavamääräyksiä. Keskustatoimintojen alueet voidaan asemakaavoissa osoittaa myös kaavamääräyksellä, jonka tyypiksi on määritelty osa-alue. Yleiskaavoissa keskustatoimintojen alueen kaavamääräyslajia käytetään, kun ei ole tarkoituksenmukaista esittää kaavakohteen kuvaaman aluevarauksen sisäistä jäsentelyä eri pääkäyttötarkoituksiin. Yleis -ja maakuntakaavoissa keskustatoimintojen alueella pääasiallisia toimintoja ovat palvelut ja hallinto, keskustaan soveltuva asuminen, keskustaan soveltuvat ympäristöhäiriöitä aiheuttamattomat työpaikkatoiminnat, näihin liityvä liikenne ja virkistys sekä yhdyskuntatekninen huolto. Maakuntakaavoissa keskustatoimintojen aluetta käytetään pääsääntöisesti osoittamaan lähinnä kaupunkitasoisten tai aluerakenteen kannalta vastaavaa seudullista merkitystä omaavien taajamien keskusta-alueita. Muussa tapauksessa keskustatoiminnot sisältyvät maakuntakaavan taajamatoimintojen alueisiin. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue. Yleis- ja maakuntakaavoissa koodi voi liittyä myös kaavakohteisiin, joiden geometria on piste.', 'C'),
(11, 'keskustatoimintojenAlakeskus', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/keskustatoimintojenAlakeskus', 'Alueen osan käyttötarkoitus','taajamatoimintojenAlue','Keskustatoimintojen alakeskus','Sekundärcentrum för centrumfunktioner', 'Ilmaisee, että kaavakohde kuvaa kunnan tai laajemman suunnittelualueen keskusverkostossa pääkeskustaa merkitykseltään pienemmän keskustatoimintojen alueen. Eräänä tarkoituksena on yhdyskunnan palvelukeskusverkon havainnollinen esittäminen. Sitä ei siis yleensä ole syytä käyttää aivan pienissä taajamissa tai alakeskuksissa. Koodi liittyy lähtökohtaisesti yleis- ja maakuntakaavoissa kaavakohteisiin, joiden geometria on piste.', 'ca'),
(12, 'tyopaikkojenAlue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/tyopaikkojenAlue', 'Alueen käyttötarkoitus','','Työpaikkojen alue','Område för arbetsplatser', 'Ilmaisee, että kaavakohde kuvaa työpaikkojen alueen, joissa voi olla toimisto- ja palvelutyöpaikkoja, ympäristöhäiriöitä aiheuttamatonta teollisuutta ja siihen liittyvää myymälätilaa sekä varastointia. Alueen toimintojen määrittelyssä ratkaisevaa on toiminnan vaikutus ympäristöön. Esimerkiksi tuotannollisen toiminnan tulisi olla ympäristövaikutuksiltaan rinnastettavissa toimistotyyppiseen työhön. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue. Yleis- ja maakuntakaavoissa koodi voi liittyä myös kaavakohteisiin, joiden geometria on piste.', 'TP'),
(13, 'toimitilojenAlue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/toimitilojenAlue', 'Alueen käyttötarkoitus','tyopaikkojenAlue','Toimitilojen alue','Område för verksamhetsbyggnader', 'Ilmaisee, että kaavakohde kuvaa toimitilarakennuksille tarkoitetun alueen. Alueelle voidaan rakentaa toimistorakennuksia sekä ympäristöhäiriöitä aiheuttamattomia teollisuus- ja varastorakennuksia tai niiden yhdistelmiä, jotka ovat tulkittavissa toimistotyyppiseen tuotannolliseen toimintaan. Mikäli kyseessä on selkeästi teolliseen toimintaan tarkoitettu alue, tulisi käyttää teollisuusalueen kaavamääräyslajia. Toimitilarakennusten alueelle voi sijoittua myös palvelun toimitiloja, jos ne luonteeltaan sopivat muun toiminnan yhteyteen. Silloin, kun toiminta on pääasiassa palveluihin luettavaa, tulisi käyttää palvelutoimintaa tarkemmin ilmaisevia kaavamääräyslajeja. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue.', 'KTY'),
(14, 'toimistorakennustenAlue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/toimistorakennustenAlue', 'Alueen käyttötarkoitus','tyopaikkojenAlue','Toimistorakennusten alue','Område för kontorsbyggnader', 'Ilmaisee, että kaavakohde kuvaa toimistorakennuksille tarkoitetun alueen. Alue on tarkoitettu toimistorakennuksia, kuten yritysten konttoreita tai järjestöjen toimitiloja. Mikäli kaavamääräyksessä halutaan tarkentaa, että alue on varattu julkista hallintoa varten tarkoitettuja virasto-, toimisto- yms. rakennuksia, voidaan kaavamääräykselle antaa lisätieto siitä, että alue on varattu yleiseen käyttöön. Mikäli alueelle halutaan osoittaa myös myymälätiloja, voidaan kaavakohteeseen liittää kaavamääräys, joka ilmaisee, että alueelle saa sijoittaa myymälärakennuksia. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue.', 'KT'),
(15, 'palvelujenAlue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/palvelujenAlue', 'Alueen käyttötarkoitus','tyopaikkojenAlue','Palvelujen alue','Område för service', 'Ilmaisee, että kaavakohde kuvaa palvelujen alueen. Palvelujen alueina osoitetaan julkisten tai yksityisten palvelujen ja hallinnon alueita eli kaavamääräyslaji itsessään ei ota kantaa siihen onko toiminta julkista vai yksityistä, vaan se voi toteutua muuttuvien tarpeiden mukaisesti kumpana tahansa. Mikäli alue halutaan varata nimenomaan julkiseen käyttöön, voidaan kaavamääräykseen liittää lisätieto siitä, että alue on varattu yleiseen käyttöön. Palvelujen alueen toimintoihin eivät kuulu merkittävä tuotantotoiminta ja kooltaan huomattava, yhden toiminnan tarpeisiin varattu myymälä. Mikäli palvelujen alue halutaan osoittaa nimenomaan  lähiympäristöä palvelevia toimintoja varten, voidaan kaavamääräykseen liittää lisätieto siitä, että kyseessä on paikallinen palvelujen alue. Paikallisia lähipalvelutoimintoja voivat olla esimerkiksi päiväkoti, terveysasema, elintarvikemyymälä tai kioski. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue. Yleis- ja maakuntakaavoissa koodi voi liittyä myös kaavakohteisiin, joiden geometria on piste.', 'P'),
(16, 'liikerakennustenAlue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/liikerakennustenAlue', 'Alueen käyttötarkoitus','tyopaikkojenAlue','Liikerakennusten alue','Område för affärsbyggnader', 'Ilmaisee, että kaavakohde kuvaa liikerakennuksille (Rakennusluokituksen 2018 mukainen koodiarvo  03) tarkoitetun alueen. Liikerakennuksia ovat myymälä-, majoitusliike- sekä ravintolarakennukset sekä näitä vastaavat liikerakennukset. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue.', 'KL'),
(17, 'myymalarakennustenAlue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/myymalarakennustenAlue', 'Alueen käyttötarkoitus','tyopaikkojenAlue','Myymälärakennusten alue','Område för butiksbyggnader', 'Ilmaisee, että kaavakohde kuvaa myymälärakennuksille (Rakennusluokituksen 2018 mukainen koodiarvo  031) tarkoitetun alueen. Myymälärakennuksia ovat pääasiassa tuotteiden ja palveluiden myyntiin tarkoitetut liikerakennukset, kuten myymälähallit, kauppakeskukset ja liike- ja tavaratalot sekä muut myymälät. Mikäli alueelle saa sijoittaa vähittäiskaupan suuryksikön tai myymäläkeskittymän, tulisi käyttää kyseistä kaavamääräyslajikoodia. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue.', 'KLM'),
(18, 'vahittaiskaupanSuuryksikko', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/vahittaiskaupanSuuryksikko', 'Alueen käyttötarkoitus','tyopaikkojenAlue','Vähittäiskaupan suuryksikkö','Stor detaljhandelsenhet', 'Ilmaisee, että kaavakohde kuvaa vähittäiskaupan suuryksikölle tarkoitetun alueen. Vähittäiskaupan suuryksiköllä viitataan siihen, mitä MRL 71 a §:ssä on säädetty. Lisätietoja ympäristöministeriön Vähittäiskaupan suuryksiköiden kaavoitus -oppaassa: https://julkaisut.valtioneuvosto.fi/handle/10138/40714 . Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue. Yleis- ja maakuntakaavoissa koodi voi liittyä myös kaavakohteisiin, joiden geometria on piste.', 'KM'),
(19, 'vahittaiskaupanMyymalakeskittyma', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/vahittaiskaupanMyymalakeskittyma', 'Alueen käyttötarkoitus','tyopaikkojenAlue','Vähittäiskaupan myymäläkeskittymä','Koncentration av detaljhandelsbutiker', 'Ilmaisee, että kaavakohde kuvaa vähittäiskaupan myymäläkeskittymälle tarkoitetun alueen. Vähittäiskaupan myymäläkeskittymä on useasta erillisestä ja toisistaan lähietäisyydellä olevasta myymälästä muodostuva toiminnallisesti yhtenäinen kokonaisuus. Vähittäiskaupan suuryksiköitä koskevia erityisiä säännöksiä sovelletaan sellaiseen myymäläkeskittymään, joka on vaikutuksiltaan verrattavissa vähittäiskaupan suuryksikköön (MRL 71 d §). Lisätietoja ympäristöministeriön Vähittäiskaupan suuryksiköiden kaavoitus -oppaassa: https://julkaisut.valtioneuvosto.fi/handle/10138/40714 . Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue. Yleis- ja maakuntakaavoissa koodi voi liittyä myös kaavakohteisiin, joiden geometria on piste.', 'KMK'),
(20, 'huviJaViihdeRakennustenAlue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/huviJaViihdeRakennustenAlue', 'Alueen käyttötarkoitus','tyopaikkojenAlue','Huvi- ja viihderakennusten alue','Område för byggnader för nöjes- och underhållningstjänster', 'Ilmaisee, että kaavakohde kuvaa huvi- ja viihdepalvelujen rakennuksille tarkoitettua aluetta. Tällaisia rakennuksia ovat mm. Rakennusluokituksen 2018 mukaiset koodiarvot 0710 Teatterit, musiikki- ja kongressitalot ja 0711 Elokuvateatterit sekä huvipuiston rakennukset ja tanssilavat. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue.', 'PV'),
(21, 'yleistenRakennustenAlue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/yleistenRakennustenAlue', 'Alueen käyttötarkoitus','tyopaikkojenAlue','Yleisten rakennusten alue','Område för allmänna byggnader', 'Ilmaisee, että kaavakohde kuvaa yleisten rakennusten alueen. Yleisiä rakennuksia ovat erilaiset julkisen hallinnon ja julkisten palvelujen rakennukset. Koodia käytetään silloin, kun ei ole tarpeen tai mahdollista osoittaa alueen käyttötarkoitusta tarkemmin. Koodia voidaan käyttää myös silloin, kun haluttua yleisten rakennusten käyttötarkoitusta varten ei ole olemassa omaa merkintää. Tällöin kaavamääräykseen tulisi liittää käyttötarkoitusta täsmentävä sanallinen kaavamääräys. Yleisten rakennusten alueelle tulisi aina liittää lisätieto, joka kertoo että kyseinen alue on varattu yleiseen käyttöön. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue.', 'Y'),
(22, 'hoitoalanRakennustenAlue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/hoitoalanRakennustenAlue', 'Alueen käyttötarkoitus','tyopaikkojenAlue','Hoitoalan rakennusten alue','Område för byggnader inom vårdbranschen', 'Ilmaisee, että kaavakohde kuvaa hoitoalan rakennuksille (Rakennusluokituksen 2018 mukainen koodiarvo  06) tarkoitetun alueen. Koodilla tarkoitetaan yhtäläisesti sosiaalitointa ja terveydenhuoltoa palvelevia rakennuksia eli esimerkiksi sairaaloita, vanhainkoteja ja muita sosiaalitointa ja terveydenhuoltoa palvelevia rakennuksia. Mikäli alue halutaan varata nimenomaan julkisia hoitoalan rakennuksia varten kaavamääräykseen tulisi liittää lisätieto, joka kertoo että kyseinen alue on varattu yleiseen käyttöön. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue.', 'YS'),
(23, 'museorakennustenAlue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/museorakennustenAlue', 'Alueen käyttötarkoitus','tyopaikkojenAlue','Museorakennusten alue','Område för museibyggnader', 'Ilmaisee, että kaavakohde kuvaa museorakennuksille (Rakennusluokituksen 2018 mukainen koodiarvo  0713) tarkoitetun alueen.  Kysymyksessä voi olla historiallinen, taide- tai muun tyyppinen museo eli rakennus, jossa säilytetään yleisön nähtävänä kulttuuri- tai luonnonhistoriallisia, taide- tai muita kokoelmia tai joissa esitellään taidetta. Mikäli alue halutaan varata nimenomaan julkisia museorakennuksia varten kaavamääräykseen tulisi liittää lisätieto, joka kertoo että kyseinen alue on varattu yleiseen käyttöön. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue.', 'YM'),
(24, 'urheiluJaLiikuntaRakennustenAlue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/urheiluJaLiikuntaRakennustenAlue', 'Alueen käyttötarkoitus','tyopaikkojenAlue','Urheilu- ja liikuntarakennusten alue','Område för idrotts- och motionsanläggningar', 'Ilmaisee, että kaavakohde kuvaa urheilu- ja liikuntarakennuksille (Rakennusluokituksen 2018 mukainen koodiarvo  074) tarkoitetun alueen. Urheilu- ja liikuntarakennuksia ovat urheiluun ja liikuntaan sekä urheilu- ja muiden tapahtumien seuraamiseen tarkoitetut kokoontumisrakennukset, esimerkiksi jää-, uima-, monitoimi-, urheilu- ja palloiluhallit, stadion- ja katsomorakennukset. Mikäli alue halutaan varata nimenomaan julkisia urheilu- ja liikuntarakennuksia varten kaavamääräykseen tulisi liittää lisätieto, joka kertoo että kyseinen alue on varattu yleiseen käyttöön. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue.', 'YU'),
(25, 'kulttuurirakennustenAlue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/kulttuurirakennustenAlue', 'Alueen käyttötarkoitus','tyopaikkojenAlue','Kulttuurirakennusten alue','Område för kulturbyggnader', 'Ilmaisee, että kaavakohde kuvaa kulttuurirakennuksille (Rakennusluokituksen 2018 mukainen koodiarvo  071) tarkoitetun alueen. Alueelle voidaan rakentaa erilaista kulttuuritoimintaa, kuten teatteri-, kirjasto-, konsertti- ja näyttelytoimintaa palvelevia rakennuksia. Mikäli alue halutaan varata nimenomaan julkisia kulttuurirakennuksia varten kaavamääräykseen tulisi liittää lisätieto, joka kertoo että kyseinen alue on varattu yleiseen käyttöön. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue.', 'YY'),
(26, 'uskonnollistenYhteisojenRakennustenAlue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/uskonnollistenYhteisojenRakennustenAlue', 'Alueen käyttötarkoitus','tyopaikkojenAlue','Uskonnollisten yhteisöjen rakennusten alue','Område för religiösa samfunds byggnader', 'Ilmaisee, että kaavakohde kuvaa uskonnollisten yhteisöjen rakennuksille (Rakennusluokituksen 2018 mukainen koodiarvo  073) tarkoitetun alueen. Mikäli alue halutaan varata nimenomaan julkisia uskonnollisten yhteisöjen rakennuksia varten kaavamääräykseen tulisi liittää lisätieto, joka kertoo että kyseinen alue on varattu yleiseen käyttöön. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue.', 'YK'),
(27, 'opetusrakennustenAlue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/opetusrakennustenAlue', 'Alueen käyttötarkoitus','tyopaikkojenAlue','Opetusrakennusten alue','Område för undervisningsbyggnader', 'Ilmaisee, että kaavakohde kuvaa opetusrakennuksille (Rakennusluokituksen 2018 mukainen koodiarvo 08) tarkoitetun alueen. Koodilla tarkoitetaan yhtäläisesti opetustoimintaa palvelevien rakennusten aluetta. Alueelle voidaan rakentaa päiväkoteja, kouluja ja muita oppilaitoksia. Käyttötarkoitusta voidaan tarvittaessa täsmentää sanallisella kaavamääräyksellä, mikäli alue halutaan osoittaa tietyn tyyppistä opetustoimintaa varten ja sen on oleellista käydä ilmi määräyksestä. Mikäli alue halutaan varata nimenomaan julkisia opetusrakennuksia varten kaavamääräykseen tulisi liittää lisätieto, joka kertoo että kyseinen alue on varattu yleiseen käyttöön. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue.', 'YO'),
(28, 'teollisuusalue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/teollisuusalue', 'Alueen käyttötarkoitus','tyopaikkojenAlue','Teollisuusalue','Industriområde', 'Ilmaisee, että kaavakohde kuvaa teollisuuden tuotantorakennuksille (Rakennusluokituksen 2018 mukainen koodiarvo  091) tarkoitetun alueen. Koodilla tarkoitetaan yhtäläisesti asemakaavojen teollisuusrakennusten aluetta sekä yleis- ja maakuntakaavojen teollisuusaluetta. Alueella on tai sille voidaan rakentaa teollisuustiloja kuten tehtaita, teollisuushalleja ja korjaamoja niihin liittyvine varasto- ja muine aputiloineen sekä varastorakennuksia. Mikäli alueella sallitaan merkittävän, vaarallisia kemikaaleja valmistavan tai varastoivan laitoksen sijoittuminen, tulee kaavamääräykseen tulisi liittää lisätieto, joka kertoo että kyseinen toiminto sallitaan alueella. Mikäli kaavakohde sijaitsee alueella, jolla ympäristö asettaa toiminnan laadulle erityisiä vaatimuksia, tulisi kaavamääräykseen liittää tämän ilmaiseva lisätieto. Mikäli teollisuusalue osoitetaan yleis- tai maakuntakaavassa ja alueelle voidaan sijoittaa sellaisia teollisuustoimintoja, joilla on merkittäviä ympäristövaikutuksia, tulisi kaavakohteeseen kohdistaa myös kaavamääräys, joka ilmaisee, että kyseessä on ympäristöhäiriöalue. Mikäli teollisuusalueelle saadaan teollisuuden tuotantorakennusten lisäksi sijoittaa myös varastotoimintaa palvelevia rakennuksia, tulisi kaavakohteeseen kohdistaa myös kaavamääräys, joka ilmaisee, että kyseessä on varastoalue. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue. Yleis- ja maakuntakaavoissa koodi voi liittyä myös kaavakohteisiin, joiden geometria on piste.', 'T'),
(29, 'varastoalue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/varastoalue', 'Alueen käyttötarkoitus','tyopaikkojenAlue','Varastoalue','Lagerområde', 'Ilmaisee, että kaavakohde kuvaa varastorakennuksille (Rakennusluokituksen 2018 mukainen koodiarvo  12) tarkoitetun alueen. Alueella on tai sille voidaan rakentaa varastotoimintaa palvelevia rakennuksia, kuten esimerkiksi vähittäis- tai tukkukaupan varastoja (myös ns. itsepalvelutukkuvarasto) niihin liittyvine aputiloineen. Myymälätilojen sijoittaminen alueelle edellyttää erillistä kaavamääräystä. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue. Yleis- ja maakuntakaavoissa koodi voi liittyä myös kaavakohteisiin, joiden geometria on piste.', 'TV'),
(30, 'vapaaAjanAsumisenJaMatkailunAlue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/vapaaAjanAsumisenJaMatkailunAlue', 'Alueen käyttötarkoitus','','Vapaa-ajan asumisen ja matkailun alue','Område för fritid och turism', 'Ilmaisee, että kaavakohde kuvaa vapaa-ajan asumisen ja matkailun rakennuksille ja/tai toiminnoille tarkoitetun alueen. Koodi on tarkoitettu yleisesti ilmaisemaan loma-asuntoalueita, lomakyliä, lomahotelleja, leirintäalueita, ryhmäpuutarha- ja palstaviljelyalueita sekä muita lomanviettoa ja matkailua palvelevia alueita varten. Asemakaavassa on näille toiminnoille on kuitenkin omat koodinsa, joiden avulla voidaan tarkemmin yksilöidä millaisesta vapaa-ajan ja matkailun alueesta on kyse. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue. Yleis- ja maakuntakaavoissa koodi voi liittyä myös kaavakohteisiin, joiden geometria on piste.', 'R'),
(31, 'vapaaAjanAsumisenAlue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/vapaaAjanAsumisenAlue', 'Alueen käyttötarkoitus','vapaaAjanAsumisenJaMatkailunAlue','Vapaa-ajan asumisen alue','Område för fritidsbostäder', 'Ilmaisee, että kaavakohde kuvaa vapaa-ajan asuinrakennuksille (Rakennusluokituksen 2018 mukainen koodiarvo  02 ja 021) tarkoitetun alueen. Alueelle voidaan rakentaa vapaa-ajan asuntoja ja niitä palvelevia sauna- ja talousrakennuksia. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue. Yleis- ja maakuntakaavoissa koodi voi liittyä myös kaavakohteisiin, joiden geometria on piste.', 'RA'),
(32, 'matkailupalvelujenAlue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/matkailupalvelujenAlue', 'Alueen käyttötarkoitus','vapaaAjanAsumisenJaMatkailunAlue','Matkailupalvelujen alue','Område för turistanläggningar', 'Ilmaisee, että kaavakohde kuvaa matkailutoimintaa palvelevien toimintojen tai rakennusten alueen. Alueelle voidaan sijoittaa lomakyliä, lomahotelleja ja niitä vastaavat matkailukeskuksia sekä muita ensisijaisesti matkailua palvelevia toimintoja ja rakennuksia. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue. Yleis- ja maakuntakaavoissa koodi voi liittyä myös kaavakohteisiin, joiden geometria on piste.', 'RM'),
(33, 'leirintaAlue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/leirintaAlue', 'Alueen käyttötarkoitus','vapaaAjanAsumisenJaMatkailunAlue','Leirintäalue','Campingområde', 'Ilmaisee, että kaavakohde kuvaa leirintäalueen. Leirintäalueella tarkoitetaan lähtökohtaisesti lain ulkoilulain muuttamisesta 1343/1994 18 §:n tarkoittamaa leirintäaluetta. Asemakaavassa voidaan osoittaa myös sellainen leirintäalue, joka on kooltaan ulkoilulaissa mainittua pienempi. Ulkoilulaissa leirintäalueella tarkoitetaan aluetta, jolla majoitutaan tilapäisesti ja yleensä vapaa-aikana leirintämökkiin, telttaan, matkailuperävaunuun tai matkailuajoneuvoon ja jolla on yhteensä vähintään 25 leirintämökkiä taikka teltalle, matkailuperävaunulle tai matkailuajoneuvolle varattua paikkaa. Alue, jolla on vähintään 10 leirintämökkiä, on kuitenkin aina leirintäalue (ulkoilulaki 18 §). Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue.', 'RL'),
(34, 'asuntovaunualue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/asuntovaunualue', 'Alueen käyttötarkoitus','vapaaAjanAsumisenJaMatkailunAlue','Asuntovaunualue','Husvagnsområde', 'Ilmaisee, että kaavakohde kuvaa asuntovaunualueen. Asuntovaunualueella tarkoitetaan lähtökohtaisesti lain ulkoilulain muuttamisesta 1343/1994 18 §:n tarkoittamaa leirintäaluetta, jolla majoittuminen tapahtuu pääasiassa matkailuperävaunuissa tai matkailuajoneuvoissa. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue.', 'RV'),
(35, 'siirtolapuutarhaAlue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/siirtolapuutarhaAlue', 'Alueen käyttötarkoitus','vapaaAjanAsumisenJaMatkailunAlue','Siirtolapuutarha-alue','Område för koloniträdgård', 'Ilmaisee, että kaavakohde kuvaa siirtolapuutarha-alueen. Siirtolapuutarha on puutarhaviljelykseen varattu alue, joka on jaettu palstoihin, ja jonka palstoille voidaan pääosin sijoittaa pieni vapaa-ajan käyttöön tarkoitettu rakennus. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue.', 'RSP'),
(36, 'palstaviljelyalue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/palstaviljelyalue', 'Alueen käyttötarkoitus','vapaaAjanAsumisenJaMatkailunAlue','Palstaviljelyalue','Område för odlingslotter', 'Ilmaisee, että kaavakohde kuvaa palstaviljelyalueen. Palstaviljelyalue on puutarhaviljelykseen varattu alue, joka on jaettu palstoihin, ja jonka palstoille ei pääosin saa sijoittaa kiinteitä rakennuksia tai rakennelmia. Viljelypalsta-alueita, joille ei rakenneta, voidaan osoittaa myös osa-alueina, jotka sijoittuvat esimerkiksi virkistysalueen aluevarausta kuvaavan kaavakohteen päälle. Tällöin palstaviljelyalueen kaavamääräyksen tyypiksi tulee määritellä osa-alue. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue.', 'RP'),
(37, 'viheralue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/viheralue', 'Alueen käyttötarkoitus','','Viheralue (OTSIKKO)','Grönområde', 'Koodistoa jäsentävä otsikkotason koodi, jota ei käytetä kaavamääräyksissä. Viheralueet tulisi kaavoissa luokitella niiden käyttötarkoitusta kuvaavalla kaavamääräyslaji-koodiarvolla.', ''),
(38, 'virkistysalue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/virkistysalue', 'Alueen käyttötarkoitus','viheralue','Virkistysalue','Rekreationsområde', 'Ilmaisee, että kaavakohde kuvaa virkistysalueen. Koodia käytetään ilmaisemaan yleisellä tasolla sellaisia ulkoilu- ja virkistysalueita, joiden käyttöä ei voida tai ei ole tarpeen määritellä tarkemmin. Asemakaavoissa virkistysalueiden käyttötarkoitus on kuitenkin yleensä yksilöitävä tarkemmin käyttämällä käyttötarkoitusta kuvaavaa tarkempaa kaavamääräyslaji-koodia. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue. Yleis- ja maakuntakaavoissa koodi voidaan kuitenkin liittää myös virkistyskohteeseen, jota kuvaavan kaavakohteen geometria on piste.', 'V'),
(39, 'lahivirkistysalue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/lahivirkistysalue', 'Alueen käyttötarkoitus','viheralue','Lähivirkistysalue','Område för närrekreation', 'Ilmaisee, että kaavakohde kuvaa lähivirkistysalueen. Lähivirkistysalueina osoitetaan virkistys- ja ulkoilukäyttöön tarkoitetut, lähinnä taajamarakenteen sisäiset tai siihen välittömästi liittyvät alueet, joita ei ole tarkoitus rakentaa varsinaisiksi puistoiksi. Kaavatasosta riippuen lähivirkistysalueilla tarkoitetaan laajuudeltaan erilaisia alueita. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue.', 'VL'),
(40, 'uimaranta', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/uimaranta', 'Alueen käyttötarkoitus','viheralue','Uimaranta','Badstrand', 'Ilmaisee, että kaavakohde kuvaa uimarannan. Uimarannalla tarkoitetaan vesistön äärellä olevaa uintiin tarkoitettua aluetta. Yleisellä uimarannalla tarkoitetaan yleiseen käyttöön tarkoitettua uimarantaa, josta on tehtävä ilmoitus terveydensuojeluviranomaiselle. Uimarannan käyttöä palvelevia pieniä kioskeja, pukusuojia tai vastaavia kevyitä rakennelmia alueelle voidaan rakentaa ilman erillistä kaavamääräystä. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue tai yleiskaavassa piste.', 'VV'),
(41, 'puisto', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/puisto', 'Alueen käyttötarkoitus','viheralue','Puisto','Park', 'Ilmaisee, että kaavakohde kuvaa puiston. Puistolla tarkoitetaan virkistysaluetta, joka on perustettu tai rakennettu puistoksi ja luonnonmukaisia virkistysalueita intensiivisemmin hoidettu. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue.', 'VP'),
(42, 'leikkipuisto', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/leikkipuisto', 'Alueen käyttötarkoitus','viheralue','Leikkipuisto','Lekpark', 'Ilmaisee, että kaavakohde kuvaa leikkipuiston. Leikkikenttä on leikkipuiston synonyymi. Leikkipuistoina osoitetaan leikkikentät, leikkipuistot, pienehköt pallokentät ja muut vastaavat alueet. Sisäleikkitiloja, alueen huoltoa tai muuta leikkipuiston toimintaa palvelevat rakennukset on syytä osoittaa erillisinä kaavakohteina, joihin liitetään kaavamääräyslaji-koodi rakennusala. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue.', 'VK'),
(43, 'leikkiJaOleskelualue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/leikkiJaOleskelualue', 'Alueen osan käyttötarkoitus','viheralue','Leikki- ja oleskelualue','Lek- och vistelseområde', 'Ilmaisee, että kaavakohde kuvaa alueen, joka varataan leikki- ja oleskelualueeksi. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue.', 'le'),
(44, 'urheiluJaVirkistyspalvelujenAlue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/urheiluJaVirkistyspalvelujenAlue', 'Alueen käyttötarkoitus','viheralue','Urheilu- ja virkistyspalvelujen alue','Område för idrotts- och rekreationsanläggningar', 'Ilmaisee, että kaavakohde kuvaa urheilu- ja virkistyspalvelujen alueen. Urheilu- ja virkistysalueina osoitetaan urheilu- ja virkistyspalvelujen alueet, kuten urheilu- ja palloilualueet ja hiihtokeskukset sekä virkistys- ja vapaa-aikakeskusten alueet. Koodia ei ole tarkoitettu käytettäväksi alueille, joilla sallitaan merkittävää rakentamista. Merkittävät ulkoilmaan sijoittuvat katsomot on syytä osoittaa erillisinä kaavakohteina, joihin liitetään kaavamääräyslaji-koodi rakennusala. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue.', 'VU'),
(45, 'retkeilyJaUlkoiluAlue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/retkeilyJaUlkoiluAlue', 'Alueen käyttötarkoitus','viheralue','Retkeily- ja ulkoilualue','Frilufts- och strövområde', 'Ilmaisee, että kaavakohde kuvaa retkeily- ja ulkoilukäyttöön tarkoitetun alueen. Alueelle voidaan sijoittaa ulkoilupolkuja ja -teitä sekä alueen ulkoilukäyttöä palvelevia yksittäisiä pieniä rakennelmia kuten keittokatoksia tai uimarannan rakennelmia. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue.', 'VR'),
(46, 'ulkoiluTaiVirkistysReitti', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/ulkoiluTaiVirkistysReitti', 'Alueen osan käyttötarkoitus','viheralue','Ulkoilu- tai virkistysreitti','Frilufts- eller rekreationsled', 'Ilmaisee, että kaavakohde kuvaa ulkoilu- tai virkistysreitin. Ulkoilureitillä tarkoitetaan ulkoilulain 13.7.1973/606 tarkoittamaa ulkoilureittiä. Ulkoilureitit yksityisen maalla toteutetaan ulkoilulain mukaisella ulkoilureittitoimituksella tai sopimuksella. Mikäli ulkoilureitti osoitetaan ohjeellisena tulisi kaavamääräykseen liittää lisätieto, joka kertoo, että kyseessä on ohjeellinen sijainti. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan viiva.', 'ulk'),
(47, 'viheryhteys', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/viheryhteys', 'Alueen osan käyttötarkoitus','viheralue','Viheryhteys','Grönförbindelse', 'Ilmaisee, että kaavakohde kuvaa viheryhteyden. Viheryhteyksinä voidaan kuvata virkistysalue- tai/ja ekologiseen verkostoon liittyviä yhteyksiä. Viivamaisina osoitettava viheryhteydet ovat sijainniltaan suuntaa antavia ja niiden laajuudesta voidaan antaa tarvittaessa tarkempia sanallisia kaavamääräyksiä. Kaavamääräyksellä on syytä täsmentää mm. ekologiaan, virkistystarpeisiin tai alue- ja yhdyskuntarakenteeseen liittyviä tavoitteita sekä antaa tarkempia ohjeita verkon ja lähiympäristön suunnittelulle. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan viiva.', 'vy'),
(48, 'ekologisenKompensaationAlue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/ekologisenKompensaationAlue', 'Alueen osan käyttötarkoitus','viheralue','Ekologisen kompensaation alue','Område för ekologisk kompensation', 'Ilmaisee, että kaavakohde kuvaa ekologisen kompensaation alueen. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue.', 'ekok'),
(49, 'istutettavaAlue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/istutettavaAlue', 'Alueen osan käyttötarkoitus','viheralue','Istutettava alue','Område som ska planteras', 'Ilmaisee, että kaavakohde kuvaa istutettavan alueen. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue.', 'ist'),
(50, 'puuTaiPuurivi', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/puuTaiPuurivi', 'Alueen osan käyttötarkoitus','viheralue','Puu tai puurivi','Träd eller trädrad', 'Ilmaisee, että kaavakohde kuvaa puun tai puurivin. Mikäli kyse on säilytettävästä puusta tai puurivistä, tulee kaavamääräykseen liittää lisätieto, joka kertoo, että kohde on säilytettävä. Mikäli kyse on suojeltavasta puusta, tulisi kaavakohteeseen kohdistaa myös kaavamääräys, joka ilmaisee, että kyseessä on suojelualue. Koodi voi liittyä kaavakohteeseen, joka on geometrialtaan piste, viiva tai alue.', 'puu'),
(51, 'vihertehokkuus', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/vihertehokkuus', 'Alueen osan käyttötarkoitus','viheralue','Vihertehokkuus','Gröneffektivitet', 'Ilmaisee kaavakohteen alueella tavoitellun vihertehokkuuden. Koodi liittyy kaavakohteeseen, joka on geometrialtaan alue. Kaavamääräykselle tulee antaa arvo positiivisena desimaalina. Yksikkönä on suhdeluku, joka kertoo kasvillisuuden peittämän pinnan suhde alueen pinta-alaan (m2/m2).', ''),
(52, 'maaJaMetsatalousAlue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/maaJaMetsatalousAlue', 'Alueen käyttötarkoitus','','Maa- ja metsätalousalue','Jord- och skogsbruksområde', 'Ilmaisee, että kaavakohde kuvaa maa- ja metsätalousalueen. Maa- ja metsätalousalueina osoitetaan maa- ja metsätalouden harjoittamiseen tarkoitettuja alueita, joiden käyttöä maatalouden ja metsätalouden välillä ei ole tarpeen määritellä tarkemmin. Yleis- ja maakuntakaavoissa maa- ja metsätalousalueita voidaan käyttää myös haja-asutusluonteiseen asutukseen sekä ulkoiluun ja virkistykseen pääasiallista käyttötarkoitusta vaikeuttamatta. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue.', 'M'),
(53, 'maaJaMetsatalousalueJollaErityistaUlkoilunOhjaamistarvetta', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/maaJaMetsatalousalueJollaErityistaUlkoilunOhjaamistarvetta', 'Alueen käyttötarkoitus','maaJaMetsatalousAlue','Maa- ja metsätalousalue, jolla erityistä ulkoilun ohjaamistarvetta','Jord- och skogsbruksområde med behov av att styra friluftslivet', 'Ilmaisee, että kaavakohde kuvaa maa- ja metsätalousalueen, jolla on erityistä ulkoilun ohjaamistarvetta. Maa- ja metsätalousalueina, joilla on erityistä ulkoilun ohjaamistarvetta osoitetaan alueet, joille suuntautuu ulkoilupainetta ja joilla ulkoilun ohjaamistarpeen vuoksi on tarkoitus toteuttaa ulkoilureittejä levähdys- ja muine tukialueineen. Vaikka alueelle suuntautuu ulkoilupainetta, alueen pääkäyttötarkoituksena on maa- ja metsätalous. Tarvittaessa ulkoilun ohjaamisen ja maa- ja metsätalouden yhteensovittamiseen liittyen voidaan antaa tarkempia sanallisia määräyksiä. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue.', 'MU'),
(54, 'maaJaMetsatalousalueJollaErityisiaYmparistoarvoja', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/maaJaMetsatalousalueJollaErityisiaYmparistoarvoja', 'Alueen käyttötarkoitus','maaJaMetsatalousAlue','Maa- ja metsätalousalue, jolla erityisiä ympäristöarvoja','Jord- och skogsbruksdominerat område med särskilda miljövärden', 'Ilmaisee, että kaavakohde kuvaa maa- ja metsätalousalueen, jolla on erityisiä ympäristöarvoja. Maa- ja metsätalousalueina, joilla on erityisiä ympäristöarvoja osoitetaan  sellaisia maa- ja metsätalouskäyttöön tarkoitettuja alueita, joilla halutaan turvata alueen erityiset ympäristöarvot. Vaikka alueella on erityisiä ympäristöarvoja, alueen pääkäyttötarkoituksena on maa- ja metsätalous. Tarvittaessa ympäristöarvojen säilyttämisestä kuten esimerkiksi maatalousrakennusten sijainnista ja mittasuhteista voidaan antaa tarkempia sanallisia määräyksiä. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue.', 'MY'),
(55, 'maatalousalue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/maatalousalue', 'Alueen käyttötarkoitus','maaJaMetsatalousAlue','Maatalousalue','Jordbruksområde', 'Ilmaisee, että kaavakohde kuvaa maatalousalueen. Maatalousalueina osoitetaan maatalouden harjoittamiseen tarkoitetut alueet. Tarkoituksena on ominaisuuksiltaan parhaiden viljelyalueiden pitäminen nykyisessä käytössään. Myös maatalouden erityistarkoituksiin, kuten opetukseen, tutkimukseen ja jalostustoimintaan tarkoitetut pelto- ja metsäalueet osoittamiseen käytetään tätä koodia. Asemakaava-alueella maatalousalue sijoittuu yleensä muiden toimintojen kuten asumisen välittömään läheisyyteen, jolloin toimintojen yhteensovittaminen saattaa vaatia tarkempia paikallisia määräyksiä. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue.', 'MT'),
(56, 'pelto', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/pelto', 'Alueen käyttötarkoitus','maaJaMetsatalousAlue','Pelto','Åker', 'Ilmaisee, että kaavakohde kuvaa pellon. Peltoina osoitetaan alueet, joiden säilyminen avoimina ja viljelykäytössä halutaan turvata. Kaavalla ei voida kuitenkaan velvoittaa maanomistajaa ryhtymään aktiivisiin toimenpiteisiin viljelyalueiden avoimina säilyttämiseksi. Mikäli peltoalueella on erityisiä maisema-arvoja, tulisi kaavakohteeseen kohdistaa myös kaavamääräys, joka ilmaisee, että kyseessä on maisemallisesti arvokas alue. Alueelle ei lähtökohtaisesti tulisi sijoittaa sellaista maataloustoimintaa, joka edellyttää merkittävää rakentamista. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue.', 'MTP'),
(57, 'metsatalousalue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/metsatalousalue', 'Alueen käyttötarkoitus','maaJaMetsatalousAlue','Metsätalousalue','Skogsbruksområde', 'Ilmaisee, että kaavakohde kuvaa metsätalousalueen. Metsätalousalueina osoitetaan metsätalouden harjoittamiseen tarkoitetut alueet. Metsätalousalueita voidaan käyttää ulkoiluun ja virkistykseen. Tarkoituksena on ominaisuuksiltaan parhaiden metsätalouden alueiden pitäminen nykyisessä käytössään. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue.', 'MM'),
(58, 'kotielaintaloudenSuuryksikonAlue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/kotielaintaloudenSuuryksikonAlue', 'Alueen käyttötarkoitus','maaJaMetsatalousAlue','Kotieläintalouden suuryksikön alue','Område för storenhet inom husdjursproduktionen', 'Ilmaisee, että kaavakohde kuvaa kotieläintalouden suuryksikön alueen. Kotieläintalouden suuryksiköiden alueina osoitetaan alueet, joilla on tai joille on tarkoitus sijoittaa kotieläin- tai turkistalouden suuryksikkö. Alueelle voidaan osoittaa myös merkittävää rakentamista. Kaavakohtaisesti koodia voidaan käyttää näitä pienempienkin kotieläintalouden yksiköiden osoittamisessa. Suuryksikön käsite on tällöin syytä kertoa sanallisessa määräyksessä. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue.', 'ME'),
(59, 'puutarhaJaKasvihuoneAlue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/puutarhaJaKasvihuoneAlue', 'Alueen käyttötarkoitus','maaJaMetsatalousAlue','Puutarha- ja kasvihuonealue','Område för trädgårdsodling och växthus', 'Ilmaisee, että kaavakohde kuvaa puutarha- ja kasvihuonealueen. Puutarha- ja kasvihuonealueina osoitetaan ammattimaiseen puutarha- ja kasvihuoneviljelyyn tarkoitetut alueet. Mikäli puutarha- ja kasvihuonealueelle on tarpeen sijoittaa toimintaan liittyviä myymälätiloja, voidaan samaan kaavakohteeseen liittää kaavamääräys, joka ilmaisee, että alueelle saa sijoittaa myymälärakennuksia. Myymälätilojen määrästä riippuu, osoitetaanko alue myymälärakennusten korttelialueena vai puutarha- ja kasvihuonealueena. Mikäli puutarha- ja kasvihuonealueelle on tarpeen sijoittaa asuntoja, voidaan samaan kaavakohteeseen liittää kaavamääräys, joka ilmaisee, että alueelle saa sijoittaa asuirakennuksia. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue.', 'MP'),
(60, 'poronhoitoalue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/poronhoitoalue', 'Alueen osan käyttötarkoitus','maaJaMetsatalousAlue','Poronhoitoalue','Renskötselområde', 'Ilmaisee, että kaavakohde kuvaa poronhoitolain (848/1990) 2 §:n mukaisen poronhoitoalueen tai kaavakohteella kuvataan poronhoitoon liittyvää aluetta tai rakennetta. Kaavakohteeseen voi olla tarpeen liittää myös sanallinen kaavamääräys, joilla tarkennetaan kaavakohteeseen liittyvää määräystä. Koodi voi liittyä kaavakohteeseen, joka on geometrialtaan alue, viiva tai piste.', 'poro'),
(61, 'erityisalue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/erityisalue', 'Alueen käyttötarkoitus','','Erityisalue','Specialområde', 'Ilmaisee, että kaavakohde kuvaa erityisalueen. Erityisalueina osoitetaan alueita, joilla on tietty erityiskäyttötarkoitus tai sellaisille toiminnoille varattavia alueita, joiden käyttö muihin tarkoituksiin on hyvin rajoitettu ja joille yleisöllä ei yleensä ole vapaata pääsyä. Toiminnan luonteesta johtuen maakuntakaavassa on yleensä syytä käyttää erityisalueiden alaluokkajaotusta. Tämä on tarpeen myös siitä syystä, että joihinkin erityisalueiden alaluokkiin liittyy lähtökohtaisesti maakuntakaavoissa MRL 33 §:n mukainen rakentamisrajoitus. Erityisalueen käyttötarkoitusta voidaan täsmentää sanallisella kaavamääräyksellä. Tällöin kaavamääräyksen kirjaintunnisteeseen olisi hyvä lisätä numero ja alueen käyttötarkoituksen käydä ilmi kaavamääräysryhmän otsikosta. Kunnan tai muun julkisyhteisön toteutettavaksi tarkoitettu erityisalue on MRL 83 §:n mukainen yleinen alue. Tällaiseen alueeseen tulisi liittää lisätieto, joka kertoo että kyseinen alue on varattu yleiseen käyttöön. Tällaista aluetta koskee MRA 47.2 §. Sen mukaan alueelle ei saa rakentaa rakennusta, joka ei sovellu alueen tarkoitukseen. Sanallisilla kaavamääräyksillä voidaan rakentamista ohjata yksityiskohtaisemmin. Sellaiset erityisalueet, joille on mahdollista rakentaa, voidaan osoittaa asemakaavoissa myös korttelialueeksi. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue. Maakunta- ja yleiskaavoissa koodi voidaan liittää myös kaavakohteeseen, joka on geometrialtaan piste.', 'E'),
(62, 'energiahuollonAlue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/energiahuollonAlue', 'Alueen käyttötarkoitus','erityisalue','Energiahuollon alue','Område för energiförsörjning', 'Ilmaisee, että kaavakohde kuvaa energiahuollon alueen. Energiahuollon alue osoitetaan energiatuotanto- ja muuntamoalueet silloin, kun ne on tarpeen osoittaa erikseen. Muuntamot voidaan esittää jonkin aluevarausta kuvaavan kaavakohteen, kuten virkistysalueen, päällä omina kaavakohteinaan, joihin liittyvän määräyksen tyypiksi on määritelty osa-alue. Energiahuoltoon varattavien alueiden sijainnin tai ympäristövaikutusten takia on usein syytä ilmaista millaisesta energiahuollosta on kysymys. Mikäli kyse on aurinkovoiman tai tuulivoiman tuotantoon varattavasta alueesta, tulisi tämä määritellä käyttötarkoituksen kohdistusta koskevana lisätietona. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue. Maakunta- ja yleiskaavoissa koodi voidaan liittää myös kaavakohteeseen, joka on geometrialtaan piste.', 'EN'),
(63, 'tuulivoimalaAlue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/tuulivoimalaAlue', 'Alueen osan käyttötarkoitus','erityisalue','Tuulivoimala-alue','Vindkraftverksområde', 'Ilmaisee, että kaavakohde kuvaa tuulivoimala-alueen (ks. MRL 10 a luku). Tuulivoimala-alueet voidaan esittää jonkin aluevarausta kuvaavan kaavakohteen, kuten maa- ja metsätalousalueen, päällä omina kaavakohteinaan, joihin liittyvän määräyksen tyypiksi on määritelty osa-alue. Maankäyttö- ja rakennuslain luvun 10 a mukaisissa yleiskaavoissa annetuissa kaavamääräyksissä rakennusluvan peruste ilmaistaan koneluettavassa muodossa määrittelemällä tuulivoimala-alueen kaavamääräyksen lisätiedon arvoksi Yleiskaavan oikeusvaikutus –koodiston koodiarvo 13. Mikäli tuulivoimala-alueen kaavamääräys liittyy kaavakohteseen, joka on geometrialtaan piste, kuvataan sillä lähtökohtaisesti voimalan sijaintia. Mikäli voimalan sijainti halutaan osoittaa ohjeellisena kaavamääräykseen liitetään lisätieto, joka kertoo, että kyseessä on ohjeellinen sijainti.', 'tv'),
(64, 'aurinkovoimalaAlue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/aurinkovoimalaAlue', 'Alueen osan käyttötarkoitus','erityisalue','Aurinkovoimala-alue','Solkraftverksområde', 'Ilmaisee, että kaavakohde kuvaa aurinkovoimala-alueen. Aurinkovoimala-alueet voidaan osoittaa varsinaisen aluevarausmerkinnän päällä omina kaavakohteinaan, joihin liittyvän määräyksen tyypiksi on määritelty osa-alue, kun määräys liittyy kaavakohteeseen, jonka geometria on alue. Mikäli aurinkovoimala-alueen kaavamääräys liittyy kaavakohteeseen, joka on geometrialtaan piste, kuvataan sillä lähtökohtaisesti voimalan sijaintia. Mikäli voimalan sijainti halutaan osoittaa ohjeellisena kaavamääräykseen liitetään lisätieto, joka kertoo, että kyseessä on ohjeellinen sijainti.', 'aur'),
(65, 'maaAinestenOttoalue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/maaAinestenOttoalue', 'Alueen käyttötarkoitus','erityisalue','Maa-ainesten ottoalue','Täktområde', 'Ilmaisee, että kaavakohde kuvaa maa-ainesten ottoalue. Maa-ainesten ottoalueella tarkoitetaan aluetta, joka on tarkoitettu maa-aineslain (555/1981) 1 §:ssä kuvattuun toimintaan. Maa-ainesten ottoalueina osoitetaan alueita soran, turpeen tai muiden maa-ainesten ottoa varten. Kaavakohteeseen voidaan liittää sanallisia kaavamääräyksiä, jotka ohjaavat yksityiskohtaisempaa suunnittelua. Tällaisia kaavamääräyksiä voidaan antaa esimerkiksi harjualueille liittyen maa-ainesten ottoaluetta ympäröivän harjumaiseman ja harjun geologisten ominaispiirteiden sekä pohjaveden suojelun huomioonottamiseen, turvealueilla pintavedensuojelun huomioonottamiseen sekä maa-ainesten oton ajoittamiseen ja ottoalueen myöhempään käyttöön. Erilaisten maa-ainesten ottoalueet voidaan erotella toisistaan kaavamääräysryhmän kirjaintunnukseen lisättävien numeroiden sekä otsikoinnin avulla.', 'EO'),
(66, 'turvetuotantoalue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/turvetuotantoalue', 'Alueen käyttötarkoitus','erityisalue','Turvetuotantoalue','Torvtäktsområde', 'Ilmaisee, että kaavakohde kuvaa turvetuotantoalueen (ks. ympäristönsuojelulaki 527/2014). Silloin kun turvetuotantoalueelle ei haluta muodostaa omaa aluevarausta, voidaan se osoittaa esimerkiksi maa- ja metsätalousvaltaista kuvaavan kaavakohteen päällä omana kaavakohteenaan, johon liittyy kaavamääräys, jonka tyypiksi on määritelty osa-alue. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue. Yleis- ja maakuntakaavoissa koodi voi liittyä myös kaavakohteisiin, joiden geometria on piste.', 'EOT'),
(67, 'kaivosalue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/kaivosalue', 'Alueen käyttötarkoitus','erityisalue','Kaivosalue','Gruvområde', 'Ilmaisee, että kaavakohde kuvaa kaivosalueen. Kaivosalueella tarkoitetaan lähtökohtaisesti kaivoslain (621/2011) 19 §:n mukaista kaivosaluetta. Kaivosalueina osoitetaan alueita, joilla jo on kaivostoimintaa tai joilla kaivostoiminnan edellytykset on selvitetty. Alueilla ei maakuntakaavoissa lähtökohtaisesti ole voimassa MRL 33 §:n mukaista rakentamisrajoitusta. Kaivosalueeseen voidaan liittää sanallisia kaavamääräyksiä, jotka ohjaavat yksityiskohtaisempaa suunnittelua. Tällaisia kaavamääräyksiä voidaan antaa esimerkiksi aluetta ympäröivän maiseman, ekologisten ominaispiirteiden sekä pinta- ja pohjavesien suojelun huomioonottamiseen sekä kaivostoiminnan ajoittamiseen ja alueen myöhempään käyttöön. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue. Yleis- ja maakuntakaavoissa koodi voi liittyä myös kaavakohteisiin, joiden geometria on piste.', 'EK'),
(68, 'maaAinestenVastaanottoTaiLajitysAlue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/maaAinestenVastaanottoTaiLajitysAlue', 'Alueen osan käyttötarkoitus','erityisalue','Maa-ainesten vastaanotto- tai läjitysalue','Mottagningsområde eller sidotipp för marksubstanser', 'Ilmaisee, että kaavakohde kuvaa maa-ainesten vastaanotto- ja läjitysalueen. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue.', 'läji'),
(69, 'jatteenkasittelyalue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/jatteenkasittelyalue', 'Alueen käyttötarkoitus','erityisalue','Jätteenkäsittelyalue','Område för avfallshantering', 'Ilmaisee, että kaavakohde kuvaa jätteenkäsittelyalueen. Jätteenkäsittelyalueina osoitetaan jätteiden vastaanottoon ja käsittelyyn varatut alueet kuten kaatopaikat ja jätteen esikäsittelylaitokset. Tällaiselle alueelle voidaan sijoittaa myös sille soveltuvia jätteiden hyödyntämiseen liittyviä toimintoja. Jätteenpolttolaitokset sen sijaan osoitetaan yleensä kaavakohteina, joihin liittyy kaavamääräyslaji "Yhdyskuntateknisen huollon alue". Jätteenkäsittelyalueen käytöstä ja alueen kunnostamisesta käyttämisen jälkeen voidaan antaa kaavamääräyksiä. Myös alueen täyttökorkeudesta voidaan määrätä asemakaavassa. Kaatopaikalle tuotavien jätteiden laadusta ei määrätä kaavassa, vaan ympäristöluvassa. Asemakaavassa saattaa olla tarpeen osoittaa myös taho, jonka tarpeisiin jätteenkäsittelyalue on osoitettu. Tällöin kaavamääräykseen liitetään lisätieto siitä, että alue varattu esimerkiksi kunnan käyttöön tai valtion käyttöön. Mikäli aluetta on suunniteltu käytettäväksi jätteidenkäsittelyyn vain tietyn ajan ja sen jälkeen varattavaksi toisenlaiseen maankäyttöön, esimerkiksi virkistyskäyttöön, tulee kaavamääräykseen liittää lisätietona, että kyse on väliaikaisesta määräyksestä ja kaavakohteeseen tulee liittää myös virkistyskäyttöä koskeva määräys. Tällöin kaavamääräysryhmän kirjaintunnisteessa voitaisiin käyttää esimerkiksi lyhennettä EJ/V. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue. Yleis- ja maakuntakaavoissa koodi voi liittyä myös kaavakohteisiin, joiden geometria on piste.', 'EJ'),
(70, 'ampumarataAlue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/ampumarataAlue', 'Alueen käyttötarkoitus','erityisalue','Ampumarata-alue','Område för skjutbana', 'Ilmaisee, että kaavakohde kuvaa ampumarata-alueen. Ampurata-alueina osoitetaan sekä ampumarata-toimintoja varten varattavat alueet että niille tarpeelliset suoja-alueet. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue. Yleis- ja maakuntakaavoissa koodi voi liittyä myös kaavakohteisiin, joiden geometria on piste.', 'EA'),
(71, 'puolustusvoimienAlue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/puolustusvoimienAlue', 'Alueen käyttötarkoitus','erityisalue','Puolustusvoimien alue','Försvarsmaktens område', 'Ilmaisee, että kaavakohde kuvaa puolustusvoimien alueen. Puolustusvoimien alueella tarkoitetaan aluetta, joka on varattu lain puolustusvoimista (551/2007) 2 §:ssä kuvattujen Puolustusvoimien tehtävien suorittamiseen. Puolustusvoimien alueisiin liittyvien tietoturvakysymysten vuoksi on niitä koskevia kaavoja valmisteltaessa syytä neuvotella erikseen puolustushallinnon kanssa. Alueilla ei maakuntakaavoissa lähtökohtaisesti ole voimassa MRL 33 §:n mukaista rakentamisrajoitusta. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue. Yleis- ja maakuntakaavoissa koodi voi liittyä myös kaavakohteisiin, joiden geometria on piste.', 'EP'),
(72, 'moottoriurheilualue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/moottoriurheilualue', 'Alueen käyttötarkoitus','erityisalue','Moottoriurheilualue','Motorsportområde', 'Ilmaisee, että kaavakohde kuvaa moottoriurheilulle varattavan alueen. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue. Yleis- ja maakuntakaavoissa koodi voi liittyä myös kaavakohteisiin, joiden geometria on piste.', 'EU'),
(73, 'mastoalue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/mastoalue', 'Alueen käyttötarkoitus','erityisalue','Mastoalue','Mastområde', 'Ilmaisee, että kaavakohde kuvaa mastoalueen. Mastoalueina osoitetaan esimerkiksi teleliikenteen mastoille varatut alueet. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue.', 'EMT'),
(74, 'yhdyskuntateknisenHuollonAlue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/yhdyskuntateknisenHuollonAlue', 'Alueen käyttötarkoitus','erityisalue','Yhdyskuntateknisen huollon alue','Område för samhällsteknisk försörjning', 'Ilmaisee, että kaavakohde kuvaa yhdyskuntateknisen huollon alueen. Yhdyskuntateknisen huollon alueina osoitetaan yhdyskuntateknistä huoltoa palvelevia laitoksia kuten voimaloita, vedenottamoita, vedenpuhdistamoita ja niihin liittyviä jätteidenkäsittelylaitoksia varten varattavia alueita. Myös palo- ja pelastusasemat osoitetaan yhdyskuntateknisen huollon alueina. Mikäli alue halutaan varata nimenomaan yleistä käyttöä varten kaavamääräykseen tulisi liittää lisätieto, joka kertoo että kyseinen alue on varattu yleiseen käyttöön. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue.', 'ET'),
(75, 'JohtoPutkiTaiLinja', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/JohtoPutkiTaiLinja', 'Alueen osan käyttötarkoitus','erityisalue','Johto, putki tai linja','Ledning, rör eller linje', 'Ilmaisee, että kaavakohde kuvaa johdon, putken tai linjan sekä sen ympäristön. Maakunta- ja yleiskaavoissa koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan viiva. Asemakaavoissa koodi liittyy lähtökohtaisesti kaavakohteeseen, jonka geometria on alue.', 'jo'),
(76, 'sahkolinja', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/sahkolinja', 'Alueen osan käyttötarkoitus','erityisalue','Sähkölinja','Elledning', 'Ilmaisee, että kaavakohde kuvaa sähköjohdon keskilinjan tai johdolle varattavan alueen. Maakunta- ja yleiskaavoissa koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan viiva. Asemakaavoissa koodi liittyy lähtökohtaisesti kaavakohteeseen, jonka geometria on alue.', 'z'),
(77, 'kaasulinja', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/kaasulinja', 'Alueen osan käyttötarkoitus','erityisalue','Kaasulinja','Gasledning', 'Ilmaisee, että kaavakohde kuvaa kaasulinjan keskilinjan tai johdolle varattavan alueen. Maakunta- ja yleiskaavoissa koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan viiva. asemakaavoissa koodi liittyy lähtökohtaisesti kaavakohteeseen, jonka geometria on alue.', 'k'),
(78, 'vesijohtoTaiViemari', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/vesijohtoTaiViemari', 'Alueen osan käyttötarkoitus','erityisalue','Vesijohto tai viemäri','Vattenledning eller avlopp', 'Ilmaisee, että kaavakohde kuvaa vesijohdon tai viemärin keskilinjan tai johdolle varattavan alueen. Maakunta- ja yleiskaavoissa koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan viiva. Asemakaavoissa koodi liittyy lähtökohtaisesti kaavakohteeseen, jonka geometria on alue.', 'v'),
(79, 'hulevesienHallintaAlue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/hulevesienHallintaAlue', 'Alueen osan käyttötarkoitus','erityisalue','Hulevesien hallinta-alue','Område för dagvattenhantering', 'Ilmaisee, että kaavakohde kuvaa hulevesien hallintaan varatun alueen. Hulevesien hallinta-alueeseen on yleensä tarpeen liittää sanallisia kaavamääräyksiä, jotka ohjaavat yksityiskohtaisempaa suunnittelua tai alueen toteuttamista. Koodi liittyy lähtökohtaisesti kaavakohteeseen, jonka geometria on alue.', 'hule'),
(80, 'jatehuollonAlue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/jatehuollonAlue', 'Alueen käyttötarkoitus','erityisalue','Jätehuollon alue','Område för avfallsservice', 'Ilmaisee, että kaavakohde kuvaa jätehuollon alueen. Jätehuollon alueina osoitetaan alueet, jotka varataan yhdyskunnan toiminnassa, kuten asumisessa, liikehuoneistojen tai kunnan hallinto- ja pavelutoiminnassa syntyvän jätteen keräämiseen. Koodi liittyy lähtökohtaisesti kaavakohteeseen, jonka geometria on alue.', 'EJH'),
(81, 'kiertotaloudenAlue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/kiertotaloudenAlue', 'Alueen käyttötarkoitus','erityisalue','Kiertotalouden alue','Område för cirkulär ekonomi', 'Ilmaisee, että kaavakohde kuvaa kiertotalouden alueen. Kiertotalousalueina osoitetaan alueet, jotka varataan kiertotalouden käyttöön. Koodi voi liittyä kaavakohteeseen, jonka geometria on alue tai piste.', 'EJK'),
(82, 'melueste', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/melueste', 'Alueen osan käyttötarkoitus','erityisalue','Melueste','Bullerhinder', 'Ilmaisee, että kaavakohde kuvaa alueen, jolla on tai jolle tulee rakentaa melueste. Melueste voi olla esimerkiksi meluvalli tai meluaita. Kaavakohteeseen liittyvällä sanallisella määräyksellä voidaan tarvittaessa esittää tarkempia meluesteen suunnitteluun ja toteutukseen liittyviä määräyksiä. Yleiskaavoissa koodi liittyy lähtökohtaisesti kaavakohteeseen, jonka geometria on viiva. Asemakaavoissa koodi liittyy kaavakohteeseen, jonka geometria on viiva tai alue.', 'mee'),
(83, 'tulvapenger', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/tulvapenger', 'Alueen osan käyttötarkoitus','erityisalue','Tulvapenger','Översvämningsvall', 'Ilmaisee, että kaavakohde kuvaa tulvapenkereen. Yleiskaavoissa koodi liittyy lähtökohtaisesti kaavakohteeseen, jonka geometria on viiva. Asemakaavoissa koodi liittyy lähtökohtaisesti kaavakohteeseen, jonka geometria on alue.', 'tupe'),
(84, 'suojaviheralue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/suojaviheralue', 'Alueen käyttötarkoitus','erityisalue','Suojaviheralue','Skyddsgrönområde', 'Ilmaisee, että kaavakohde kuvaa suojaviheralueen. Suojaviheralueina osoitetaan sellaiset esimerkiksi liikenneväylien varrella olevat viheralueina säilytettävät alueet, joiden tarkoituksena on pääasiassa suojata muita alueita haitoilta, ja joita ei sijaintinsa takia voida käyttää virkistysalueina. Suojaviheralueille voi tarvittaessa antaa kaavamääräyksiä esimerkiksi puuston säilyttämisestä tai istuttamisesta. Suojaviheraluetta koskevat maankäyttö- ja rakennuslain 96 §:n ja 101 §:n lunastusoikeudet ja -velvollisuudet. Kunnalla on oikeus lunastaa asemakaava-alueella sellainen yleinen alue, joka asemakaavassa on tarkoitettu kunnan tarpeisiin. Toisaalta kunta on velvollinen lunastamaan alueen, joka on osoitettu käytettäväksi muuhun tarkoitukseen kuin yksityiseen rakennustoimintaan, eikä maanomistaja voi sen vuoksi käyttää hyväkseen aluettaan kohtuullista hyötyä tuottavalla tavalla. Vastaava lunastusoikeus ja -velvollisuus on valtiolla silloin, kun alue on tarkoitettu valtion tarpeisiin. Koodi liittyy lähtökohtaisesti kaavakohteeseen, jonka geometria on alue.', 'EV'),
(85, 'hautausmaa', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/hautausmaa', 'Alueen käyttötarkoitus','erityisalue','Hautausmaa','Begravningsplats', 'Ilmaisee, että kaavakohde kuvaa hautausmaa. Hautausmaalla tarkoitetaan hautaustoimilaissa (6.6.2003/457) tarkoitettuja hautausmaita. Hautausmaina osoitetaan hautausmaata ja siihen liittyviä rakennuksia varten varattavat alueet. Mikäli hautausmaa-alueeseen liittyy erityistä kulttuurihistoriallista merkitystä, mutta se ei kuulu muinaismuistolain piiriin eikä kyse ole vanhasta puistotyyppisestä käytöstä jo poistetusta hautausmaasta, tulisi kaavakohteeseen liittää myös kaavamääräys, joka ilmaisee, että kyseessä on merkittävä rakennettu kulttuuriympäristö. Mikäli hautausmaa-alue halutaan säilyttää, tulisi kaavamääräykselle antaa säilyttämistä koskeva lisätieto. Tällöin kaavamääräysryhmän kirjaintunnuksena voidaan käyttää lyhennettä EH/s. Koodi liittyy lähtökohtaisesti kaavakohteeseen, jonka geometria on alue.', 'EH'),
(86, 'liikennealue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/liikennealue', 'Alueen käyttötarkoitus','','Liikennealue','Trafikområde', 'Ilmaisee, että kaavakohde kuvaa liikennealueen. Merkintää voidaan käyttää silloin, kun ei ole tarkoituksenmukaista tai mahdollista eritellä osoitettavia liikennealueita eri liikennemuodoille. Mikäli toiminnan luonne on määritelty tarkemmin tulisi käyttää tarkempia liikennealueiden alakoodeja. Maakuntakaavoissa liikennealueina osoitetaan seudullisesti merkittäviä liikennealueita, kuten matkakeskuksia, tavaraliikenneasemia, ratapihoja, lentokenttiä ja satamia.  Liikennealueilla on maakuntakaavoissa lähtökohtaisesti voimassa MRL 33 §:n mukainen rakentamisrajoitus. Tämä voidaan mainita kaavakohteeseen liittyvänä sanallisena määräyksenä. Koodi voi liittyä kaavakohteeseen, joka on geometrialtaan alue, viiva tai piste.', 'L'),
(87, 'maaliikenteenAlue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/maaliikenteenAlue', 'Alueen käyttötarkoitus','liikennealue','Maaliikenteen alue','Område för landtrafik', 'Ilmaisee, että kaavakohde kuvaa maaliikenteen alueen. Maaliikenteen alueina osoitetaan alueita tie- ja rautatieliikenteen vähintään seudullisia tarpeita palveleville tavaraterminaaleille sekä seudullisen liikennejärjestelmän kannalta tärkeille matkakeskuksille ja julkisen liikenteen vaihtopaikoille. Mikäli toiminnan luonne on määritelty tarkemmin tulisi käyttää tarkempia maaliikenteen alueiden alakoodeja. Maakuntakaavoissa maaliikenteen alueilla on lähtökohtaisesti voimassa MRL 33 §:n mukainen rakentamisrajoitus. Tämä voidaan mainita kaavakohteeseen liittyvänä sanallisena määräyksenä. Koodi voi liittyä kaavakohteeseen, joka on geometrialtaan alue, viiva tai piste.', 'LM'),
(88, 'maantie', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/maantie', 'Alueen käyttötarkoitus','liikennealue','Maantie','Landsväg', 'Ilmaisee, että kaavakohde kuvaa maantien. Vastaa aiemmin käytössä ollutta käsitettä "yleinen tie". Maantie on yleiseen liikenteeseen tarkoitettu tie, jonka tienpitäjänä toimii valtio. Liikenteellisen merkityksensä mukaan maantiet ovat valtateitä, kantateitä, seututeitä tai yhdysteitä. Mikäli toiminnan luonne on määritelty tarkemmin tulisi maakunta-  ja yleisasemakaavoissa käyttää tarkempia maantien alakoodeja. Maakuntakaavoissa maantiealueilla on lähtökohtaisesti voimassa MRL 33 §:n mukainen rakentamisrajoitus. Tämä voidaan mainita kaavakohteeseen liittyvänä sanallisena määräyksenä. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue.', 'LT'),
(89, 'maantienNakemaAlue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/maantienNakemaAlue', 'Alueen osan käyttötarkoitus','liikennealue','Maantien näkemäalue','Frisiktsområde för landsväg', 'Ilmaisee, että kaavakohde kuvaa kaavassa osoitettavan maantien näkemäalueen. Koodi liittyy kaavakohteeseen, joka on geometrialtaan alue.', 'mtnä'),
(90, 'maantienSuojaAlue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/maantienSuojaAlue', 'Alueen osan käyttötarkoitus','liikennealue','Maantien suoja-alue','Skyddsområde för landsväg', 'Ilmaisee, että kaavakohde kuvaa kaavassa osoitettavan maantien suoja-alueen. Koodi liittyy kaavakohteeseen, joka on geometrialtaan alue.', 'mtsu'),
(91, 'moottoriTaiMoottoriliikenneTie', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/moottoriTaiMoottoriliikenneTie', 'Alueen osan käyttötarkoitus','liikennealue','Moottori- tai moottoriliikennetie','Motorväg eller motortrafikled', 'Ilmaisee, että kaavakohde kuvaa moottoritien tai moottoriliikennetien. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan viiva.', 'mo'),
(92, 'kaksiajoratainenTieTaiKatu', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/kaksiajoratainenTieTaiKatu', 'Alueen osan käyttötarkoitus','liikennealue','Kaksiajoratainen tie tai katu','Väg eller gata med två körbanor', 'Ilmaisee, että kaavakohde kuvaa kaksiajorataisen tien tai kadun. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan viiva.', ''),
(93, 'valtatie', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/valtatie', 'Alueen osan käyttötarkoitus','liikennealue','Valtatie','Riksväg', 'Ilmaisee, että kaavakohde kuvaa valtatien. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan viiva.', 'vt'),
(94, 'kantatie', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/kantatie', 'Alueen osan käyttötarkoitus','liikennealue','Kantatie','Stamväg', 'Ilmaisee, että kaavakohde kuvaa kantatien. Kantatiet täydentävät valtatieverkkoa ja palvelevat maakuntien liikennettä. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan viiva.', 'kt'),
(95, 'seututie', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/seututie', 'Alueen osan käyttötarkoitus','liikennealue','Seututie','Regional väg', 'Ilmaisee, että kaavakohde kuvaa seututien. Seututiet palvelevat seutukuntien liikennettä ja liittävät näitä valta- ja kantateihin. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan viiva.', 'st'),
(96, 'yhdystie', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/yhdystie', 'Alueen osan käyttötarkoitus','liikennealue','Yhdystie','Förbindelseväg', 'Ilmaisee, että kaavakohde kuvaa yhdystien. Yhdystie on maantie, joka ei ole valta-, kanta- eikä seututie. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan viiva.', 'yt'),
(97, 'tie', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/tie', 'Alueen osan käyttötarkoitus','liikennealue','Tie','Väg', 'Ilmaisee, että kaavakohde kuvaa tien. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan viiva.', ''),
(98, 'katu', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/katu', 'Alueen osan käyttötarkoitus','liikennealue','Katu','Gata', 'Ilmaisee, että kaavakohde kuvaa kadun. Koodia käytetään yhtäläisesti kuvaamaan MRL 83 §:n mukaista katualuetta. Katualue käsittää asemakaavassa osoitetun katualueen maanalaisine ja maanpäällisine sekä yläpuolisine johtoineen, laitteineen ja rakenteineen, jollei asemakaavassa ole toisin osoitettu. Kadut toteutetaan asemakaavassa osoitetulle katualueelle kunnan hyväksymän katusuunnitelman mukaisesti. Yksityiskohtainen suunnittelu kuuluu varsinaisesti katusuunnitelman laatimiseen. Katujen rakentamisesta vastaa kunta kustannuksellaan. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue.', 'KATU'),
(99, 'paakatu', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/paakatu', 'Alueen osan käyttötarkoitus','liikennealue','Pääkatu','Huvudgata', 'Ilmaisee, että kaavakohde kuvaa pääkadun. Pääkadut liittävät yhdyskunnan osa-alueiden paikallisverkkoja toisiinsa ja palvelevat niiden välistä liikennettä sekä tarvittaessa myös kytkevät seudullista tieverkkoa yhdyskunnan katuverkkoon. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan viiva.', 'pk'),
(100, 'kokoojakatu', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/kokoojakatu', 'Alueen osan käyttötarkoitus','liikennealue','Kokoojakatu','Matargata', 'Ilmaisee, että kaavakohde kuvaa kokoojakadun. Kokoojakadut liittävät yhdyskunnan osa-alueiden tonttikadut toisiinsa ja pääverkkoon. Ne kokoavat tonttikatujen liikenteen ja mahdollistavat liikenteen osa-alueen sisällä (paikallinen kokoojakatu) tai sen liittymisen pääverkon liikenteeseen (alueellinen kokoojakatu). Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue.', 'kk'),
(101, 'hidaskatu', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/hidaskatu', 'Alueen osan käyttötarkoitus','liikennealue','Hidaskatu','Lågfartsgata', 'Ilmaisee, että kaavakohde kuvaa hidaskadun. Hidaskadut ovat liikennejärjestelyiltään tai rakenteeltaan sellaisia katuja, että yli 30 km/h ajonopeuksien käyttö ei niillä ole luontevaa. Hidaskatu voidaan toteuttaa sopivilla kadun geometriaan, poikkileikkaukseen ja/tai päällysteeseen kohdistuvilla valinnoilla siten, että kadun käyttäjät toimivat luontojaan tavoitellulla tavalla. Katu voidaan tehdä hidaskaduksi rakentamalla töyssyjä ja vastaavia mekaanisia hidastimia, joilla käyttäjät pakotetaan haluttuun liikennekäyttäytymiseen. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue.', 'hk'),
(102, 'pihakatu', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/pihakatu', 'Alueen osan käyttötarkoitus','liikennealue','Pihakatu','Gårdsgata', 'Ilmaisee, että kaavakohde kuvaa pihakadun. Pihakadut ovat korostetusti jalankulkua ja kadulla oleskelua suosivia katuja. Moottoriajoneuvoliikenne on rajoitettu vain kiinteistöihin ja niiden merkityille pysäköintipaikoille. Ajonopeudet on sovitettava jalankulun mukaisesti eivätkä saa ylittää 20 km/h. Jalankulkijalle on annettava esteetön kulku. Jalankulku saa käyttää koko katutilaa, ei kuitenkaan ajoneuvoliikennettä tarpeettomasti estäen. Pihakaduiksi soveltuvat erityisesti tiiviiden keskusta-alueiden asuntokadut, jolloin ne onnistuneesti toteutettuina lisäävät asukkaiden käytössä olevaa yhteistä ulkotilaa. Katualue, jonka käyttötarkoitusta ei ole määritelty, voidaan osoittaa pihakaduksi katusuunnitelmassa. Pihakadun muodostamiseksi ei asemakaavan muuttaminen siten ole välttämätöntä. Kun asemakaavaa muutetaan tai laaditaan uusi asemakaava, on kuitenkin tarkoituksenmukaista merkitä pihakaduiksi suunnitellut kadut sellaisiksi jo asemakaavaan. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue.', 'pik'),
(103, 'kadunOsaJollaOnAjoneuvoliittymakielto', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/kadunOsaJollaOnAjoneuvoliittymakielto', 'Alueen osan käyttötarkoitus','liikennealue','Kadun osa, jolla on ajoneuvoliittymäkielto','Del av gata med förbud mot in- och utfart för fordon', 'Ilmaisee, että kaavakohde kuvaa katualueen ja tontin rajan osaa, jonka kohdalta ei saa järjestää ajoneuvoliittymää. Koodi liittyy kaavakohteeseen, joka on geometrialtaan viiva.', ''),
(104, 'ajoyhteys', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/ajoyhteys', 'Alueen osan käyttötarkoitus','liikennealue','Ajoyhteys','Körförbindelse', 'Ilmaisee, että kaavakohde kuvaa ajoyhteyden. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue.', 'ajo'),
(105, 'ajoluiska', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/ajoluiska', 'Alueen osan käyttötarkoitus','liikennealue','Ajoluiska','Körramp', 'Ilmaisee, että kaavakohde kuvaa ajoluiskan. Koodi liittyy kaavakohteeseen, joka on geometrialtaan viiva tai alue.', 'ajol'),
(106, 'huoltoajoalue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/huoltoajoalue', 'Alueen osan käyttötarkoitus','liikennealue','Huoltoajoalue','Servicekörområde', 'Ilmaisee, että kaavakohteen kuvaama alue on varattu huoltoliikenteelle. Lisätiedolla "Varattu alueen sisäiseen käyttöön" voidaan täsmentää kaavamääräyksen koskevan alueen sisäistä huoltoliikennettä. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue.', 'h'),
(107, 'liittyma', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/liittyma', 'Alueen osan käyttötarkoitus','liikennealue','Liittymä','Anslutning', 'Ilmaisee, että kaavakohde kuvaa liikenneliittymän. Koodi ei ota tarkemmin kantaa siihen millaisena liittymä toteutetaan. Liittymä on mahdollista toteuttaa myös eritasoliittymänä tai suuntaisliittymänä. Mikäli liittymä on erityisestä syystä toteutettava tietyn tyyppisenä, tulisi käyttää liittymän toteutusta tarkemmin kuvaavaa koodia. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan piste.', 'liit'),
(108, 'suuntaisliittyma', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/suuntaisliittyma', 'Alueen osan käyttötarkoitus','liikennealue','Suuntaisliittymä','Ensidig anslutning', 'Ilmaisee, että kaavakohde kuvaa suuntaisliittymän alueen. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan piste.', 'sliit'),
(109, 'eritasoliittyma', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/eritasoliittyma', 'Alueen osan käyttötarkoitus','liikennealue','Eritasoliittymä','Planskild anslutning', 'Ilmaisee, että kaavakohde kuvaa eritasoliittymän. Koodi liittyy lähtökohtaisesti maakunta- ja yleiskaavoissa kaavakohteeseen, joka on geometrialtaan piste.', 'eliit'),
(110, 'liikennetunneli', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/liikennetunneli', 'Alueen osan käyttötarkoitus','liikennealue','Liikennetunneli','Trafiktunnel', 'Ilmaisee, että kaavakohde kuvaa liikennetunnelin. Liikennetunneleina osoitetaan liikenneväylät, joihin molemmilta puolilta kiinteäksi rakennettu kansirakenne. Mikäli halutaan tarkentaa millaisesta liikennetunnelista on kyse, kaavamääräykselle voidaan määritellä lisätietona käyttötarkoituskohdistus, jolle annetaan arvoksi jokin väylää kuvaava kaavamääräyslaji esimerkiksi maantie, katu tai raideliikenteen alue. Koodi liittyy lähtökohtaisesti maakunta- ja yleiskaavoissa kaavakohteeseen, joka on geometrialtaan viiva. Asemakaavoissa koodi liittyy kaavakohteeseen, joka on geometrialtaan alue.', 'lt'),
(111, 'eritasoristeys', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/eritasoristeys', 'Alueen osan käyttötarkoitus','liikennealue','Eritasoristeys','Planskild korsning', 'Ilmaisee, että kaavakohde kuvaa eritasoristeyksen. Eritasoristeys ei ota tarkemmin kantaa risteämiseen. Asemakaavan ympäristövaikutusten tai liikennejärjestelyjen tarkoituksenmukaisuuden arvioimiseksi on usein tarpeen kaavassa osoittaa, kumpi risteävistä liikenneväylistä ylittää toisen. Tällöin käytetään alikulkua tai ylikulkua ilmaisevaa kaavamääräyslaji-koodia. Koodi liittyy lähtökohtaisesti maakunta- ja yleiskaavoissa kaavakohteeseen, joka on geometrialtaan piste. Asemakaavoissa koodi liittyy kaavakohteeseen, joka on geometrialtaan alue.', 'eri'),
(112, 'ylikulku', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/ylikulku', 'Alueen osan käyttötarkoitus','liikennealue','Ylikulku','Överfart', 'Ilmaisee, että kaavakohde kuvaa ylikulun. Mikäli halutaan tarkentaa millaisesta ylikulusta on kyse, kaavamääräykselle voidaan määritellä lisätietona käyttötarkoituskohdistus, jolle annetaan arvoksi jokin liikennemuotoa kuvaava kaavamääräyslaji esimerkiksi jalankulkualue. Koodi liittyy lähtökohtaisesti maakunta- ja yleiskaavoissa kaavakohteeseen, joka on geometrialtaan piste. Asemakaavoissa koodi liittyy kaavakohteeseen, joka on geometrialtaan alue.', 'yli'),
(113, 'alikulku', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/alikulku', 'Alueen osan käyttötarkoitus','liikennealue','Alikulku','Underfart', 'Ilmaisee, että kaavakohde kuvaa alikulun. Mikäli halutaan tarkentaa millaisesta alikulusta on kyse, kaavamääräykselle voidaan määritellä lisätietona käyttötarkoituskohdistus, jolle annetaan arvoksi jokin liikennemuotoa kuvaava kaavamääräyslaji esimerkiksi jalankulkualue. Koodi liittyy lähtökohtaisesti maakunta- ja yleiskaavoissa kaavakohteeseen, joka on geometrialtaan piste. Asemakaavoissa koodi liittyy kaavakohteeseen, joka on geometrialtaan alue.', 'ali'),
(114, 'katuaukioTaiTori', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/katuaukioTaiTori', 'Alueen osan käyttötarkoitus','liikennealue','Katuaukio tai tori','Öppen plats eller torg', 'Ilmaisee, että kaavakohde kuvaa katuaukion tai torin. Katuaukio/tori on maankäyttö- ja rakennuslain 83 §:n mukaista yleistä aluetta. Katuaukiota tai toria varten voidaan laatia liikennejärjestelysuunnitelma, jossa osoitetaan alueen jäsentely esimerkiksi istutuksin, kulkutein jne. Asemakaavoissa koodi liittyy kaavakohteeseen, joka on geometrialtaan alue.', ''),
(115, 'moottorikelkkailureitti', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/moottorikelkkailureitti', 'Alueen osan käyttötarkoitus','liikennealue','Moottorikelkkailureitti','Snöskoterled', 'Ilmaisee, että kaavakohde kuvaa moottorikelkkailureitin. Reitti voidaan perustaa maastoliikennelain mukaan tai sopimuksilla. Reitin sijainti esimerkiksi taajamissa tai arvokkailla luontoalueilla voi yleiskaavassa olla hyvinkin tarkka. Mikäli moottorikelkkailureitti osoitetaan ohjeellisena tulisi kaavamääräykseen liittää lisätieto, joka kertoo, että kyseessä on ohjeellinen sijainti. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan viiva.', 'moot'),
(116, 'pyorailyalue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/pyorailyalue', 'Alueen osan käyttötarkoitus','liikennealue','Pyöräilyalue','Cykelområde', 'Ilmaisee, että kaavakohde kuvaa pyöräilyalueen tai pyöräilyreitin. Koodi liittyy lähtökohtaisesti yleiskaavoissa kaavakohteeseen, joka on geometrialtaan viiva. Asemakaavoissa koodi liittyy kaavakohteeseen, joka on geometrialtaan alue.', 'pp'),
(117, 'jalankulkualue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/jalankulkualue', 'Alueen osan käyttötarkoitus','liikennealue','Jalankulkualue','Fotgängarområde', 'Ilmaisee, että kaavakohde kuvaa jalankulkualueen tai kävelyreitin.  Koodi liittyy lähtökohtaisesti yleiskaavoissa kaavakohteeseen, joka on geometrialtaan viiva. Asemakaavoissa koodi liittyy kaavakohteeseen, joka on geometrialtaan alue.', 'jk'),
(118, 'pysakoinninAlue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/pysakoinninAlue', 'Alueen käyttötarkoitus','liikennealue','Pysäköinnin alue','Parkeringsområde', 'Ilmaisee, että kaavakohde kuvaa pysäköintiä varten varattavan alueen. Pysäköinnin aluetta kuvaavaan kaavakohteeseen liittyvää kaavamääräystä on usein tarpeen tarkentaa siihen liittyvillä lisätiedoilla. Pysäköinnin alueet voidaan osoittaa joko pysäköintialueiden aluevarauksina tai pysäköimispaikkoja kuvaavina osa-alueina. Auton säilytyspaikkojen rakennusalat osoitetaan rakennusaloina, joihin liitetään lisätietona käyttötarkoituskohdistus, joka kertoo, että kyseessä on pysäköinnin alue. Mikäli kaavakohteen kuvaama alue on tarkoitettu nimenomaan yleiseen pysäköintiin, tulisi kaavamääräykseen liittää lisätieto siitä, että alue on varattu yleiseen käyttöön. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue. Yleiskaavoissa koodi voi myös liittyä kohteeseen, joka on geometrialtaan piste.', 'LPA'),
(119, 'pysakointilaitostenAlue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/pysakointilaitostenAlue', 'Alueen käyttötarkoitus','liikennealue','Pysäköintilaitosten alue','Område för parkeringsanläggningar', 'Ilmaisee, että kaavakohde kuvaa pysäköintilaitosten alueen. Pysäköintilaitosten aluetta kuvaavaan kaavakohteeseen liittyvää kaavamääräystä on usein tarpeen tarkentaa siihen liittyvillä lisätiedoilla. Mikäli kaavakohteen kuvaama alue on tarkoitettu nimenomaan yleiseen pysäköintiin, tulisi kaavamääräykseen liittää lisätieto siitä, että alue on varattu yleiseen käyttöön. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue. Yleiskaavoissa koodi voi myös liittyä kohteeseen, joka on geometrialtaan piste.', 'LPL'),
(120, 'huoltoasemaAlue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/huoltoasemaAlue', 'Alueen käyttötarkoitus','liikennealue','Huoltoasema-alue','Område för servicestation', 'Ilmaisee, että kaavakohde kuvaa huoltoasema-alueen. Huoltoasema-alueina osoitetaan moottoriajoneuvojen huoltoasemaa ja siihen liittyviä korjaamotoimintaa palvelevia rakennuksia varten varattavat alueet. Ilman erityistä kaavamääräystäkin voidaan alueelle rakentaa myös pienehköjä huoltoasemaan liittyviä kahvila- ja ravintolatiloja sekä kioskikauppaan verrattavia myymälätiloja (Kioskikaupan käsite on määritelty laissa vähittäiskaupan sekä parturi- ja kampaamoliikkeen aukioloajoista 1297/2000). Mikäli alueelle halutaan mahdollistaa muiden myymälä- ja ravintolatilojen rakentaminen tulisi kaavakohteeseen liittää myös kaavamääräys, joka ilmaisee, että kyseessä on myymälärakennusten tai liikerakennusten alue. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue. Yleiskaavoissa koodi voi myös liittyä kohteeseen, joka on geometrialtaan piste.', 'LH'),
(121, 'polttoaineenJakeluasema', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/polttoaineenJakeluasema', 'Alueen osan käyttötarkoitus','liikennealue','Polttoaineen jakeluasema','Försäljningsplats för drivmedel', 'Ilmaisee, että kaavakohde kuvaa polttoaineen jakeluasemalle osoitettavan alueen. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue.', 'pj'),
(122, 'raideliikenteenAlue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/raideliikenteenAlue', 'Alueen käyttötarkoitus','liikennealue','Raideliikenteen alue','Område för spårtrafik', 'Ilmaisee, että kaavakohde kuvaa raideliikenteen alueen. Raideliikenteen alueina osoitetaan asemakaavoissa rautatiealueet sekä niihin liittyvät terminaali-, huolto- ym. rakennuksia varten varattavat alueet. Rakentamisesta määrätään tarpeen mukaan kaavassa. Metro, mahdolliset pikaraitiotiet, kaupunkirata jne. voidaan osoittaa tarvittaessa kaavamääräykselle lisätietona annettavan käyttötarkoituskohdistuksen avulla. Samoin muuta kuin yleisesti ylläpidettäväksi tarkoitettua rautatietä varten varattavat teollisuusraide- tai vastaavat alueet voidaan osoittaa, siten kaavamääräykselle voidaan määritellä lisätietona käyttötarkoituskohdistus, jolle annetaan arvoksi jokin raidealueen tarkempaa käyttötarkoitusta kuvaava kaavamääräyslaji esimerkiksi satama tai teollisuusalue. Tällöin tarkemman käyttötarkoituksen tulisi käydä ilmi kaavamääräysryhmän otsikoinnista. Liikenteellisen merkityksensä mukaan raideliikenteen alueita kuvaavat radat ovat pääratoja, yhdysratoja, sivuratoja tai kaupunkiratoja. Lisäksi kaavoissa voidaan osoittaa metro- ja raitioteiden linjauksia. Mikäli toiminnan luonne on määritelty tarkemmin tulisi maakunta-  ja yleisasemakaavoissa käyttää tarkempia raideliikenteen alakoodeja. Maakuntakaavoissa maantiealueilla on lähtökohtaisesti voimassa MRL 33 §:n mukainen rakentamisrajoitus. Tämä voidaan mainita kaavakohteeseen liittyvänä sanallisena määräyksenä. Asemakaavoissa koodi liittyy kaavakohteeseen, joka on geometrialtaan alue. Yleis- ja maakuntakaavoissa koodi voi liittyä kaavakohteeseen, joka on geometrialtaan alue, viiva tai piste.', 'LR'),
(123, 'rautatienNakemaAlue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/rautatienNakemaAlue', 'Alueen osan käyttötarkoitus','liikennealue','Rautatien näkemäalue','Frisiktsområde för järnväg', 'Ilmaisee, että kaavakohde kuvaa kaavassa osoitettavan rautatien näkemäalueen. Koodi liittyy kaavakohteeseen, joka on geometrialtaan alue.', 'rtnä'),
(124, 'rautatienSuojaAlue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/rautatienSuojaAlue', 'Alueen osan käyttötarkoitus','liikennealue','Rautatien suoja-alue','Skyddsområde för järnväg', 'Ilmaisee, että kaavakohde kuvaa kaavassa osoitettavan rautatien suoja-alueen. Koodi liittyy kaavakohteeseen, joka on geometrialtaan alue.', 'rtsu'),
(125, 'paarata', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/paarata', 'Alueen osan käyttötarkoitus','liikennealue','Päärata','Huvudbana', 'Ilmaisee, että kaavakohde kuvaa raideliikenteen pääradan. Pääratoina osoitetaan tärkeimmät kansainvälisen liikenteen rataosat, valtakunnan osakeskuksia ja merkittävimpiä maakunta- ja kaupunkikeskuksia yhdistävät rataosat sekä merkittävimpiin satamiin ja tärkeimmille rajanylistyspaikoille johtavat radat. Koodi liittyy kaavakohteeseen, joka on geometrialtaan viiva.', 'pr'),
(126, 'yhdysrata', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/yhdysrata', 'Alueen osan käyttötarkoitus','liikennealue','Yhdysrata','Förbindelsebana', 'Ilmaisee, että kaavakohde kuvaa raideliikenteen yhdysradan. Koodi liittyy kaavakohteeseen, joka on geometrialtaan viiva.', 'yr'),
(127, 'sivurata', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/sivurata', 'Alueen osan käyttötarkoitus','liikennealue','Sivurata','Bibana', 'Ilmaisee, että kaavakohde kuvaa raideliikenteen sivuradan. Koodi liittyy kaavakohteeseen, joka on geometrialtaan viiva.', 'siv'),
(128, 'kaupunkirata', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/kaupunkirata', 'Alueen osan käyttötarkoitus','liikennealue','Kaupunkirata','Stadsbana', 'Ilmaisee, että kaavakohde kuvaa raideliikenteen kaupunkiradan. Koodi liittyy kaavakohteeseen, joka on geometrialtaan viiva.', 'kr'),
(129, 'metro', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/metro', 'Alueen osan käyttötarkoitus','liikennealue','Metro','Metro', 'Ilmaisee, että kaavakohde kuvaa metrolinjan. Koodi liittyy kaavakohteeseen, joka on geometrialtaan viiva.', 'metro'),
(130, 'raitiotie', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/raitiotie', 'Alueen osan käyttötarkoitus','liikennealue','Raitiotie','Spårväg', 'Ilmaisee, että kaavakohde kuvaa raitiotien. Koodi liittyy kaavakohteeseen, joka on geometrialtaan viiva.', 'rt'),
(131, 'varikko', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/varikko', 'Alueen käyttötarkoitus','liikennealue','Varikko','Depå', 'Ilmaisee, että kaavakohde kuvaa varikkoalueen. Koodi liittyy kaavakohteeseen, joka on geometrialtaan viiva tai piste.', 'LHV'),
(132, 'henkiloliikenteenTerminaalialue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/henkiloliikenteenTerminaalialue', 'Alueen käyttötarkoitus','liikennealue','Henkilöliikenteen terminaalialue','Terminalområde för persontrafik', 'Ilmaisee, että kaavakohde kuvaa henkilöliikenteen terminaalialueen. Henkilöliikenneterminaaleina voidaan osoitetaan matkakeskuksia, linja-auto-, tai metroasemia varten varattavat alueet. Mikäli toiminnan luonne on määritelty tarkemmin tulisi maakunta-  ja yleisasemakaavoissa käyttää tarkempia henkilöliikenneterminaalin alakoodeja.  Alueilla voi sijaita myös myymälä-, ravintola- ja muita vastaavia toimintoja. Mahdollisuudesta toteuttaa asemien yhteyteen huomattavan suuria kaupan ja palvelun tiloja on syytä mainita erikseen. Mikäli alueelle halutaan mahdollistaa muiden myymälä- ja ravintolatilojen rakentaminen tulisi kaavakohteeseen liittää myös kaavamääräys, joka ilmaisee, että kyseessä on myymälärakennusten tai liikerakennusten alue. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue. Maakunta- ja yleiskaavoissa koodi voi myös liittyä kohteeseen, joka on geometrialtaan piste.', 'LHA'),
(133, 'linjaAutoasema', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/linjaAutoasema', 'Alueen osan käyttötarkoitus','liikennealue','Linja-autoasema','Busstation', 'Ilmaisee, että kaavakohde kuvaa julkisen liikenteen linja-autoaseman. Maakunta- ja yleiskaavoissa koodi liittyy lähtökohtaisesti kohteeseen, joka on geometrialtaan piste.', 'lja'),
(134, 'raideliikenteenAsemaTaiSeisake', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/raideliikenteenAsemaTaiSeisake', 'Alueen osan käyttötarkoitus','liikennealue','Raideliikenteen asema tai seisake','Station eller hållplats för spårtrafik', 'Ilmaisee, että kaavakohde kuvaa raideliikenteen aseman tai seisakkeen. Maakunta- ja yleiskaavoissa koodi liittyy lähtökohtaisesti kohteeseen, joka on geometrialtaan piste.', 'rau'),
(135, 'pysakki', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/pysakki', 'Alueen osan käyttötarkoitus','liikennealue','Pysäkki','Hållplats', 'Ilmaisee, että kaavakohde kuvaa pysäkin. Koodi liittyy kaavakohteeseen, joka on geometrialtaan alue tai piste.', 'pys'),
(136, 'tavaraliikenteenTerminaalialue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/tavaraliikenteenTerminaalialue', 'Alueen käyttötarkoitus','liikennealue','Tavaraliikenteen terminaalialue','Terminalområde för godstrafik', 'Ilmaisee, että kaavakohde kuvaa tavaraliikenteen terminaalialueen. Tavaraliikenteen terminaalialueina osoitetaan terminaalit, esimerkiksi maaliikennekeskukset. Niitä voidaan käyttää myös lyhytaikaiseen varastointiin. Ne kuuluvat osana logistiikkaketjuun ja aiheuttavat yleensä merkittävästi raskasta liikennettä. Mikäli alueelle halutaan mahdollistaa pitkäaikaista varastointia tulisi kaavakohteeseen liittää myös kaavamääräys, joka ilmaisee, että kyseessä on varastoalue. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue. Maakunta- ja yleiskaavoissa koodi voi myös liittyä kohteeseen, joka on geometrialtaan piste.', 'LTA'),
(137, 'joukkoliikenteenAlue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/joukkoliikenteenAlue', 'Alueen osan käyttötarkoitus','liikennealue','Joukkoliikenteen alue','Område för kollektivtrafik', 'Ilmaisee, että kaavakohde kuvaa joukkoliikenteelle varatun alueen tai reitin.  Koodi liittyy lähtökohtaisesti yleiskaavoissa kaavakohteeseen, joka on geometrialtaan viiva. Asemakaavoissa koodi liittyy kaavakohteeseen, joka on geometrialtaan alue.', 'jl'),
(138, 'lentoliikenteenAlue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/lentoliikenteenAlue', 'Alueen käyttötarkoitus','liikennealue','Lentoliikenteen alue','Område för flygtrafik', 'Ilmaisee, että kaavakohde kuvaa lentoliikenteen tai lentokentän alueen. Lentoliikenteen alueina osoitetaan lentotoimintaa varten varattavat alueet. Näitä ovat lentokoneiden liikennealueille, terminaaleille, muille lentoliikennettä palveleville rakennuksille, rakenteille ja toiminnoille varattavat alueet, jotka sisältävät myös alueen toiminnoille tarpeelliset maaliikenneväylät ja -alueet, suoja-alueet, alueen toimintoihin liittyvät yhdyskuntateknisen huollon alueet sekä palvelu- ja toimistotilat. Myös helikopterikentät on syytä osoittaa tätä merkintää käyttäen.  Pääasiassa sotilasilmailun käytössä olevat alueet osoitetaan asianmukaisella, puolustushallinnon kanssa sovittavalla tavalla. Lentoliikenteen meluvyöhykkeet esitetään pääsääntöisesti erikseen omina melualueita kuvaavina kaavakohteinaan. Lentotoiminnan ympäristöhaittojen vähentämiseksi voidaan tarvittaessa antaa myös tarkempia sanallisia kaavamääräyksiä. Maakuntakaavoissa lentoliikenteen alueilla on lähtökohtaisesti voimassa MRL 33 §:n mukainen rakentamisrajoitus. Tämä voidaan mainita kaavakohteeseen liittyvänä sanallisena määräyksenä.  Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue. Maakunta- ja yleiskaavoissa koodi voi myös liittyä kohteeseen, joka on geometrialtaan piste.', 'LL'),
(139, 'satama-alue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/satama-alue', 'Alueen käyttötarkoitus','liikennealue','Satama-alue','Hamn', 'Ilmaisee, että kaavakohde kuvaa sataman tai satama-alueen. Satama-alueina osoitetaan satama-alueet ja niihin liittyvät terminaali-, varasto- ym. rakennusten vaatimat alueet. Rakentamisesta määrätään tarpeen mukaan kaavassa. Satama-aluetta kuvaava kaavakohde tulisi rajata siten, että se kattaa satamaa varten tarkoitetun maa-alueen sekä sellaiseksi muodostettava tai laituriksi rakennettavan alueen. Vesialueelle sijoittuvat satama-alueen osat voidaan osoittaa erillisinä vesialueen aluevarauksen päälle sijoittuvina kaavakohteinaan, joihin liitetään satamaa koskeva kaavamääräys, jonka tyypiksi on määritelty osa-alue. Maakuntakaavoissa satama-alueilla on lähtökohtaisesti voimassa MRL 33 §:n mukainen rakentamisrajoitus. Tämä voidaan mainita kaavakohteeseen liittyvänä sanallisena määräyksenä. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue. Maakunta- ja yleiskaavoissa koodi voi myös liittyä kohteeseen, joka on geometrialtaan piste.', 'LS'),
(140, 'venesatama', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/venesatama', 'Alueen käyttötarkoitus','liikennealue','Venesatama','Småbåtshamn', 'Ilmaisee, että kaavakohde kuvaa venesataman. Venesatamina osoitetaan venesatamia ja näihin liittyviä rakennelmia ja pieniä rakennuksia, kuten veneilyä palvelevia vajoja tai huoltorakennuksia varten varattavat alueet. Mikäli alueelle halutaan mahdollistaa muiden myymälä- ja ravintolatilojen rakentaminen tulisi kaavakohteeseen liittää myös kaavamääräys, joka ilmaisee, että kyseessä on myymälärakennusten tai liikerakennusten alue. Vesialueelle sijoittuvat venesataman osat voidaan osoittaa erillisinä vesialueen aluevarauksen päälle sijoittuvina kaavakohteinaan, joihin liitetään venesatamaa koskeva kaavamääräys, jonka tyypiksi on määritelty osa-alue. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue. Maakunta- ja yleiskaavoissa koodi voi myös liittyä kohteeseen, joka on geometrialtaan piste.', 'LV'),
(141, 'venevalkama', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/venevalkama', 'Alueen käyttötarkoitus','liikennealue','Venevalkama','Småbåtsplats', 'Ilmaisee, että kaavakohde kuvaa venevalkaman. Venevalkamina osoitetaan venevalkamia ja näihin liittyviä rakennelmia, kuten veneilyä palvelevia vajoja varten varattavat alueet. Vesialueelle sijoittuvat venevalkaman osat voidaan osoittaa erillisinä vesialueen aluevarauksen päälle sijoittuvina kaavakohteinaan, joihin liitetään venevalkamaa koskeva kaavamääräys, jonka tyypiksi on määritelty osa-alue. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue. Maakunta- ja yleiskaavoissa koodi voi myös liittyä kohteeseen, joka on geometrialtaan piste.', 'LVV'),
(142, 'kanava', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/kanava', 'Alueen käyttötarkoitus','liikennealue','Kanava','Kanal', 'Ilmaisee, että kaavakohde kuvaa kanavan. Kanava on kahta vesistönosaa yhdistävä kapea väylänosa, joka on usein joko kokonaan tai osittain kaivettu maalle (ks. Vesiväyliin liittyvät käsitteet, 552253/03.04.01.01/2021. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue.', 'LK'),
(143, 'laivavayla', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/laivavayla', 'Alueen osan käyttötarkoitus','liikennealue','Laivaväylä','Farled', 'Ilmaisee, että kaavakohde kuvaa laivaväylän. Laivaväyliä ovat ensisijaisesti kauppamerenkulun tai muun hyötyliikenteen käyttöön tarkoitetut väylät. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan viiva.', 'lv'),
(144, 'venevayla', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/venevayla', 'Alueen osan käyttötarkoitus','liikennealue','Veneväylä','Småbåtsled', 'Ilmaisee, että kaavakohde kuvaa veneväylän. Veneväyliä ovat veneilyn runkoväylät, alueellisesti merkittävät veneilyn pääväylät ja veneilyn käyttöön tarkoitetut paikalliset väylät. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan viiva.', 'vv'),
(145, 'lossiTaiLauttaYhteys', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/lossiTaiLauttaYhteys', 'Alueen osan käyttötarkoitus','liikennealue','Lossi- tai lauttayhteys','Färjförbindelse', 'Ilmaisee, että kaavakohde kuvaa lossi- tai lauttayhteyden. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan viiva.', 'ly'),
(146, 'vesialue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/vesialue', 'Alueen käyttötarkoitus','','Vesialue','Vattenområde', 'Ilmaisee, että kaavakohde kuvaa vesialueen. Vesialueen aluevarauksina osoitetaan sellaiset alueet, jotka on tarkoitettu säilytettäviksi vesialueena. Pienialaiset ja erityisesti vedenmäärältään vaihtelevat alueet, kuten ojat tai hulevesialtaat voidaan osoittaa jonkin toisen aluevarauksen päälle sijoittuvina omina kaavakohteinaan, joihin liittyy vesialuetta koskeva kaavamääräys, jonka tyypiksi on määritelty osa-alue. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue.', 'W'),
(147, 'pohjavesialue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/pohjavesialue', 'Alueen osan käyttötarkoitus','vesialue','Pohjavesialue','Grundvattenområde', 'Ilmaisee, että kaavakohde kuvaa pohjavesialueen. Vaikka pohjavesialueen rajausta ei päätetä kaavassa, pohjavesialuetta kuvaava kaavakohde voi olla tarpeen osoittaa, mikäli siihen liittyen on tarpeen antaa vesiensuojelua koskevia sanallisia kaavamääräyksiä.  Vastaavaa merkintää voidaan käyttää myös pintavesialueiden suojeluun. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue.', 'pv'),
(148, 'ymparistoarvojenAlue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/ymparistoarvojenAlue', 'Alueen osan käyttötarkoitus','','Ympäristöarvojen alue (OTSIKKO)','Område för miljövärden', 'Koodistoa jäsentävä otsikkotason koodi, jota ei käytetä kaavamääräyksissä. Ympäristöarvojen alueet tulisi kaavoissa luokitella niiden käyttötarkoitusta tarkemmin kuvaavalla kaavamääräyslaji-koodiarvolla.', ''),
(149, 'suojelualue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/suojelualue', 'Alueen osan käyttötarkoitus','ymparistoarvojenAlue','Suojelualue','Skyddsområde', 'Ilmaisee, että kaavakohde kuvaa suojelualueen. Suojelualueina osoitetaan alueet, joilla on useita eri perustein suojeltavia kohteita. Suojelualueina voidaan osoittaa alueet, joiden suojeluperusteita ei ole tarpeellista tai mahdollista yksilöidä erikseen. Mikäli suojelualuetta koskevaa kaavamääräystä käytetään kulttuuriympäristön suojelemiseen, tulisi kaavakohteeseen liittää täsmentävä sanallinen määräys, joka kertoo millaisia suojelumääräyksiä kaavakohteeseen liittyy. Mikäli suojelun perusteena on selkeästi rakennussuojelu tai luonnonsuojelu tulisi käyttää kyseisiä koodeja. Suojelualueet voidaan esittää joko aluevarauksina tai osa-alueina. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue. Maakunta- ja yleiskaavoissa koodi voi myös liittyä kohteeseen, joka on geometrialtaan piste.', 'S'),
(150, 'luonnonsuojelualue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/luonnonsuojelualue', 'Alueen osan käyttötarkoitus','ymparistoarvojenAlue','Luonnonsuojelualue','Naturskyddsområde', 'Ilmaisee, että kaavakohde kuvaa luonnonsuojelulain (9/2023) mukaisen luonnonsuojelualueen. Luonnonsuojelualueet voidaan esittää joko aluevarauksina tai osa-alueina. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue. Maakunta- ja yleiskaavoissa koodi voi myös liittyä kohteeseen, joka on geometrialtaan piste.', 'SL'),
(151, 'natura2000VerkostonAlue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/natura2000VerkostonAlue', 'Alueen osan käyttötarkoitus','ymparistoarvojenAlue','Natura 2000 -verkoston alue','Område som hör till nätverket Natura 2000', 'Ilmaisee, että kaavakohde kuvaa Natura 2000 -verkostoon kuuluvan alueen. Alueet on kuvattu Ympäristöministeriön asetuksessa Natura 2000 –verkostoon kuuluvien alueiden luettelosta (354/2015). Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue. Maakunta- ja yleiskaavoissa koodi voi myös liittyä kohteeseen, joka on geometrialtaan piste tai viiva.', 'nat'),
(152, 'rakennussuojelualue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/rakennussuojelualue', 'Alueen käyttötarkoitus','ymparistoarvojenAlue','Rakennussuojelualue','Byggnadsskyddsområde', 'Ilmaisee, että kaavakohde kuvaa yhden tai useamman suojeltavan rakennuksen muodostaman alueen. Rakennussuojelualueet voidaan osoittaa joko aluevarauksina tai osa-alueina. Osa-alueet voivat olla myös rakennusaloja tai rakennusalan osia. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue. Maakunta- ja yleiskaavoissa koodi voi myös liittyä kohteeseen, joka on geometrialtaan piste.', 'SR'),
(153, 'rakennusperinnonSuojelemisestaAnnetunLainNojallaSuojeltuRakennus', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/rakennusperinnonSuojelemisestaAnnetunLainNojallaSuojeltuRakennus', 'Alueen käyttötarkoitus','ymparistoarvojenAlue','Rakennusperinnön suojelemisesta annetun lain nojalla suojeltu rakennus','Byggnad som har skyddats med stöd av lagen om skyddande av byggnadsarvet', 'Ilmaisee, että kaavakohde kuvaa rakennuksen tai alueen, joka on rakennusperinnön suojelemisesta annetun lain (498/2010) tai sitä edeltäneiden säädösten nojalla suojeltu. Rakennusperinnön suojelemisesta annetun lain nojalla suojellut rakennukset tai alueet voidaan osoittaa joko aluevarauksina tai osa-alueina. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue. Maakunta- ja yleiskaavoissa koodi voi myös liittyä kohteeseen, joka on geometrialtaan piste.', 'SRS'),
(154, 'valtionOmistamienRakennustenSuojelustaAnnetunAsetuksenNojallaSuojeltuRakennus', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/valtionOmistamienRakennustenSuojelustaAnnetunAsetuksenNojallaSuojeltuRakennus', 'Alueen osan käyttötarkoitus','ymparistoarvojenAlue','Valtion omistamien rakennusten suojelusta annetun asetuksen nojalla suojeltu rakennus','Byggnad som har skyddats med stöd av förordningen om skydd för staten tillhöriga byggnader', 'Ilmaisee, että kaavakohde kuvaa rakennuksen tai alueen, joka on valtion omistamien rakennusten suojelusta annetun asetuksen (480/1985) tai sitä edeltäneiden asetusten nojalla suojeltu. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue. Maakunta- ja yleiskaavoissa koodi voi myös liittyä kohteeseen, joka on geometrialtaan piste.', 'sra'),
(155, 'suojeltuKirkollinenRakennus', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/suojeltuKirkollinenRakennus', 'Alueen osan käyttötarkoitus','ymparistoarvojenAlue','Suojeltu kirkollinen rakennus','Kyrklig byggnad', 'Ilmaisee, että kaavakohde kuvaa rakennuksen tai alueen, joka on suojeltu kirkkolain (652/2023) nojalla. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue. Maakunta- ja yleiskaavoissa koodi voi myös liittyä kohteeseen, joka on geometrialtaan piste.', 'srk'),
(156, 'suojeltuOrtodoksinenKirkkoTaiRukoushuone', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/suojeltuOrtodoksinenKirkkoTaiRukoushuone', 'Alueen osan käyttötarkoitus','ymparistoarvojenAlue','Suojeltu ortodoksinen kirkko tai rukoushuone','Ortodox kyrka eller bönehus', 'Ilmaisee, että kaavakohde kuvaa kirkon tai rukoushuoneen, joka on suojeltu ortodoksisesta kirkosta annetulla lailla (985/2006). Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue. Maakunta- ja yleiskaavoissa koodi voi myös liittyä kohteeseen, joka on geometrialtaan piste.', 'srko'),
(157, 'muinaismuistoAlue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/muinaismuistoAlue', 'Alueen käyttötarkoitus','ymparistoarvojenAlue','Muinaismuistoalue','Fornminnesområde', 'Ilmaisee, että kaavakohde kuvaa muinaismuistolain (295/1963) mukaisen muinaismuistoalueen tai kohteen. Munaismuistoalueet voidaan osoittaa joko aluevarauksina tai osa-alueina. Asemakaavassa kiinteät muinaisjäännökset osoitetaan yleensä aluevarauksina. Jos muinaisjäännös sijaitsee jonkin muun käyttötarkoitusmerkinnän alueella, voidaan muinaismuisto alue osoittaa myös osa-alueena. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue. Maakunta- ja yleiskaavoissa koodi voi myös liittyä kohteeseen, joka on geometrialtaan piste.', 'SM'),
(158, 'luonnonMonimuotoisuudenKannaltaErityisenTarkeaAlue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/luonnonMonimuotoisuudenKannaltaErityisenTarkeaAlue', 'Alueen osan käyttötarkoitus','ymparistoarvojenAlue','Luonnon monimuotoisuuden kannalta erityisen tärkeä alue','Område som är särskilt viktigt med tanke på naturens mångfald', 'Ilmaisee, että kaavakohde kuvaa luonnon monimuotoisuuden kannalta tärkeän alueen. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue. Maakunta- ja yleiskaavoissa koodi voi myös liittyä kohteeseen, joka on geometrialtaan piste.', 'luo'),
(159, 'luonnonRauhanKannaltaTarkeaAlue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/luonnonRauhanKannaltaTarkeaAlue', 'Alueen osan käyttötarkoitus','ymparistoarvojenAlue','Luonnon rauhan kannalta tärkeä alue','Område som är viktigt med tanke på naturens fred', 'Ilmaisee, että kaavakohde kuvaa luonnon rauhan kannalta tärkeän alueen. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue. Maakunta- ja yleiskaavoissa koodi voi myös liittyä kohteeseen, joka on geometrialtaan piste.', 'luor'),
(160, 'arvokasGeologinenMuodostuma', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/arvokasGeologinenMuodostuma', 'Alueen osan käyttötarkoitus','ymparistoarvojenAlue','Arvokas geologinen muodostuma','Värdefull geologisk formation', 'Ilmaisee, että kaavakohde kuvaa arvokkaan geologisen muodostuman.', 'ge'),
(161, 'merkittavaRakennettuKulttuuriymparisto', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/merkittavaRakennettuKulttuuriymparisto', 'Alueen osan käyttötarkoitus','ymparistoarvojenAlue','Merkittävä rakennettu kulttuuriympäristö','Betydande byggd kulturmiljö', 'Ilmaisee, että kaavakohde kuvaa merkittävän rakennetun kulttuuriympäristön alueen. Merkittävyyden taso ilmaistaan kaavamääräyksen lisätiedonlaji -koodiston arvoilla. Lisätiedon "Merkittävyys" avulla voidaan kuvata paikallisesti, maakunnallisesti tai kansainvälisesti merkittävät rakennetut kulttuuriympäristöt. Koodi voi liittyä kohteeseen, joka on geometrialtaan alue, piste tai viiva.', 'ky'),
(162, 'valtakunnallisestiMerkittavaRakennettuKulttuuriymparisto', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/valtakunnallisestiMerkittavaRakennettuKulttuuriymparisto', 'Alueen osan käyttötarkoitus','ymparistoarvojenAlue','Valtakunnallisesti merkittävä rakennettu kulttuuriympäristö','Nationellt betydande byggd kulturmiljö', 'Ilmaisee, että kaavakohde kuvaa valtakunnallisesti merkittävän rakennetun kulttuuriympäristön kohteen. Merkittävyydeltään "valtakunnallisiksi" määritetyillä kohteilla tarkoitetaan RKY-inventoinnin kohteita, jotka perustuvat valtakunnallisten alueidenkäyttötavoitteiden (VAT) mukaiseen inventointiin. Koodi voi liittyä kohteeseen, joka on geometrialtaan alue, piste tai viiva.', 'rky'),
(163, 'kaupunkiTaiKylakuvallisestiArvokasAlue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/kaupunkiTaiKylakuvallisestiArvokasAlue', 'Alueen osan käyttötarkoitus','ymparistoarvojenAlue','Kaupunki- tai kyläkuvallisesti arvokas alue','Område som är värdefullt med tanke på stads- eller bybilden', 'Ilmaisee, että kaavakohde kuvaa kaupunki- tai kyläkuvallisesti arvokkaan alueen. Kyläkuvallisesti arvokkaina alueina osoitetaan esimerkiksi kylät, joissa on useita kulttuurimaisemaan liittyviä, historiallisesti tai taajamakuvan kannalta arvokkaita rakennuksia pihapiireineen. Kaupunkikuvallisesti arvokkaina alueina voidaan osoittaa myös taajaman yhtenäisen tai omaleimaisen, yleensä tiettyyn ajanjaksoon tai tyyliin kuuluvan rakennetun ympäristön osa-alueet. Kaavamääräyksessä tulisi mainita mitä ja miten arvoja (esimerkiksi rakennustaiteellisia, historiallisia ja ympäristökuvallisia) kaavamääräyksellä pyritään nimenomaisesti turvaamaan.  Koodi voi liittyä kohteeseen, joka on geometrialtaan alue, piste tai viiva.', 'sk'),
(164, 'muuArkeologinenKohde', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/muuArkeologinenKohde', 'Alueen osan käyttötarkoitus','ymparistoarvojenAlue','Muu arkeologinen kohde','Annat arkeologiskt objekt', 'Ilmaisee, että kaavakohde kuvaa muun arkeologisen kohteen, joka ei ole muinaismuistolain nojalla rauhoitettu kiinteä muinaisjäännös. Muuna arkeologisena kohteena osoitetaan alueita tai paikkoja, joilla on arkeologista merkitystä. Kohteet voivat olla esimerkiksi toisen maailmansodan aikaisia linnoitteita, historiallisen ajan kyläpaikkoja, 1800-luvun lopulle tai 1900-luvun alkuun ajoittuvia rakenteiden jäännöksiä. Koodi liittyy kohteeseen, joka on geometrialtaan alue, piste tai viiva.', 'ark'),
(165, 'valtakunnallisestiMerkittavaArkeologinenKohde', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/valtakunnallisestiMerkittavaArkeologinenKohde', 'Alueen osan käyttötarkoitus','ymparistoarvojenAlue','Valtakunnallisesti merkittävä arkeologinen kohde','Nationellt betydande arkeologiskt objekt', 'Ilmaisee, että kaavakohde kuvaa valtakunnallisesti merkittävän arkeologisen kohteen. Merkittävyydeltään "valtakunnallisiksi" määritetyillä kohteilla tarkoitetaan VARK-inventoinnin kohteita, jotka perustuvat valtakunnallisten alueidenkäyttötavoitteiden (VAT) mukaiseen inventointiin. Koodi liittyy kohteeseen, joka on geometrialtaan alue, piste tai viiva.', 'vark'),
(166, 'historiallinenKohde', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/historiallinenKohde', 'Alueen osan käyttötarkoitus','ymparistoarvojenAlue','Historiallinen kohde','Historisk objekt', 'Ilmaisee, että kaavakohde kuvaa historiallisen kohteen. Tällaisia voivat olla esimerkiksi historialliset tiet tai muut historialliset kulttuuriperintökohteet, joihin liittyen kaavassa on tarpeen antaa kaavamääräyksiä. Kaavamääräyksessä tulisi mainita mitä ja miten arvoja kaavamääräyksellä pyritään nimenomaisesti turvaamaan. Koodi voi liittyä kohteeseen, joka on geometrialtaan alue, piste tai viiva.', 'his'),
(167, 'unesconMaailmanperintokohde', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/unesconMaailmanperintokohde', 'Alueen osan käyttötarkoitus','ymparistoarvojenAlue','UNESCO:n maailmanperintökohde','Objekt som ingår i UNESCO:s världsarvslista', 'Ilmaisee, että kaavakohde kuvaa UNESCO:n maailmanperintöluetteloon kuuluvan kulttuuri- tai luontokohteen. Koodi voi liittyä kohteeseen, joka on geometrialtaan alue, piste tai viiva.', 'un'),
(168, 'saamelaiskulttuurinKannaltaTarkeaAlue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/saamelaiskulttuurinKannaltaTarkeaAlue', 'Alueen osan käyttötarkoitus','ymparistoarvojenAlue','Saamelaiskulttuurin kannalta tärkeä alue','Område som är viktigt med tanke på den samiska kulturen', 'Ilmaisee, että kaavakohde kuvaa saamelaiskulttuurin kannalta tärkeän alueen. Kaavakohteeseen voi olla tarpeen liittää myös sanallinen kaavamääräys, joilla tarkennetaan kaavakohteeseen liittyvää määräystä. Koodi voi liittyä kohteeseen, joka on geometrialtaan alue, piste tai viiva.', 'saame'),
(169, 'maisemallisestiArvokasAlue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/maisemallisestiArvokasAlue', 'Alueen osan käyttötarkoitus','ymparistoarvojenAlue','Maisemallisesti arvokas alue','Landskapsmässigt värdefullt område', 'Ilmaisee, että kaavakohde kuvaa maisemallisesti arvokkaan alueen. Lisätiedon "Merkittävyys" avulla voidaan kuvata paikallisesti, maakunnallisesti tai kansainvälisesti arvokkaat maisema-alueet. Koodi liittyy lähtökohtaisesti kohteeseen, joka on geometrialtaan alue.', 'ma'),
(170, 'maisemanhoitoalue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/maisemanhoitoalue', 'Alueen osan käyttötarkoitus','ymparistoarvojenAlue','Maisemanhoitoalue','Landskapsvårdsområde', 'Ilmaisee, että kaavakohde kuvaa luonnonsuojelulain 91 §:n mukaisen maisemanhoitoalueen. Koodi liittyy lähtökohtaisesti kohteeseen, joka on geometrialtaan alue.', 'mai'),
(171, 'valtakunnallisestiArvokasMaisemaAlue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/valtakunnallisestiArvokasMaisemaAlue', 'Alueen osan käyttötarkoitus','ymparistoarvojenAlue','Valtakunnallisesti arvokas maisema-alue','Nationellt värdefullt landskapsområde', 'Ilmaisee, että kaavakohde kuvaa valtakunnallisesti arvokkaan maisema-alueen. Merkittävyydeltään "valtakunnallisiksi" määritetyillä kohteilla tarkoitetaan VAMA-inventoinnin kohteita, jotka perustuvat valtakunnallisten alueidenkäyttötavoitteiden (VAT) mukaiseen inventointiin. Koodi liittyy lähtökohtaisesti kohteeseen, joka on geometrialtaan alue.', 'vama'),
(172, 'kansallinenKaupunkipuisto', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/kansallinenKaupunkipuisto', 'Alueen osan käyttötarkoitus','ymparistoarvojenAlue','Kansallinen kaupunkipuisto','Nationalstadspark', 'Ilmaisee, että kaavakohde kuvaa MRL 9 luvussa tarkoitetun kansallisen kaupunkipuiston. Koodi liittyy lähtökohtaisesti kohteeseen, joka on geometrialtaan alue.', 'kp'),
(173, 'ymparistohairioalue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/ymparistohairioalue', 'Alueen osan käyttötarkoitus','','Ympäristöhäiriöalue','Område med miljöstörning', 'Ilmaisee, että kaavakohde kuvaa alueen, jolla on ympäristöhäiriöitä tai niiden riski. Koodia voidaan käyttää myös kuvaamaan ympäristö- tai maisemavaurion korjaustarvetta tai terveyshaitan poistamistarvetta. Kaavakohteeseen voi olla tarpeen liittää myös sanallinen kaavamääräys, joilla tarkennetaan kaavakohteeseen liittyvää määräystä. Koodi liittyy kaavakohteeseen, joka on geometrialtaan alue, viiva tai piste.', 'häiriö'),
(174, 'melualue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/melualue', 'Alueen osan käyttötarkoitus','ymparistohairioalue','Melualue','Bullerområde', 'Ilmaisee, että kaavakohde kuvaa alueen, jolla esiintyy siinä määrin melua, että siitä voi aiheutua merkittävää haittaa. Kaavakohteeseen voi olla tarpeen liittää myös sanallinen kaavamääräys, joilla tarkennetaan kaavakohteeseen liittyvää määräystä. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue.', 'me'),
(175, 'tarinaAlue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/tarinaAlue', 'Alueen osan käyttötarkoitus','ymparistohairioalue','Tärinäalue','Vibrationsområde', 'Ilmaisee, että kaavakohde kuvaa alueen, jolla esiintyy siinä määrin tärinää, että siitä voi aiheutua merkittävää haittaa. Kaavakohteeseen voi olla tarpeen liittää myös sanallinen kaavamääräys, joilla tarkennetaan kaavakohteeseen liittyvää määräystä. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue.', 'tärinä'),
(176, 'tulvariskialue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/tulvariskialue', 'Alueen osan käyttötarkoitus','ymparistohairioalue','Tulvariskialue','Område med risk för översvämning', 'Ilmaisee, että kaavakohde kuvaa alueen, jolla on tunnistettu tulvimisvaara. Tulvariskialue on (maantieteellinen) alue, jolle tulvavaara aiheuttaa vahinkoriskin, ts. alue, jolla vallitsee tulvavaara ja jolla on sellainen vahinkopotentiaali (haavoittuvuus) että tulva aiheuttaisi vahinkoja. Merkittävällä tulvariskialueella tarkoitetaan tulvariskilainsäädännön mukaisesti nimettyä, tulvariskien alustavan arvioinnin perusteella tunnistettua aluetta (SYKE, Tulvasanasto). Kaavakohteeseen voi olla tarpeen liittää myös sanallinen kaavamääräys, joilla tarkennetaan kaavakohteeseen liittyvää määräystä. Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue.', 'tulva'),
(177, 'radonriskialue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/radonriskialue', 'Alueen osan käyttötarkoitus','ymparistohairioalue','Radonriskialue','Radonriskområde', 'Ilmaisee, että kaavakohde kuvaa alueen, jolla maaperästä saattaa erittyä radonkaasua siinä määrin, että siitä voi aiheutua terveyshaittaa. Radonhaitta on huomioitava rakennettaessa. Kaavakohteeseen voi olla tarpeen liittää myös sanallinen kaavamääräys, joilla tarkennetaan kaavakohteeseen liittyvää määräystä. Lisätietoja Säteilyturvakeskuksen julkaisussa: Kansallinen toimintasuunnitelma radonista aiheutuvien riskien ehkäisemiseksi, https://julkaisut.valtioneuvosto.fi/handle/10024/162383 Koodi liittyy lähtökohtaisesti kaavakohteeseen, joka on geometrialtaan alue.', 'radon'),
(178, 'pilaantunutMaaAlue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/pilaantunutMaaAlue', 'Alueen osan käyttötarkoitus','ymparistohairioalue','Pilaantunut maa-alue','Förorenat markområde', 'Ilmaisee, että kaavakohde kuvaa alueen, jolla on ihmisen toiminnan seurauksena haitallisia aineita siinä määrin, että niistä aiheutuu haittaa tai merkittävä riski ympäristölle tai terveydelle, viihtyisyyden vähentymistä tai muuta niihin verrattavissa olevaa haittaa. Kaavakohteeseen voi olla tarpeen liittää myös sanallinen kaavamääräys, joilla tarkennetaan kaavakohteeseen liittyvää määräystä. Koodi liittyy kaavakohteeseen, joka on geometrialtaan alue tai piste.', 'pima'),
(179, 'vaaraAlue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/vaaraAlue', 'Alueen osan käyttötarkoitus','ymparistohairioalue','Vaara-alue','Faroområde', 'Ilmaisee, että kaavakohde kuvaa vaara-alueen. Vaara-alueena osoitetaan alue, jolla liikkuminen on turvallisuussyistä rajoitettu tai sitä on tarkoitus rajoittaa. Näitä voivat olla esimerkiksi puolustusvoimien käytössä olevat alueet sekä tehdas- ja voimalaitosten lähivyöhykkeet. Puolustusvoimien alueisiin liittyvien tietoturvakysymysten vuoksi on niitä koskevia kaavoja valmisteltaessa syytä neuvotella erikseen puolustushallinnon kanssa. Kaavakohteeseen voi olla tarpeen liittää myös sanallinen kaavamääräys, joilla tarkennetaan kaavakohteeseen liittyvää määräystä. Koodi liittyy kaavakohteeseen, joka on geometrialtaan alue.', 'vaara'),
(180, 'suojavyohyke', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/suojavyohyke', 'Alueen osan käyttötarkoitus','ymparistohairioalue','Suojavyöhyke','Skyddszon', 'Ilmaisee, että kaavakohteen kuvaa alueen, jolla alueiden käyttöä on läheisen vaara-alueen tai muun ympäristöönsä käyttörajoituksia aiheuttavan toiminnan luonteen vuoksi rajoitettava. Mikäli alueeseen liittyy rakentamisrajoitus, tulee kaavakohteeseen liittää kaavamääräys, joka ilmaisee, että alueelle voimassa rakentamisrajoitus. Koodi liittyy kaavakohteeseen, joka on geometrialtaan alue.', 'suojav'),
(181, 'konsultointivyohyke', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/konsultointivyohyke', 'Alueen osan käyttötarkoitus','ymparistohairioalue','Konsultointivyöhyke','Konsultationszon', 'Ilmaisee, että kaavakohde kuvaa konsultointivyöhykkeen. Kaavakohteella voidaan ilmaista myös SEVESO III-direktiivin mukaisen laitoksen konsultointivyöhyke. Seveso III -direktiivin mukaiset laitokset ovat laitoksia, joiden toiminnan laajuus on turvallisuusselvityslaitos tai toimintaperiaateasiakirjalaitos. Konsultointivyöhykkeellä tapahtuvista kaavoitusmuutoksista tai merkittävämmästä rakentamisesta on pyydettävä lausunto Tukesilta ja pelastusviranomaiselta. Konsultointivyöhyke määritetään lähtökohtaisesti kohteen tontin rajasta. Koodi liittyy kaavakohteeseen, joka on geometrialtaan alue.', 'konsu'),
(182, 'kunnanTaiKaupunginOsa', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/kunnanTaiKaupunginOsa', 'Alueen osan käyttötarkoitus','','Kunnan tai kaupungin osa','Stadsdels- eller kommundelsgräns', 'Ilmaisee, että kaavakohde kuvaa kunnan tai kaupungin osan. Koodi liittyy kaavakohteeseen, joka on geometrialtaan alue.', 'kosa'),
(183, 'korttelialueTaiKorttelialueenOsa', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/korttelialueTaiKorttelialueenOsa', 'Alueen osan käyttötarkoitus','','Korttelialue tai korttelialueen osa','Kvarter', 'Ilmaisee, että kaavakohde kuvaa korttelialueen tai kortelinalueen osan. Koodi liittyy kaavakohteeseen, joka on geometrialtaan alue.', 'kort'),
(184, 'rakennuspaikka', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/rakennuspaikka', 'Alueen osan käyttötarkoitus','','Rakennuspaikka','Byggnadsplats', 'Ilmaisee, että kaavakohde kuvaa paikkaa tai aluetta, jolla on rakennus tai johon voidaan rakentaa yksi tai useampi rakennus. Koodi liittyy kaavakohteeseen, joka on geometrialtaan alue.', 'rakp'),
(185, 'sitovanTonttijaonMukainenTontti', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/sitovanTonttijaonMukainenTontti', 'Alueen osan käyttötarkoitus','rakennuspaikka','Sitovan tonttijaon mukainen tontti','Tomt enligt bindande tomtindelning', 'Ilmaisee, että kaavakohde kuvaa sitovan tonttijaon mukaisen tontin. Koodi liittyy kaavakohteeseen, joka on geometrialtaan alue.', 'tontti'),
(186, 'ohjeellinenRakennuspaikka', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/ohjeellinenRakennuspaikka', 'Alueen osan käyttötarkoitus','rakennuspaikka','Ohjeellinen rakennuspaikka','Riktgivande byggnadsplats', 'Ilmaisee, että kaavakohde kuvaa asemakaavassa osoitettavan ohjeellisen tonttijaon mukaisen rakennuspaikan, josta voidaan käyttää myös nimitystä ohjeellinen tontti. Ohjeellisen tonttijaon mukainen rakennuspaikka ei kuitenkaan ole varsinainen tontti. Koodi liittyy kaavakohteeseen, joka on geometrialtaan alue.', 'orakp'),
(187, 'rakennusala', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/rakennusala', 'Alueen osan käyttötarkoitus','','Rakennusala','Byggnadsyta', 'Ilmaisee, että kaavakohteen alue on rakennusala. Rakennusaloina osoitetaan alueet, joille rakennusten tulee sijoittua. Mikäli halutaan tarkentaa millaisesta rakennusalasta on kyse, kaavamääräykselle voidaan määritellä lisätietona käyttötarkoituskohdistus, jolle annetaan arvoksi jokin rakennusten käyttötarkoitusta kuvaava kaavamääräyslaji. Koodi liittyy kaavakohteeseen, joka on geometrialtaan alue.', 'rak-ala'),
(188, 'rakennusalaJolleSaaSijoittaaTalousrakennuksen', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/rakennusalaJolleSaaSijoittaaTalousrakennuksen', 'Alueen osan käyttötarkoitus','rakennusala','Rakennusala, jolle saa sijoittaa talousrakennuksen','Byggnadsyta där ekonomibyggnad får placeras', 'Ilmaisee, että kaavakohteen alue on rakennusala, jolle saa sijoittaa talousrakennuksen.  Koodi liittyy kaavakohteeseen, joka on geometrialtaan alue.', 't'),
(189, 'rakennusalaJolleSaaSijoittaaSaunan', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/rakennusalaJolleSaaSijoittaaSaunan', 'Alueen osan käyttötarkoitus','rakennusala','Rakennusala, jolle saa sijoittaa saunan','Byggnadsyta där bastu får placeras', 'Ilmaisee, että kaavakohteen alue on rakennusala, jolle saa sijoittaa saunan.  Koodi liittyy kaavakohteeseen, joka on geometrialtaan alue.', 'sa'),
(190, 'rakennusalanSivuJotaKoskeeTarkempiMaarays', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/rakennusalanSivuJotaKoskeeTarkempiMaarays', 'Rakentamistapa','rakennusala','Rakennusalan sivu, jota koskee tarkempi määräys','Den sida av byggnadsytan som omfattas av en närmare bestämmelse', 'Ilmaisee, että kaavakohde kuvaa rakennusalan sivun tai sivuja, jota koskee tarkempi määräys. Kaavakohteeseen tulisi liittää täsmentävä sanallinen määräys, josta käy ilmi millainen rakennusalan sivuun kohdistuva kaavamääräys kaavakohteeseen liittyy. Koodi liittyy kaavakohteeseen, joka on geometrialtaan viiva.', 'rak-siv'),
(191, 'rakennusalanSivuJohonRakennusOnRakennettavaKiinni', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/rakennusalanSivuJohonRakennusOnRakennettavaKiinni', 'Rakentamistapa','rakennusala','Rakennusalan sivu, johon rakennus on rakennettava kiinni','Den sida av byggnadsytan som byggnaden ska tangera', 'Ilmaisee, että kaavakohde kuvaa rakennusalan sivun, johon rakennus on rakennettava kiinni. Koodi liittyy kaavakohteeseen, joka on geometrialtaan viiva.', 'rak-kii'),
(192, 'rakennuksenSivuJossaSuoraUloskayntiPorrashuoneista', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/rakennuksenSivuJossaSuoraUloskayntiPorrashuoneista', 'Rakentamistapa','rakennusala','Rakennuksen sivu, jossa suora uloskäynti porrashuoneista','Den sida av byggnaden som har direkt utgång från trapphusen', 'Ilmaisee, että kaavakohde kuvaa rakennusalan sivun, jolla on järjestettävä suora uloskäynti porrashuoneista. Koodi liittyy kaavakohteeseen, joka on geometrialtaan viiva.', 'rak-ulo'),
(193, 'ikkunatonSeina', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/ikkunatonSeina', 'Rakentamistapa','rakennusala','Ikkunaton seinä','Vägg utan fönster', 'Ilmaisee, että kaavakohde kuvaa rakennusalan sivun, jolla tulee olla ikkunaton seinä. Koodi liittyy kaavakohteeseen, joka on geometrialtaan viiva.', 'ik'),
(194, 'rakennukseenJatettavaKulkuaukko', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/rakennukseenJatettavaKulkuaukko', 'Rakentamistapa','rakennusala','Rakennukseen jätettävä kulkuaukko','Genomfartsöppning i byggnad', 'Ilmaisee, että kaavakohteen geometria kuvaa rakennukseen liittyvää paikkaa, johon tulee jättää kulkuaukko. Koodi liittyy kaavakohteeseen, joka on geometrialtaan alue.', 'x'),
(195, 'uloke', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/uloke', 'Rakentamistapa','rakennusala','Uloke','Utsprång', 'Ilmaisee, että kaavakohteen geometria kuvaa liikenne-, rautatie- tai katualueen osaa, johon saa sijoittaa yläpuolisen rakentamisen vaatimia kantavia rakenteita, jotka eivät haittaa liikennealueen käyttöä. Koodi liittyy kaavakohteeseen, joka on geometrialtaan alue.', 'u'),
(196, 'rakennuksenHarjanSuunta', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/rakennuksenHarjanSuunta', 'Rakentamistapa','rakennusala','Rakennuksen harjan suunta','Riktning för byggnadens takås', 'Koodin avulla kuvataan rakennuksen harjan suunnan. Koodi liittyy kaavakohteeseen, joka on geometrialtaan viiva.', 'harj'),
(197, 'valokatteinenTila', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/valokatteinenTila', 'Rakentamistapa','rakennusala','Valokatteinen tila','Glasövertäckt utrymme', 'Ilmaisee, että kaavakohteen geometria kuvaa alueen osaa, johon tulee rakentaa valokatteinen tila. Koodi liittyy kaavakohteeseen, joka on geometrialtaan alue.', 'v'),
(198, 'alueJotaKoskeeKehittamisperiaate', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/alueJotaKoskeeKehittamisperiaate', 'Alueen osan käyttötarkoitus','','Alue, jota koskee kehittämisperiaate  (OTSIKKO)','Område som omfattas av utvecklingsprincip', 'Koodistoa jäsentävä otsikkotason koodi, jota ei käytetä kaavamääräyksissä. Kehittämisperiaatteita koskevat kaavamääräykset tulisi kaavoissa luokitella niiden käyttötarkoitusta tarkemmin kuvaavalla kaavamääräyslaji-koodiarvolla.', ''),
(199, 'yhdyskuntarakenteenLaajenemissuunta', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/yhdyskuntarakenteenLaajenemissuunta', 'Alueen osan käyttötarkoitus','alueJotaKoskeeKehittamisperiaate','Yhdyskuntarakenteen laajenemissuunta','Utvidgningsriktning för bebyggelsen', 'Ilmaisee, että kaavakohde kuvaa yhdyskuntarakenteen laajenemissuunnan. Mikäli halutaan tarkentaa millaista alueidenkäyttöä laajenevalla yhdyskuntarakenteella tarkoitetaan, kaavamääräykselle voidaan määritellä lisätietona käyttötarkoituskohdistus, jolle annetaan arvoksi jokin yhdyskuntarakenteen laajenemissuunnan käyttötarkoitusta kuvaava kaavamääräyslaji. Koodi liittyy kaavakohteeseen, joka on geometrialtaan viiva.', 'ykr-laa'),
(200, 'kehittamisvyohyke', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/kehittamisvyohyke', 'Alueen osan käyttötarkoitus','alueJotaKoskeeKehittamisperiaate','Kehittämisvyöhyke','Utvecklingszon', 'Ilmaisee, että kaavakohde kuvaa kehittämisvyöhykkeen tai kehittämisen kohdealueen. Mikäli halutaan tarkentaa millaista alueidenkäyttöä alueella kehitetään, kaavamääräykselle voidaan määritellä lisätietona käyttötarkoituskohdistus, jolle annetaan arvoksi jokin kehittämisen käyttötarkoitusta kuvaava kaavamääräyslaji. Kaavakohteeseen tulee liittää täsmentävä sanallinen määräys, joka kertoo, miten aluetta tulee kehittää. Koodi liittyy kaavakohteeseen, joka on geometrialtaan alue.', 'ke-vyö'),
(201, 'selvitysalue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/selvitysalue', 'Alueen osan käyttötarkoitus','alueJotaKoskeeKehittamisperiaate','Selvitysalue','Utredningsområde', 'Ilmaisee, että kaavakohde kuvaa selvitysalueen. Koodi liittyy kaavakohteeseen, joka on geometrialtaan alue.', 'se'),
(202, 'kehittamisalue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/kehittamisalue', 'Alueen osan käyttötarkoitus','','Kehittämisalue','Utvecklingsområde', 'Ilmaisee, että kaavakohde kuvaa maankäyttö- ja rakennuslain luvussa 15 tarkoitetun kehittämisalueen. Kehittämisalueeksi voidaan nimetä rakennettu alue, jonka uudisrakentamista, suojelemista, ympäristön parantamista, käyttötarkoituksen muuttamista tai muuta yleistä tarvetta koskevien tavoitteiden saavuttamiseksi erityiset kehittämis- tai toteuttamistoimenpiteet ovat tarpeen. Kehittämisalueeksi voidaan nimetä myös rakentamaton alue, milloin sen rakentaminen on asunto- tai elinkeinopoliittisista syistä tarpeen ja sen toteuttaminen maanomistuksen pirstoutuneisuudesta, kiinteistöjaotuksen hajanaisuudesta tai muusta vastaavasta syystä edellyttää kehittämis- tai toteuttamistoimenpiteitä. Kehittämisalueeksi nimeämisellä pyritään erityisjärjestelyjen avulla uudistamaan kunnan tiettyä osa-aluetta, esimerkiksi muuttamaan vanhan teollisuusalueen käyttötarkoitusta. Alueella on mahdollista käyttää MRL 112 §:ssä lueteltuja erityisjärjestelyjä, kuten erityisten asunto- tai elinkeinopoliittisten tukitoimien suuntaaminen alueelle. Koodi liittyy kaavakohteeseen, joka on geometrialtaan alue.', 'ke'),
(203, 'suunnittelutarvealue', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/suunnittelutarvealue', 'Alueen osan käyttötarkoitus','','Suunnittelutarvealue','Område i behov av planering', 'Ilmaisee, että kaavakohde kuvaa aluetta, joilla on odotettavissa suunnittelua edellyttävää yhdyskuntakehitystä tai jolla erityisten ympäristöarvojen tai ympäristöhaittojen takia on tarpeen suunnitella maankäyttöä. Ks. MRL 16 §. Kaavakohteeseen tulee lähtökohtaisesti liittää täsmentävä sanallinen määräys, joka kertoo määräyksen voimassaoloajan. Koodi liittyy kaavakohteeseen, joka on geometrialtaan alue.', 'st'),
(204, 'nimisto', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/nimisto', 'Nimistö','','Nimistö  (OTSIKKO)','Namnbestånd', 'Koodistoa jäsentävä otsikkotason koodi, jota ei käytetä kaavamääräyksissä. Nimistöä koskevat kaavamääräykset tulisi kaavoissa luokitella niiden käyttötarkoitusta kuvaavalla kaavamääräyslaji-koodiarvolla.', ''),
(205, 'kadunTaiTienNimi', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/kadunTaiTienNimi', 'Nimistö','nimisto','Kadun tai tien nimi','Namn på gata eller väg', 'Ilmaisee, että kaavamääräyksellä annetaan kadun tai tien nimi. Koodi liittyy kaavakohteeseen, joka on geometrialtaan alue. Kaavamääräykselle tulee antaa arvo kieliversioituna tekstinä, joka ilmaisee kadun tai tien nimen.', ''),
(206, 'torinTaiKatuaukionNimi', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/torinTaiKatuaukionNimi', 'Nimistö','nimisto','Torin tai katuaukion nimi','Namn på torg eller öppen plats', 'Ilmaisee, että kaavamääräyksellä annetaan torin tai katuaukion nimi. Koodi liittyy kaavakohteeseen, joka on geometrialtaan alue. Kaavamääräykselle tulee antaa arvo kieliversioituna tekstinä, joka ilmaisee torin tai katuaukion nimen.', ''),
(207, 'puistonTaiMuunYleisenAlueenNimi', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/puistonTaiMuunYleisenAlueenNimi', 'Nimistö','nimisto','Puiston tai muun yleisen alueen nimi','Namn på park eller annat allmänt område', 'Ilmaisee, että kaavamääräyksellä annetaan puiston tai muun yleisen alueen nimi. Koodi liittyy kaavakohteeseen, joka on geometrialtaan alue. Kaavamääräykselle tulee antaa arvo kieliversioituna tekstinä, joka ilmaisee puiston tai muun yleisen alueen nimen.', ''),
(208, 'kaupunginTaiKunnanosanNimi', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/kaupunginTaiKunnanosanNimi', 'Nimistö','nimisto','Kaupungin- tai kunnanosan nimi','Namn på stads- eller kommundel', 'Ilmaisee, että kaavamääräyksellä annetaan kaupungin- tai kunnanosan nimi. Koodi liittyy kaavakohteeseen, joka on geometrialtaan alue. Kaavamääräykselle tulee antaa arvo kieliversioituna tekstinä, joka ilmaisee kaupungin- tai kunnanosan nimen.', ''),
(209, 'aluetunnukset', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/aluetunnukset', 'Nimistö','','Aluetunnukset  (OTSIKKO)','Områdeskoder', 'Koodistoa jäsentävä otsikkotason koodi, jota ei käytetä kaavamääräyksissä. Aluetunnuksia koskevat kaavamääräykset tulisi kaavoissa luokitella niiden käyttötarkoitusta kuvaavalla kaavamääräyslaji-koodiarvolla.', ''),
(210, 'korttelinNumero', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/korttelinNumero', 'Nimistö','aluetunnukset','Korttelin numero','Kvartersnummer', 'Ilmaisee, että kaavamääräyksellä annetaan korttelin numero. Koodi liittyy kaavakohteeseen, joka on geometrialtaan alue. Kaavamääräykselle tulee antaa arvo positiivisena kokonaislukuna, joka ilmaisee korttelin numeron.', ''),
(211, 'tontinTaiRakennuspaikanNumero', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/tontinTaiRakennuspaikanNumero', 'Nimistö','aluetunnukset','Tontin tai rakennuspaikan numero','Nummer på tomt/byggnadsplats', 'Ilmaisee, että kaavamääräyksellä annetaan tontin tai rakennuspaikan numero. Koodi liittyy kaavakohteeseen, joka on geometrialtaan alue. Kaavamääräykselle tulee antaa arvo positiivisena kokonaislukuna, joka ilmaisee tontin tai rakennuspaikan numeron.', ''),
(212, 'kaupunginTaiKunnanosanNumero', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/kaupunginTaiKunnanosanNumero', 'Nimistö','aluetunnukset','Kaupungin- tai kunnanosan numero','Stadsdels- eller kommundelsnummer', 'Ilmaisee, että kaavamääräyksellä annetaan kaupungin- tai kunnanosan numero. Koodi liittyy kaavakohteeseen, joka on geometrialtaan alue. Kaavamääräykselle tulee antaa arvo positiivisena kokonaislukuna, joka ilmaisee kaupungin- tai kunnanosan numeron.', ''),
(213, 'rakentamisenMaara', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/rakentamisenMaara', 'Rakentamisen määrä','','Rakentamisen määrä  (OTSIKKO)','Omfattningen av byggandet', 'Koodistoa jäsentävä otsikkotason koodi, jota ei käytetä kaavamääräyksissä. Rakentamisen määrää koskevat kaavamääräykset tulisi kaavoissa luokitella niiden käyttötarkoitusta kuvaavalla kaavamääräyslaji-koodiarvolla.', ''),
(214, 'sallittuKerrosala', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/sallittuKerrosala', 'Rakentamisen määrä','rakentamisenMaara','Sallittu kerrosala','Tillåten våningsyta', 'Ilmaisee, että kaavamääräyksellä osoitetaan sallittu kerrosala. Koodi liittyy kaavakohteeseen, joka on geometrialtaan alue. Kaavamääräykselle tulee antaa arvo positiivisena kokonaislukuna, joka ilmaisee sallitun kerrosalan määrän. Yksikkönä käytetään kerrosneliömetriä (k-m2).', ''),
(215, 'sallittuRakennustilavuus', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/sallittuRakennustilavuus', 'Rakentamisen määrä','rakentamisenMaara','Sallittu rakennustilavuus','Tillåten byggvolym', 'Ilmaisee, että kaavamääräyksellä osoitetaan sallittu rakennustilavuus. Koodi liittyy kaavakohteeseen, joka on geometrialtaan alue. Kaavamääräykselle tulee antaa arvo positiivisena kokonaislukuna, joka ilmaisee sallitun rakennustilavuuden määrän. Yksikkönä käytetään kuutiometriä (m3).', ''),
(216, 'tehokkuusluku', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/tehokkuusluku', 'Rakentamisen määrä','rakentamisenMaara','Tehokkuusluku','Exploateringstal', 'Ilmaisee, että kaavamääräyksellä osoitetaan kaavakohteen alueen sallittu rakennustehokkuus. Koodi liittyy kaavakohteeseen, joka on geometrialtaan alue. Kaavamääräykselle tulee antaa arvo positiivisena desimaalina, joka ilmaisee sallitun rakentamisen määrän. Yksikkönä suhdeluku kerrosala / pinta-ala (k-m2/m2).', ''),
(217, 'rakentamisenSuhdeAlueenPintaAlaan', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/rakentamisenSuhdeAlueenPintaAlaan', 'Rakentamisen määrä','rakentamisenMaara','Rakentamisen suhde alueen pinta-alaan','Byggandets förhållande till områdets yta', 'Ilmaisee, että kaavamääräyksellä osoitetaan kaavakohteen alueella rakentamiseen käytettävän alueen pinta-ala suhteessa koko kaava-alueen pinta-alaan. Koodi liittyy kaavakohteeseen, joka on geometrialtaan alue. Kaavamääräykselle tulee antaa arvo positiivisena kokonaislukuna, joka ilmaisee  sallitun rakentamisen määrän. Yksikkönä prosentti.', ''),
(218, 'valjyysluku', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/valjyysluku', 'Rakentamisen määrä','rakentamisenMaara','Väljyysluku','Rymlighetstal', 'Ilmaisee, että kaavamääräyksellä osoitetaan kaavakohteen alueen tavoiteltavan väljyysluvun. Koodi liittyy kaavakohteeseen, joka on geometrialtaan alue. Kaavamääräykselle tulee antaa arvo positiivisena desimaalilukuna. Yksikkönä suhdeluku, joka ilmaisee rakentamattoman pohjapinta-alan suhteessa alueen pinta-alaan (m2/k-m2).', ''),
(219, 'maanpaallinenKerroslukuLuku', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/maanpaallinenKerroslukuLuku', 'Rakentamisen määrä','rakentamisenMaara','Maanpäällinen kerrosluku (luku)','Våningsantal ovan jord (tal)', 'Ilmaisee, että kaavamääräyksellä osoitetaan rakennuksen sallittu maanpäällinen kerrosluku. Koodi liittyy kaavakohteeseen, joka on geometrialtaan alue. Kaavamääräykselle tulee antaa arvo positiivisena kokonaislukuna, joka ilmaisee korkeimman sallitun maanpäällisen kerrosluvun.', ''),
(220, 'maanpaallinenKerroslukuArvovali', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/maanpaallinenKerroslukuArvovali', 'Rakentamisen määrä','rakentamisenMaara','Maanpäällinen kerrosluku (arvoväli)','Våningsantal ovan jord (värdeintervall)', 'Ilmaisee, että kaavamääräyksellä osoitetaan rakennuksen sallittu maanpäällinen kerrosluku. Koodi liittyy kaavakohteeseen, joka on geometrialtaan alue. Kaavamääräykselle tulee antaa arvo positiivisena kokonaislukuina määriteltävänä arvovälinä, jolla ilmaistaan matalin ja korkein sallittu maanpäällisen kerrosluku.', ''),
(221, 'maanalainenKerroslukuLuku', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/maanalainenKerroslukuLuku', 'Rakentamisen määrä','rakentamisenMaara','Maanalainen kerrosluku (luku)','Våningsantal under jord (tal)', 'Ilmaisee, että kaavamääräyksellä osoitetaan rakennuksen sallittu maanalainen kerrosluku. Koodi liittyy kaavakohteeseen, joka on geometrialtaan alue. Kaavamääräykselle tulee antaa arvo positiivisena kokonaislukuna, joka ilmaisee korkeimman sallitun maanalaisen kerrosluvun.', ''),
(222, 'maanalainenKerroslukuArvovali', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/maanalainenKerroslukuArvovali', 'Rakentamisen määrä','rakentamisenMaara','Maanalainen kerrosluku (arvoväli)','Våningsantal under jord (värdeintervall)', 'Ilmaisee, että kaavamääräyksellä osoitetaan rakennuksen sallittu maanalainen kerrosluku. Koodi liittyy kaavakohteeseen, joka on geometrialtaan alue. Kaavamääräykselle tulee antaa arvo positiivisena kokonaislukuina määriteltävänä arvovälinä, jolla ilmaistaan matalin ja korkein sallittu maanalaisen kerrosluku.', ''),
(223, 'kellarinSallittuOsuusKerrosalasta', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/kellarinSallittuOsuusKerrosalasta', 'Rakentamisen määrä','rakentamisenMaara','Kellarin sallittu osuus kerrosalasta','Källarens tillåtna andel av våningsytan', 'Ilmaisee, että kaavamääräyksellä osoitetaan rakennuksen kellarin sallittu osuus kerrosalasta. Koodi liittyy kaavakohteeseen, joka on geometrialtaan alue. Kaavamääräykselle tulee antaa arvo positiivisena kokonaislukuna. Yksikkönä prosentti.', ''),
(224, 'ullakonSallittuOsuusKerrosalasta', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/ullakonSallittuOsuusKerrosalasta', 'Rakentamisen määrä','rakentamisenMaara','Ullakon sallittu osuus kerrosalasta','Vindens tillåtna andel av våningsytan', 'Ilmaisee, että kaavamääräyksellä osoitetaan rakennuksen ullakon sallittu osuus kerrosalasta. Koodi liittyy kaavakohteeseen, joka on geometrialtaan alue. Kaavamääräykselle tulee antaa arvo positiivisena kokonaislukuna. Yksikkönä prosentti.', ''),
(225, 'asuntojenMaara', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/asuntojenMaara', 'Rakentamisen määrä','rakentamisenMaara','Asuntojen määrä','Antal bostäder', 'Ilmaisee, että kaavamääräyksellä osoitetaan asuntojen lukumäärä. Koodi liittyy kaavakohteeseen, joka on geometrialtaan alue. Kaavamääräykselle tulee antaa arvo positiivisena kokonaislukuna, joka ilmaisee kuinka monta asuntoa alueelle on rakennettava.', ''),
(226, 'rakennuspaikkojenMaara', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/rakennuspaikkojenMaara', 'Rakentamisen määrä','rakentamisenMaara','Rakennuspaikkojen määrä','Antal byggplatser', 'Ilmaisee, että kaavamääräyksellä osoitetaan rakennuspaikkojen lukumäärä. Koodi liittyy kaavakohteeseen, joka on geometrialtaan alue. Kaavamääräykselle tulee antaa arvo positiivisena kokonaislukuna, joka ilmaisee sallittujen rakennuspaikkojen lukumäärän.', ''),
(227, 'tuulivoimaloidenMaara', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/tuulivoimaloidenMaara', 'Rakentamisen määrä','rakentamisenMaara','Tuulivoimaloiden määrä','Antal vindkraftverk', 'Ilmaisee, että kaavamääräyksellä osoitetaan tuulivoimaloiden määrä tuulivoimaloiden alueella. Koodi liittyy kaavakohteeseen, joka on geometrialtaan alue. Kaavamääräykselle tulee antaa arvo positiivisena kokonaislukuna, joka ilmaisee sallittujen tuulivoimaloiden lukumäärän.', ''),
(228, 'korkeusasema', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/korkeusasema', 'Korkeusasema','','Korkeusasema  (OTSIKKO)','Höjd', 'Koodistoa jäsentävä otsikkotason koodi, jota ei käytetä kaavamääräyksissä. Korkeusasemaa koskevat kaavamääräykset tulisi kaavoissa luokitella niiden käyttötarkoitusta kuvaavalla kaavamääräyslaji-koodiarvolla.', ''),
(229, 'maanpinnanKorkeusasema', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/maanpinnanKorkeusasema', 'Korkeusasema','korkeusasema','Maanpinnan korkeusasema','Markhöjd', 'Ilmaisee maanpinnan korkeusaseman merenpinnasta sovitun pystysuuntaisen koordinaatiston arvona kaavakohteen sijainnissa. Koodi liittyy kaavakohteeseen, joka on geometrialtaan alue. Kaavamääräykselle tulee antaa arvo desimaalina. Yksikkönä metri (m).', ''),
(230, 'vesikatonYlimmanKohdanKorkeusasema', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/vesikatonYlimmanKohdanKorkeusasema', 'Korkeusasema','korkeusasema','Vesikaton ylimmän kohdan korkeusasema','Vattentakets högsta höjd', 'Koodin avulla ilmaistaan vesikaton ylimmän kohdan korkeusaseman merenpinnasta sovitun pystysuuntaisen koordinaatiston arvona. Koodi liittyy kaavakohteeseen, joka on geometrialtaan alue. Kaavamääräykselle tulee antaa arvo desimaalina. Yksikkönä metri (m).', ''),
(231, 'julkisivupinnanJaVesikatonLeikkauskohdanKorkeusasema', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/julkisivupinnanJaVesikatonLeikkauskohdanKorkeusasema', 'Korkeusasema','korkeusasema','Julkisivupinnan ja vesikaton leikkauskohdan korkeusasema','Högsta höjd för skärningspunkten mellan fasad och vattentak', 'Koodin avulla ilmaistaan julkisivupinnan ja vesikaton leikkauskohdan korkeusasema merenpinnasta sovitun pystysuuntaisen koordinaatiston arvona. Koodi liittyy kaavakohteeseen, joka on geometrialtaan alue tai viiva. Kaavamääräykselle tulee antaa arvo desimaalilukuna.  Yksikkönä metri (m).', ''),
(232, 'julkisivunEnimmaiskorkeus', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/julkisivunEnimmaiskorkeus', 'Korkeusasema','korkeusasema','Julkisivun enimmäiskorkeus','Fasadens högsta höjd', 'Koodin avulla ilmaistaan rakennuksen julkisivun enimmäiskorkeus. Koodi liittyy kaavakohteeseen, joka on geometrialtaan alue tai viiva. Kaavamääräykselle tulee antaa arvo desimaalilukuna. Yksikkönä metri (m).', ''),
(233, 'rakennustenRakenteidenJaLaitteidenYlinKorkeusasema', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/rakennustenRakenteidenJaLaitteidenYlinKorkeusasema', 'Korkeusasema','korkeusasema','Rakennusten, rakenteiden ja laitteiden ylin korkeusasema','Byggnadernas, konstruktionernas och anläggningarnas högsta höjd', 'Koodin avulla ilmaistaan rakennusten, rakenteiden ja laitteiden ylin korkeusasema merenpinnasta sovitun pystysuuntaisen koordinaatiston arvona. Koodi liittyy kaavakohteeseen, joka on geometrialtaan alue. Kaavamääräykselle tulee antaa arvo desimaalina. Yksikkönä metri (m).', ''),
(234, 'alinPainovoimainenViemarointitaso', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/alinPainovoimainenViemarointitaso', 'Korkeusasema','korkeusasema','Alin painovoimainen viemäröintitaso','Lägsta nivå för gravitationsavlopp', 'Koodin avulla ilmaistaan alin painovoimainen viemäröintitaso. Koodi liittyy kaavakohteeseen, joka on geometrialtaan alue. Kaavamääräykselle tulee antaa arvo desimaalina. Yksikkönä metri (m).', ''),
(235, 'rakennustenRakenteidenJaLaitteidenAlinKorkeusasema', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/rakennustenRakenteidenJaLaitteidenAlinKorkeusasema', 'Korkeusasema','korkeusasema','Rakennusten, rakenteiden ja laitteiden alin korkeusasema','Byggnadernas, konstruktionernas och anläggningarnas lägsta höjd', 'Koodin avulla ilmaistaan rakennusten, rakenteiden ja laitteiden alin korkeusasema merenpinnasta sovitun pystysuuntaisen koordinaatiston arvona. Koodi liittyy kaavakohteeseen, joka on geometrialtaan alue. Kaavamääräykselle tulee antaa arvo desimaalina. Yksikkönä metri (m).', 'o+'),
(236, 'kosteudelleAlttiidenRakenteidenAlinRakentamiskorkeus', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/kosteudelleAlttiidenRakenteidenAlinRakentamiskorkeus', 'Korkeusasema','korkeusasema','Kosteudelle alttiiden rakenteiden alin rakentamiskorkeus','Lägsta bygghöjd för fuktkänsliga konstruktioner', 'Koodin avulla ilmaistaan alin korkeusasema merenpinnasta sovitun pystysuuntaisen koordinaatiston arvona, jolle saa sijoittaa kosteudelle alttiita rakenteita. Koodi liittyy kaavakohteeseen, joka on geometrialtaan alue. Kaavamääräykselle tulee antaa arvo desimaalina. Yksikkönä metri (m).', 'N2000 XX,XX m'),
(237, 'tuulivoimalanEnimmaiskorkeus', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/tuulivoimalanEnimmaiskorkeus', 'Korkeusasema','korkeusasema','Tuulivoimalan enimmäiskorkeus','Vindkraftverkets högsta höjd', 'Koodin avulla kuvataan kaavakohteelle sijoittuvan tuulivoimalan suurin sallittu kokonaiskorkeus. Kaavamääräyksestä tulee käydä ilmi onko suurin sallittu kokonaiskorkeus metriä merenpinnasta vai maanpinnasta. Koodi liittyy kaavakohteeseen, joka on geometrialtaan alue tai piste. Kaavamääräykselle tulee antaa arvo positiivisena kokonaislukuna. Koodiin liitetyn arvon yksikkönä on metri (m).', ''),
(238, 'rakentamisenTapa', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/rakentamisenTapa', 'Yleismääräykset','','Rakentamisen tapa  (OTSIKKO)','Byggsättet', 'Koodistoa jäsentävä otsikkotason koodi, jota ei käytetä kaavamääräyksissä. Rakentamisen tapaa koskevat kaavamääräykset tulisi kaavoissa luokitella niiden käyttötarkoitusta kuvaavalla kaavamääräyslaji-koodiarvolla.', 'tv XXX m'),
(239, 'kattokaltevuus', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/kattokaltevuus', 'Rakentamistapa','rakentamisenTapa','Kattokaltevuus','Taklutning', 'Koodin avulla kuvataan rakennuksen kattokaltevuus. Koodi liittyy kaavakohteeseen, joka on geometrialtaan alue. Kaavamääräykselle tulee antaa arvo desimaalina. Koodiin liitetyn arvon yksikkönä on aste.', ''),
(240, 'aaneneristavyys', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/aaneneristavyys', 'Rakentamistapa','rakentamisenTapa','Ääneneristävyys','Ljudisolering', 'Koodin avulla kuvataan kaavakohteeseen liittyvä ääneneristävyysmääräys. Koodi liittyy kaavakohteeseen, joka on geometrialtaan alue tai viiva. Kaavamääräykselle tulee antaa arvo positiivisena desimaalilukuna. Koodiin liitetyn arvon yksikkönä on desibeli (dB).', ''),
(241, 'liikenteenSuureet', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/liikenteenSuureet', 'Rakentamisen määrä','','Liikenteen suureet  (OTSIKKO)','Trafikens storheter', 'Koodistoa jäsentävä otsikkotason koodi, jota ei käytetä kaavamääräyksissä. Liikenteen suureita koskevat kaavamääräykset tulisi kaavoissa luokitella niiden käyttötarkoitusta kuvaavalla kaavamääräyslaji-koodiarvolla.', ''),
(242, 'pysakoinninMaara', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/pysakoinninMaara', 'Rakentamisen määrä','liikenteenSuureet','Pysäköinnin määrä  (OTSIKKO)','Parkeringens omfattning', 'Koodistoa jäsentävä otsikkotason koodi, jota ei käytetä kaavamääräyksissä. Pysäköinnin määrää koskevat kaavamääräykset tulisi kaavoissa luokitella niiden käyttötarkoitusta kuvaavalla kaavamääräyslaji-koodiarvolla.', ''),
(243, 'autopaikkojenMaara', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/autopaikkojenMaara', 'Rakentamisen määrä','pysakoinninMaara','Autopaikkojen määrä','Antal bilplatser', 'Kuvaa, että koodin avulla on ilmaistu autopaikkojen lukumäärä. Koodi liittyy kaavakohteeseen, joka on geometrialtaan alue. Kaavamääräykselle tulee antaa arvo positiivisena kokonaislukuna.', ''),
(244, 'autopaikkojenMaaraAsuntoaKohden', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/autopaikkojenMaaraAsuntoaKohden', 'Rakentamisen määrä','pysakoinninMaara','Autopaikkojen määrä asuntoa kohden','Antal bilplatser per bostad', 'Kuvaa, että koodin avulla on ilmaistu autopaikkojen lukumäärä asunto kohden. Koodi liittyy kaavakohteeseen, joka on geometrialtaan alue. Kaavamääräykselle tulee antaa arvo positiivisena desimaalina.', ''),
(245, 'kerrosneliomaaraYhtaAutopaikkaaKohden', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/kerrosneliomaaraYhtaAutopaikkaaKohden', 'Rakentamisen määrä','pysakoinninMaara','Kerrosneliömäärä yhtä autopaikkaa kohden','Våningsyta per bilplats', 'Kuvaa, että koodin avulla on ilmaistu kerrosneliömäärä yhtä autopaikkaa kohden. Koodi liittyy kaavakohteeseen, joka on geometrialtaan alue. Kaavamääräykselle tulee antaa arvo positiivisena kokonaislukuna. Yksikkönä käytetään kerrosneliömetriä (k-m2).', ''),
(246, 'pyorapaikkojenMaara', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/pyorapaikkojenMaara', 'Rakentamisen määrä','pysakoinninMaara','Pyöräpaikkojen määrä','Antal cykelplatser', 'Kuvaa, että koodin avulla on ilmaistu polkupyöräpysäköintipaikkojen lukumäärä. Koodi liittyy kaavakohteeseen, joka on geometrialtaan alue. Kaavamääräykselle tulee antaa arvo positiivisena kokonaislukuna.', ''),
(247, 'pyorapaikkojenMaaraAsuntoaKohden', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/pyorapaikkojenMaaraAsuntoaKohden', 'Rakentamisen määrä','pysakoinninMaara','Pyöräpaikkojen määrä asuntoa kohden','Antal cykelplatser per bostad', 'Kuvaa, että koodin avulla on ilmaistu polkupyöräpysäköintipaikkojen lukumäärä asunto kohden. Koodi liittyy kaavakohteeseen, joka on geometrialtaan alue. Kaavamääräykselle tulee antaa arvo positiivisena desimaalina.', ''),
(248, 'kerrosneliomaaraYhtaPyorapaikkaaKohden', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/kerrosneliomaaraYhtaPyorapaikkaaKohden', 'Rakentamisen määrä','pysakoinninMaara','Kerrosneliömäärä yhtä pyöräpaikkaa kohden','Våningsyta per cykelplats', 'Kuvaa, että koodin avulla on ilmaistu kerrosneliömäärä yhtä pyöräpaikkaa kohden. Koodi liittyy kaavakohteeseen, joka on geometrialtaan alue. Kaavamääräykselle tulee antaa arvo positiivisena kokonaislukuna. Yksikkönä käytetään kerrosneliömetriä (k-m2).', ''),
(249, 'sanallinenMaarays', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/sanallinenMaarays', 'Yleismääräykset','','Sanallinen määräys','Verbal bestämmelse', 'Kuvaa, että koodin avulla on ilmaistu sanallinen (tekstimuotoinen) kaavamääräys, jonka sisältö tulee luokitella erillisellä koodistolla. Kaavamääräykselle tulee antaa arvo kieliversioituna tekstinä.', ''),
(250, 'rakentamisrajoitusYleiskaava', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/rakentamisrajoitusYleiskaava', 'Yleismääräykset','sanallinenMaarays','Rakentamisrajoitus (yleiskaava)','Bygginskränkning (generalplan)', 'Ilmaisee, että kohteen alueella on määrätty maankäyttö- ja rakennuslain 43 §:n 2 momentin mukainen rakentamisrajoitus. Kaavakohteeseen tulee lähtökohtaisesti liittää täsmentävä sanallinen määräys, joka kertoo mistä rakentamisrajoituksessa on kyse. Koodi liittyy kaavakohteeseen, joka on geometrialtaan alue.', 'yk-rr'),
(251, 'rakentamisrajoitusMaakuntakaava', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/rakentamisrajoitusMaakuntakaava', 'Yleismääräykset','sanallinenMaarays','Rakentamisrajoitus (maakuntakaava)','Bygginskränkning (landskapsplan)', 'Ilmaisee, että kohteen alueelle on maakuntakaavassa annettu erityinen määräys, jolla supistetaan tai laajennetaan maakuntakaavan rakentamisrajoituksen aluetta. Maankäyttö- ja rakennuslain 33 §:n 1 momentin mukaan maakuntakaavassa virkistys- tai suojelualueeksi osoitetulla alueella, Puolustusvoimien tai Rajavartiolaitoksen tarkoituksiin osoitetulla alueella ja liikenteen tai teknisen huollon verkostoja tai alueita varten osoitetulla alueella on voimassa rakentamista koskeva rajoitus. Koodia ei käytetä näiden alueiden osoittamiseen. Kaavakohteeseen tulee lähtökohtaisesti liittää täsmentävä sanallinen määräys, joka kertoo mistä maakuntakaavassa määrättävässä erityisessä rakentamisrajoitusta koskevassa kaavamääräyksessä on kyse. Koodi liittyy kaavakohteeseen, joka on geometrialtaan alue.', ''),
(252, 'maaraAikainenRakentamisrajoitus', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/maaraAikainenRakentamisrajoitus', 'Yleismääräykset','sanallinenMaarays','Määräaikainen rakentamisrajoitus','Tidsbegränsad bygginskränkning', 'Ilmaisee, että yleiskaavan kaavakohteen alueella on määrätty maankäyttö- ja rakennuslain 43 §:n 3 momentin mukainen määräaikainen rakentamisrajoitus. Kaavakohteeseen tulee lähtökohtaisesti liittää täsmentävä sanallinen määräys, joka kertoo rakentamisrajoituksen perusteen ja voimaoloajan. Koodi liittyy kaavakohteeseen, joka on geometrialtaan alue.', ''),
(253, 'toimenpiderajoitus', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/toimenpiderajoitus', 'Yleismääräykset','sanallinenMaarays','Toimenpiderajoitus','Åtgärdsbegränsning', 'Ilmaisee, että kaavakohteen alueella on määrätty maankäyttö- ja rakennuslain 43 §:n 2 momentin mukainen toimenpiderajoitus. Tällöin toimenpiteen edellytyksenä on, että kunta myöntää alueelle maisematyöluvan (MRL 128 § ja 140 §). Lupaa ei voida myöntää, jos toimenpide vaikeuttaa alueen käyttämistä kaavassa varattuun tarkoitukseen. Koodi liittyy kaavakohteeseen, joka on geometrialtaan alue.', 'tr'),
(254, 'maaraAikainenKieltoRakennuksenRakentamiseksi', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/maaraAikainenKieltoRakennuksenRakentamiseksi', 'Yleismääräykset','sanallinenMaarays','Määräaikainen kielto rakennuksen rakentamiseksi ','Tidsbegränsat förbud mot uppförande av byggnad', 'Ilmaisee, että asemakaavan kaavakohteen alueella on määrätty maankäyttö- ja rakennuslain 58 §:n 5 momentin mukainen kielto uuden rakennuksen rakentamiseksi. Kaavakohteeseen tulee lähtökohtaisesti liittää täsmentävä sanallinen määräys, joka kertoo kiellon perusteen ja voimaoloajan. Koodi liittyy kaavakohteeseen, joka on geometrialtaan alue.', 'mrk'),
(255, 'suunnittelumaarays', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/suunnittelumaarays', 'Yleismääräykset','sanallinenMaarays','Suunnittelumääräys','planeringsbestämmelse', 'alueiden käytön suunnittelua koskeva määräys', ''),
(256, 'rakentamismaarays', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/rakentamismaarays', 'Yleismääräykset','sanallinenMaarays','Rakentamismääräys','byggbestämmelse', 'rakentamista koskeva määräys', ''),
(257, 'suojelumaarays', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavamaarayslaji/code/suojelumaarays', 'Yleismääräykset','sanallinenMaarays','Suojelumääräys','skyddsbestämmelse', 'määräys, jonka tarkoituksena on erityisten ympäristöarvojen turvaaminen', '');

--
-- Data for Name: detail_plan_theme; Type: TABLE DATA; Schema: code_lists; Owner: -
--

INSERT INTO code_lists.detail_plan_theme VALUES (1, '01', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavoitusteema_AK/code/01', 'Rakennusoikeus', 'byggrätt', 'Oikeus rakentaa määritellylle alueelle', NULL);
INSERT INTO code_lists.detail_plan_theme VALUES (2, '02', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavoitusteema_AK/code/02', 'Asuminen', NULL, NULL, NULL);
INSERT INTO code_lists.detail_plan_theme VALUES (3, '03', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavoitusteema_AK/code/03', 'Palvelut', NULL, NULL, NULL);
INSERT INTO code_lists.detail_plan_theme VALUES (4, '04', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavoitusteema_AK/code/04', 'Elinkeinot', NULL, NULL, NULL);
INSERT INTO code_lists.detail_plan_theme VALUES (5, '05', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavoitusteema_AK/code/05', 'Viheralueet ja virkistys', NULL, NULL, NULL);
INSERT INTO code_lists.detail_plan_theme VALUES (6, '06', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavoitusteema_AK/code/06', 'Kadut', NULL, NULL, NULL);
INSERT INTO code_lists.detail_plan_theme VALUES (7, '07', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavoitusteema_AK/code/07', 'Kunnallistekniikka', NULL, NULL, NULL);
INSERT INTO code_lists.detail_plan_theme VALUES (8, '08', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavoitusteema_AK/code/08', 'Liikenneverkko', NULL, NULL, NULL);
INSERT INTO code_lists.detail_plan_theme VALUES (9, '09', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavoitusteema_AK/code/09', 'Kulttuuriympäristöt', NULL, NULL, NULL);
INSERT INTO code_lists.detail_plan_theme VALUES (10, '10', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavoitusteema_AK/code/10', 'Suojelu', NULL, NULL, NULL);
INSERT INTO code_lists.detail_plan_theme VALUES (11, '11', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavoitusteema_AK/code/11', 'Muu kaavoitusteema', NULL, NULL, NULL);


--
-- Data for Name: digital_origin_kind; Type: TABLE DATA; Schema: code_lists; Owner: -
--

INSERT INTO code_lists.digital_origin_kind VALUES (1, '01', 'http://uri.suomi.fi/codelist/rytj/RY_DigitaalinenAlkupera/code/01', 'Tietomallin mukaan laadittu');
INSERT INTO code_lists.digital_origin_kind VALUES (2, '02', 'http://uri.suomi.fi/codelist/rytj/RY_DigitaalinenAlkupera/code/02', 'Kokonaan digitoitu');
INSERT INTO code_lists.digital_origin_kind VALUES (3, '03', 'http://uri.suomi.fi/codelist/rytj/RY_DigitaalinenAlkupera/code/03', 'Osittain digitoitu');
INSERT INTO code_lists.digital_origin_kind VALUES (4, '04', 'http://uri.suomi.fi/codelist/rytj/RY_DigitaalinenAlkupera/code/04', 'Rajaus digitoitu');


--
-- Data for Name: document_kind; Type: TABLE DATA; Schema: code_lists; Owner: -
--

INSERT INTO code_lists.document_kind VALUES (1, '01', 'http://uri.suomi.fi/codelist/rytj/RY_AsiakirjanLaji_YKAK/code/01', 'Hakemus', NULL, NULL, 'Kaava-asiaan liittyvä hakemus, esimerkiksi kaavoitusaloite tai -hakemus.');
INSERT INTO code_lists.document_kind VALUES (2, '02', 'http://uri.suomi.fi/codelist/rytj/RY_AsiakirjanLaji_YKAK/code/02', 'Havainnekuva', NULL, 'Kaavaa havainnollistava visualisointi', NULL);
INSERT INTO code_lists.document_kind VALUES (3, '03', 'http://uri.suomi.fi/codelist/rytj/RY_AsiakirjanLaji_YKAK/code/03', 'Kaavakartta', NULL, NULL, 'Juridisen kaavakartan sähköinen versio. Esimerkiksi vanhan, digitoidun kaavakartan skannattu versio.');
INSERT INTO code_lists.document_kind VALUES (4, '04', 'http://uri.suomi.fi/codelist/rytj/RY_AsiakirjanLaji_YKAK/code/04', 'Kaavamääräykset', NULL, NULL, NULL);
INSERT INTO code_lists.document_kind VALUES (5, '05', 'http://uri.suomi.fi/codelist/rytj/RY_AsiakirjanLaji_YKAK/code/05', 'Kaavaselostus', NULL, NULL, NULL);
INSERT INTO code_lists.document_kind VALUES (6, '06', 'http://uri.suomi.fi/codelist/rytj/RY_AsiakirjanLaji_YKAK/code/06', 'Karttaliite', NULL, NULL, 'Kaavaan liitetty karttaa esittävä dokumentti.');
INSERT INTO code_lists.document_kind VALUES (7, '07', 'http://uri.suomi.fi/codelist/rytj/RY_AsiakirjanLaji_YKAK/code/07', 'Kirje', NULL, NULL, NULL);
INSERT INTO code_lists.document_kind VALUES (8, '08', 'http://uri.suomi.fi/codelist/rytj/RY_AsiakirjanLaji_YKAK/code/08', 'Kuulutus', NULL, NULL, NULL);
INSERT INTO code_lists.document_kind VALUES (9, '09', 'http://uri.suomi.fi/codelist/rytj/RY_AsiakirjanLaji_YKAK/code/09', 'Lausunto', NULL, 'Asiakirja tai asiakirjojen muodostama kokonaisuus, jolla lausuntopyynnön saanut toimija esittää näkemyksensä tarkastelun kohteesta asiankäsittelyn aikana', NULL);
INSERT INTO code_lists.document_kind VALUES (10, '10', 'http://uri.suomi.fi/codelist/rytj/RY_AsiakirjanLaji_YKAK/code/10', 'Mielipide', 'Åsikt', 'Osallisen tai yhteisön jäsenen esittämä kannanotto viranomaisen valmisteluaineistoon', NULL);
INSERT INTO code_lists.document_kind VALUES (11, '11', 'http://uri.suomi.fi/codelist/rytj/RY_AsiakirjanLaji_YKAK/code/11', 'Muistio', NULL, NULL, NULL);
INSERT INTO code_lists.document_kind VALUES (12, '12', 'http://uri.suomi.fi/codelist/rytj/RY_AsiakirjanLaji_YKAK/code/12', 'Muistutus', 'Anmärkning', 'Asianosaisen esittämä kannanotto kaavaehdotukseen', NULL);
INSERT INTO code_lists.document_kind VALUES (13, '13', 'http://uri.suomi.fi/codelist/rytj/RY_AsiakirjanLaji_YKAK/code/13', 'Osallistumis- ja arviointisuunnitelma', NULL, NULL, NULL);
INSERT INTO code_lists.document_kind VALUES (14, '14', 'http://uri.suomi.fi/codelist/rytj/RY_AsiakirjanLaji_YKAK/code/14', 'Päätös', NULL, NULL, NULL);
INSERT INTO code_lists.document_kind VALUES (15, '15', 'http://uri.suomi.fi/codelist/rytj/RY_AsiakirjanLaji_YKAK/code/15', 'Pöytäkirja', NULL, NULL, NULL);
INSERT INTO code_lists.document_kind VALUES (16, '16', 'http://uri.suomi.fi/codelist/rytj/RY_AsiakirjanLaji_YKAK/code/16', 'Raportti', NULL, 'Raportti voi olla esimerkiksi yhteenveto vuorovaikutustapahtumasta tai -tapahtumien kokonaisuudesta.', 'Asiakirja, joka sisältää yhteenvedon kaavan valmisteluun liittyvästä asiasta');
INSERT INTO code_lists.document_kind VALUES (17, '17', 'http://uri.suomi.fi/codelist/rytj/RY_AsiakirjanLaji_YKAK/code/17', 'Selvitys', NULL, 'Kaavan laadinnassa hyödynnetyt selvitykset. Selvityksiä voivat olla esimerkiksi luonto-, maisema-, kulttuuriperintö-, liikenne- tai palveluverkkoselvitykset.', NULL);
INSERT INTO code_lists.document_kind VALUES (18, '18', 'http://uri.suomi.fi/codelist/rytj/RY_AsiakirjanLaji_YKAK/code/18', 'Sopimus', NULL, NULL, NULL);
INSERT INTO code_lists.document_kind VALUES (19, '19', 'http://uri.suomi.fi/codelist/rytj/RY_AsiakirjanLaji_YKAK/code/19', 'Suunnitelma', NULL, 'Kaavatyöhön liittyvä erillinen suunnitelma, esimerkiksi katujen tai yleisten alueiden suunnitelma', NULL);
INSERT INTO code_lists.document_kind VALUES (20, '20', 'http://uri.suomi.fi/codelist/rytj/RY_AsiakirjanLaji_YKAK/code/20', 'Suunnitteluohje', NULL, 'Suunnitteluohje voi olla esimerkiksi rakentamistapaohje tai lähiympäristön suunnitteluohje.', 'Kaavan suunnitteluratkaisuja täydentävä ohjeistus jatkosuunnittelua varten.');
INSERT INTO code_lists.document_kind VALUES (21, '21', 'http://uri.suomi.fi/codelist/rytj/RY_AsiakirjanLaji_YKAK/code/21', 'Valitus', NULL, NULL, NULL);
INSERT INTO code_lists.document_kind VALUES (22, '22', 'http://uri.suomi.fi/codelist/rytj/RY_AsiakirjanLaji_YKAK/code/22', 'Vastine', NULL, NULL, NULL);
INSERT INTO code_lists.document_kind VALUES (23, '99', 'http://uri.suomi.fi/codelist/rytj/RY_AsiakirjanLaji_YKAK/code/99', 'Muu asiakirja', NULL, NULL, NULL);


--
-- Data for Name: finnish_area_type; Type: TABLE DATA; Schema: code_lists; Owner: -
--

INSERT INTO code_lists.finnish_area_type VALUES (1, 1, 'Maankäyttöalue');
INSERT INTO code_lists.finnish_area_type VALUES (2, 2, 'Kaavan osa-alue');
INSERT INTO code_lists.finnish_area_type VALUES (3, 3, 'Kaavan tarkennemerkintä');


--
-- Data for Name: finnish_document_role; Type: TABLE DATA; Schema: code_lists; Owner: -
--

INSERT INTO code_lists.finnish_document_role VALUES (1, 1, 'Liiteaineisto');
INSERT INTO code_lists.finnish_document_role VALUES (2, 2, 'Kaavaselostus');
INSERT INTO code_lists.finnish_document_role VALUES (3, 3, 'Lisätieto');
INSERT INTO code_lists.finnish_document_role VALUES (4, 4, 'Päätös');


--
-- Data for Name: finnish_document_type; Type: TABLE DATA; Schema: code_lists; Owner: -
--

INSERT INTO code_lists.finnish_document_type VALUES (1, 1, 'Kaavaselostus', NULL);
INSERT INTO code_lists.finnish_document_type VALUES (2, 2, 'Lausunto', '07');
INSERT INTO code_lists.finnish_document_type VALUES (3, 3, 'Mielipide', '08');
INSERT INTO code_lists.finnish_document_type VALUES (4, 4, 'Muistutus', '10');
INSERT INTO code_lists.finnish_document_type VALUES (5, 5, 'Vastine', '20');
INSERT INTO code_lists.finnish_document_type VALUES (6, 6, 'Päätös', '12');
INSERT INTO code_lists.finnish_document_type VALUES (7, 7, 'Havainnekuva', '02');
INSERT INTO code_lists.finnish_document_type VALUES (8, 8, 'Vaikutustenarviointi', NULL);
INSERT INTO code_lists.finnish_document_type VALUES (9, 9, 'Kaavakartta', '03');
INSERT INTO code_lists.finnish_document_type VALUES (10, 10, 'Osallistumis- ja arviointisuunnitelma', '11');
INSERT INTO code_lists.finnish_document_type VALUES (11, 11, 'Hakemus', '01');
INSERT INTO code_lists.finnish_document_type VALUES (12, 12, 'Karttaliite', '04');
INSERT INTO code_lists.finnish_document_type VALUES (13, 13, 'Kirje', '05');
INSERT INTO code_lists.finnish_document_type VALUES (14, 14, 'Kuulutus', '06');
INSERT INTO code_lists.finnish_document_type VALUES (15, 15, 'Muistio', '09');
INSERT INTO code_lists.finnish_document_type VALUES (16, 16, 'Pöytäkirja', '13');
INSERT INTO code_lists.finnish_document_type VALUES (17, 17, 'Raportti', '14');
INSERT INTO code_lists.finnish_document_type VALUES (18, 18, 'Selvitys', '15');
INSERT INTO code_lists.finnish_document_type VALUES (19, 19, 'Sopimus', '16');
INSERT INTO code_lists.finnish_document_type VALUES (20, 20, 'Suunnitelma', '17');
INSERT INTO code_lists.finnish_document_type VALUES (21, 21, 'Suunnitteluohje', '18');
INSERT INTO code_lists.finnish_document_type VALUES (22, 22, 'Valitus', '19');
INSERT INTO code_lists.finnish_document_type VALUES (23, 23, 'Muu asiakirja', '21');


--
-- Data for Name: finnish_informative_feature_type; Type: TABLE DATA; Schema: code_lists; Owner: -
--

INSERT INTO code_lists.finnish_informative_feature_type VALUES (1, 1, 'Kiinteistöt');
INSERT INTO code_lists.finnish_informative_feature_type VALUES (2, 2, 'Maaperä');
INSERT INTO code_lists.finnish_informative_feature_type VALUES (3, 3, 'Maasto');
INSERT INTO code_lists.finnish_informative_feature_type VALUES (4, 4, 'Luonto');
INSERT INTO code_lists.finnish_informative_feature_type VALUES (5, 5, 'Kulttuuriympäristö');
INSERT INTO code_lists.finnish_informative_feature_type VALUES (6, 6, 'Ympäristöterveys');
INSERT INTO code_lists.finnish_informative_feature_type VALUES (7, 7, 'Liikenne');
INSERT INTO code_lists.finnish_informative_feature_type VALUES (8, 8, 'Yhdyskuntarakenne');
INSERT INTO code_lists.finnish_informative_feature_type VALUES (9, 9, 'Energiahuolto');
INSERT INTO code_lists.finnish_informative_feature_type VALUES (10, 10, 'Kunnallistekniset verkostot');
INSERT INTO code_lists.finnish_informative_feature_type VALUES (11, 11, 'Rakennukset');
INSERT INTO code_lists.finnish_informative_feature_type VALUES (12, 12, 'Muu');


--
-- Data for Name: finnish_land_use_kind; Type: TABLE DATA; Schema: code_lists; Owner: -
--

INSERT INTO code_lists.finnish_land_use_kind VALUES (12, 'C0', 'Keskustatoiminnot', 'Keskustatoiminnot', 'C', '0102', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/0102');
INSERT INTO code_lists.finnish_land_use_kind VALUES (13, 'C1', 'Keskustatoiminnot', 'Keskustatoimintojen alue', 'C', '010201', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/010201');
INSERT INTO code_lists.finnish_land_use_kind VALUES (14, 'C2', 'Keskustatoiminnot', 'Keskustatoimintojen alakeskus', 'C', '010202', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/010202');
INSERT INTO code_lists.finnish_land_use_kind VALUES (15, 'C3', 'Keskustatoiminnot', 'Muut keskustatoiminnot', 'C', '010203', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/010203');
INSERT INTO code_lists.finnish_land_use_kind VALUES (16, 'K0', 'Liike- ja toimistorakentaminen', 'Liike- ja toimistorakentaminen', 'K', '0103', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/0103');
INSERT INTO code_lists.finnish_land_use_kind VALUES (18, 'K2', 'Liike- ja toimistorakentaminen', 'Liikerakennusten korttelialue, jolle saa sijoittaa vähittäiskaupan suuryksikön', 'KM', '010304', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/010304');
INSERT INTO code_lists.finnish_land_use_kind VALUES (19, 'K5', 'Liike- ja toimistorakentaminen', 'Kaupallisten palveluiden alue', 'KM', '010304', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/010304');
INSERT INTO code_lists.finnish_land_use_kind VALUES (23, 'P0', 'Palvelut', 'Palvelut', 'P', '0104', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/0104');
INSERT INTO code_lists.finnish_land_use_kind VALUES (28, 'Y', 'Julkiset palvelut', 'Julkiset palvelut', 'Y', '0105', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/0105');
INSERT INTO code_lists.finnish_land_use_kind VALUES (29, 'Y1', 'Julkiset palvelut', 'Julkiset palvelut', 'Y', '010501', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/010501');
INSERT INTO code_lists.finnish_land_use_kind VALUES (30, 'P3', 'Julkiset palvelut', 'Yleisten rakennusten alue', 'Y', '010502', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/010502');
INSERT INTO code_lists.finnish_land_use_kind VALUES (31, 'P4', 'Julkiset palvelut', 'Julkisten lähipalveluiden alue', 'YL', '010503', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/010503');
INSERT INTO code_lists.finnish_land_use_kind VALUES (32, 'P5', 'Julkiset palvelut', 'Hallinto- ja virastorakennusten alue', 'YH', '010504', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/010504');
INSERT INTO code_lists.finnish_land_use_kind VALUES (33, 'P6', 'Julkiset palvelut', 'Opetustoimintaa palvelevien rakennusten alue', 'YO', '010505', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/010505');
INSERT INTO code_lists.finnish_land_use_kind VALUES (34, 'P7', 'Julkiset palvelut', 'Sosiaalitointa ja terveydenhuoltoa palvelevien rakennusten alue', 'YS', '010506', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/010506');
INSERT INTO code_lists.finnish_land_use_kind VALUES (35, 'Y10', 'Julkiset palvelut', 'Kulttuuritoimintaa palvelevien rakennusten alue', 'YY', '010507', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/010507');
INSERT INTO code_lists.finnish_land_use_kind VALUES (36, 'Y11', 'Julkiset palvelut', 'Museorakennusten alue', 'YM', '010508', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/010508');
INSERT INTO code_lists.finnish_land_use_kind VALUES (37, 'P8', 'Julkiset palvelut', 'Kirkkojen ja muiden seurakunnallisten rakennusten alue', 'YK', '010509', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/010509');
INSERT INTO code_lists.finnish_land_use_kind VALUES (38, 'P9', 'Julkiset palvelut', 'Urheilutoimintaa palvelevien rakennusten alue', 'YU', '010510', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/010510');
INSERT INTO code_lists.finnish_land_use_kind VALUES (39, 'Y12', 'Julkiset palvelut', 'Julkisten palveluiden ja hallinnon alue', 'Y', '010511', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/010511');
INSERT INTO code_lists.finnish_land_use_kind VALUES (40, 'Y13', 'Julkiset palvelut', 'Muut julkiset palvelut', 'Y', '010512', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/010512');
INSERT INTO code_lists.finnish_land_use_kind VALUES (41, 'T0', 'Työ- ja tuotanto', 'Työ- ja tuotanto', 'T', '0106', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/0106');
INSERT INTO code_lists.finnish_land_use_kind VALUES (42, 'T2', 'Työ- ja tuotanto', 'Työpaikka-alue', 'T', '010601', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/010601');
INSERT INTO code_lists.finnish_land_use_kind VALUES (43, 'T3', 'Työ- ja tuotanto', 'Teollisuusalue', 'TT', '010602', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/010602');
INSERT INTO code_lists.finnish_land_use_kind VALUES (44, 'T4', 'Työ- ja tuotanto', 'Varastorakennusten alue', 'TV', '010603', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/010603');
INSERT INTO code_lists.finnish_land_use_kind VALUES (45, 'T5', 'Työ- ja tuotanto', 'Alue, jolle saa sijoittaa merkittävän, vaarallisia kemikaaleja valmistavan tai varastoivan laitoksen', 'T/kem', '010604', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/010604');
INSERT INTO code_lists.finnish_land_use_kind VALUES (46, 'T6', 'Työ- ja tuotanto', 'Ympäristövaikutuksiltaan merkittävien teollisuustoimintojen alue', 'TT', '010605', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/010605');
INSERT INTO code_lists.finnish_land_use_kind VALUES (47, 'T7', 'Työ- ja tuotanto', 'Kiertotalous', 'T', '010606', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/010606');
INSERT INTO code_lists.finnish_land_use_kind VALUES (48, 'T1', 'Työ- ja tuotanto', 'Teollisuusalue, jolla ympäristö asettaa toiminnan laadulle erityisiä vaatimuksia', 'TY', '010607', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/010607');
INSERT INTO code_lists.finnish_land_use_kind VALUES (49, 'T8', 'Työ- ja tuotanto', 'Muu työpaikka- ja tuotantoalue', 'T', '010608', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/010608');
INSERT INTO code_lists.finnish_land_use_kind VALUES (50, 'V', 'Virkistys', 'Virkistys', 'V', '0107', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/0107');
INSERT INTO code_lists.finnish_land_use_kind VALUES (51, 'V0', 'Virkistys', 'Virkistysalue', 'V', '010701', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/010701');
INSERT INTO code_lists.finnish_land_use_kind VALUES (52, 'V1', 'Virkistys', 'Puisto', 'VP', '010702', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/010702');
INSERT INTO code_lists.finnish_land_use_kind VALUES (53, 'V2', 'Virkistys', 'Lähivirkistysalue', 'VL', '010703', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/010703');
INSERT INTO code_lists.finnish_land_use_kind VALUES (54, 'V3', 'Virkistys', 'Leikkipuisto', 'VK', '010704', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/010704');
INSERT INTO code_lists.finnish_land_use_kind VALUES (55, 'V4', 'Virkistys', 'Urheilu- ja virkistyspalvelujen alue', 'VU', '010705', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/010705');
INSERT INTO code_lists.finnish_land_use_kind VALUES (56, 'V5', 'Virkistys', 'Retkeily- ja ulkoilualue', 'VR', '010706', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/010706');
INSERT INTO code_lists.finnish_land_use_kind VALUES (57, 'V6', 'Virkistys', 'Uimaranta-alue', 'VV', '010707', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/010707');
INSERT INTO code_lists.finnish_land_use_kind VALUES (58, 'V7', 'Virkistys', 'Lähimetsä', 'V', '010708', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/010708');
INSERT INTO code_lists.finnish_land_use_kind VALUES (59, 'V8', 'Virkistys', 'Muu virkistysalue', 'V', '010709', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/010709');
INSERT INTO code_lists.finnish_land_use_kind VALUES (60, 'R0', 'Loma-asuminen ja matkailu', 'Loma-asuminen ja matkailu', 'R', '0108', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/0108');
INSERT INTO code_lists.finnish_land_use_kind VALUES (61, 'R1', 'Loma-asuminen ja matkailu', 'Loma-asuntojen alue', 'RA', '010801', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/010801');
INSERT INTO code_lists.finnish_land_use_kind VALUES (62, 'R2', 'Loma-asuminen ja matkailu', 'Matkailua palvelevien rakennusten alue', 'RM', '010802', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/010802');
INSERT INTO code_lists.finnish_land_use_kind VALUES (63, 'R3', 'Loma-asuminen ja matkailu', 'Leirintäalue', 'RL', '010803', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/010803');
INSERT INTO code_lists.finnish_land_use_kind VALUES (64, 'R5', 'Loma-asuminen ja matkailu', 'Asuntovaunualue', 'RV', '010804', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/010804');
INSERT INTO code_lists.finnish_land_use_kind VALUES (65, 'R4', 'Loma-asuminen ja matkailu', 'Siirtolapuutarha-/palstaviljelyalue', 'RP', '010805', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/010805');
INSERT INTO code_lists.finnish_land_use_kind VALUES (67, 'L', 'Liikenne', 'Liikenne', 'L', '0109', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/0109');
INSERT INTO code_lists.finnish_land_use_kind VALUES (68, 'L0', 'Liikenne', 'Liikennealue', 'L', '010901', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/010901');
INSERT INTO code_lists.finnish_land_use_kind VALUES (69, 'L2', 'Liikenne', 'Yleisen tien alue', 'LT', '010902', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/010902');
INSERT INTO code_lists.finnish_land_use_kind VALUES (70, 'L3', 'Liikenne', 'Rautatieliikenteen alue', 'LR', '010903', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/010903');
INSERT INTO code_lists.finnish_land_use_kind VALUES (71, 'L4', 'Liikenne', 'Lentoliikenteen alue', 'LL', '010904', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/010904');
INSERT INTO code_lists.finnish_land_use_kind VALUES (72, 'L5', 'Liikenne', 'Satama-alue', 'LS', '010905', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/010905');
INSERT INTO code_lists.finnish_land_use_kind VALUES (73, 'L6', 'Liikenne', 'Kanava-alue', 'LK', '010906', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/010906');
INSERT INTO code_lists.finnish_land_use_kind VALUES (74, 'L7', 'Liikenne', 'Venesatama/venevalkama', 'LV', '010907', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/010907');
INSERT INTO code_lists.finnish_land_use_kind VALUES (76, 'L10', 'Liikenne', 'Huoltoasema-alue', 'LH', '010909', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/010909');
INSERT INTO code_lists.finnish_land_use_kind VALUES (78, 'L12', 'Liikenne', 'Tavaraliikenteen terminaalialue', 'LTA', '010911', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/010911');
INSERT INTO code_lists.finnish_land_use_kind VALUES (80, 'L9', 'Liikenne', 'Autopaikkojen alue', 'LPA', '010913', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/010913');
INSERT INTO code_lists.finnish_land_use_kind VALUES (81, 'L1', 'Liikenne', 'Katu', 'KATU', '010914', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/010914');
INSERT INTO code_lists.finnish_land_use_kind VALUES (82, 'L13', 'Liikenne', 'Katuaukio/tori', 'TORI', '010914', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/010914');
INSERT INTO code_lists.finnish_land_use_kind VALUES (83, 'L14', 'Liikenne', 'Jalankululle tai pyöräilylle varattu katu', 'KATU', '010914', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/010914');
INSERT INTO code_lists.finnish_land_use_kind VALUES (84, 'L15', 'Liikenne', 'Muu liikennealue', 'L', '010915', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/010915');
INSERT INTO code_lists.finnish_land_use_kind VALUES (85, 'E', 'Erityisalueet', 'Erityisalueet', 'E', '0110', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/0110');
INSERT INTO code_lists.finnish_land_use_kind VALUES (86, 'E0', 'Erityisalueet', 'Erityisalue', 'E', '011001', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/011001');
INSERT INTO code_lists.finnish_land_use_kind VALUES (87, 'E1', 'Erityisalueet', 'Yhdyskuntateknisen huollon alue', 'ET', '011002', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/011002');
INSERT INTO code_lists.finnish_land_use_kind VALUES (88, 'E2', 'Erityisalueet', 'Energiahuollon alue', 'EN', '011003', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/011003');
INSERT INTO code_lists.finnish_land_use_kind VALUES (89, 'E3', 'Erityisalueet', 'Jätteenkäsittelyalue', 'EJ', '011004', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/011004');
INSERT INTO code_lists.finnish_land_use_kind VALUES (90, 'E4', 'Erityisalueet', 'Maa-ainesten ottoalue', 'EO', '011005', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/011005');
INSERT INTO code_lists.finnish_land_use_kind VALUES (11, 'A10', 'Asuminen', 'Muu asuminen', 'A', '010109', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/010109');
INSERT INTO code_lists.finnish_land_use_kind VALUES (79, 'L16', 'Liikenne', 'Yleisten pysäköintilaitosten alue', 'LPY', '010912', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/010912');
INSERT INTO code_lists.finnish_land_use_kind VALUES (77, 'L11', 'Liikenne', 'Henkilöliikenteen terminaalialue', 'LHA', '010910', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/010910');
INSERT INTO code_lists.finnish_land_use_kind VALUES (66, 'R6', 'Loma-asuminen ja matkailu', 'Muu loma-asumisen tai matkailun laue', 'R', '010806', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/010806');
INSERT INTO code_lists.finnish_land_use_kind VALUES (75, 'L8', 'Liikenne', 'Yleinen pysäköintialue', 'LP', '010908', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/010908');
INSERT INTO code_lists.finnish_land_use_kind VALUES (91, 'E6', 'Erityisalueet', 'Kaivosalue', 'EK', '011006', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/011006');
INSERT INTO code_lists.finnish_land_use_kind VALUES (92, 'E7', 'Erityisalueet', 'Mastoalue', 'EMT', '011007', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/011007');
INSERT INTO code_lists.finnish_land_use_kind VALUES (93, 'E8', 'Erityisalueet', 'Ampumarata-alue', 'EA', '011008', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/011008');
INSERT INTO code_lists.finnish_land_use_kind VALUES (94, 'E9', 'Erityisalueet', 'Puolustusvoimien alue', 'EP', '011009', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/011009');
INSERT INTO code_lists.finnish_land_use_kind VALUES (95, 'E10', 'Erityisalueet', 'Hautausmaa-alue', 'EH', '011010', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/011010');
INSERT INTO code_lists.finnish_land_use_kind VALUES (96, 'E5', 'Erityisalueet', 'Suojaviheralue', 'EV', '011011', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/011011');
INSERT INTO code_lists.finnish_land_use_kind VALUES (97, 'E11', 'Erityisalueet', 'Tuulivoimaloiden alue', 'EN', '011012', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/011012');
INSERT INTO code_lists.finnish_land_use_kind VALUES (98, 'E12', 'Erityisalueet', 'Moottorirata', 'EM', '011013', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/011013');
INSERT INTO code_lists.finnish_land_use_kind VALUES (99, 'E13', 'Erityisalueet', 'Maa-ainesten vastaanotto- ja läjitysalue', 'E', '011014', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/011014');
INSERT INTO code_lists.finnish_land_use_kind VALUES (100, 'E14', 'Erityisalueet', 'Vankila-alue', 'E', '011015', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/011015');
INSERT INTO code_lists.finnish_land_use_kind VALUES (101, 'E15', 'Erityisalueet', 'Muu erityisalue', NULL, '011016', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/011016');
INSERT INTO code_lists.finnish_land_use_kind VALUES (102, 'S', 'Suojelu', 'Suojelu', 'S', '0111', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/0111');
INSERT INTO code_lists.finnish_land_use_kind VALUES (103, 'S0', 'Suojelu', 'Suojelualue', 'S', '011101', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/011101');
INSERT INTO code_lists.finnish_land_use_kind VALUES (104, 'S1', 'Suojelu', 'Luonnonsuojelualue', 'SL', '011102', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/011102');
INSERT INTO code_lists.finnish_land_use_kind VALUES (105, 'S2', 'Suojelu', 'Muinaismuistoalue', 'SM', '011103', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/011103');
INSERT INTO code_lists.finnish_land_use_kind VALUES (107, 'S4', 'Suojelu', 'Rakennussuojelulain nojalla suojeltu alue', 'SR', '011105', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/011105');
INSERT INTO code_lists.finnish_land_use_kind VALUES (108, 'S5', 'Suojelu', 'Muu suojelualue', 'S', '011106', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/011106');
INSERT INTO code_lists.finnish_land_use_kind VALUES (109, 'M', 'Maa- ja metsätalous', 'Maa- ja metsätalous', 'M', '0112', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/0112');
INSERT INTO code_lists.finnish_land_use_kind VALUES (110, 'M0', 'Maa- ja metsätalous', 'Maa- ja metsätalousalue', 'M', '011201', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/011201');
INSERT INTO code_lists.finnish_land_use_kind VALUES (111, 'M1', 'Maa- ja metsätalous', 'Maatalousalue', 'MT', '011202', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/011202');
INSERT INTO code_lists.finnish_land_use_kind VALUES (113, 'M3', 'Maa- ja metsätalous', 'Puutarha- ja kasvihuonealue', 'MP', '011204', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/011204');
INSERT INTO code_lists.finnish_land_use_kind VALUES (114, 'M4', 'Maa- ja metsätalous', 'Maisemallisesti arvokas peltoalue', 'MA', '011205', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/011205');
INSERT INTO code_lists.finnish_land_use_kind VALUES (115, 'M5', 'Maa- ja metsätalous', 'Poronhoitovaltainen maa- ja metsätalousalue', 'M', '011206', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/011206');
INSERT INTO code_lists.finnish_land_use_kind VALUES (116, 'M6', 'Maa- ja metsätalous', 'Muu maa- ja metsätalosualue', 'M', '011207', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/011207');
INSERT INTO code_lists.finnish_land_use_kind VALUES (117, 'W', 'Vesialueet', 'Vesialueet', 'W', '0113', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/0113');
INSERT INTO code_lists.finnish_land_use_kind VALUES (118, 'W0', 'Vesialueet', 'Vesialue', 'W', '011301', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/011301');
INSERT INTO code_lists.finnish_land_use_kind VALUES (119, 'W1', 'Vesialueet', 'Muu vesialue', 'W', '011302', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/011302');
INSERT INTO code_lists.finnish_land_use_kind VALUES (9, 'A8', 'Asuminen', 'Kyläalue', 'AT', '010107', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/010107');
INSERT INTO code_lists.finnish_land_use_kind VALUES (8, 'A5', 'Asuminen', 'Asuin-, liike- ja toimistorakennusten alue', 'AL', '010101', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/010101');
INSERT INTO code_lists.finnish_land_use_kind VALUES (10, 'A9', 'Asuminen', 'Erityisryhmien palveluasuminen', 'A', '010108', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/010108');
INSERT INTO code_lists.finnish_land_use_kind VALUES (1, 'A0', 'Asuminen', 'Asuminen', 'A', '0101', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/0101');
INSERT INTO code_lists.finnish_land_use_kind VALUES (3, 'A2', 'Asuminen', 'Asuinpientaloalue', 'AP', '010102', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/010102');
INSERT INTO code_lists.finnish_land_use_kind VALUES (2, 'A1', 'Asuminen', 'Asuinkerrostaloalue', 'AK', '010101', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/010101');
INSERT INTO code_lists.finnish_land_use_kind VALUES (5, 'A4', 'Asuminen', 'Erillispientaloalue', 'AO', '010104', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/010104');
INSERT INTO code_lists.finnish_land_use_kind VALUES (4, 'A3', 'Asuminen', 'Rivitalojen ja muiden kytkettyjen asuinrakennusten alue', 'AR', '010103', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/010103');
INSERT INTO code_lists.finnish_land_use_kind VALUES (7, 'A6', 'Asuminen', 'Maatilan talouskeskuksen alue', 'AM', '010106', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/010106');
INSERT INTO code_lists.finnish_land_use_kind VALUES (6, 'A7', 'Asuminen', 'Asumista palveleva yhteiskäyttöinen alue', 'A/yk', '010105', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/010105');
INSERT INTO code_lists.finnish_land_use_kind VALUES (106, 'S3', 'Suojelu', 'Rakennuslainsäädännön nojalla suojeltava alue', 'SR', '011104', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/011104');
INSERT INTO code_lists.finnish_land_use_kind VALUES (112, 'M2', 'Maa- ja metsätalous', 'Kotieläintalouden suuryksikön alue', 'ME', '011203', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/011203');
INSERT INTO code_lists.finnish_land_use_kind VALUES (120, 'M7', 'Maa- ja metsätalous', 'Maa- ja metsätalousalue, jolla on erityistä ulkoilun ohjaamistarvetta', 'MU', '011201', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/011201');
INSERT INTO code_lists.finnish_land_use_kind VALUES (121, 'M8', 'Maa- ja metsätalous', 'Maa- ja metsätalousalue, jolla on erityisiä ympäristöarvoja', 'MY', '011201', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/011201');
INSERT INTO code_lists.finnish_land_use_kind VALUES (17, 'K1', 'Liike- ja toimistorakentaminen', 'Liikerakennusten alue', 'KL', '010301', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/010301');
INSERT INTO code_lists.finnish_land_use_kind VALUES (20, 'K3', 'Liike- ja toimistorakentaminen', 'Toimistorakennusten alue', 'KT', '010302', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/010302');
INSERT INTO code_lists.finnish_land_use_kind VALUES (21, 'K4', 'Liike- ja toimistorakentaminen', 'Toimitilarakennusten alue', 'KTY', '010303', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/010303');
INSERT INTO code_lists.finnish_land_use_kind VALUES (22, 'K6', 'Liike- ja toimistorakentaminen', 'Muu liike- ja toimistorakentaminen', 'K', '010305', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/010305');
INSERT INTO code_lists.finnish_land_use_kind VALUES (24, 'P10', 'Palvelut', 'Palvelurakennusten  alue', 'P', '010401', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/010401');
INSERT INTO code_lists.finnish_land_use_kind VALUES (25, 'P1', 'Palvelut', 'Lähipalveluiden alue', 'PL', '010402', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/010402');
INSERT INTO code_lists.finnish_land_use_kind VALUES (26, 'P2', 'Palvelut', 'Huvi- ja viihdepalveluiden alue', 'PV', '010403', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/010403');
INSERT INTO code_lists.finnish_land_use_kind VALUES (27, 'P11', 'Palvelut', 'Muut palvelut', 'P', '010404', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/010404');


--
-- Data for Name: finnish_language; Type: TABLE DATA; Schema: code_lists; Owner: -
--

INSERT INTO code_lists.finnish_language VALUES (1, 1, 'Suomi');
INSERT INTO code_lists.finnish_language VALUES (2, 2, 'Ruotsi');
INSERT INTO code_lists.finnish_language VALUES (3, 3, 'Suomi ja ruotsi');


--
-- Data for Name: finnish_municipalities; Type: TABLE DATA; Schema: code_lists; Owner: -
--

INSERT INTO code_lists.finnish_municipalities VALUES (1, '005', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/005', 'Alajärvi', 'Alajärvi');
INSERT INTO code_lists.finnish_municipalities VALUES (2, '009', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/009', 'Alavieska', 'Alavieska');
INSERT INTO code_lists.finnish_municipalities VALUES (3, '010', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/010', 'Alavus', 'Alavo');
INSERT INTO code_lists.finnish_municipalities VALUES (4, '016', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/016', 'Asikkala', 'Asikkala');
INSERT INTO code_lists.finnish_municipalities VALUES (5, '018', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/018', 'Askola', 'Askola');
INSERT INTO code_lists.finnish_municipalities VALUES (6, '019', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/019', 'Aura', 'Aura');
INSERT INTO code_lists.finnish_municipalities VALUES (7, '020', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/020', 'Akaa', 'Ackas');
INSERT INTO code_lists.finnish_municipalities VALUES (8, '035', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/035', 'Brändö', 'Brändö');
INSERT INTO code_lists.finnish_municipalities VALUES (9, '043', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/043', 'Eckerö', 'Eckerö');
INSERT INTO code_lists.finnish_municipalities VALUES (10, '046', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/046', 'Enonkoski', 'Enonkoski');
INSERT INTO code_lists.finnish_municipalities VALUES (11, '047', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/047', 'Enontekiö', 'Enontekis');
INSERT INTO code_lists.finnish_municipalities VALUES (12, '049', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/049', 'Espoo', 'Esbo');
INSERT INTO code_lists.finnish_municipalities VALUES (13, '050', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/050', 'Eura', 'Eura');
INSERT INTO code_lists.finnish_municipalities VALUES (14, '051', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/051', 'Eurajoki', 'Euraåminne');
INSERT INTO code_lists.finnish_municipalities VALUES (15, '052', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/052', 'Evijärvi', 'Evijärvi');
INSERT INTO code_lists.finnish_municipalities VALUES (16, '060', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/060', 'Finström', 'Finström');
INSERT INTO code_lists.finnish_municipalities VALUES (17, '061', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/061', 'Forssa', 'Forssa');
INSERT INTO code_lists.finnish_municipalities VALUES (18, '062', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/062', 'Föglö', 'Föglö');
INSERT INTO code_lists.finnish_municipalities VALUES (19, '065', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/065', 'Geta', 'Geta');
INSERT INTO code_lists.finnish_municipalities VALUES (20, '069', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/069', 'Haapajärvi', 'Haapajärvi');
INSERT INTO code_lists.finnish_municipalities VALUES (21, '071', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/071', 'Haapavesi', 'Haapavesi');
INSERT INTO code_lists.finnish_municipalities VALUES (22, '072', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/072', 'Hailuoto', 'Karlö');
INSERT INTO code_lists.finnish_municipalities VALUES (23, '074', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/074', 'Halsua', 'Halso');
INSERT INTO code_lists.finnish_municipalities VALUES (24, '075', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/075', 'Hamina', 'Fredrikshamn');
INSERT INTO code_lists.finnish_municipalities VALUES (25, '076', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/076', 'Hammarland', 'Hammarland');
INSERT INTO code_lists.finnish_municipalities VALUES (26, '077', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/077', 'Hankasalmi', 'Hankasalmi');
INSERT INTO code_lists.finnish_municipalities VALUES (27, '078', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/078', 'Hanko', 'Hangö');
INSERT INTO code_lists.finnish_municipalities VALUES (28, '079', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/079', 'Harjavalta', 'Harjavalta');
INSERT INTO code_lists.finnish_municipalities VALUES (29, '081', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/081', 'Hartola', 'Gustav Adolfs');
INSERT INTO code_lists.finnish_municipalities VALUES (30, '082', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/082', 'Hattula', 'Hattula');
INSERT INTO code_lists.finnish_municipalities VALUES (31, '086', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/086', 'Hausjärvi', 'Hausjärvi');
INSERT INTO code_lists.finnish_municipalities VALUES (32, '090', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/090', 'Heinävesi', 'Heinävesi');
INSERT INTO code_lists.finnish_municipalities VALUES (33, '091', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/091', 'Helsinki', 'Helsingfors');
INSERT INTO code_lists.finnish_municipalities VALUES (34, '092', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/092', 'Vantaa', 'Vanda');
INSERT INTO code_lists.finnish_municipalities VALUES (35, '097', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/097', 'Hirvensalmi', 'Hirvensalmi');
INSERT INTO code_lists.finnish_municipalities VALUES (36, '098', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/098', 'Hollola', 'Hollola');
INSERT INTO code_lists.finnish_municipalities VALUES (37, '102', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/102', 'Huittinen', 'Vittis');
INSERT INTO code_lists.finnish_municipalities VALUES (38, '103', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/103', 'Humppila', 'Humppila');
INSERT INTO code_lists.finnish_municipalities VALUES (39, '105', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/105', 'Hyrynsalmi', 'Hyrynsalmi');
INSERT INTO code_lists.finnish_municipalities VALUES (40, '106', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/106', 'Hyvinkää', 'Hyvinge');
INSERT INTO code_lists.finnish_municipalities VALUES (41, '108', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/108', 'Hämeenkyrö', 'Tavastkyro');
INSERT INTO code_lists.finnish_municipalities VALUES (42, '109', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/109', 'Hämeenlinna', 'Tavastehus');
INSERT INTO code_lists.finnish_municipalities VALUES (43, '111', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/111', 'Heinola', 'Heinola');
INSERT INTO code_lists.finnish_municipalities VALUES (44, '139', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/139', 'Ii', 'Ijo');
INSERT INTO code_lists.finnish_municipalities VALUES (45, '140', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/140', 'Iisalmi', 'Idensalmi');
INSERT INTO code_lists.finnish_municipalities VALUES (46, '142', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/142', 'Iitti', 'Itis');
INSERT INTO code_lists.finnish_municipalities VALUES (47, '143', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/143', 'Ikaalinen', 'Ikalis');
INSERT INTO code_lists.finnish_municipalities VALUES (48, '145', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/145', 'Ilmajoki', 'Ilmola');
INSERT INTO code_lists.finnish_municipalities VALUES (49, '146', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/146', 'Ilomantsi', 'Ilomants');
INSERT INTO code_lists.finnish_municipalities VALUES (50, '148', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/148', 'Inari', 'Enare');
INSERT INTO code_lists.finnish_municipalities VALUES (51, '149', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/149', 'Inkoo', 'Ingå');
INSERT INTO code_lists.finnish_municipalities VALUES (52, '151', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/151', 'Isojoki', 'Storå');
INSERT INTO code_lists.finnish_municipalities VALUES (53, '152', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/152', 'Isokyrö', 'Storkyro');
INSERT INTO code_lists.finnish_municipalities VALUES (54, '153', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/153', 'Imatra', 'Imatra');
INSERT INTO code_lists.finnish_municipalities VALUES (55, '165', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/165', 'Janakkala', 'Janakkala');
INSERT INTO code_lists.finnish_municipalities VALUES (56, '167', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/167', 'Joensuu', 'Joensuu');
INSERT INTO code_lists.finnish_municipalities VALUES (57, '169', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/169', 'Jokioinen', 'Jockis');
INSERT INTO code_lists.finnish_municipalities VALUES (58, '170', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/170', 'Jomala', 'Jomala');
INSERT INTO code_lists.finnish_municipalities VALUES (59, '171', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/171', 'Joroinen', 'Jorois');
INSERT INTO code_lists.finnish_municipalities VALUES (60, '172', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/172', 'Joutsa', 'Joutsa');
INSERT INTO code_lists.finnish_municipalities VALUES (61, '176', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/176', 'Juuka', 'Juga');
INSERT INTO code_lists.finnish_municipalities VALUES (62, '177', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/177', 'Juupajoki', 'Juupajoki');
INSERT INTO code_lists.finnish_municipalities VALUES (63, '178', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/178', 'Juva', 'Juva');
INSERT INTO code_lists.finnish_municipalities VALUES (64, '179', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/179', 'Jyväskylä', 'Jyväskylä');
INSERT INTO code_lists.finnish_municipalities VALUES (65, '181', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/181', 'Jämijärvi', 'Jämijärvi');
INSERT INTO code_lists.finnish_municipalities VALUES (66, '182', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/182', 'Jämsä', 'Jämsä');
INSERT INTO code_lists.finnish_municipalities VALUES (67, '186', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/186', 'Järvenpää', 'Träskända');
INSERT INTO code_lists.finnish_municipalities VALUES (68, '202', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/202', 'Kaarina', 'S:t Karins');
INSERT INTO code_lists.finnish_municipalities VALUES (69, '204', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/204', 'Kaavi', 'Kaavi');
INSERT INTO code_lists.finnish_municipalities VALUES (70, '205', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/205', 'Kajaani', 'Kajana');
INSERT INTO code_lists.finnish_municipalities VALUES (71, '208', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/208', 'Kalajoki', 'Kalajoki');
INSERT INTO code_lists.finnish_municipalities VALUES (72, '211', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/211', 'Kangasala', 'Kangasala');
INSERT INTO code_lists.finnish_municipalities VALUES (73, '213', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/213', 'Kangasniemi', 'Kangasniemi');
INSERT INTO code_lists.finnish_municipalities VALUES (74, '214', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/214', 'Kankaanpää', 'Kankaanpää');
INSERT INTO code_lists.finnish_municipalities VALUES (75, '216', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/216', 'Kannonkoski', 'Kannonkoski');
INSERT INTO code_lists.finnish_municipalities VALUES (76, '217', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/217', 'Kannus', 'Kannus');
INSERT INTO code_lists.finnish_municipalities VALUES (77, '218', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/218', 'Karijoki', 'Bötom');
INSERT INTO code_lists.finnish_municipalities VALUES (78, '224', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/224', 'Karkkila', 'Högfors');
INSERT INTO code_lists.finnish_municipalities VALUES (79, '226', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/226', 'Karstula', 'Karstula');
INSERT INTO code_lists.finnish_municipalities VALUES (80, '230', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/230', 'Karvia', 'Karvia');
INSERT INTO code_lists.finnish_municipalities VALUES (81, '231', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/231', 'Kaskinen', 'Kaskö');
INSERT INTO code_lists.finnish_municipalities VALUES (82, '232', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/232', 'Kauhajoki', 'Kauhajoki');
INSERT INTO code_lists.finnish_municipalities VALUES (83, '233', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/233', 'Kauhava', 'Kauhava');
INSERT INTO code_lists.finnish_municipalities VALUES (84, '235', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/235', 'Kauniainen', 'Grankulla');
INSERT INTO code_lists.finnish_municipalities VALUES (85, '236', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/236', 'Kaustinen', 'Kaustby');
INSERT INTO code_lists.finnish_municipalities VALUES (86, '239', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/239', 'Keitele', 'Keitele');
INSERT INTO code_lists.finnish_municipalities VALUES (87, '240', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/240', 'Kemi', 'Kemi');
INSERT INTO code_lists.finnish_municipalities VALUES (88, '241', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/241', 'Keminmaa', 'Keminmaa');
INSERT INTO code_lists.finnish_municipalities VALUES (89, '244', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/244', 'Kempele', 'Kempele');
INSERT INTO code_lists.finnish_municipalities VALUES (90, '245', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/245', 'Kerava', 'Kervo');
INSERT INTO code_lists.finnish_municipalities VALUES (91, '249', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/249', 'Keuruu', 'Keuru');
INSERT INTO code_lists.finnish_municipalities VALUES (92, '250', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/250', 'Kihniö', 'Kihniö');
INSERT INTO code_lists.finnish_municipalities VALUES (93, '256', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/256', 'Kinnula', 'Kinnula');
INSERT INTO code_lists.finnish_municipalities VALUES (94, '257', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/257', 'Kirkkonummi', 'Kyrkslätt');
INSERT INTO code_lists.finnish_municipalities VALUES (95, '260', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/260', 'Kitee', 'Kides');
INSERT INTO code_lists.finnish_municipalities VALUES (96, '261', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/261', 'Kittilä', 'Kittilä');
INSERT INTO code_lists.finnish_municipalities VALUES (97, '263', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/263', 'Kiuruvesi', 'Kiuruvesi');
INSERT INTO code_lists.finnish_municipalities VALUES (98, '265', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/265', 'Kivijärvi', 'Kivijärvi');
INSERT INTO code_lists.finnish_municipalities VALUES (99, '271', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/271', 'Kokemäki', 'Kumo');
INSERT INTO code_lists.finnish_municipalities VALUES (100, '272', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/272', 'Kokkola', 'Karleby');
INSERT INTO code_lists.finnish_municipalities VALUES (101, '273', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/273', 'Kolari', 'Kolari');
INSERT INTO code_lists.finnish_municipalities VALUES (102, '275', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/275', 'Konnevesi', 'Konnevesi');
INSERT INTO code_lists.finnish_municipalities VALUES (103, '276', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/276', 'Kontiolahti', 'Kontiolax');
INSERT INTO code_lists.finnish_municipalities VALUES (104, '280', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/280', 'Korsnäs', 'Korsnäs');
INSERT INTO code_lists.finnish_municipalities VALUES (105, '284', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/284', 'Koski Tl', 'Koskis');
INSERT INTO code_lists.finnish_municipalities VALUES (106, '285', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/285', 'Kotka', 'Kotka');
INSERT INTO code_lists.finnish_municipalities VALUES (107, '286', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/286', 'Kouvola', 'Kouvola');
INSERT INTO code_lists.finnish_municipalities VALUES (108, '287', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/287', 'Kristiinankaupunki', 'Kristinestad');
INSERT INTO code_lists.finnish_municipalities VALUES (109, '288', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/288', 'Kruunupyy', 'Kronoby');
INSERT INTO code_lists.finnish_municipalities VALUES (110, '290', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/290', 'Kuhmo', 'Kuhmo');
INSERT INTO code_lists.finnish_municipalities VALUES (111, '291', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/291', 'Kuhmoinen', 'Kuhmois');
INSERT INTO code_lists.finnish_municipalities VALUES (112, '295', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/295', 'Kumlinge', 'Kumlinge');
INSERT INTO code_lists.finnish_municipalities VALUES (113, '297', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/297', 'Kuopio', 'Kuopio');
INSERT INTO code_lists.finnish_municipalities VALUES (114, '300', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/300', 'Kuortane', 'Kuortane');
INSERT INTO code_lists.finnish_municipalities VALUES (115, '301', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/301', 'Kurikka', 'Kurikka');
INSERT INTO code_lists.finnish_municipalities VALUES (116, '304', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/304', 'Kustavi', 'Gustavs');
INSERT INTO code_lists.finnish_municipalities VALUES (117, '305', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/305', 'Kuusamo', 'Kuusamo');
INSERT INTO code_lists.finnish_municipalities VALUES (118, '309', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/309', 'Outokumpu', 'Outokumpu');
INSERT INTO code_lists.finnish_municipalities VALUES (119, '312', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/312', 'Kyyjärvi', 'Kyyjärvi');
INSERT INTO code_lists.finnish_municipalities VALUES (120, '316', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/316', 'Kärkölä', 'Kärkölä');
INSERT INTO code_lists.finnish_municipalities VALUES (121, '317', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/317', 'Kärsämäki', 'Kärsämäki');
INSERT INTO code_lists.finnish_municipalities VALUES (122, '318', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/318', 'Kökar', 'Kökar');
INSERT INTO code_lists.finnish_municipalities VALUES (123, '320', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/320', 'Kemijärvi', 'Kemijärvi');
INSERT INTO code_lists.finnish_municipalities VALUES (124, '322', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/322', 'Kemiönsaari', 'Kimitoön');
INSERT INTO code_lists.finnish_municipalities VALUES (125, '398', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/398', 'Lahti', 'Lahtis');
INSERT INTO code_lists.finnish_municipalities VALUES (126, '399', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/399', 'Laihia', 'Laihela');
INSERT INTO code_lists.finnish_municipalities VALUES (127, '400', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/400', 'Laitila', 'Letala');
INSERT INTO code_lists.finnish_municipalities VALUES (128, '402', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/402', 'Lapinlahti', 'Lapinlahti');
INSERT INTO code_lists.finnish_municipalities VALUES (129, '403', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/403', 'Lappajärvi', 'Lappajärvi');
INSERT INTO code_lists.finnish_municipalities VALUES (130, '405', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/405', 'Lappeenranta', 'Villmanstrand');
INSERT INTO code_lists.finnish_municipalities VALUES (131, '407', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/407', 'Lapinjärvi', 'Lappträsk');
INSERT INTO code_lists.finnish_municipalities VALUES (132, '408', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/408', 'Lapua', 'Lappo');
INSERT INTO code_lists.finnish_municipalities VALUES (133, '410', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/410', 'Laukaa', 'Laukas');
INSERT INTO code_lists.finnish_municipalities VALUES (134, '416', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/416', 'Lemi', 'Lemi');
INSERT INTO code_lists.finnish_municipalities VALUES (135, '417', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/417', 'Lemland', 'Lemland');
INSERT INTO code_lists.finnish_municipalities VALUES (136, '418', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/418', 'Lempäälä', 'Lempäälä');
INSERT INTO code_lists.finnish_municipalities VALUES (137, '420', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/420', 'Leppävirta', 'Leppävirta');
INSERT INTO code_lists.finnish_municipalities VALUES (138, '421', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/421', 'Lestijärvi', 'Lestijärvi');
INSERT INTO code_lists.finnish_municipalities VALUES (139, '422', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/422', 'Lieksa', 'Lieksa');
INSERT INTO code_lists.finnish_municipalities VALUES (140, '423', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/423', 'Lieto', 'Lundo');
INSERT INTO code_lists.finnish_municipalities VALUES (141, '425', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/425', 'Liminka', 'Limingo');
INSERT INTO code_lists.finnish_municipalities VALUES (142, '426', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/426', 'Liperi', 'Libelits');
INSERT INTO code_lists.finnish_municipalities VALUES (143, '430', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/430', 'Loimaa', 'Loimaa');
INSERT INTO code_lists.finnish_municipalities VALUES (144, '433', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/433', 'Loppi', 'Loppi');
INSERT INTO code_lists.finnish_municipalities VALUES (145, '434', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/434', 'Loviisa', 'Lovisa');
INSERT INTO code_lists.finnish_municipalities VALUES (146, '435', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/435', 'Luhanka', 'Luhanka');
INSERT INTO code_lists.finnish_municipalities VALUES (147, '436', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/436', 'Lumijoki', 'Lumijoki');
INSERT INTO code_lists.finnish_municipalities VALUES (148, '438', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/438', 'Lumparland', 'Lumparland');
INSERT INTO code_lists.finnish_municipalities VALUES (149, '440', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/440', 'Luoto', 'Larsmo');
INSERT INTO code_lists.finnish_municipalities VALUES (150, '441', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/441', 'Luumäki', 'Luumäki');
INSERT INTO code_lists.finnish_municipalities VALUES (151, '444', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/444', 'Lohja', 'Lojo');
INSERT INTO code_lists.finnish_municipalities VALUES (152, '445', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/445', 'Parainen', 'Pargas');
INSERT INTO code_lists.finnish_municipalities VALUES (153, '475', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/475', 'Maalahti', 'Malax');
INSERT INTO code_lists.finnish_municipalities VALUES (154, '478', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/478', 'Maarianhamina - Mariehamn', 'Mariehamn');
INSERT INTO code_lists.finnish_municipalities VALUES (155, '480', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/480', 'Marttila', 'S:t Mårtens');
INSERT INTO code_lists.finnish_municipalities VALUES (156, '481', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/481', 'Masku', 'Masku');
INSERT INTO code_lists.finnish_municipalities VALUES (157, '483', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/483', 'Merijärvi', 'Merijärvi');
INSERT INTO code_lists.finnish_municipalities VALUES (158, '484', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/484', 'Merikarvia', 'Sastmola');
INSERT INTO code_lists.finnish_municipalities VALUES (159, '489', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/489', 'Miehikkälä', 'Miehikkälä');
INSERT INTO code_lists.finnish_municipalities VALUES (160, '491', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/491', 'Mikkeli', 'S:t Michel');
INSERT INTO code_lists.finnish_municipalities VALUES (161, '494', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/494', 'Muhos', 'Muhos');
INSERT INTO code_lists.finnish_municipalities VALUES (162, '495', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/495', 'Multia', 'Multia');
INSERT INTO code_lists.finnish_municipalities VALUES (163, '498', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/498', 'Muonio', 'Muonio');
INSERT INTO code_lists.finnish_municipalities VALUES (164, '499', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/499', 'Mustasaari', 'Korsholm');
INSERT INTO code_lists.finnish_municipalities VALUES (165, '500', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/500', 'Muurame', 'Muurame');
INSERT INTO code_lists.finnish_municipalities VALUES (166, '503', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/503', 'Mynämäki', 'Virmo');
INSERT INTO code_lists.finnish_municipalities VALUES (167, '504', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/504', 'Myrskylä', 'Mörskom');
INSERT INTO code_lists.finnish_municipalities VALUES (168, '505', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/505', 'Mäntsälä', 'Mäntsälä');
INSERT INTO code_lists.finnish_municipalities VALUES (169, '507', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/507', 'Mäntyharju', 'Mäntyharju');
INSERT INTO code_lists.finnish_municipalities VALUES (170, '508', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/508', 'Mänttä-Vilppula', 'Mänttä-Vilppula');
INSERT INTO code_lists.finnish_municipalities VALUES (171, '529', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/529', 'Naantali', 'Nådendal');
INSERT INTO code_lists.finnish_municipalities VALUES (172, '531', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/531', 'Nakkila', 'Nakkila');
INSERT INTO code_lists.finnish_municipalities VALUES (173, '535', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/535', 'Nivala', 'Nivala');
INSERT INTO code_lists.finnish_municipalities VALUES (174, '536', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/536', 'Nokia', 'Nokia');
INSERT INTO code_lists.finnish_municipalities VALUES (175, '538', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/538', 'Nousiainen', 'Nousis');
INSERT INTO code_lists.finnish_municipalities VALUES (176, '541', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/541', 'Nurmes', 'Nurmes');
INSERT INTO code_lists.finnish_municipalities VALUES (177, '543', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/543', 'Nurmijärvi', 'Nurmijärvi');
INSERT INTO code_lists.finnish_municipalities VALUES (178, '545', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/545', 'Närpiö', 'Närpes');
INSERT INTO code_lists.finnish_municipalities VALUES (179, '560', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/560', 'Orimattila', 'Orimattila');
INSERT INTO code_lists.finnish_municipalities VALUES (180, '561', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/561', 'Oripää', 'Oripää');
INSERT INTO code_lists.finnish_municipalities VALUES (181, '562', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/562', 'Orivesi', 'Orivesi');
INSERT INTO code_lists.finnish_municipalities VALUES (182, '563', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/563', 'Oulainen', 'Oulainen');
INSERT INTO code_lists.finnish_municipalities VALUES (183, '564', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/564', 'Oulu', 'Uleåborg');
INSERT INTO code_lists.finnish_municipalities VALUES (184, '576', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/576', 'Padasjoki', 'Padasjoki');
INSERT INTO code_lists.finnish_municipalities VALUES (185, '577', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/577', 'Paimio', 'Pemar');
INSERT INTO code_lists.finnish_municipalities VALUES (186, '578', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/578', 'Paltamo', 'Paltamo');
INSERT INTO code_lists.finnish_municipalities VALUES (187, '580', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/580', 'Parikkala', 'Parikkala');
INSERT INTO code_lists.finnish_municipalities VALUES (188, '581', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/581', 'Parkano', 'Parkano');
INSERT INTO code_lists.finnish_municipalities VALUES (189, '583', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/583', 'Pelkosenniemi', 'Pelkosenniemi');
INSERT INTO code_lists.finnish_municipalities VALUES (190, '584', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/584', 'Perho', 'Perho');
INSERT INTO code_lists.finnish_municipalities VALUES (191, '588', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/588', 'Pertunmaa', 'Pertunmaa');
INSERT INTO code_lists.finnish_municipalities VALUES (192, '592', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/592', 'Petäjävesi', 'Petäjävesi');
INSERT INTO code_lists.finnish_municipalities VALUES (193, '593', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/593', 'Pieksämäki', 'Pieksämäki');
INSERT INTO code_lists.finnish_municipalities VALUES (194, '595', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/595', 'Pielavesi', 'Pielavesi');
INSERT INTO code_lists.finnish_municipalities VALUES (195, '598', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/598', 'Pietarsaari', 'Jakobstad');
INSERT INTO code_lists.finnish_municipalities VALUES (196, '599', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/599', 'Pedersören kunta', 'Pedersöre');
INSERT INTO code_lists.finnish_municipalities VALUES (197, '601', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/601', 'Pihtipudas', 'Pihtipudas');
INSERT INTO code_lists.finnish_municipalities VALUES (198, '604', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/604', 'Pirkkala', 'Birkala');
INSERT INTO code_lists.finnish_municipalities VALUES (199, '607', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/607', 'Polvijärvi', 'Polvijärvi');
INSERT INTO code_lists.finnish_municipalities VALUES (200, '608', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/608', 'Pomarkku', 'Påmark');
INSERT INTO code_lists.finnish_municipalities VALUES (201, '609', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/609', 'Pori', 'Björneborg');
INSERT INTO code_lists.finnish_municipalities VALUES (202, '611', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/611', 'Pornainen', 'Borgnäs');
INSERT INTO code_lists.finnish_municipalities VALUES (203, '614', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/614', 'Posio', 'Posio');
INSERT INTO code_lists.finnish_municipalities VALUES (204, '615', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/615', 'Pudasjärvi', 'Pudasjärvi');
INSERT INTO code_lists.finnish_municipalities VALUES (205, '616', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/616', 'Pukkila', 'Pukkila');
INSERT INTO code_lists.finnish_municipalities VALUES (206, '619', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/619', 'Punkalaidun', 'Punkalaidun');
INSERT INTO code_lists.finnish_municipalities VALUES (207, '620', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/620', 'Puolanka', 'Puolanka');
INSERT INTO code_lists.finnish_municipalities VALUES (208, '623', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/623', 'Puumala', 'Puumala');
INSERT INTO code_lists.finnish_municipalities VALUES (209, '624', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/624', 'Pyhtää', 'Pyttis');
INSERT INTO code_lists.finnish_municipalities VALUES (210, '625', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/625', 'Pyhäjoki', 'Pyhäjoki');
INSERT INTO code_lists.finnish_municipalities VALUES (211, '626', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/626', 'Pyhäjärvi', 'Pyhäjärvi');
INSERT INTO code_lists.finnish_municipalities VALUES (212, '630', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/630', 'Pyhäntä', 'Pyhäntä');
INSERT INTO code_lists.finnish_municipalities VALUES (213, '631', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/631', 'Pyhäranta', 'Pyhäranta');
INSERT INTO code_lists.finnish_municipalities VALUES (214, '635', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/635', 'Pälkäne', 'Pälkäne');
INSERT INTO code_lists.finnish_municipalities VALUES (215, '636', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/636', 'Pöytyä', 'Pöytyä');
INSERT INTO code_lists.finnish_municipalities VALUES (216, '638', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/638', 'Porvoo', 'Borgå');
INSERT INTO code_lists.finnish_municipalities VALUES (217, '678', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/678', 'Raahe', 'Brahestad');
INSERT INTO code_lists.finnish_municipalities VALUES (218, '680', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/680', 'Raisio', 'Reso');
INSERT INTO code_lists.finnish_municipalities VALUES (219, '681', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/681', 'Rantasalmi', 'Rantasalmi');
INSERT INTO code_lists.finnish_municipalities VALUES (220, '683', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/683', 'Ranua', 'Ranua');
INSERT INTO code_lists.finnish_municipalities VALUES (221, '684', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/684', 'Rauma', 'Raumo');
INSERT INTO code_lists.finnish_municipalities VALUES (222, '686', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/686', 'Rautalampi', 'Rautalampi');
INSERT INTO code_lists.finnish_municipalities VALUES (223, '687', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/687', 'Rautavaara', 'Rautavaara');
INSERT INTO code_lists.finnish_municipalities VALUES (224, '689', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/689', 'Rautjärvi', 'Rautjärvi');
INSERT INTO code_lists.finnish_municipalities VALUES (225, '691', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/691', 'Reisjärvi', 'Reisjärvi');
INSERT INTO code_lists.finnish_municipalities VALUES (226, '694', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/694', 'Riihimäki', 'Riihimäki');
INSERT INTO code_lists.finnish_municipalities VALUES (227, '697', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/697', 'Ristijärvi', 'Ristijärvi');
INSERT INTO code_lists.finnish_municipalities VALUES (228, '698', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/698', 'Rovaniemi', 'Rovaniemi');
INSERT INTO code_lists.finnish_municipalities VALUES (229, '700', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/700', 'Ruokolahti', 'Ruokolax');
INSERT INTO code_lists.finnish_municipalities VALUES (230, '702', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/702', 'Ruovesi', 'Ruovesi');
INSERT INTO code_lists.finnish_municipalities VALUES (231, '704', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/704', 'Rusko', 'Rusko');
INSERT INTO code_lists.finnish_municipalities VALUES (232, '707', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/707', 'Rääkkylä', 'Rääkkylä');
INSERT INTO code_lists.finnish_municipalities VALUES (233, '710', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/710', 'Raasepori', 'Raseborg');
INSERT INTO code_lists.finnish_municipalities VALUES (234, '729', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/729', 'Saarijärvi', 'Saarijärvi');
INSERT INTO code_lists.finnish_municipalities VALUES (235, '732', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/732', 'Salla', 'Salla');
INSERT INTO code_lists.finnish_municipalities VALUES (236, '734', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/734', 'Salo', 'Salo');
INSERT INTO code_lists.finnish_municipalities VALUES (237, '736', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/736', 'Saltvik', 'Saltvik');
INSERT INTO code_lists.finnish_municipalities VALUES (238, '738', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/738', 'Sauvo', 'Sagu');
INSERT INTO code_lists.finnish_municipalities VALUES (239, '739', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/739', 'Savitaipale', 'Savitaipale');
INSERT INTO code_lists.finnish_municipalities VALUES (240, '740', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/740', 'Savonlinna', 'Nyslott');
INSERT INTO code_lists.finnish_municipalities VALUES (241, '742', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/742', 'Savukoski', 'Savukoski');
INSERT INTO code_lists.finnish_municipalities VALUES (242, '743', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/743', 'Seinäjoki', 'Seinäjoki');
INSERT INTO code_lists.finnish_municipalities VALUES (243, '746', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/746', 'Sievi', 'Sievi');
INSERT INTO code_lists.finnish_municipalities VALUES (244, '747', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/747', 'Siikainen', 'Siikais');
INSERT INTO code_lists.finnish_municipalities VALUES (245, '748', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/748', 'Siikajoki', 'Siikajoki');
INSERT INTO code_lists.finnish_municipalities VALUES (246, '749', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/749', 'Siilinjärvi', 'Siilinjärvi');
INSERT INTO code_lists.finnish_municipalities VALUES (247, '751', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/751', 'Simo', 'Simo');
INSERT INTO code_lists.finnish_municipalities VALUES (248, '753', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/753', 'Sipoo', 'Sibbo');
INSERT INTO code_lists.finnish_municipalities VALUES (249, '755', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/755', 'Siuntio', 'Sjundeå');
INSERT INTO code_lists.finnish_municipalities VALUES (250, '758', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/758', 'Sodankylä', 'Sodankylä');
INSERT INTO code_lists.finnish_municipalities VALUES (251, '759', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/759', 'Soini', 'Soini');
INSERT INTO code_lists.finnish_municipalities VALUES (252, '761', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/761', 'Somero', 'Somero');
INSERT INTO code_lists.finnish_municipalities VALUES (253, '762', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/762', 'Sonkajärvi', 'Sonkajärvi');
INSERT INTO code_lists.finnish_municipalities VALUES (254, '765', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/765', 'Sotkamo', 'Sotkamo');
INSERT INTO code_lists.finnish_municipalities VALUES (255, '766', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/766', 'Sottunga', 'Sottunga');
INSERT INTO code_lists.finnish_municipalities VALUES (256, '768', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/768', 'Sulkava', 'Sulkava');
INSERT INTO code_lists.finnish_municipalities VALUES (257, '771', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/771', 'Sund', 'Sund');
INSERT INTO code_lists.finnish_municipalities VALUES (258, '777', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/777', 'Suomussalmi', 'Suomussalmi');
INSERT INTO code_lists.finnish_municipalities VALUES (259, '778', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/778', 'Suonenjoki', 'Suonenjoki');
INSERT INTO code_lists.finnish_municipalities VALUES (260, '781', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/781', 'Sysmä', 'Sysmä');
INSERT INTO code_lists.finnish_municipalities VALUES (261, '783', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/783', 'Säkylä', 'Säkylä');
INSERT INTO code_lists.finnish_municipalities VALUES (262, '785', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/785', 'Vaala', 'Vaala');
INSERT INTO code_lists.finnish_municipalities VALUES (263, '790', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/790', 'Sastamala', 'Sastamala');
INSERT INTO code_lists.finnish_municipalities VALUES (264, '791', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/791', 'Siikalatva', 'Siikalatva');
INSERT INTO code_lists.finnish_municipalities VALUES (265, '831', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/831', 'Taipalsaari', 'Taipalsaari');
INSERT INTO code_lists.finnish_municipalities VALUES (266, '832', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/832', 'Taivalkoski', 'Taivalkoski');
INSERT INTO code_lists.finnish_municipalities VALUES (267, '833', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/833', 'Taivassalo', 'Tövsala');
INSERT INTO code_lists.finnish_municipalities VALUES (268, '834', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/834', 'Tammela', 'Tammela');
INSERT INTO code_lists.finnish_municipalities VALUES (269, '837', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/837', 'Tampere', 'Tammerfors');
INSERT INTO code_lists.finnish_municipalities VALUES (270, '844', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/844', 'Tervo', 'Tervo');
INSERT INTO code_lists.finnish_municipalities VALUES (271, '845', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/845', 'Tervola', 'Tervola');
INSERT INTO code_lists.finnish_municipalities VALUES (272, '846', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/846', 'Teuva', 'Östermark');
INSERT INTO code_lists.finnish_municipalities VALUES (273, '848', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/848', 'Tohmajärvi', 'Tohmajärvi');
INSERT INTO code_lists.finnish_municipalities VALUES (274, '849', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/849', 'Toholampi', 'Toholampi');
INSERT INTO code_lists.finnish_municipalities VALUES (275, '850', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/850', 'Toivakka', 'Toivakka');
INSERT INTO code_lists.finnish_municipalities VALUES (276, '851', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/851', 'Tornio', 'Torneå');
INSERT INTO code_lists.finnish_municipalities VALUES (277, '853', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/853', 'Turku', 'Åbo');
INSERT INTO code_lists.finnish_municipalities VALUES (278, '854', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/854', 'Pello', 'Pello');
INSERT INTO code_lists.finnish_municipalities VALUES (279, '857', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/857', 'Tuusniemi', 'Tuusniemi');
INSERT INTO code_lists.finnish_municipalities VALUES (280, '858', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/858', 'Tuusula', 'Tusby');
INSERT INTO code_lists.finnish_municipalities VALUES (281, '859', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/859', 'Tyrnävä', 'Tyrnävä');
INSERT INTO code_lists.finnish_municipalities VALUES (282, '886', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/886', 'Ulvila', 'Ulvsby');
INSERT INTO code_lists.finnish_municipalities VALUES (283, '887', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/887', 'Urjala', 'Urjala');
INSERT INTO code_lists.finnish_municipalities VALUES (284, '889', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/889', 'Utajärvi', 'Utajärvi');
INSERT INTO code_lists.finnish_municipalities VALUES (285, '890', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/890', 'Utsjoki', 'Utsjoki');
INSERT INTO code_lists.finnish_municipalities VALUES (286, '892', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/892', 'Uurainen', 'Uurainen');
INSERT INTO code_lists.finnish_municipalities VALUES (287, '893', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/893', 'Uusikaarlepyy', 'Nykarleby');
INSERT INTO code_lists.finnish_municipalities VALUES (288, '895', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/895', 'Uusikaupunki', 'Nystad');
INSERT INTO code_lists.finnish_municipalities VALUES (289, '905', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/905', 'Vaasa', 'Vasa');
INSERT INTO code_lists.finnish_municipalities VALUES (290, '908', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/908', 'Valkeakoski', 'Valkeakoski');
INSERT INTO code_lists.finnish_municipalities VALUES (291, '915', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/915', 'Varkaus', 'Varkaus');
INSERT INTO code_lists.finnish_municipalities VALUES (292, '918', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/918', 'Vehmaa', 'Vemo');
INSERT INTO code_lists.finnish_municipalities VALUES (293, '921', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/921', 'Vesanto', 'Vesanto');
INSERT INTO code_lists.finnish_municipalities VALUES (294, '922', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/922', 'Vesilahti', 'Vesilahti');
INSERT INTO code_lists.finnish_municipalities VALUES (295, '924', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/924', 'Veteli', 'Vetil');
INSERT INTO code_lists.finnish_municipalities VALUES (296, '925', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/925', 'Vieremä', 'Vieremä');
INSERT INTO code_lists.finnish_municipalities VALUES (297, '927', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/927', 'Vihti', 'Vichtis');
INSERT INTO code_lists.finnish_municipalities VALUES (298, '931', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/931', 'Viitasaari', 'Viitasaari');
INSERT INTO code_lists.finnish_municipalities VALUES (299, '934', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/934', 'Vimpeli', 'Vindala');
INSERT INTO code_lists.finnish_municipalities VALUES (300, '935', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/935', 'Virolahti', 'Vederlax');
INSERT INTO code_lists.finnish_municipalities VALUES (301, '936', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/936', 'Virrat', 'Virdois');
INSERT INTO code_lists.finnish_municipalities VALUES (302, '941', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/941', 'Vårdö', 'Vårdö');
INSERT INTO code_lists.finnish_municipalities VALUES (303, '946', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/946', 'Vöyri', 'Vörå');
INSERT INTO code_lists.finnish_municipalities VALUES (304, '976', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/976', 'Ylitornio', 'Övertorneå');
INSERT INTO code_lists.finnish_municipalities VALUES (305, '977', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/977', 'Ylivieska', 'Ylivieska');
INSERT INTO code_lists.finnish_municipalities VALUES (306, '980', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/980', 'Ylöjärvi', 'Ylöjärvi');
INSERT INTO code_lists.finnish_municipalities VALUES (307, '981', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/981', 'Ypäjä', 'Ypäjä');
INSERT INTO code_lists.finnish_municipalities VALUES (308, '989', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/989', 'Ähtäri', 'Etseri');
INSERT INTO code_lists.finnish_municipalities VALUES (309, '992', 'http://uri.suomi.fi/codelist/jhs/kunta_1_20230101/code/992', 'Äänekoski', 'Äänekoski');


--
-- Data for Name: finnish_municipality_codes; Type: TABLE DATA; Schema: code_lists; Owner: -
--

INSERT INTO code_lists.finnish_municipality_codes VALUES (1, '020', 'Akaa');
INSERT INTO code_lists.finnish_municipality_codes VALUES (2, '005', 'Alajärvi');
INSERT INTO code_lists.finnish_municipality_codes VALUES (3, '009', 'Alavieska');
INSERT INTO code_lists.finnish_municipality_codes VALUES (4, '010', 'Alavus');
INSERT INTO code_lists.finnish_municipality_codes VALUES (5, '016', 'Asikkala');
INSERT INTO code_lists.finnish_municipality_codes VALUES (6, '018', 'Askola');
INSERT INTO code_lists.finnish_municipality_codes VALUES (7, '019', 'Aura');
INSERT INTO code_lists.finnish_municipality_codes VALUES (8, '035', 'Brändö');
INSERT INTO code_lists.finnish_municipality_codes VALUES (9, '043', 'Eckerö');
INSERT INTO code_lists.finnish_municipality_codes VALUES (10, '046', 'Enonkoski');
INSERT INTO code_lists.finnish_municipality_codes VALUES (11, '047', 'Enontekiö');
INSERT INTO code_lists.finnish_municipality_codes VALUES (12, '049', 'Espoo');
INSERT INTO code_lists.finnish_municipality_codes VALUES (13, '050', 'Eura');
INSERT INTO code_lists.finnish_municipality_codes VALUES (14, '051', 'Eurajoki');
INSERT INTO code_lists.finnish_municipality_codes VALUES (15, '052', 'Evijärvi');
INSERT INTO code_lists.finnish_municipality_codes VALUES (16, '060', 'Finström');
INSERT INTO code_lists.finnish_municipality_codes VALUES (17, '061', 'Forssa');
INSERT INTO code_lists.finnish_municipality_codes VALUES (18, '062', 'Föglö');
INSERT INTO code_lists.finnish_municipality_codes VALUES (19, '065', 'Geta');
INSERT INTO code_lists.finnish_municipality_codes VALUES (20, '069', 'Haapajärvi');
INSERT INTO code_lists.finnish_municipality_codes VALUES (21, '071', 'Haapavesi');
INSERT INTO code_lists.finnish_municipality_codes VALUES (22, '072', 'Hailuoto');
INSERT INTO code_lists.finnish_municipality_codes VALUES (23, '074', 'Halsua');
INSERT INTO code_lists.finnish_municipality_codes VALUES (24, '075', 'Hamina');
INSERT INTO code_lists.finnish_municipality_codes VALUES (25, '076', 'Hammarland');
INSERT INTO code_lists.finnish_municipality_codes VALUES (26, '077', 'Hankasalmi');
INSERT INTO code_lists.finnish_municipality_codes VALUES (27, '078', 'Hanko');
INSERT INTO code_lists.finnish_municipality_codes VALUES (28, '079', 'Harjavalta');
INSERT INTO code_lists.finnish_municipality_codes VALUES (29, '081', 'Hartola');
INSERT INTO code_lists.finnish_municipality_codes VALUES (30, '082', 'Hattula');
INSERT INTO code_lists.finnish_municipality_codes VALUES (31, '086', 'Hausjärvi');
INSERT INTO code_lists.finnish_municipality_codes VALUES (32, '111', 'Heinola');
INSERT INTO code_lists.finnish_municipality_codes VALUES (33, '090', 'Heinävesi');
INSERT INTO code_lists.finnish_municipality_codes VALUES (34, '091', 'Helsinki');
INSERT INTO code_lists.finnish_municipality_codes VALUES (35, '097', 'Hirvensalmi');
INSERT INTO code_lists.finnish_municipality_codes VALUES (36, '098', 'Hollola');
INSERT INTO code_lists.finnish_municipality_codes VALUES (37, '099', 'Honkajoki');
INSERT INTO code_lists.finnish_municipality_codes VALUES (38, '102', 'Huittinen');
INSERT INTO code_lists.finnish_municipality_codes VALUES (39, '103', 'Humppila');
INSERT INTO code_lists.finnish_municipality_codes VALUES (40, '105', 'Hyrynsalmi');
INSERT INTO code_lists.finnish_municipality_codes VALUES (41, '106', 'Hyvinkää');
INSERT INTO code_lists.finnish_municipality_codes VALUES (42, '108', 'Hämeenkyrö');
INSERT INTO code_lists.finnish_municipality_codes VALUES (43, '109', 'Hämeenlinna');
INSERT INTO code_lists.finnish_municipality_codes VALUES (44, '139', 'Ii');
INSERT INTO code_lists.finnish_municipality_codes VALUES (45, '140', 'Iisalmi');
INSERT INTO code_lists.finnish_municipality_codes VALUES (46, '142', 'Iitti');
INSERT INTO code_lists.finnish_municipality_codes VALUES (47, '143', 'Ikaalinen');
INSERT INTO code_lists.finnish_municipality_codes VALUES (48, '145', 'Ilmajoki');
INSERT INTO code_lists.finnish_municipality_codes VALUES (49, '146', 'Ilomantsi');
INSERT INTO code_lists.finnish_municipality_codes VALUES (50, '153', 'Imatra');
INSERT INTO code_lists.finnish_municipality_codes VALUES (51, '148', 'Inari');
INSERT INTO code_lists.finnish_municipality_codes VALUES (52, '149', 'Inkoo');
INSERT INTO code_lists.finnish_municipality_codes VALUES (53, '151', 'Isojoki');
INSERT INTO code_lists.finnish_municipality_codes VALUES (54, '152', 'Isokyrö');
INSERT INTO code_lists.finnish_municipality_codes VALUES (55, '165', 'Janakkala');
INSERT INTO code_lists.finnish_municipality_codes VALUES (56, '167', 'Joensuu');
INSERT INTO code_lists.finnish_municipality_codes VALUES (57, '169', 'Jokioinen');
INSERT INTO code_lists.finnish_municipality_codes VALUES (58, '170', 'Jomala');
INSERT INTO code_lists.finnish_municipality_codes VALUES (59, '171', 'Joroinen');
INSERT INTO code_lists.finnish_municipality_codes VALUES (60, '172', 'Joutsa');
INSERT INTO code_lists.finnish_municipality_codes VALUES (61, '176', 'Juuka');
INSERT INTO code_lists.finnish_municipality_codes VALUES (62, '177', 'Juupajoki');
INSERT INTO code_lists.finnish_municipality_codes VALUES (63, '178', 'Juva');
INSERT INTO code_lists.finnish_municipality_codes VALUES (64, '179', 'Jyväskylä');
INSERT INTO code_lists.finnish_municipality_codes VALUES (65, '181', 'Jämijärvi');
INSERT INTO code_lists.finnish_municipality_codes VALUES (66, '182', 'Jämsä');
INSERT INTO code_lists.finnish_municipality_codes VALUES (67, '186', 'Järvenpää');
INSERT INTO code_lists.finnish_municipality_codes VALUES (68, '202', 'Kaarina');
INSERT INTO code_lists.finnish_municipality_codes VALUES (69, '204', 'Kaavi');
INSERT INTO code_lists.finnish_municipality_codes VALUES (70, '205', 'Kajaani');
INSERT INTO code_lists.finnish_municipality_codes VALUES (71, '208', 'Kalajoki');
INSERT INTO code_lists.finnish_municipality_codes VALUES (72, '211', 'Kangasala');
INSERT INTO code_lists.finnish_municipality_codes VALUES (73, '213', 'Kangasniemi');
INSERT INTO code_lists.finnish_municipality_codes VALUES (74, '214', 'Kankaanpää');
INSERT INTO code_lists.finnish_municipality_codes VALUES (75, '216', 'Kannonkoski');
INSERT INTO code_lists.finnish_municipality_codes VALUES (76, '217', 'Kannus');
INSERT INTO code_lists.finnish_municipality_codes VALUES (77, '218', 'Karijoki');
INSERT INTO code_lists.finnish_municipality_codes VALUES (78, '224', 'Karkkila');
INSERT INTO code_lists.finnish_municipality_codes VALUES (79, '226', 'Karstula');
INSERT INTO code_lists.finnish_municipality_codes VALUES (80, '230', 'Karvia');
INSERT INTO code_lists.finnish_municipality_codes VALUES (81, '231', 'Kaskinen');
INSERT INTO code_lists.finnish_municipality_codes VALUES (82, '232', 'Kauhajoki');
INSERT INTO code_lists.finnish_municipality_codes VALUES (83, '233', 'Kauhava');
INSERT INTO code_lists.finnish_municipality_codes VALUES (84, '235', 'Kauniainen');
INSERT INTO code_lists.finnish_municipality_codes VALUES (85, '236', 'Kaustinen');
INSERT INTO code_lists.finnish_municipality_codes VALUES (86, '239', 'Keitele');
INSERT INTO code_lists.finnish_municipality_codes VALUES (87, '240', 'Kemi');
INSERT INTO code_lists.finnish_municipality_codes VALUES (88, '320', 'Kemijärvi');
INSERT INTO code_lists.finnish_municipality_codes VALUES (89, '241', 'Keminmaa');
INSERT INTO code_lists.finnish_municipality_codes VALUES (90, '322', 'Kemiönsaari');
INSERT INTO code_lists.finnish_municipality_codes VALUES (91, '244', 'Kempele');
INSERT INTO code_lists.finnish_municipality_codes VALUES (92, '245', 'Kerava');
INSERT INTO code_lists.finnish_municipality_codes VALUES (93, '249', 'Keuruu');
INSERT INTO code_lists.finnish_municipality_codes VALUES (94, '250', 'Kihniö');
INSERT INTO code_lists.finnish_municipality_codes VALUES (95, '256', 'Kinnula');
INSERT INTO code_lists.finnish_municipality_codes VALUES (96, '257', 'Kirkkonummi');
INSERT INTO code_lists.finnish_municipality_codes VALUES (97, '260', 'Kitee');
INSERT INTO code_lists.finnish_municipality_codes VALUES (98, '261', 'Kittilä');
INSERT INTO code_lists.finnish_municipality_codes VALUES (99, '263', 'Kiuruvesi');
INSERT INTO code_lists.finnish_municipality_codes VALUES (100, '265', 'Kivijärvi');
INSERT INTO code_lists.finnish_municipality_codes VALUES (101, '271', 'Kokemäki');
INSERT INTO code_lists.finnish_municipality_codes VALUES (102, '272', 'Kokkola');
INSERT INTO code_lists.finnish_municipality_codes VALUES (103, '273', 'Kolari');
INSERT INTO code_lists.finnish_municipality_codes VALUES (104, '275', 'Konnevesi');
INSERT INTO code_lists.finnish_municipality_codes VALUES (105, '276', 'Kontiolahti');
INSERT INTO code_lists.finnish_municipality_codes VALUES (106, '280', 'Korsnäs');
INSERT INTO code_lists.finnish_municipality_codes VALUES (107, '284', 'Koski Tl');
INSERT INTO code_lists.finnish_municipality_codes VALUES (108, '285', 'Kotka');
INSERT INTO code_lists.finnish_municipality_codes VALUES (109, '286', 'Kouvola');
INSERT INTO code_lists.finnish_municipality_codes VALUES (110, '287', 'Kristiinankaupunki');
INSERT INTO code_lists.finnish_municipality_codes VALUES (111, '288', 'Kruunupyy');
INSERT INTO code_lists.finnish_municipality_codes VALUES (112, '290', 'Kuhmo');
INSERT INTO code_lists.finnish_municipality_codes VALUES (113, '291', 'Kuhmoinen');
INSERT INTO code_lists.finnish_municipality_codes VALUES (114, '295', 'Kumlinge');
INSERT INTO code_lists.finnish_municipality_codes VALUES (115, '297', 'Kuopio');
INSERT INTO code_lists.finnish_municipality_codes VALUES (116, '300', 'Kuortane');
INSERT INTO code_lists.finnish_municipality_codes VALUES (117, '301', 'Kurikka');
INSERT INTO code_lists.finnish_municipality_codes VALUES (118, '304', 'Kustavi');
INSERT INTO code_lists.finnish_municipality_codes VALUES (119, '305', 'Kuusamo');
INSERT INTO code_lists.finnish_municipality_codes VALUES (120, '312', 'Kyyjärvi');
INSERT INTO code_lists.finnish_municipality_codes VALUES (121, '316', 'Kärkölä');
INSERT INTO code_lists.finnish_municipality_codes VALUES (122, '317', 'Kärsämäki');
INSERT INTO code_lists.finnish_municipality_codes VALUES (123, '318', 'Kökar');
INSERT INTO code_lists.finnish_municipality_codes VALUES (124, '398', 'Lahti');
INSERT INTO code_lists.finnish_municipality_codes VALUES (125, '399', 'Laihia');
INSERT INTO code_lists.finnish_municipality_codes VALUES (126, '400', 'Laitila');
INSERT INTO code_lists.finnish_municipality_codes VALUES (127, '407', 'Lapinjärvi');
INSERT INTO code_lists.finnish_municipality_codes VALUES (128, '402', 'Lapinlahti');
INSERT INTO code_lists.finnish_municipality_codes VALUES (129, '403', 'Lappajärvi');
INSERT INTO code_lists.finnish_municipality_codes VALUES (130, '405', 'Lappeenranta');
INSERT INTO code_lists.finnish_municipality_codes VALUES (131, '408', 'Lapua');
INSERT INTO code_lists.finnish_municipality_codes VALUES (132, '410', 'Laukaa');
INSERT INTO code_lists.finnish_municipality_codes VALUES (133, '416', 'Lemi');
INSERT INTO code_lists.finnish_municipality_codes VALUES (134, '417', 'Lemland');
INSERT INTO code_lists.finnish_municipality_codes VALUES (135, '418', 'Lempäälä');
INSERT INTO code_lists.finnish_municipality_codes VALUES (136, '420', 'Leppävirta');
INSERT INTO code_lists.finnish_municipality_codes VALUES (137, '421', 'Lestijärvi');
INSERT INTO code_lists.finnish_municipality_codes VALUES (138, '422', 'Lieksa');
INSERT INTO code_lists.finnish_municipality_codes VALUES (139, '423', 'Lieto');
INSERT INTO code_lists.finnish_municipality_codes VALUES (140, '425', 'Liminka');
INSERT INTO code_lists.finnish_municipality_codes VALUES (141, '426', 'Liperi');
INSERT INTO code_lists.finnish_municipality_codes VALUES (142, '444', 'Lohja');
INSERT INTO code_lists.finnish_municipality_codes VALUES (143, '430', 'Loimaa');
INSERT INTO code_lists.finnish_municipality_codes VALUES (144, '433', 'Loppi');
INSERT INTO code_lists.finnish_municipality_codes VALUES (145, '434', 'Loviisa');
INSERT INTO code_lists.finnish_municipality_codes VALUES (146, '435', 'Luhanka');
INSERT INTO code_lists.finnish_municipality_codes VALUES (147, '436', 'Lumijoki');
INSERT INTO code_lists.finnish_municipality_codes VALUES (148, '438', 'Lumparland');
INSERT INTO code_lists.finnish_municipality_codes VALUES (149, '440', 'Luoto');
INSERT INTO code_lists.finnish_municipality_codes VALUES (150, '441', 'Luumäki');
INSERT INTO code_lists.finnish_municipality_codes VALUES (151, '475', 'Maalahti');
INSERT INTO code_lists.finnish_municipality_codes VALUES (152, '478', 'Maarianhamina - Mariehamn');
INSERT INTO code_lists.finnish_municipality_codes VALUES (153, '480', 'Marttila');
INSERT INTO code_lists.finnish_municipality_codes VALUES (154, '481', 'Masku');
INSERT INTO code_lists.finnish_municipality_codes VALUES (155, '483', 'Merijärvi');
INSERT INTO code_lists.finnish_municipality_codes VALUES (156, '484', 'Merikarvia');
INSERT INTO code_lists.finnish_municipality_codes VALUES (157, '489', 'Miehikkälä');
INSERT INTO code_lists.finnish_municipality_codes VALUES (158, '491', 'Mikkeli');
INSERT INTO code_lists.finnish_municipality_codes VALUES (159, '494', 'Muhos');
INSERT INTO code_lists.finnish_municipality_codes VALUES (160, '495', 'Multia');
INSERT INTO code_lists.finnish_municipality_codes VALUES (161, '498', 'Muonio');
INSERT INTO code_lists.finnish_municipality_codes VALUES (162, '499', 'Mustasaari');
INSERT INTO code_lists.finnish_municipality_codes VALUES (163, '500', 'Muurame');
INSERT INTO code_lists.finnish_municipality_codes VALUES (164, '503', 'Mynämäki');
INSERT INTO code_lists.finnish_municipality_codes VALUES (165, '504', 'Myrskylä');
INSERT INTO code_lists.finnish_municipality_codes VALUES (166, '505', 'Mäntsälä');
INSERT INTO code_lists.finnish_municipality_codes VALUES (167, '508', 'Mänttä-Vilppula');
INSERT INTO code_lists.finnish_municipality_codes VALUES (168, '507', 'Mäntyharju');
INSERT INTO code_lists.finnish_municipality_codes VALUES (169, '529', 'Naantali');
INSERT INTO code_lists.finnish_municipality_codes VALUES (170, '531', 'Nakkila');
INSERT INTO code_lists.finnish_municipality_codes VALUES (171, '535', 'Nivala');
INSERT INTO code_lists.finnish_municipality_codes VALUES (172, '536', 'Nokia');
INSERT INTO code_lists.finnish_municipality_codes VALUES (173, '538', 'Nousiainen');
INSERT INTO code_lists.finnish_municipality_codes VALUES (174, '541', 'Nurmes');
INSERT INTO code_lists.finnish_municipality_codes VALUES (175, '543', 'Nurmijärvi');
INSERT INTO code_lists.finnish_municipality_codes VALUES (176, '545', 'Närpiö');
INSERT INTO code_lists.finnish_municipality_codes VALUES (177, '560', 'Orimattila');
INSERT INTO code_lists.finnish_municipality_codes VALUES (178, '561', 'Oripää');
INSERT INTO code_lists.finnish_municipality_codes VALUES (179, '562', 'Orivesi');
INSERT INTO code_lists.finnish_municipality_codes VALUES (180, '563', 'Oulainen');
INSERT INTO code_lists.finnish_municipality_codes VALUES (181, '564', 'Oulu');
INSERT INTO code_lists.finnish_municipality_codes VALUES (182, '309', 'Outokumpu');
INSERT INTO code_lists.finnish_municipality_codes VALUES (183, '576', 'Padasjoki');
INSERT INTO code_lists.finnish_municipality_codes VALUES (184, '577', 'Paimio');
INSERT INTO code_lists.finnish_municipality_codes VALUES (185, '578', 'Paltamo');
INSERT INTO code_lists.finnish_municipality_codes VALUES (186, '445', 'Parainen');
INSERT INTO code_lists.finnish_municipality_codes VALUES (187, '580', 'Parikkala');
INSERT INTO code_lists.finnish_municipality_codes VALUES (188, '581', 'Parkano');
INSERT INTO code_lists.finnish_municipality_codes VALUES (189, '599', 'Pedersören kunta');
INSERT INTO code_lists.finnish_municipality_codes VALUES (190, '583', 'Pelkosenniemi');
INSERT INTO code_lists.finnish_municipality_codes VALUES (191, '854', 'Pello');
INSERT INTO code_lists.finnish_municipality_codes VALUES (192, '584', 'Perho');
INSERT INTO code_lists.finnish_municipality_codes VALUES (193, '588', 'Pertunmaa');
INSERT INTO code_lists.finnish_municipality_codes VALUES (194, '592', 'Petäjävesi');
INSERT INTO code_lists.finnish_municipality_codes VALUES (195, '593', 'Pieksämäki');
INSERT INTO code_lists.finnish_municipality_codes VALUES (196, '595', 'Pielavesi');
INSERT INTO code_lists.finnish_municipality_codes VALUES (197, '598', 'Pietarsaari');
INSERT INTO code_lists.finnish_municipality_codes VALUES (198, '601', 'Pihtipudas');
INSERT INTO code_lists.finnish_municipality_codes VALUES (199, '604', 'Pirkkala');
INSERT INTO code_lists.finnish_municipality_codes VALUES (200, '607', 'Polvijärvi');
INSERT INTO code_lists.finnish_municipality_codes VALUES (201, '608', 'Pomarkku');
INSERT INTO code_lists.finnish_municipality_codes VALUES (202, '609', 'Pori');
INSERT INTO code_lists.finnish_municipality_codes VALUES (203, '611', 'Pornainen');
INSERT INTO code_lists.finnish_municipality_codes VALUES (204, '638', 'Porvoo');
INSERT INTO code_lists.finnish_municipality_codes VALUES (205, '614', 'Posio');
INSERT INTO code_lists.finnish_municipality_codes VALUES (206, '615', 'Pudasjärvi');
INSERT INTO code_lists.finnish_municipality_codes VALUES (207, '616', 'Pukkila');
INSERT INTO code_lists.finnish_municipality_codes VALUES (208, '619', 'Punkalaidun');
INSERT INTO code_lists.finnish_municipality_codes VALUES (209, '620', 'Puolanka');
INSERT INTO code_lists.finnish_municipality_codes VALUES (210, '623', 'Puumala');
INSERT INTO code_lists.finnish_municipality_codes VALUES (211, '624', 'Pyhtää');
INSERT INTO code_lists.finnish_municipality_codes VALUES (212, '625', 'Pyhäjoki');
INSERT INTO code_lists.finnish_municipality_codes VALUES (213, '626', 'Pyhäjärvi');
INSERT INTO code_lists.finnish_municipality_codes VALUES (214, '630', 'Pyhäntä');
INSERT INTO code_lists.finnish_municipality_codes VALUES (215, '631', 'Pyhäranta');
INSERT INTO code_lists.finnish_municipality_codes VALUES (216, '635', 'Pälkäne');
INSERT INTO code_lists.finnish_municipality_codes VALUES (217, '636', 'Pöytyä');
INSERT INTO code_lists.finnish_municipality_codes VALUES (218, '678', 'Raahe');
INSERT INTO code_lists.finnish_municipality_codes VALUES (219, '710', 'Raasepori');
INSERT INTO code_lists.finnish_municipality_codes VALUES (220, '680', 'Raisio');
INSERT INTO code_lists.finnish_municipality_codes VALUES (221, '681', 'Rantasalmi');
INSERT INTO code_lists.finnish_municipality_codes VALUES (222, '683', 'Ranua');
INSERT INTO code_lists.finnish_municipality_codes VALUES (223, '684', 'Rauma');
INSERT INTO code_lists.finnish_municipality_codes VALUES (224, '686', 'Rautalampi');
INSERT INTO code_lists.finnish_municipality_codes VALUES (225, '687', 'Rautavaara');
INSERT INTO code_lists.finnish_municipality_codes VALUES (226, '689', 'Rautjärvi');
INSERT INTO code_lists.finnish_municipality_codes VALUES (227, '691', 'Reisjärvi');
INSERT INTO code_lists.finnish_municipality_codes VALUES (228, '694', 'Riihimäki');
INSERT INTO code_lists.finnish_municipality_codes VALUES (229, '697', 'Ristijärvi');
INSERT INTO code_lists.finnish_municipality_codes VALUES (230, '698', 'Rovaniemi');
INSERT INTO code_lists.finnish_municipality_codes VALUES (231, '700', 'Ruokolahti');
INSERT INTO code_lists.finnish_municipality_codes VALUES (232, '702', 'Ruovesi');
INSERT INTO code_lists.finnish_municipality_codes VALUES (233, '704', 'Rusko');
INSERT INTO code_lists.finnish_municipality_codes VALUES (234, '707', 'Rääkkylä');
INSERT INTO code_lists.finnish_municipality_codes VALUES (235, '729', 'Saarijärvi');
INSERT INTO code_lists.finnish_municipality_codes VALUES (236, '732', 'Salla');
INSERT INTO code_lists.finnish_municipality_codes VALUES (237, '734', 'Salo');
INSERT INTO code_lists.finnish_municipality_codes VALUES (238, '736', 'Saltvik');
INSERT INTO code_lists.finnish_municipality_codes VALUES (239, '790', 'Sastamala');
INSERT INTO code_lists.finnish_municipality_codes VALUES (240, '738', 'Sauvo');
INSERT INTO code_lists.finnish_municipality_codes VALUES (241, '739', 'Savitaipale');
INSERT INTO code_lists.finnish_municipality_codes VALUES (242, '740', 'Savonlinna');
INSERT INTO code_lists.finnish_municipality_codes VALUES (243, '742', 'Savukoski');
INSERT INTO code_lists.finnish_municipality_codes VALUES (244, '743', 'Seinäjoki');
INSERT INTO code_lists.finnish_municipality_codes VALUES (245, '746', 'Sievi');
INSERT INTO code_lists.finnish_municipality_codes VALUES (246, '747', 'Siikainen');
INSERT INTO code_lists.finnish_municipality_codes VALUES (247, '748', 'Siikajoki');
INSERT INTO code_lists.finnish_municipality_codes VALUES (248, '791', 'Siikalatva');
INSERT INTO code_lists.finnish_municipality_codes VALUES (249, '749', 'Siilinjärvi');
INSERT INTO code_lists.finnish_municipality_codes VALUES (250, '751', 'Simo');
INSERT INTO code_lists.finnish_municipality_codes VALUES (251, '753', 'Sipoo');
INSERT INTO code_lists.finnish_municipality_codes VALUES (252, '755', 'Siuntio');
INSERT INTO code_lists.finnish_municipality_codes VALUES (253, '758', 'Sodankylä');
INSERT INTO code_lists.finnish_municipality_codes VALUES (254, '759', 'Soini');
INSERT INTO code_lists.finnish_municipality_codes VALUES (255, '761', 'Somero');
INSERT INTO code_lists.finnish_municipality_codes VALUES (256, '762', 'Sonkajärvi');
INSERT INTO code_lists.finnish_municipality_codes VALUES (257, '765', 'Sotkamo');
INSERT INTO code_lists.finnish_municipality_codes VALUES (258, '766', 'Sottunga');
INSERT INTO code_lists.finnish_municipality_codes VALUES (259, '768', 'Sulkava');
INSERT INTO code_lists.finnish_municipality_codes VALUES (260, '771', 'Sund');
INSERT INTO code_lists.finnish_municipality_codes VALUES (261, '777', 'Suomussalmi');
INSERT INTO code_lists.finnish_municipality_codes VALUES (262, '778', 'Suonenjoki');
INSERT INTO code_lists.finnish_municipality_codes VALUES (263, '781', 'Sysmä');
INSERT INTO code_lists.finnish_municipality_codes VALUES (264, '783', 'Säkylä');
INSERT INTO code_lists.finnish_municipality_codes VALUES (265, '831', 'Taipalsaari');
INSERT INTO code_lists.finnish_municipality_codes VALUES (266, '832', 'Taivalkoski');
INSERT INTO code_lists.finnish_municipality_codes VALUES (267, '833', 'Taivassalo');
INSERT INTO code_lists.finnish_municipality_codes VALUES (268, '834', 'Tammela');
INSERT INTO code_lists.finnish_municipality_codes VALUES (269, '837', 'Tampere');
INSERT INTO code_lists.finnish_municipality_codes VALUES (270, '844', 'Tervo');
INSERT INTO code_lists.finnish_municipality_codes VALUES (271, '845', 'Tervola');
INSERT INTO code_lists.finnish_municipality_codes VALUES (272, '846', 'Teuva');
INSERT INTO code_lists.finnish_municipality_codes VALUES (273, '848', 'Tohmajärvi');
INSERT INTO code_lists.finnish_municipality_codes VALUES (274, '849', 'Toholampi');
INSERT INTO code_lists.finnish_municipality_codes VALUES (275, '850', 'Toivakka');
INSERT INTO code_lists.finnish_municipality_codes VALUES (276, '851', 'Tornio');
INSERT INTO code_lists.finnish_municipality_codes VALUES (277, '853', 'Turku');
INSERT INTO code_lists.finnish_municipality_codes VALUES (278, '857', 'Tuusniemi');
INSERT INTO code_lists.finnish_municipality_codes VALUES (279, '858', 'Tuusula');
INSERT INTO code_lists.finnish_municipality_codes VALUES (280, '859', 'Tyrnävä');
INSERT INTO code_lists.finnish_municipality_codes VALUES (281, '886', 'Ulvila');
INSERT INTO code_lists.finnish_municipality_codes VALUES (282, '887', 'Urjala');
INSERT INTO code_lists.finnish_municipality_codes VALUES (283, '889', 'Utajärvi');
INSERT INTO code_lists.finnish_municipality_codes VALUES (284, '890', 'Utsjoki');
INSERT INTO code_lists.finnish_municipality_codes VALUES (285, '892', 'Uurainen');
INSERT INTO code_lists.finnish_municipality_codes VALUES (286, '893', 'Uusikaarlepyy');
INSERT INTO code_lists.finnish_municipality_codes VALUES (287, '895', 'Uusikaupunki');
INSERT INTO code_lists.finnish_municipality_codes VALUES (288, '785', 'Vaala');
INSERT INTO code_lists.finnish_municipality_codes VALUES (289, '905', 'Vaasa');
INSERT INTO code_lists.finnish_municipality_codes VALUES (290, '908', 'Valkeakoski');
INSERT INTO code_lists.finnish_municipality_codes VALUES (291, '092', 'Vantaa');
INSERT INTO code_lists.finnish_municipality_codes VALUES (292, '915', 'Varkaus');
INSERT INTO code_lists.finnish_municipality_codes VALUES (293, '918', 'Vehmaa');
INSERT INTO code_lists.finnish_municipality_codes VALUES (294, '921', 'Vesanto');
INSERT INTO code_lists.finnish_municipality_codes VALUES (295, '922', 'Vesilahti');
INSERT INTO code_lists.finnish_municipality_codes VALUES (296, '924', 'Veteli');
INSERT INTO code_lists.finnish_municipality_codes VALUES (297, '925', 'Vieremä');
INSERT INTO code_lists.finnish_municipality_codes VALUES (298, '927', 'Vihti');
INSERT INTO code_lists.finnish_municipality_codes VALUES (299, '931', 'Viitasaari');
INSERT INTO code_lists.finnish_municipality_codes VALUES (300, '934', 'Vimpeli');
INSERT INTO code_lists.finnish_municipality_codes VALUES (301, '935', 'Virolahti');
INSERT INTO code_lists.finnish_municipality_codes VALUES (302, '936', 'Virrat');
INSERT INTO code_lists.finnish_municipality_codes VALUES (303, '941', 'Vårdö');
INSERT INTO code_lists.finnish_municipality_codes VALUES (304, '946', 'Vöyri');
INSERT INTO code_lists.finnish_municipality_codes VALUES (305, '976', 'Ylitornio');
INSERT INTO code_lists.finnish_municipality_codes VALUES (306, '977', 'Ylivieska');
INSERT INTO code_lists.finnish_municipality_codes VALUES (307, '980', 'Ylöjärvi');
INSERT INTO code_lists.finnish_municipality_codes VALUES (308, '981', 'Ypäjä');
INSERT INTO code_lists.finnish_municipality_codes VALUES (309, '989', 'Ähtäri');
INSERT INTO code_lists.finnish_municipality_codes VALUES (310, '992', 'Äänekoski');


--
-- Data for Name: finnish_numeric_value; Type: TABLE DATA; Schema: code_lists; Owner: -
--

INSERT INTO code_lists.finnish_numeric_value VALUES (2, 2, 'Rakennusoikeus murtolukuna', '1,2', NULL, NULL);
INSERT INTO code_lists.finnish_numeric_value VALUES (5, 6, 'Sallittu asuinhuoneistojen osuus rakennusalasta', '2', NULL, NULL);
INSERT INTO code_lists.finnish_numeric_value VALUES (6, 7, 'Salittu myymälätilojen osuus rakennusalasta', '2', NULL, NULL);
INSERT INTO code_lists.finnish_numeric_value VALUES (9, 10, 'Luku osoittaa neliömetreinä, kuinka suuren osan rakennuksen alimmasta kerroksesta (I) saa kerroalaneliömetreinä ilmoitetun kerrosalan lisäksi käyttää asukkaiden yhteistiloihin', '2', NULL, NULL);
INSERT INTO code_lists.finnish_numeric_value VALUES (10, 11, 'Velvoitettu päiväkotitilojen osuus alimman kerroksen rakennusalasta', '2', NULL, NULL);
INSERT INTO code_lists.finnish_numeric_value VALUES (16, 17, 'Kerrosalaneliömetri määrä, jota kohti on rakennettava yksi autopaikka', '2', NULL, NULL);
INSERT INTO code_lists.finnish_numeric_value VALUES (17, 18, 'Autopaikkojen lukumäärä asuntoa kohti', '2', NULL, NULL);
INSERT INTO code_lists.finnish_numeric_value VALUES (18, 19, 'Desibeliraja', '3', NULL, NULL);
INSERT INTO code_lists.finnish_numeric_value VALUES (22, 22, 'Rakentamisen määrä', NULL, '03', NULL);
INSERT INTO code_lists.finnish_numeric_value VALUES (23, 23, 'Sallittu kerrosala', NULL, '0301', NULL);
INSERT INTO code_lists.finnish_numeric_value VALUES (24, 24, 'Sallittu rakennustilavuus', NULL, '0302', NULL);
INSERT INTO code_lists.finnish_numeric_value VALUES (25, 25, 'Maanalainen kerrosluku', NULL, '0305', NULL);
INSERT INTO code_lists.finnish_numeric_value VALUES (26, 26, 'Rakennuspaikkojen määrä', NULL, '0308', NULL);
INSERT INTO code_lists.finnish_numeric_value VALUES (27, 27, 'Etäisyys naapuritontin rajasta', NULL, '0402', NULL);
INSERT INTO code_lists.finnish_numeric_value VALUES (28, 28, 'Rakennusala', NULL, '0403', NULL);
INSERT INTO code_lists.finnish_numeric_value VALUES (29, 29, 'Korkeusasema', NULL, '06', NULL);
INSERT INTO code_lists.finnish_numeric_value VALUES (30, 30, 'Maanalaisen kohteen korkeusasema', NULL, '0606', NULL);
INSERT INTO code_lists.finnish_numeric_value VALUES (31, 31, 'Muu korkeusasemaan liittyvä määräys', NULL, '0607', NULL);
INSERT INTO code_lists.finnish_numeric_value VALUES (32, 32, 'Vihertehokkuus', NULL, '0701', NULL);
INSERT INTO code_lists.finnish_numeric_value VALUES (33, 33, 'Autopaikkojen määrä', NULL, '0803', NULL);
INSERT INTO code_lists.finnish_numeric_value VALUES (34, 34, 'Polkupyöräpysäköinnin määrä', NULL, '0804', NULL);
INSERT INTO code_lists.finnish_numeric_value VALUES (35, 35, 'Ajanmukaisuuden arvioinnin aikaraja', NULL, '1102', NULL);
INSERT INTO code_lists.finnish_numeric_value VALUES (36, 36, 'Alin painovoimainen viemäröintitaso', NULL, '1201', NULL);
INSERT INTO code_lists.finnish_numeric_value VALUES (37, 37, 'Aurinkokennojen alin sijoittumistaso', NULL, '1202', NULL);
INSERT INTO code_lists.finnish_numeric_value VALUES (38, 38, 'Muu liikenteeseen liittyvä määräys', NULL, '0805', NULL);
INSERT INTO code_lists.finnish_numeric_value VALUES (1, 1, 'Rakennusoikeus kerrosalaneliömetreinä', '1,2', '0301', NULL);
INSERT INTO code_lists.finnish_numeric_value VALUES (20, 3, 'Tehokkuusluku', '1', '0303', NULL);
INSERT INTO code_lists.finnish_numeric_value VALUES (3, 4, 'Kerrosluku', '1,2', '0304', NULL);
INSERT INTO code_lists.finnish_numeric_value VALUES (4, 5, 'Kattokaltevuus', '2', '0501', NULL);
INSERT INTO code_lists.finnish_numeric_value VALUES (7, 8, 'Osuus, jonka rakennuksen suurimman kerroksen alasta saa kellarikerroksessa käyttää kerrosalaan luettavaksi tilaksi', '2', '0306', NULL);
INSERT INTO code_lists.finnish_numeric_value VALUES (8, 9, 'Osuus, jonka rakennuksen suurimman kerroksen alasta saa käyttää ullakon tasolla kerrosalaan luettavaksi tilaksi', '2', '0307', NULL);
INSERT INTO code_lists.finnish_numeric_value VALUES (11, 12, 'Maanipinnan likimääräinen korkeusasema', '3', '0601', NULL);
INSERT INTO code_lists.finnish_numeric_value VALUES (12, 13, 'Rakennuksen vesikaton ylimmän kohdan korkeusasema', '2', '0602', NULL);
INSERT INTO code_lists.finnish_numeric_value VALUES (13, 14, 'Rakennuksen julkisivupinnan ja vesikaton leikkauskohdan ylin korkeusasema', '2', '0603', NULL);
INSERT INTO code_lists.finnish_numeric_value VALUES (14, 15, 'Rakennuksen julkisivun enimmäiskorkeus metreinä', '2,3', '0604', NULL);
INSERT INTO code_lists.finnish_numeric_value VALUES (15, 16, 'Rakennuksen, rakenteiden ja laitteiden ylin korkeusasema', '2', '0605', NULL);
INSERT INTO code_lists.finnish_numeric_value VALUES (19, 20, 'Muu lisärakennusoikeus kerrosalaneliömetreinä', '1,2', '0309', NULL);
INSERT INTO code_lists.finnish_numeric_value VALUES (21, 21, 'Osuus, kuinka suuren osan alueesta tai rakennusalasta saa käyttää rakentamiseen', '2', '0401', NULL);


--
-- Data for Name: finnish_ordinance_process; Type: TABLE DATA; Schema: code_lists; Owner: -
--

INSERT INTO code_lists.finnish_ordinance_process VALUES (1, 1, 'Uusi asemakaava');
INSERT INTO code_lists.finnish_ordinance_process VALUES (2, 2, 'Asemakaavan muutos');
INSERT INTO code_lists.finnish_ordinance_process VALUES (3, 3, 'Uusi ranta-asemakaava');
INSERT INTO code_lists.finnish_ordinance_process VALUES (4, 4, 'Ranta-asemakaavan muutos');


--
-- Data for Name: finnish_ordinance_process_step; Type: TABLE DATA; Schema: code_lists; Owner: -
--

INSERT INTO code_lists.finnish_ordinance_process_step VALUES (1, 1, 'Aloitusvaihe');
INSERT INTO code_lists.finnish_ordinance_process_step VALUES (2, 2, 'Valmisteluvaihe');
INSERT INTO code_lists.finnish_ordinance_process_step VALUES (3, 3, 'Ehdotusvaihe');
INSERT INTO code_lists.finnish_ordinance_process_step VALUES (4, 4, 'Hyväksymisvaihe');
INSERT INTO code_lists.finnish_ordinance_process_step VALUES (5, 5, 'Voimaantulo');
INSERT INTO code_lists.finnish_ordinance_process_step VALUES (6, 6, 'Kumoaminen');
INSERT INTO code_lists.finnish_ordinance_process_step VALUES (7, 7, 'Raukeaminen');


--
-- Data for Name: finnish_plan_description; Type: TABLE DATA; Schema: code_lists; Owner: -
--

INSERT INTO code_lists.finnish_plan_description VALUES (1, '1', 'Tiivistelmä');
INSERT INTO code_lists.finnish_plan_description VALUES (2, '2', 'Lähtökohdat');
INSERT INTO code_lists.finnish_plan_description VALUES (3, '2A', 'Selvitys suunnittelualueen oloista');
INSERT INTO code_lists.finnish_plan_description VALUES (4, '2B', 'Suunnittelutilanne');
INSERT INTO code_lists.finnish_plan_description VALUES (5, '3', 'Suunnittelun vaiheet');
INSERT INTO code_lists.finnish_plan_description VALUES (6, '3A', 'Kaavan suunnittelun tarve');
INSERT INTO code_lists.finnish_plan_description VALUES (7, '3B', 'Suunnittelun käynnistäminen ja sitä koskevat päätökset');
INSERT INTO code_lists.finnish_plan_description VALUES (8, '3C', 'Osallistuminen ja yhteistyö');
INSERT INTO code_lists.finnish_plan_description VALUES (9, '3D', 'Kaavan tavoitteet');
INSERT INTO code_lists.finnish_plan_description VALUES (10, '3E', 'Kaavaratkaisun vaihtoehdot');
INSERT INTO code_lists.finnish_plan_description VALUES (11, '4', 'Kaavan kuvaus');
INSERT INTO code_lists.finnish_plan_description VALUES (12, '4A', 'Kaavan rakenne');
INSERT INTO code_lists.finnish_plan_description VALUES (13, '4B', 'Aluevaraukset');
INSERT INTO code_lists.finnish_plan_description VALUES (14, '4C', 'Nimistö');
INSERT INTO code_lists.finnish_plan_description VALUES (15, '5', 'Kaavan vaikutukset');
INSERT INTO code_lists.finnish_plan_description VALUES (16, '5A', 'Vaikutukset rakennettuun ympäristöön');
INSERT INTO code_lists.finnish_plan_description VALUES (17, '5B', 'Vaikutukset luontoon ja luonnon ympäristöön');
INSERT INTO code_lists.finnish_plan_description VALUES (18, '5C', 'Muut vaikutukset');
INSERT INTO code_lists.finnish_plan_description VALUES (19, '5D', 'Ympäristön häiriötekijät');
INSERT INTO code_lists.finnish_plan_description VALUES (20, '6', 'Kaavan toteutus');
INSERT INTO code_lists.finnish_plan_description VALUES (21, '6A', 'Toteutusta ohjaavat ja havainnollistavat suunnitelmat');
INSERT INTO code_lists.finnish_plan_description VALUES (22, '6B', 'Toteuttaminen ja ajoitus');
INSERT INTO code_lists.finnish_plan_description VALUES (23, '6C', 'Toteutuksen seuranta');


--
-- Data for Name: finnish_planned_space_type; Type: TABLE DATA; Schema: code_lists; Owner: -
--

INSERT INTO code_lists.finnish_planned_space_type VALUES (1, 1, 'Rakennusala');
INSERT INTO code_lists.finnish_planned_space_type VALUES (2, 2, 'Osa-alue');


--
-- Data for Name: finnish_planning_detail_line_type; Type: TABLE DATA; Schema: code_lists; Owner: -
--

INSERT INTO code_lists.finnish_planning_detail_line_type VALUES (1, 1, 'Melusuojaustarve');
INSERT INTO code_lists.finnish_planning_detail_line_type VALUES (2, 2, 'Liittymäkielto');
INSERT INTO code_lists.finnish_planning_detail_line_type VALUES (3, 3, 'Harjasuunta');
INSERT INTO code_lists.finnish_planning_detail_line_type VALUES (4, 4, 'Ulkoilureitti');
INSERT INTO code_lists.finnish_planning_detail_line_type VALUES (5, 5, 'Puurivi');
INSERT INTO code_lists.finnish_planning_detail_line_type VALUES (6, 6, 'Rakennusalan sivu, johon kohdistuu lisätieto');
INSERT INTO code_lists.finnish_planning_detail_line_type VALUES (7, 7, 'Muu');


--
-- Data for Name: finnish_planning_detail_point_type; Type: TABLE DATA; Schema: code_lists; Owner: -
--

INSERT INTO code_lists.finnish_planning_detail_point_type VALUES (1, 1, 'Ajoneuvoliittymän likimääräinen sijainti');
INSERT INTO code_lists.finnish_planning_detail_point_type VALUES (2, 3, 'Suojeltava puu');
INSERT INTO code_lists.finnish_planning_detail_point_type VALUES (3, 4, 'Maanpinnan likimääräinen korkeusasema');
INSERT INTO code_lists.finnish_planning_detail_point_type VALUES (4, 2, 'Rakennuksen sivu, johon rakennus on rakennettava kiinni');
INSERT INTO code_lists.finnish_planning_detail_point_type VALUES (5, 5, 'Muu');


--
-- Data for Name: finnish_regulative_text_type; Type: TABLE DATA; Schema: code_lists; Owner: -
--

INSERT INTO code_lists.finnish_regulative_text_type VALUES (38, 38, 'Leikkialue', '020202', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/020202');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (39, 39, 'Oleskelualue', '020203', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/020203');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (40, 40, 'Varattu huoltoajolle', '020317', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/020317');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (41, 41, 'Varattu jalankululle', '020318', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/020318');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (42, 42, 'Varattu polkypyöräilylle', '020320', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/020320');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (43, 43, 'Tontille ajo sallittu', '020312', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/020312');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (44, 44, 'Sähkölinja', '020102', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/020102');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (45, 45, 'Kaasulinja', '020103', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/020103');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (46, 46, 'Vesi- tai jätevesitunneli', '020104', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/020104');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (47, 47, 'Vesijohto tai siirtoviemäri', '020105', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/020105');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (48, 48, 'Kaukolämpölinja', '020106', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/020106');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (49, 49, 'Kaukokylmälinja', '020107', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/020107');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (50, 50, 'Tulvapenger', '020108', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/020108');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (51, 51, 'Tulvareitti', '020109', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/020109');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (52, 52, 'Pumppaamo', '020110', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/020110');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (53, 53, 'Muuntamo', '020111', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/020111');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (54, 54, 'Suojavyöhyke', '020112', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/020112');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (55, 55, 'Hulevesijärjestelmä', '020113', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/020113');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (56, 56, 'Hulevesien viivytysallas', '020114', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/020114');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (57, 57, 'Avo-oja', '020115', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/020115');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (58, 58, 'Muu yhdyskuntatekniseen huoltoon liittyvä käyttö', '020116', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/020116');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (59, 59, 'Kadun tai liikennealueen alittava kevyen liikenteen yhteys', '020303', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/020303');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (60, 60, 'Eritasoristeys', '020305', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/020305');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (61, 61, 'Hidaskatu', '020306', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/020306');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (62, 62, 'Katuaukio/Tori', '020307', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/020307');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (63, 63, 'Pelastustie', '020309', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/020309');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (64, 64, 'Pihakatu', '020310', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/020310');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (65, 65, 'Kadun tai liikennealueen ylittävä kevyen liikenteen yhteys', '020323', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/020323');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (66, 66, 'Varattu alueen sisäiselle jalankululle', '020315', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/020315');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (67, 67, 'Varattu alueen sisäiselle polkupyöräilylle', '020316', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/020316');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (68, 68, 'Muu liikennejärjestelmään liittyvä käyttö', '020324', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/020324');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (69, 69, 'Asuntovaunualue', '020401', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/020401');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (70, 70, 'Frisbeegolf', '020402', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/020402');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (71, 71, 'Golf-väylä', '020403', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/020403');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (72, 72, 'Kenttä', '020404', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/020404');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (73, 73, 'Koirapuisto', '020405', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/020405');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (74, 74, 'Mäenlaskupaikka', '020406', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/020406');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (75, 75, 'Ratsastuskenttä', '020407', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/020407');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (76, 76, 'Telttailu', '020408', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/020408');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (77, 77, 'Muu virkistyskäyttö', '020409', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/020409');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (78, 78, 'Laidun', '020501', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/020501');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (79, 79, 'Muu maatalouskäyttö', '020502', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/020502');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (80, 80, 'Rakennusalan käyttötarkoitus. Rakennusluokitus 2018 -koodiston avulla tai tekstiarvona.', '0206', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/0206');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (81, 81, 'Muu tontinkäyttöön liittyvä käyttö', '020207', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/020207');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (82, 82, 'Pengerrys', '020206', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/020206');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (83, 83, 'Rakennettava kiinni rajaan', '0404', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/0404');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (84, 84, 'Muu rakennusten sijoitukseen liittyvä määräys', '0406', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/0406');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (85, 85, 'Rakennuksen sivu, jolla tulee olla suora uloskäynti porrashuoneista', '0506', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/0506');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (86, 86, 'Rakennusalan sivu, jonka puoleiseen rakennuksen seinään ei saa sijoittaa ikkunoita', '0507', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/0507');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (87, 87, 'Parvekkeet sijoitettava rungon sisään', '0509', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/0509');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (88, 88, 'Hissi', '0510', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/0510');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (89, 89, 'Viherkatto', '0511', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/0511');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (90, 90, 'Kelluvat asuinrakennukset', '0512', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/0512');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (91, 91, 'Muu rakentamistapaan liittyvä määräys', '0513', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/0513');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (92, 92, 'Puusto tai kasvillisuus säilytettävä tai korvattava', '0702', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/0702');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (93, 93, 'Olemassa oleva puusto säilytettävä', '0703', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/0703');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (94, 94, 'Maisema säilytettävä avoimena', '0704', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/0704');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (95, 95, 'Suojeltava rakennelma', '090103', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/090103');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (96, 96, 'Kiinteä suojeltava kohde', '090104', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/090104');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (97, 97, 'Alue tai alueen osa, jolla sijaitsee muinaismuistolailla rauhoitettu kiinteä muinaisjäännös', '090105', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/090105');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (98, 98, 'Suojeltava vesistö tai vesialue', '090203', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/090203');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (99, 99, 'Luonnon monimuotoisuuden kannalta tärkeä alue', '090204', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/090204');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (100, 100, 'Ekologinen yhteys', '090205', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/090205');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (101, 101, 'Alue, jolla ympäristö säilytetään', '0903', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/0903');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (102, 102, 'Alue, jolla on erityistä ulkoilun ohjaamistarvetta', '0904', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/0904');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (103, 103, 'Yleismääräys', '1101', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/1101');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (104, 104, 'Vaatimus hulevesisuunnitelman laatimisesta', '1203', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/1203');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (105, 105, 'Liitettävä kaukolämpöverkkoon', '1204', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/1204');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (106, 106, 'Hulevesien imeyttämisen periaate tai vaatimus', '1205', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/1205');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (3, 1, 'Muu alueen osan käyttötarkoitus', '0207', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/0207');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (107, 107, 'Muu yhdyskuntatekniseen huoltoon liittyvä määräys', '1206', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/1206');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (108, 108, 'Pilaantunut maa-alue', '1301', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/1301');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (109, 109, 'Meluaita', '1302', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/1302');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (110, 110, 'Meluvalli', '1303', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/1303');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (111, 111, 'Melualue', '1304', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/1304');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (112, 112, 'Radonhaitta huomioitava', '1305', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/1305');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (113, 113, 'Muu ympäristönsuojeluun liittyvä määräys', '1306', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/1306');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (4, 2, 'Auton säilytyspaikka', '020304', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/020304');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (5, 3, 'Pysäköintialue', '020311', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/020311');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (37, 4, 'Istutettava alueen osa', '020201', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/020201');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (7, 6, 'Maanalaisiin tiloihin johtava ajoliuska', '020301', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/020301');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (11, 10, 'Liikennetunneli', '020308', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/020308');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (24, 23, 'Varattu joukkoliikenteelle', '020319', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/020319');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (25, 24, 'Ajoyhteys', '020302', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/020302');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (26, 25, 'Varattu alueen sisäiselle huoltoajolle', '020314', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/020314');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (27, 26, 'Yleisen tien suoja-alue', '020322', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/020322');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (28, 27, 'Yleisen tien näkemäalue', '020321', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/020321');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (36, 37, 'Maan alaista tai maan päällistä johtoa, putkea tai linjaa varten varattu alue.', '020101', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/020101');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (6, 5, 'Rakennukseen jätettävä kulkuaukko', '0504', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/0504');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (17, 16, 'Uloke', '0502', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/0502');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (18, 17, 'Valokatteinen tila', '0505', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/0505');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (33, 32, 'Suojeltava alueen osa', '090101', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/090101');
INSERT INTO code_lists.finnish_regulative_text_type VALUES (2, 34, 'Suojeltava rakennus', '090102', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_AK/code/090102');


--
-- Data for Name: finnish_spatial_plan_approved_by; Type: TABLE DATA; Schema: code_lists; Owner: -
--

INSERT INTO code_lists.finnish_spatial_plan_approved_by VALUES (1, 1, 'Kunnanvaltuusto');
INSERT INTO code_lists.finnish_spatial_plan_approved_by VALUES (2, 2, 'Kunnanhallitus');
INSERT INTO code_lists.finnish_spatial_plan_approved_by VALUES (3, 3, 'Jaosto/lautakunta');


--
-- Data for Name: finnish_spatial_plan_level; Type: TABLE DATA; Schema: code_lists; Owner: -
--

INSERT INTO code_lists.finnish_spatial_plan_level VALUES (1, 4, 'Asemakaava (ohjeellinen tonttijako)');
INSERT INTO code_lists.finnish_spatial_plan_level VALUES (2, 5, 'Asemakaava (sitova tonttijako)');


--
-- Data for Name: finnish_spatial_plan_origin; Type: TABLE DATA; Schema: code_lists; Owner: -
--

INSERT INTO code_lists.finnish_spatial_plan_origin VALUES (1, 1, 'Tietomallin mukaan laadittu', '01');
INSERT INTO code_lists.finnish_spatial_plan_origin VALUES (2, 2, 'Kokonaan digitoitu', '02');
INSERT INTO code_lists.finnish_spatial_plan_origin VALUES (3, 3, 'Osittain digitoitu', '03');
INSERT INTO code_lists.finnish_spatial_plan_origin VALUES (4, 4, 'Kaavan rajaus digitoitu', '04');


--
-- Data for Name: finnish_spatial_plan_status; Type: TABLE DATA; Schema: code_lists; Owner: -
--

INSERT INTO code_lists.finnish_spatial_plan_status VALUES (1, 1, 'Kaavoitusaloite', '01');
INSERT INTO code_lists.finnish_spatial_plan_status VALUES (2, 2, 'Vireilletullut', '02');
INSERT INTO code_lists.finnish_spatial_plan_status VALUES (3, 3, 'Valmisteluaineisto', '03');
INSERT INTO code_lists.finnish_spatial_plan_status VALUES (4, 4, 'Kaavaehdotus', '04');
INSERT INTO code_lists.finnish_spatial_plan_status VALUES (5, 5, 'Hyväksytty kaava', '06');
INSERT INTO code_lists.finnish_spatial_plan_status VALUES (6, 6, 'Voimassa', '10');
INSERT INTO code_lists.finnish_spatial_plan_status VALUES (7, 7, 'Kumoutunut', '12');
INSERT INTO code_lists.finnish_spatial_plan_status VALUES (8, 8, 'Rauennut', '13');
INSERT INTO code_lists.finnish_spatial_plan_status VALUES (9, 9, 'Tarkistettu kaavaehdotus', '05');
INSERT INTO code_lists.finnish_spatial_plan_status VALUES (10, 10, 'Oikaisukehotuksen alainen', '07');
INSERT INTO code_lists.finnish_spatial_plan_status VALUES (11, 11, 'Valituksenalainen', '08');
INSERT INTO code_lists.finnish_spatial_plan_status VALUES (12, 12, 'Osittain voimassa', '09');
INSERT INTO code_lists.finnish_spatial_plan_status VALUES (13, 13, 'Kumottu', '11');
INSERT INTO code_lists.finnish_spatial_plan_status VALUES (14, 14, 'Hylätty', '14');


--
-- Data for Name: finnish_spatial_plan_type; Type: TABLE DATA; Schema: code_lists; Owner: -
--

INSERT INTO code_lists.finnish_spatial_plan_type VALUES (1, 1, 'Asemakaava', '31');
INSERT INTO code_lists.finnish_spatial_plan_type VALUES (2, 2, 'Ranta-asemakaava', '33');
INSERT INTO code_lists.finnish_spatial_plan_type VALUES (3, 3, 'Vaiheasemakaava', '32');
INSERT INTO code_lists.finnish_spatial_plan_type VALUES (4, 4, 'Vaiheranta-asemakaava', '34');
INSERT INTO code_lists.finnish_spatial_plan_type VALUES (5, 5, 'Maanalaisten tilojen asemakaava', '35');


--
-- Data for Name: finnish_up_to_dateness; Type: TABLE DATA; Schema: code_lists; Owner: -
--

INSERT INTO code_lists.finnish_up_to_dateness VALUES (1, 1, 'Kaava vanhentunut');
INSERT INTO code_lists.finnish_up_to_dateness VALUES (2, 2, 'Ajanmukainen');
INSERT INTO code_lists.finnish_up_to_dateness VALUES (3, 3, 'Päätös vanhentunut');
INSERT INTO code_lists.finnish_up_to_dateness VALUES (4, 4, 'Arviointi vireillä');


--
-- Data for Name: finnish_vertical_coordinate_reference_system; Type: TABLE DATA; Schema: code_lists; Owner: -
--

INSERT INTO code_lists.finnish_vertical_coordinate_reference_system VALUES (1, 1, 'N2000');
INSERT INTO code_lists.finnish_vertical_coordinate_reference_system VALUES (2, 2, 'N60');
INSERT INTO code_lists.finnish_vertical_coordinate_reference_system VALUES (3, 3, 'N43');
INSERT INTO code_lists.finnish_vertical_coordinate_reference_system VALUES (4, 4, 'NN');


--
-- Data for Name: finnish_zoning_element_type; Type: TABLE DATA; Schema: code_lists; Owner: -
--

INSERT INTO code_lists.finnish_zoning_element_type VALUES (1, 1, 'Pääkäyttötarkoitusalue');
INSERT INTO code_lists.finnish_zoning_element_type VALUES (2, 2, 'Sitova tontti');
INSERT INTO code_lists.finnish_zoning_element_type VALUES (3, 3, 'Ohjeellinen tontti');


--
-- Data for Name: ground_relativeness_kind; Type: TABLE DATA; Schema: code_lists; Owner: -
--

INSERT INTO code_lists.ground_relativeness_kind VALUES (1, '01', 'http://uri.suomi.fi/codelist/rytj/RY_MaanalaisuudenLaji/code/01', 'Maanalainen');
INSERT INTO code_lists.ground_relativeness_kind VALUES (2, '02', 'http://uri.suomi.fi/codelist/rytj/RY_MaanalaisuudenLaji/code/02', 'Maanpäällinen');


--
-- Data for Name: ryhti_language; Type: TABLE DATA; Schema: code_lists; Owner: -
--

INSERT INTO code_lists.ryhti_language (code, name) VALUES ('fin', 'Finnish');
INSERT INTO code_lists.ryhti_language (code, name) VALUES ('swe', 'Swedish');
INSERT INTO code_lists.ryhti_language (code, name) VALUES ('smn', 'Inari Sami');
INSERT INTO code_lists.ryhti_language (code, name) VALUES ('sms', 'Skolt Sami');
INSERT INTO code_lists.ryhti_language (code, name) VALUES ('sme', 'Northern Sami');
INSERT INTO code_lists.ryhti_language (code, name) VALUES ('eng', 'English');


--
-- Data for Name: legal_effectiveness_kind; Type: TABLE DATA; Schema: code_lists; Owner: -
--

INSERT INTO code_lists.legal_effectiveness_kind VALUES (1, '01', 'http://uri.suomi.fi/codelist/rytj/RY_OikeusvaikutteisuudenLaji/code/01', 'Oikeusvaikutteinen', 'Päätetyllä maankäyttöasialla vaikutus, joka luo, muuttaa tai kumoaa oikeuden tai velvollisuuden');
INSERT INTO code_lists.legal_effectiveness_kind VALUES (2, '02', 'http://uri.suomi.fi/codelist/rytj/RY_OikeusvaikutteisuudenLaji/code/02', 'Oikeusvaikutukseton', 'Päätetyllä maankäyttöasialla ei ole vaikutusta, joka luo, muuttaa tai kumoaa oikeuden tai velvollisuuden');


--
-- Data for Name: master_plan_additional_information_kind; Type: TABLE DATA; Schema: code_lists; Owner: -
--

INSERT INTO code_lists.master_plan_additional_information_kind VALUES (1, '01', 'http://uri.suomi.fi/codelist/rytj/RY_LisatiedonLaji_YK/code/01', 'Käyttötarkoituksen osuus kerrosalasta', NULL, 'Kuvaa yhden käyttötarkoituksen osuuden yhden tai usemman rakennuksen sallitusta kerrosalasta');
INSERT INTO code_lists.master_plan_additional_information_kind VALUES (2, '02', 'http://uri.suomi.fi/codelist/rytj/RY_LisatiedonLaji_YK/code/02', 'Käyttötarkoituskohdistus', 'Kohdistaa liittyvän kaavamääryksen koskemaan ainoastaan lisätiedon arvona annettuja käyttötarkoituksia', NULL);
INSERT INTO code_lists.master_plan_additional_information_kind VALUES (3, '03', 'http://uri.suomi.fi/codelist/rytj/RY_LisatiedonLaji_YK/code/03', 'Kohteen geometrian osa', 'Liitetty arvo ilmaisee sen osan liittyvän kohteen geometriasta, jota kaavamääräys koskee.', 'Esim. se osa korttelin tai tontin rajaviivaa, johon rakennukset on rakennettava kiinni, tai osa yhtenä paikkatietokohteena määritellyn liikenneväylän viivaa.');
INSERT INTO code_lists.master_plan_additional_information_kind VALUES (4, '04', 'http://uri.suomi.fi/codelist/rytj/RY_LisatiedonLaji_YK/code/04', 'Poisluettava käyttötarkoitus', NULL, 'Annetut käyttötarkoitukset suljetaan pois kaavamääräyksen kuvaamista sallituista käyttötarkoituksista. Käytetään, mikäli on luontevampaa sulkea tiettyjä yksityiskohtaisia käyttötarkoituksia pois sallittujen joukosta kuin kuvata kaikki sallitut käyttötarkoitukset.');
INSERT INTO code_lists.master_plan_additional_information_kind VALUES (5, '05', 'http://uri.suomi.fi/codelist/rytj/RY_LisatiedonLaji_YK/code/05', 'Kulttuurihistoriallinen merkittävyys', 'Kohteesta muodostettu käsitys, joka perustuu kohteen kulttuurihistoriallisten arvojen ja kulttuuristen merkitysten analysointiin sekä sen suhteuttamiseen muihin vastaaviin kohteisiin', 'Kulttuurihistoriallinen merkittävyys voi olla kansainvälinen, valtakunnallinen, maakunnallinen, paikallinen tai vähäinen.');
INSERT INTO code_lists.master_plan_additional_information_kind VALUES (6, '06', 'http://uri.suomi.fi/codelist/rytj/RY_LisatiedonLaji_YK/code/06', 'Kulttuurihistoriallinen arvotyyppi', 'Kohteelle määritetyt kulttuurihistorialliset ominaisuudet', 'Kulttuurihistoriallisia ominaisuuksia ovat esimerkiksi rakennustaiteellinen, rakennustekninen, arkkitehtoninen ja maisemallinen.');
INSERT INTO code_lists.master_plan_additional_information_kind VALUES (7, '07', 'http://uri.suomi.fi/codelist/rytj/RY_LisatiedonLaji_YK/code/07', 'Kulttuurihistoriallinen tyyppi', 'Kuvaa kohteen kulttuurihistoriallista käyttötarkoitusta', NULL);
INSERT INTO code_lists.master_plan_additional_information_kind VALUES (8, '08', 'http://uri.suomi.fi/codelist/rytj/RY_LisatiedonLaji_YK/code/08', 'Kulttuurihistoriallisen merkittävyyden kriteerit', 'Kuvaa kulttuurihistoriallisen merkittävyyden kriteerejä, joita kohde edustaa.', 'Merkittävyys voi liittyä edustavuuteen, alkuperäisyyteen, harvinaisuuteen, tyypillisyyteen tai historialliseen merkittävyyteen.');
INSERT INTO code_lists.master_plan_additional_information_kind VALUES (9, '09', 'http://uri.suomi.fi/codelist/rytj/RY_LisatiedonLaji_YK/code/09', 'Ympäristö- tai luontoarvon peruste', NULL, NULL);
INSERT INTO code_lists.master_plan_additional_information_kind VALUES (10, '10', 'http://uri.suomi.fi/codelist/rytj/RY_LisatiedonLaji_YK/code/10', 'Ympäristö- tai luontoarvon merkittävyys', NULL, NULL);
INSERT INTO code_lists.master_plan_additional_information_kind VALUES (11, '11', 'http://uri.suomi.fi/codelist/rytj/RY_LisatiedonLaji_YK/code/11', 'Muu lisätiedon laji', NULL, NULL);


--
-- Data for Name: master_plan_envrionmental_change_kind; Type: TABLE DATA; Schema: code_lists; Owner: -
--

INSERT INTO code_lists.master_plan_envrionmental_change_kind VALUES (1, '01', 'http://uri.suomi.fi/codelist/rytj/RY_ymparistomuutoksenLaji_YK/code/01', 'Olemassa oleva', NULL, 'Kaavakohde kuvaa kaavan laatimisen hetkellä olemassa olevaa kohdetta. Tällaisia voivat esimerkiksi olla olemassa olevat (jo rakennetut) rakennuspaikat, väylät tai muut kohteet.', NULL);
INSERT INTO code_lists.master_plan_envrionmental_change_kind VALUES (2, '02', 'http://uri.suomi.fi/codelist/rytj/RY_ymparistomuutoksenLaji_YK/code/02', 'Uusi', NULL, 'Kaavakohde on uusi eli sitä ei vielä ole toteutettu. Koodiarvolla voidaan ilmaista esimerkiksi uusi rakennuspaikka, uusi väylä tai muu kaavakohde.', NULL);


--
-- Data for Name: master_plan_regulation_kind; Type: TABLE DATA; Schema: code_lists; Owner: -
--

INSERT INTO code_lists.master_plan_regulation_kind VALUES (1, '01', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/01', 'Alueen käyttötarkoitus', NULL, NULL, 'Alueen käyttötarkoitus', NULL);
INSERT INTO code_lists.master_plan_regulation_kind VALUES (2, '0101', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0101', 'Asuminen', NULL, NULL, 'Alueen käyttötarkoitus', 'Asuminen');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (3, '010101', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010101', 'Asuinkerrostaloalue', NULL, NULL, 'Alueen käyttötarkoitus', 'Asuminen');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (4, '010102', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010102', 'Asuinpientaloalue', NULL, NULL, 'Alueen käyttötarkoitus', 'Asuminen');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (5, '010103', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010103', 'Rivitalojen ja muiden kytkettyjen asuinrakennusten alue', NULL, NULL, 'Alueen käyttötarkoitus', 'Asuminen');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (6, '010104', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010104', 'Erillispientaloalue', NULL, NULL, 'Alueen käyttötarkoitus', 'Asuminen');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (7, '010105', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010105', 'Asumista palveleva yhteiskäyttöinen alue', NULL, NULL, 'Alueen käyttötarkoitus', 'Asuminen');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (8, '010106', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010106', 'Maatilan talouskeskuksen alue', NULL, NULL, 'Alueen käyttötarkoitus', 'Asuminen');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (9, '010107', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010107', 'Kyläalue', NULL, NULL, 'Alueen käyttötarkoitus', 'Asuminen');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (10, '010108', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010108', 'Erityisryhmien palveluasuminen', NULL, NULL, 'Alueen käyttötarkoitus', 'Asuminen');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (11, '010109', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010109', 'Muu asuminen', NULL, NULL, 'Alueen käyttötarkoitus', 'Asuminen');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (12, '0102', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0102', 'Keskustatoiminnot', NULL, NULL, 'Alueen käyttötarkoitus', 'Keskustatoiminnot');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (13, '010201', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010201', 'Keskustatoimintojen alue', NULL, NULL, 'Alueen käyttötarkoitus', 'Keskustatoiminnot');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (14, '010202', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010202', 'Keskustatoimintojen alakeskus', NULL, NULL, 'Alueen käyttötarkoitus', 'Keskustatoiminnot');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (15, '010203', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010203', 'Muut keskustatoiminnot', NULL, NULL, 'Alueen käyttötarkoitus', 'Keskustatoiminnot');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (16, '0103', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0103', 'Elinkeinot, työ ja tuotanto', NULL, NULL, 'Alueen käyttötarkoitus', 'Elinkeinot, työ ja tuotanto');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (17, '010301', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010301', 'Liikerakennusten alue', NULL, NULL, 'Alueen käyttötarkoitus', 'Elinkeinot, työ ja tuotanto');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (18, '010302', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010302', 'Toimistorakennusten alue', NULL, NULL, 'Alueen käyttötarkoitus', 'Elinkeinot, työ ja tuotanto');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (19, '010303', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010303', 'Toimitilarakennusten alue', NULL, NULL, 'Alueen käyttötarkoitus', 'Elinkeinot, työ ja tuotanto');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (20, '010304', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010304', 'Kaupallisten palveluiden alue', NULL, NULL, 'Alueen käyttötarkoitus', 'Elinkeinot, työ ja tuotanto');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (21, '010305', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010305', 'Vähittäiskaupan suuryksikkö', NULL, NULL, 'Alueen käyttötarkoitus', 'Elinkeinot, työ ja tuotanto');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (22, '010306', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010306', 'Vähittäiskaupan myymäläkeskittymä', NULL, NULL, 'Alueen käyttötarkoitus', 'Elinkeinot, työ ja tuotanto');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (23, '010307', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010307', 'Työpaikka-alue', NULL, NULL, 'Alueen käyttötarkoitus', 'Elinkeinot, työ ja tuotanto');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (24, '010308', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010308', 'Teollisuusalue', NULL, NULL, 'Alueen käyttötarkoitus', 'Elinkeinot, työ ja tuotanto');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (25, '010309', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010309', 'Varastorakennusten alue', NULL, NULL, 'Alueen käyttötarkoitus', 'Elinkeinot, työ ja tuotanto');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (26, '010310', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010310', 'Alue, jolle saa sijoittaa merkittävän, vaarallisia kemikaaleja valmistavan tai varastoivan laitoksen', NULL, NULL, 'Alueen käyttötarkoitus', 'Elinkeinot, työ ja tuotanto');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (27, '010311', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010311', 'Ympäristövaikutuksiltaan merkittävien teollisuustoimintojen alue', NULL, NULL, 'Alueen käyttötarkoitus', 'Elinkeinot, työ ja tuotanto');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (28, '010312', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010312', 'Kiertotalous', NULL, NULL, 'Alueen käyttötarkoitus', 'Elinkeinot, työ ja tuotanto');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (29, '010313', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010313', 'Ympäristöhäiriötä aiheuttava tuotantotoiminta', NULL, NULL, 'Alueen käyttötarkoitus', 'Elinkeinot, työ ja tuotanto');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (30, '010314', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010314', 'Muu elinkeinotoiminta', NULL, NULL, 'Alueen käyttötarkoitus', 'Elinkeinot, työ ja tuotanto');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (31, '0104', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0104', 'Palvelut', NULL, NULL, 'Alueen käyttötarkoitus', 'Palvelut');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (32, '010401', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010401', 'Palvelurakennusten alue', NULL, NULL, 'Alueen käyttötarkoitus', 'Palvelut');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (33, '010402', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010402', 'Lähipalveluiden alue', NULL, NULL, 'Alueen käyttötarkoitus', 'Palvelut');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (34, '010403', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010403', 'Huvi- ja viihdepalveluiden alue', NULL, NULL, 'Alueen käyttötarkoitus', 'Palvelut');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (35, '010404', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010404', 'Julkiset palvelut', NULL, NULL, 'Alueen käyttötarkoitus', 'Palvelut');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (36, '010405', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010405', 'Yleisten rakennusten alue', NULL, NULL, 'Alueen käyttötarkoitus', 'Palvelut');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (37, '010406', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010406', 'Julkisten lähipalveluiden alue', NULL, NULL, 'Alueen käyttötarkoitus', 'Palvelut');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (38, '010407', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010407', 'Hallinto- ja virastorakennusten alue', NULL, NULL, 'Alueen käyttötarkoitus', 'Palvelut');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (39, '010408', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010408', 'Opetustoimintaa palvelevien rakennusten alue', NULL, NULL, 'Alueen käyttötarkoitus', 'Palvelut');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (40, '010409', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010409', 'Sosiaalitointa ja terveydenhuoltoa palvelevien rakennusten alue', NULL, NULL, 'Alueen käyttötarkoitus', 'Palvelut');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (41, '010410', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010410', 'Kulttuuritoimintaa palvelevien rakennusten alue', NULL, NULL, 'Alueen käyttötarkoitus', 'Palvelut');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (42, '010411', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010411', 'Museorakennusten alue', NULL, NULL, 'Alueen käyttötarkoitus', 'Palvelut');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (43, '010412', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010412', 'Kirkkojen ja muiden seurakunnallisten rakennusten alue', NULL, NULL, 'Alueen käyttötarkoitus', 'Palvelut');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (44, '010413', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010413', 'Urheilutoimintaa palvelevien rakennusten alue', NULL, NULL, 'Alueen käyttötarkoitus', 'Palvelut');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (45, '010414', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010414', 'Julkisten palveluiden ja hallinnon alue', NULL, NULL, 'Alueen käyttötarkoitus', 'Palvelut');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (46, '010415', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010415', 'Muut palvelut', NULL, NULL, 'Alueen käyttötarkoitus', 'Palvelut');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (47, '0105', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0105', 'Virkistys', NULL, NULL, 'Alueen käyttötarkoitus', 'Virkistys');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (48, '010501', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010501', 'Virkistysalue', NULL, NULL, 'Alueen käyttötarkoitus', 'Virkistys');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (49, '010502', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010502', 'Puisto', NULL, NULL, 'Alueen käyttötarkoitus', 'Virkistys');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (50, '010503', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010503', 'Lähivirkistysalue', NULL, NULL, 'Alueen käyttötarkoitus', 'Virkistys');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (51, '010504', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010504', 'Leikkipuisto', NULL, NULL, 'Alueen käyttötarkoitus', 'Virkistys');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (52, '010505', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010505', 'Urheilupalvelujen alue', NULL, NULL, 'Alueen käyttötarkoitus', 'Virkistys');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (53, '010506', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010506', 'Retkeily- ja ulkoilualue', NULL, NULL, 'Alueen käyttötarkoitus', 'Virkistys');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (54, '010507', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010507', 'Uimaranta-alue', NULL, NULL, 'Alueen käyttötarkoitus', 'Virkistys');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (55, '010508', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010508', 'Lähimetsä', NULL, NULL, 'Alueen käyttötarkoitus', 'Virkistys');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (56, '010509', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010509', 'Muu virkistysalue', NULL, NULL, 'Alueen käyttötarkoitus', 'Virkistys');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (57, '0106', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0106', 'Loma-asuminen ja matkailu', NULL, NULL, 'Alueen käyttötarkoitus', 'Loma-asuminen ja matkailu');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (58, '010601', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010601', 'Loma-asuntojen alue', NULL, NULL, 'Alueen käyttötarkoitus', 'Loma-asuminen ja matkailu');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (59, '010602', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010602', 'Matkailua palvelevien rakennusten alue', NULL, NULL, 'Alueen käyttötarkoitus', 'Loma-asuminen ja matkailu');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (60, '010603', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010603', 'Leirintäalue', NULL, NULL, 'Alueen käyttötarkoitus', 'Loma-asuminen ja matkailu');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (61, '010604', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010604', 'Asuntovaunualue', NULL, NULL, 'Alueen käyttötarkoitus', 'Loma-asuminen ja matkailu');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (62, '010605', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010605', 'Siirtolapuutarha-/palstaviljelyalue', NULL, NULL, 'Alueen käyttötarkoitus', 'Loma-asuminen ja matkailu');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (63, '010606', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010606', 'Muu loma-asumisen tai matkailun alue', NULL, NULL, 'Alueen käyttötarkoitus', 'Loma-asuminen ja matkailu');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (64, '0107', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0107', 'Liikenne', NULL, NULL, 'Alueen käyttötarkoitus', 'Liikenne');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (65, '010701', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010701', 'Liikennealue', NULL, NULL, 'Alueen käyttötarkoitus', 'Liikenne');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (66, '010702', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010702', 'Yleisen tien alue', NULL, NULL, 'Alueen käyttötarkoitus', 'Liikenne');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (67, '010703', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010703', 'Rautatieliikenteen alue', NULL, NULL, 'Alueen käyttötarkoitus', 'Liikenne');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (68, '010704', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010704', 'Lentoliikenteen alue', NULL, NULL, 'Alueen käyttötarkoitus', 'Liikenne');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (69, '010705', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010705', 'Satama-alue', NULL, NULL, 'Alueen käyttötarkoitus', 'Liikenne');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (70, '010706', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010706', 'Kanava-alue', NULL, NULL, 'Alueen käyttötarkoitus', 'Liikenne');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (71, '010707', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010707', 'Venesatama/venevalkama', NULL, NULL, 'Alueen käyttötarkoitus', 'Liikenne');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (72, '010708', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010708', 'Yleinen pysäköintialue', NULL, NULL, 'Alueen käyttötarkoitus', 'Liikenne');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (73, '010709', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010709', 'Huoltoasema-alue', NULL, NULL, 'Alueen käyttötarkoitus', 'Liikenne');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (74, '010710', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010710', 'Henkilöliikenteen terminaalialue', NULL, NULL, 'Alueen käyttötarkoitus', 'Liikenne');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (75, '010711', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010711', 'Tavaraliikenteen terminaalialue', NULL, NULL, 'Alueen käyttötarkoitus', 'Liikenne');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (76, '010712', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010712', 'Yleisten pysäköintilaitosten alue', NULL, NULL, 'Alueen käyttötarkoitus', 'Liikenne');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (77, '010713', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010713', 'Autopaikkojen alue', NULL, NULL, 'Alueen käyttötarkoitus', 'Liikenne');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (78, '010714', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010714', 'Katualue', NULL, NULL, 'Alueen käyttötarkoitus', 'Liikenne');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (79, '010715', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010715', 'Muu liikennealue', NULL, NULL, 'Alueen käyttötarkoitus', 'Liikenne');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (80, '0108', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0108', 'Erityisalueet', NULL, NULL, 'Alueen käyttötarkoitus', 'Erityisalueet');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (81, '010801', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010801', 'Erityisalue', NULL, NULL, 'Alueen käyttötarkoitus', 'Erityisalueet');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (82, '010802', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010802', 'Yhdyskuntateknisen huollon alue', NULL, NULL, 'Alueen käyttötarkoitus', 'Erityisalueet');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (83, '010803', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010803', 'Energiahuollon alue', NULL, NULL, 'Alueen käyttötarkoitus', 'Erityisalueet');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (84, '010804', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010804', 'Jätteenkäsittelyalue', NULL, NULL, 'Alueen käyttötarkoitus', 'Erityisalueet');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (85, '010805', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010805', 'Maa-ainesten ottoalue', NULL, NULL, 'Alueen käyttötarkoitus', 'Erityisalueet');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (86, '010806', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010806', 'Kaivosalue', NULL, NULL, 'Alueen käyttötarkoitus', 'Erityisalueet');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (87, '010807', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010807', 'Mastoalue', NULL, NULL, 'Alueen käyttötarkoitus', 'Erityisalueet');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (88, '010808', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010808', 'Ampumarata-alue', NULL, NULL, 'Alueen käyttötarkoitus', 'Erityisalueet');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (89, '010809', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010809', 'Puolustusvoimien alue', NULL, NULL, 'Alueen käyttötarkoitus', 'Erityisalueet');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (90, '010810', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010810', 'Hautausmaa-alue', NULL, NULL, 'Alueen käyttötarkoitus', 'Erityisalueet');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (91, '010811', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010811', 'Suojaviheralue', NULL, NULL, 'Alueen käyttötarkoitus', 'Erityisalueet');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (92, '010812', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010812', 'Tuulivoimaloiden alue', NULL, NULL, 'Alueen käyttötarkoitus', 'Erityisalueet');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (93, '010813', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010813', 'Moottorirata', NULL, NULL, 'Alueen käyttötarkoitus', 'Erityisalueet');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (94, '010814', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010814', 'Maa-ainesten vastaanotto- tai läjitysalue', NULL, NULL, 'Alueen käyttötarkoitus', 'Erityisalueet');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (95, '010815', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010815', 'Vankila-alue', NULL, NULL, 'Alueen käyttötarkoitus', 'Erityisalueet');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (96, '010816', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010816', 'Muu erityisalue', NULL, NULL, 'Alueen käyttötarkoitus', 'Erityisalueet');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (97, '0109', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0109', 'Suojelu', NULL, NULL, 'Alueen käyttötarkoitus', 'Suojelu');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (98, '010901', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010901', 'Suojelualue', NULL, NULL, 'Alueen käyttötarkoitus', 'Suojelu');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (99, '010902', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010902', 'Luonnonsuojelualue', NULL, NULL, 'Alueen käyttötarkoitus', 'Suojelu');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (100, '010903', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010903', 'Muinaismuistoalue', NULL, NULL, 'Alueen käyttötarkoitus', 'Suojelu');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (101, '010904', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010904', 'Rakennuslainsäädännön nojalla suojeltava alue', NULL, NULL, 'Alueen käyttötarkoitus', 'Suojelu');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (102, '010905', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010905', 'Rakennussuojelulakien nojalla suojeltu alue', NULL, NULL, 'Alueen käyttötarkoitus', 'Suojelu');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (103, '010906', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010906', 'Muu suojelualue', NULL, NULL, 'Alueen käyttötarkoitus', 'Suojelu');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (104, '0110', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0110', 'Maa- ja metsätalous', NULL, NULL, 'Alueen käyttötarkoitus', 'Maa- ja metsätalous');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (105, '011001', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/011001', 'Maa- ja metsätalousalue', NULL, NULL, 'Alueen käyttötarkoitus', 'Maa- ja metsätalous');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (106, '011002', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/011002', 'Maatalousalue', NULL, NULL, 'Alueen käyttötarkoitus', 'Maa- ja metsätalous');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (107, '011003', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/011003', 'Kotieläintalouden suuryksikön alue', NULL, NULL, 'Alueen käyttötarkoitus', 'Maa- ja metsätalous');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (108, '011004', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/011004', 'Puutarha- ja kasvihuonealue', NULL, NULL, 'Alueen käyttötarkoitus', 'Maa- ja metsätalous');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (109, '011005', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/011005', 'Maisemallisesti arvokas peltoalue', NULL, NULL, 'Alueen käyttötarkoitus', 'Maa- ja metsätalous');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (110, '011006', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/011006', 'Poronhoitovaltainen maa- ja metsätalousalue', NULL, NULL, 'Alueen käyttötarkoitus', 'Maa- ja metsätalous');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (111, '011007', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/011007', 'Muu maa- ja metsätalousalue', NULL, NULL, 'Alueen käyttötarkoitus', 'Maa- ja metsätalous');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (112, '0111', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0111', 'Vesialueet', NULL, NULL, 'Alueen käyttötarkoitus', 'Vesialueet');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (113, '011101', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/011101', 'Vesialue', NULL, NULL, 'Alueen käyttötarkoitus', 'Vesialueet');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (114, '011102', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/011102', 'Muu vesialue', NULL, NULL, 'Alueen käyttötarkoitus', 'Vesialueet');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (115, '02', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/02', 'Rakentaminen', NULL, NULL, 'Rakentaminen', NULL);
INSERT INTO code_lists.master_plan_regulation_kind VALUES (116, '0201', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0201', 'Rakennusala', NULL, NULL, 'Rakentaminen', 'Rakennusala');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (117, '0202', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0202', 'Rakennuspaikka', NULL, NULL, 'Rakentaminen', 'Rakennuspaikka');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (118, '0203', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0203', 'Asunnon rakennuspaikka', NULL, NULL, 'Rakentaminen', 'Asunnon rakennuspaikka');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (119, '0204', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0204', 'Loma-asunnon rakennuspaikka', NULL, NULL, 'Rakentaminen', 'Loma-asunnon rakennuspaikka');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (120, '0205', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0205', 'Saunan rakennuspaikka', NULL, NULL, 'Rakentaminen', 'Saunan rakennuspaikka');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (121, '0206', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0206', 'Maatalouden talouskeskuksen rakennuspaikka', NULL, NULL, 'Rakentaminen', 'Maatalouden talouskeskuksen rakennuspaikka');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (122, '0207', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0207', 'Sallittu kokonaiskerrosala', 'Kokonaiskerrosalan suhde korttelin pinta-alaan', NULL, 'Rakentaminen', 'Sallittu kokonaiskerrosala');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (123, '0208', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0208', 'Aluetehokkuus', NULL, NULL, 'Rakentaminen', 'Aluetehokkuus');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (124, '0209', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0209', 'Korttelitehokkuus', 'Kokonaiskerrosalan suhde tontin/rakennuspaikan pinta-alaan', NULL, 'Rakentaminen', 'Korttelitehokkuus');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (125, '0210', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0210', 'Tonttitehokkuus', NULL, NULL, 'Rakentaminen', 'Tonttitehokkuus');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (126, '0211', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0211', 'Sallittujen rakennuspaikkojen lukumäärä', NULL, NULL, 'Rakentaminen', 'Sallittujen rakennuspaikkojen lukumäärä');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (127, '0212', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0212', 'Rakennuspaikan vähimmäiskoko', NULL, NULL, 'Rakentaminen', 'Rakennuspaikan vähimmäiskoko');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (128, '0213', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0213', 'Sallittu tuulivoimaloiden määrä', NULL, NULL, 'Rakentaminen', 'Sallittu tuulivoimaloiden määrä');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (129, '0214', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0214', 'Vähittäiskaupan suuryksikön sallittu kerrosala', NULL, NULL, 'Rakentaminen', 'Vähittäiskaupan suuryksikön sallittu kerrosala');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (130, '0215', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0215', 'Vähittäiskaupan myymäläkeskittymän sallittu kerrosala', NULL, NULL, 'Rakentaminen', 'Vähittäiskaupan myymäläkeskittymän sallittu kerrosala');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (131, '03', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/03', 'Liikenne', NULL, NULL, 'Liikenne', NULL);
INSERT INTO code_lists.master_plan_regulation_kind VALUES (132, '0301', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0301', 'Alueverkon pyöräilyreitti', NULL, NULL, 'Liikenne', 'Alueverkon pyöräilyreitti');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (133, '0302', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0302', 'Eritasoliittymä', NULL, NULL, 'Liikenne', 'Eritasoliittymä');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (134, '0303', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0303', 'Eritasoristeys ilman liittymää', NULL, NULL, 'Liikenne', 'Eritasoristeys ilman liittymää');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (135, '0304', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0304', 'Joukkoliikenteen runkoyhteys', NULL, NULL, 'Liikenne', 'Joukkoliikenteen runkoyhteys');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (136, '0305', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0305', 'Kaksiajoratainen päätie/-katu', NULL, NULL, 'Liikenne', 'Kaksiajoratainen päätie/-katu');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (137, '0306', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0306', 'Kevyen liikenteen reitti', NULL, NULL, 'Liikenne', 'Kevyen liikenteen reitti');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (138, '0307', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0307', 'Laivaväylä', NULL, NULL, 'Liikenne', 'Laivaväylä');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (139, '0308', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0308', 'Liikennetunneli', NULL, NULL, 'Liikenne', 'Liikennetunneli');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (140, '0309', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0309', 'Liittymä', NULL, NULL, 'Liikenne', 'Liittymä');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (141, '0310', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0310', 'Linja-autoasema/julkisen liikenteen vaihtopaikka/matkakeskus', NULL, NULL, 'Liikenne', 'Linja-autoasema/julkisen liikenteen vaihtopaikka/matkakeskus');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (142, '0311', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0311', 'Metroasema', NULL, NULL, 'Liikenne', 'Metroasema');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (143, '0312', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0312', 'Metrolinja', NULL, NULL, 'Liikenne', 'Metrolinja');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (144, '0313', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0313', 'Moottori- tai moottoriliikennetie', NULL, NULL, 'Liikenne', 'Moottori- tai moottoriliikennetie');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (145, '0314', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0314', 'Moottorikelkkailureitti', NULL, NULL, 'Liikenne', 'Moottorikelkkailureitti');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (146, '0315', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0315', 'Pysäkki/seisake', NULL, NULL, 'Liikenne', 'Pysäkki/seisake');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (147, '0316', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0316', 'Pyöräilyn pää-/runkoreitti', NULL, NULL, 'Liikenne', 'Pyöräilyn pää-/runkoreitti');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (148, '0317', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0317', 'Päärata', NULL, NULL, 'Liikenne', 'Päärata');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (149, '0318', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0318', 'Raitiotie/Pikaraitiotie', NULL, NULL, 'Liikenne', 'Raitiotie/Pikaraitiotie');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (150, '0319', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0319', 'Ratsastusreitti', NULL, NULL, 'Liikenne', 'Ratsastusreitti');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (151, '0320', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0320', 'Rautatieasema', NULL, NULL, 'Liikenne', 'Rautatieasema');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (152, '0321', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0321', 'Seututie/pääkatu', NULL, NULL, 'Liikenne', 'Seututie/pääkatu');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (153, '0322', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0322', 'Seutuverkon pyöräilyreitti', NULL, NULL, 'Liikenne', 'Seutuverkon pyöräilyreitti');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (154, '0323', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0323', 'Suuntaisliittymä', NULL, NULL, 'Liikenne', 'Suuntaisliittymä');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (155, '0324', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0324', 'Ulkoilu- tai virkistysreitti', NULL, NULL, 'Liikenne', 'Ulkoilu- tai virkistysreitti');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (156, '0325', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0325', 'Valtatie/kantatie', NULL, NULL, 'Liikenne', 'Valtatie/kantatie');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (157, '0326', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0326', 'Varattu joukkoliikenteelle', NULL, NULL, 'Liikenne', 'Varattu joukkoliikenteelle');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (158, '0327', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0327', 'Varikko', NULL, NULL, 'Liikenne', 'Varikko');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (159, '0328', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0328', 'Venesatama/venevalkama', NULL, NULL, 'Liikenne', 'Venesatama/venevalkama');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (160, '0329', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0329', 'Veneväylä', NULL, NULL, 'Liikenne', 'Veneväylä');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (161, '0330', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0330', 'Yhdysrata/sivurata/kaupunkirata', NULL, NULL, 'Liikenne', 'Yhdysrata/sivurata/kaupunkirata');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (162, '0331', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0331', 'Yhdystie/kokoojakatu', NULL, NULL, 'Liikenne', 'Yhdystie/kokoojakatu');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (163, '0334', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0334', 'Liityntäpysäköinti', NULL, NULL, 'Liikenne', 'Liityntäpysäköinti');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (164, '0335', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0335', 'Muu liikenteeseen liittyvä määräys', NULL, NULL, 'Liikenne', 'Muu liikenteeseen liittyvä määräys');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (165, '04', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/04', 'Kehittämisperiaatteet', NULL, NULL, 'Kehittämisperiaatteet', NULL);
INSERT INTO code_lists.master_plan_regulation_kind VALUES (166, '0401', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0401', 'Yhdyskuntarakenteen laajenemissuunta', NULL, NULL, 'Kehittämisperiaatteet', 'Yhdyskuntarakenteen laajenemissuunta');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (167, '0402', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0402', 'Yhdyskuntarakenteen mahdollinen laajenemisalue', NULL, NULL, 'Kehittämisperiaatteet', 'Yhdyskuntarakenteen mahdollinen laajenemisalue');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (168, '0403', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0403', 'Alueen eheyttämis- tai tiivistämistarve', NULL, NULL, 'Kehittämisperiaatteet', 'Alueen eheyttämis- tai tiivistämistarve');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (169, '0404', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0404', 'Ohjeellinen tai vaihtoehtoinen tielinjaus', NULL, NULL, 'Kehittämisperiaatteet', 'Ohjeellinen tai vaihtoehtoinen tielinjaus');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (170, '0405', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0405', 'Tieliikenteen yhteystarve', NULL, NULL, 'Kehittämisperiaatteet', 'Tieliikenteen yhteystarve');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (171, '0406', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0406', 'Joukkoliikenteen kehittämiskäytävä tai yhteystarve', NULL, NULL, 'Kehittämisperiaatteet', 'Joukkoliikenteen kehittämiskäytävä tai yhteystarve');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (172, '0407', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0407', 'Kevyen liikenteen yhteystarve', NULL, NULL, 'Kehittämisperiaatteet', 'Kevyen liikenteen yhteystarve');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (173, '0408', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0408', 'Johdon, putken tai linjan yhteystarve', NULL, NULL, 'Kehittämisperiaatteet', 'Johdon, putken tai linjan yhteystarve');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (174, '0409', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0409', 'Viheryhteystarve', NULL, NULL, 'Kehittämisperiaatteet', 'Viheryhteystarve');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (175, '0410', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0410', 'Virkistyksen yhteystarve', NULL, NULL, 'Kehittämisperiaatteet', 'Virkistyksen yhteystarve');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (176, '0411', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0411', 'Julkisen virkistyksen kehittämistarve', NULL, NULL, 'Kehittämisperiaatteet', 'Julkisen virkistyksen kehittämistarve');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (177, '0412', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0412', 'Kävely-ympäristön kehittämistarve', NULL, NULL, 'Kehittämisperiaatteet', 'Kävely-ympäristön kehittämistarve');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (178, '0413', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0413', 'Kaupunkikuvallinen kehittämistarve', NULL, NULL, 'Kehittämisperiaatteet', 'Kaupunkikuvallinen kehittämistarve');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (179, '0414', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0414', 'Meluntorjuntatarve', NULL, NULL, 'Kehittämisperiaatteet', 'Meluntorjuntatarve');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (180, '0415', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0415', 'Ympäristö- tai maisemavaurion korjaustarve', NULL, NULL, 'Kehittämisperiaatteet', 'Ympäristö- tai maisemavaurion korjaustarve');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (181, '0416', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0416', 'Terveyshaitan poistamistarve', NULL, NULL, 'Kehittämisperiaatteet', 'Terveyshaitan poistamistarve');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (182, '0418', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0418', 'Uusi tai olennaisesti muuttuva alue', NULL, NULL, 'Kehittämisperiaatteet', 'Uusi tai olennaisesti muuttuva alue');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (183, '0419', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0419', 'Pienin toimenpitein kehitettävä alue', NULL, NULL, 'Kehittämisperiaatteet', 'Pienin toimenpitein kehitettävä alue');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (184, '0421', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0421', 'Muu kehittämisperiaate', NULL, NULL, 'Kehittämisperiaatteet', 'Muu kehittämisperiaate');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (185, '05', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/05', 'Rajoitukset', NULL, NULL, 'Rajoitukset', NULL);
INSERT INTO code_lists.master_plan_regulation_kind VALUES (186, '0501', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0501', 'Rakentamisrajoitus', NULL, NULL, 'Rajoitukset', 'Rakentamisrajoitus');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (187, '0502', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0502', 'Määräaikainen rakentamisrajoitus', NULL, NULL, 'Rajoitukset', 'Määräaikainen rakentamisrajoitus');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (188, '0503', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0503', 'Toimenpiderajoitus', NULL, NULL, 'Rajoitukset', 'Toimenpiderajoitus');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (189, '0504', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0504', 'Rakennuksen purkamisrajoitus', NULL, NULL, 'Rajoitukset', 'Rakennuksen purkamisrajoitus');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (190, '06', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/06', 'Alueen osan erityisominaisuudet', NULL, NULL, 'Alueen osan erityisominaisuudet', NULL);
INSERT INTO code_lists.master_plan_regulation_kind VALUES (191, '0601', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0601', 'Erityisharkinta-alue', NULL, NULL, 'Alueen osan erityisominaisuudet', 'Erityisharkinta-alue');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (192, '0602', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0602', 'Kehittämisalue', NULL, NULL, 'Alueen osan erityisominaisuudet', 'Kehittämisalue');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (193, '0603', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0603', 'Vaara-alue', NULL, NULL, 'Alueen osan erityisominaisuudet', 'Vaara-alue');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (194, '0604', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0604', 'Suojavyöhyke', NULL, NULL, 'Alueen osan erityisominaisuudet', 'Suojavyöhyke');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (195, '0605', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0605', 'Suunnittelutarvealue', NULL, NULL, 'Alueen osan erityisominaisuudet', 'Suunnittelutarvealue');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (196, '0606', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0606', 'Reservialue', NULL, NULL, 'Alueen osan erityisominaisuudet', 'Reservialue');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (197, '0607', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0607', 'Muu alueen osan erityisominaisuus', NULL, NULL, 'Alueen osan erityisominaisuudet', 'Muu alueen osan erityisominaisuus');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (198, '07', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/07', 'Ympäristöarvojen vaaliminen', NULL, NULL, 'Ympäristöarvojen vaaliminen', NULL);
INSERT INTO code_lists.master_plan_regulation_kind VALUES (199, '0701', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0701', 'Kulttuurihistoriallisesti arvokas alue tai kohde', NULL, NULL, 'Ympäristöarvojen vaaliminen', 'Kulttuurihistoriallisesti arvokas alue tai kohde');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (200, '070101', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/070101', 'Suojeltava alue tai alueen osa', NULL, NULL, 'Ympäristöarvojen vaaliminen', 'Kulttuurihistoriallisesti arvokas alue tai kohde');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (201, '070102', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/070102', 'Suojeltava rakennus', NULL, NULL, 'Ympäristöarvojen vaaliminen', 'Kulttuurihistoriallisesti arvokas alue tai kohde');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (202, '070103', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/070103', 'Suojeltava rakennelma', NULL, NULL, 'Ympäristöarvojen vaaliminen', 'Kulttuurihistoriallisesti arvokas alue tai kohde');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (203, '070104', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/070104', 'Kiinteä suojeltava kohde', NULL, NULL, 'Ympäristöarvojen vaaliminen', 'Kulttuurihistoriallisesti arvokas alue tai kohde');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (204, '070105', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/070105', 'Kiinteä muinaisjäännös', 'Alue tai alueen osa, jolla sijaitsee muinaismuistolailla rauhoitettu kiinteä muinaisjäännös', NULL, 'Ympäristöarvojen vaaliminen', 'Kulttuurihistoriallisesti arvokas alue tai kohde');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (205, '0702', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0702', 'Luontoarvoiltaan arvokas alue tai kohde', NULL, NULL, 'Ympäristöarvojen vaaliminen', 'Luontoarvoiltaan arvokas alue tai kohde');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (206, '070201', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/070201', 'Suojeltu puu', NULL, NULL, 'Ympäristöarvojen vaaliminen', 'Luontoarvoiltaan arvokas alue tai kohde');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (207, '070202', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/070202', 'Säilytettävä puu', NULL, NULL, 'Ympäristöarvojen vaaliminen', 'Luontoarvoiltaan arvokas alue tai kohde');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (208, '070203', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/070203', 'Suojeltava vesistö tai vesialue', NULL, NULL, 'Ympäristöarvojen vaaliminen', 'Luontoarvoiltaan arvokas alue tai kohde');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (209, '070204', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/070204', 'Luonnon monimuotoisuuden kannalta tärkeä alue', NULL, NULL, 'Ympäristöarvojen vaaliminen', 'Luontoarvoiltaan arvokas alue tai kohde');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (210, '070205', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/070205', 'Ekologinen yhteys', NULL, NULL, 'Ympäristöarvojen vaaliminen', 'Luontoarvoiltaan arvokas alue tai kohde');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (211, '0703', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0703', 'Alue, jolla ympäristö säilytetään', NULL, NULL, 'Ympäristöarvojen vaaliminen', 'Alue, jolla ympäristö säilytetään');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (212, '0704', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0704', 'Alue, jolla on erityistä ulkoilun ohjaamistarvetta', NULL, NULL, 'Ympäristöarvojen vaaliminen', 'Alue, jolla on erityistä ulkoilun ohjaamistarvetta');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (213, '08', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/08', 'Yleismääräykset', NULL, NULL, 'Yleismääräykset', NULL);
INSERT INTO code_lists.master_plan_regulation_kind VALUES (214, '0801', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0801', 'Yleismääräys', NULL, NULL, 'Yleismääräykset', 'Yleismääräys');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (215, '0802', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0802', 'Yleiskaavan käyttö rakennusluvan myöntämisen perusteena', NULL, NULL, 'Yleismääräykset', 'Yleiskaavan käyttö rakennusluvan myöntämisen perusteena');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (216, '09', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/09', 'Yhdyskuntatekninen huolto', NULL, NULL, 'Yhdyskuntatekninen huolto', NULL);
INSERT INTO code_lists.master_plan_regulation_kind VALUES (217, '0901', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0901', 'Johto, putki tai linja', 'Yhdyskuntatekniikkaa palveleva johto, putki tai linja, joka voi sijaita maan päällä tai alla. Tällaisia ovat esimerkiksi sähkölinjat, vesijohdot, maakaasun runkoputket ja jätevesiviemärit.', NULL, 'Yhdyskuntatekninen huolto', 'Johto, putki tai linja');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (218, '0902', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0902', 'Sähkölinja', NULL, NULL, 'Yhdyskuntatekninen huolto', 'Sähkölinja');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (219, '0903', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0903', 'Kaasulinja', NULL, NULL, 'Yhdyskuntatekninen huolto', 'Kaasulinja');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (220, '0904', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0904', 'Vesi- tai jätevesitunneli', NULL, NULL, 'Yhdyskuntatekninen huolto', 'Vesi- tai jätevesitunneli');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (221, '0905', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0905', 'Vesijohto tai siirtoviemäri', NULL, NULL, 'Yhdyskuntatekninen huolto', 'Vesijohto tai siirtoviemäri');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (222, '0906', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0906', 'Kaukolämpölinja', NULL, NULL, 'Yhdyskuntatekninen huolto', 'Kaukolämpölinja');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (223, '0907', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0907', 'Kaukokylmälinja', NULL, NULL, 'Yhdyskuntatekninen huolto', 'Kaukokylmälinja');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (224, '0908', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0908', 'Hulevesien hallinta-alue', NULL, NULL, 'Yhdyskuntatekninen huolto', 'Hulevesien hallinta-alue');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (225, '0909', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0909', 'Hulevesien hallinnan kannalta merkittävä alue', NULL, NULL, 'Yhdyskuntatekninen huolto', 'Hulevesien hallinnan kannalta merkittävä alue');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (226, '0910', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0910', 'Hulevesien purkuoja/-reitti', NULL, NULL, 'Yhdyskuntatekninen huolto', 'Hulevesien purkuoja/-reitti');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (227, '0911', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0911', 'Hulevesien viivytysalue', 'Hulevesien käsittelytapaa ohjaava määräys', NULL, 'Yhdyskuntatekninen huolto', 'Hulevesien viivytysalue');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (228, '0912', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0912', 'Hulevesien käsittelytapa', NULL, NULL, 'Yhdyskuntatekninen huolto', 'Hulevesien käsittelytapa');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (229, '0913', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0913', 'Pohjavedenottamo', NULL, NULL, 'Yhdyskuntatekninen huolto', 'Pohjavedenottamo');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (230, '0914', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0914', 'Pohjavedenottamon lähisuoja-alue', NULL, NULL, 'Yhdyskuntatekninen huolto', 'Pohjavedenottamon lähisuoja-alue');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (231, '0915', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/0915', 'Muu yhdyskuntatekniseen huoltoon liittyvä määräys', NULL, NULL, 'Yhdyskuntatekninen huolto', 'Muu yhdyskuntatekniseen huoltoon liittyvä määräys');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (232, '010', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/010', 'Ympäristön ja terveyden suojelu', NULL, NULL, 'Ympäristön ja terveyden suojelu', NULL);
INSERT INTO code_lists.master_plan_regulation_kind VALUES (233, '01001', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/01001', 'Pilaantunut maa-alue', NULL, 'Alue, jolla on maaperän haitta-aineita', 'Ympäristön ja terveyden suojelu', 'Pilaantunut maa-alue');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (234, '01002', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/01002', 'Tulvavaara-alue', 'Alue, joka on tulvavaarassa', 'Tulvavaara voi liittyä meritulvaan tai hulevesien aiheuttamaan tulvimiseen', 'Ympäristön ja terveyden suojelu', 'Tulvavaara-alue');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (235, '01003', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/01003', 'Meritulvavaara-alue', NULL, NULL, 'Ympäristön ja terveyden suojelu', 'Meritulvavaara-alue');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (236, '01004', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/01004', 'Hulevesitulvavaara-alue', NULL, NULL, 'Ympäristön ja terveyden suojelu', 'Hulevesitulvavaara-alue');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (237, '01005', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/01005', 'Valuma-alue', NULL, NULL, 'Ympäristön ja terveyden suojelu', 'Valuma-alue');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (238, '01006', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/01006', 'Virkistyskohde', NULL, NULL, 'Kehittämisperiaatteet', 'Virkistyskohde');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (239, '01007', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/01007', 'Melualue', NULL, NULL, 'Ympäristön ja terveyden suojelu', 'Melualue');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (240, '01008', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/01008', 'Pohjavesialue', NULL, NULL, 'Ympäristön ja terveyden suojelu', 'Pohjavesialue');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (241, '01009', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/01009', 'Pohjaveden muodostumisalue', NULL, NULL, 'Ympäristön ja terveyden suojelu', 'Pohjaveden muodostumisalue');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (242, '01010', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/01010', 'Arvokas harjualue tai muu geologinen muodostuma', NULL, NULL, 'Ympäristön ja terveyden suojelu', 'Arvokas harjualue tai muu geologinen muodostuma');
INSERT INTO code_lists.master_plan_regulation_kind VALUES (243, '01011', 'http://uri.suomi.fi/codelist/rytj/RY_KaavamaaraysLaji_YK/code/01011', 'Muu ympäristönsuojeluun liittyvä määräys', NULL, NULL, 'Ympäristön ja terveyden suojelu', 'Muu ympäristönsuojeluun liittyvä määräys');


--
-- Data for Name: master_plan_theme; Type: TABLE DATA; Schema: code_lists; Owner: -
--

INSERT INTO code_lists.master_plan_theme VALUES (1, '01', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavoitusteema_YK/code/01', 'Yhdyskuntarakenne', 'Samhällsstruktur', 'Kaupunkiseudun, kunnan tai kunnan osan keskeisten toimintojen sijoittuminen ja keskinäiset suhteet', NULL);
INSERT INTO code_lists.master_plan_theme VALUES (2, '02', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavoitusteema_YK/code/02', 'Liikenneverkko', 'Trafiknät', 'Eri liikennemuotoja palvelevat väylät ja näiden solmukohdat', NULL);
INSERT INTO code_lists.master_plan_theme VALUES (3, '03', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavoitusteema_YK/code/03', 'Luontoarvot', NULL, 'Arvo, joka perustuu bio- ja geodiversiteettiin jollakin tietyllä alueella', NULL);
INSERT INTO code_lists.master_plan_theme VALUES (4, '04', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavoitusteema_YK/code/04', 'Viherverkko', 'Grönnät', 'Viheralueiden ja niitä yhdistävien viheryhteyksien muodostama kokonaisuus', NULL);
INSERT INTO code_lists.master_plan_theme VALUES (5, '05', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavoitusteema_YK/code/05', 'Virkistysalueet', NULL, 'Virkistykseen ja ulkoiluun varatut alueet', NULL);
INSERT INTO code_lists.master_plan_theme VALUES (6, '06', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavoitusteema_YK/code/06', 'Kulttuuriympäristö', 'Kulturmiljö', 'Kulttuurin vaiheita sekä ihmisen ja luonnon vuorovaikutusta ilmentävä ympäristö', NULL);
INSERT INTO code_lists.master_plan_theme VALUES (7, '07', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavoitusteema_YK/code/07', 'Yhdyskuntatekninen huolto', NULL, 'Yhdyskunnan yleistä tarvetta palvelevat verkostot ja rakenteet', NULL);
INSERT INTO code_lists.master_plan_theme VALUES (8, '08', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavoitusteema_YK/code/08', 'Vesitalous', NULL, 'Toiminta, jolla pyritään vesivarojen tarkoituksenmukaiseen hyväksikäyttöön ja suojeluun', NULL);
INSERT INTO code_lists.master_plan_theme VALUES (9, '09', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavoitusteema_YK/code/09', 'Muu kaavoitusteema', NULL, NULL, NULL);


--
-- Data for Name: spatial_plan_kind; Type: TABLE DATA; Schema: code_lists; Owner: -
--

INSERT INTO code_lists.spatial_plan_kind VALUES (1, 'Yleiskaava', '21', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavalaji/code/21', 'Yleiskaava', 'Generalplan', 'Koko kuntaa tai kunnan osa-aluetta koskeva rajattuja teemoja käsittelevä yleiskaava.', NULL);
INSERT INTO code_lists.spatial_plan_kind VALUES (2, 'Yleiskaava', '22', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavalaji/code/22', 'Vaiheyleiskaava', 'Etappgeneralplan', 'Koko kuntaa tai kunnan osa-aluetta koskeva rajattuja teemoja käsittelevä yleiskaava.', NULL);
INSERT INTO code_lists.spatial_plan_kind VALUES (3, 'Yleiskaava', '23', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavalaji/code/23', 'Osayleiskaava', 'Delgeneralplan', 'Kunnan osa-aluetta koskeva yleiskaava.', NULL);
INSERT INTO code_lists.spatial_plan_kind VALUES (4, 'Yleiskaava', '24', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavalaji/code/24', 'Kuntien yhteinen yleiskaava', 'Gemensam generalplan', 'Kahden tai useamman kunnan aluetta tai osa-aluetta koskeva yleiskaava (MRL 46 §) tai vaiheyleiskaava.', NULL);
INSERT INTO code_lists.spatial_plan_kind VALUES (5, 'Yleiskaava', '25', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavalaji/code/25', 'Oikeusvaikutukseton yleiskaava', 'Generalplan utan rättsverkningar', 'Koko kuntaa tai kunnan osa-aluetta koskeva yleiskaava, jolla ei ole maankäyttö- ja rakennuslaissa tarkoitettuja oikeusvaikutuksia (MRL 45§).', NULL);
INSERT INTO code_lists.spatial_plan_kind VALUES (6, 'Yleiskaava', '26', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavalaji/code/26', 'Maanalainen yleiskaava', NULL, NULL, NULL);
INSERT INTO code_lists.spatial_plan_kind VALUES (7, 'Asemakaava', '31', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavalaji/code/31', 'Asemakaava', 'Detaljplan', 'MRL 50 § mukaan laadittu yksityiskohtainen asemakaava tai asemakaavan muutos.', NULL);
INSERT INTO code_lists.spatial_plan_kind VALUES (8, 'Asemakaava', '32', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavalaji/code/32', 'Vaiheasemakaava', 'Etappdetaljplan', 'MRL 50 § mukaan laadittu rajattuja teemoja käsittelevä asemakaava tai asemakaavan muutos,', NULL);
INSERT INTO code_lists.spatial_plan_kind VALUES (9, 'Asemakaava', '33', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavalaji/code/33', 'Ranta-asemakaava', 'Stranddetaljplan', 'Asemakaava, joka laaditaan pääasiassa loma-asutuksen järjestämiseksi', NULL);
INSERT INTO code_lists.spatial_plan_kind VALUES (10, 'Asemakaava', '34', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavalaji/code/34', 'Vaiheranta-asemakaava', 'Etappsranddetaljplan', 'Rajattuja teemoja käsittelevä asemakaava, joka laaditaan pääasiassa loma-asutuksen järjestämiseksi.', NULL);
INSERT INTO code_lists.spatial_plan_kind VALUES (11, 'Asemakaava', '35', 'http://uri.suomi.fi/codelist/rytj/RY_Kaavalaji/code/35', 'Maanalaisten tilojen asemakaava', 'Underjordisk detaljplan', NULL, NULL);


--
-- Data for Name: spatial_plan_lifecycle_status; Type: TABLE DATA; Schema: code_lists; Owner: -
--

INSERT INTO code_lists.spatial_plan_lifecycle_status VALUES (1, '01', 'http://uri.suomi.fi/codelist/rytj/RY_KaavanElinkaaritila/code/01', 'Kaavoitusaloite', NULL, 'Kuntaan saapunut kaavoitusaloite', NULL, NULL, NULL);
INSERT INTO code_lists.spatial_plan_lifecycle_status VALUES (2, '02', 'http://uri.suomi.fi/codelist/rytj/RY_KaavanElinkaaritila/code/02', 'Vireilletullut', NULL, 'Viranomainen on ottanut kaava-asian käsiteltäväksi', NULL, NULL, NULL);
INSERT INTO code_lists.spatial_plan_lifecycle_status VALUES (3, '03', 'http://uri.suomi.fi/codelist/rytj/RY_KaavanElinkaaritila/code/03', 'Valmistelu', 'beredningsmaterial', NULL, NULL, 'Kaavaprosessin vaihe, jossa laaditaan kaavan valmisteluaineisto. Valmisteluaineisto koostuu kaavaehdotuksen tai muun päätösehdotuksen laatimista varten laadituista ja kerätyistä aineistoista.', NULL);
INSERT INTO code_lists.spatial_plan_lifecycle_status VALUES (4, '04', 'http://uri.suomi.fi/codelist/rytj/RY_KaavanElinkaaritila/code/04', 'Kaavaehdotus', 'planförslag', 'Julkisesti nähtäville asetettava ehdotus kaavaksi', NULL, NULL, NULL);
INSERT INTO code_lists.spatial_plan_lifecycle_status VALUES (5, '05', 'http://uri.suomi.fi/codelist/rytj/RY_KaavanElinkaaritila/code/05', 'Tarkistettu kaavaehdotus', NULL, NULL, NULL, NULL, NULL);
INSERT INTO code_lists.spatial_plan_lifecycle_status VALUES (6, '06', 'http://uri.suomi.fi/codelist/rytj/RY_KaavanElinkaaritila/code/06', 'Hyväksytty kaava', NULL, 'Toimivaltainen viranomainen on hyväksynyt kaavaehdotuksen', NULL, NULL, NULL);
INSERT INTO code_lists.spatial_plan_lifecycle_status VALUES (7, '07', 'http://uri.suomi.fi/codelist/rytj/RY_KaavanElinkaaritila/code/07', 'Oikaisukehotuksen alainen', NULL, 'Kaavasta on jätetty oikaisukehotus', NULL, NULL, NULL);
INSERT INTO code_lists.spatial_plan_lifecycle_status VALUES (8, '08', 'http://uri.suomi.fi/codelist/rytj/RY_KaavanElinkaaritila/code/08', 'Valituksen alainen', NULL, 'Kaavasta on tehty valitus', NULL, NULL, NULL);
INSERT INTO code_lists.spatial_plan_lifecycle_status VALUES (9, '09', 'http://uri.suomi.fi/codelist/rytj/RY_KaavanElinkaaritila/code/09', 'Oikaisukehotuksen alainen ja valituksen alainen', NULL, 'Kaavasta on jätetty oikaisukehotus ja siitä on tehty valitus', NULL, NULL, NULL);
INSERT INTO code_lists.spatial_plan_lifecycle_status VALUES (10, '10', 'http://uri.suomi.fi/codelist/rytj/RY_KaavanElinkaaritila/code/10', 'Osittain voimassa', NULL, 'Kaava on kuulutettu osittain voimaan', NULL, NULL, NULL);
INSERT INTO code_lists.spatial_plan_lifecycle_status VALUES (11, '11', 'http://uri.suomi.fi/codelist/rytj/RY_KaavanElinkaaritila/code/11', 'Voimassa', NULL, 'Kaava on saanut lainvoiman', NULL, NULL, NULL);
INSERT INTO code_lists.spatial_plan_lifecycle_status VALUES (12, '12', 'http://uri.suomi.fi/codelist/rytj/RY_KaavanElinkaaritila/code/12', 'Kumottu', NULL, 'Kaava on kumottu', NULL, NULL, NULL);
INSERT INTO code_lists.spatial_plan_lifecycle_status VALUES (13, '13', 'http://uri.suomi.fi/codelist/rytj/RY_KaavanElinkaaritila/code/13', 'Kumoutunut', NULL, 'Kaava on kumoutunut kaavamuutoksen myötä', NULL, NULL, NULL);
INSERT INTO code_lists.spatial_plan_lifecycle_status VALUES (14, '14', 'http://uri.suomi.fi/codelist/rytj/RY_KaavanElinkaaritila/code/14', 'Rauennut', NULL, 'Kaava on rauennut kaavoitusprosessin keskeyttämisen myötä', NULL, NULL, NULL);
INSERT INTO code_lists.spatial_plan_lifecycle_status VALUES (15, '15', 'http://uri.suomi.fi/codelist/rytj/RY_KaavanElinkaaritila/code/15', 'Hylätty', NULL, NULL, NULL, NULL, NULL);


--
-- Data for Name: validity_type; Type: TABLE DATA; Schema: code_lists; Owner: -
--

INSERT INTO code_lists.validity_type VALUES (1, 1, 'Täysin voimassa');
INSERT INTO code_lists.validity_type VALUES (2, 2, 'Osittain voimassa');
INSERT INTO code_lists.validity_type VALUES (3, 3, 'Ei voimassa');
INSERT INTO code_lists.validity_type VALUES (4, 4, 'Keskeneräinen');

--
-- Data for Name: data_type; Type: TABLE DATA; Schema: code_lists; Owner: -
--

INSERT INTO code_lists.data_type (value, description) VALUES (1, 'LocalizedText');
INSERT INTO code_lists.data_type (value, description) VALUES (2, 'Text');
INSERT INTO code_lists.data_type (value, description) VALUES (3, 'Numeric');
INSERT INTO code_lists.data_type (value, description) VALUES (4, 'NumericRange');
INSERT INTO code_lists.data_type (value, description) VALUES (5, 'PositiveNumeric');
INSERT INTO code_lists.data_type (value, description) VALUES (6, 'PositiveNumericRange');
INSERT INTO code_lists.data_type (value, description) VALUES (7, 'Decimal');
INSERT INTO code_lists.data_type (value, description) VALUES (8, 'DecimalRange');
INSERT INTO code_lists.data_type (value, description) VALUES (9, 'PositiveDecimal');
INSERT INTO code_lists.data_type (value, description) VALUES (10, 'PositiveDecimalRange');
INSERT INTO code_lists.data_type (value, description) VALUES (11, 'Code');
INSERT INTO code_lists.data_type (value, description) VALUES (12, 'Identifier');
INSERT INTO code_lists.data_type (value, description) VALUES (13, 'SpotElevation');


--
-- Data for Name: plan_interaction_event_type; Type: TABLE DATA; Schema: code_lists; Owner: -
--

INSERT INTO code_lists.plan_interaction_event_type VALUES (1, '01', 'http://uri.suomi.fi/codelist/rytj/RY_KaavanVuorovaikutustapahtumanLaji/code/01', 'Nähtävilläolo', 'Tillgänglighet', 'Presentation to the public');
INSERT INTO code_lists.plan_interaction_event_type VALUES (2, '02', 'http://uri.suomi.fi/codelist/rytj/RY_KaavanVuorovaikutustapahtumanLaji/code/02', 'Lausuntopyyntö', 'Begäran om utlåtande', 'Request for opinions');
INSERT INTO code_lists.plan_interaction_event_type VALUES (3, '03', 'http://uri.suomi.fi/codelist/rytj/RY_KaavanVuorovaikutustapahtumanLaji/code/03', 'Vuorovaikutustilaisuus', 'Interaktiv tillställning', 'Interaction event');
INSERT INTO code_lists.plan_interaction_event_type VALUES (4, '04', 'http://uri.suomi.fi/codelist/rytj/RY_KaavanVuorovaikutustapahtumanLaji/code/04', 'Tiedonkeruu', 'Informationsinsamling', 'Data collection');
INSERT INTO code_lists.plan_interaction_event_type VALUES (5, '05', 'http://uri.suomi.fi/codelist/rytj/RY_KaavanVuorovaikutustapahtumanLaji/code/05', 'Neuvottelu', 'Förhandling', 'Negotiation');
INSERT INTO code_lists.plan_interaction_event_type VALUES (6, '06', 'http://uri.suomi.fi/codelist/rytj/RY_KaavanVuorovaikutustapahtumanLaji/code/06', 'Sähköinen osallistuminen', 'Deltagande elektroniskt', 'Electronic participation');
INSERT INTO code_lists.plan_interaction_event_type VALUES (7, '07', 'http://uri.suomi.fi/codelist/rytj/RY_KaavanVuorovaikutustapahtumanLaji/code/07', 'Muutoksenhaku', 'Ändringsansökan', 'Appeal');
INSERT INTO code_lists.plan_interaction_event_type VALUES (8, '08', 'http://uri.suomi.fi/codelist/rytj/RY_KaavanVuorovaikutustapahtumanLaji/code/08', 'Muu vuorovaikutustapahtuma', 'Annan interaktiv händelse', 'Other interaction event');


--
-- Data for Name: plan_handling_event_type; Type: TABLE DATA; Schema: code_lists; Owner: -
--

INSERT INTO code_lists.plan_handling_event_type VALUES (1, '01', 'http://uri.suomi.fi/codelist/rytj/kaavakastap/code/01', 'Kaavan ajanmukaisuuden arviointi', 'Bedömning av planens tidsenlighet', 'Assessment of plan timeliness');
INSERT INTO code_lists.plan_handling_event_type VALUES (2, '02', 'http://uri.suomi.fi/codelist/rytj/kaavakastap/code/02', 'Kaavoitusaloitteen hyväksyminen', 'Godkännande av planläggningsinitiativ', 'Approval of planning initiative');
INSERT INTO code_lists.plan_handling_event_type VALUES (3, '03', 'http://uri.suomi.fi/codelist/rytj/kaavakastap/code/03', 'Kaavoituksen käynnistäminen', 'Inledande av planläggning', 'Initiation of planning');
INSERT INTO code_lists.plan_handling_event_type VALUES (4, '04', 'http://uri.suomi.fi/codelist/rytj/kaavakastap/code/04', 'Kaavan vireilletulo', 'Planen blir anhängig', 'Announcement of pending plan');
INSERT INTO code_lists.plan_handling_event_type VALUES (5, '05', 'http://uri.suomi.fi/codelist/rytj/kaavakastap/code/05', 'Osallistumis- ja arviointisuunnitelman nähtäville asettaminen', 'Planen för deltagande och bedömning läggs fram offentligt', 'Presenting the participation and assessment scheme to the public');
INSERT INTO code_lists.plan_handling_event_type VALUES (6, '06', 'http://uri.suomi.fi/codelist/rytj/kaavakastap/code/06', 'Kaavan valmisteluaineiston nähtäville asettaminen', 'Offentligt framläggande av beredningsmaterialet som rör planen', 'Presenting the plan preparation material to the public');
INSERT INTO code_lists.plan_handling_event_type VALUES (7, '07', 'http://uri.suomi.fi/codelist/rytj/kaavakastap/code/07', 'Kaavaehdotuksen nähtäville asettaminen', 'Offentligt framläggande av planförslaget', 'Presenting the draft proposal to the public');
INSERT INTO code_lists.plan_handling_event_type VALUES (8, '08', 'http://uri.suomi.fi/codelist/rytj/kaavakastap/code/08', 'Viranomaislausuntokierros', 'Remissbehandling i myndigheter', 'Request for opinions from authorities');
INSERT INTO code_lists.plan_handling_event_type VALUES (9, '09', 'http://uri.suomi.fi/codelist/rytj/kaavakastap/code/09', 'Muutetun kaavaehdotuksen nähtäville asettaminen', 'Offentligt framläggande av det ändrade planförslaget', 'Presenting the amended plan proposal to the public');
INSERT INTO code_lists.plan_handling_event_type VALUES (10, '10', 'http://uri.suomi.fi/codelist/rytj/kaavakastap/code/10', 'Kaavaprosessin keskeyttäminen', 'Avbrytande av planprocessen', 'Interruption of plan process');
INSERT INTO code_lists.plan_handling_event_type VALUES (11, '11', 'http://uri.suomi.fi/codelist/rytj/kaavakastap/code/11', 'Kaavan hyväksyminen', 'Godkännande av planen', 'Plan approval');
INSERT INTO code_lists.plan_handling_event_type VALUES (12, '12', 'http://uri.suomi.fi/codelist/rytj/kaavakastap/code/12', 'Kaavan hyväksyminen oikaisukehotuksen johdosta', 'Godkännande av planen med anledning av rättelseuppmaning', 'Plan approval due to rectification reminder');
INSERT INTO code_lists.plan_handling_event_type VALUES (13, '13', 'http://uri.suomi.fi/codelist/rytj/kaavakastap/code/13', 'Kaavan tai sen osan kuuluttaminen voimaan ennen kaavan lainvoimaisuutta', 'Kungörelse av planen eller en del av den innan planen vunnit laga kraft', 'Announcement of a plan or part thereof as valid before legal validity');
INSERT INTO code_lists.plan_handling_event_type VALUES (14, '14', 'http://uri.suomi.fi/codelist/rytj/kaavakastap/code/14', 'Kaavan kumoaminen', 'Upphävande av planen', 'Plan repeal');
INSERT INTO code_lists.plan_handling_event_type VALUES (15, '15', 'http://uri.suomi.fi/codelist/rytj/kaavakastap/code/15', 'Valituksen vastineiden hyväksyminen', 'Godkännande av besvärsgenmälen', 'Approval of the rejoinders to the appeal');
INSERT INTO code_lists.plan_handling_event_type VALUES (16, '16', 'http://uri.suomi.fi/codelist/rytj/kaavakastap/code/16', 'Kaava kuulutetaan voimaan', 'Planen kungörs', 'Plan notified as valid');
INSERT INTO code_lists.plan_handling_event_type VALUES (17, '17', 'http://uri.suomi.fi/codelist/rytj/kaavakastap/code/17', 'Kaavan palauttaminen valmisteluun', 'Returnering av planen för beredning', 'Returning plan to preparation');
INSERT INTO code_lists.plan_handling_event_type VALUES (18, '18', 'http://uri.suomi.fi/codelist/rytj/kaavakastap/code/18', 'Toimeenpano keskeytetty', 'Verkställigheten är avbruten', 'Implementation suspended');
INSERT INTO code_lists.plan_handling_event_type VALUES (19, '19', 'http://uri.suomi.fi/codelist/rytj/kaavakastap/code/19', 'Muutoksenhaun yhteydessä viranomaisen tekemät muutokset', 'Ändringar som myndigheten gjort i samband med ändringsansökan', 'Changes made by authority in connection with appeal');


--
-- Data for Name: plan_decision_name; Type: TABLE DATA; Schema: code_lists; Owner: -
--

INSERT INTO code_lists.plan_decision_name (
    id, 
    codevalue, 
    uri, 
    preflabel_en, 
    preflabel_fi, 
    preflabel_sv, 
    description_en, 
    description_fi, 
    description_sv
) VALUES 
(1, '01', 'http://uri.suomi.fi/codelist/rytj/kaavpaatnimi/code/01', 'Assessment of plan timeliness', 'Kaavan ajanmukaisuuden arviointi', 'Bedömning av planens tidsenlighet', 'The timeliness of the plan is assessed.', 'Kaavan ajanmukaisuus arvioidaan.', 'Planens tidsenlighet bedöms.'),
(2, '02', 'http://uri.suomi.fi/codelist/rytj/kaavpaatnimi/code/02', 'Approval of planning initiative', 'Kaavoitusaloitteen hyväksyminen', 'Godkännande av planläggningsinitiativ', 'Decision on the approval of a planning initiative.', 'Päätös kaavoitusaloitteen hyväksymisestä.', 'Beslut om godkännande av planläggningsinitiativ.'),
(3, '03', 'http://uri.suomi.fi/codelist/rytj/kaavpaatnimi/code/03', 'Initiation of planning', 'Kaavoituksen käynnistäminen', 'Inledande av planläggning', 'A decision on the initiation of planning and the allocation of resources to prepare a specific plan.', 'Päätös kaavoituksen käynnistämisestä ja varataan resurssit tietyn kaavan laatimiseen.', 'Beslut om inledande av planläggning och resurser reserveras för att utarbeta en viss plan.'),
(4, '04', 'http://uri.suomi.fi/codelist/rytj/kaavpaatnimi/code/04', 'Presenting the participation and assessment scheme to the public', 'Osallistumis- ja arviointisuunnitelman nähtäville asettaminen', 'Planen för deltagande och bedömning läggs fram offentligt', 'Decision to present the plan’s participation and assessment scheme to the public.', 'Päätös kaavan osallistumis- ja arviointisuunnitelman nähtäville asettamisesta.', 'Beslut om offentligt framläggande av planen för deltagande och bedömning.'),
(5, '05', 'http://uri.suomi.fi/codelist/rytj/kaavpaatnimi/code/05', 'Presenting the plan preparation material to the public', 'Kaavan valmisteluaineiston nähtäville asettaminen', 'Offentligt framläggande av beredningsmaterialet som rör planen', 'Decision on presenting the plan to the public.', 'Päätös kaavan valmisteluaineiston nähtäville asettamisesta.', 'Beslut om offentligt framläggande av beredningsmaterialet som rör planen.'),
(6, '06', 'http://uri.suomi.fi/codelist/rytj/kaavpaatnimi/code/06', 'Presenting the draft plan to the public', 'Kaavaluonnoksen nähtäville asettaminen', 'Offentligt framläggande av utkastet till plan', 'Decision to present the draft plan to the public.', 'Päätös kaavaluonnoksen nähtäville asettamisesta.', 'Beslut om offentligt framläggande av utkastet till plan.'),
(7, '07', 'http://uri.suomi.fi/codelist/rytj/kaavpaatnimi/code/07', 'Sending a plan proposal out for opinions', 'Kaavaehdotuksen asettaminen lausunnoille', 'Utsändning av planförslaget på remiss', 'Opinions on the regional plan proposal are requested before its presentation to the public (section 13 of the Land Use and Building Decree).', 'Maakuntakaavaehdotuksesta pyydetään lausunnot ennen nähtäville asettamista (MRA 13 §).', 'Utlåtande om förslaget till landskapsplan ska begäras före framläggandet (13 § i markanvändnings- och byggförordningen).'),
(8, '08', 'http://uri.suomi.fi/codelist/rytj/kaavpaatnimi/code/08', 'Presenting the draft proposal to the public', 'Kaavaehdotuksen nähtäville asettaminen', 'Offentligt framläggande av planförslaget', 'Decision to present the plan proposal to the public.', 'Päätös kaavaehdotuksen asettamisesta julkisesti nähtäville.', 'Beslut om offentligt framläggande av planförslaget.'),
(9, '09', 'http://uri.suomi.fi/codelist/rytj/kaavpaatnimi/code/09', 'Presenting the amended plan proposal to the public', 'Muutetun kaavaehdotuksen nähtäville asettaminen', 'Offentligt framläggande av det ändrade planförslaget', 'Decision to present the plan proposal to the public again due to essential changes made to it.', 'Päätös kaavaehdotuksen asettamisesta uudelleen julkisesti nähtäville siihen tehtyjen olennaisten muutosten johdosta.', 'Beslut om att på nytt lägga fram planförslaget offentligt med anledning av de väsentliga ändringar som gjorts i det.'),
(10, '10', 'http://uri.suomi.fi/codelist/rytj/kaavpaatnimi/code/10', 'Interruption of plan process', 'Kaavaprosessin keskeyttäminen', 'Avbrytande av planprocessen', 'Decision to suspend the preparation of the plan before submitting it to the approval process.', 'Päätös kaavan valmistelun keskeyttämisestä ennen kaavan viemistä hyväksymiskäsittelyyn.', 'Beslut om att avbryta beredningen av planen innan planen behandlas vidare för godkännande.'),
(11, '11A', 'http://uri.suomi.fi/codelist/rytj/kaavpaatnimi/code/11A', 'Plan approval', 'Kaavan hyväksyminen', 'Godkännande av planen', 'The council or committee makes the decision to approve the plan.', 'Valtuusto tai lautakunta tekee päätöksen kaavan hyväksymisestä.', 'Fullmäktige eller nämnden beslutar om godkännande av planen.'),
(12, '11B', 'http://uri.suomi.fi/codelist/rytj/kaavpaatnimi/code/11B', 'Approval of plan and binding plot division', 'Kaavan ja sitovan tonttijaon hyväksyminen', 'Godkännande av planen och den bindande tomtindelningen', 'When a binding plot division is approved as part of a local detailed plan.', 'Kun sitova tonttijako hyväksytään osana asemakaavaa.', 'Då den bindande tomtindelningen godkänns som en del av detaljplanen.'),
(13, '12', 'http://uri.suomi.fi/codelist/rytj/kaavpaatnimi/code/12', 'Plan approval due to rectification reminder', 'Kaavan hyväksyminen oikaisukehotuksen johdosta', 'Godkännande av planen med anledning av rättelseuppmaning', 'The decision to approve the plan is reconsidered due to a rectification reminder.', 'Kaavan hyväksymispäätös käsitellään uudelleen oikaisukehotuksen johdosta.', 'Beslutet om godkännande av planen behandlas på nytt med anledning av en rättelseuppmaning.'),
(14, '13', 'http://uri.suomi.fi/codelist/rytj/kaavpaatnimi/code/13', 'Announcement of a plan or part thereof as valid before legal validity', 'Kaavan tai sen osan kuuluttaminen voimaan ennen kaavan lainvoimaisuutta', 'Kungörelse av planen eller en del av den innan planen vunnit laga kraft', 'The decision to announce a plan or part thereof as valid before its legal validity.', 'Päätös kuuluttaa kaava tai sen osa voimaan ennen kaavan lainvoimaisuutta.', 'Beslut att kungöra planen eller en del av den innan planen vunnit laga kraft.'),
(15, '14', 'http://uri.suomi.fi/codelist/rytj/kaavpaatnimi/code/14', 'Plan repeal', 'Kaavan kumoaminen', 'Upphävande av planen', 'The council or committee makes the decision to repeal the plan.', 'Valtuusto tai lautakunta tekee päätöksen kaavan kumoamisesta.', 'Fullmäktige eller nämnden beslutar om upphävande av planen.'),
(16, '15', 'http://uri.suomi.fi/codelist/rytj/kaavpaatnimi/code/15', 'Approval of the rejoinders to the appeal', 'Valituksen vastineiden hyväksyminen', 'Godkännande av besvärsgenmälen', 'The municipality or the regional council approves the rejoinders to be submitted to the administrative court or the Supreme Administrative Court.', 'Kunta tai maakunnan liitto hyväksyy hallinto-oikeudelle tai korkeimmalle hallinto-oikeudelle annettavat vastineet.', 'Kommunen eller landskapsförbundet godkänner de genmälen som ges till förvaltningsdomstolen eller högsta förvaltningsdomstolen.'),
(17, '16', 'http://uri.suomi.fi/codelist/rytj/kaavpaatnimi/code/16', 'Returning plan to preparation', 'Kaavan palauttaminen valmisteluun', 'Returnering av planen för beredning', 'The decision to return to a plan that has already been presented to the public and approved to the preparation stage after a plan proposal or an appeal.', 'Päätös nähtävillä olleen kaavaehdotuksen tai muutoksenhaun myötä jo hyväksytyn kaavan palauttamisesta valmisteluvaiheeseen.', 'Beslut om att ett planförslag som varit framlagt eller en plan som redan godkänts genom ändringsansökan returneras till beredningsskedet.');


--
-- Data for Name: plan_decision_maker_type; Type: TABLE DATA; Schema: code_lists; Owner: -
--

INSERT INTO code_lists.plan_decision_maker_type (
    id, 
    codevalue, 
    uri, 
    preflabel_fi, 
    preflabel_sv, 
    preflabel_en, 
    description_fi, 
    description_sv, 
    description_en
) VALUES 
(1, '01', 'http://uri.suomi.fi/codelist/rytj/PaatoksenTekija/code/01', 'Viranhaltija', 'Tjänsteinnehavare', 'Office-holder', 'Viranhaltija, jolle kunnan päätöksenteko-oikeus on delegoitu.', 'Tjänsteinnehavare som kommunens beslutsrätt har delegerats till.', 'The office-holder to whom the municipality’s decision-making rights have been delegated.'),
(2, '02', 'http://uri.suomi.fi/codelist/rytj/PaatoksenTekija/code/02', 'Monijäseninen päätöksentekoelin', 'Beslutsorgan med flera medlemmar', 'Multi-member decision-making body', 'Monijäseninen päätöksentekoelin, esimerkiksi lautakunta tai jaosto.', 'Beslutsorgan med flera medlemmar, till exempel nämnd eller sektion.', 'A multi-member decision-making body, such as a committee or division.');


--
-- Name: bindingness_kind_id_seq; Type: SEQUENCE SET; Schema: code_lists; Owner: -
--

SELECT pg_catalog.setval('code_lists.bindingness_kind_id_seq', 2, true);


--
-- Name: describing_line_type_identifier_seq; Type: SEQUENCE SET; Schema: code_lists; Owner: -
--

SELECT pg_catalog.setval('code_lists.describing_line_type_identifier_seq', 5, true);


--
-- Name: detail_plan_addition_information_kind_id_seq; Type: SEQUENCE SET; Schema: code_lists; Owner: -
--

SELECT pg_catalog.setval('code_lists.detail_plan_addition_information_kind_id_seq', 13, true);


--
-- Name: detail_plan_regulation_kind_id_seq; Type: SEQUENCE SET; Schema: code_lists; Owner: -
--

SELECT pg_catalog.setval('code_lists.detail_plan_regulation_kind_id_seq', 257, true);


--
-- Name: detail_plan_theme_id_seq; Type: SEQUENCE SET; Schema: code_lists; Owner: -
--

SELECT pg_catalog.setval('code_lists.detail_plan_theme_id_seq', 11, true);


--
-- Name: digital_origin_kind_id_seq; Type: SEQUENCE SET; Schema: code_lists; Owner: -
--

SELECT pg_catalog.setval('code_lists.digital_origin_kind_id_seq', 4, true);


--
-- Name: document_kind_id_seq; Type: SEQUENCE SET; Schema: code_lists; Owner: -
--

SELECT pg_catalog.setval('code_lists.document_kind_id_seq', 23, true);


--
-- Name: finnish_area_type_identifier_seq; Type: SEQUENCE SET; Schema: code_lists; Owner: -
--

SELECT pg_catalog.setval('code_lists.finnish_area_type_identifier_seq', 3, true);


--
-- Name: finnish_document_role_identifier_seq; Type: SEQUENCE SET; Schema: code_lists; Owner: -
--

SELECT pg_catalog.setval('code_lists.finnish_document_role_identifier_seq', 4, true);


--
-- Name: finnish_document_type_identifier_seq; Type: SEQUENCE SET; Schema: code_lists; Owner: -
--

SELECT pg_catalog.setval('code_lists.finnish_document_type_identifier_seq', 1, false);


--
-- Name: finnish_informative_feature_type_identifier_seq; Type: SEQUENCE SET; Schema: code_lists; Owner: -
--

SELECT pg_catalog.setval('code_lists.finnish_informative_feature_type_identifier_seq', 12, true);


--
-- Name: finnish_land_use_kind_identifier_seq; Type: SEQUENCE SET; Schema: code_lists; Owner: -
--

SELECT pg_catalog.setval('code_lists.finnish_land_use_kind_identifier_seq', 121, true);


--
-- Name: finnish_language_identifier_seq; Type: SEQUENCE SET; Schema: code_lists; Owner: -
--

SELECT pg_catalog.setval('code_lists.finnish_language_identifier_seq', 1, false);


--
-- Name: finnish_municipalities_id_seq; Type: SEQUENCE SET; Schema: code_lists; Owner: -
--

SELECT pg_catalog.setval('code_lists.finnish_municipalities_id_seq', 309, true);


--
-- Name: finnish_municipality_codes_identifier_seq; Type: SEQUENCE SET; Schema: code_lists; Owner: -
--

SELECT pg_catalog.setval('code_lists.finnish_municipality_codes_identifier_seq', 1, false);


--
-- Name: finnish_numeric_value_identifier_seq; Type: SEQUENCE SET; Schema: code_lists; Owner: -
--

SELECT pg_catalog.setval('code_lists.finnish_numeric_value_identifier_seq', 38, true);


--
-- Name: finnish_ordinance_process_identifier_seq; Type: SEQUENCE SET; Schema: code_lists; Owner: -
--

SELECT pg_catalog.setval('code_lists.finnish_ordinance_process_identifier_seq', 4, true);


--
-- Name: finnish_ordinance_process_step_identifier_seq; Type: SEQUENCE SET; Schema: code_lists; Owner: -
--

SELECT pg_catalog.setval('code_lists.finnish_ordinance_process_step_identifier_seq', 7, true);


--
-- Name: finnish_plan_description_identifier_seq; Type: SEQUENCE SET; Schema: code_lists; Owner: -
--

SELECT pg_catalog.setval('code_lists.finnish_plan_description_identifier_seq', 23, true);


--
-- Name: finnish_planned_space_type_identifier_seq; Type: SEQUENCE SET; Schema: code_lists; Owner: -
--

SELECT pg_catalog.setval('code_lists.finnish_planned_space_type_identifier_seq', 2, true);


--
-- Name: finnish_planning_detail_line_type_identifier_seq; Type: SEQUENCE SET; Schema: code_lists; Owner: -
--

SELECT pg_catalog.setval('code_lists.finnish_planning_detail_line_type_identifier_seq', 7, true);


--
-- Name: finnish_planning_detail_point_type_identifier_seq; Type: SEQUENCE SET; Schema: code_lists; Owner: -
--

SELECT pg_catalog.setval('code_lists.finnish_planning_detail_point_type_identifier_seq', 5, true);


--
-- Name: finnish_regulative_text_type_identifier_seq; Type: SEQUENCE SET; Schema: code_lists; Owner: -
--

SELECT pg_catalog.setval('code_lists.finnish_regulative_text_type_identifier_seq', 113, true);


--
-- Name: finnish_spatial_plan_approved_by_identifier_seq; Type: SEQUENCE SET; Schema: code_lists; Owner: -
--

SELECT pg_catalog.setval('code_lists.finnish_spatial_plan_approved_by_identifier_seq', 3, true);


--
-- Name: finnish_spatial_plan_level_identifier_seq; Type: SEQUENCE SET; Schema: code_lists; Owner: -
--

SELECT pg_catalog.setval('code_lists.finnish_spatial_plan_level_identifier_seq', 2, true);


--
-- Name: finnish_spatial_plan_origin_identifier_seq; Type: SEQUENCE SET; Schema: code_lists; Owner: -
--

SELECT pg_catalog.setval('code_lists.finnish_spatial_plan_origin_identifier_seq', 4, true);


--
-- Name: finnish_spatial_plan_status_identifier_seq; Type: SEQUENCE SET; Schema: code_lists; Owner: -
--

SELECT pg_catalog.setval('code_lists.finnish_spatial_plan_status_identifier_seq', 14, true);


--
-- Name: finnish_spatial_plan_type_identifier_seq; Type: SEQUENCE SET; Schema: code_lists; Owner: -
--

SELECT pg_catalog.setval('code_lists.finnish_spatial_plan_type_identifier_seq', 5, true);


--
-- Name: finnish_up_to_dateness_identifier_seq; Type: SEQUENCE SET; Schema: code_lists; Owner: -
--

SELECT pg_catalog.setval('code_lists.finnish_up_to_dateness_identifier_seq', 4, true);


--
-- Name: finnish_vertical_coordinate_reference_system_identifier_seq; Type: SEQUENCE SET; Schema: code_lists; Owner: -
--

SELECT pg_catalog.setval('code_lists.finnish_vertical_coordinate_reference_system_identifier_seq', 4, true);


--
-- Name: finnish_zoning_element_type_identifier_seq; Type: SEQUENCE SET; Schema: code_lists; Owner: -
--

SELECT pg_catalog.setval('code_lists.finnish_zoning_element_type_identifier_seq', 3, true);


--
-- Name: ground_relativeness_kind_id_seq; Type: SEQUENCE SET; Schema: code_lists; Owner: -
--

SELECT pg_catalog.setval('code_lists.ground_relativeness_kind_id_seq', 2, true);


--
-- Name: legal_effectiveness_kind_id_seq; Type: SEQUENCE SET; Schema: code_lists; Owner: -
--

SELECT pg_catalog.setval('code_lists.legal_effectiveness_kind_id_seq', 2, true);


--
-- Name: master_plan_additional_information_kind_id_seq; Type: SEQUENCE SET; Schema: code_lists; Owner: -
--

SELECT pg_catalog.setval('code_lists.master_plan_additional_information_kind_id_seq', 11, true);


--
-- Name: master_plan_envrionmental_change_kind_id_seq; Type: SEQUENCE SET; Schema: code_lists; Owner: -
--

SELECT pg_catalog.setval('code_lists.master_plan_envrionmental_change_kind_id_seq', 2, true);


--
-- Name: master_plan_regulation_kind_id_seq; Type: SEQUENCE SET; Schema: code_lists; Owner: -
--

SELECT pg_catalog.setval('code_lists.master_plan_regulation_kind_id_seq', 243, true);


--
-- Name: master_plan_theme_id_seq; Type: SEQUENCE SET; Schema: code_lists; Owner: -
--

SELECT pg_catalog.setval('code_lists.master_plan_theme_id_seq', 9, true);


--
-- Name: spatial_plan_kind_id_seq; Type: SEQUENCE SET; Schema: code_lists; Owner: -
--

SELECT pg_catalog.setval('code_lists.spatial_plan_kind_id_seq', 11, true);


--
-- Name: spatial_plan_lifecycle_status_id_seq; Type: SEQUENCE SET; Schema: code_lists; Owner: -
--

SELECT pg_catalog.setval('code_lists.spatial_plan_lifecycle_status_id_seq', 15, true);


--
-- Name: validity_type_identifier_seq; Type: SEQUENCE SET; Schema: code_lists; Owner: -
--

SELECT pg_catalog.setval('code_lists.validity_type_identifier_seq', 1, false);


--
-- Name: plan_interaction_event_type_id_seq; Type: SEQUENCE SET; Schema: code_lists; Owner: -
--

SELECT pg_catalog.setval('code_lists.plan_interaction_event_type_id_seq', 8, true);


--
-- Name: plan_handling_event_type_id_seq; Type: SEQUENCE SET; Schema: code_lists; Owner: -
--

SELECT pg_catalog.setval('code_lists.plan_handling_event_type_id_seq', 19, true);


--
-- Name: plan_decision_name_id_seq; Type: SEQUENCE SET; Schema: code_lists; Owner: -
--

SELECT pg_catalog.setval('code_lists.plan_decision_name_id_seq', 17, true);


--
-- Name: plan_decision_maker_type_id_seq; Type: SEQUENCE SET; Schema: code_lists; Owner: -
--

SELECT pg_catalog.setval('code_lists.plan_decision_maker_type_id_seq', 2, true);


--
-- Name: bindingness_kind bindingness_kind_codevalue_key; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.bindingness_kind
    ADD CONSTRAINT bindingness_kind_codevalue_key UNIQUE (codevalue);


--
-- Name: bindingness_kind bindingness_kind_pkey; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.bindingness_kind
    ADD CONSTRAINT bindingness_kind_pkey PRIMARY KEY (id);


--
-- Name: bindingness_kind bindingness_kind_uri_key; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.bindingness_kind
    ADD CONSTRAINT bindingness_kind_uri_key UNIQUE (uri);


--
-- Name: describing_line_type describing_line_type_pkey; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.describing_line_type
    ADD CONSTRAINT describing_line_type_pkey PRIMARY KEY (identifier);


--
-- Name: describing_line_type describing_line_type_value_key; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.describing_line_type
    ADD CONSTRAINT describing_line_type_value_key UNIQUE (value);


--
-- Name: detail_plan_addition_information_kind detail_plan_addition_information_kind_codevalue_key; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.detail_plan_addition_information_kind
    ADD CONSTRAINT detail_plan_addition_information_kind_codevalue_key UNIQUE (codevalue);


--
-- Name: detail_plan_addition_information_kind detail_plan_addition_information_kind_pkey; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.detail_plan_addition_information_kind
    ADD CONSTRAINT detail_plan_addition_information_kind_pkey PRIMARY KEY (id);


--
-- Name: detail_plan_addition_information_kind detail_plan_addition_information_kind_uri_key; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.detail_plan_addition_information_kind
    ADD CONSTRAINT detail_plan_addition_information_kind_uri_key UNIQUE (uri);


--
-- Name: detail_plan_regulation_kind detail_plan_regulation_kind_codevalue_key; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.detail_plan_regulation_kind
    ADD CONSTRAINT detail_plan_regulation_kind_codevalue_key UNIQUE (codevalue);


--
-- Name: detail_plan_regulation_kind detail_plan_regulation_kind_pkey; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.detail_plan_regulation_kind
    ADD CONSTRAINT detail_plan_regulation_kind_pkey PRIMARY KEY (id);


--
-- Name: detail_plan_regulation_kind detail_plan_regulation_kind_uri_key; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.detail_plan_regulation_kind
    ADD CONSTRAINT detail_plan_regulation_kind_uri_key UNIQUE (uri);


--
-- Name: detail_plan_theme detail_plan_theme_codevalue_key; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.detail_plan_theme
    ADD CONSTRAINT detail_plan_theme_codevalue_key UNIQUE (codevalue);


--
-- Name: detail_plan_theme detail_plan_theme_pkey; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.detail_plan_theme
    ADD CONSTRAINT detail_plan_theme_pkey PRIMARY KEY (id);


--
-- Name: detail_plan_theme detail_plan_theme_uri_key; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.detail_plan_theme
    ADD CONSTRAINT detail_plan_theme_uri_key UNIQUE (uri);


--
-- Name: digital_origin_kind digital_origin_kind_codevalue_key; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.digital_origin_kind
    ADD CONSTRAINT digital_origin_kind_codevalue_key UNIQUE (codevalue);


--
-- Name: digital_origin_kind digital_origin_kind_pkey; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.digital_origin_kind
    ADD CONSTRAINT digital_origin_kind_pkey PRIMARY KEY (id);


--
-- Name: digital_origin_kind digital_origin_kind_uri_key; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.digital_origin_kind
    ADD CONSTRAINT digital_origin_kind_uri_key UNIQUE (uri);


--
-- Name: document_kind document_kind_codevalue_key; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.document_kind
    ADD CONSTRAINT document_kind_codevalue_key UNIQUE (codevalue);


--
-- Name: document_kind document_kind_pkey; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.document_kind
    ADD CONSTRAINT document_kind_pkey PRIMARY KEY (id);


--
-- Name: document_kind document_kind_uri_key; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.document_kind
    ADD CONSTRAINT document_kind_uri_key UNIQUE (uri);


--
-- Name: finnish_area_type finnish_area_type_pkey; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.finnish_area_type
    ADD CONSTRAINT finnish_area_type_pkey PRIMARY KEY (identifier);


--
-- Name: finnish_area_type finnish_area_type_value_key; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.finnish_area_type
    ADD CONSTRAINT finnish_area_type_value_key UNIQUE (value);


--
-- Name: finnish_document_role finnish_document_role_pkey; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.finnish_document_role
    ADD CONSTRAINT finnish_document_role_pkey PRIMARY KEY (identifier);


--
-- Name: finnish_document_role finnish_document_role_value_key; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.finnish_document_role
    ADD CONSTRAINT finnish_document_role_value_key UNIQUE (value);


--
-- Name: finnish_document_type finnish_document_type_pkey; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.finnish_document_type
    ADD CONSTRAINT finnish_document_type_pkey PRIMARY KEY (identifier);


--
-- Name: finnish_document_type finnish_document_type_value_key; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.finnish_document_type
    ADD CONSTRAINT finnish_document_type_value_key UNIQUE (value);


--
-- Name: finnish_informative_feature_type finnish_informative_feature_type_pkey; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.finnish_informative_feature_type
    ADD CONSTRAINT finnish_informative_feature_type_pkey PRIMARY KEY (identifier);


--
-- Name: finnish_informative_feature_type finnish_informative_feature_type_value_key; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.finnish_informative_feature_type
    ADD CONSTRAINT finnish_informative_feature_type_value_key UNIQUE (value);


--
-- Name: finnish_land_use_kind finnish_land_use_kind_code_key; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.finnish_land_use_kind
    ADD CONSTRAINT finnish_land_use_kind_code_key UNIQUE (code);


--
-- Name: finnish_land_use_kind finnish_land_use_kind_pkey; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.finnish_land_use_kind
    ADD CONSTRAINT finnish_land_use_kind_pkey PRIMARY KEY (identifier);


--
-- Name: finnish_language finnish_language_pkey; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.finnish_language
    ADD CONSTRAINT finnish_language_pkey PRIMARY KEY (identifier);


--
-- Name: finnish_language finnish_language_value_key; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.finnish_language
    ADD CONSTRAINT finnish_language_value_key UNIQUE (value);


--
-- Name: finnish_municipalities finnish_municipalities_codevalue_key; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.finnish_municipalities
    ADD CONSTRAINT finnish_municipalities_codevalue_key UNIQUE (codevalue);


--
-- Name: finnish_municipalities finnish_municipalities_pkey; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.finnish_municipalities
    ADD CONSTRAINT finnish_municipalities_pkey PRIMARY KEY (id);


--
-- Name: finnish_municipalities finnish_municipalities_uri_key; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.finnish_municipalities
    ADD CONSTRAINT finnish_municipalities_uri_key UNIQUE (uri);


--
-- Name: finnish_municipality_codes finnish_municipality_codes_code_key; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.finnish_municipality_codes
    ADD CONSTRAINT finnish_municipality_codes_code_key UNIQUE (code);


--
-- Name: finnish_municipality_codes finnish_municipality_codes_pkey; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.finnish_municipality_codes
    ADD CONSTRAINT finnish_municipality_codes_pkey PRIMARY KEY (identifier);


--
-- Name: finnish_numeric_value finnish_numeric_value_pkey; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.finnish_numeric_value
    ADD CONSTRAINT finnish_numeric_value_pkey PRIMARY KEY (identifier);


--
-- Name: finnish_numeric_value finnish_numeric_value_value_key; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.finnish_numeric_value
    ADD CONSTRAINT finnish_numeric_value_value_key UNIQUE (value);


--
-- Name: finnish_ordinance_process finnish_ordinance_process_pkey; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.finnish_ordinance_process
    ADD CONSTRAINT finnish_ordinance_process_pkey PRIMARY KEY (identifier);


--
-- Name: finnish_ordinance_process_step finnish_ordinance_process_step_pkey; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.finnish_ordinance_process_step
    ADD CONSTRAINT finnish_ordinance_process_step_pkey PRIMARY KEY (identifier);


--
-- Name: finnish_ordinance_process_step finnish_ordinance_process_step_value_key; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.finnish_ordinance_process_step
    ADD CONSTRAINT finnish_ordinance_process_step_value_key UNIQUE (value);


--
-- Name: finnish_ordinance_process finnish_ordinance_process_value_key; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.finnish_ordinance_process
    ADD CONSTRAINT finnish_ordinance_process_value_key UNIQUE (value);


--
-- Name: finnish_plan_description finnish_plan_description_pkey; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.finnish_plan_description
    ADD CONSTRAINT finnish_plan_description_pkey PRIMARY KEY (identifier);


--
-- Name: finnish_plan_description finnish_plan_description_value_key; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.finnish_plan_description
    ADD CONSTRAINT finnish_plan_description_value_key UNIQUE (value);


--
-- Name: finnish_planned_space_type finnish_planned_space_type_pkey; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.finnish_planned_space_type
    ADD CONSTRAINT finnish_planned_space_type_pkey PRIMARY KEY (identifier);


--
-- Name: finnish_planned_space_type finnish_planned_space_type_value_key; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.finnish_planned_space_type
    ADD CONSTRAINT finnish_planned_space_type_value_key UNIQUE (value);


--
-- Name: finnish_planning_detail_line_type finnish_planning_detail_line_type_pkey; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.finnish_planning_detail_line_type
    ADD CONSTRAINT finnish_planning_detail_line_type_pkey PRIMARY KEY (identifier);


--
-- Name: finnish_planning_detail_line_type finnish_planning_detail_line_type_value_key; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.finnish_planning_detail_line_type
    ADD CONSTRAINT finnish_planning_detail_line_type_value_key UNIQUE (value);


--
-- Name: finnish_planning_detail_point_type finnish_planning_detail_point_type_pkey; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.finnish_planning_detail_point_type
    ADD CONSTRAINT finnish_planning_detail_point_type_pkey PRIMARY KEY (identifier);


--
-- Name: finnish_planning_detail_point_type finnish_planning_detail_point_type_value_key; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.finnish_planning_detail_point_type
    ADD CONSTRAINT finnish_planning_detail_point_type_value_key UNIQUE (value);


--
-- Name: finnish_regulative_text_type finnish_regulative_text_type_pkey; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.finnish_regulative_text_type
    ADD CONSTRAINT finnish_regulative_text_type_pkey PRIMARY KEY (identifier);


--
-- Name: finnish_regulative_text_type finnish_regulative_text_type_value_key; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.finnish_regulative_text_type
    ADD CONSTRAINT finnish_regulative_text_type_value_key UNIQUE (value);


--
-- Name: finnish_spatial_plan_approved_by finnish_spatial_plan_approved_by_pkey; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.finnish_spatial_plan_approved_by
    ADD CONSTRAINT finnish_spatial_plan_approved_by_pkey PRIMARY KEY (identifier);


--
-- Name: finnish_spatial_plan_approved_by finnish_spatial_plan_approved_by_value_key; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.finnish_spatial_plan_approved_by
    ADD CONSTRAINT finnish_spatial_plan_approved_by_value_key UNIQUE (value);


--
-- Name: finnish_spatial_plan_level finnish_spatial_plan_level_pkey; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.finnish_spatial_plan_level
    ADD CONSTRAINT finnish_spatial_plan_level_pkey PRIMARY KEY (identifier);


--
-- Name: finnish_spatial_plan_level finnish_spatial_plan_level_value_key; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.finnish_spatial_plan_level
    ADD CONSTRAINT finnish_spatial_plan_level_value_key UNIQUE (value);


--
-- Name: finnish_spatial_plan_origin finnish_spatial_plan_origin_pkey; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.finnish_spatial_plan_origin
    ADD CONSTRAINT finnish_spatial_plan_origin_pkey PRIMARY KEY (identifier);


--
-- Name: finnish_spatial_plan_origin finnish_spatial_plan_origin_value_key; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.finnish_spatial_plan_origin
    ADD CONSTRAINT finnish_spatial_plan_origin_value_key UNIQUE (value);


--
-- Name: finnish_spatial_plan_status finnish_spatial_plan_status_pkey; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.finnish_spatial_plan_status
    ADD CONSTRAINT finnish_spatial_plan_status_pkey PRIMARY KEY (identifier);


--
-- Name: finnish_spatial_plan_status finnish_spatial_plan_status_value_key; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.finnish_spatial_plan_status
    ADD CONSTRAINT finnish_spatial_plan_status_value_key UNIQUE (value);


--
-- Name: finnish_spatial_plan_type finnish_spatial_plan_type_pkey; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.finnish_spatial_plan_type
    ADD CONSTRAINT finnish_spatial_plan_type_pkey PRIMARY KEY (identifier);


--
-- Name: finnish_spatial_plan_type finnish_spatial_plan_type_value_key; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.finnish_spatial_plan_type
    ADD CONSTRAINT finnish_spatial_plan_type_value_key UNIQUE (value);


--
-- Name: finnish_up_to_dateness finnish_up_to_dateness_pkey; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.finnish_up_to_dateness
    ADD CONSTRAINT finnish_up_to_dateness_pkey PRIMARY KEY (identifier);


--
-- Name: finnish_up_to_dateness finnish_up_to_dateness_value_key; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.finnish_up_to_dateness
    ADD CONSTRAINT finnish_up_to_dateness_value_key UNIQUE (value);


--
-- Name: finnish_vertical_coordinate_reference_system finnish_vertical_coordinate_reference_system_pkey; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.finnish_vertical_coordinate_reference_system
    ADD CONSTRAINT finnish_vertical_coordinate_reference_system_pkey PRIMARY KEY (identifier);


--
-- Name: finnish_vertical_coordinate_reference_system finnish_vertical_coordinate_reference_system_value_key; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.finnish_vertical_coordinate_reference_system
    ADD CONSTRAINT finnish_vertical_coordinate_reference_system_value_key UNIQUE (value);


--
-- Name: finnish_zoning_element_type finnish_zoning_element_type_pkey; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.finnish_zoning_element_type
    ADD CONSTRAINT finnish_zoning_element_type_pkey PRIMARY KEY (identifier);


--
-- Name: finnish_zoning_element_type finnish_zoning_element_type_value_key; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.finnish_zoning_element_type
    ADD CONSTRAINT finnish_zoning_element_type_value_key UNIQUE (value);


--
-- Name: ground_relativeness_kind ground_relativeness_kind_codevalue_key; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.ground_relativeness_kind
    ADD CONSTRAINT ground_relativeness_kind_codevalue_key UNIQUE (codevalue);


--
-- Name: ground_relativeness_kind ground_relativeness_kind_pkey; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.ground_relativeness_kind
    ADD CONSTRAINT ground_relativeness_kind_pkey PRIMARY KEY (id);


--
-- Name: ground_relativeness_kind ground_relativeness_kind_uri_key; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.ground_relativeness_kind
    ADD CONSTRAINT ground_relativeness_kind_uri_key UNIQUE (uri);


--
-- Name: ryhti_language ryhti_language_code_key; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.ryhti_language
    ADD CONSTRAINT ryhti_language_code_key UNIQUE (code);


--
-- Name: legal_effectiveness_kind legal_effectiveness_kind_codevalue_key; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.legal_effectiveness_kind
    ADD CONSTRAINT legal_effectiveness_kind_codevalue_key UNIQUE (codevalue);


--
-- Name: legal_effectiveness_kind legal_effectiveness_kind_pkey; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.legal_effectiveness_kind
    ADD CONSTRAINT legal_effectiveness_kind_pkey PRIMARY KEY (id);


--
-- Name: legal_effectiveness_kind legal_effectiveness_kind_uri_key; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.legal_effectiveness_kind
    ADD CONSTRAINT legal_effectiveness_kind_uri_key UNIQUE (uri);


--
-- Name: master_plan_additional_information_kind master_plan_additional_information_kind_codevalue_key; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.master_plan_additional_information_kind
    ADD CONSTRAINT master_plan_additional_information_kind_codevalue_key UNIQUE (codevalue);


--
-- Name: master_plan_additional_information_kind master_plan_additional_information_kind_pkey; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.master_plan_additional_information_kind
    ADD CONSTRAINT master_plan_additional_information_kind_pkey PRIMARY KEY (id);


--
-- Name: master_plan_additional_information_kind master_plan_additional_information_kind_uri_key; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.master_plan_additional_information_kind
    ADD CONSTRAINT master_plan_additional_information_kind_uri_key UNIQUE (uri);


--
-- Name: master_plan_envrionmental_change_kind master_plan_envrionmental_change_kind_codevalue_key; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.master_plan_envrionmental_change_kind
    ADD CONSTRAINT master_plan_envrionmental_change_kind_codevalue_key UNIQUE (codevalue);


--
-- Name: master_plan_envrionmental_change_kind master_plan_envrionmental_change_kind_pkey; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.master_plan_envrionmental_change_kind
    ADD CONSTRAINT master_plan_envrionmental_change_kind_pkey PRIMARY KEY (id);


--
-- Name: master_plan_envrionmental_change_kind master_plan_envrionmental_change_kind_uri_key; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.master_plan_envrionmental_change_kind
    ADD CONSTRAINT master_plan_envrionmental_change_kind_uri_key UNIQUE (uri);


--
-- Name: master_plan_regulation_kind master_plan_regulation_kind_codevalue_key; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.master_plan_regulation_kind
    ADD CONSTRAINT master_plan_regulation_kind_codevalue_key UNIQUE (codevalue);


--
-- Name: master_plan_regulation_kind master_plan_regulation_kind_pkey; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.master_plan_regulation_kind
    ADD CONSTRAINT master_plan_regulation_kind_pkey PRIMARY KEY (id);


--
-- Name: master_plan_regulation_kind master_plan_regulation_kind_uri_key; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.master_plan_regulation_kind
    ADD CONSTRAINT master_plan_regulation_kind_uri_key UNIQUE (uri);


--
-- Name: master_plan_theme master_plan_theme_codevalue_key; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.master_plan_theme
    ADD CONSTRAINT master_plan_theme_codevalue_key UNIQUE (codevalue);


--
-- Name: master_plan_theme master_plan_theme_pkey; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.master_plan_theme
    ADD CONSTRAINT master_plan_theme_pkey PRIMARY KEY (id);


--
-- Name: master_plan_theme master_plan_theme_uri_key; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.master_plan_theme
    ADD CONSTRAINT master_plan_theme_uri_key UNIQUE (uri);


--
-- Name: spatial_plan_kind spatial_plan_kind_codevalue_key; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.spatial_plan_kind
    ADD CONSTRAINT spatial_plan_kind_codevalue_key UNIQUE (codevalue);


--
-- Name: spatial_plan_kind spatial_plan_kind_pkey; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.spatial_plan_kind
    ADD CONSTRAINT spatial_plan_kind_pkey PRIMARY KEY (id);


--
-- Name: spatial_plan_kind spatial_plan_kind_uri_key; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.spatial_plan_kind
    ADD CONSTRAINT spatial_plan_kind_uri_key UNIQUE (uri);


--
-- Name: spatial_plan_lifecycle_status spatial_plan_lifecycle_status_codevalue_key; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.spatial_plan_lifecycle_status
    ADD CONSTRAINT spatial_plan_lifecycle_status_codevalue_key UNIQUE (codevalue);


--
-- Name: spatial_plan_lifecycle_status spatial_plan_lifecycle_status_pkey; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.spatial_plan_lifecycle_status
    ADD CONSTRAINT spatial_plan_lifecycle_status_pkey PRIMARY KEY (id);


--
-- Name: spatial_plan_lifecycle_status spatial_plan_lifecycle_status_uri_key; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.spatial_plan_lifecycle_status
    ADD CONSTRAINT spatial_plan_lifecycle_status_uri_key UNIQUE (uri);


--
-- Name: validity_type validity_type_pkey; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.validity_type
    ADD CONSTRAINT validity_type_pkey PRIMARY KEY (identifier);


--
-- Name: validity_type validity_type_value_key; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.validity_type
    ADD CONSTRAINT validity_type_value_key UNIQUE (value);


--
-- Name: data_type data_type_value_key; Type: CONSTRAINT; Schema: code_lists; Owner: -
--

ALTER TABLE ONLY code_lists.data_type
    ADD CONSTRAINT data_type_value_key UNIQUE (value);