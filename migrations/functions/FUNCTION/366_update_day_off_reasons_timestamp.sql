CREATE FUNCTION public.update_day_off_reasons_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$;


--
-- Name: update_day_off_timestamp(); Type: FUNCTION; Schema: public; Owner: -
--

