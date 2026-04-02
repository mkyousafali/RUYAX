CREATE FUNCTION public.process_finger_transaction_linking() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Link with employee if not already set
    IF NEW.employee_id IS NULL THEN
        NEW.employee_id := link_finger_transaction_to_employee(
            NEW.employee_code,
            NEW.branch_id
        );
    END IF;
    
    NEW.updated_at := NOW();
    RETURN NEW;
END;
$$;


--
-- Name: queue_push_notification(uuid, text, jsonb, text[], uuid[]); Type: FUNCTION; Schema: public; Owner: -
--

