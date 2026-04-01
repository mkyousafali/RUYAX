CREATE FUNCTION public.get_broadcast_recipients(p_broadcast_id uuid, p_limit integer DEFAULT 100, p_offset integer DEFAULT 0, p_status_filter text DEFAULT NULL::text) RETURNS TABLE(id uuid, phone_number character varying, customer_name text, status character varying, sent_at timestamp with time zone, error_details text)
    LANGUAGE sql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
    SELECT r.id, r.phone_number, r.customer_name, r.status, r.sent_at, r.error_details
    FROM wa_broadcast_recipients r
    WHERE r.broadcast_id = p_broadcast_id
      AND (p_status_filter IS NULL OR r.status = p_status_filter)
    ORDER BY r.sent_at DESC NULLS LAST
    LIMIT p_limit
    OFFSET p_offset;
$$;


--
-- Name: get_broadcast_summary(uuid); Type: FUNCTION; Schema: public; Owner: -
--

