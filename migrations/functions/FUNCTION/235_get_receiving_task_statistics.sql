CREATE FUNCTION public.get_receiving_task_statistics(branch_id_param integer DEFAULT NULL::integer, date_from date DEFAULT NULL::date, date_to date DEFAULT NULL::date) RETURNS TABLE(total_tasks bigint, pending_tasks bigint, in_progress_tasks bigint, completed_tasks bigint, overdue_tasks bigint, high_priority_tasks bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        COUNT(*) as total_tasks,
        COUNT(*) FILTER (WHERE t.status = 'pending') as pending_tasks,
        COUNT(*) FILTER (WHERE t.status = 'in_progress') as in_progress_tasks,
        COUNT(*) FILTER (WHERE t.status = 'completed') as completed_tasks,
        COUNT(*) FILTER (WHERE t.status != 'completed' AND t.due_datetime < NOW()) as overdue_tasks,
        COUNT(*) FILTER (WHERE t.priority = 'high') as high_priority_tasks
    FROM tasks t
    LEFT JOIN receiving_records rr ON rr.id::text = SUBSTRING(t.description FROM 'receiving record ([0-9a-f-]+)')
    WHERE t.description LIKE '%receiving record%'
    AND (branch_id_param IS NULL OR rr.branch_id = branch_id_param)
    AND (date_from IS NULL OR DATE(t.created_at) >= date_from)
    AND (date_to IS NULL OR DATE(t.created_at) <= date_to);
END;
$$;


--
-- Name: get_receiving_task_statistics(integer, timestamp with time zone, timestamp with time zone); Type: FUNCTION; Schema: public; Owner: -
--

