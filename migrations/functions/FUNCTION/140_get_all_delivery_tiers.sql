CREATE FUNCTION public.get_all_delivery_tiers() RETURNS TABLE(id uuid, min_order_amount numeric, max_order_amount numeric, delivery_fee numeric, tier_order integer, is_active boolean, description_en text, description_ar text)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        t.id,
        t.min_order_amount,
        t.max_order_amount,
        t.delivery_fee,
        t.tier_order,
        t.is_active,
        t.description_en,
        t.description_ar
    FROM public.delivery_fee_tiers t
    WHERE t.is_active = true
    ORDER BY t.tier_order ASC;
END;
$$;


--
-- Name: FUNCTION get_all_delivery_tiers(); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.get_all_delivery_tiers() IS 'Get all active delivery fee tiers ordered for display';


--
-- Name: get_all_expiry_products(); Type: FUNCTION; Schema: public; Owner: -
--

