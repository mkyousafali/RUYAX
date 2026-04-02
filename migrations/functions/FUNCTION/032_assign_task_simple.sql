CREATE FUNCTION public.assign_task_simple(task_id_param uuid, assigned_to_user_id_param uuid, assigned_by_param text, assigned_by_name_param text, deadline_datetime_param timestamp with time zone, priority_param text, notes_param text) RETURNS uuid
    LANGUAGE plpgsql
    AS $$
DECLARE
    assignment_id UUID;
BEGIN
    INSERT INTO task_assignments (
        task_id,
        assignment_type,
        assigned_to_user_id,
        assigned_by,
        assigned_by_name,
        deadline_datetime,
        priority_override,
        notes,
        status
    ) VALUES (
        task_id_param,
        'user',
        assigned_to_user_id_param,
        assigned_by_param,
        assigned_by_name_param,
        deadline_datetime_param,
        priority_param,
        notes_param,
        'assigned'
    ) RETURNING id INTO assignment_id;
    
    RETURN assignment_id;
END;
$$;


--
-- Name: authenticate_customer_access_code(text); Type: FUNCTION; Schema: public; Owner: -
--

