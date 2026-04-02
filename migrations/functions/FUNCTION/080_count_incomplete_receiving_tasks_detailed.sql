CREATE FUNCTION public.count_incomplete_receiving_tasks_detailed() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    incomplete_count INTEGER;
BEGIN
    -- Count receiving tasks where either:
    -- 1. The receiving task is not marked as completed, OR
    -- 2. The task itself is not completed, OR
    -- 3. There's no task_completion record, OR
    -- 4. The task_completion is not fully finished
    SELECT COUNT(*) INTO incomplete_count
    FROM receiving_tasks rt
    LEFT JOIN tasks t ON rt.task_id = t.id
    LEFT JOIN task_completions tc ON rt.task_id = tc.task_id AND rt.assignment_id = tc.assignment_id
    WHERE (
        rt.task_completed = false 
        OR t.status != 'completed'
        OR tc.id IS NULL
        OR tc.task_finished_completed = false
    );
    
    RETURN COALESCE(incomplete_count, 0);
END;
$$;


--
-- Name: create_customer_order(uuid, bigint, jsonb, character varying, character varying, numeric, numeric, numeric, numeric, numeric, integer, integer, text); Type: FUNCTION; Schema: public; Owner: -
--

