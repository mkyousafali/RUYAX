CREATE TABLE public.incidents (
    id text NOT NULL,
    incident_type_id text NOT NULL,
    employee_id text,
    branch_id bigint NOT NULL,
    violation_id text,
    what_happened jsonb NOT NULL,
    witness_details jsonb,
    report_type text DEFAULT 'employee_related'::text NOT NULL,
    reports_to_user_ids uuid[] DEFAULT ARRAY[]::uuid[] NOT NULL,
    claims_status text,
    claimed_user_id uuid,
    resolution_status public.resolution_status DEFAULT 'reported'::public.resolution_status NOT NULL,
    user_statuses jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    updated_by uuid,
    attachments jsonb DEFAULT '[]'::jsonb,
    investigation_report jsonb,
    related_party jsonb,
    resolution_report jsonb
);


--
-- Name: TABLE incidents; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.incidents IS 'Stores incident reports submitted by employees and other incident types';


--
-- Name: COLUMN incidents.id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.incidents.id IS 'Unique identifier for incident (INS1, INS2, etc.)';


--
-- Name: COLUMN incidents.incident_type_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.incidents.incident_type_id IS 'Type of incident (references incident_types table)';


--
-- Name: COLUMN incidents.employee_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.incidents.employee_id IS 'Employee ID - NULL for non-employee incidents (Customer, Maintenance, Vendor, Vehicle, Government, Other)';


--
-- Name: COLUMN incidents.branch_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.incidents.branch_id IS 'Branch where incident occurred';


--
-- Name: COLUMN incidents.violation_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.incidents.violation_id IS 'Violation ID - NULL for non-employee incidents';


--
-- Name: COLUMN incidents.what_happened; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.incidents.what_happened IS 'JSONB: Detailed description of what happened';


--
-- Name: COLUMN incidents.witness_details; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.incidents.witness_details IS 'JSONB: Information about witnesses';


--
-- Name: COLUMN incidents.report_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.incidents.report_type IS 'Type of report (e.g., employee_related)';


--
-- Name: COLUMN incidents.reports_to_user_ids; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.incidents.reports_to_user_ids IS 'Array of user IDs who should receive this incident report';


--
-- Name: COLUMN incidents.claims_status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.incidents.claims_status IS 'Status of claims related to the incident';


--
-- Name: COLUMN incidents.claimed_user_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.incidents.claimed_user_id IS 'User ID of person who claimed the incident';


--
-- Name: COLUMN incidents.resolution_status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.incidents.resolution_status IS 'Status: reported, claimed, or resolved';


--
-- Name: COLUMN incidents.user_statuses; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.incidents.user_statuses IS 'JSONB: Individual status for each user in reports_to_user_ids';


--
-- Name: COLUMN incidents.attachments; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.incidents.attachments IS 'JSONB array of attachments: [{url, name, type, size, uploaded_at}, ...]';


--
-- Name: COLUMN incidents.investigation_report; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.incidents.investigation_report IS 'Stores investigation report details as JSON';


--
-- Name: COLUMN incidents.related_party; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.incidents.related_party IS 'Stores related party details as JSONB. For customer incidents: {name, contact_number}. For other incidents: {details}';


--
-- Name: COLUMN incidents.resolution_report; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.incidents.resolution_report IS 'Stores resolution report as JSONB with content, resolved_by, resolved_by_name, and resolved_at';


--
-- Name: interface_permissions; Type: TABLE; Schema: public; Owner: -
--

