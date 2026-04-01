CREATE FUNCTION public.update_receiving_user_defaults_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$;


--
-- Name: update_regular_shift_timestamp(); Type: FUNCTION; Schema: public; Owner: -
--

