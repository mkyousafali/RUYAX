CREATE FUNCTION public.current_user_is_admin() RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  RETURN current_setting('app.is_master_admin', true)::BOOLEAN 
         OR current_setting('app.is_admin', true)::BOOLEAN;
EXCEPTION
  WHEN OTHERS THEN
    RETURN false;
END;
$$;


--
-- Name: daily_erp_sync_maintenance(); Type: FUNCTION; Schema: public; Owner: -
--

