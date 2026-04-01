CREATE TABLE public.hr_employee_master (
    id text NOT NULL,
    user_id uuid NOT NULL,
    current_branch_id integer NOT NULL,
    current_position_id uuid,
    name_en character varying(255),
    name_ar character varying(255),
    employee_id_mapping jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    nationality_id character varying(10),
    id_expiry_date date,
    id_document_url character varying(500),
    health_card_expiry_date date,
    health_card_document_url character varying(500),
    driving_licence_expiry_date date,
    driving_licence_document_url character varying(500),
    id_number character varying(50),
    health_card_number character varying(50),
    driving_licence_number character varying(50),
    bank_name character varying(255),
    iban character varying(34),
    contract_expiry_date date,
    contract_document_url text,
    sponsorship_status boolean DEFAULT false,
    insurance_expiry_date date,
    insurance_company_id character varying(15),
    health_educational_renewal_date date,
    date_of_birth date,
    join_date date,
    work_permit_expiry_date date,
    probation_period_expiry_date date,
    employment_status text DEFAULT 'Resigned'::text,
    permitted_early_leave_hours numeric DEFAULT 0,
    employment_status_effective_date date,
    employment_status_reason text,
    whatsapp_number text,
    email text,
    privacy_policy_accepted boolean DEFAULT false NOT NULL,
    CONSTRAINT employment_status_values CHECK ((employment_status = ANY (ARRAY['Resigned'::text, 'Job (With Finger)'::text, 'Vacation'::text, 'Terminated'::text, 'Run Away'::text, 'Remote Job'::text, 'Job (No Finger)'::text])))
);


--
-- Name: COLUMN hr_employee_master.bank_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.hr_employee_master.bank_name IS 'Name of the bank where employee has account';


--
-- Name: COLUMN hr_employee_master.iban; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.hr_employee_master.iban IS 'International Bank Account Number';


--
-- Name: COLUMN hr_employee_master.contract_expiry_date; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.hr_employee_master.contract_expiry_date IS 'Employment contract expiry date';


--
-- Name: COLUMN hr_employee_master.contract_document_url; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.hr_employee_master.contract_document_url IS 'URL to the uploaded contract document';


--
-- Name: COLUMN hr_employee_master.sponsorship_status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.hr_employee_master.sponsorship_status IS 'Employee sponsorship status - true if active, false if inactive';


--
-- Name: COLUMN hr_employee_master.employment_status_effective_date; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.hr_employee_master.employment_status_effective_date IS 'Effective date for employment status changes (Resigned, Terminated, Run Away)';


--
-- Name: COLUMN hr_employee_master.employment_status_reason; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.hr_employee_master.employment_status_reason IS 'Reason for employment status change';


--
-- Name: hr_employees; Type: TABLE; Schema: public; Owner: -
--

