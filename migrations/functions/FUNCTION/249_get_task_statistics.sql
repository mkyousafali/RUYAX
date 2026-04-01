CREATE FUNCTION public.get_task_statistics(user_id_param text DEFAULT NULL::text) RETURNS TABLE(total_tasks bigint, active_tasks bigint, completed_tasks bigint, draft_tasks bigint, paused_tasks bigint, cancelled_tasks bigint, my_assigned_tasks bigint, my_completed_tasks bigint, overdue_tasks bigint, due_today bigint, high_priority_tasks bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        COUNT(*) FILTER (WHERE t.deleted_at IS NULL) as total_tasks,
        COUNT(*) FILTER (WHERE t.status = 'active' AND t.deleted_at IS NULL) as active_tasks,
        COUNT(*) FILTER (WHERE t.status = 'completed' AND t.deleted_at IS NULL) as completed_tasks,
        COUNT(*) FILTER (WHERE t.status = 'draft' AND t.deleted_at IS NULL) as draft_tasks,
        COUNT(*) FILTER (WHERE t.status = 'paused' AND t.deleted_at IS NULL) as paused_tasks,
        COUNT(*) FILTER (WHERE t.status = 'cancelled' AND t.deleted_at IS NULL) as cancelled_tasks,
        COUNT(DISTINCT ta.task_id) FILTER (WHERE (ta.assigned_to_user_id = user_id_param OR ta.assignment_type = 'all') AND t.deleted_at IS NULL) as my_assigned_tasks,
        COUNT(DISTINCT tc.task_id) FILTER (WHERE tc.completed_by = user_id_param AND t.deleted_at IS NULL) as my_completed_tasks,
        COUNT(*) FILTER (WHERE t.due_date < CURRENT_DATE AND t.status IN ('active', 'draft', 'paused') AND t.deleted_at IS NULL) as overdue_tasks,
        COUNT(*) FILTER (WHERE t.due_date = CURRENT_DATE AND t.status IN ('active', 'draft', 'paused') AND t.deleted_at IS NULL) as due_today,
        COUNT(*) FILTER (WHERE t.priority = 'high' AND t.status IN ('active', 'draft', 'paused') AND t.deleted_at IS NULL) as high_priority_tasks
    FROM public.tasks t
    LEFT JOIN public.task_assignments ta ON t.id = ta.task_id
    LEFT JOIN public.task_completions tc ON t.id = tc.task_id AND tc.completed_by = user_id_param;
END;
$$;


--
-- Name: get_task_statistics(uuid); Type: FUNCTION; Schema: public; Owner: -
--

