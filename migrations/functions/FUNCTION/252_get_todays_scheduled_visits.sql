CREATE FUNCTION public.get_todays_scheduled_visits(target_date date DEFAULT CURRENT_DATE) RETURNS TABLE(id uuid, vendor_name text, branch_name text, visit_type text, pattern_info text, notes text, branch_id uuid, vendor_id uuid, weekday_name text, fresh_type text, day_number integer, skip_days integer, start_date date, next_visit_date date)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        vv.id,
        v.name::TEXT as vendor_name,
        b.name::TEXT as branch_name,
        vv.visit_type::TEXT,
        CASE 
            WHEN vv.visit_type = 'weekly' THEN ('Weekly on ' || COALESCE(vv.weekday_name, ''))::TEXT
            WHEN vv.visit_type = 'daily' THEN ('Daily (' || COALESCE(vv.fresh_type, '') || ')')::TEXT
            WHEN vv.visit_type = 'monthly' THEN ('Monthly on day ' || COALESCE(vv.day_number::TEXT, ''))::TEXT
            WHEN vv.visit_type = 'skip_days' THEN ('Every ' || COALESCE(vv.skip_days::TEXT, '') || ' days')::TEXT
            ELSE vv.visit_type::TEXT
        END as pattern_info,
        COALESCE(vv.notes, '')::TEXT,
        vv.branch_id,
        vv.vendor_id,
        COALESCE(vv.weekday_name, '')::TEXT,
        COALESCE(vv.fresh_type, '')::TEXT,
        vv.day_number,
        vv.skip_days,
        vv.start_date,
        vv.next_visit_date
    FROM vendor_visits vv
    JOIN vendors v ON vv.vendor_id = v.id
    JOIN branches b ON vv.branch_id = b.id
    WHERE vv.next_visit_date = target_date
    AND vv.status = 'active'
    ORDER BY b.name, v.name;
END;
$$;


--
-- Name: get_todays_scheduled_visits(uuid); Type: FUNCTION; Schema: public; Owner: -
--

