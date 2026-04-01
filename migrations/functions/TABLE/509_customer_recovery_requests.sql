CREATE TABLE public.customer_recovery_requests (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    customer_id uuid,
    whatsapp_number character varying(20) NOT NULL,
    customer_name text,
    request_type text DEFAULT 'account_recovery'::text NOT NULL,
    verification_status text DEFAULT 'pending'::text NOT NULL,
    verification_notes text,
    processed_by uuid,
    processed_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT customer_recovery_requests_request_type_check CHECK ((request_type = ANY (ARRAY['account_recovery'::text, 'access_code_request'::text]))),
    CONSTRAINT customer_recovery_requests_verification_status_check CHECK ((verification_status = ANY (ARRAY['pending'::text, 'verified'::text, 'rejected'::text, 'processed'::text]))),
    CONSTRAINT customer_recovery_requests_whatsapp_format_check CHECK (((whatsapp_number)::text ~ '^\+?[1-9]\d{1,14}$'::text))
);


--
-- Name: TABLE customer_recovery_requests; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.customer_recovery_requests IS 'Customer account recovery requests for admin processing';


--
-- Name: COLUMN customer_recovery_requests.request_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.customer_recovery_requests.request_type IS 'Type of recovery request';


--
-- Name: COLUMN customer_recovery_requests.verification_status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.customer_recovery_requests.verification_status IS 'Admin verification status';


--
-- Name: customers; Type: TABLE; Schema: public; Owner: -
--

