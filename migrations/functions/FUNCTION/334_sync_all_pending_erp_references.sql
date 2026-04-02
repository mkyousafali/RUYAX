CREATE FUNCTION public.sync_all_pending_erp_references() RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
    sync_record RECORD;
    total_synced INTEGER := 0;
    sync_details JSONB := '[]'::JSONB;
    record_detail JSONB;
BEGIN
    -- Find all receiving records that need ERP sync
    FOR sync_record IN
        SELECT 
            rr.id as receiving_record_id,
            tc.erp_reference_number,
            rr.erp_purchase_invoice_reference as current_erp,
            tc.completed_by
        FROM receiving_records rr
        JOIN receiving_tasks rt ON rr.id = rt.receiving_record_id
        JOIN task_completions tc ON rt.task_id = tc.task_id AND rt.assignment_id = tc.assignment_id
        WHERE rt.role_type = 'inventory_manager'
          AND tc.erp_reference_completed = true
          AND tc.erp_reference_number IS NOT NULL
          AND TRIM(tc.erp_reference_number) != ''
          AND (rr.erp_purchase_invoice_reference IS NULL 
               OR rr.erp_purchase_invoice_reference != TRIM(tc.erp_reference_number))
        ORDER BY tc.completed_at DESC
    LOOP
        -- Update the receiving record
        UPDATE receiving_records 
        SET 
            erp_purchase_invoice_reference = TRIM(sync_record.erp_reference_number),
            updated_at = now()
        WHERE id = sync_record.receiving_record_id;
        
        total_synced := total_synced + 1;
        
        -- Add details to the result
        record_detail := jsonb_build_object(
            'receiving_record_id', sync_record.receiving_record_id,
            'erp_reference', TRIM(sync_record.erp_reference_number),
            'previous_erp', sync_record.current_erp,
            'completed_by', sync_record.completed_by
        );
        
        sync_details := sync_details || record_detail;
    END LOOP;
    
    RETURN jsonb_build_object(
        'success', true,
        'total_synced', total_synced,
        'details', sync_details,
        'message', format('%s receiving records synced successfully', total_synced)
    );

EXCEPTION
    WHEN OTHERS THEN
        RETURN jsonb_build_object(
            'success', false,
            'error', SQLERRM,
            'error_code', SQLSTATE
        );
END;
$$;


--
-- Name: FUNCTION sync_all_pending_erp_references(); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.sync_all_pending_erp_references() IS 'Sync all receiving records that have pending ERP references from task completions';


--
-- Name: sync_app_functions_from_components(jsonb); Type: FUNCTION; Schema: public; Owner: -
--

