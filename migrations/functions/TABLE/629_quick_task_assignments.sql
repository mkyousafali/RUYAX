CREATE TABLE public.quick_task_assignments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    quick_task_id uuid NOT NULL,
    assigned_to_user_id uuid NOT NULL,
    status character varying(50) DEFAULT 'pending'::character varying,
    accepted_at timestamp with time zone,
    started_at timestamp with time zone,
    completed_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    require_task_finished boolean DEFAULT true,
    require_photo_upload boolean DEFAULT true,
    require_erp_reference boolean DEFAULT false,
    CONSTRAINT chk_require_task_finished_not_null CHECK ((require_task_finished IS NOT NULL))
);


--
-- Name: COLUMN quick_task_assignments.require_task_finished; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.quick_task_assignments.require_task_finished IS 'Whether task completion checkbox is required';


--
-- Name: COLUMN quick_task_assignments.require_photo_upload; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.quick_task_assignments.require_photo_upload IS 'Whether photo upload is required for task completion';


--
-- Name: COLUMN quick_task_assignments.require_erp_reference; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.quick_task_assignments.require_erp_reference IS 'Whether ERP reference number is required for task completion';


--
-- Name: quick_task_comments; Type: TABLE; Schema: public; Owner: -
--

