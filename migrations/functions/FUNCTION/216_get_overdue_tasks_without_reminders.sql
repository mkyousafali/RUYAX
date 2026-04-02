CREATE FUNCTION public.get_overdue_tasks_without_reminders() RETURNS TABLE(assignment_id uuid, task_id uuid, task_title text, assigned_to_user_id uuid, user_name character varying, deadline timestamp with time zone, hours_overdue numeric)
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
BEGIN
  RETURN QUERY
  SELECT 
    ta.id as assignment_id,
    t.id as task_id,
    t.title as task_title,
    ta.assigned_to_user_id,
    u.username as user_name,
    COALESCE(ta.deadline_datetime, ta.deadline_date, t.due_datetime) as deadline,
    EXTRACT(EPOCH FROM (NOW() - COALESCE(ta.deadline_datetime, ta.deadline_date, t.due_datetime))) / 3600 as hours_overdue
  FROM task_assignments ta
  JOIN tasks t ON t.id = ta.task_id
  JOIN users u ON u.id = ta.assigned_to_user_id
  LEFT JOIN task_completions tc ON tc.assignment_id = ta.id
  WHERE tc.id IS NULL  -- Not completed
    AND COALESCE(ta.deadline_datetime, ta.deadline_date, t.due_datetime) IS NOT NULL  -- Has deadline
    AND COALESCE(ta.deadline_datetime, ta.deadline_date, t.due_datetime) < NOW()  -- Overdue
    AND NOT EXISTS (  -- No reminder sent yet
      SELECT 1 FROM task_reminder_logs trl 
      WHERE trl.task_assignment_id = ta.id
    )
  ORDER BY hours_overdue DESC;
END;
$$;


--
-- Name: FUNCTION get_overdue_tasks_without_reminders(); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.get_overdue_tasks_without_reminders() IS 'Returns overdue tasks that havent received reminders yet - used by Edge Function';


--
-- Name: get_paid_expense_payments(date, date); Type: FUNCTION; Schema: public; Owner: -
--

