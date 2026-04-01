CREATE FUNCTION public.get_assignments_with_deadlines(user_id uuid DEFAULT NULL::uuid, days_ahead integer DEFAULT 7) RETURNS TABLE(id uuid, task_id uuid, task_title character varying, assigned_to uuid, assignee_name character varying, due_date date, priority character varying, status character varying, days_until_due integer)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        ta.id,
        t.id as task_id,
        t.title as task_title,
        ta.assigned_to,
        u.username as assignee_name,
        t.due_date,
        ta.priority,
        ta.status,
        (t.due_date - CURRENT_DATE)::INTEGER as days_until_due
    FROM task_assignments ta
    JOIN tasks t ON ta.task_id = t.id
    LEFT JOIN users u ON ta.assigned_to = u.id
    WHERE (user_id IS NULL OR ta.assigned_to = user_id)
      AND t.due_date IS NOT NULL
      AND t.due_date <= CURRENT_DATE + INTERVAL '1 day' * days_ahead
      AND ta.status != 'completed'
      AND t.deleted_at IS NULL
    ORDER BY t.due_date ASC;
END;
$$;


--
-- Name: get_assignments_with_deadlines(text, uuid, boolean, integer); Type: FUNCTION; Schema: public; Owner: -
--

