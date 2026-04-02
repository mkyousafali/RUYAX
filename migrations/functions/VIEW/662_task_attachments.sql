CREATE VIEW public.task_attachments AS
 SELECT task_images.id,
    task_images.task_id,
    task_images.file_name,
    task_images.file_url AS file_path,
    task_images.file_size,
    task_images.file_type,
    COALESCE(task_images.attachment_type, task_images.image_type, 'task_creation'::text) AS attachment_type,
    task_images.uploaded_by,
    task_images.uploaded_by_name,
    task_images.created_at
   FROM public.task_images;


--
-- Name: task_completions; Type: TABLE; Schema: public; Owner: -
--

