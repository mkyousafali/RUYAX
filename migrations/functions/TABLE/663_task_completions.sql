CREATE TABLE public.task_completions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    task_id uuid NOT NULL,
    assignment_id uuid NOT NULL,
    completed_by text NOT NULL,
    completed_by_name text,
    completed_by_branch_id uuid,
    task_finished_completed boolean DEFAULT false,
    photo_uploaded_completed boolean DEFAULT false,
    erp_reference_completed boolean DEFAULT false,
    erp_reference_number text,
    completion_notes text,
    verified_by text,
    verified_at timestamp with time zone,
    verification_notes text,
    completed_at timestamp with time zone DEFAULT now(),
    created_at timestamp with time zone DEFAULT now(),
    completion_photo_url text,
    CONSTRAINT chk_photo_url_consistency CHECK (((photo_uploaded_completed = false) OR (completion_photo_url IS NOT NULL)))
);


--
-- Name: TABLE task_completions; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.task_completions IS 'Individual user task completion records';


--
-- Name: COLUMN task_completions.completion_photo_url; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.task_completions.completion_photo_url IS 'URL of the uploaded completion photo stored in completion-photos bucket';


--
-- Name: tasks; Type: TABLE; Schema: public; Owner: -
--

