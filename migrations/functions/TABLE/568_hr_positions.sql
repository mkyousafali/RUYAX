CREATE TABLE public.hr_positions (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    position_title_en character varying(100) NOT NULL,
    position_title_ar character varying(100) NOT NULL,
    department_id uuid NOT NULL,
    level_id uuid NOT NULL,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: TABLE hr_positions; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.hr_positions IS 'HR Positions - minimal schema for Create Position function';


--
-- Name: incident_actions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

