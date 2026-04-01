CREATE TABLE public.hr_position_assignments (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    employee_id uuid NOT NULL,
    position_id uuid NOT NULL,
    department_id uuid NOT NULL,
    level_id uuid NOT NULL,
    branch_id bigint NOT NULL,
    effective_date date DEFAULT CURRENT_DATE NOT NULL,
    is_current boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: TABLE hr_position_assignments; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.hr_position_assignments IS 'HR Position Assignments - minimal schema for Assign Positions function';


--
-- Name: hr_position_reporting_template; Type: TABLE; Schema: public; Owner: -
--

