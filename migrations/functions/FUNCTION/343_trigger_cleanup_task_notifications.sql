CREATE FUNCTION public.trigger_cleanup_task_notifications() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Clean up notifications related to the deleted task
    DELETE FROM notifications 
    WHERE task_id = OLD.id;
    RETURN OLD;
END;
$$;


--
-- Name: FUNCTION trigger_cleanup_task_notifications(); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.trigger_cleanup_task_notifications() IS 'Trigger function to clean up notifications when tasks are deleted';


--
-- Name: trigger_log_order_offer_usage(); Type: FUNCTION; Schema: public; Owner: -
--

