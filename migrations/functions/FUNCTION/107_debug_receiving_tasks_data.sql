CREATE FUNCTION public.debug_receiving_tasks_data() RETURNS TABLE(total_receiving_tasks integer, total_task_completions integer, receiving_task_ids text, task_completion_task_ids text, matching_completed_tasks integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        (SELECT COUNT(*)::INTEGER FROM receiving_tasks) as total_receiving_tasks,
        (SELECT COUNT(*)::INTEGER FROM task_completions) as total_task_completions,
        (SELECT string_agg(rt.task_id::TEXT, ', ') FROM receiving_tasks rt LIMIT 10) as receiving_task_ids,
        (SELECT string_agg(tc.task_id::TEXT, ', ') FROM task_completions tc WHERE tc.task_finished_completed = true LIMIT 10) as task_completion_task_ids,
        (SELECT COUNT(DISTINCT rt.id)::INTEGER 
         FROM receiving_tasks rt 
         WHERE EXISTS (
             SELECT 1 FROM task_completions tc 
             WHERE tc.task_id = rt.task_id 
             AND tc.task_finished_completed = true
         )) as matching_completed_tasks;
END;
$$;


--
-- Name: debug_users(); Type: FUNCTION; Schema: public; Owner: -
--

