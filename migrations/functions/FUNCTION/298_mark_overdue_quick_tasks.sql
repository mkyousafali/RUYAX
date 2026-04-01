CREATE FUNCTION public.mark_overdue_quick_tasks() RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Mark main tasks as overdue
    UPDATE quick_tasks 
    SET status = 'overdue', updated_at = NOW()
    WHERE deadline_datetime < NOW() 
    AND status NOT IN ('completed', 'overdue');
    
    -- Mark individual assignments as overdue
    UPDATE quick_task_assignments
    SET status = 'overdue', updated_at = NOW()
    WHERE quick_task_id IN (
        SELECT id FROM quick_tasks 
        WHERE deadline_datetime < NOW()
    )
    AND status NOT IN ('completed', 'overdue');
END;
$$;


--
-- Name: notify_branches_change(); Type: FUNCTION; Schema: public; Owner: -
--

