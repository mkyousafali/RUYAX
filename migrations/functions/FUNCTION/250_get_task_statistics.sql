CREATE FUNCTION public.get_task_statistics(user_id uuid DEFAULT NULL::uuid) RETURNS TABLE(total_tasks bigint, pending_tasks bigint, in_progress_tasks bigint, completed_tasks bigint, overdue_tasks bigint)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        COUNT(*)::BIGINT as total_tasks,
        COUNT(CASE WHEN t.status = 'pending' THEN 1 END)::BIGINT as pending_tasks,
        COUNT(CASE WHEN t.status = 'in_progress' THEN 1 END)::BIGINT as in_progress_tasks,
        COUNT(CASE WHEN t.status = 'completed' THEN 1 END)::BIGINT as completed_tasks,
        COUNT(CASE WHEN t.status = 'overdue' THEN 1 END)::BIGINT as overdue_tasks
    FROM tasks t
    LEFT JOIN task_assignments ta ON t.id = ta.task_id
    WHERE (user_id IS NULL OR ta.assigned_to = user_id OR t.created_by = user_id)
      AND t.deleted_at IS NULL;
END;
$$;


--
-- Name: get_tasks_for_receiving_record(uuid); Type: FUNCTION; Schema: public; Owner: -
--

