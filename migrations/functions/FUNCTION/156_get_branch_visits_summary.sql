CREATE FUNCTION public.get_branch_visits_summary(branch_uuid uuid, start_date date DEFAULT CURRENT_DATE, end_date date DEFAULT (CURRENT_DATE + '30 days'::interval)) RETURNS TABLE(total_visits integer, scheduled_visits integer, confirmed_visits integer, completed_visits integer, high_priority_visits integer, visits_requiring_followup integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        COUNT(*)::INTEGER as total_visits,
        COUNT(CASE WHEN status = 'scheduled' THEN 1 END)::INTEGER as scheduled_visits,
        COUNT(CASE WHEN status = 'confirmed' THEN 1 END)::INTEGER as confirmed_visits,
        COUNT(CASE WHEN status = 'completed' THEN 1 END)::INTEGER as completed_visits,
        COUNT(CASE WHEN priority IN ('high', 'urgent') THEN 1 END)::INTEGER as high_priority_visits,
        COUNT(CASE WHEN follow_up_required = true THEN 1 END)::INTEGER as visits_requiring_followup
    FROM vendor_visits 
    WHERE branch_id = branch_uuid 
    AND visit_date BETWEEN start_date AND end_date;
END;
$$;


--
-- Name: get_break_security_code(); Type: FUNCTION; Schema: public; Owner: -
--

