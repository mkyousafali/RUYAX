CREATE FUNCTION public.update_order_status(p_order_id uuid, p_new_status character varying, p_user_id uuid, p_notes text DEFAULT NULL::text) RETURNS TABLE(success boolean, message text)
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
    
    -- Get user name
    SELECT username INTO v_user_name
    FROM users
    WHERE id = p_user_id;
    
    -- Update order with status-specific timestamps
    UPDATE orders
    SET order_status = p_new_status,
        ready_at = CASE WHEN p_new_status = 'ready' THEN NOW() ELSE ready_at END,
        delivered_at = CASE WHEN p_new_status = 'delivered' THEN NOW() ELSE delivered_at END,
        actual_delivery_time = CASE WHEN p_new_status = 'delivered' THEN NOW() ELSE actual_delivery_time END,
        payment_status = CASE WHEN p_new_status = 'delivered' AND payment_method = 'cash' THEN 'paid' ELSE payment_status END,
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
        'status_changed',
        v_current_status,
        p_new_status,
        p_user_id,
        v_user_name,
        COALESCE(p_notes, 'Status changed to ' || p_new_status)
    );
    
    RETURN QUERY SELECT TRUE, 'Order status updated successfully';
END;
$$;


--
-- Name: FUNCTION update_order_status(p_order_id uuid, p_new_status character varying, p_user_id uuid, p_notes text); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.update_order_status(p_order_id uuid, p_new_status character varying, p_user_id uuid, p_notes text) IS 'Updates order status with audit trail';


--
-- Name: update_payment_transactions_updated_at(); Type: FUNCTION; Schema: public; Owner: -
--

