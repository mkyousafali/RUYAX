CREATE FUNCTION public.get_active_customer_media() RETURNS TABLE(id uuid, media_type character varying, slot_number integer, title_en character varying, title_ar character varying, file_url text, duration integer, display_order integer)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        cam.id,
        cam.media_type,
        cam.slot_number,
        cam.title_en,
        cam.title_ar,
        cam.file_url,
        cam.duration,
        cam.display_order
    FROM customer_app_media cam
    WHERE cam.is_active = true
      AND (
          cam.is_infinite = true 
          OR cam.expiry_date > NOW()
      )
    ORDER BY cam.display_order ASC, cam.created_at DESC;
END;
$$;


--
-- Name: FUNCTION get_active_customer_media(); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.get_active_customer_media() IS 'Returns all active non-expired media for customer home page display';


--
-- Name: get_active_employees_by_branch(uuid); Type: FUNCTION; Schema: public; Owner: -
--

