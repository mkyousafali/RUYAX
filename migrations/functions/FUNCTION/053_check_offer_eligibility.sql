CREATE FUNCTION public.check_offer_eligibility(p_offer_id integer, p_customer_id uuid, p_cart_total numeric DEFAULT 0, p_cart_quantity integer DEFAULT 0) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_offer RECORD;
    v_customer_usage_count INTEGER;
BEGIN
    -- Get offer details
    SELECT * INTO v_offer FROM offers WHERE id = p_offer_id;
    
    IF NOT FOUND THEN
        RETURN false;
    END IF;
    
    -- Check if offer is active
    IF v_offer.is_active = false THEN
        RETURN false;
    END IF;
    
    -- Check date range
    IF NOW() NOT BETWEEN v_offer.start_date AND v_offer.end_date THEN
        RETURN false;
    END IF;
    
    -- Check minimum amount
    IF v_offer.min_amount IS NOT NULL AND p_cart_total < v_offer.min_amount THEN
        RETURN false;
    END IF;
    
    -- Check minimum quantity
    IF v_offer.min_quantity IS NOT NULL AND p_cart_quantity < v_offer.min_quantity THEN
        RETURN false;
    END IF;
    
    -- Check max uses per customer
    IF v_offer.max_uses_per_customer IS NOT NULL THEN
        SELECT COUNT(*) INTO v_customer_usage_count
        FROM offer_usage_logs
        WHERE offer_id = p_offer_id AND customer_id = p_customer_id;
        
        IF v_customer_usage_count >= v_offer.max_uses_per_customer THEN
            RETURN false;
        END IF;
    END IF;
    
    -- Check max total uses
    IF v_offer.max_total_uses IS NOT NULL AND v_offer.current_total_uses >= v_offer.max_total_uses THEN
        RETURN false;
    END IF;
    
    -- If customer-specific, check assignment
    IF v_offer.type = 'customer' THEN
        IF NOT EXISTS (
            SELECT 1 FROM customer_offers
            WHERE offer_id = p_offer_id AND customer_id = p_customer_id
        ) THEN
            RETURN false;
        END IF;
    END IF;
    
    RETURN true;
END;
$$;


--
-- Name: check_orphaned_variations(); Type: FUNCTION; Schema: public; Owner: -
--

