CREATE TABLE public.hr_position_reporting_template (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    subordinate_position_id uuid NOT NULL,
    manager_position_1 uuid,
    manager_position_2 uuid,
    manager_position_3 uuid,
    manager_position_4 uuid,
    manager_position_5 uuid,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT chk_no_self_report_1 CHECK ((subordinate_position_id <> manager_position_1)),
    CONSTRAINT chk_no_self_report_2 CHECK ((subordinate_position_id <> manager_position_2)),
    CONSTRAINT chk_no_self_report_3 CHECK ((subordinate_position_id <> manager_position_3)),
    CONSTRAINT chk_no_self_report_4 CHECK ((subordinate_position_id <> manager_position_4)),
    CONSTRAINT chk_no_self_report_5 CHECK ((subordinate_position_id <> manager_position_5))
);


--
-- Name: TABLE hr_position_reporting_template; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.hr_position_reporting_template IS 'HR Position Reporting Template - Each position can report to up to 5 different manager positions (Slots 1-5)';


--
-- Name: hr_positions; Type: TABLE; Schema: public; Owner: -
--

