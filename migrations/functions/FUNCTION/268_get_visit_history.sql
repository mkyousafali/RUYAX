CREATE FUNCTION public.get_visit_history(start_date_param date DEFAULT (CURRENT_DATE - '30 days'::interval), end_date_param date DEFAULT CURRENT_DATE, branch_uuid uuid DEFAULT NULL::uuid) RETURNS TABLE(id uuid, vendor_name text, branch_name text, visit_type text, scheduled_date date, actual_date date, status text, outcome_notes text, completed_by text, duration_minutes integer, next_scheduled_date date, created_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        vh.id,
        v.name::TEXT as vendor_name,
        b.name::TEXT as branch_name,
        vv.visit_type::TEXT,
        vh.scheduled_date,
        vh.actual_date,
        vh.status::TEXT,
        COALESCE(vh.outcome_notes, '')::TEXT,
        COALESCE(vh.completed_by, '')::TEXT,
        vh.duration_minutes,
        vh.next_scheduled_date,
        vh.created_at
    FROM visit_history vh
    JOIN vendor_visits vv ON vh.visit_schedule_id = vv.id
    JOIN vendors v ON vh.vendor_id = v.id
    JOIN branches b ON vh.branch_id = b.id
    WHERE vh.scheduled_date BETWEEN start_date_param AND end_date_param
    AND (branch_uuid IS NULL OR vh.branch_id = branch_uuid)
    ORDER BY vh.scheduled_date DESC, vh.created_at DESC;
END;
$$;


--
-- Name: get_visits_by_date_range(date, date); Type: FUNCTION; Schema: public; Owner: -
--

