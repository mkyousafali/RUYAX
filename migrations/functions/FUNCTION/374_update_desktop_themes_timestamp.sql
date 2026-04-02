CREATE FUNCTION public.update_desktop_themes_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$;


--
-- Name: update_duty_schedule_timestamp(); Type: FUNCTION; Schema: public; Owner: -
--

