CREATE TABLE public.notifications (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    title character varying(255) NOT NULL,
    message text NOT NULL,
    created_by character varying(255) DEFAULT 'system'::character varying NOT NULL,
    created_by_name character varying(100) DEFAULT 'System'::character varying NOT NULL,
    created_by_role character varying(50) DEFAULT 'Admin'::character varying NOT NULL,
    target_users jsonb,
    target_roles jsonb,
    target_branches jsonb,
    scheduled_for timestamp with time zone,
    sent_at timestamp with time zone DEFAULT now(),
    expires_at timestamp with time zone,
    has_attachments boolean DEFAULT false NOT NULL,
    read_count integer DEFAULT 0 NOT NULL,
    total_recipients integer DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    metadata jsonb,
    task_id uuid,
    task_assignment_id uuid,
    priority character varying(20) DEFAULT 'medium'::character varying NOT NULL,
    status character varying(20) DEFAULT 'published'::character varying NOT NULL,
    target_type character varying(50) DEFAULT 'all_users'::character varying NOT NULL,
    type character varying(50) DEFAULT 'info'::character varying NOT NULL
);


--
-- Name: TABLE notifications; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.notifications IS 'Cache refresh timestamp: 2025-10-04 11:00:23.237041+00';


--
-- Name: COLUMN notifications.task_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.notifications.task_id IS 'Reference to the task this notification is about';


--
-- Name: COLUMN notifications.task_assignment_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.notifications.task_assignment_id IS 'Reference to the task assignment this notification is about';


--
-- Name: offer_bundles; Type: TABLE; Schema: public; Owner: -
--

