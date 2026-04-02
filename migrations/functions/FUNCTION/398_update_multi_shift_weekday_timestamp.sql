CREATE FUNCTION public.update_multi_shift_weekday_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;


--
-- Name: update_near_expiry_reports_updated_at(); Type: FUNCTION; Schema: public; Owner: -
--

