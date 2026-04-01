CREATE FUNCTION public.queue_quick_task_push_notifications() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    user_record RECORD;
    notification_payload jsonb;
BEGIN
    -- Only process if this is a task assignment notification
    IF NEW.type = 'task_assignment' AND NEW.target_users IS NOT NULL THEN
        -- Extract assignment details from metadata
        notification_payload := jsonb_build_object(
            'title', NEW.title,
            'body', NEW.message,
            'icon', '/favicon.ico',
            'badge', '/favicon.ico',
            'data', jsonb_build_object(
                'notificationId', NEW.id,
                'type', NEW.type,
                'quick_task_id', (NEW.metadata->>'quick_task_id'),
                'assignment_details', (NEW.metadata->>'assignment_details'),
                'url', '/mobile/quick-task'
            )
        );

        -- Queue push notifications for each target user
        FOR user_record IN 
            SELECT DISTINCT jsonb_array_elements_text(NEW.target_users) as user_id
        LOOP
            INSERT INTO notification_queue (
                notification_id,
                user_id,
                status,
                payload,
                created_at
            ) VALUES (
                NEW.id,
                user_record.user_id::uuid,
                'pending',
                notification_payload,
                NOW()
            );
        END LOOP;
    END IF;
    
    RETURN NEW;
END;
$$;


--
-- Name: FUNCTION queue_quick_task_push_notifications(); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.queue_quick_task_push_notifications() IS 'Enhanced queue function with better payload information for Quick Task notifications';


--
-- Name: reassign_receiving_task(uuid, uuid, text, text); Type: FUNCTION; Schema: public; Owner: -
--

