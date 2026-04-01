CREATE FUNCTION public.get_incomplete_tasks() RETURNS json
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
    SELECT json_agg(row_to_json(t) ORDER BY t.assigned_date DESC) as tasks_arr
    FROM (
      -- Task Assignments (incomplete)
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
        ta.notes
      FROM task_assignments ta
      LEFT JOIN tasks tk ON tk.id = ta.task_id
      LEFT JOIN branches b ON b.id = ta.assigned_to_branch_id
      LEFT JOIN users u_to ON u_to.id = ta.assigned_to_user_id
      LEFT JOIN users u_by ON u_by.id = ta.assigned_by
      LEFT JOIN hr_employee_master e_to ON e_to.user_id = ta.assigned_to_user_id
      WHERE ta.status NOT IN ('completed', 'cancelled')

      UNION ALL

      -- Quick Task Assignments (incomplete)
      SELECT
        qta.id,
        'quick' as task_type,
        COALESCE(qt.title, 'Quick Task #' || LEFT(qta.id::text, 8)) as task_title,
        COALESCE(qt.description, '') as task_description,
        qta.status,
        COALESCE(qt.priority, 'medium') as priority,
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
        NULL as notes
      FROM quick_task_assignments qta
      JOIN quick_tasks qt ON qt.id = qta.quick_task_id
      LEFT JOIN branches b ON b.id = qt.assigned_to_branch_id
      LEFT JOIN users u_to ON u_to.id = qta.assigned_to_user_id
      LEFT JOIN users u_by ON u_by.id = qt.assigned_by
      LEFT JOIN hr_employee_master e_to ON e_to.user_id = qta.assigned_to_user_id
      WHERE qta.status NOT IN ('completed', 'cancelled')

      UNION ALL

      -- Receiving Tasks (incomplete)
      SELECT
        rt.id,
        'receiving' as task_type,
        COALESCE(rt.title, 'Receiving Task #' || LEFT(rt.id::text, 8)) as task_title,
        COALESCE(rt.description, '') as task_description,
        rt.task_status as status,
        COALESCE(rt.priority, 'medium') as priority,
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
        rt.completion_notes as notes
      FROM receiving_tasks rt
      LEFT JOIN receiving_records rr ON rr.id = rt.receiving_record_id
      LEFT JOIN branches b ON b.id = rr.branch_id
      LEFT JOIN users u_to ON u_to.id = rt.assigned_user_id
      LEFT JOIN users u_by ON u_by.id = rr.user_id
      LEFT JOIN hr_employee_master e_to ON e_to.user_id = rt.assigned_user_id
      WHERE rt.task_status NOT IN ('completed', 'cancelled')
    ) t
  ) sub;

  RETURN v_result;
END;
$$;


--
-- Name: get_issue_pv_vouchers(text, bigint); Type: FUNCTION; Schema: public; Owner: -
--

