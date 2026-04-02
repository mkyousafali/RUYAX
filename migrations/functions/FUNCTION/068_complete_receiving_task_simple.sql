CREATE FUNCTION public.complete_receiving_task_simple(receiving_task_id_param uuid, user_id_param uuid, completion_photo_url_param text DEFAULT NULL::text, completion_notes_param text DEFAULT NULL::text) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_task RECORD;
  v_receiving_record RECORD;
  v_result JSONB;
BEGIN
  -- Get task details
  SELECT * INTO v_task
  FROM receiving_tasks
  WHERE id = receiving_task_id_param
    AND assigned_user_id = user_id_param;
  
  IF NOT FOUND THEN
    RETURN json_build_object(
      'success', false,
      'error', 'Task not found or not assigned to user',
      'error_code', 'TASK_NOT_FOUND'
    );
  END IF;
  
  -- Check if task is already completed
  IF v_task.task_completed THEN
    RETURN json_build_object(
      'success', false,
      'error', 'Task is already completed',
      'error_code', 'TASK_ALREADY_COMPLETED'
    );
  END IF;
  
  -- Get receiving record
  SELECT * INTO v_receiving_record
  FROM receiving_records
  WHERE id = v_task.receiving_record_id;
  
  IF NOT FOUND THEN
    RETURN json_build_object(
      'success', false,
      'error', 'Receiving record not found',
      'error_code', 'RECEIVING_RECORD_NOT_FOUND'
    );
  END IF;

  -- Simplified role-specific validations (no payment schedule checks!)
  IF v_task.role_type = 'purchase_manager' THEN
    -- Purchase manager ONLY needs PR Excel URL to exist (not the boolean flag!)
    -- CHANGED: Check URL column instead of boolean flag
    IF v_receiving_record.pr_excel_file_url IS NULL OR v_receiving_record.pr_excel_file_url = '' THEN
      RETURN json_build_object(
        'success', false,
        'error', 'PR Excel file not uploaded by inventory manager',
        'error_code', 'PR_EXCEL_REQUIRED'
      );
    END IF;
  ELSIF v_task.role_type = 'accountant' THEN
    -- Check accountant dependency on inventory manager original bill upload
    -- CHANGED: Also check URL column for accountant
    IF v_receiving_record.original_bill_url IS NULL OR v_receiving_record.original_bill_url = '' THEN
      RETURN json_build_object(
        'success', false,
        'error', 'Original bill not uploaded by the inventory manager ΓÇô please follow up.',
        'error_code', 'DEPENDENCIES_NOT_MET'
      );
    END IF;
  END IF;

  -- Update the task as completed (update BOTH fields)
  UPDATE receiving_tasks
  SET 
    task_completed = true,
    task_status = 'completed',
    completed_at = CURRENT_TIMESTAMP,
    completion_photo_url = completion_photo_url_param,
    completion_notes = completion_notes_param
  WHERE id = receiving_task_id_param;
  
  -- Return success
  v_result := json_build_object(
    'success', true,
    'message', 'Task completed successfully',
    'task_id', receiving_task_id_param,
    'role_type', v_task.role_type,
    'completed_at', CURRENT_TIMESTAMP
  );
  
  RETURN v_result;
  
EXCEPTION WHEN OTHERS THEN
  RETURN json_build_object(
    'success', false,
    'error', SQLERRM,
    'error_code', 'INTERNAL_ERROR'
  );
END;
$$;


--
-- Name: complete_visit_and_update_next(uuid); Type: FUNCTION; Schema: public; Owner: -
--

