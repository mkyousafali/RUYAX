CREATE FUNCTION public.refresh_broadcast_status(p_broadcast_id uuid) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
    v_total int;
    v_sent_count int;
    v_delivered_count int;
    v_read_count int;
    v_failed_count int;
    v_pending_count int;
    v_broadcast_status text;
    v_old_status text;
BEGIN
    -- Step 1: Update broadcast recipients whose wa_messages have a higher status
    UPDATE wa_broadcast_recipients r
    SET status = sub.new_status
    FROM (
        SELECT 
            r2.id AS recipient_id,
            (
                SELECT m.status
                FROM wa_messages m
                WHERE m.whatsapp_message_id = r2.whatsapp_message_id
                ORDER BY 
                    CASE m.status
                        WHEN 'read' THEN 3
                        WHEN 'delivered' THEN 2
                        WHEN 'sent' THEN 1
                        ELSE 0
                    END DESC
                LIMIT 1
            ) AS new_status
        FROM wa_broadcast_recipients r2
        WHERE r2.broadcast_id = p_broadcast_id
          AND r2.whatsapp_message_id IS NOT NULL
    ) sub
    WHERE r.id = sub.recipient_id
      AND sub.new_status IS NOT NULL
      AND (
          CASE sub.new_status
              WHEN 'read' THEN 3
              WHEN 'delivered' THEN 2
              WHEN 'sent' THEN 1
              ELSE 0
          END
      ) > (
          CASE r.status
              WHEN 'read' THEN 3
              WHEN 'delivered' THEN 2
              WHEN 'sent' THEN 1
              ELSE 0
          END
      );

    -- Step 2: Count statuses (exclusive - each recipient counted in exactly one category)
    SELECT 
        count(*) FILTER (WHERE status = 'pending'),
        count(*) FILTER (WHERE status = 'sent'),
        count(*) FILTER (WHERE status = 'delivered'),
        count(*) FILTER (WHERE status = 'read'),
        count(*) FILTER (WHERE status = 'failed'),
        count(*)
    INTO v_pending_count, v_sent_count, v_delivered_count, v_read_count, v_failed_count, v_total
    FROM wa_broadcast_recipients
    WHERE broadcast_id = p_broadcast_id;

    -- Step 3: Determine broadcast status
    SELECT status INTO v_old_status FROM wa_broadcasts WHERE id = p_broadcast_id;
    v_broadcast_status := v_old_status;
    
    IF v_pending_count > 0 THEN
        v_broadcast_status := 'sending';
    ELSIF v_failed_count = v_total AND v_total > 0 THEN
        v_broadcast_status := 'failed';
    ELSIF v_pending_count = 0 AND v_total > 0 THEN
        v_broadcast_status := 'completed';
    END IF;

    -- Step 4: Update the broadcast row with exclusive counts
    UPDATE wa_broadcasts
    SET 
        sent_count = v_sent_count,
        delivered_count = v_delivered_count,
        read_count = v_read_count,
        failed_count = v_failed_count,
        total_recipients = v_total,
        status = v_broadcast_status
    WHERE id = p_broadcast_id;

    -- Return summary
    RETURN jsonb_build_object(
        'status', v_broadcast_status,
        'total_recipients', v_total,
        'sent_count', v_sent_count,
        'delivered_count', v_delivered_count,
        'read_count', v_read_count,
        'failed_count', v_failed_count,
        'pending_count', v_pending_count
    );
END;
$$;


--
-- Name: refresh_edge_functions_cache(jsonb); Type: FUNCTION; Schema: public; Owner: -
--

