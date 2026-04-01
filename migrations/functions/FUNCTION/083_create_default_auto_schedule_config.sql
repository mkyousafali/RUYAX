CREATE FUNCTION public.create_default_auto_schedule_config(p_branch_id bigint, p_start_time time without time zone DEFAULT '09:00:00'::time without time zone, p_end_time time without time zone DEFAULT '17:00:00'::time without time zone) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO auto_schedule_config (
        branch_id,
        default_start_time,
        default_end_time,
        default_hours
    ) VALUES (
        p_branch_id,
        p_start_time,
        p_end_time,
        calculate_working_hours(p_start_time, p_end_time, FALSE)
    ) ON CONFLICT (branch_id) DO NOTHING;
END;
$$;


--
-- Name: create_default_auto_schedule_config(uuid, time without time zone, time without time zone); Type: FUNCTION; Schema: public; Owner: -
--

