CREATE FUNCTION public.update_user_device_sessions_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$;


--
-- Name: update_user_theme_assignments_timestamp(); Type: FUNCTION; Schema: public; Owner: -
--

