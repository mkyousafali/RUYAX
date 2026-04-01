CREATE TABLE public.day_off (
    id text NOT NULL,
    employee_id text NOT NULL,
    day_off_date date NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    day_off_reason_id character varying(50),
    approval_status character varying(50) DEFAULT 'pending'::character varying,
    approval_requested_by uuid,
    approval_requested_at timestamp with time zone,
    approval_approved_by uuid,
    approval_approved_at timestamp with time zone,
    approval_notes text,
    document_url text,
    document_uploaded_at timestamp with time zone,
    is_deductible_on_salary boolean DEFAULT false,
    rejection_reason text,
    description text,
    CONSTRAINT day_off_approval_status_check CHECK (((approval_status)::text = ANY ((ARRAY['pending'::character varying, 'sent_for_approval'::character varying, 'approved'::character varying, 'rejected'::character varying])::text[])))
);


--
-- Name: COLUMN day_off.description; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.day_off.description IS 'Description or reason for the day off request';


--
-- Name: day_off_reasons; Type: TABLE; Schema: public; Owner: -
--

