CREATE FUNCTION public.assign_order_picker(p_order_id uuid, p_picker_id uuid, p_assigned_by uuid) RETURNS TABLE(success boolean, message text)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_picker_name VARCHAR(255);
    v_assigned_by_name VARCHAR(255);
BEGIN
    -- Get picker name
    SELECT username INTO v_picker_name
    FROM users
    WHERE id = p_picker_id;
    
    IF NOT FOUND THEN
        RETURN QUERY SELECT FALSE, 'Picker not found';
        RETURN;
    END IF;
    
    -- Get assigner name
    SELECT username INTO v_assigned_by_name
    FROM users
    WHERE id = p_assigned_by;
    
    -- Update order
    UPDATE orders
    SET picker_id = p_picker_id,
        picker_assigned_at = NOW(),
        order_status = CASE 
            WHEN order_status = 'accepted' THEN 'in_picking'
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
        'assigned_picker',
        p_picker_id,
        v_picker_name,
        'picker',
        p_assigned_by,
        v_assigned_by_name,
        'Picker assigned to order'
    );
    
    RETURN QUERY SELECT TRUE, 'Picker assigned successfully';
END;
$$;


--
-- Name: FUNCTION assign_order_picker(p_order_id uuid, p_picker_id uuid, p_assigned_by uuid); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.assign_order_picker(p_order_id uuid, p_picker_id uuid, p_assigned_by uuid) IS 'Assigns picker to order for preparation';


--
-- Name: assign_task_simple(uuid, uuid, text, text, timestamp with time zone, text, text); Type: FUNCTION; Schema: public; Owner: -
--

