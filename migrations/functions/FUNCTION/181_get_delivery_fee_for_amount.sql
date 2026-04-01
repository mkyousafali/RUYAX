CREATE FUNCTION public.get_delivery_fee_for_amount(order_amount numeric) RETURNS numeric
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
    calculated_fee numeric;
BEGIN
    -- Find the appropriate tier for the given order amount
    SELECT delivery_fee INTO calculated_fee
    FROM public.delivery_fee_tiers
    WHERE is_active = true
      AND min_order_amount <= order_amount
      AND (max_order_amount IS NULL OR max_order_amount >= order_amount)
    ORDER BY min_order_amount DESC
    LIMIT 1;
    
    -- If no tier found, return 0 (shouldn't happen with proper setup)
    RETURN COALESCE(calculated_fee, 0);
END;
$$;


--
-- Name: FUNCTION get_delivery_fee_for_amount(order_amount numeric); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.get_delivery_fee_for_amount(order_amount numeric) IS 'Calculate delivery fee based on order amount using active tier structure';


--
-- Name: get_delivery_fee_for_amount_by_branch(bigint, numeric); Type: FUNCTION; Schema: public; Owner: -
--

