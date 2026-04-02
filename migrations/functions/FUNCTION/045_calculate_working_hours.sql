CREATE FUNCTION public.calculate_working_hours(check_in timestamp with time zone, check_out timestamp with time zone) RETURNS numeric
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF check_in IS NULL OR check_out IS NULL THEN
        RETURN 0.00;
    END IF;
    
    IF check_out <= check_in THEN
        RETURN 0.00;
    END IF;
    
    RETURN ROUND(
        EXTRACT(EPOCH FROM (check_out - check_in)) / 3600.0,
        2
    );
END;
$$;


--
-- Name: calculate_working_hours(time without time zone, time without time zone, boolean); Type: FUNCTION; Schema: public; Owner: -
--

