CREATE FUNCTION public.search_tasks(search_term text DEFAULT NULL::text, task_status text DEFAULT NULL::text, assigned_user_id uuid DEFAULT NULL::uuid, created_by_user_id uuid DEFAULT NULL::uuid) RETURNS TABLE(id uuid, title character varying, description text, status character varying, priority character varying, assigned_to uuid, created_by uuid, created_at timestamp with time zone, updated_at timestamp with time zone, due_date date, assignee_name character varying, creator_name character varying)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        t.id,
        t.title,
        t.description,
        t.status,
        t.priority,
        ta.assigned_to,
        t.created_by,
        t.created_at,
        t.updated_at,
        t.due_date,
        COALESCE(u_assignee.username, 'Unassigned')::VARCHAR as assignee_name,
        COALESCE(u_creator.username, 'Unknown')::VARCHAR as creator_name
    FROM tasks t
    LEFT JOIN task_assignments ta ON t.id = ta.task_id
    LEFT JOIN users u_assignee ON ta.assigned_to = u_assignee.id
    LEFT JOIN users u_creator ON t.created_by = u_creator.id
    WHERE (search_term IS NULL OR t.title ILIKE '%' || search_term || '%' OR t.description ILIKE '%' || search_term || '%')
      AND (task_status IS NULL OR t.status = task_status)
      AND (assigned_user_id IS NULL OR ta.assigned_to = assigned_user_id)
      AND (created_by_user_id IS NULL OR t.created_by = created_by_user_id)
      AND t.deleted_at IS NULL
    ORDER BY t.created_at DESC;
END;
$$;


--
-- Name: select_random_product(uuid); Type: FUNCTION; Schema: public; Owner: -
--

