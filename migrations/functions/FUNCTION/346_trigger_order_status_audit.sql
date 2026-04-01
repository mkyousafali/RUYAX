CREATE FUNCTION public.trigger_order_status_audit() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Only log if status actually changed
    IF OLD.order_status IS DISTINCT FROM NEW.order_status THEN
        INSERT INTO order_audit_logs (
            order_id,
            action_type,
            from_status,
            to_status,
            performed_by,
            notes
        ) VALUES (
            NEW.id,
            'status_changed',
            OLD.order_status,
            NEW.order_status,
            NEW.updated_by,
            'Status changed from ' || OLD.order_status || ' to ' || NEW.order_status
        );
    END IF;
    
    RETURN NEW;
END;
$$;


--
-- Name: FUNCTION trigger_order_status_audit(); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.trigger_order_status_audit() IS 'Automatically creates audit log when order status changes';


--
-- Name: trigger_sync_erp_reference_on_task_completion(); Type: FUNCTION; Schema: public; Owner: -
--

