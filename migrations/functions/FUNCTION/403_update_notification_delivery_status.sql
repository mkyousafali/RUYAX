CREATE FUNCTION public.update_notification_delivery_status() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    -- When a notification_queue item is marked as 'sent', update the recipient's delivery status
    IF NEW.status = 'sent' AND OLD.status != 'sent' THEN
        UPDATE notification_recipients
        SET 
            delivery_status = 'delivered',
            delivery_attempted_at = NEW.sent_at,
            updated_at = NOW()
        WHERE notification_id = NEW.notification_id
        AND user_id = NEW.user_id;
        
        RAISE NOTICE 'Updated delivery status for notification % user %', NEW.notification_id, NEW.user_id;
    
    -- When a notification_queue item is marked as 'failed', update the recipient's delivery status
    ELSIF NEW.status = 'failed' AND OLD.status != 'failed' THEN
        UPDATE notification_recipients
        SET 
            delivery_status = 'failed',
            delivery_attempted_at = NEW.last_attempt_at,
            error_message = NEW.error_message,
            updated_at = NOW()
        WHERE notification_id = NEW.notification_id
        AND user_id = NEW.user_id;
        
        RAISE NOTICE 'Marked delivery as failed for notification % user %', NEW.notification_id, NEW.user_id;
    END IF;
    
    RETURN NEW;
END;
$$;


--
-- Name: FUNCTION update_notification_delivery_status(); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.update_notification_delivery_status() IS 'Updates notification_recipients.delivery_status when push notifications are sent or failed.';


--
-- Name: update_notification_queue_updated_at(); Type: FUNCTION; Schema: public; Owner: -
--

