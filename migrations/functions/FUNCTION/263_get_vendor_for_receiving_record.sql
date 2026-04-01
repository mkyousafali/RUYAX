CREATE FUNCTION public.get_vendor_for_receiving_record(vendor_id_param integer, branch_id_param bigint) RETURNS TABLE(erp_vendor_id integer, vendor_name text, vat_number text, salesman_name text, salesman_contact text, branch_id bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        v.erp_vendor_id,
        v.vendor_name,
        v.vat_number,
        v.salesman_name,
        v.salesman_contact,
        v.branch_id
    FROM vendors v
    WHERE v.erp_vendor_id = vendor_id_param
    AND (v.branch_id = branch_id_param OR v.branch_id IS NULL)
    LIMIT 1;
END;
$$;


--
-- Name: FUNCTION get_vendor_for_receiving_record(vendor_id_param integer, branch_id_param bigint); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.get_vendor_for_receiving_record(vendor_id_param integer, branch_id_param bigint) IS 'Gets vendor details for a receiving record, ensuring branch compatibility';


--
-- Name: get_vendor_pending_summary(); Type: FUNCTION; Schema: public; Owner: -
--

