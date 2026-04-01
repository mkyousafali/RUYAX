CREATE FUNCTION public.get_broadcast_summary(p_broadcast_id uuid) RETURNS TABLE(total_count bigint, pending_count bigint, sent_count bigint, delivered_count bigint, read_count bigint, failed_count bigint)
    LANGUAGE sql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
    SELECT 
        COUNT(*)::bigint AS total_count,
        COUNT(*) FILTER (WHERE status = 'pending')::bigint AS pending_count,
        COUNT(*) FILTER (WHERE status = 'sent')::bigint AS sent_count,
        COUNT(*) FILTER (WHERE status = 'delivered')::bigint AS delivered_count,
        COUNT(*) FILTER (WHERE status = 'read')::bigint AS read_count,
        COUNT(*) FILTER (WHERE status = 'failed')::bigint AS failed_count
    FROM wa_broadcast_recipients
    WHERE broadcast_id = p_broadcast_id;
$$;


--
-- Name: get_bt_assigned_ims(uuid[]); Type: FUNCTION; Schema: public; Owner: -
--

