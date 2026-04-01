CREATE FUNCTION public.count_bills_without_erp_reference() RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
    no_erp_count INTEGER;
BEGIN
    -- Count receiving records where erp_purchase_invoice_reference is NULL or empty
    SELECT COUNT(*) INTO no_erp_count
    FROM receiving_records rr
    WHERE rr.erp_purchase_invoice_reference IS NULL 
    OR rr.erp_purchase_invoice_reference = ''
    OR TRIM(rr.erp_purchase_invoice_reference) = '';
    
    RETURN COALESCE(no_erp_count, 0);
END;
$$;


--
-- Name: count_bills_without_erp_reference_by_branch(bigint); Type: FUNCTION; Schema: public; Owner: -
--

