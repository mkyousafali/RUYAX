CREATE FUNCTION public.get_offer_products_data(p_exclude_offer_id integer DEFAULT 0) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  v_result json;
BEGIN
  SELECT json_build_object(
    'products', (
      SELECT COALESCE(json_agg(
        json_build_object(
          'id', p.id,
          'name_ar', p.product_name_ar,
          'name_en', p.product_name_en,
          'barcode', p.barcode,
          'product_serial', COALESCE(p.barcode, ''),
          'price', COALESCE(p.sale_price, 0),
          'cost', COALESCE(p.cost, 0),
          'unit_name_en', COALESCE(u.name_en, ''),
          'unit_name_ar', COALESCE(u.name_ar, ''),
          'unit_qty', COALESCE(p.unit_qty, 1),
          'image_url', p.image_url,
          'stock', COALESCE(p.current_stock, 0),
          'minim_qty', 1
        ) ORDER BY p.barcode
      ), '[]'::json)
      FROM products p
      LEFT JOIN product_units u ON u.id = p.unit_id
      WHERE p.is_active = true
        AND p.is_customer_product = true
    ),
    'products_in_other_offers', (
      SELECT COALESCE(json_agg(DISTINCT pid), '[]'::json)
      FROM (
        -- Products in offer_products (percentage, fixed price offers)
        SELECT op.product_id AS pid
        FROM offer_products op
        JOIN offers o ON o.id = op.offer_id
        WHERE o.is_active = true
          AND o.end_date >= NOW()
          AND o.id != p_exclude_offer_id

        UNION

        -- Products in BOGO offers (buy product)
        SELECT bor.buy_product_id AS pid
        FROM bogo_offer_rules bor
        JOIN offers o ON o.id = bor.offer_id
        WHERE o.is_active = true
          AND o.end_date >= NOW()
          AND o.id != p_exclude_offer_id

        UNION

        -- Products in BOGO offers (get product)
        SELECT bor.get_product_id AS pid
        FROM bogo_offer_rules bor
        JOIN offers o ON o.id = bor.offer_id
        WHERE o.is_active = true
          AND o.end_date >= NOW()
          AND o.id != p_exclude_offer_id

        UNION

        -- Products in bundle offers (from JSONB required_products array)
        SELECT (elem->>'product_id')::text AS pid
        FROM offer_bundles ob
        JOIN offers o ON o.id = ob.offer_id,
        LATERAL jsonb_array_elements(ob.required_products) AS elem
        WHERE o.is_active = true
          AND o.end_date >= NOW()
          AND o.id != p_exclude_offer_id
      ) sub
      WHERE pid IS NOT NULL
    )
  ) INTO v_result;

  RETURN v_result;
END;
$$;


--
-- Name: get_offer_variation_summary(integer); Type: FUNCTION; Schema: public; Owner: -
--

