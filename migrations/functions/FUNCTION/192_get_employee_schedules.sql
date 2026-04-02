CREATE FUNCTION public.get_employee_schedules(p_employee_id bigint, p_start_date date, p_end_date date) RETURNS TABLE(schedule_id bigint, schedule_date date, start_time time without time zone, end_time time without time zone, hours numeric, is_overnight boolean, is_auto boolean)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        ds.id,
        ds.schedule_date,
        ds.scheduled_start_time,
        ds.scheduled_end_time,
        ds.scheduled_hours,
        ds.is_overnight,
        ds.is_auto_generated
    FROM duty_schedules ds
    WHERE ds.employee_id = p_employee_id
      AND ds.schedule_date >= p_start_date
      AND ds.schedule_date <= p_end_date
    ORDER BY ds.schedule_date;
END;
$$;


--
-- Name: get_employee_schedules(uuid, date, date); Type: FUNCTION; Schema: public; Owner: -
--

