CREATE TABLE public.incident_actions (
    id text DEFAULT ('ACT'::text || nextval('public.incident_actions_id_seq'::regclass)) NOT NULL,
    action_type text NOT NULL,
    recourse_type text,
    action_report jsonb,
    has_fine boolean DEFAULT false,
    fine_amount numeric(10,2) DEFAULT 0,
    fine_threat_amount numeric(10,2) DEFAULT 0,
    is_paid boolean DEFAULT false,
    paid_at timestamp with time zone,
    paid_by text,
    employee_id text NOT NULL,
    incident_id text NOT NULL,
    incident_type_id text,
    created_by text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT incident_actions_action_type_check CHECK ((action_type = ANY (ARRAY['warning'::text, 'investigation'::text, 'termination'::text, 'other'::text]))),
    CONSTRAINT incident_actions_recourse_type_check CHECK ((recourse_type = ANY (ARRAY['warning'::text, 'warning_fine'::text, 'warning_fine_threat'::text, 'warning_fine_termination_threat'::text, 'termination'::text])))
);


--
-- Name: TABLE incident_actions; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.incident_actions IS 'Tracks all actions taken on incidents including warnings, fines, and their payment status';


--
-- Name: COLUMN incident_actions.id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.incident_actions.id IS 'Auto-generated ID in format ACT1, ACT2, etc.';


--
-- Name: COLUMN incident_actions.action_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.incident_actions.action_type IS 'Type of action: warning, investigation, termination, other';


--
-- Name: COLUMN incident_actions.recourse_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.incident_actions.recourse_type IS 'Type of recourse for warnings';


--
-- Name: COLUMN incident_actions.action_report; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.incident_actions.action_report IS 'Full action/warning report as JSONB';


--
-- Name: COLUMN incident_actions.has_fine; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.incident_actions.has_fine IS 'Whether this action includes a fine';


--
-- Name: COLUMN incident_actions.fine_amount; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.incident_actions.fine_amount IS 'Fine amount if applicable';


--
-- Name: COLUMN incident_actions.fine_threat_amount; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.incident_actions.fine_threat_amount IS 'Threatened fine amount for warning_fine_threat type';


--
-- Name: COLUMN incident_actions.is_paid; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.incident_actions.is_paid IS 'Whether the fine has been paid';


--
-- Name: COLUMN incident_actions.paid_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.incident_actions.paid_at IS 'When the fine was paid';


--
-- Name: COLUMN incident_actions.paid_by; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.incident_actions.paid_by IS 'User ID who marked the fine as paid';


--
-- Name: incident_types; Type: TABLE; Schema: public; Owner: -
--

