CREATE FUNCTION public.get_reminder_statistics(p_user_id uuid DEFAULT NULL::uuid, p_days integer DEFAULT 30) RETURNS TABLE(total_reminders bigint, reminders_today bigint, reminders_this_week bigint, reminders_this_month bigint, avg_hours_overdue numeric, most_overdue_task text)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  RETURN QUERY
  WITH stats AS (
    SELECT
      COUNT(*) as total,
      COUNT(*) FILTER (WHERE DATE(reminder_sent_at) = CURRENT_DATE) as today,
      COUNT(*) FILTER (WHERE reminder_sent_at >= CURRENT_DATE - INTERVAL '7 days') as week,
      COUNT(*) FILTER (WHERE reminder_sent_at >= CURRENT_DATE - INTERVAL '30 days') as month,
      AVG(hours_overdue) as avg_overdue
    FROM task_reminder_logs
    WHERE (p_user_id IS NULL OR assigned_to_user_id = p_user_id)
      AND reminder_sent_at >= CURRENT_DATE - (p_days || ' days')::INTERVAL
  ),
  most_overdue AS (
    SELECT task_title
    FROM task_reminder_logs
    WHERE (p_user_id IS NULL OR assigned_to_user_id = p_user_id)
    ORDER BY hours_overdue DESC NULLS LAST
    LIMIT 1
  )
  SELECT 
    COALESCE(s.total, 0),
    COALESCE(s.today, 0),
    COALESCE(s.week, 0),
    COALESCE(s.month, 0),
    ROUND(COALESCE(s.avg_overdue, 0), 1),
    COALESCE(m.task_title, 'N/A')
  FROM stats s
  CROSS JOIN most_overdue m;
END;
$$;


--
-- Name: FUNCTION get_reminder_statistics(p_user_id uuid, p_days integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.get_reminder_statistics(p_user_id uuid, p_days integer) IS 'Returns statistics about sent reminders for a user or all users';


--
-- Name: get_report_data(text, uuid[]); Type: FUNCTION; Schema: public; Owner: -
--

