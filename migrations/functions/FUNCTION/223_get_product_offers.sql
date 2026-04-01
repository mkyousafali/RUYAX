CREATE FUNCTION public.get_product_offers(p_product_id uuid) RETURNS TABLE(offer_id integer, offer_name_en text, offer_name_ar text, offer_type text, discount_type text, offer_qty integer, offer_percentage numeric, offer_price numeric, original_price numeric, savings numeric, end_date timestamp with time zone, service_type text, branch_id integer)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
  RETURN QUERY
  SELECT 
    o.id AS offer_id,
    o.name_en AS offer_name_en,
    o.name_ar AS offer_name_ar,
    o.type AS offer_type,
    o.discount_type,
    op.offer_qty,
    op.offer_percentage,
    op.offer_price,
    p.sale_price AS original_price,
    CASE 
      WHEN op.offer_percentage IS NOT NULL THEN 
        (p.sale_price * op.offer_qty) - ((p.sale_price * op.offer_qty) * (1 - op.offer_percentage / 100))
      WHEN op.offer_price IS NOT NULL THEN 
        (p.sale_price * op.offer_qty) - op.offer_price
      ELSE 0
    END AS savings,
    o.end_date,
    o.service_type,
    o.branch_id
  FROM offers o
  INNER JOIN offer_products op ON o.id = op.offer_id
  INNER JOIN products p ON op.product_id = p.id
  WHERE op.product_id = p_product_id
    AND o.is_active = true
    AND o.type = 'product'
    AND o.start_date <= NOW()
    AND o.end_date >= NOW()
  ORDER BY savings DESC;
END;
$$;


--
-- Name: FUNCTION get_product_offers(p_product_id uuid); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.get_product_offers(p_product_id uuid) IS 'Get all active product offers for a specific product, ordered by best savings';


--
-- Name: get_product_variations(text); Type: FUNCTION; Schema: public; Owner: -
--

