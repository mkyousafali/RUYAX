CREATE FUNCTION public.get_assignments_with_deadlines(p_user_id text DEFAULT NULL::text, p_branch_id uuid DEFAULT NULL::uuid, p_include_overdue boolean DEFAULT true, p_days_ahead integer DEFAULT 7) RETURNS TABLE(assignment_id uuid, task_id uuid, task_title text, task_description text, task_priority text, assignment_status text, assigned_to_user_id text, assigned_to_branch_id uuid, deadline_datetime timestamp with time zone, schedule_date date, schedule_time time without time zone, is_overdue boolean, hours_until_deadline numeric, is_reassignable boolean, notes text, require_task_finished boolean, require_photo_upload boolean, require_erp_reference boolean)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        ta.id as assignment_id,
        t.id as task_id,
        t.title as task_title,
        t.description as task_description,
        COALESCE(ta.priority_override, t.priority) as task_priority,
        ta.status as assignment_status,
        ta.assigned_to_user_id,
        ta.assigned_to_branch_id,
        ta.deadline_datetime,
        ta.schedule_date,
        ta.schedule_time,
        CASE 
            WHEN ta.deadline_datetime IS NOT NULL AND ta.deadline_datetime < now() 
                AND ta.status NOT IN ('completed', 'cancelled') 
            THEN true 
            ELSE false 
        END as is_overdue,
        CASE 
            WHEN ta.deadline_datetime IS NOT NULL 
            THEN EXTRACT(EPOCH FROM (ta.deadline_datetime - now()))/3600 
            ELSE NULL 
        END as hours_until_deadline,
        ta.is_reassignable,
        ta.notes,
        ta.require_task_finished,
        ta.require_photo_upload,
        ta.require_erp_reference
    FROM public.task_assignments ta
    JOIN public.tasks t ON ta.task_id = t.id
    WHERE 
        (p_user_id IS NULL OR ta.assigned_to_user_id = p_user_id) AND
        (p_branch_id IS NULL OR ta.assigned_to_branch_id = p_branch_id) AND
        ta.status NOT IN ('cancelled', 'reassigned') AND
        (
            p_include_overdue = true OR 
            ta.deadline_datetime IS NULL OR 
            ta.deadline_datetime >= now()
        ) AND
        (
            ta.deadline_datetime IS NULL OR 
            ta.deadline_datetime <= now() + (p_days_ahead || ' days')::interval
        )
    ORDER BY 
        CASE WHEN ta.deadline_datetime IS NOT NULL AND ta.deadline_datetime < now() THEN 1 ELSE 2 END,
        ta.deadline_datetime ASC NULLS LAST,
        ta.assigned_at DESC;
END;
$$;


--
-- Name: FUNCTION get_assignments_with_deadlines(p_user_id text, p_branch_id uuid, p_include_overdue boolean, p_days_ahead integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.get_assignments_with_deadlines(p_user_id text, p_branch_id uuid, p_include_overdue boolean, p_days_ahead integer) IS 'Retrieves assignments with deadline information and overdue status';


--
-- Name: get_branch_delivery_settings(bigint); Type: FUNCTION; Schema: public; Owner: -
--

