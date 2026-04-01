CREATE FUNCTION public.sync_all_missing_erp_references() RETURNS TABLE(synced_count integer, details text)
    LANGUAGE plpgsql
    AS $$
DECLARE
    sync_record RECORD;
    total_synced INTEGER := 0;
    sync_details TEXT := '';
BEGIN
    -- Process all unsynced inventory manager task completions
    FOR sync_record IN
        SELECT 
            tc.id as completion_id,
            tc.task_id,
            tc.erp_reference_number,
            rt.receiving_record_id,
            rt.role_type,
            rr.erp_purchase_invoice_reference as current_erp
        FROM task_completions tc
        JOIN receiving_tasks rt ON tc.task_id = rt.task_id AND tc.assignment_id = rt.assignment_id
        JOIN receiving_records rr ON rt.receiving_record_id = rr.id
        WHERE tc.erp_reference_completed = true 
          AND tc.erp_reference_number IS NOT NULL 
          AND TRIM(tc.erp_reference_number) != ''
          AND rt.role_type = 'inventory_manager'
          AND (rr.erp_purchase_invoice_reference IS NULL 
               OR rr.erp_purchase_invoice_reference != TRIM(tc.erp_reference_number))
    LOOP
        -- Update the receiving record
        UPDATE receiving_records 
        SET 
            erp_purchase_invoice_reference = TRIM(sync_record.erp_reference_number),
            updated_at = now()
        WHERE id = sync_record.receiving_record_id;
        
        total_synced := total_synced + 1;
        sync_details := sync_details || format('Synced receiving_record %s with ERP %s; ', 
                                              sync_record.receiving_record_id, 
                                              TRIM(sync_record.erp_reference_number));
        
    END LOOP;
    
    RETURN QUERY SELECT total_synced, sync_details;
END;
$$;


--
-- Name: sync_all_pending_erp_references(); Type: FUNCTION; Schema: public; Owner: -
--

