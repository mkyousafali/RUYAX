CREATE FUNCTION public.get_next_delivery_tier_by_branch(p_branch_id bigint, p_current_amount numeric) RETURNS TABLE(next_tier_min_amount numeric, next_tier_delivery_fee numeric, amount_needed numeric, potential_savings numeric, description_en text, description_ar text)
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
    v_current_fee numeric;
BEGIN
    -- Require branch id
    IF p_branch_id IS NULL THEN
        RETURN; -- empty set
    END IF;

    v_current_fee := public.get_delivery_fee_for_amount_by_branch(p_branch_id, p_current_amount);

    RETURN QUERY
    SELECT 
        t.min_order_amount,
        t.delivery_fee,
        (t.min_order_amount - p_current_amount) AS amount_needed,
        (v_current_fee - t.delivery_fee) AS potential_savings,
        t.description_en,
        t.description_ar
    FROM public.delivery_fee_tiers t
    WHERE t.is_active = true
      AND t.branch_id = p_branch_id
      AND t.min_order_amount > p_current_amount
      AND t.delivery_fee < v_current_fee
    ORDER BY t.min_order_amount ASC
    LIMIT 1;
END;
$$;


--
-- Name: FUNCTION get_next_delivery_tier_by_branch(p_branch_id bigint, p_current_amount numeric); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.get_next_delivery_tier_by_branch(p_branch_id bigint, p_current_amount numeric) IS 'Get next tier for branch reducing delivery fee with savings info';


--
-- Name: get_next_product_serial(); Type: FUNCTION; Schema: public; Owner: -
--

