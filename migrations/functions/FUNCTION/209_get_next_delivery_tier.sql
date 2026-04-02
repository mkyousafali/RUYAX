CREATE FUNCTION public.get_next_delivery_tier(current_amount numeric) RETURNS TABLE(next_tier_min_amount numeric, next_tier_delivery_fee numeric, amount_needed numeric, potential_savings numeric, description_en text, description_ar text)
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
    current_fee numeric;
BEGIN
    -- Get current delivery fee
    current_fee := public.get_delivery_fee_for_amount(current_amount);
    
    -- Find next better tier
    RETURN QUERY
    SELECT 
        t.min_order_amount,
        t.delivery_fee,
        (t.min_order_amount - current_amount) as amount_needed,
        (current_fee - t.delivery_fee) as potential_savings,
        t.description_en,
        t.description_ar
    FROM public.delivery_fee_tiers t
    WHERE t.is_active = true
      AND t.min_order_amount > current_amount
      AND t.delivery_fee < current_fee
    ORDER BY t.min_order_amount ASC
    LIMIT 1;
END;
$$;


--
-- Name: FUNCTION get_next_delivery_tier(current_amount numeric); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.get_next_delivery_tier(current_amount numeric) IS 'Get the next tier that would reduce delivery fee with amount needed to reach it';


--
-- Name: get_next_delivery_tier_by_branch(bigint, numeric); Type: FUNCTION; Schema: public; Owner: -
--

