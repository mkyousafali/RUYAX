CREATE FUNCTION public.cancel_order(p_order_id uuid, p_user_id uuid, p_cancellation_reason text) RETURNS TABLE(success boolean, message text)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_current_status VARCHAR(50);
    v_user_name VARCHAR(255);
BEGIN
    -- Get current status
    SELECT order_status INTO v_current_status
    FROM orders
    WHERE id = p_order_id;
    
    IF NOT FOUND THEN
        RETURN QUERY SELECT FALSE, 'Order not found';
        RETURN;
    END IF;
    
    IF v_current_status = 'delivered' THEN
        RETURN QUERY SELECT FALSE, 'Cannot cancel delivered order';
        RETURN;
    END IF;
    
    IF v_current_status = 'cancelled' THEN
        RETURN QUERY SELECT FALSE, 'Order is already cancelled';
        RETURN;
    END IF;
    
    -- Get user name
    SELECT username INTO v_user_name
    FROM users
    WHERE id = p_user_id;
    
    -- Update order
    UPDATE orders
    SET order_status = 'cancelled',
        cancelled_at = NOW(),
        cancelled_by = p_user_id,
        cancellation_reason = p_cancellation_reason,
        updated_at = NOW(),
        updated_by = p_user_id
    WHERE id = p_order_id;
    
    -- Create audit log
    INSERT INTO order_audit_logs (
        order_id,
        action_type,
        from_status,
        to_status,
        performed_by,
        performed_by_name,
        notes
    ) VALUES (
        p_order_id,
        'cancelled',
        v_current_status,
        'cancelled',
        p_user_id,
        v_user_name,
        p_cancellation_reason
    );
    
    RETURN QUERY SELECT TRUE, 'Order cancelled successfully';
END;
$$;


--
-- Name: FUNCTION cancel_order(p_order_id uuid, p_user_id uuid, p_cancellation_reason text); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.cancel_order(p_order_id uuid, p_user_id uuid, p_cancellation_reason text) IS 'Cancels order with reason';


--
-- Name: check_accountant_dependency(uuid); Type: FUNCTION; Schema: public; Owner: -
--

