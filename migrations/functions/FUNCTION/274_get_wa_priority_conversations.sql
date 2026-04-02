CREATE FUNCTION public.get_wa_priority_conversations(p_account_id uuid) RETURNS TABLE(id uuid, customer_phone character varying, customer_name text, last_message_at timestamp with time zone, last_message_preview text, unread_count integer, is_bot_handling boolean, bot_type character varying, handled_by character varying, needs_human boolean, status character varying, is_inside_24hr boolean, is_sos boolean, total_count bigint)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        c.id,
        c.customer_phone,
        c.customer_name,
        c.last_message_at,
        c.last_message_preview,
        c.unread_count,
        c.is_bot_handling,
        c.bot_type,
        c.handled_by,
        c.needs_human,
        c.status,
        CASE
            WHEN c.last_message_at IS NOT NULL
                 AND c.last_message_at > (NOW() - INTERVAL '24 hours')
            THEN TRUE
            ELSE FALSE
        END AS is_inside_24hr,
        c.is_sos,
        COUNT(*) OVER() AS total_count
    FROM wa_conversations c
    WHERE c.wa_account_id = p_account_id
      AND c.status = 'active'
      AND (c.is_sos = TRUE OR c.needs_human = TRUE)
    ORDER BY
        CASE WHEN c.is_sos = TRUE THEN 0 ELSE 1 END ASC,
        c.last_message_at DESC NULLS LAST;
END;
$$;


--
-- Name: handle_document_deactivation(); Type: FUNCTION; Schema: public; Owner: -
--

