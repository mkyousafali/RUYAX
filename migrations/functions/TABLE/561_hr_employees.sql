CREATE TABLE public.hr_employees (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    employee_id character varying(20) NOT NULL,
    branch_id bigint NOT NULL,
    hire_date date,
    status character varying(20) DEFAULT 'active'::character varying,
    created_at timestamp with time zone DEFAULT now(),
    name character varying(200) NOT NULL,
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: TABLE hr_employees; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.hr_employees IS 'HR Employees - Upload function with Employee ID and Name only. Branch assigned from UI, Hire Date updated later.';


--
-- Name: hr_fingerprint_transactions; Type: TABLE; Schema: public; Owner: -
--

