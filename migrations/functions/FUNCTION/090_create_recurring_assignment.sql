CREATE FUNCTION public.create_recurring_assignment(task_id uuid, assigned_to uuid, assigned_by uuid, recurrence_pattern character varying, start_date date, end_date date DEFAULT NULL::date) RETURNS uuid
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    schedule_id UUID;
BEGIN
    INSERT INTO recurring_assignment_schedules (
        task_id,
        assigned_to,
        assigned_by,
        recurrence_pattern,
        start_date,
        end_date,
        is_active,
        created_at,
        updated_at
    ) VALUES (
        task_id,
        assigned_to,
        assigned_by,
        recurrence_pattern,
        start_date,
        end_date,
        true,
        NOW(),
        NOW()
    ) RETURNING id INTO schedule_id;
    
    RETURN schedule_id;
END;
$$;


--
-- Name: create_recurring_assignment(uuid, text, text, text, text, uuid, text, integer, integer[], time without time zone, date, date, integer, text, boolean); Type: FUNCTION; Schema: public; Owner: -
--

