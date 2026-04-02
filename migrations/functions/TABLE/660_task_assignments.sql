CREATE TABLE public.task_assignments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    task_id uuid NOT NULL,
    assignment_type text NOT NULL,
    assigned_to_user_id uuid,
    assigned_to_branch_id bigint,
    assigned_by uuid NOT NULL,
    assigned_by_name text,
    assigned_at timestamp with time zone DEFAULT now(),
    status text DEFAULT 'assigned'::text,
    started_at timestamp with time zone,
    completed_at timestamp with time zone,
    schedule_date date,
    schedule_time time without time zone,
    deadline_date date,
    deadline_time time without time zone,
    deadline_datetime timestamp with time zone,
    is_reassignable boolean DEFAULT true,
    is_recurring boolean DEFAULT false,
    recurring_pattern jsonb,
    notes text,
    priority_override text,
    require_task_finished boolean DEFAULT true,
    require_photo_upload boolean DEFAULT false,
    require_erp_reference boolean DEFAULT false,
    reassigned_from uuid,
    reassignment_reason text,
    reassigned_at timestamp with time zone,
    CONSTRAINT chk_deadline_consistency CHECK ((((deadline_date IS NULL) AND (deadline_time IS NULL)) OR (deadline_date IS NOT NULL))),
    CONSTRAINT chk_priority_override_valid CHECK (((priority_override IS NULL) OR (priority_override = ANY (ARRAY['low'::text, 'medium'::text, 'high'::text, 'urgent'::text])))),
    CONSTRAINT chk_schedule_consistency CHECK ((((schedule_date IS NULL) AND (schedule_time IS NULL)) OR (schedule_date IS NOT NULL)))
);


--
-- Name: TABLE task_assignments; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.task_assignments IS 'Task assignments to users, branches, or all';


--
-- Name: COLUMN task_assignments.schedule_date; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.task_assignments.schedule_date IS 'The date when the task should be started/executed';


--
-- Name: COLUMN task_assignments.schedule_time; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.task_assignments.schedule_time IS 'The time when the task should be started/executed';


--
-- Name: COLUMN task_assignments.deadline_date; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.task_assignments.deadline_date IS 'The date when the task must be completed';


--
-- Name: COLUMN task_assignments.deadline_time; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.task_assignments.deadline_time IS 'The time when the task must be completed';


--
-- Name: COLUMN task_assignments.deadline_datetime; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.task_assignments.deadline_datetime IS 'Computed timestamp combining deadline_date and deadline_time';


--
-- Name: COLUMN task_assignments.is_reassignable; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.task_assignments.is_reassignable IS 'Whether this assignment can be reassigned to another user';


--
-- Name: COLUMN task_assignments.is_recurring; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.task_assignments.is_recurring IS 'Whether this is a recurring assignment';


--
-- Name: COLUMN task_assignments.recurring_pattern; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.task_assignments.recurring_pattern IS 'JSON configuration for recurring patterns';


--
-- Name: COLUMN task_assignments.notes; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.task_assignments.notes IS 'Additional instructions or notes for the assignee';


--
-- Name: COLUMN task_assignments.priority_override; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.task_assignments.priority_override IS 'Override the task priority for this specific assignment';


--
-- Name: COLUMN task_assignments.require_task_finished; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.task_assignments.require_task_finished IS 'Whether task completion confirmation is required';


--
-- Name: COLUMN task_assignments.require_photo_upload; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.task_assignments.require_photo_upload IS 'Whether photo upload is required for completion';


--
-- Name: COLUMN task_assignments.require_erp_reference; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.task_assignments.require_erp_reference IS 'Whether ERP reference is required for completion';


--
-- Name: COLUMN task_assignments.reassigned_from; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.task_assignments.reassigned_from IS 'Reference to the original assignment if this is a reassignment';


--
-- Name: COLUMN task_assignments.reassignment_reason; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.task_assignments.reassignment_reason IS 'Reason for reassignment';


--
-- Name: task_images; Type: TABLE; Schema: public; Owner: -
--

