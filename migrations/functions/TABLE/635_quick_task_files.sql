CREATE TABLE public.quick_task_files (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    quick_task_id uuid NOT NULL,
    file_name character varying(255) NOT NULL,
    file_type character varying(100),
    file_size integer,
    mime_type character varying(100),
    storage_path text NOT NULL,
    storage_bucket character varying(100) DEFAULT 'quick-task-files'::character varying,
    uploaded_by uuid,
    uploaded_at timestamp with time zone DEFAULT now()
);


--
-- Name: quick_task_files_with_details; Type: VIEW; Schema: public; Owner: -
--

