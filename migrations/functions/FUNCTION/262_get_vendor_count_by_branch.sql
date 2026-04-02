CREATE FUNCTION public.get_vendor_count_by_branch() RETURNS TABLE(branch_id bigint, branch_name text, vendor_count bigint, active_vendor_count bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        b.id as branch_id,
        b.name_en as branch_name,
        COUNT(v.erp_vendor_id) as vendor_count,
        COUNT(CASE WHEN v.status = 'Active' THEN 1 END) as active_vendor_count
    FROM branches b
    LEFT JOIN vendors v ON b.id = v.branch_id
    GROUP BY b.id, b.name_en
    ORDER BY b.name_en;
END;
$$;


--
-- Name: get_vendor_for_receiving_record(integer, bigint); Type: FUNCTION; Schema: public; Owner: -
--

