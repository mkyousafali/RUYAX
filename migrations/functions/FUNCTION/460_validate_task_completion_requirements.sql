CREATE FUNCTION public.validate_task_completion_requirements(receiving_task_id_param uuid, user_id_param uuid) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
    receiving_task RECORD;
    receiving_record RECORD;
    validation_result JSONB;
    missing_requirements TEXT[] := '{}';
BEGIN
    -- Get receiving task
    SELECT * INTO receiving_task 
    FROM receiving_tasks 
    WHERE id = receiving_task_id_param AND assigned_user_id = user_id_param;
    
    IF NOT FOUND THEN
        RETURN jsonb_build_object(
            'valid', false,
            'error', 'Task not found or user not authorized'
        );
    END IF;
    
    -- Get receiving record
    SELECT * INTO receiving_record 
    FROM receiving_records 
    WHERE id = receiving_task.receiving_record_id;
    
    -- Check ERP reference requirement
    IF receiving_task.requires_erp_reference AND receiving_task.erp_reference_number IS NULL THEN
        missing_requirements := missing_requirements || 'ERP reference number required';
    END IF;
    
    -- Check original bill upload requirement (especially for inventory manager)
    IF receiving_task.requires_original_bill_upload THEN
        -- Check if original bill has been uploaded to receiving record
        IF receiving_record.original_bill_url IS NULL OR receiving_record.original_bill_url = '' THEN
            missing_requirements := missing_requirements || 'Original bill must be uploaded through Receive Record window';
        ELSE
            -- Auto-update the receiving task if bill is already uploaded
            UPDATE receiving_tasks 
            SET 
                original_bill_uploaded = true,
                original_bill_file_path = receiving_record.original_bill_url,
                updated_at = now()
            WHERE id = receiving_task_id_param;
        END IF;
    END IF;
    
    validation_result := jsonb_build_object(
        'valid', array_length(missing_requirements, 1) IS NULL,
        'missing_requirements', missing_requirements,
        'task_id', receiving_task.task_id,
        'role_type', receiving_task.role_type,
        'requirements', jsonb_build_object(
            'erp_reference_required', receiving_task.requires_erp_reference,
            'erp_reference_provided', receiving_task.erp_reference_number IS NOT NULL,
            'original_bill_upload_required', receiving_task.requires_original_bill_upload,
            'original_bill_uploaded', receiving_task.original_bill_uploaded OR receiving_record.original_bill_url IS NOT NULL,
            'task_finished_mark_required', receiving_task.requires_task_finished_mark
        )
    );
    
    RETURN validation_result;
END;
$$;


--
-- Name: validate_variation_prices(integer, uuid); Type: FUNCTION; Schema: public; Owner: -
--

