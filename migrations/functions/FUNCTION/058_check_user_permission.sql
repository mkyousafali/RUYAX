CREATE FUNCTION public.check_user_permission(p_function_code text, p_permission text) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  -- Old role system removed - this function is deprecated
  -- Return false since we now use button_permissions system
  -- TODO: Remove calls to this function from application code
  RETURN false;
END;
$$;


--
-- Name: check_visit_conflicts(uuid, date, time without time zone, integer, uuid); Type: FUNCTION; Schema: public; Owner: -
--

