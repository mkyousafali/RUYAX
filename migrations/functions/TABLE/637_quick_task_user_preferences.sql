CREATE TABLE public.quick_task_user_preferences (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    default_branch_id bigint,
    default_price_tag character varying(50),
    default_issue_type character varying(100),
    default_priority character varying(50),
    selected_user_ids uuid[],
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: quick_tasks_with_details; Type: VIEW; Schema: public; Owner: -
--

