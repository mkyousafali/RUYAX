CREATE FUNCTION public.sync_erp_reference_for_receiving_record(receiving_record_id_param uuid) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
    sync_record RECORD;
    updated_count INTEGER := 0;
    result_json JSONB;
BEGIN
    RAISE NOTICE 'Starting ERP sync for receiving_record_id: %', receiving_record_id_param;
    
    -- First, try to find task completion with ERP reference
    SELECT 
        tc.erp_reference_number,
        tc.erp_reference_completed,
        rt.role_type,
        rr.erp_purchase_invoice_reference as current_erp,
        tc.completed_at,
        tc.completed_by
    INTO sync_record
    FROM receiving_records rr
    JOIN receiving_tasks rt ON rr.id = rt.receiving_record_id
    JOIN task_completions tc ON rt.task_id = tc.task_id AND rt.assignment_id = tc.assignment_id
    WHERE rr.id = receiving_record_id_param
      AND rt.role_type = 'inventory_manager'
      AND tc.erp_reference_completed = true
      AND tc.erp_reference_number IS NOT NULL
      AND TRIM(tc.erp_reference_number) != ''
    ORDER BY tc.completed_at DESC
    LIMIT 1;

    -- If we found a task completion with ERP reference
    IF FOUND THEN
        RAISE NOTICE 'Found task completion with ERP: %', sync_record.erp_reference_number;
        
        -- Check if sync is needed
        IF sync_record.current_erp IS NULL OR sync_record.current_erp != TRIM(sync_record.erp_reference_number) THEN
            -- Update the receiving record
            UPDATE receiving_records 
            SET 
                erp_purchase_invoice_reference = TRIM(sync_record.erp_reference_number),
                updated_at = now()
            WHERE id = receiving_record_id_param;
            
            GET DIAGNOSTICS updated_count = ROW_COUNT;
            
            result_json := jsonb_build_object(
                'success', true,
                'synced', true,
                'updated_count', updated_count,
                'erp_reference', TRIM(sync_record.erp_reference_number),
                'previous_erp', sync_record.current_erp,
                'completed_by', sync_record.completed_by,
                'completed_at', sync_record.completed_at,
                'message', format('ERP reference %s synced from task completion', TRIM(sync_record.erp_reference_number))
            );
        ELSE
            result_json := jsonb_build_object(
                'success', true,
                'synced', false,
                'updated_count', 0,
                'erp_reference', sync_record.current_erp,
                'message', 'ERP reference already synced - no update needed'
            );
        END IF;
    ELSE
        RAISE NOTICE 'No task completion found, checking for existing ERP reference';
        
        -- If no task completion, check if the record already has an ERP reference
        SELECT 
            rr.erp_purchase_invoice_reference as current_erp,
            rr.created_at,
            rr.updated_at
        INTO sync_record
        FROM receiving_records rr
        WHERE rr.id = receiving_record_id_param;
        
        IF FOUND AND sync_record.current_erp IS NOT NULL AND TRIM(sync_record.current_erp) != '' THEN
            result_json := jsonb_build_object(
                'success', true,
                'synced', false,
                'updated_count', 0,
                'erp_reference', sync_record.current_erp,
                'message', format('ERP reference %s already exists (legacy record)', sync_record.current_erp)
            );
        ELSE
            result_json := jsonb_build_object(
                'success', true,
                'synced', false,
                'updated_count', 0,
                'message', 'No ERP reference available - inventory manager task not completed'
            );
        END IF;
    END IF;
    
    RETURN result_json;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'ERROR in sync function: %', SQLERRM;
        RETURN jsonb_build_object(
            'success', false,
            'error', SQLERRM,
            'error_code', SQLSTATE
        );
END;
$$;


--
-- Name: FUNCTION sync_erp_reference_for_receiving_record(receiving_record_id_param uuid); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.sync_erp_reference_for_receiving_record(receiving_record_id_param uuid) IS 'Manually sync ERP reference from task completion to specific receiving record';


--
-- Name: sync_erp_references_from_task_completions(); Type: FUNCTION; Schema: public; Owner: -
--

