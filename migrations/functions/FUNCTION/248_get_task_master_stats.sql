CREATE FUNCTION public.get_task_master_stats(p_user_id uuid) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_result json;
  v_total_tasks bigint;
  v_completed_tasks bigint;
  v_incomplete_tasks bigint;
  v_my_assigned_tasks bigint;
  v_my_completed_tasks bigint;
  v_my_assignments bigint;
BEGIN
  -- Total tasks (all assignment types)
  SELECT
    (SELECT COUNT(*) FROM task_assignments) +
    (SELECT COUNT(*) FROM quick_task_assignments) +
    (SELECT COUNT(*) FROM receiving_tasks)
  INTO v_total_tasks;

  -- Completed tasks
  SELECT
    (SELECT COUNT(*) FROM task_completions) +
    (SELECT COUNT(*) FROM quick_task_completions) +
    (SELECT COUNT(*) FROM receiving_tasks WHERE task_status = 'completed')
  INTO v_completed_tasks;

  -- Incomplete tasks
  SELECT
    (SELECT COUNT(*) FROM task_assignments WHERE status NOT IN ('completed', 'closed')) +
    (SELECT COUNT(*) FROM quick_task_assignments WHERE status NOT IN ('completed', 'closed')) +
    (SELECT COUNT(*) FROM receiving_tasks WHERE task_status != 'completed' AND task_completed = false)
  INTO v_incomplete_tasks;

  -- My assigned tasks (active only)
  SELECT
    (SELECT COUNT(*) FROM task_assignments WHERE assigned_to_user_id = p_user_id AND status IN ('assigned', 'in_progress', 'pending')) +
    (SELECT COUNT(*) FROM quick_task_assignments WHERE assigned_to_user_id = p_user_id AND status IN ('assigned', 'in_progress', 'pending')) +
    (SELECT COUNT(*) FROM receiving_tasks WHERE assigned_user_id = p_user_id AND task_status IN ('pending', 'in_progress'))
  INTO v_my_assigned_tasks;

  -- My completed tasks
  SELECT
    (SELECT COUNT(*) FROM task_completions WHERE completed_by = p_user_id::text) +
    (SELECT COUNT(*) FROM quick_task_completions WHERE completed_by_user_id = p_user_id) +
    (SELECT COUNT(*) FROM receiving_tasks WHERE completed_by_user_id = p_user_id AND task_status = 'completed')
  INTO v_my_completed_tasks;

  -- My assignments (tasks I assigned to others)
  SELECT
    (SELECT COUNT(*) FROM task_assignments WHERE assigned_by = p_user_id) +
    (SELECT COUNT(*) FROM quick_tasks WHERE assigned_by = p_user_id)
  INTO v_my_assignments;

  v_result := json_build_object(
    'total_tasks', v_total_tasks,
    'completed_tasks', v_completed_tasks,
    'incomplete_tasks', v_incomplete_tasks,
    'my_assigned_tasks', v_my_assigned_tasks,
    'my_completed_tasks', v_my_completed_tasks,
    'my_assignments', v_my_assignments
  );

  RETURN v_result;
END;
$$;


--
-- Name: get_task_statistics(text); Type: FUNCTION; Schema: public; Owner: -
--

