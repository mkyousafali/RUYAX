CREATE FUNCTION public.get_branch_promissory_notes_summary(branch_uuid uuid) RETURNS TABLE(total_notes integer, total_active_amount numeric, total_collected_amount numeric, active_notes_count integer, collected_notes_count integer, cancelled_notes_count integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        COUNT(*)::INTEGER as total_notes,
        COALESCE(SUM(CASE WHEN status = 'active' THEN amount ELSE 0 END), 0) as total_active_amount,
        COALESCE(SUM(CASE WHEN status = 'collected' THEN amount ELSE 0 END), 0) as total_collected_amount,
        COUNT(CASE WHEN status = 'active' THEN 1 END)::INTEGER as active_notes_count,
        COUNT(CASE WHEN status = 'collected' THEN 1 END)::INTEGER as collected_notes_count,
        COUNT(CASE WHEN status = 'cancelled' THEN 1 END)::INTEGER as cancelled_notes_count
    FROM promissory_notes 
    WHERE branch_id = branch_uuid;
END;
$$;


--
-- Name: get_branch_service_availability(uuid); Type: FUNCTION; Schema: public; Owner: -
--

