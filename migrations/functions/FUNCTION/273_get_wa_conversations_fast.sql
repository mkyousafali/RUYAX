CREATE FUNCTION public.get_wa_conversations_fast(p_account_id uuid, p_limit integer DEFAULT 50, p_offset integer DEFAULT 0, p_search text DEFAULT NULL::text, p_filter text DEFAULT 'all'::text) RETURNS TABLE(id uuid, customer_phone character varying, customer_name text, last_message_at timestamp with time zone, last_message_preview text, unread_count integer, is_bot_handling boolean, bot_type character varying, handled_by character varying, needs_human boolean, status character varying, is_inside_24hr boolean, is_sos boolean, total_count bigint)
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
      -- Exclude priority conversations (SOS / needs_human) ΓÇö they go in their own section
      AND c.is_sos IS NOT TRUE
      AND c.needs_human IS NOT TRUE
      -- Search filter
      AND (
          p_search IS NULL
          OR p_search = ''
          OR c.customer_name ILIKE '%' || p_search || '%'
          OR c.customer_phone ILIKE '%' || p_search || '%'
      )
      -- Chat filter
      AND (
          p_filter = 'all'
          OR (p_filter = 'unread' AND c.unread_count > 0)
          OR (p_filter = 'ai' AND c.is_bot_handling = TRUE AND c.bot_type = 'ai')
          OR (p_filter = 'bot' AND c.is_bot_handling = TRUE AND c.bot_type = 'auto_reply')
          OR (p_filter = 'human' AND c.is_bot_handling = FALSE)
      )
    ORDER BY c.last_message_at DESC NULLS LAST
    LIMIT p_limit
    OFFSET p_offset;
END;
$$;


--
-- Name: get_wa_priority_conversations(uuid); Type: FUNCTION; Schema: public; Owner: -
--

