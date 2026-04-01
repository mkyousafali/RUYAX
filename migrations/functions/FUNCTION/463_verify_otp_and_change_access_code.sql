CREATE FUNCTION public.verify_otp_and_change_access_code(p_email character varying, p_whatsapp character varying, p_otp character varying, p_new_code character varying) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
  v_user_id UUID;
  v_otp_record RECORD;
  v_whatsapp_clean VARCHAR(20);
  v_hashed_code VARCHAR(255);
  v_existing_count INT;
BEGIN
  v_whatsapp_clean := REGEXP_REPLACE(p_whatsapp, '[\s\-]', '', 'g');

  -- Find matching user (correct JOIN: e.user_id = u.id)
  SELECT u.id INTO v_user_id
  FROM users u
  JOIN hr_employee_master e ON e.user_id = u.id
  WHERE LOWER(TRIM(e.email)) = LOWER(TRIM(p_email))
    AND REGEXP_REPLACE(e.whatsapp_number, '[\s\-]', '', 'g') = v_whatsapp_clean
    AND u.status = 'active'
  LIMIT 1;

  IF v_user_id IS NULL THEN
    RETURN json_build_object('success', false, 'message', 'User not found.');
  END IF;

  -- Find valid OTP
  SELECT id, otp_code, attempts INTO v_otp_record
  FROM access_code_otp
  WHERE user_id = v_user_id
    AND verified = false
    AND expires_at > NOW()
  ORDER BY created_at DESC
  LIMIT 1;

  IF v_otp_record IS NULL THEN
    RETURN json_build_object('success', false, 'message', 'No valid OTP found. Please request a new one.');
  END IF;

  -- Check attempts
  IF v_otp_record.attempts >= 5 THEN
    UPDATE access_code_otp SET verified = true WHERE id = v_otp_record.id;
    RETURN json_build_object('success', false, 'message', 'Too many failed attempts. Please request a new OTP.');
  END IF;

  -- Verify OTP
  IF v_otp_record.otp_code != p_otp THEN
    UPDATE access_code_otp SET attempts = attempts + 1 WHERE id = v_otp_record.id;
    RETURN json_build_object('success', false, 'message', 'Invalid OTP code.');
  END IF;

  -- Check new code is not already used by another user
  SELECT COUNT(*) INTO v_existing_count
  FROM users
  WHERE id != v_user_id
    AND quick_access_code IS NOT NULL
    AND quick_access_code != ''
    AND extensions.crypt(p_new_code, quick_access_code) = quick_access_code;

  IF v_existing_count > 0 THEN
    RETURN json_build_object('success', false, 'message', 'This access code is already in use. Please choose a different one.');
  END IF;

  -- Hash the new code and update
  v_hashed_code := extensions.crypt(p_new_code, extensions.gen_salt('bf'));

  UPDATE users
  SET quick_access_code = v_hashed_code,
      updated_at = NOW()
  WHERE id = v_user_id;

  -- Mark OTP as verified
  UPDATE access_code_otp SET verified = true WHERE id = v_otp_record.id;

  RETURN json_build_object('success', true, 'message', 'Access code changed successfully.');
END;
$$;


--
-- Name: verify_password(text, text); Type: FUNCTION; Schema: public; Owner: -
--

