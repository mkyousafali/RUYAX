CREATE FUNCTION public.update_special_shift_date_wise_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;


--
-- Name: update_special_shift_weekday_timestamp(); Type: FUNCTION; Schema: public; Owner: -
--

