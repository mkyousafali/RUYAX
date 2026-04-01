CREATE FUNCTION public.complete_receiving_task(receiving_task_id_param uuid, user_id_param uuid, erp_reference_param character varying DEFAULT NULL::character varying, original_bill_file_path_param text DEFAULT NULL::text, has_erp_purchase_invoice boolean DEFAULT false, has_pr_excel_file boolean DEFAULT false, has_original_bill boolean DEFAULT false, completion_photo_url_param text DEFAULT NULL::text, completion_notes_param text DEFAULT NULL::text) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_task RECORD;
  v_receiving_record_id UUID;
  v_template RECORD;
  dependency_check_result JSONB;  -- Changed from JSON to JSONB
  accountant_dependency_result JSONB;  -- Changed from JSON to JSONB
  blocking_roles_array TEXT[];
BEGIN
  -- Get the task
  SELECT * INTO v_task
  FROM receiving_tasks
  WHERE id = receiving_task_id_param;
  
  IF NOT FOUND THEN
    RETURN jsonb_build_object(  -- Changed from json_build_object
      'success', false,
      'error', 'Task not found',
      'error_code', 'TASK_NOT_FOUND'
    );
  END IF;

  v_receiving_record_id := v_task.receiving_record_id;

  -- Get template for requirements
  SELECT * INTO v_template
  FROM receiving_task_templates
  WHERE role_type = v_task.role_type;

  -- SPECIAL CHECK FOR ACCOUNTANT: Must wait for files to be uploaded
  IF v_task.role_type = 'accountant' THEN
    accountant_dependency_result := check_accountant_dependency(v_receiving_record_id);
    
    IF NOT (accountant_dependency_result->>'can_complete')::BOOLEAN THEN
      RETURN jsonb_build_object(  -- Changed from json_build_object
        'success', false,
        'error', accountant_dependency_result->>'error',
        'error_code', accountant_dependency_result->>'error_code',
        'message', accountant_dependency_result->>'message'
      );
    END IF;
  END IF;

  -- Check photo requirement (for non-exempt tasks)
  IF v_template.require_photo_upload AND completion_photo_url_param IS NULL THEN
    -- Check if task is exempt from new rules (backward compatibility)
    IF v_task.rule_effective_date IS NOT NULL THEN
      RETURN jsonb_build_object(  -- Changed from json_build_object
        'success', false,
        'error', 'Photo upload is required for this role',
        'error_code', 'PHOTO_REQUIRED'
      );
    END IF;
  END IF;

  -- Check other dependencies (existing logic) - FIXED VERSION
  IF v_template.depends_on_role_types IS NOT NULL AND array_length(v_template.depends_on_role_types, 1) > 0 THEN
    dependency_check_result := check_receiving_task_dependencies(
      v_receiving_record_id, 
      v_task.role_type
    );

    IF NOT (dependency_check_result->>'can_complete')::BOOLEAN THEN
      -- Extract blocking roles properly from JSONB
      IF dependency_check_result ? 'blocking_roles' THEN
        -- Convert JSONB array to PostgreSQL array
        SELECT ARRAY(
          SELECT jsonb_array_elements_text(dependency_check_result->'blocking_roles')
        ) INTO blocking_roles_array;
      ELSE
        blocking_roles_array := ARRAY[]::TEXT[];
      END IF;

      RETURN jsonb_build_object(  -- Changed from json_build_object
        'success', false,
        'error', 'Cannot complete task. Missing dependencies: ' || 
                COALESCE(array_to_string(blocking_roles_array, ', '), 'Unknown dependencies'),
        'error_code', 'DEPENDENCIES_NOT_MET',
        'blocking_roles', blocking_roles_array,
        'dependency_details', dependency_check_result
      );
    END IF;
  END IF;

  -- Validation for Inventory Manager role
  IF v_task.role_type = 'inventory_manager' THEN
    IF erp_reference_param IS NULL OR erp_reference_param = '' THEN
      RETURN jsonb_build_object(  -- Changed from json_build_object
        'success', false,
        'error', 'ERP reference is required for Inventory Manager',
        'error_code', 'MISSING_ERP_REFERENCE'
      );
    END IF;
    
    IF NOT has_pr_excel_file THEN
      RETURN jsonb_build_object(  -- Changed from json_build_object
        'success', false,
        'error', 'PR Excel file is required for Inventory Manager',
        'error_code', 'MISSING_PR_EXCEL'
      );
    END IF;
    
    IF NOT has_original_bill THEN
      RETURN jsonb_build_object(  -- Changed from json_build_object
        'success', false,
        'error', 'Original bill is required for Inventory Manager',
        'error_code', 'MISSING_ORIGINAL_BILL'
      );
    END IF;
  END IF;

  -- For Purchase Manager, check PR Excel upload and verification status
  IF v_task.role_type = 'purchase_manager' THEN
    DECLARE
      v_receiving_record RECORD;
      v_payment_schedule RECORD;
    BEGIN
      -- Get receiving record details
      SELECT * INTO v_receiving_record
      FROM receiving_records
      WHERE id = v_task.receiving_record_id;
      
      -- Check if PR Excel file is uploaded
      IF v_receiving_record.pr_excel_file_url IS NULL OR v_receiving_record.pr_excel_file_url = '' THEN
        RETURN jsonb_build_object(  -- Changed from json_build_object
          'success', false,
          'error', 'PR Excel not uploaded',
          'error_code', 'PR_EXCEL_NOT_UPLOADED'
        );
      END IF;
      
      -- Get payment schedule to check verification status
      SELECT * INTO v_payment_schedule
      FROM vendor_payment_schedules
      WHERE receiving_record_id = v_task.receiving_record_id;
      
      IF NOT FOUND THEN
        RETURN jsonb_build_object(  -- Changed from json_build_object
          'success', false,
          'error', 'Payment schedule not found. PR Excel may not be processed yet.',
          'error_code', 'PAYMENT_SCHEDULE_NOT_FOUND'
        );
      END IF;
      
      IF v_payment_schedule.verification_status != 'verified' THEN
        RETURN jsonb_build_object(  -- Changed from json_build_object
          'success', false,
          'error', 'Payment schedule not verified. Current status: ' || COALESCE(v_payment_schedule.verification_status, 'unverified'),
          'error_code', 'PAYMENT_SCHEDULE_NOT_VERIFIED'
        );
      END IF;
    END;
  END IF;

  -- Update the task
  UPDATE receiving_tasks
  SET 
    task_status = 'completed',
    task_completed = true,
    completed_at = NOW(),
    completed_by_user_id = user_id_param,
    completion_photo_url = COALESCE(completion_photo_url_param, completion_photo_url),
    completion_notes = COALESCE(completion_notes_param, completion_notes),
    erp_reference_number = CASE 
      WHEN v_task.role_type = 'inventory_manager' THEN erp_reference_param 
      ELSE erp_reference_number
    END,
    original_bill_uploaded = CASE 
      WHEN v_task.role_type = 'inventory_manager' THEN has_original_bill
      ELSE original_bill_uploaded
    END,
    updated_at = NOW()
  WHERE id = receiving_task_id_param;
  
  -- If this is an Inventory Manager task, update the receiving_records table
  IF v_task.role_type = 'inventory_manager' THEN
    UPDATE receiving_records
    SET 
      erp_purchase_invoice_uploaded = has_erp_purchase_invoice,
      pr_excel_file_uploaded = has_pr_excel_file,
      original_bill_uploaded = has_original_bill,
      updated_at = NOW()
    WHERE id = v_receiving_record_id;
  END IF;
  
  RETURN jsonb_build_object(  -- Changed from json_build_object
    'success', true,
    'task_id', receiving_task_id_param,
    'role_type', v_task.role_type,
    'completed_at', NOW(),
    'completed_by', user_id_param,
    'message', 'Task completed successfully'
  );
  
EXCEPTION WHEN OTHERS THEN
  RETURN jsonb_build_object(  -- Changed from json_build_object
    'success', false,
    'error', SQLERRM,
    'error_code', 'INTERNAL_ERROR'
  );
END;
$$;


--
-- Name: complete_receiving_task_fixed(uuid, uuid, text, text); Type: FUNCTION; Schema: public; Owner: -
--

