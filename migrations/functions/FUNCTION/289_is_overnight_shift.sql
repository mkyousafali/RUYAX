CREATE FUNCTION public.is_overnight_shift(start_time time without time zone, end_time time without time zone) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $$
BEGIN
    RETURN start_time > end_time;
END;
$$;


--
-- Name: is_product_in_active_bundle(uuid, integer); Type: FUNCTION; Schema: public; Owner: -
--

