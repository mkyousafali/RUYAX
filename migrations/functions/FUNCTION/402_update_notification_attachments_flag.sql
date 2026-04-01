CREATE FUNCTION public.update_notification_attachments_flag() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE notifications 
        SET has_attachments = TRUE,
            updated_at = NOW()
        WHERE id = NEW.notification_id;
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        UPDATE notifications 
        SET has_attachments = (
            SELECT COUNT(*) > 0 
            FROM notification_attachments 
            WHERE notification_id = OLD.notification_id
        ),
        updated_at = NOW()
        WHERE id = OLD.notification_id;
        RETURN OLD;
    END IF;
    
    RETURN NULL;
END;
$$;


--
-- Name: update_notification_delivery_status(); Type: FUNCTION; Schema: public; Owner: -
--

