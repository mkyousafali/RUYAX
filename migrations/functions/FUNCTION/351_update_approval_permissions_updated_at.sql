CREATE FUNCTION public.update_approval_permissions_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$;


--
-- Name: update_approver_visibility_config_timestamp(); Type: FUNCTION; Schema: public; Owner: -
--

