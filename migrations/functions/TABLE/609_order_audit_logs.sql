CREATE TABLE public.order_audit_logs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    order_id uuid NOT NULL,
    action_type character varying(50) NOT NULL,
    from_status character varying(50),
    to_status character varying(50),
    performed_by uuid,
    performed_by_name character varying(255),
    performed_by_role character varying(50),
    assigned_user_id uuid,
    assigned_user_name character varying(255),
    assignment_type character varying(50),
    field_name character varying(100),
    old_value text,
    new_value text,
    notes text,
    ip_address inet,
    user_agent text,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);

ALTER TABLE ONLY public.order_audit_logs REPLICA IDENTITY FULL;


--
-- Name: TABLE order_audit_logs; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.order_audit_logs IS 'Audit trail for all order changes and actions';


--
-- Name: COLUMN order_audit_logs.action_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.order_audit_logs.action_type IS 'Type of action: created, status_changed, assigned_picker, assigned_delivery, cancelled, etc.';


--
-- Name: COLUMN order_audit_logs.from_status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.order_audit_logs.from_status IS 'Previous order status (for status_changed actions)';


--
-- Name: COLUMN order_audit_logs.to_status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.order_audit_logs.to_status IS 'New order status (for status_changed actions)';


--
-- Name: COLUMN order_audit_logs.performed_by; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.order_audit_logs.performed_by IS 'User who performed the action';


--
-- Name: COLUMN order_audit_logs.assigned_user_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.order_audit_logs.assigned_user_id IS 'User who was assigned (for assignment actions)';


--
-- Name: COLUMN order_audit_logs.assignment_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.order_audit_logs.assignment_type IS 'Type of assignment: picker or delivery';


--
-- Name: order_items; Type: TABLE; Schema: public; Owner: -
--

