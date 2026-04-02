CREATE FUNCTION public.get_visits_by_date_range(start_date_param date DEFAULT CURRENT_DATE, end_date_param date DEFAULT (CURRENT_DATE + '7 days'::interval), branch_uuid uuid DEFAULT NULL::uuid) RETURNS TABLE(id uuid, vendor_name text, branch_name text, visit_type text, next_visit_date date, pattern_config jsonb, notes text, is_active boolean, created_at timestamp with time zone)
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
        COALESCE(vv.is_active, true) as is_active,
        vv.created_at
    FROM vendor_visits vv
    JOIN vendors v ON vv.vendor_id = v.id
    JOIN branches b ON vv.branch_id = b.id
    WHERE vv.next_visit_date BETWEEN start_date_param AND end_date_param
    AND COALESCE(vv.is_active, true) = true
    AND (branch_uuid IS NULL OR vv.branch_id = branch_uuid)
    ORDER BY vv.next_visit_date ASC;
END;
$$;


--
-- Name: get_wa_catalog_stats(uuid); Type: FUNCTION; Schema: public; Owner: -
--

