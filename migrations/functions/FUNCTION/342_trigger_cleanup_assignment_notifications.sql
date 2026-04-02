CREATE FUNCTION public.trigger_cleanup_assignment_notifications() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Clean up notifications related to the deleted assignment
    DELETE FROM notifications 
    WHERE task_assignment_id = OLD.id;
    RETURN OLD;
END;
$$;


--
-- Name: FUNCTION trigger_cleanup_assignment_notifications(); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.trigger_cleanup_assignment_notifications() IS 'Trigger function to clean up notifications when task assignments are deleted';


--
-- Name: trigger_cleanup_task_notifications(); Type: FUNCTION; Schema: public; Owner: -
--

