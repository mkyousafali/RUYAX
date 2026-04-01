CREATE VIEW public.quick_tasks_with_details AS
 SELECT qt.id,
    qt.title,
    qt.description,
    qt.price_tag,
    qt.issue_type,
    qt.priority,
    qt.assigned_by,
    qt.assigned_to_branch_id,
    qt.created_at,
    qt.deadline_datetime,
    qt.completed_at,
    qt.status,
    qt.created_from,
    qt.updated_at,
    u_assigned_by.username AS assigned_by_username,
    he_assigned_by.name AS assigned_by_name,
    b.name_en AS branch_name,
    b.name_ar AS branch_name_ar,
    count(qta.id) AS total_assignments,
    count(
        CASE
            WHEN ((qta.status)::text = 'completed'::text) THEN 1
            ELSE NULL::integer
        END) AS completed_assignments,
    count(
        CASE
            WHEN ((qta.status)::text = 'overdue'::text) THEN 1
            ELSE NULL::integer
        END) AS overdue_assignments
   FROM ((((public.quick_tasks qt
     LEFT JOIN public.users u_assigned_by ON ((qt.assigned_by = u_assigned_by.id)))
     LEFT JOIN public.hr_employees he_assigned_by ON ((u_assigned_by.employee_id = he_assigned_by.id)))
     LEFT JOIN public.branches b ON ((qt.assigned_to_branch_id = b.id)))
     LEFT JOIN public.quick_task_assignments qta ON ((qt.id = qta.quick_task_id)))
  GROUP BY qt.id, qt.title, qt.description, qt.price_tag, qt.issue_type, qt.priority, qt.assigned_by, qt.assigned_to_branch_id, qt.created_at, qt.deadline_datetime, qt.completed_at, qt.status, qt.created_from, qt.updated_at, u_assigned_by.username, he_assigned_by.name, b.name_en, b.name_ar;


--
-- Name: receiving_records; Type: TABLE; Schema: public; Owner: -
--

