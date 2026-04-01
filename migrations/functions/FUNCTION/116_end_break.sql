CREATE FUNCTION public.end_break(p_user_id uuid) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  v_break RECORD;
  v_duration INTEGER;
BEGIN
  SELECT id, start_time INTO v_break
  FROM break_register
  WHERE user_id = p_user_id AND status = 'open'
  LIMIT 1;

  IF v_break IS NULL THEN
    RETURN jsonb_build_object('success', false, 'error', 'No open break found');
  END IF;

  v_duration := EXTRACT(EPOCH FROM (NOW() - v_break.start_time))::INTEGER;

  UPDATE break_register
  SET end_time = NOW(),
      duration_seconds = v_duration,
      status = 'closed'
  WHERE id = v_break.id;

  RETURN jsonb_build_object('success', true, 'break_id', v_break.id, 'duration_seconds', v_duration);
END;
$$;


--
-- Name: end_break(uuid, text); Type: FUNCTION; Schema: public; Owner: -
--

