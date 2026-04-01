CREATE FUNCTION public.count_bills_without_erp_reference_by_branch(branch_id_param bigint DEFAULT NULL::bigint) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    result_count INTEGER;
BEGIN
    IF branch_id_param IS NULL THEN
        -- If no branch specified, return all
        SELECT COUNT(*) INTO result_count
        FROM receiving_records
        WHERE erp_purchase_invoice_reference IS NULL OR erp_purchase_invoice_reference = '' OR TRIM(erp_purchase_invoice_reference) = '';
    ELSE
        -- Count for specific branch
        SELECT COUNT(*) INTO result_count
        FROM receiving_records
        WHERE (erp_purchase_invoice_reference IS NULL OR erp_purchase_invoice_reference = '' OR TRIM(erp_purchase_invoice_reference) = '')
        AND branch_id = branch_id_param;
    END IF;
    
    RETURN COALESCE(result_count, 0);
END;
$$;


--
-- Name: FUNCTION count_bills_without_erp_reference_by_branch(branch_id_param bigint); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.count_bills_without_erp_reference_by_branch(branch_id_param bigint) IS 'Counts receiving records without ERP purchase invoice reference, optionally filtered by branch';


--
-- Name: count_bills_without_original(); Type: FUNCTION; Schema: public; Owner: -
--

