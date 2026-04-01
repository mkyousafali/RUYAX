CREATE FUNCTION public.update_receiving_task_completion(receiving_task_id_param uuid, erp_reference_param character varying DEFAULT NULL::character varying, original_bill_uploaded_param boolean DEFAULT NULL::boolean, original_bill_file_path_param text DEFAULT NULL::text) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
    receiving_task RECORD;
    can_complete BOOLEAN := true;
BEGIN
    -- Get receiving task details
    SELECT * INTO receiving_task 
    FROM receiving_tasks 
    WHERE id = receiving_task_id_param;
    
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Receiving task not found: %', receiving_task_id_param;
    END IF;
    
    -- Update the receiving task
    UPDATE receiving_tasks 
    SET 
        erp_reference_number = COALESCE(erp_reference_param, erp_reference_number),
        original_bill_uploaded = COALESCE(original_bill_uploaded_param, original_bill_uploaded),
        original_bill_file_path = COALESCE(original_bill_file_path_param, original_bill_file_path),
        updated_at = now()
    WHERE id = receiving_task_id_param;
    
    -- Check if task can be completed based on requirements
    SELECT * INTO receiving_task FROM receiving_tasks WHERE id = receiving_task_id_param;
    
    -- Check ERP reference requirement
    IF receiving_task.requires_erp_reference AND receiving_task.erp_reference_number IS NULL THEN
        can_complete := false;
    END IF;
    
    -- Check original bill upload requirement
    IF receiving_task.requires_original_bill_upload AND NOT receiving_task.original_bill_uploaded THEN
        can_complete := false;
    END IF;
    
    -- If all requirements are met, mark as completed
    IF can_complete AND NOT receiving_task.task_completed THEN
        UPDATE receiving_tasks 
        SET 
            task_completed = true,
            completed_at = now(),
            updated_at = now()
        WHERE id = receiving_task_id_param;
        
        -- Update the main task assignment status
        UPDATE task_assignments 
        SET 
            status = 'completed',
            completed_at = now()
        WHERE id = receiving_task.assignment_id;
        
        -- Update the main task status
        UPDATE tasks 
        SET 
            status = 'completed',
            completion_percentage = 100,
            updated_at = now()
        WHERE id = receiving_task.task_id;
        
        RETURN true;
    END IF;
    
    RETURN false;
END;
$$;


--
-- Name: update_receiving_task_templates_updated_at(); Type: FUNCTION; Schema: public; Owner: -
--

