CREATE FUNCTION public.get_active_break(p_user_id uuid) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  v_break RECORD;
  v_reason RECORD;
BEGIN
  SELECT br.*, br.reason_id as rid
  INTO v_break
  FROM break_register br
  WHERE br.user_id = p_user_id AND br.status = 'open'
  LIMIT 1;

  IF v_break IS NULL THEN
    RETURN jsonb_build_object('active', false);
  END IF;

  SELECT name_en, name_ar INTO v_reason
  FROM break_reasons WHERE id = v_break.rid;

  RETURN jsonb_build_object(
    'active', true,
    'break_id', v_break.id,
    'start_time', v_break.start_time,
    'reason_en', v_reason.name_en,
    'reason_ar', v_reason.name_ar,
    'reason_note', v_break.reason_note
  );
END;
$$;


--
-- Name: get_active_customer_media(); Type: FUNCTION; Schema: public; Owner: -
--

