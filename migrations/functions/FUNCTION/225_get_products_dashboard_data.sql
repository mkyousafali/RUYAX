CREATE FUNCTION public.get_products_dashboard_data(p_limit integer DEFAULT 500, p_offset integer DEFAULT 0) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  result jsonb;
BEGIN
  SELECT jsonb_build_object(
    'products', COALESCE((
      SELECT jsonb_agg(row_data ORDER BY rn)
      FROM (
        SELECT 
          jsonb_build_object(
            'id', p.id,
            'barcode', p.barcode,
            'product_name_en', COALESCE(p.product_name_en, ''),
            'product_name_ar', COALESCE(p.product_name_ar, ''),
            'category_id', p.category_id,
            'category_name_en', pc.name_en,
            'category_name_ar', pc.name_ar,
            'unit_id', p.unit_id,
            'unit_name_en', pu.name_en,
            'unit_name_ar', pu.name_ar
          ) AS row_data,
          ROW_NUMBER() OVER (ORDER BY p.product_name_en) AS rn
        FROM products p
        LEFT JOIN product_categories pc ON p.category_id = pc.id
        LEFT JOIN product_units pu ON p.unit_id = pu.id
        ORDER BY p.product_name_en
        LIMIT p_limit
        OFFSET p_offset
      ) sub
    ), '[]'::jsonb),
    'categories', COALESCE((
      SELECT jsonb_agg(
        jsonb_build_object(
          'id', pc.id,
          'name_en', pc.name_en,
          'name_ar', pc.name_ar
        ) ORDER BY pc.name_en
      )
      FROM product_categories pc
    ), '[]'::jsonb),
    'units', COALESCE((
      SELECT jsonb_agg(
        jsonb_build_object(
          'id', pu.id,
          'name_en', pu.name_en,
          'name_ar', pu.name_ar
        ) ORDER BY pu.name_en
      )
      FROM product_units pu
    ), '[]'::jsonb),
    'total_count', (SELECT COUNT(*)::int FROM products)
  )
  INTO result;

  RETURN result;
END;
$$;


--
-- Name: get_products_in_active_offers(); Type: FUNCTION; Schema: public; Owner: -
--

