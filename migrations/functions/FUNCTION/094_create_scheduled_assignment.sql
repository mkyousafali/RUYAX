CREATE FUNCTION public.create_scheduled_assignment(task_id uuid, assigned_to uuid, assigned_by uuid, scheduled_for timestamp with time zone, priority character varying DEFAULT 'medium'::character varying) RETURNS uuid
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    assignment_id UUID;
BEGIN
    INSERT INTO task_assignments (
        task_id,
        assigned_to,
        assigned_by,
        status,
        priority,
        assigned_at,
        created_at,
        updated_at
    ) VALUES (
        task_id,
        assigned_to,
        assigned_by,
        'pending',
        priority,
        scheduled_for,
        NOW(),
        NOW()
    ) RETURNING id INTO assignment_id;
    
    RETURN assignment_id;
END;
$$;


--
-- Name: create_scheduled_assignment(uuid, text, text, text, uuid, text, date, time without time zone, date, time without time zone, boolean, text, text, boolean, boolean, boolean); Type: FUNCTION; Schema: public; Owner: -
--

