CREATE VIEW public.task_completion_summary AS
 SELECT tc.id AS completion_id,
    tc.task_id,
    t.title AS task_title,
    t.priority AS task_priority,
    tc.assignment_id,
    tc.completed_by,
    tc.completed_by_name,
    tc.completed_by_branch_id,
    b.name_en AS branch_name,
    tc.task_finished_completed,
    tc.photo_uploaded_completed,
    tc.completion_photo_url,
    tc.erp_reference_completed,
    tc.erp_reference_number,
    tc.completion_notes,
    tc.verified_by,
    tc.verified_at,
    tc.verification_notes,
    tc.completed_at,
    round((((((
        CASE
            WHEN tc.task_finished_completed THEN 1
            ELSE 0
        END +
        CASE
            WHEN tc.photo_uploaded_completed THEN 1
            ELSE 0
        END) +
        CASE
            WHEN tc.erp_reference_completed THEN 1
            ELSE 0
        END))::numeric * 100.0) / (3)::numeric), 2) AS completion_percentage,
    ((tc.task_finished_completed = true) AND (tc.photo_uploaded_completed = true) AND (tc.erp_reference_completed = true)) AS is_fully_completed
   FROM ((public.task_completions tc
     JOIN public.tasks t ON ((tc.task_id = t.id)))
     LEFT JOIN public.branches b ON (((tc.completed_by_branch_id)::text = (b.id)::text)))
  ORDER BY tc.completed_at DESC;


--
-- Name: task_reminder_logs; Type: TABLE; Schema: public; Owner: -
--

