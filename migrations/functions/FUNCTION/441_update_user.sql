CREATE FUNCTION public.update_user(p_user_id uuid, p_username character varying DEFAULT NULL::character varying, p_is_master_admin boolean DEFAULT NULL::boolean, p_is_admin boolean DEFAULT NULL::boolean, p_user_type character varying DEFAULT NULL::character varying, p_branch_id bigint DEFAULT NULL::bigint, p_employee_id uuid DEFAULT NULL::uuid, p_position_id uuid DEFAULT NULL::uuid, p_status character varying DEFAULT NULL::character varying, p_avatar text DEFAULT NULL::text) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
BEGIN
  -- Check if user exists
  IF NOT EXISTS (SELECT 1 FROM users WHERE id = p_user_id) THEN
    RETURN json_build_object(
      'success', false,
      'message', 'User not found'
    );
  END IF;

  -- Check if username is being changed and if it's already taken
  IF p_username IS NOT NULL AND p_username != (SELECT username FROM users WHERE id = p_user_id) THEN
    IF EXISTS (SELECT 1 FROM users WHERE username = p_username AND id != p_user_id) THEN
      RETURN json_build_object(
        'success', false,
        'message', 'Username already exists'
      );
    END IF;
  END IF;

  -- Update user with provided fields
  -- Use conditional updates to avoid type casting issues
  IF p_username IS NOT NULL THEN
    UPDATE users SET username = p_username, updated_at = NOW() WHERE id = p_user_id;
  END IF;
  
  IF p_is_master_admin IS NOT NULL THEN
    UPDATE users SET is_master_admin = p_is_master_admin, updated_at = NOW() WHERE id = p_user_id;
  END IF;
  
  IF p_is_admin IS NOT NULL THEN
    UPDATE users SET is_admin = p_is_admin, updated_at = NOW() WHERE id = p_user_id;
  END IF;
  
  IF p_user_type IS NOT NULL THEN
    UPDATE users SET user_type = p_user_type::user_type_enum, updated_at = NOW() WHERE id = p_user_id;
  END IF;
  
  IF p_branch_id IS NOT NULL THEN
    UPDATE users SET branch_id = p_branch_id, updated_at = NOW() WHERE id = p_user_id;
  END IF;
  
  IF p_employee_id IS NOT NULL THEN
    UPDATE users SET employee_id = p_employee_id, updated_at = NOW() WHERE id = p_user_id;
  END IF;
  
  IF p_position_id IS NOT NULL THEN
    UPDATE users SET position_id = p_position_id, updated_at = NOW() WHERE id = p_user_id;
  END IF;
  
  IF p_status IS NOT NULL THEN
    UPDATE users SET status = p_status, updated_at = NOW() WHERE id = p_user_id;
  END IF;
  
  IF p_avatar IS NOT NULL THEN
    UPDATE users SET avatar = p_avatar, updated_at = NOW() WHERE id = p_user_id;
  END IF;

  RETURN json_build_object(
    'success', true,
    'message', 'User updated successfully'
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
-- Name: update_user_device_sessions_updated_at(); Type: FUNCTION; Schema: public; Owner: -
--

