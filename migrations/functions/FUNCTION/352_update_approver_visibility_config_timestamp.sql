CREATE FUNCTION public.update_approver_visibility_config_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$;


--
-- Name: update_attendance_hours(); Type: FUNCTION; Schema: public; Owner: -
--

