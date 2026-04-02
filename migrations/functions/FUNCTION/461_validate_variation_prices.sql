CREATE FUNCTION public.validate_variation_prices(p_offer_id integer, p_group_id uuid) RETURNS TABLE(barcode text, product_name_en text, offer_price numeric, offer_percentage numeric, price_mismatch boolean)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
  RETURN QUERY
  WITH group_prices AS (
    SELECT 
      op.offer_price,
      op.offer_percentage,
      COUNT(DISTINCT op.offer_price) OVER () as price_count,
      COUNT(DISTINCT op.offer_percentage) OVER () as percentage_count
    FROM offer_products op
    WHERE op.offer_id = p_offer_id
      AND op.variation_group_id = p_group_id
    LIMIT 1
  )
  SELECT 
    p.barcode,
    p.product_name_en,
    op.offer_price,
    op.offer_percentage,
    CASE 
      WHEN gp.price_count > 1 OR gp.percentage_count > 1 THEN true
      ELSE false
    END as price_mismatch
  FROM offer_products op
  JOIN products p ON op.product_id = p.id
  CROSS JOIN group_prices gp
  WHERE op.offer_id = p_offer_id
    AND op.variation_group_id = p_group_id
  ORDER BY p.variation_order, p.product_name_en;
END;
$$;


--
-- Name: validate_vendor_branch_match(); Type: FUNCTION; Schema: public; Owner: -
--

