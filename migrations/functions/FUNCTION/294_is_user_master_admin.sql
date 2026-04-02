CREATE FUNCTION public.is_user_master_admin(check_user_id uuid) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  user_is_master_admin BOOLEAN;
BEGIN
  SELECT is_master_admin
  INTO user_is_master_admin
  FROM users
  WHERE id = check_user_id;
  
  RETURN COALESCE(user_is_master_admin, false);
END;
$$;


--
-- Name: link_finger_transaction_to_employee(character varying, uuid); Type: FUNCTION; Schema: public; Owner: -
--

