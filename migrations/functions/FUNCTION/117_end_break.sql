CREATE FUNCTION public.end_break(p_user_id uuid, p_security_code text DEFAULT NULL::text) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
    v_break_id uuid;
    v_start_time timestamptz;
    v_duration integer;
BEGIN
    -- Validate security code (required)
    IF p_security_code IS NULL OR p_security_code = '' THEN
        RETURN jsonb_build_object('success', false, 'error', 'Security code is required. Please scan the QR code.');
    END IF;
    
    IF NOT validate_break_code(p_security_code) THEN
        RETURN jsonb_build_object('success', false, 'error', 'Invalid or expired QR code. Please scan the current QR code displayed on the screen.');
    END IF;

    -- Find the open break
    SELECT id, start_time INTO v_break_id, v_start_time
    FROM break_register
    WHERE user_id = p_user_id AND status = 'open'
    ORDER BY start_time DESC
    LIMIT 1;

    IF v_break_id IS NULL THEN
        RETURN jsonb_build_object('success', false, 'error', 'No open break found');
    END IF;

    -- Calculate duration
    v_duration := EXTRACT(EPOCH FROM (NOW() - v_start_time))::integer;

    -- Close the break
    UPDATE break_register
    SET end_time = NOW(),
        duration_seconds = v_duration,
        status = 'closed'
    WHERE id = v_break_id;

    RETURN jsonb_build_object('success', true, 'break_id', v_break_id, 'duration_seconds', v_duration);
END;
$$;


--
-- Name: ensure_single_default_flyer_template(); Type: FUNCTION; Schema: public; Owner: -
--

