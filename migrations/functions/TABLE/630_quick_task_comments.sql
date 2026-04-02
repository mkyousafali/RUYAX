CREATE TABLE public.quick_task_comments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    quick_task_id uuid NOT NULL,
    comment text NOT NULL,
    comment_type character varying(50) DEFAULT 'comment'::character varying,
    created_by uuid,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: quick_task_completions; Type: TABLE; Schema: public; Owner: -
--

