CREATE FUNCTION public.create_user(p_username character varying, p_password character varying, p_is_master_admin boolean DEFAULT false, p_is_admin boolean DEFAULT false, p_user_type character varying DEFAULT 'branch_specific'::character varying, p_branch_id bigint DEFAULT NULL::bigint, p_employee_id uuid DEFAULT NULL::uuid, p_position_id uuid DEFAULT NULL::uuid, p_quick_access_code character varying DEFAULT NULL::character varying) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
  v_user_id UUID;
  v_quick_access_code VARCHAR(6);
  v_quick_access_hash TEXT;
  v_password_hash TEXT;
  v_salt TEXT;
  v_quick_access_salt TEXT;
BEGIN
  v_salt := extensions.gen_salt('bf');
  v_quick_access_salt := extensions.gen_salt('bf');

  IF p_quick_access_code IS NULL THEN
    -- Generate a unique random 6-digit code
    v_quick_access_code := LPAD(FLOOR(RANDOM() * 1000000)::TEXT, 6, '0');

    -- Loop until we find a unique code (check against hashed values)
    WHILE EXISTS (
      SELECT 1 FROM users 
      WHERE extensions.crypt(v_quick_access_code, quick_access_code) = quick_access_code
    ) LOOP
      v_quick_access_code := LPAD(FLOOR(RANDOM() * 1000000)::TEXT, 6, '0');
    END LOOP;
  ELSE
    v_quick_access_code := p_quick_access_code;

    -- Check if this code already exists (by hashing and comparing)
    IF EXISTS (
      SELECT 1 FROM users 
      WHERE extensions.crypt(v_quick_access_code, quick_access_code) = quick_access_code
    ) THEN
      RETURN json_build_object(
        'success', false,
        'message', 'Quick access code already exists'
      );
    END IF;
  END IF;

  IF EXISTS (SELECT 1 FROM users WHERE username = p_username) THEN
    RETURN json_build_object(
      'success', false,
      'message', 'Username already exists'
    );
  END IF;

  v_password_hash := extensions.crypt(p_password, v_salt);
  
  -- Hash the quick access code with bcrypt
  v_quick_access_hash := extensions.crypt(v_quick_access_code, v_quick_access_salt);

  INSERT INTO users (
    username,
    password_hash,
    salt,
    quick_access_code,
    quick_access_salt,
    is_master_admin,
    is_admin,
    user_type,
    branch_id,
    employee_id,
    position_id,
    status,
    is_first_login,
    failed_login_attempts,
    created_at,
    updated_at
  ) VALUES (
    p_username,
    v_password_hash,
    v_salt,
    v_quick_access_hash,        -- Store hashed code instead of plain text
    v_quick_access_salt,
    p_is_master_admin,
    p_is_admin,
    p_user_type::user_type_enum,
    p_branch_id,
    p_employee_id,
    p_position_id,
    'active',
    true,
    0,
    NOW(),
    NOW()
  )
  RETURNING id INTO v_user_id;

  RETURN json_build_object(
    'success', true,
    'user_id', v_user_id,
    'quick_access_code', v_quick_access_code,   -- Return plain code to show to user
    'message', 'User created successfully'
  );

EXCEPTION
  WHEN OTHERS THEN
    RETURN json_build_object(
      'success', false,
      'message', SQLERRM
    );
END;
$$;


--
-- Name: create_user_profile(); Type: FUNCTION; Schema: public; Owner: -
--

