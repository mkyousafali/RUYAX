CREATE FUNCTION public.check_visit_conflicts(branch_uuid uuid, visit_date_param date, visit_time_param time without time zone, duration_minutes integer DEFAULT 60, exclude_visit_id uuid DEFAULT NULL::uuid) RETURNS TABLE(conflict_count integer, conflicting_visits text[])
    LANGUAGE plpgsql
    AS $$
DECLARE
    start_time TIME;
    end_time TIME;
BEGIN
    -- Calculate time range
    start_time := visit_time_param;
    end_time := visit_time_param + (duration_minutes || ' minutes')::INTERVAL;
    
    RETURN QUERY
    SELECT 
        COUNT(*)::INTEGER as conflict_count,
        ARRAY_AGG(
            'Visit with ' || v.company || ' at ' || vv.visit_time::TEXT
        ) as conflicting_visits
    FROM vendor_visits vv
    JOIN vendors v ON vv.vendor_id = v.id
    WHERE vv.branch_id = branch_uuid 
    AND vv.visit_date = visit_date_param
    AND vv.status IN ('scheduled', 'confirmed', 'in_progress')
    AND (exclude_visit_id IS NULL OR vv.id != exclude_visit_id)
    AND vv.visit_time IS NOT NULL
    AND (
        -- Check for time overlap
        (vv.visit_time BETWEEN start_time AND end_time) OR
        (vv.visit_time + (vv.expected_duration_minutes || ' minutes')::INTERVAL BETWEEN start_time AND end_time) OR
        (start_time BETWEEN vv.visit_time AND vv.visit_time + (vv.expected_duration_minutes || ' minutes')::INTERVAL)
    );
END;
$$;


--
-- Name: claim_coupon(uuid, character varying, uuid, bigint, uuid); Type: FUNCTION; Schema: public; Owner: -
--

