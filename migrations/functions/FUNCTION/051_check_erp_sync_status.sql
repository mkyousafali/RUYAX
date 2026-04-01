CREATE FUNCTION public.check_erp_sync_status() RETURNS TABLE(total_inventory_completions bigint, synced_records bigint, unsynced_records bigint, sync_percentage numeric, status text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        COUNT(*) as total_completions,
        COUNT(CASE WHEN rr.erp_purchase_invoice_reference IS NOT NULL THEN 1 END) as synced,
        COUNT(CASE WHEN rr.erp_purchase_invoice_reference IS NULL THEN 1 END) as unsynced,
        ROUND(
            (COUNT(CASE WHEN rr.erp_purchase_invoice_reference IS NOT NULL THEN 1 END)::NUMERIC / 
             COUNT(*)::NUMERIC) * 100, 2
        ) as percentage,
        CASE 
            WHEN COUNT(CASE WHEN rr.erp_purchase_invoice_reference IS NULL THEN 1 END) = 0 
            THEN 'Γ£à ALL SYNCED'
            ELSE 'ΓÜá∩╕Å SOME UNSYNCED'
        END as sync_status
    FROM task_completions tc
    JOIN receiving_tasks rt ON tc.task_id = rt.task_id AND tc.assignment_id = rt.assignment_id
    JOIN receiving_records rr ON rt.receiving_record_id = rr.id
    WHERE tc.erp_reference_completed = true 
      AND tc.erp_reference_number IS NOT NULL 
      AND tc.erp_reference_number != ''
      AND rt.role_type = 'inventory_manager';
END;
$$;


--
-- Name: check_erp_sync_status_for_record(uuid); Type: FUNCTION; Schema: public; Owner: -
--

