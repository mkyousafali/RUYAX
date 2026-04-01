CREATE TABLE public.quick_task_completions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    quick_task_id uuid NOT NULL,
    assignment_id uuid NOT NULL,
    completed_by_user_id uuid NOT NULL,
    completion_notes text,
    photo_path text,
    erp_reference character varying(255),
    completion_status character varying(50) DEFAULT 'submitted'::character varying NOT NULL,
    verified_by_user_id uuid,
    verified_at timestamp with time zone,
    verification_notes text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT chk_completion_status_valid CHECK (((completion_status)::text = ANY (ARRAY[('submitted'::character varying)::text, ('verified'::character varying)::text, ('rejected'::character varying)::text, ('pending_review'::character varying)::text]))),
    CONSTRAINT chk_verified_at_when_verified CHECK (((((completion_status)::text <> 'verified'::text) AND (verified_at IS NULL)) OR (((completion_status)::text = 'verified'::text) AND (verified_at IS NOT NULL))))
);


--
-- Name: TABLE quick_task_completions; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.quick_task_completions IS 'Completion records for quick tasks with photos and verification';


--
-- Name: COLUMN quick_task_completions.id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.quick_task_completions.id IS 'Unique identifier for the completion record';


--
-- Name: COLUMN quick_task_completions.quick_task_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.quick_task_completions.quick_task_id IS 'Reference to the quick task that was completed';


--
-- Name: COLUMN quick_task_completions.assignment_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.quick_task_completions.assignment_id IS 'Reference to the specific assignment that was completed';


--
-- Name: COLUMN quick_task_completions.completed_by_user_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.quick_task_completions.completed_by_user_id IS 'User who completed the task';


--
-- Name: COLUMN quick_task_completions.completion_notes; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.quick_task_completions.completion_notes IS 'Notes provided by the user upon completion';


--
-- Name: COLUMN quick_task_completions.photo_path; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.quick_task_completions.photo_path IS 'Path to the completion photo in storage';


--
-- Name: COLUMN quick_task_completions.erp_reference; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.quick_task_completions.erp_reference IS 'ERP system reference number if required';


--
-- Name: COLUMN quick_task_completions.completion_status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.quick_task_completions.completion_status IS 'Status of the completion record';


--
-- Name: COLUMN quick_task_completions.verified_by_user_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.quick_task_completions.verified_by_user_id IS 'User who verified the completion';


--
-- Name: COLUMN quick_task_completions.verified_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.quick_task_completions.verified_at IS 'When the completion was verified';


--
-- Name: COLUMN quick_task_completions.verification_notes; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.quick_task_completions.verification_notes IS 'Notes from the verifier';


--
-- Name: quick_tasks; Type: TABLE; Schema: public; Owner: -
--

