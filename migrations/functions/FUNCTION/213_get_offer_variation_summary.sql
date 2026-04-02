CREATE FUNCTION public.get_offer_variation_summary(p_offer_id integer) RETURNS TABLE(variation_group_id uuid, parent_barcode text, group_name_en text, group_name_ar text, selected_count integer, total_count integer, has_price_mismatch boolean)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
  RETURN QUERY
  WITH variation_groups AS (
    SELECT DISTINCT 
      op.variation_group_id,
      op.variation_parent_barcode
    FROM offer_products op
    WHERE op.offer_id = p_offer_id
      AND op.is_part_of_variation_group = true
      AND op.variation_group_id IS NOT NULL
  ),
  selected_variations AS (
    SELECT 
      op.variation_group_id,
      COUNT(DISTINCT op.product_id) as selected_count,
      COUNT(DISTINCT op.offer_price) as price_count,
      COUNT(DISTINCT op.offer_percentage) as percentage_count
    FROM offer_products op
    WHERE op.offer_id = p_offer_id
      AND op.variation_group_id IS NOT NULL
    GROUP BY op.variation_group_id
  ),
  total_variations AS (
    SELECT 
      vg.variation_group_id,
      COUNT(DISTINCT p.id) as total_count
    FROM variation_groups vg
    JOIN products p ON p.parent_product_barcode = vg.variation_parent_barcode
      OR p.barcode = vg.variation_parent_barcode
    WHERE p.is_variation = true
    GROUP BY vg.variation_group_id
  )
  SELECT 
    vg.variation_group_id,
    vg.variation_parent_barcode as parent_barcode,
    p.variation_group_name_en as group_name_en,
    p.variation_group_name_ar as group_name_ar,
    sv.selected_count::INTEGER,
    tv.total_count::INTEGER,
    CASE 
      WHEN sv.price_count > 1 OR sv.percentage_count > 1 THEN true
      ELSE false
    END as has_price_mismatch
  FROM variation_groups vg
  JOIN products p ON p.barcode = vg.variation_parent_barcode
  LEFT JOIN selected_variations sv ON sv.variation_group_id = vg.variation_group_id
  LEFT JOIN total_variations tv ON tv.variation_group_id = vg.variation_group_id
  ORDER BY p.variation_group_name_en;
END;
$$;


--
-- Name: get_ongoing_quick_assignment_count(uuid); Type: FUNCTION; Schema: public; Owner: -
--

