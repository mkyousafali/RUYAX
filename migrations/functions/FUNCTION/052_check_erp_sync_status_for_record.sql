CREATE FUNCTION public.check_erp_sync_status_for_record(receiving_record_id_param uuid) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
    status_record RECORD;
    result_json JSONB;
    has_tasks BOOLEAN := false;
BEGIN
    RAISE NOTICE 'Checking sync status for receiving_record_id: %', receiving_record_id_param;
    
    -- Check if this record has any receiving tasks
    SELECT EXISTS (
        SELECT 1 FROM receiving_tasks rt 
        WHERE rt.receiving_record_id = receiving_record_id_param
    ) INTO has_tasks;
    
    RAISE NOTICE 'Record has receiving tasks: %', has_tasks;
    
    IF has_tasks THEN
        -- Get task-based sync status information
        SELECT 
            rr.erp_purchase_invoice_reference,
            tc.erp_reference_number as task_erp_reference,
            tc.erp_reference_completed,
            tc.completed_at as task_completed_at,
            tc.completed_by,
            rt.role_type,
            rt.task_completed as receiving_task_completed,
            CASE 
                WHEN tc.erp_reference_completed = true 
                     AND tc.erp_reference_number IS NOT NULL 
                     AND TRIM(tc.erp_reference_number) != ''
                     AND rr.erp_purchase_invoice_reference = TRIM(tc.erp_reference_number)
                THEN 'SYNCED'
                WHEN tc.erp_reference_completed = true 
                     AND tc.erp_reference_number IS NOT NULL 
                     AND TRIM(tc.erp_reference_number) != ''
                     AND (rr.erp_purchase_invoice_reference IS NULL 
                          OR rr.erp_purchase_invoice_reference != TRIM(tc.erp_reference_number))
                THEN 'NEEDS_SYNC'
                WHEN tc.erp_reference_completed = false 
                     OR tc.erp_reference_number IS NULL 
                     OR TRIM(tc.erp_reference_number) = ''
                THEN 'NO_ERP_REFERENCE'
                ELSE 'UNKNOWN'
            END as sync_status
        INTO status_record
        FROM receiving_records rr
        LEFT JOIN receiving_tasks rt ON rr.id = rt.receiving_record_id AND rt.role_type = 'inventory_manager'
        LEFT JOIN task_completions tc ON rt.task_id = tc.task_id AND rt.assignment_id = tc.assignment_id
        WHERE rr.id = receiving_record_id_param
        ORDER BY tc.completed_at DESC
        LIMIT 1;
    ELSE
        -- For legacy records without tasks, check if they have ERP references
        SELECT 
            rr.erp_purchase_invoice_reference,
            NULL::text as task_erp_reference,
            NULL::boolean as erp_reference_completed,
            NULL::timestamptz as task_completed_at,
            NULL::text as completed_by,
            NULL::text as role_type,
            NULL::boolean as receiving_task_completed,
            CASE 
                WHEN rr.erp_purchase_invoice_reference IS NOT NULL 
                     AND TRIM(rr.erp_purchase_invoice_reference) != ''
                THEN 'LEGACY_WITH_ERP'
                ELSE 'LEGACY_NO_ERP'
            END as sync_status
        INTO status_record
        FROM receiving_records rr
        WHERE rr.id = receiving_record_id_param;
    END IF;

    RAISE NOTICE 'Status check - FOUND: %, Current ERP: %, Task ERP: %, Status: %', 
                 FOUND, status_record.erp_purchase_invoice_reference, 
                 status_record.task_erp_reference, status_record.sync_status;

    IF FOUND THEN
        result_json := jsonb_build_object(
            'success', true,
            'receiving_record_id', receiving_record_id_param,
            'current_erp_reference', status_record.erp_purchase_invoice_reference,
            'task_erp_reference', status_record.task_erp_reference,
            'task_erp_completed', status_record.erp_reference_completed,
            'task_completed_at', status_record.task_completed_at,
            'task_completed_by', status_record.completed_by,
            'receiving_task_completed', status_record.receiving_task_completed,
            'sync_status', status_record.sync_status,
            'sync_needed', status_record.sync_status = 'NEEDS_SYNC',
            'can_sync', status_record.sync_status IN ('NEEDS_SYNC', 'SYNCED', 'LEGACY_WITH_ERP'),
            'has_tasks', has_tasks
        );
    ELSE
        RAISE NOTICE 'No record found for receiving_record_id: %', receiving_record_id_param;
        result_json := jsonb_build_object(
            'success', false,
            'error', 'Receiving record not found'
        );
    END IF;
    
    RETURN result_json;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'ERROR in status check function: %', SQLERRM;
        RETURN jsonb_build_object(
            'success', false,
            'error', SQLERRM,
            'error_code', SQLSTATE
        );
END;
$$;


--
-- Name: FUNCTION check_erp_sync_status_for_record(receiving_record_id_param uuid); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.check_erp_sync_status_for_record(receiving_record_id_param uuid) IS 'Check ERP sync status for a specific receiving record';


--
-- Name: check_offer_eligibility(integer, uuid, numeric, integer); Type: FUNCTION; Schema: public; Owner: -
--

