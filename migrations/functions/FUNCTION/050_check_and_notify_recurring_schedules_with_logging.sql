CREATE FUNCTION public.check_and_notify_recurring_schedules_with_logging() RETURNS TABLE(schedules_checked integer, notifications_sent integer, execution_date date, message text)
    LANGUAGE plpgsql
    AS $$
DECLARE
    checked_count INTEGER := 0;
    notified_count INTEGER := 0;
    rec RECORD;
BEGIN
    -- Run the notification check
    FOR rec IN SELECT * FROM check_and_notify_recurring_schedules()
    LOOP
        checked_count := checked_count + 1;
        IF rec.notification_sent THEN
            notified_count := notified_count + 1;
        END IF;
    END LOOP;
    
    -- Log the execution
    INSERT INTO recurring_schedule_check_log (
        check_date,
        schedules_checked,
        notifications_sent
    ) VALUES (
        CURRENT_DATE,
        checked_count,
        notified_count
    )
    ON CONFLICT (check_date) 
    DO UPDATE SET
        schedules_checked = recurring_schedule_check_log.schedules_checked + EXCLUDED.schedules_checked,
        notifications_sent = recurring_schedule_check_log.notifications_sent + EXCLUDED.notifications_sent;
    
    -- Return summary
    schedules_checked := checked_count;
    notifications_sent := notified_count;
    execution_date := CURRENT_DATE;
    message := FORMAT('Checked %s schedules, sent %s notifications', checked_count, notified_count);
    RETURN NEXT;
END;
$$;


--
-- Name: FUNCTION check_and_notify_recurring_schedules_with_logging(); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.check_and_notify_recurring_schedules_with_logging() IS 'Wrapper function that calls check_and_notify_recurring_schedules() and logs execution. Use this for cron jobs or manual execution.';


--
-- Name: check_erp_sync_status(); Type: FUNCTION; Schema: public; Owner: -
--

