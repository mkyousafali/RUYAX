CREATE FUNCTION public.create_quick_task_with_assignments(title_param character varying, description_param text, priority_param character varying DEFAULT 'medium'::character varying, deadline_param timestamp with time zone DEFAULT NULL::timestamp with time zone, created_by_param uuid DEFAULT NULL::uuid, assigned_user_ids uuid[] DEFAULT NULL::uuid[], require_task_finished_param boolean DEFAULT true, require_photo_upload_param boolean DEFAULT false, require_erp_reference_param boolean DEFAULT false) RETURNS uuid
    LANGUAGE plpgsql
    AS $$
DECLARE
    task_id UUID;
    user_id UUID;
BEGIN
    -- Create the quick task with completion requirements
    INSERT INTO quick_tasks (
        title,
        description,
        priority,
        deadline_datetime,
        created_by_user_id,
        require_task_finished,
        require_photo_upload,
        require_erp_reference,
        status
    ) VALUES (
        title_param,
        description_param,
        priority_param,
        deadline_param,
        created_by_param,
        require_task_finished_param,
        require_photo_upload_param,
        require_erp_reference_param,
        'active'
    ) RETURNING id INTO task_id;
    
    -- Create assignments for each user if provided
    IF assigned_user_ids IS NOT NULL THEN
        FOREACH user_id IN ARRAY assigned_user_ids
        LOOP
            INSERT INTO quick_task_assignments (
                quick_task_id,
                assigned_to_user_id,
                require_task_finished,
                require_photo_upload,
                require_erp_reference,
                status
            ) VALUES (
                task_id,
                user_id,
                require_task_finished_param,
                require_photo_upload_param,
                require_erp_reference_param,
                'pending'
            );
        END LOOP;
    END IF;
    
    RETURN task_id;
END;
$$;


--
-- Name: create_recurring_assignment(uuid, uuid, uuid, character varying, date, date); Type: FUNCTION; Schema: public; Owner: -
--

