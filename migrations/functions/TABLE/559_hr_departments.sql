CREATE TABLE public.hr_departments (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    department_name_en character varying(100) NOT NULL,
    department_name_ar character varying(100) NOT NULL,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: TABLE hr_departments; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.hr_departments IS 'HR Departments - minimal schema for Create Department function';


--
-- Name: hr_employee_master; Type: TABLE; Schema: public; Owner: -
--

