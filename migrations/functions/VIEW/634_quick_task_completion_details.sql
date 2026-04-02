CREATE VIEW public.quick_task_completion_details AS
 SELECT qtc.id,
    qtc.quick_task_id,
    qt.title AS task_title,
    qt.description AS task_description,
    qtc.assignment_id,
    qtc.completed_by_user_id,
    u1.username AS completed_by_username,
    u1.username AS completed_by_name,
    qtc.completion_notes,
    qtc.photo_path,
    qtc.erp_reference,
    qtc.completion_status,
    qtc.verified_by_user_id,
    u2.username AS verified_by_username,
    u2.username AS verified_by_name,
    qtc.verified_at,
    qtc.verification_notes,
    qtc.created_at,
    qtc.updated_at,
    qta.require_photo_upload,
    qta.require_erp_reference,
    qta.require_task_finished
   FROM ((((public.quick_task_completions qtc
     JOIN public.quick_tasks qt ON ((qtc.quick_task_id = qt.id)))
     JOIN public.quick_task_assignments qta ON ((qtc.assignment_id = qta.id)))
     JOIN public.users u1 ON ((qtc.completed_by_user_id = u1.id)))
     LEFT JOIN public.users u2 ON ((qtc.verified_by_user_id = u2.id)))
  ORDER BY qtc.created_at DESC;


--
-- Name: quick_task_files; Type: TABLE; Schema: public; Owner: -
--

