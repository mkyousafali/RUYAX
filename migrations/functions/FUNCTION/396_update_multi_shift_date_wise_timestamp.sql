CREATE FUNCTION public.update_multi_shift_date_wise_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;


--
-- Name: update_multi_shift_regular_timestamp(); Type: FUNCTION; Schema: public; Owner: -
--

