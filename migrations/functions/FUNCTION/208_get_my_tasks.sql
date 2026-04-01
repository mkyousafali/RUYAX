CREATE FUNCTION public.get_my_tasks(p_user_id uuid, p_include_completed boolean DEFAULT false, p_limit integer DEFAULT 500) RETURNS json
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
      -- Regular Task Assignments (assigned TO this user)
      SELECT
        ta.task_id as id,
        'regular' as task_type,
        COALESCE(tk.title, 'Task #' || LEFT(ta.id::text, 8)) as title,
        COALESCE(tk.description, '') as description,
        COALESCE(ta.priority_override, tk.priority, 'medium') as priority,
        COALESCE(tk.status, 'pending') as status,
        ta.status as assignment_status,
        ta.id as assignment_id,
        ta.assigned_at,
        COALESCE(ta.deadline_datetime::text, ta.deadline_date::text) as deadline_datetime,
        ta.assigned_by,
        COALESCE(u_by.username, 'Unknown') as assigned_by_name,
        ta.assigned_to_user_id,
        COALESCE(b.name_en, 'No Branch') as branch_name,
        COALESCE(b.name_ar, b.name_en, 'No Branch') as branch_name_ar,
        COALESCE(e_to.name_en, u_to.username, 'You') as assigned_to_name_en,
        COALESCE(e_to.name_ar, e_to.name_en, u_to.username, '╪ú┘å╪¬') as assigned_to_name_ar,
        tk.created_at,
        -- Completion requirements
        false as require_task_finished,
        false as require_photo_upload,
        false as require_erp_reference,
        -- Quick task extras
        NULL::text as issue_type,
        NULL::text as incident_id,
        NULL::uuid as product_request_id,
        NULL::text as product_request_type,
        NULL::text as price_tag,
        -- Receiving extras
        NULL::text as role_type,
        NULL::uuid as receiving_record_id,
        NULL::text as clearance_certificate_url,
        ta.completed_at
      FROM task_assignments ta
      LEFT JOIN tasks tk ON tk.id = ta.task_id
      LEFT JOIN branches b ON b.id = ta.assigned_to_branch_id
      LEFT JOIN users u_by ON u_by.id = ta.assigned_by
      LEFT JOIN users u_to ON u_to.id = ta.assigned_to_user_id
      LEFT JOIN hr_employee_master e_to ON e_to.user_id = ta.assigned_to_user_id
      WHERE ta.assigned_to_user_id = p_user_id
        AND (p_include_completed OR ta.status NOT IN ('completed', 'cancelled'))

      UNION ALL

      -- Quick Task Assignments (assigned TO this user)
      SELECT
        qt.id as id,
        'quick_task' as task_type,
        COALESCE(qt.title, 'Quick Task #' || LEFT(qta.id::text, 8)) as title,
        COALESCE(qt.description, '') as description,
        COALESCE(qt.priority::text, 'medium') as priority,
        COALESCE(qt.status, 'pending') as status,
        qta.status::text as assignment_status,
        qta.id as assignment_id,
        qta.created_at as assigned_at,
        qt.deadline_datetime::text as deadline_datetime,
        qt.assigned_by,
        COALESCE(u_by.username, 'Unknown') as assigned_by_name,
        qta.assigned_to_user_id,
        COALESCE(b.name_en, 'No Branch') as branch_name,
        COALESCE(b.name_ar, b.name_en, 'No Branch') as branch_name_ar,
        COALESCE(e_to.name_en, u_to.username, 'You') as assigned_to_name_en,
        COALESCE(e_to.name_ar, e_to.name_en, u_to.username, '╪ú┘å╪¬') as assigned_to_name_ar,
        qt.created_at,
        false as require_task_finished,
        false as require_photo_upload,
        false as require_erp_reference,
        qt.issue_type,
        qt.incident_id,
        qt.product_request_id,
        qt.product_request_type,
        qt.price_tag,
        NULL::text as role_type,
        NULL::uuid as receiving_record_id,
        NULL::text as clearance_certificate_url,
        qta.completed_at
      FROM quick_task_assignments qta
      JOIN quick_tasks qt ON qt.id = qta.quick_task_id
      LEFT JOIN branches b ON b.id = qt.assigned_to_branch_id
      LEFT JOIN users u_by ON u_by.id = qt.assigned_by
      LEFT JOIN users u_to ON u_to.id = qta.assigned_to_user_id
      LEFT JOIN hr_employee_master e_to ON e_to.user_id = qta.assigned_to_user_id
      WHERE qta.assigned_to_user_id = p_user_id
        AND (p_include_completed OR qta.status NOT IN ('completed', 'cancelled'))

      UNION ALL

      -- Receiving Tasks (assigned TO this user)
      SELECT
        rt.id as id,
        'receiving' as task_type,
        COALESCE(rt.title, 'Receiving Task #' || LEFT(rt.id::text, 8)) as title,
        COALESCE(rt.description, '') as description,
        COALESCE(rt.priority::text, 'medium') as priority,
        rt.task_status::text as status,
        rt.task_status::text as assignment_status,
        rt.id as assignment_id,
        rt.created_at as assigned_at,
        rt.due_date::text as deadline_datetime,
        rr.user_id as assigned_by,
        COALESCE(u_by.username, 'System (Receiving)') as assigned_by_name,
        rt.assigned_user_id as assigned_to_user_id,
        COALESCE(b.name_en, 'No Branch') as branch_name,
        COALESCE(b.name_ar, b.name_en, 'No Branch') as branch_name_ar,
        COALESCE(e_to.name_en, u_to.username, 'You') as assigned_to_name_en,
        COALESCE(e_to.name_ar, e_to.name_en, u_to.username, '╪ú┘å╪¬') as assigned_to_name_ar,
        rt.created_at,
        true as require_task_finished,
        COALESCE(rt.requires_original_bill_upload, false) as require_photo_upload,
        COALESCE(rt.requires_erp_reference, false) as require_erp_reference,
        NULL::text as issue_type,
        NULL::text as incident_id,
        NULL::uuid as product_request_id,
        NULL::text as product_request_type,
        NULL::text as price_tag,
        rt.role_type,
        rt.receiving_record_id,
        rt.clearance_certificate_url,
        rt.completed_at
      FROM receiving_tasks rt
      LEFT JOIN receiving_records rr ON rr.id = rt.receiving_record_id
      LEFT JOIN branches b ON b.id = rr.branch_id
      LEFT JOIN users u_by ON u_by.id = rr.user_id
      LEFT JOIN users u_to ON u_to.id = rt.assigned_user_id
      LEFT JOIN hr_employee_master e_to ON e_to.user_id = rt.assigned_user_id
      WHERE rt.assigned_user_id = p_user_id
        AND (p_include_completed OR rt.task_status NOT IN ('completed', 'cancelled'))
      ) all_tasks
      ORDER BY
        CASE WHEN assignment_status IN ('completed', 'cancelled') THEN 1 ELSE 0 END,
        assigned_at DESC
      LIMIT p_limit
    ) t
  ) sub;

  RETURN v_result;
END;
$$;


--
-- Name: get_next_delivery_tier(numeric); Type: FUNCTION; Schema: public; Owner: -
--

