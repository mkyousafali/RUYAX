CREATE FUNCTION public.is_user_admin(check_user_id uuid) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  user_is_master_admin BOOLEAN;
  user_is_admin BOOLEAN;
BEGIN
  SELECT is_master_admin, is_admin
  INTO user_is_master_admin, user_is_admin
  FROM users
  WHERE id = check_user_id;
  
  RETURN COALESCE(user_is_master_admin, false) OR COALESCE(user_is_admin, false);
END;
$$;


--
-- Name: is_user_master_admin(uuid); Type: FUNCTION; Schema: public; Owner: -
--

