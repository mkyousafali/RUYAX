CREATE FUNCTION public.update_duty_schedule_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;


--
-- Name: update_early_leave_timestamp(); Type: FUNCTION; Schema: public; Owner: -
--

