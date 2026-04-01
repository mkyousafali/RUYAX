CREATE FUNCTION public.get_wa_contacts(p_limit integer DEFAULT 100, p_offset integer DEFAULT 0, p_search text DEFAULT NULL::text) RETURNS TABLE(id uuid, name text, whatsapp_number character varying, registration_status text, whatsapp_available boolean, created_at timestamp with time zone, approved_at timestamp with time zone, last_login_at timestamp with time zone, is_deleted boolean, conversation_id uuid, last_message_at timestamp with time zone, last_interaction_at timestamp with time zone, unread_count integer, is_inside_24hr boolean, handled_by text, is_bot_handling boolean, total_count bigint)
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
  SELECT
    c.id,
    c.name::text AS name,
    c.whatsapp_number,
    c.registration_status,
    c.whatsapp_available,
    c.created_at,
    c.approved_at,
    c.last_login_at,
    COALESCE(c.is_deleted, false) AS is_deleted,
    conv.id AS conversation_id,
    conv.last_message_at,
    GREATEST(conv.last_message_at, code_hist.last_code_at, c.created_at) AS last_interaction_at,
    COALESCE(conv.unread_count, 0)::int AS unread_count,
    CASE
      WHEN conv.last_message_at IS NOT NULL
        AND conv.last_message_at > (now() - interval '24 hours')
      THEN true
      ELSE false
    END AS is_inside_24hr,
    COALESCE(conv.handled_by, 'bot') AS handled_by,
    COALESCE(conv.is_bot_handling, true) AS is_bot_handling,
    COUNT(*) OVER() AS total_count
  FROM customers c
  LEFT JOIN LATERAL (
    SELECT wc.id, wc.last_message_at, wc.unread_count, wc.handled_by, wc.is_bot_handling
    FROM wa_conversations wc
    WHERE wc.customer_phone = c.whatsapp_number
      AND wc.status = 'active'
    ORDER BY wc.created_at DESC
    LIMIT 1
  ) conv ON true
  LEFT JOIN LATERAL (
    SELECT MAX(ach.created_at) AS last_code_at
    FROM customer_access_code_history ach
    WHERE ach.customer_id = c.id
  ) code_hist ON true
  WHERE c.whatsapp_number IS NOT NULL
    AND c.whatsapp_number != ''
    AND COALESCE(c.is_deleted, false) = false
    AND (
      p_search IS NULL
      OR c.name ILIKE '%' || p_search || '%'
      OR c.whatsapp_number ILIKE '%' || p_search || '%'
    )
  ORDER BY GREATEST(conv.last_message_at, code_hist.last_code_at, c.created_at) DESC NULLS LAST
  LIMIT p_limit
  OFFSET p_offset;
$$;


--
-- Name: get_wa_conversations_fast(uuid, integer, integer, text, text); Type: FUNCTION; Schema: public; Owner: -
--

