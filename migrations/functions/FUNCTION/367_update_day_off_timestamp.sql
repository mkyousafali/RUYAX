CREATE FUNCTION public.update_day_off_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;


--
-- Name: update_day_off_weekday_updated_at(); Type: FUNCTION; Schema: public; Owner: -
--

