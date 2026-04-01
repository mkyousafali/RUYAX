CREATE FUNCTION public.update_notification_read_count() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Update read_count in notifications table when recipient read status changes
    IF TG_OP = 'UPDATE' AND OLD.is_read = FALSE AND NEW.is_read = TRUE THEN
        UPDATE notifications 
        SET read_count = read_count + 1,
            updated_at = NOW()
        WHERE id = NEW.notification_id;
    ELSIF TG_OP = 'UPDATE' AND OLD.is_read = TRUE AND NEW.is_read = FALSE THEN
        UPDATE notifications 
        SET read_count = GREATEST(read_count - 1, 0),
            updated_at = NOW()
        WHERE id = NEW.notification_id;
    END IF;
    
    RETURN COALESCE(NEW, OLD);
END;
$$;


--
-- Name: update_offer_cart_tiers_updated_at(); Type: FUNCTION; Schema: public; Owner: -
--

