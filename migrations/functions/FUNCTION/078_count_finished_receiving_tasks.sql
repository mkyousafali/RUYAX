CREATE FUNCTION public.count_finished_receiving_tasks() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    finished_count INTEGER;
BEGIN
    -- Count receiving tasks that are marked as task_finished_completed = true
    SELECT COUNT(DISTINCT rt.id) INTO finished_count
    FROM receiving_tasks rt
    WHERE EXISTS (
        SELECT 1 
        FROM task_completions tc 
        WHERE tc.task_id = rt.task_id 
        AND tc.task_finished_completed = true
    );
    
    RETURN COALESCE(finished_count, 0);
END;
$$;


--
-- Name: count_incomplete_receiving_tasks(); Type: FUNCTION; Schema: public; Owner: -
--

