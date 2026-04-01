CREATE FUNCTION public.get_campaign_statistics(p_campaign_id uuid) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_stats JSONB;
  v_products JSONB;
  v_max_claims INTEGER;
BEGIN
  -- Get campaign max claims
  SELECT COALESCE(max_claims_per_customer, 1)
  INTO v_max_claims
  FROM coupon_campaigns
  WHERE id = p_campaign_id;
  
  -- Get overall campaign stats
  SELECT jsonb_build_object(
    'max_claims_per_customer', v_max_claims,
    'total_eligible_customers', (
      SELECT COUNT(*) 
      FROM coupon_eligible_customers 
      WHERE campaign_id = p_campaign_id
    ),
    'total_claims', (
      SELECT COUNT(*) 
      FROM coupon_claims 
      WHERE campaign_id = p_campaign_id
    ),
    'unique_customers_claimed', (
      SELECT COUNT(DISTINCT customer_mobile)
      FROM coupon_claims
      WHERE campaign_id = p_campaign_id
    ),
    'remaining_potential_claims', (
      SELECT COUNT(*) * v_max_claims
      FROM coupon_eligible_customers ec
      WHERE ec.campaign_id = p_campaign_id
    ) - (
      SELECT COUNT(*)
      FROM coupon_claims
      WHERE campaign_id = p_campaign_id
    ),
    'total_stock_limit', (
      SELECT COALESCE(SUM(stock_limit), 0)
      FROM coupon_products
      WHERE campaign_id = p_campaign_id
        AND deleted_at IS NULL
    ),
    'total_stock_remaining', (
      SELECT COALESCE(SUM(stock_remaining), 0)
      FROM coupon_products
      WHERE campaign_id = p_campaign_id
        AND deleted_at IS NULL
    )
  ) INTO v_stats;
  
  -- Get per-product stats
  SELECT jsonb_agg(
    jsonb_build_object(
      'product_id', p.id,
      'product_name_en', p.product_name_en,
      'product_name_ar', p.product_name_ar,
      'stock_limit', p.stock_limit,
      'stock_remaining', p.stock_remaining,
      'claims_count', (
        SELECT COUNT(*) 
        FROM coupon_claims 
        WHERE product_id = p.id
      )
    )
  )
  INTO v_products
  FROM coupon_products p
  WHERE p.campaign_id = p_campaign_id
    AND p.deleted_at IS NULL;
  
  -- Combine and return
  RETURN v_stats || jsonb_build_object('products', COALESCE(v_products, '[]'::jsonb));
END;
$$;


--
-- Name: get_cart_tier_discount(integer, numeric); Type: FUNCTION; Schema: public; Owner: -
--

