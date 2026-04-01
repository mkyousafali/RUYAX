CREATE FUNCTION public.check_orphaned_variations() RETURNS TABLE(barcode text, product_name_en text, product_name_ar text, parent_product_barcode text, reason text)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
  RETURN QUERY
  SELECT 
    p.barcode,
    p.product_name_en,
    p.product_name_ar,
    p.parent_product_barcode,
    CASE 
      WHEN p.parent_product_barcode IS NOT NULL 
           AND NOT EXISTS (
             SELECT 1 FROM products parent 
             WHERE parent.barcode = p.parent_product_barcode
           ) THEN 'Parent product does not exist'
      WHEN p.parent_product_barcode = p.barcode THEN 'Self-referencing parent'
      ELSE 'Unknown issue'
    END as reason
  FROM products p
  WHERE p.is_variation = true
    AND (
      (p.parent_product_barcode IS NOT NULL 
       AND NOT EXISTS (
         SELECT 1 FROM products parent 
         WHERE parent.barcode = p.parent_product_barcode
       ))
      OR p.parent_product_barcode = p.barcode
    )
  ORDER BY p.product_name_en;
END;
$$;


--
-- Name: check_overdue_tasks_and_send_reminders(); Type: FUNCTION; Schema: public; Owner: -
--

