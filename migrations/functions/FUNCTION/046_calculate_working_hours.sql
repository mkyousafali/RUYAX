CREATE FUNCTION public.calculate_working_hours(start_time time without time zone, end_time time without time zone, is_overnight_shift boolean DEFAULT false) RETURNS numeric
    LANGUAGE plpgsql IMMUTABLE
    AS $$
BEGIN
    IF is_overnight_shift THEN
        -- For overnight shifts: (24:00 - start_time) + end_time
        RETURN ROUND(
            (EXTRACT(EPOCH FROM (TIME '24:00:00' - start_time)) + 
             EXTRACT(EPOCH FROM end_time)) / 3600.0, 2
        );
    ELSE
        -- For regular shifts: end_time - start_time
        RETURN ROUND(
            EXTRACT(EPOCH FROM (end_time - start_time)) / 3600.0, 2
        );
    END IF;
END;
$$;


--
-- Name: cancel_order(uuid, uuid, text); Type: FUNCTION; Schema: public; Owner: -
--

