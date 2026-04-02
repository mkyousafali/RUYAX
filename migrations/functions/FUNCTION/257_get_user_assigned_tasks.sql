CREATE FUNCTION public.get_user_assigned_tasks(user_id_param text, branch_id_param uuid DEFAULT NULL::uuid, status_filter text DEFAULT NULL::text, limit_param integer DEFAULT 50, offset_param integer DEFAULT 0) RETURNS TABLE(id uuid, title text, description text, require_task_finished boolean, require_photo_upload boolean, require_erp_reference boolean, can_escalate boolean, can_reassign boolean, created_by text, created_by_name text, status text, priority text, created_at timestamp with time zone, updated_at timestamp with time zone, due_date date, due_time time without time zone, assignment_status text, assigned_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        t.id, t.title, t.description, t.require_task_finished, t.require_photo_upload, t.require_erp_reference,
        t.can_escalate, t.can_reassign, t.created_by, t.created_by_name, t.status, t.priority,
        t.created_at, t.updated_at, t.due_date, t.due_time,
        ta.status as assignment_status, ta.assigned_at
    FROM public.tasks t
    INNER JOIN public.task_assignments ta ON t.id = ta.task_id
    WHERE t.deleted_at IS NULL
    AND (
        ta.assignment_type = 'all' 
        OR (ta.assignment_type = 'user' AND ta.assigned_to_user_id = user_id_param)
        OR (ta.assignment_type = 'branch' AND ta.assigned_to_branch_id = branch_id_param)
    )
    AND (status_filter IS NULL OR t.status = status_filter)
    ORDER BY t.created_at DESC
    LIMIT limit_param OFFSET offset_param;
END;
$$;


--
-- Name: get_user_interface_permissions(uuid); Type: FUNCTION; Schema: public; Owner: -
--

