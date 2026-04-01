CREATE FUNCTION public.get_delivery_fee_for_amount_by_branch(p_branch_id bigint, p_order_amount numeric) RETURNS numeric
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
    v_fee numeric;
BEGIN
    -- Require a branch id; without it, no fee can be determined
    IF p_branch_id IS NULL THEN
        RETURN 0;
    END IF;

    -- Attempt branch-specific tier match
    SELECT t.delivery_fee INTO v_fee
    FROM public.delivery_fee_tiers t
    WHERE t.is_active = true
      AND t.branch_id = p_branch_id
      AND t.min_order_amount <= p_order_amount
      AND (t.max_order_amount IS NULL OR t.max_order_amount >= p_order_amount)
    ORDER BY t.min_order_amount DESC
    LIMIT 1;

    RETURN COALESCE(v_fee, 0);
END;
$$;


--
-- Name: FUNCTION get_delivery_fee_for_amount_by_branch(p_branch_id bigint, p_order_amount numeric); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.get_delivery_fee_for_amount_by_branch(p_branch_id bigint, p_order_amount numeric) IS 'Calculate delivery fee for order amount using branch tiers only';


--
-- Name: get_delivery_service_settings(); Type: FUNCTION; Schema: public; Owner: -
--

