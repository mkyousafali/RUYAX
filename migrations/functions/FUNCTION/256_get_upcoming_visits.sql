CREATE FUNCTION public.get_upcoming_visits(branch_uuid uuid DEFAULT NULL::uuid, days_ahead integer DEFAULT 7) RETURNS TABLE(visit_id uuid, vendor_name text, vendor_company text, visit_type text, next_visit_date date, days_until_visit integer, notes text, branch_name text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        vv.id as visit_id,
        v.name as vendor_name,
        v.company as vendor_company,
        vv.visit_type,
        vv.next_visit_date,
        (vv.next_visit_date - CURRENT_DATE)::INTEGER as days_until_visit,
        vv.notes,
        b.name as branch_name
    FROM vendor_visits vv
    JOIN vendors v ON vv.vendor_id = v.id
    JOIN branches b ON vv.branch_id = b.id
    WHERE vv.next_visit_date BETWEEN CURRENT_DATE AND CURRENT_DATE + days_ahead
    AND vv.status = 'active'
    AND (branch_uuid IS NULL OR vv.branch_id = branch_uuid)
    ORDER BY vv.next_visit_date, v.company;
END;
$$;


--
-- Name: get_user_assigned_tasks(text, uuid, text, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

