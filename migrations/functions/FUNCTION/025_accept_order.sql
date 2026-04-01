CREATE FUNCTION public.accept_order(p_order_id uuid, p_user_id uuid) RETURNS TABLE(success boolean, message text)
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
    
    IF v_current_status != 'new' THEN
        RETURN QUERY SELECT FALSE, 'Order can only be accepted from new status';
        RETURN;
    END IF;
    
    -- Get user name
    SELECT username INTO v_user_name
    FROM users
    WHERE id = p_user_id;
    
    -- Update order
    UPDATE orders
    SET order_status = 'accepted',
        accepted_at = NOW(),
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
        'new',
        'accepted',
        p_user_id,
        v_user_name,
        'Order accepted'
    );
    
    RETURN QUERY SELECT TRUE, 'Order accepted successfully';
END;
$$;


--
-- Name: FUNCTION accept_order(p_order_id uuid, p_user_id uuid); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.accept_order(p_order_id uuid, p_user_id uuid) IS 'Admin accepts a new order';


--
-- Name: acknowledge_warning(uuid, uuid); Type: FUNCTION; Schema: public; Owner: -
--

