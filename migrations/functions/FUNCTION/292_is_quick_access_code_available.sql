CREATE FUNCTION public.is_quick_access_code_available(p_quick_access_code character varying) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
BEGIN
  RETURN NOT EXISTS (
    SELECT 1 FROM users
    WHERE extensions.crypt(p_quick_access_code, quick_access_code) = quick_access_code
  );
END;
$$;


--
-- Name: is_user_admin(uuid); Type: FUNCTION; Schema: public; Owner: -
--

