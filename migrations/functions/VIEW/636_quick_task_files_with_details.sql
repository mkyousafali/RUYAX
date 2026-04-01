CREATE VIEW public.quick_task_files_with_details AS
 SELECT qtf.id,
    qtf.quick_task_id,
    qtf.file_name,
    qtf.file_type,
    qtf.file_size,
    qtf.mime_type,
    qtf.storage_path,
    qtf.storage_bucket,
    qtf.uploaded_by,
    qtf.uploaded_at,
    qt.title AS task_title,
    qt.status AS task_status,
    u.username AS uploaded_by_username,
    he.name AS uploaded_by_name
   FROM (((public.quick_task_files qtf
     LEFT JOIN public.quick_tasks qt ON ((qtf.quick_task_id = qt.id)))
     LEFT JOIN public.users u ON ((qtf.uploaded_by = u.id)))
     LEFT JOIN public.hr_employees he ON ((u.employee_id = he.id)));


--
-- Name: quick_task_user_preferences; Type: TABLE; Schema: public; Owner: -
--

