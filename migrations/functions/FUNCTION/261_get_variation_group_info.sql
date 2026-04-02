CREATE FUNCTION public.get_variation_group_info(p_barcode text) RETURNS TABLE(parent_barcode text, group_name_en text, group_name_ar text, total_variations integer, variation_image_override text, created_by uuid, modified_by uuid, modified_at timestamp with time zone)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
  RETURN QUERY
  WITH parent_info AS (
    SELECT 
      COALESCE(p.parent_product_barcode, p.barcode) as parent_ref
    FROM products p
    WHERE p.barcode = p_barcode
  )
  SELECT 
    parent.barcode as parent_barcode,
    parent.variation_group_name_en as group_name_en,
    parent.variation_group_name_ar as group_name_ar,
    COUNT(DISTINCT variations.barcode)::INTEGER as total_variations,
    parent.variation_image_override,
    parent.created_by,
    parent.modified_by,
    parent.modified_at
  FROM products parent
  LEFT JOIN products variations 
    ON variations.parent_product_barcode = parent.barcode 
    OR variations.barcode = parent.barcode
  WHERE parent.barcode = (SELECT parent_ref FROM parent_info)
    AND parent.is_variation = true
  GROUP BY 
    parent.barcode,
    parent.variation_group_name_en,
    parent.variation_group_name_ar,
    parent.variation_image_override,
    parent.created_by,
    parent.modified_by,
    parent.modified_at;
END;
$$;


--
-- Name: get_vendor_count_by_branch(); Type: FUNCTION; Schema: public; Owner: -
--

