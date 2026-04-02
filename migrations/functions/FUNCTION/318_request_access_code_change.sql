CREATE FUNCTION public.request_access_code_change(p_email character varying, p_whatsapp character varying) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
  v_user_id UUID;
  v_otp VARCHAR(6);
  v_whatsapp_clean VARCHAR(20);
BEGIN
  -- Clean WhatsApp number (remove spaces, dashes)
  v_whatsapp_clean := REGEXP_REPLACE(p_whatsapp, '[\s\-]', '', 'g');

  -- Find the user by matching email AND whatsapp_number in hr_employee_master
  -- Correct relationship: hr_employee_master.user_id = users.id
  SELECT u.id INTO v_user_id
  FROM users u
  JOIN hr_employee_master e ON e.user_id = u.id
  WHERE LOWER(TRIM(e.email)) = LOWER(TRIM(p_email))
    AND REGEXP_REPLACE(e.whatsapp_number, '[\s\-]', '', 'g') = v_whatsapp_clean
    AND u.status = 'active'
  LIMIT 1;

  IF v_user_id IS NULL THEN
    RETURN json_build_object(
      'success', false,
      'message', 'No matching user found. Please check your email and WhatsApp number.'
    );
  END IF;

  -- Rate limit: max 3 OTP requests per hour per user
  IF (
    SELECT COUNT(*) FROM access_code_otp
    WHERE user_id = v_user_id
      AND created_at > NOW() - INTERVAL '1 hour'
  ) >= 3 THEN
    RETURN json_build_object(
      'success', false,
      'message', 'Too many requests. Please try again later.'
    );
  END IF;

  -- Delete any existing unused OTPs for this user
  DELETE FROM access_code_otp WHERE user_id = v_user_id AND verified = false;

  -- Generate 6-digit OTP
  v_otp := LPAD(FLOOR(RANDOM() * 1000000)::TEXT, 6, '0');

  -- Store OTP (expires in 5 minutes)
  INSERT INTO access_code_otp (user_id, otp_code, email, whatsapp_number, expires_at)
  VALUES (v_user_id, v_otp, p_email, v_whatsapp_clean, NOW() + INTERVAL '5 minutes');

  RETURN json_build_object(
    'success', true,
    'otp', v_otp,
    'whatsapp_number', v_whatsapp_clean,
    'message', 'OTP generated successfully'
  );
END;
$$;


--
-- Name: request_access_code_resend(text); Type: FUNCTION; Schema: public; Owner: -
--

