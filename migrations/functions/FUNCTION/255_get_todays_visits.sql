CREATE FUNCTION public.get_todays_visits(branch_uuid uuid DEFAULT NULL::uuid) RETURNS TABLE(id uuid, vendor_name text, branch_name text, visit_type text, next_visit_date date, pattern_config jsonb, notes text, last_visit_date date, visit_count integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        vv.id,
        v.name::TEXT as vendor_name,
        b.name::TEXT as branch_name,
        vv.visit_type::TEXT,
        vv.next_visit_date,
        COALESCE(vv.pattern_config, '{}'::jsonb) as pattern_config,
        COALESCE(vv.notes, '')::TEXT,
        vv.last_visit_date,
        COALESCE(
            (SELECT COUNT(*)::INTEGER 
             FROM visit_history vh 
             WHERE vh.visit_schedule_id = vv.id 
             AND vh.status = 'completed'), 
            0
        ) as visit_count
    FROM vendor_visits vv
    JOIN vendors v ON vv.vendor_id = v.id
    JOIN branches b ON vv.branch_id = b.id
    WHERE vv.next_visit_date = CURRENT_DATE
    AND COALESCE(vv.is_active, true) = true
    AND (branch_uuid IS NULL OR vv.branch_id = branch_uuid)
    ORDER BY v.name ASC;
END;
$$;


--
-- Name: get_upcoming_visits(uuid, integer); Type: FUNCTION; Schema: public; Owner: -
--

