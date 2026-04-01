CREATE FUNCTION public.track_media_activation() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.is_active = true AND (OLD.is_active IS NULL OR OLD.is_active = false) THEN
        NEW.activated_at = NOW();
    END IF;
    
    IF NEW.is_active = false AND OLD.is_active = true THEN
        NEW.deactivated_at = NOW();
    END IF;
    
    RETURN NEW;
END;
$$;


--
-- Name: trigger_cleanup_assignment_notifications(); Type: FUNCTION; Schema: public; Owner: -
--

