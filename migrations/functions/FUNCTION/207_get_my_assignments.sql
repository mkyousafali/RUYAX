CREATE FUNCTION public.get_my_assignments(p_user_id uuid, p_limit integer DEFAULT 500) RETURNS json
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
      -- Regular Task Assignments (assigned by this user)
      SELECT
        ta.id,
        'regular' as task_type,
        COALESCE(tk.title, 'Task #' || LEFT(ta.id::text, 8)) as task_title,
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
        ta.assigned_by as assigned_by_id,
        ta.assigned_at as assigned_date,
        COALESCE(ta.deadline_datetime::text, ta.deadline_date::text) as deadline,
        ta.completed_at as completed_date,
        ta.notes,
        CASE WHEN ta.status = 'completed' AND ta.completed_at IS NOT NULL AND ta.assigned_at IS NOT NULL
          THEN ROUND(EXTRACT(EPOCH FROM (ta.completed_at - ta.assigned_at)) / 3600, 1)
          ELSE NULL
        END as completion_hours,
        NULL as price_tag,
        NULL as issue_type
      FROM task_assignments ta
      LEFT JOIN tasks tk ON tk.id = ta.task_id
      LEFT JOIN branches b ON b.id = ta.assigned_to_branch_id
      LEFT JOIN users u_to ON u_to.id = ta.assigned_to_user_id
      LEFT JOIN users u_by ON u_by.id = ta.assigned_by
      LEFT JOIN hr_employee_master e_to ON e_to.user_id = ta.assigned_to_user_id
      WHERE ta.assigned_by = p_user_id

      UNION ALL

      -- Quick Task Assignments (assigned by this user)
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
        qt.assigned_by as assigned_by_id,
        qta.created_at as assigned_date,
        qt.deadline_datetime::text as deadline,
        qta.completed_at as completed_date,
        NULL as notes,
        CASE WHEN qta.status = 'completed' AND qta.completed_at IS NOT NULL
          THEN ROUND(EXTRACT(EPOCH FROM (qta.completed_at - qta.created_at)) / 3600, 1)
          ELSE NULL
        END as completion_hours,
        qt.price_tag,
        qt.issue_type
      FROM quick_task_assignments qta
      JOIN quick_tasks qt ON qt.id = qta.quick_task_id
      LEFT JOIN branches b ON b.id = qt.assigned_to_branch_id
      LEFT JOIN users u_to ON u_to.id = qta.assigned_to_user_id
      LEFT JOIN users u_by ON u_by.id = qt.assigned_by
      LEFT JOIN hr_employee_master e_to ON e_to.user_id = qta.assigned_to_user_id
      WHERE qt.assigned_by = p_user_id
      ) all_tasks
      ORDER BY assigned_date DESC
      LIMIT p_limit
    ) t
  ) sub;

  RETURN v_result;
END;
$$;


--
-- Name: get_my_tasks(uuid, boolean, integer); Type: FUNCTION; Schema: public; Owner: -
--

