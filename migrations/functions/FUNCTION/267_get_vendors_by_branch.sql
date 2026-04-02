CREATE FUNCTION public.get_vendors_by_branch(branch_id_param bigint DEFAULT NULL::bigint) RETURNS TABLE(erp_vendor_id integer, vendor_name text, salesman_name text, vendor_contact_number text, payment_method text, status text, branch_id bigint, categories text[], delivery_modes text[], place text, vat_number text, created_at timestamp without time zone, updated_at timestamp without time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF branch_id_param IS NULL THEN
        -- Return all vendors if no branch specified
        RETURN QUERY
        SELECT 
            v.erp_vendor_id,
            v.vendor_name,
            v.salesman_name,
            v.vendor_contact_number,
            v.payment_method,
            v.status,
            v.branch_id,
            v.categories,
            v.delivery_modes,
            v.place,
            v.vat_number,
            v.created_at,
            v.updated_at
        FROM vendors v
        ORDER BY v.vendor_name;
    ELSE
        -- Return vendors for specific branch
        RETURN QUERY
        SELECT 
            v.erp_vendor_id,
            v.vendor_name,
            v.salesman_name,
            v.vendor_contact_number,
            v.payment_method,
            v.status,
            v.branch_id,
            v.categories,
            v.delivery_modes,
            v.place,
            v.vat_number,
            v.created_at,
            v.updated_at
        FROM vendors v
        WHERE v.branch_id = branch_id_param
        ORDER BY v.vendor_name;
    END IF;
END;
$$;


--
-- Name: get_visit_history(date, date, uuid); Type: FUNCTION; Schema: public; Owner: -
--

