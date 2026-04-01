CREATE TABLE public.task_images (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    task_id uuid NOT NULL,
    file_name text NOT NULL,
    file_size bigint NOT NULL,
    file_type text NOT NULL,
    file_url text NOT NULL,
    image_type text NOT NULL,
    uploaded_by text NOT NULL,
    uploaded_by_name text,
    created_at timestamp with time zone DEFAULT now(),
    image_width integer,
    image_height integer,
    file_path text,
    attachment_type text DEFAULT 'task_creation'::text,
    CONSTRAINT task_images_attachment_type_check CHECK ((attachment_type = ANY (ARRAY['task_creation'::text, 'task_completion'::text])))
);


--
-- Name: TABLE task_images; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.task_images IS 'Task creation images and completion photos';


--
-- Name: task_attachments; Type: VIEW; Schema: public; Owner: -
--

