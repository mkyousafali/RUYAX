CREATE TABLE public.customer_access_code_history (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    customer_id uuid NOT NULL,
    old_access_code text,
    new_access_code text NOT NULL,
    generated_by uuid NOT NULL,
    reason text NOT NULL,
    notes text,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT customer_access_code_history_reason_check CHECK ((reason = ANY (ARRAY['initial_generation'::text, 'admin_regeneration'::text, 'security_reset'::text, 'customer_request'::text, 're_registration'::text, 'forgot_code_resend'::text, 'pre_registered_upgrade'::text])))
);


--
-- Name: TABLE customer_access_code_history; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.customer_access_code_history IS 'Audit trail of customer access code changes';


--
-- Name: COLUMN customer_access_code_history.reason; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.customer_access_code_history.reason IS 'Reason for access code change';


--
-- Name: customer_app_media; Type: TABLE; Schema: public; Owner: -
--

