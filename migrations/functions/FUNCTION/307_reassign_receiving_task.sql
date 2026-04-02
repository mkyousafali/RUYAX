CREATE FUNCTION public.reassign_receiving_task(receiving_task_id_param uuid, new_assigned_user_id uuid, reassigned_by_user_id text, reassignment_reason text DEFAULT NULL::text) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
    receiving_task RECORD;
    new_assignment_id UUID;
    response JSONB;
BEGIN
    -- Get the current receiving task
    SELECT * INTO receiving_task 
    FROM receiving_tasks 
    WHERE id = receiving_task_id_param;
    
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Receiving task not found: %', receiving_task_id_param;
    END IF;
    
    -- Check if reassignment is allowed for this task type
    IF NOT receiving_task.requires_reassignment THEN
        RAISE EXCEPTION 'This task type does not allow reassignment';
    END IF;
    
    -- Reassign the task assignment
    SELECT reassign_task(
        receiving_task.assignment_id,
        new_assigned_user_id::TEXT,
        NULL, -- branch_id
        reassigned_by_user_id,
        reassignment_reason
    ) INTO new_assignment_id;
    
    -- Update the receiving task with new assignment
    UPDATE receiving_tasks 
    SET 
        assignment_id = new_assignment_id,
        assigned_user_id = new_assigned_user_id,
        updated_at = now()
    WHERE id = receiving_task_id_param;
    
    -- Create notification for new assignee
    INSERT INTO notifications (
        title, message, created_by, created_by_name,
        target_type, target_users, type, priority,
        task_id, task_assignment_id, has_attachments,
        metadata
    ) VALUES (
        'Task Reassigned to You',
        format('A %s task has been reassigned to you. Reason: %s', 
               receiving_task.role_type, 
               COALESCE(reassignment_reason, 'No reason provided')),
        reassigned_by_user_id, 'System',
        'specific_users', to_jsonb(ARRAY[new_assigned_user_id::TEXT]),
        'task', 'medium',
        receiving_task.task_id, new_assignment_id,
        receiving_task.clearance_certificate_url IS NOT NULL,
        jsonb_build_object(
            'receiving_task_id', receiving_task_id_param,
            'original_assignee', receiving_task.assigned_user_id,
            'reassignment_reason', reassignment_reason
        )
    );
    
    response := jsonb_build_object(
        'success', true,
        'receiving_task_id', receiving_task_id_param,
        'new_assignment_id', new_assignment_id,
        'new_assigned_user_id', new_assigned_user_id,
        'reassigned_at', now()
    );
    
    RETURN response;
    
EXCEPTION
    WHEN OTHERS THEN
        RETURN jsonb_build_object(
            'success', false,
            'error', SQLERRM
        );
END;
$$;


--
-- Name: reassign_task(uuid, uuid, uuid, text); Type: FUNCTION; Schema: public; Owner: -
--

