CREATE FUNCTION public.get_delivery_service_settings() RETURNS TABLE(minimum_order_amount numeric, is_24_hours boolean, operating_start_time time without time zone, operating_end_time time without time zone, is_active boolean, display_message_ar text, display_message_en text)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        s.minimum_order_amount,
        s.is_24_hours,
        s.operating_start_time,
        s.operating_end_time,
        s.is_active,
        s.display_message_ar,
        s.display_message_en
    FROM public.delivery_service_settings s
    WHERE s.id = '00000000-0000-0000-0000-000000000001'::uuid
    LIMIT 1;
END;
$$;


--
-- Name: FUNCTION get_delivery_service_settings(); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.get_delivery_service_settings() IS 'Get global delivery service configuration settings';


--
-- Name: get_delivery_tiers_by_branch(bigint); Type: FUNCTION; Schema: public; Owner: -
--

