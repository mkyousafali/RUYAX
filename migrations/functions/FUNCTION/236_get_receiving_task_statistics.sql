CREATE FUNCTION public.get_receiving_task_statistics(branch_id_param integer DEFAULT NULL::integer, date_from timestamp with time zone DEFAULT NULL::timestamp with time zone, date_to timestamp with time zone DEFAULT NULL::timestamp with time zone) RETURNS TABLE(total_tasks bigint, completed_tasks bigint, pending_tasks bigint, overdue_tasks bigint, tasks_by_role jsonb, completion_rate numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        COUNT(*) as total_tasks,
        COUNT(*) FILTER (WHERE task_completed = true) as completed_tasks,
        COUNT(*) FILTER (WHERE task_completed = false) as pending_tasks,
        COUNT(*) FILTER (WHERE is_overdue = true AND task_completed = false) as overdue_tasks,
        jsonb_object_agg(
            role_type, 
            jsonb_build_object(
                'total', role_count,
                'completed', role_completed
            )
        ) as tasks_by_role,
        CASE 
            WHEN COUNT(*) > 0 THEN 
                ROUND((COUNT(*) FILTER (WHERE task_completed = true) * 100.0) / COUNT(*), 2)
            ELSE 0
        END as completion_rate
    FROM (
        SELECT 
            rtd.role_type,
            rtd.task_completed,
            rtd.is_overdue,
            COUNT(*) OVER (PARTITION BY rtd.role_type) as role_count,
            COUNT(*) FILTER (WHERE rtd.task_completed = true) OVER (PARTITION BY rtd.role_type) as role_completed
        FROM receiving_tasks_detailed rtd
        WHERE (branch_id_param IS NULL OR rtd.branch_id = branch_id_param)
          AND (date_from IS NULL OR rtd.created_at >= date_from)
          AND (date_to IS NULL OR rtd.created_at <= date_to)
    ) stats
    GROUP BY ();
END;
$$;


--
-- Name: get_receiving_tasks_for_user(uuid, integer); Type: FUNCTION; Schema: public; Owner: -
--

