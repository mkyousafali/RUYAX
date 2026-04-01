CREATE FUNCTION public.verify_quick_access_code(p_code character varying) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $_$
DECLARE
  v_user RECORD;
BEGIN
  -- Validate input format
  IF p_code IS NULL OR LENGTH(p_code) != 6 OR p_code !~ '^[0-9]{6}$' THEN
    RETURN json_build_object('success', false, 'error', 'Invalid access code format');
  END IF;

  -- Find user where crypt(input, stored_hash) = stored_hash
  SELECT id, username, user_type, status, is_master_admin, is_admin,
         employee_id, branch_id, position_id, avatar, quick_access_code, quick_access_salt
  INTO v_user
  FROM users
  WHERE status = 'active'
    AND extensions.crypt(p_code, quick_access_code) = quick_access_code;

  IF NOT FOUND THEN
    RETURN json_build_object('success', false, 'error', 'Invalid access code');
  END IF;

  RETURN json_build_object(
    'success', true,
    'user', json_build_object(
      'id', v_user.id,
      'username', v_user.username,
      'user_type', v_user.user_type,
      'status', v_user.status,
      'is_master_admin', v_user.is_master_admin,
      'is_admin', v_user.is_admin,
      'employee_id', v_user.employee_id,
      'branch_id', v_user.branch_id,
      'position_id', v_user.position_id,
      'avatar', v_user.avatar
    )
  );
END;
$_$;


--
-- Name: verify_quick_task_completion(uuid, uuid, text, boolean); Type: FUNCTION; Schema: public; Owner: -
--

