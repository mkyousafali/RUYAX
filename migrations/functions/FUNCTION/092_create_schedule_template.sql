CREATE FUNCTION public.create_schedule_template(p_branch_id bigint, p_template_name character varying, p_start_time time without time zone, p_end_time time without time zone, p_weekdays_only boolean DEFAULT true) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
DECLARE
    template_id BIGINT;
BEGIN
    INSERT INTO schedule_templates (
        branch_id,
        template_name,
        default_start_time,
        default_end_time,
        is_overnight,
        default_hours,
        applies_to_weekdays,
        applies_to_weekends
    ) VALUES (
        p_branch_id,
        p_template_name,
        p_start_time,
        p_end_time,
        is_overnight_shift(p_start_time, p_end_time),
        calculate_working_hours(p_start_time, p_end_time, is_overnight_shift(p_start_time, p_end_time)),
        p_weekdays_only,
        NOT p_weekdays_only
    ) RETURNING id INTO template_id;
    
    RETURN template_id;
END;
$$;


--
-- Name: create_schedule_template(uuid, character varying, time without time zone, time without time zone, boolean); Type: FUNCTION; Schema: public; Owner: -
--

