CREATE FUNCTION public.get_vendor_promissory_notes_summary(vendor_uuid uuid) RETURNS TABLE(total_notes integer, total_active_amount numeric, total_collected_amount numeric, oldest_active_date date, newest_note_date date)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        COUNT(*)::INTEGER as total_notes,
        COALESCE(SUM(CASE WHEN status = 'active' THEN amount ELSE 0 END), 0) as total_active_amount,
        COALESCE(SUM(CASE WHEN status = 'collected' THEN amount ELSE 0 END), 0) as total_collected_amount,
        MIN(CASE WHEN status = 'active' THEN signed_date END) as oldest_active_date,
        MAX(signed_date) as newest_note_date
    FROM promissory_notes 
    WHERE vendor_id = vendor_uuid;
END;
$$;


--
-- Name: get_vendor_visits_summary(uuid); Type: FUNCTION; Schema: public; Owner: -
--

