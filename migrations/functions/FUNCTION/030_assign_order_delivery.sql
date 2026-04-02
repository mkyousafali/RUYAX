CREATE FUNCTION public.assign_order_delivery(p_order_id uuid, p_delivery_person_id uuid, p_assigned_by uuid) RETURNS TABLE(success boolean, message text)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_delivery_name VARCHAR(255);
    v_assigned_by_name VARCHAR(255);
BEGIN
    -- Get delivery person name
    SELECT username INTO v_delivery_name
    FROM users
    WHERE id = p_delivery_person_id;
    
    IF NOT FOUND THEN
        RETURN QUERY SELECT FALSE, 'Delivery person not found';
        RETURN;
    END IF;
    
    -- Get assigner name
    SELECT username INTO v_assigned_by_name
    FROM users
    WHERE id = p_assigned_by;
    
    -- Update order
    UPDATE orders
    SET delivery_person_id = p_delivery_person_id,
        delivery_assigned_at = NOW(),
        order_status = CASE 
            WHEN order_status = 'ready' THEN 'out_for_delivery'
            ELSE order_status
        END,
        updated_at = NOW(),
        updated_by = p_assigned_by
    WHERE id = p_order_id;
    
    -- Create audit log
    INSERT INTO order_audit_logs (
        order_id,
        action_type,
        assigned_user_id,
        assigned_user_name,
        assignment_type,
        performed_by,
        performed_by_name,
        notes
    ) VALUES (
        p_order_id,
        'assigned_delivery',
        p_delivery_person_id,
        v_delivery_name,
        'delivery',
        p_assigned_by,
        v_assigned_by_name,
        'Delivery person assigned to order'
    );
    
    RETURN QUERY SELECT TRUE, 'Delivery person assigned successfully';
END;
$$;


--
-- Name: FUNCTION assign_order_delivery(p_order_id uuid, p_delivery_person_id uuid, p_assigned_by uuid); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.assign_order_delivery(p_order_id uuid, p_delivery_person_id uuid, p_assigned_by uuid) IS 'Assigns delivery person to order';


--
-- Name: assign_order_picker(uuid, uuid, uuid); Type: FUNCTION; Schema: public; Owner: -
--

