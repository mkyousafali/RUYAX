CREATE FUNCTION public.set_user_context(user_id uuid, is_master_admin boolean DEFAULT false, is_admin boolean DEFAULT false) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  -- Set configuration variables that RLS policies can access
  PERFORM set_config('app.current_user_id', user_id::text, false);
  PERFORM set_config('app.is_master_admin', is_master_admin::text, false);
  PERFORM set_config('app.is_admin', is_admin::text, false);
END;
$$;


--
-- Name: setup_role_permissions(text, jsonb); Type: FUNCTION; Schema: public; Owner: -
--

