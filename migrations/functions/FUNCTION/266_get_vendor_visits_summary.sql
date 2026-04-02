CREATE FUNCTION public.get_vendor_visits_summary(vendor_uuid uuid) RETURNS TABLE(total_visits integer, completed_visits integer, scheduled_visits integer, cancelled_visits integer, last_visit_date date, next_visit_date date, avg_duration_minutes numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        COUNT(*)::INTEGER as total_visits,
        COUNT(CASE WHEN status = 'completed' THEN 1 END)::INTEGER as completed_visits,
        COUNT(CASE WHEN status IN ('scheduled', 'confirmed') THEN 1 END)::INTEGER as scheduled_visits,
        COUNT(CASE WHEN status = 'cancelled' THEN 1 END)::INTEGER as cancelled_visits,
        MAX(CASE WHEN status = 'completed' THEN visit_date END) as last_visit_date,
        MIN(CASE WHEN status IN ('scheduled', 'confirmed') AND visit_date >= CURRENT_DATE THEN visit_date END) as next_visit_date,
        AVG(CASE 
            WHEN actual_start_time IS NOT NULL AND actual_end_time IS NOT NULL 
            THEN EXTRACT(EPOCH FROM (actual_end_time - actual_start_time))/60 
            ELSE expected_duration_minutes 
        END)::NUMERIC(10,2) as avg_duration_minutes
    FROM vendor_visits 
    WHERE vendor_id = vendor_uuid;
END;
$$;


--
-- Name: get_vendors_by_branch(bigint); Type: FUNCTION; Schema: public; Owner: -
--

