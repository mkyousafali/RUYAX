CREATE FUNCTION public.get_cart_tier_discount(p_offer_id integer, p_cart_amount numeric) RETURNS TABLE(tier_number integer, discount_type character varying, discount_value numeric, min_amount numeric, max_amount numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        t.tier_number,
        t.discount_type,
        t.discount_value,
        t.min_amount,
        t.max_amount
    FROM offer_cart_tiers t
    WHERE t.offer_id = p_offer_id
      AND p_cart_amount >= t.min_amount
      AND (t.max_amount IS NULL OR p_cart_amount <= t.max_amount)
    ORDER BY t.tier_number DESC
    LIMIT 1;
END;
$$;


--
-- Name: get_close_purchase_voucher_data(); Type: FUNCTION; Schema: public; Owner: -
--

