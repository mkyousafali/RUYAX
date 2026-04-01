CREATE FUNCTION public.deactivate_expired_media() RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    UPDATE customer_app_media
    SET 
        is_active = false,
        deactivated_at = NOW(),
        updated_at = NOW()
    WHERE 
        is_active = true
        AND is_infinite = false
        AND expiry_date <= NOW();
END;
$$;


--
-- Name: FUNCTION deactivate_expired_media(); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.deactivate_expired_media() IS 'Automatically deactivates media that has passed its expiry date';


--
-- Name: debug_get_dependency_photos(uuid, text[]); Type: FUNCTION; Schema: public; Owner: -
--

