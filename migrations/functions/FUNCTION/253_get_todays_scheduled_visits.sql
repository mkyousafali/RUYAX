CREATE FUNCTION public.get_todays_scheduled_visits(branch_uuid uuid DEFAULT NULL::uuid) RETURNS TABLE(visit_id uuid, vendor_name text, vendor_company text, visit_type text, fresh_type text, notes text, branch_name text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        vv.id as visit_id,
        v.name as vendor_name,
        v.company as vendor_company,
        vv.visit_type,
        vv.fresh_type,
        vv.notes,
        b.name as branch_name
    FROM vendor_visits vv
    JOIN vendors v ON vv.vendor_id = v.id
    JOIN branches b ON vv.branch_id = b.id
    WHERE vv.next_visit_date = CURRENT_DATE
    AND vv.status = 'active'
    AND (branch_uuid IS NULL OR vv.branch_id = branch_uuid)
    ORDER BY v.company;
END;
$$;


--
-- Name: get_todays_vendor_visits(uuid); Type: FUNCTION; Schema: public; Owner: -
--

