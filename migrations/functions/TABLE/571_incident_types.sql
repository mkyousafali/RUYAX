CREATE TABLE public.incident_types (
    id text NOT NULL,
    incident_type_en text NOT NULL,
    incident_type_ar text NOT NULL,
    description_en text,
    description_ar text,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: TABLE incident_types; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.incident_types IS 'Stores the types of incidents that can be reported in the system';


--
-- Name: COLUMN incident_types.id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.incident_types.id IS 'Unique identifier for incident type (IN1, IN2, etc.)';


--
-- Name: COLUMN incident_types.incident_type_en; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.incident_types.incident_type_en IS 'English name of the incident type';


--
-- Name: COLUMN incident_types.incident_type_ar; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.incident_types.incident_type_ar IS 'Arabic name of the incident type';


--
-- Name: incidents; Type: TABLE; Schema: public; Owner: -
--

