CREATE FUNCTION public.get_product_variations(p_barcode text) RETURNS TABLE(id character varying, barcode text, product_name_en text, product_name_ar text, unit_name text, image_url text, variation_order integer, is_parent boolean, parent_barcode text, group_name_en text, group_name_ar text)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
  RETURN QUERY
  WITH target_product AS (
    SELECT 
      COALESCE(p.parent_product_barcode, p.barcode) as parent_ref
    FROM products p
    WHERE p.barcode = p_barcode
  )
  SELECT 
    p.id,
    p.barcode,
    p.product_name_en,
    p.product_name_ar,
    pu.name_en as unit_name,
    p.image_url,
    p.variation_order,
    (p.barcode = (SELECT parent_ref FROM target_product)) as is_parent,
    p.parent_product_barcode as parent_barcode,
    p.variation_group_name_en as group_name_en,
    p.variation_group_name_ar as group_name_ar
  FROM products p
  LEFT JOIN product_units pu ON p.unit_id = pu.id
  WHERE p.is_variation = true
    AND (p.parent_product_barcode = (SELECT parent_ref FROM target_product)
         OR p.barcode = (SELECT parent_ref FROM target_product))
  ORDER BY p.variation_order ASC, p.product_name_en ASC;
END;
$$;


--
-- Name: get_products_dashboard_data(integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

