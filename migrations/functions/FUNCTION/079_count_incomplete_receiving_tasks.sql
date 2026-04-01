CREATE FUNCTION public.count_incomplete_receiving_tasks() RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
    incomplete_count INTEGER;
BEGIN
    -- Take task_id from receiving_tasks and check if NOT completed in task_completions table
    -- Count as incomplete if there's no matching task_completion OR task_finished_completed = false
    SELECT COUNT(DISTINCT rt.id) INTO incomplete_count
    FROM receiving_tasks rt
    WHERE NOT EXISTS (
        SELECT 1 
        FROM task_completions tc 
        WHERE tc.task_id = rt.task_id 
        AND tc.task_finished_completed = true
    );
    
    RETURN COALESCE(incomplete_count, 0);
END;
$$;


--
-- Name: count_incomplete_receiving_tasks_detailed(); Type: FUNCTION; Schema: public; Owner: -
--

