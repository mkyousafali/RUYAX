CREATE FUNCTION public.count_completed_receiving_tasks() RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
    completed_count INTEGER;
BEGIN
    -- Simple logic: if task_id from receiving_tasks exists in task_completions table, count as completed
    SELECT COUNT(DISTINCT rt.id) INTO completed_count
    FROM receiving_tasks rt
    WHERE EXISTS (
        SELECT 1 
        FROM task_completions tc 
        WHERE tc.task_id = rt.task_id
    );
    
    RETURN COALESCE(completed_count, 0);
END;
$$;


--
-- Name: count_finished_receiving_tasks(); Type: FUNCTION; Schema: public; Owner: -
--

