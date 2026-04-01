CREATE TABLE public.hr_levels (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    level_name_en character varying(100) NOT NULL,
    level_name_ar character varying(100) NOT NULL,
    level_order integer NOT NULL,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: TABLE hr_levels; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.hr_levels IS 'HR Levels - minimal schema for Create Level function';


--
-- Name: hr_position_assignments; Type: TABLE; Schema: public; Owner: -
--

