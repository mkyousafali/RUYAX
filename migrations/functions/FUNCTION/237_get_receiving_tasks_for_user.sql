CREATE FUNCTION public.get_receiving_tasks_for_user(p_user_id uuid, p_completed_days integer DEFAULT 7) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_my_tasks json;
  v_team_tasks json;
  v_is_branch_manager boolean := false;
  v_employee_names json;
  v_cutoff timestamp;
BEGIN
  -- Calculate cutoff for completed tasks
  v_cutoff := NOW() - (p_completed_days || ' days')::interval;

  -- 1. Get user's own tasks: all pending + completed from last N days
  SELECT json_agg(t ORDER BY t.created_at DESC)
  INTO v_my_tasks
  FROM (
    SELECT id, title, description, priority, role_type, task_status, due_date,
           created_at, assigned_user_id, receiving_record_id, clearance_certificate_url,
           requires_original_bill_upload, requires_erp_reference
    FROM receiving_tasks
    WHERE assigned_user_id = p_user_id
      AND (task_status != 'completed' OR created_at >= v_cutoff)
  ) t;

  -- Default to empty array
  IF v_my_tasks IS NULL THEN
    v_my_tasks := '[]'::json;
  END IF;

  -- 2. Check if user is branch manager
  SELECT EXISTS (
    SELECT 1 FROM receiving_tasks
    WHERE assigned_user_id = p_user_id AND role_type = 'branch_manager'
    LIMIT 1
  ) INTO v_is_branch_manager;

  -- 3. If branch manager, load team tasks (shelf_stocker + night_supervisor)
  -- All pending tasks (no time limit) + completed from last N days
  IF v_is_branch_manager THEN
    SELECT json_agg(t ORDER BY t.created_at DESC)
    INTO v_team_tasks
    FROM (
      SELECT rt.id, rt.title, rt.description, rt.priority, rt.role_type, rt.task_status,
             rt.due_date, rt.created_at, rt.assigned_user_id, rt.receiving_record_id,
             rt.clearance_certificate_url, rt.completion_photo_url, rt.completed_at
      FROM receiving_tasks rt
      WHERE rt.receiving_record_id IN (
        SELECT DISTINCT receiving_record_id
        FROM receiving_tasks
        WHERE assigned_user_id = p_user_id
      )
      AND rt.role_type IN ('shelf_stocker', 'night_supervisor')
      AND (rt.task_status != 'completed' OR rt.created_at >= v_cutoff)
    ) t;

    IF v_team_tasks IS NULL THEN
      v_team_tasks := '[]'::json;
    END IF;

    -- 4. Resolve employee names for team task users
    SELECT json_agg(json_build_object('user_id', e.user_id, 'name_en', COALESCE(e.name_en, e.name_ar, 'Unknown'), 'name_ar', COALESCE(e.name_ar, e.name_en, '╪║┘è╪▒ ┘à╪╣╪▒┘ê┘ü')))
    INTO v_employee_names
    FROM hr_employee_master e
    WHERE e.user_id IN (
      SELECT DISTINCT rt.assigned_user_id
      FROM receiving_tasks rt
      WHERE rt.receiving_record_id IN (
        SELECT DISTINCT receiving_record_id
        FROM receiving_tasks
        WHERE assigned_user_id = p_user_id
      )
      AND rt.role_type IN ('shelf_stocker', 'night_supervisor')
      AND rt.assigned_user_id IS NOT NULL
    );

    IF v_employee_names IS NULL THEN
      v_employee_names := '[]'::json;
    END IF;
  ELSE
    v_team_tasks := '[]'::json;
    v_employee_names := '[]'::json;
  END IF;

  RETURN json_build_object(
    'my_tasks', v_my_tasks,
    'team_tasks', v_team_tasks,
    'is_branch_manager', v_is_branch_manager,
    'employee_names', v_employee_names
  );
END;
$$;


--
-- Name: get_reminder_statistics(uuid, integer); Type: FUNCTION; Schema: public; Owner: -
--

