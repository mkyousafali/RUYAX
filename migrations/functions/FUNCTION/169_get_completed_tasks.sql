CREATE FUNCTION public.get_completed_tasks(p_limit integer DEFAULT 500) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_result json;
BEGIN
  SELECT json_build_object(
    'tasks', COALESCE(tasks_arr, '[]'::json),
    'total_count', COALESCE(json_array_length(tasks_arr), 0)
  ) INTO v_result
  FROM (
    SELECT json_agg(row_to_json(t)) as tasks_arr
    FROM (
      SELECT * FROM (
      -- Task Assignments (completed)
      SELECT
        ta.id,
        'regular' as task_type,
        COALESCE(tk.title, 'Task Assignment #' || LEFT(ta.id::text, 8)) as task_title,
        COALESCE(tk.description, '') as task_description,
        ta.status,
        COALESCE(ta.priority_override, tk.priority, 'medium') as priority,
        COALESCE(b.name_en, 'No Branch') as branch_name,
        COALESCE(b.name_ar, b.name_en, 'No Branch') as branch_name_ar,
        ta.assigned_to_branch_id as branch_id,
        COALESCE(u_to.username, 'Unassigned') as assigned_to_name,
        COALESCE(e_to.name_en, u_to.username, 'Unassigned') as assigned_to_name_en,
        COALESCE(e_to.name_ar, e_to.name_en, u_to.username, 'Unassigned') as assigned_to_name_ar,
        ta.assigned_to_user_id,
        COALESCE(u_by.username, 'System') as assigned_by_name,
        ta.assigned_at as assigned_date,
        COALESCE(ta.deadline_datetime::text, ta.deadline_date::text) as deadline,
        ta.completed_at as completed_date,
        ta.notes,
        ROUND(EXTRACT(EPOCH FROM (ta.completed_at - ta.assigned_at)) / 3600, 1) as completion_hours,
        tc.completion_photo_url as completion_photo_url,
        tc.completion_notes as completion_notes_detail,
        tc.completed_by_name as completed_by_name,
        tc.erp_reference_number as erp_reference
      FROM task_assignments ta
      LEFT JOIN tasks tk ON tk.id = ta.task_id
      LEFT JOIN branches b ON b.id = ta.assigned_to_branch_id
      LEFT JOIN users u_to ON u_to.id = ta.assigned_to_user_id
      LEFT JOIN users u_by ON u_by.id = ta.assigned_by
      LEFT JOIN hr_employee_master e_to ON e_to.user_id = ta.assigned_to_user_id
      LEFT JOIN LATERAL (
        SELECT tc2.completion_photo_url, tc2.completion_notes, tc2.completed_by_name, tc2.erp_reference_number
        FROM task_completions tc2
        WHERE tc2.assignment_id = ta.id
        ORDER BY tc2.completed_at DESC
        LIMIT 1
      ) tc ON true
      WHERE ta.status = 'completed'

      UNION ALL

      -- Quick Task Assignments (completed)
      SELECT
        qta.id,
        'quick' as task_type,
        COALESCE(qt.title, 'Quick Task #' || LEFT(qta.id::text, 8)) as task_title,
        COALESCE(qt.description, '') as task_description,
        qta.status::text,
        COALESCE(qt.priority::text, 'medium') as priority,
        COALESCE(b.name_en, 'No Branch') as branch_name,
        COALESCE(b.name_ar, b.name_en, 'No Branch') as branch_name_ar,
        qt.assigned_to_branch_id as branch_id,
        COALESCE(u_to.username, 'Unassigned') as assigned_to_name,
        COALESCE(e_to.name_en, u_to.username, 'Unassigned') as assigned_to_name_en,
        COALESCE(e_to.name_ar, e_to.name_en, u_to.username, 'Unassigned') as assigned_to_name_ar,
        qta.assigned_to_user_id,
        COALESCE(u_by.username, 'System') as assigned_by_name,
        qta.created_at as assigned_date,
        qt.deadline_datetime::text as deadline,
        qta.completed_at as completed_date,
        NULL as notes,
        ROUND(EXTRACT(EPOCH FROM (qta.completed_at - qta.created_at)) / 3600, 1) as completion_hours,
        qtc.photo_path as completion_photo_url,
        qtc.completion_notes as completion_notes_detail,
        NULL as completed_by_name,
        qtc.erp_reference as erp_reference
      FROM quick_task_assignments qta
      JOIN quick_tasks qt ON qt.id = qta.quick_task_id
      LEFT JOIN branches b ON b.id = qt.assigned_to_branch_id
      LEFT JOIN users u_to ON u_to.id = qta.assigned_to_user_id
      LEFT JOIN users u_by ON u_by.id = qt.assigned_by
      LEFT JOIN hr_employee_master e_to ON e_to.user_id = qta.assigned_to_user_id
      LEFT JOIN LATERAL (
        SELECT qtc2.photo_path, qtc2.completion_notes, qtc2.erp_reference
        FROM quick_task_completions qtc2
        WHERE qtc2.assignment_id = qta.id
        ORDER BY qtc2.created_at DESC
        LIMIT 1
      ) qtc ON true
      WHERE qta.status = 'completed'

      UNION ALL

      -- Receiving Tasks (completed)
      SELECT
        rt.id,
        'receiving' as task_type,
        COALESCE(rt.title, 'Receiving Task #' || LEFT(rt.id::text, 8)) as task_title,
        COALESCE(rt.description, '') as task_description,
        rt.task_status::text as status,
        COALESCE(rt.priority::text, 'medium') as priority,
        COALESCE(b.name_en, 'No Branch') as branch_name,
        COALESCE(b.name_ar, b.name_en, 'No Branch') as branch_name_ar,
        rr.branch_id as branch_id,
        COALESCE(u_to.username, 'Unassigned') as assigned_to_name,
        COALESCE(e_to.name_en, u_to.username, 'Unassigned') as assigned_to_name_en,
        COALESCE(e_to.name_ar, e_to.name_en, u_to.username, 'Unassigned') as assigned_to_name_ar,
        rt.assigned_user_id as assigned_to_user_id,
        COALESCE(u_by.username, 'System') as assigned_by_name,
        rt.created_at as assigned_date,
        rt.due_date::text as deadline,
        rt.completed_at as completed_date,
        rt.completion_notes as notes,
        ROUND(EXTRACT(EPOCH FROM (rt.completed_at - rt.created_at)) / 3600, 1) as completion_hours,
        rt.completion_photo_url as completion_photo_url,
        rt.completion_notes as completion_notes_detail,
        NULL as completed_by_name,
        NULL as erp_reference
      FROM receiving_tasks rt
      LEFT JOIN receiving_records rr ON rr.id = rt.receiving_record_id
      LEFT JOIN branches b ON b.id = rr.branch_id
      LEFT JOIN users u_to ON u_to.id = rt.assigned_user_id
      LEFT JOIN users u_by ON u_by.id = rr.user_id
      LEFT JOIN hr_employee_master e_to ON e_to.user_id = rt.assigned_user_id
      WHERE rt.task_status = 'completed'
      ) all_tasks
      ORDER BY completed_date DESC
      LIMIT p_limit
    ) t
  ) sub;

  RETURN v_result;
END;
$$;


--
-- Name: get_contact_broadcast_stats(text); Type: FUNCTION; Schema: public; Owner: -
--

