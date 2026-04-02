CREATE TABLE public.hr_basic_salary (
    employee_id character varying(50) NOT NULL,
    basic_salary numeric(10,2) NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    payment_mode character varying(20) DEFAULT 'Bank'::character varying NOT NULL,
    other_allowance numeric(10,2),
    other_allowance_payment_mode character varying(20),
    accommodation_allowance numeric(10,2),
    accommodation_payment_mode character varying(20),
    travel_allowance numeric(10,2),
    travel_payment_mode character varying(20),
    gosi_deduction numeric(10,2),
    total_salary numeric(10,2),
    food_allowance numeric(10,2) DEFAULT 0,
    food_payment_mode text DEFAULT 'Bank'::text,
    CONSTRAINT hr_basic_salary_accommodation_payment_mode_check CHECK (((accommodation_payment_mode)::text = ANY ((ARRAY['Bank'::character varying, 'Cash'::character varying])::text[]))),
    CONSTRAINT hr_basic_salary_food_payment_mode_check CHECK ((food_payment_mode = ANY (ARRAY['Bank'::text, 'Cash'::text]))),
    CONSTRAINT hr_basic_salary_other_allowance_payment_mode_check CHECK (((other_allowance_payment_mode)::text = ANY ((ARRAY['Bank'::character varying, 'Cash'::character varying])::text[]))),
    CONSTRAINT hr_basic_salary_payment_mode_check CHECK (((payment_mode)::text = ANY ((ARRAY['Bank'::character varying, 'Cash'::character varying])::text[]))),
    CONSTRAINT hr_basic_salary_travel_payment_mode_check CHECK (((travel_payment_mode)::text = ANY ((ARRAY['Bank'::character varying, 'Cash'::character varying])::text[])))
);


--
-- Name: TABLE hr_basic_salary; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.hr_basic_salary IS 'Stores basic salary information for employees';


--
-- Name: COLUMN hr_basic_salary.employee_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.hr_basic_salary.employee_id IS 'References hr_employee_master.id';


--
-- Name: COLUMN hr_basic_salary.basic_salary; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.hr_basic_salary.basic_salary IS 'Employee basic salary amount';


--
-- Name: COLUMN hr_basic_salary.payment_mode; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.hr_basic_salary.payment_mode IS 'Payment mode: Bank or Cash';


--
-- Name: COLUMN hr_basic_salary.other_allowance; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.hr_basic_salary.other_allowance IS 'Other allowance amount';


--
-- Name: COLUMN hr_basic_salary.other_allowance_payment_mode; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.hr_basic_salary.other_allowance_payment_mode IS 'Payment mode for other allowance: Bank or Cash';


--
-- Name: COLUMN hr_basic_salary.accommodation_allowance; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.hr_basic_salary.accommodation_allowance IS 'Accommodation allowance amount';


--
-- Name: COLUMN hr_basic_salary.accommodation_payment_mode; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.hr_basic_salary.accommodation_payment_mode IS 'Payment mode for accommodation: Bank or Cash';


--
-- Name: COLUMN hr_basic_salary.travel_allowance; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.hr_basic_salary.travel_allowance IS 'Travel allowance amount';


--
-- Name: COLUMN hr_basic_salary.travel_payment_mode; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.hr_basic_salary.travel_payment_mode IS 'Payment mode for travel: Bank or Cash';


--
-- Name: COLUMN hr_basic_salary.gosi_deduction; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.hr_basic_salary.gosi_deduction IS 'GOSI deduction amount';


--
-- Name: COLUMN hr_basic_salary.total_salary; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.hr_basic_salary.total_salary IS 'Total salary after all allowances and deductions';


--
-- Name: COLUMN hr_basic_salary.food_allowance; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.hr_basic_salary.food_allowance IS 'Food allowance amount for the employee';


--
-- Name: COLUMN hr_basic_salary.food_payment_mode; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.hr_basic_salary.food_payment_mode IS 'Payment mode for food allowance: Bank or Cash';


--
-- Name: hr_checklist_operations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

