CREATE FUNCTION public.get_incomplete_receiving_tasks_breakdown() RETURNS TABLE(total_receiving_tasks integer, incomplete_receiving_tasks integer, missing_task_completions integer, incomplete_task_completions integer, tasks_not_completed integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    WITH stats AS (
        SELECT 
            COUNT(*) as total_tasks,
            COUNT(CASE WHEN rt.task_completed = false OR t.status != 'completed' THEN 1 END) as incomplete_tasks,
            COUNT(CASE WHEN tc.id IS NULL THEN 1 END) as missing_completions,
            COUNT(CASE WHEN tc.id IS NOT NULL AND tc.task_finished_completed = false THEN 1 END) as incomplete_completions,
            COUNT(CASE WHEN t.status != 'completed' THEN 1 END) as tasks_not_completed
        FROM receiving_tasks rt
        LEFT JOIN tasks t ON rt.task_id = t.id
        LEFT JOIN task_completions tc ON rt.task_id = tc.task_id AND rt.assignment_id = tc.assignment_id
    )
    SELECT 
        s.total_tasks::INTEGER,
        s.incomplete_tasks::INTEGER,
        s.missing_completions::INTEGER,
        s.incomplete_completions::INTEGER,
        s.tasks_not_completed::INTEGER
    FROM stats s;
END;
$$;


--
-- Name: get_incomplete_tasks(); Type: FUNCTION; Schema: public; Owner: -
--

