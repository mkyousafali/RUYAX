CREATE FUNCTION public.create_customer_order(p_customer_id uuid, p_branch_id bigint, p_selected_location jsonb, p_fulfillment_method character varying, p_payment_method character varying, p_subtotal_amount numeric, p_delivery_fee numeric, p_discount_amount numeric, p_tax_amount numeric, p_total_amount numeric, p_total_items integer, p_total_quantity integer, p_customer_notes text DEFAULT NULL::text) RETURNS TABLE(order_id uuid, order_number character varying, success boolean, message text)
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
    v_order_id UUID;
    v_order_number VARCHAR(50);
    v_customer_name VARCHAR(255);
    v_customer_phone VARCHAR(20);
    v_customer_whatsapp VARCHAR(20);
BEGIN
    -- Get customer information
    SELECT name, whatsapp_number, whatsapp_number
    INTO v_customer_name, v_customer_phone, v_customer_whatsapp
    FROM customers
    WHERE id = p_customer_id;
    
    IF NOT FOUND THEN
        RETURN QUERY SELECT NULL::UUID, NULL::VARCHAR, FALSE, 'Customer not found';
        RETURN;
    END IF;
    
    -- Generate order number
    v_order_number := generate_order_number();
    
    -- Create order (will bypass RLS due to SECURITY DEFINER)
    INSERT INTO orders (
        order_number,
        customer_id,
        customer_name,
        customer_phone,
        customer_whatsapp,
        branch_id,
        selected_location,
        order_status,
        fulfillment_method,
        subtotal_amount,
        delivery_fee,
        discount_amount,
        tax_amount,
        total_amount,
        payment_method,
        payment_status,
        total_items,
        total_quantity,
        customer_notes
    ) VALUES (
        v_order_number,
        p_customer_id,
        v_customer_name,
        v_customer_phone,
        v_customer_whatsapp,
        p_branch_id,
        p_selected_location,
        'new',
        p_fulfillment_method,
        p_subtotal_amount,
        p_delivery_fee,
        p_discount_amount,
        p_tax_amount,
        p_total_amount,
        p_payment_method,
        'pending',
        p_total_items,
        p_total_quantity,
        p_customer_notes
    )
    RETURNING id INTO v_order_id;
    
    -- Create audit log
    INSERT INTO order_audit_logs (
        order_id,
        action_type,
        to_status,
        notes
    ) VALUES (
        v_order_id,
        'created',
        'new',
        'Order created by customer'
    );
    
    RETURN QUERY SELECT v_order_id, v_order_number, TRUE, 'Order created successfully';
END;
$$;


--
-- Name: FUNCTION create_customer_order(p_customer_id uuid, p_branch_id bigint, p_selected_location jsonb, p_fulfillment_method character varying, p_payment_method character varying, p_subtotal_amount numeric, p_delivery_fee numeric, p_discount_amount numeric, p_tax_amount numeric, p_total_amount numeric, p_total_items integer, p_total_quantity integer, p_customer_notes text); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.create_customer_order(p_customer_id uuid, p_branch_id bigint, p_selected_location jsonb, p_fulfillment_method character varying, p_payment_method character varying, p_subtotal_amount numeric, p_delivery_fee numeric, p_discount_amount numeric, p_tax_amount numeric, p_total_amount numeric, p_total_items integer, p_total_quantity integer, p_customer_notes text) IS 'Creates a new customer order (SECURITY DEFINER to bypass RLS)';


--
-- Name: create_customer_registration(text, text, uuid); Type: FUNCTION; Schema: public; Owner: -
--

