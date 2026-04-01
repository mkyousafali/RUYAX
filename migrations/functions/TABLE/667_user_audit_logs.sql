CREATE TABLE public.user_audit_logs (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    user_id uuid,
    target_user_id uuid,
    action character varying(100) NOT NULL,
    table_name character varying(100),
    record_id uuid,
    old_values jsonb,
    new_values jsonb,
    ip_address inet,
    user_agent text,
    performed_by uuid,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: user_device_sessions; Type: TABLE; Schema: public; Owner: -
--

