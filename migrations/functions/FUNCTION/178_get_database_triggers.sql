CREATE FUNCTION public.get_database_triggers() RETURNS TABLE(trigger_name text, event_manipulation text, event_object_table text, action_statement text, action_timing text)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        tg.trigger_name::text,
        tg.event_manipulation::text,
        tg.event_object_table::text,
        tg.action_statement::text,
        tg.action_timing::text
    FROM information_schema.triggers tg
    WHERE tg.trigger_schema = 'public'
    ORDER BY tg.event_object_table, tg.trigger_name;
END;
$$;


--
-- Name: get_day_offs_with_details(date, date); Type: FUNCTION; Schema: public; Owner: -
--

