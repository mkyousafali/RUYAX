CREATE FUNCTION public.sync_erp_references_from_task_completions() RETURNS TABLE(receiving_record_id uuid, erp_reference_updated text, sync_status text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    WITH erp_updates AS (
        UPDATE receiving_records rr
        SET 
            erp_purchase_invoice_reference = tc.erp_reference_number,
            updated_at = now()
        FROM task_completions tc
        JOIN receiving_tasks rt ON tc.task_id = rt.task_id AND tc.assignment_id = rt.assignment_id
        WHERE rt.receiving_record_id = rr.id
        AND rt.role_type = 'inventory_manager'
        AND tc.erp_reference_completed = true
        AND tc.erp_reference_number IS NOT NULL
        AND tc.erp_reference_number != ''
        AND (rr.erp_purchase_invoice_reference IS NULL OR rr.erp_purchase_invoice_reference != tc.erp_reference_number)
        RETURNING rr.id as receiving_record_id, tc.erp_reference_number::TEXT, 'updated'::TEXT as sync_status
    )
    SELECT 
        eu.receiving_record_id,
        eu.erp_reference_number,
        eu.sync_status
    FROM erp_updates eu;
END;
$$;


--
-- Name: sync_requisition_balance(); Type: FUNCTION; Schema: public; Owner: -
--

