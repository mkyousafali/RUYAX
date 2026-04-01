CREATE FUNCTION public.reassign_task(p_assignment_id uuid, p_reassigned_by text, p_new_user_id text DEFAULT NULL::text, p_new_branch_id uuid DEFAULT NULL::uuid, p_reassignment_reason text DEFAULT NULL::text, p_copy_deadline boolean DEFAULT true) RETURNS uuid
    LANGUAGE plpgsql
    AS $$
DECLARE
    new_assignment_id UUID;
    original_assignment RECORD;
BEGIN
    -- Get original assignment details
    SELECT * INTO original_assignment 
    FROM public.task_assignments 
    WHERE id = p_assignment_id;
    
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Assignment not found: %', p_assignment_id;
    END IF;
    
    IF NOT original_assignment.is_reassignable THEN
        RAISE EXCEPTION 'Assignment is not reassignable: %', p_assignment_id;
    END IF;
    
    -- Create new assignment
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
        require_erp_reference,
        reassigned_from,
        reassignment_reason,
        reassigned_at
    ) VALUES (
        original_assignment.task_id,
        original_assignment.assignment_type,
        p_new_user_id,
        p_new_branch_id,
        p_reassigned_by,
        NULL, -- Will be filled by the application
        CASE WHEN p_copy_deadline THEN original_assignment.schedule_date ELSE NULL END,
        CASE WHEN p_copy_deadline THEN original_assignment.schedule_time ELSE NULL END,
        CASE WHEN p_copy_deadline THEN original_assignment.deadline_date ELSE NULL END,
        CASE WHEN p_copy_deadline THEN original_assignment.deadline_time ELSE NULL END,
        original_assignment.is_reassignable,
        original_assignment.notes,
        original_assignment.priority_override,
        original_assignment.require_task_finished,
        original_assignment.require_photo_upload,
        original_assignment.require_erp_reference,
        p_assignment_id,
        p_reassignment_reason,
        now()
    )
    RETURNING id INTO new_assignment_id;
    
    -- Mark original assignment as reassigned
    UPDATE public.task_assignments 
    SET status = 'reassigned',
        completed_at = now()
    WHERE id = p_assignment_id;
    
    RETURN new_assignment_id;
END;
$$;


--
-- Name: FUNCTION reassign_task(p_assignment_id uuid, p_reassigned_by text, p_new_user_id text, p_new_branch_id uuid, p_reassignment_reason text, p_copy_deadline boolean); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.reassign_task(p_assignment_id uuid, p_reassigned_by text, p_new_user_id text, p_new_branch_id uuid, p_reassignment_reason text, p_copy_deadline boolean) IS 'Reassigns a task to a different user or branch while maintaining audit trail';


--
-- Name: record_fine_payment(uuid, numeric, character varying, character varying, uuid); Type: FUNCTION; Schema: public; Owner: -
--

