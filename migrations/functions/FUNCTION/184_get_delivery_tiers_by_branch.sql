CREATE FUNCTION public.get_delivery_tiers_by_branch(p_branch_id bigint) RETURNS TABLE(id uuid, branch_id bigint, min_order_amount numeric, max_order_amount numeric, delivery_fee numeric, tier_order integer, is_active boolean, description_en text, description_ar text)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    -- Strictly branch-specific tiers; if branch_id is NULL, return empty set
    IF p_branch_id IS NULL THEN
        RETURN;
    END IF;

    RETURN QUERY
    SELECT 
        t.id,
        t.branch_id,
        t.min_order_amount,
        t.max_order_amount,
        t.delivery_fee,
        t.tier_order,
        t.is_active,
        t.description_en,
        t.description_ar
    FROM public.delivery_fee_tiers t
    WHERE t.is_active = true
      AND t.branch_id = p_branch_id
    ORDER BY t.tier_order ASC;
END;
$$;


--
-- Name: FUNCTION get_delivery_tiers_by_branch(p_branch_id bigint); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.get_delivery_tiers_by_branch(p_branch_id bigint) IS 'Get active delivery fee tiers for a specific branch only';


--
-- Name: get_dependency_completion_photos(uuid, text[]); Type: FUNCTION; Schema: public; Owner: -
--

