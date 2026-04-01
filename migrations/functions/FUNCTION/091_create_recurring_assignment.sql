CREATE FUNCTION public.create_recurring_assignment(p_task_id uuid, p_assignment_type text, p_assigned_by text, p_repeat_type text, p_assigned_to_user_id text DEFAULT NULL::text, p_assigned_to_branch_id uuid DEFAULT NULL::uuid, p_assigned_by_name text DEFAULT NULL::text, p_repeat_interval integer DEFAULT 1, p_repeat_on_days integer[] DEFAULT NULL::integer[], p_execute_time time without time zone DEFAULT '09:00:00'::time without time zone, p_start_date date DEFAULT CURRENT_DATE, p_end_date date DEFAULT NULL::date, p_max_occurrences integer DEFAULT NULL::integer, p_notes text DEFAULT NULL::text, p_is_reassignable boolean DEFAULT true) RETURNS uuid
    LANGUAGE plpgsql
    AS $$
DECLARE
    assignment_id UUID;
    next_exec_time TIMESTAMP WITH TIME ZONE;
BEGIN
    -- Calculate first execution time
    next_exec_time := (p_start_date::text || ' ' || p_execute_time::text)::timestamp with time zone;
    
    -- Create the assignment record
    INSERT INTO public.task_assignments (
        task_id,
        assignment_type,
        assigned_to_user_id,
        assigned_to_branch_id,
        assigned_by,
        assigned_by_name,
        is_recurring,
        is_reassignable,
        notes
    ) VALUES (
        p_task_id,
        p_assignment_type,
        p_assigned_to_user_id,
        p_assigned_to_branch_id,
        p_assigned_by,
        p_assigned_by_name,
        true,
        p_is_reassignable,
        p_notes
    )
    RETURNING id INTO assignment_id;
    
    -- Create the recurring schedule
    INSERT INTO public.recurring_assignment_schedules (
        assignment_id,
        repeat_type,
        repeat_interval,
        repeat_on_days,
        execute_time,
        start_date,
        end_date,
        max_occurrences,
        next_execution_at,
        created_by
    ) VALUES (
        assignment_id,
        p_repeat_type,
        p_repeat_interval,
        p_repeat_on_days,
        p_execute_time,
        p_start_date,
        p_end_date,
        p_max_occurrences,
        next_exec_time,
        p_assigned_by
    );
    
    RETURN assignment_id;
END;
$$;


--
-- Name: FUNCTION create_recurring_assignment(p_task_id uuid, p_assignment_type text, p_assigned_by text, p_repeat_type text, p_assigned_to_user_id text, p_assigned_to_branch_id uuid, p_assigned_by_name text, p_repeat_interval integer, p_repeat_on_days integer[], p_execute_time time without time zone, p_start_date date, p_end_date date, p_max_occurrences integer, p_notes text, p_is_reassignable boolean); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.create_recurring_assignment(p_task_id uuid, p_assignment_type text, p_assigned_by text, p_repeat_type text, p_assigned_to_user_id text, p_assigned_to_branch_id uuid, p_assigned_by_name text, p_repeat_interval integer, p_repeat_on_days integer[], p_execute_time time without time zone, p_start_date date, p_end_date date, p_max_occurrences integer, p_notes text, p_is_reassignable boolean) IS 'Creates a recurring task assignment with schedule configuration';


--
-- Name: create_schedule_template(bigint, character varying, time without time zone, time without time zone, boolean); Type: FUNCTION; Schema: public; Owner: -
--

