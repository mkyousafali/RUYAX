CREATE TABLE public.tasks (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    title text NOT NULL,
    description text,
    require_task_finished boolean DEFAULT false,
    require_photo_upload boolean DEFAULT false,
    require_erp_reference boolean DEFAULT false,
    can_escalate boolean DEFAULT false,
    can_reassign boolean DEFAULT false,
    created_by text NOT NULL,
    created_by_name text,
    created_by_role text,
    status text DEFAULT 'draft'::text,
    priority text DEFAULT 'medium'::text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    deleted_at timestamp with time zone,
    due_date date,
    due_time time without time zone,
    due_datetime timestamp with time zone,
    search_vector tsvector GENERATED ALWAYS AS (to_tsvector('english'::regconfig, ((title || ' '::text) || COALESCE(description, ''::text)))) STORED,
    metadata jsonb,
    CONSTRAINT tasks_priority_check CHECK ((priority = ANY (ARRAY['low'::text, 'medium'::text, 'high'::text])))
);


--
-- Name: TABLE tasks; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.tasks IS 'Main task information and metadata';


--
-- Name: COLUMN tasks.metadata; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.tasks.metadata IS 'JSONB field to store task-specific metadata like payment_schedule_id, payment_type, etc.';


--
-- Name: task_completion_summary; Type: VIEW; Schema: public; Owner: -
--

