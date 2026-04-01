CREATE TABLE public.overtime_registrations (
    id text NOT NULL,
    employee_id text NOT NULL,
    overtime_date date NOT NULL,
    overtime_minutes integer DEFAULT 0 NOT NULL,
    worked_minutes integer DEFAULT 0,
    notes text,
    created_by text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: TABLE overtime_registrations; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.overtime_registrations IS 'Stores overtime registrations for employees who worked on holidays/day offs or worked beyond expected hours';


--
-- Name: pos_deduction_transfers; Type: TABLE; Schema: public; Owner: -
--

