CREATE TABLE public.hr_fingerprint_transactions (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    employee_id character varying(20) NOT NULL,
    name character varying(200),
    branch_id bigint NOT NULL,
    date date NOT NULL,
    "time" time without time zone NOT NULL,
    status character varying(20) NOT NULL,
    device_id character varying(50),
    created_at timestamp with time zone DEFAULT now(),
    location text,
    processed boolean DEFAULT false,
    CONSTRAINT chk_hr_fingerprint_punch CHECK (((status)::text = ANY (ARRAY[('Check In'::character varying)::text, ('Check Out'::character varying)::text, ('Break In'::character varying)::text, ('Break Out'::character varying)::text, ('Overtime In'::character varying)::text, ('Overtime Out'::character varying)::text])))
);


--
-- Name: TABLE hr_fingerprint_transactions; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.hr_fingerprint_transactions IS 'HR Fingerprint Transactions - Excel upload with numeric employee_id and name matching hr_employees table';


--
-- Name: hr_insurance_companies; Type: TABLE; Schema: public; Owner: -
--

