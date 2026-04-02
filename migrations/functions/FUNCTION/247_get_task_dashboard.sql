CREATE FUNCTION public.get_task_dashboard(user_id_param text DEFAULT NULL::text, branch_id_param uuid DEFAULT NULL::uuid) RETURNS TABLE(total_tasks bigint, my_tasks bigint, completed_today bigint, overdue_count bigint, high_priority_count bigint, recent_completions json)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        (SELECT COUNT(*) FROM tasks WHERE deleted_at IS NULL) as total_tasks,
        (
            SELECT COUNT(DISTINCT ta.task_id) 
            FROM task_assignments ta 
            JOIN tasks t ON ta.task_id = t.id
            WHERE (ta.assigned_to_user_id = user_id_param OR ta.assignment_type = 'all' 
                   OR (ta.assignment_type = 'branch' AND ta.assigned_to_branch_id = branch_id_param))
            AND t.deleted_at IS NULL
        ) as my_tasks,
        (
            SELECT COUNT(*) 
            FROM task_completions tc 
            JOIN tasks t ON tc.task_id = t.id
            WHERE tc.completed_by = user_id_param 
            AND tc.completed_at::date = CURRENT_DATE
            AND t.deleted_at IS NULL
        ) as completed_today,
        (SELECT COUNT(*) FROM tasks WHERE due_date < CURRENT_DATE AND status IN ('active', 'draft', 'paused') AND deleted_at IS NULL) as overdue_count,
        (SELECT COUNT(*) FROM tasks WHERE priority = 'high' AND status IN ('active', 'draft', 'paused') AND deleted_at IS NULL) as high_priority_count,
        (
            SELECT json_agg(json_build_object(
                'task_id', tc.task_id,
                'task_title', t.title,
                'completed_at', tc.completed_at,
                'completed_by_name', tc.completed_by_name
            ))
            FROM task_completions tc
            JOIN tasks t ON tc.task_id = t.id
            WHERE tc.completed_at >= CURRENT_DATE - INTERVAL '7 days'
            AND t.deleted_at IS NULL
            ORDER BY tc.completed_at DESC
            LIMIT 10
        ) as recent_completions;
END;
$$;


--
-- Name: get_task_master_stats(uuid); Type: FUNCTION; Schema: public; Owner: -
--

