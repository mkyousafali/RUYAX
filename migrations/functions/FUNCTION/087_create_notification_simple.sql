CREATE FUNCTION public.create_notification_simple(title_param text, message_param text, created_by_param text, created_by_name_param text, target_user_id_param uuid, task_id_param uuid, assignment_id_param uuid) RETURNS uuid
    LANGUAGE plpgsql
    AS $$
DECLARE
    notification_id UUID;
BEGIN
    INSERT INTO notifications (
        title,
        message,
        created_by,
        created_by_name,
        target_type,
        target_users,
        type,
        priority,
        task_id,
        task_assignment_id
    ) VALUES (
        title_param,
        message_param,
        created_by_param,
        created_by_name_param,
        'specific_users',
        to_jsonb(ARRAY[target_user_id_param::TEXT]),
        'task',
        'high',
        task_id_param,
        assignment_id_param
    ) RETURNING id INTO notification_id;
    
    RETURN notification_id;
END;
$$;


--
-- Name: create_quick_task_notification(); Type: FUNCTION; Schema: public; Owner: -
--

