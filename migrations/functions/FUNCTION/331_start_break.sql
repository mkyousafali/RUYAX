CREATE FUNCTION public.start_break(p_user_id uuid, p_reason_id integer, p_reason_note text DEFAULT NULL::text) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  v_emp RECORD;
  v_existing UUID;
  v_break_id UUID;
BEGIN
  -- Check for already-open break
  SELECT id INTO v_existing
  FROM break_register
  WHERE user_id = p_user_id AND status = 'open'
  LIMIT 1;

  IF v_existing IS NOT NULL THEN
    RETURN jsonb_build_object('success', false, 'error', 'You already have an open break', 'break_id', v_existing);
  END IF;

  -- Get employee info
  SELECT id, name_en, name_ar, current_branch_id
  INTO v_emp
  FROM hr_employee_master
  WHERE user_id = p_user_id
  LIMIT 1;

  IF v_emp IS NULL THEN
    RETURN jsonb_build_object('success', false, 'error', 'Employee record not found');
  END IF;

  -- Insert break
  INSERT INTO break_register (user_id, employee_id, employee_name_en, employee_name_ar, branch_id, reason_id, reason_note, start_time, status)
  VALUES (p_user_id, v_emp.id, v_emp.name_en, v_emp.name_ar, v_emp.current_branch_id, p_reason_id, p_reason_note, NOW(), 'open')
  RETURNING id INTO v_break_id;

  RETURN jsonb_build_object('success', true, 'break_id', v_break_id);
END;
$$;


--
-- Name: submit_quick_task_completion(uuid, uuid, text, text[], text); Type: FUNCTION; Schema: public; Owner: -
--

