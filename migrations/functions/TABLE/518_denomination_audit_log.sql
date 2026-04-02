CREATE TABLE public.denomination_audit_log (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    record_id uuid NOT NULL,
    branch_id integer NOT NULL,
    user_id uuid NOT NULL,
    action character varying(10) NOT NULL,
    record_type character varying(30) NOT NULL,
    box_number smallint,
    old_counts jsonb,
    new_counts jsonb,
    old_erp_balance numeric(15,2),
    new_erp_balance numeric(15,2),
    old_grand_total numeric(15,2),
    new_grand_total numeric(15,2),
    old_difference numeric(15,2),
    new_difference numeric(15,2),
    change_reason text,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT denomination_audit_log_action_check CHECK (((action)::text = ANY ((ARRAY['INSERT'::character varying, 'UPDATE'::character varying, 'DELETE'::character varying])::text[])))
);


--
-- Name: TABLE denomination_audit_log; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.denomination_audit_log IS 'Automatic audit log for all denomination record changes (INSERT, UPDATE, DELETE)';


--
-- Name: denomination_records; Type: TABLE; Schema: public; Owner: -
--

