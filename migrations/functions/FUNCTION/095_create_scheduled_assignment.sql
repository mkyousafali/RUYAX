CREATE FUNCTION public.create_scheduled_assignment(p_task_id uuid, p_assignment_type text, p_assigned_by text, p_assigned_to_user_id text DEFAULT NULL::text, p_assigned_to_branch_id uuid DEFAULT NULL::uuid, p_assigned_by_name text DEFAULT NULL::text, p_schedule_date date DEFAULT NULL::date, p_schedule_time time without time zone DEFAULT NULL::time without time zone, p_deadline_date date DEFAULT NULL::date, p_deadline_time time without time zone DEFAULT NULL::time without time zone, p_is_reassignable boolean DEFAULT true, p_notes text DEFAULT NULL::text, p_priority_override text DEFAULT NULL::text, p_require_task_finished boolean DEFAULT true, p_require_photo_upload boolean DEFAULT false, p_require_erp_reference boolean DEFAULT false) RETURNS uuid
    LANGUAGE plpgsql
    AS $$
DECLARE
    assignment_id UUID;
BEGIN
    INSERT INTO public.task_assignments (
        task_id,
        assignment_type,
        assigned_to_user_id,
        assigned_to_branch_id,
        assigned_by,
        assigned_by_name,
        schedule_date,
        schedule_time,
        deadline_date,
        deadline_time,
        is_reassignable,
        notes,
        priority_override,
        require_task_finished,
        require_photo_upload,
        require_erp_reference
    ) VALUES (
        p_task_id,
        p_assignment_type,
        p_assigned_to_user_id,
        p_assigned_to_branch_id,
        p_assigned_by,
        p_assigned_by_name,
        p_schedule_date,
        p_schedule_time,
        p_deadline_date,
        p_deadline_time,
        p_is_reassignable,
        p_notes,
        p_priority_override,
        p_require_task_finished,
        p_require_photo_upload,
        p_require_erp_reference
    )
    RETURNING id INTO assignment_id;
    
    RETURN assignment_id;
END;
$$;


--
-- Name: FUNCTION create_scheduled_assignment(p_task_id uuid, p_assignment_type text, p_assigned_by text, p_assigned_to_user_id text, p_assigned_to_branch_id uuid, p_assigned_by_name text, p_schedule_date date, p_schedule_time time without time zone, p_deadline_date date, p_deadline_time time without time zone, p_is_reassignable boolean, p_notes text, p_priority_override text, p_require_task_finished boolean, p_require_photo_upload boolean, p_require_erp_reference boolean); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.create_scheduled_assignment(p_task_id uuid, p_assignment_type text, p_assigned_by text, p_assigned_to_user_id text, p_assigned_to_branch_id uuid, p_assigned_by_name text, p_schedule_date date, p_schedule_time time without time zone, p_deadline_date date, p_deadline_time time without time zone, p_is_reassignable boolean, p_notes text, p_priority_override text, p_require_task_finished boolean, p_require_photo_upload boolean, p_require_erp_reference boolean) IS 'Creates a one-time task assignment with optional scheduling and deadline';


--
-- Name: create_system_admin(text, text, text, boolean, public.user_type_enum); Type: FUNCTION; Schema: public; Owner: -
--

