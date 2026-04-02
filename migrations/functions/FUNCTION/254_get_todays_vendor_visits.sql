CREATE FUNCTION public.get_todays_vendor_visits(branch_uuid uuid) RETURNS TABLE(visit_id uuid, vendor_name text, vendor_company text, visit_time time without time zone, purpose text, status text, priority text, contact_person text, expected_duration_minutes integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        vv.id as visit_id,
        v.name as vendor_name,
        v.company as vendor_company,
        vv.visit_time,
        vv.purpose,
        vv.status,
        vv.priority,
        vv.contact_person,
        vv.expected_duration_minutes
    FROM vendor_visits vv
    JOIN vendors v ON vv.vendor_id = v.id
    WHERE vv.branch_id = branch_uuid 
    AND vv.visit_date = CURRENT_DATE
    AND vv.status IN ('scheduled', 'confirmed', 'in_progress')
    ORDER BY vv.visit_time ASC NULLS LAST, vv.priority DESC;
END;
$$;


--
-- Name: get_todays_visits(uuid); Type: FUNCTION; Schema: public; Owner: -
--

