CREATE FUNCTION public.log_offer_usage(p_offer_id integer, p_customer_id uuid, p_order_id integer, p_discount_applied numeric, p_original_amount numeric, p_final_amount numeric, p_cart_items jsonb DEFAULT NULL::jsonb) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_log_id INTEGER;
BEGIN
    -- Insert usage log
    INSERT INTO offer_usage_logs (
        offer_id, customer_id, order_id,
        discount_applied, original_amount, final_amount,
        cart_items
    ) VALUES (
        p_offer_id, p_customer_id, p_order_id,
        p_discount_applied, p_original_amount, p_final_amount,
        p_cart_items
    ) RETURNING id INTO v_log_id;
    
    -- Increment offer usage counter
    UPDATE offers
    SET current_total_uses = current_total_uses + 1
    WHERE id = p_offer_id;
    
    -- Update customer_offers if customer-specific
    UPDATE customer_offers
    SET is_used = true,
        used_at = NOW(),
        usage_count = usage_count + 1
    WHERE offer_id = p_offer_id AND customer_id = p_customer_id;
    
    RETURN v_log_id;
END;
$$;


--
-- Name: log_user_action(); Type: FUNCTION; Schema: public; Owner: -
--

