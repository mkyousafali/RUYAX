CREATE FUNCTION public.get_all_expiry_products(p_page integer DEFAULT 1, p_page_size integer DEFAULT 1000, p_search_barcode text DEFAULT NULL::text, p_search_name text DEFAULT NULL::text, p_branch_id integer DEFAULT NULL::integer) RETURNS TABLE(branch_id integer, barcode character varying, product_name_en character varying, product_name_ar character varying, expiry_date date, days_left integer, managed_by jsonb, total_count bigint)
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
  v_offset integer;
  v_limit integer;
BEGIN
  v_offset := CASE WHEN (p_search_barcode IS NOT NULL OR p_search_name IS NOT NULL) THEN 0 ELSE (p_page - 1) * p_page_size END;
  v_limit := CASE WHEN (p_search_barcode IS NOT NULL OR p_search_name IS NOT NULL) THEN NULL ELSE p_page_size END;

  RETURN QUERY
  SELECT
    (entry->>'branch_id')::integer AS branch_id,
    p.barcode,
    p.product_name_en,
    p.product_name_ar,
    (entry->>'expiry_date')::date AS expiry_date,
    ((entry->>'expiry_date')::date - CURRENT_DATE)::integer AS days_left,
    p.managed_by,
    count(*) OVER() AS total_count
  FROM erp_synced_products p,
    jsonb_array_elements(p.expiry_dates) AS entry
  WHERE p.expiry_hidden IS NOT TRUE
    AND jsonb_array_length(p.expiry_dates) > 0
    AND (entry->>'expiry_date') IS NOT NULL
    AND (entry->>'branch_id') IS NOT NULL
    AND (p_branch_id IS NULL OR (entry->>'branch_id')::integer = p_branch_id)
    AND (p_search_barcode IS NULL OR p.barcode ILIKE '%' || p_search_barcode || '%')
    AND (p_search_name IS NULL OR p.product_name_en ILIKE '%' || p_search_name || '%' OR p.product_name_ar ILIKE '%' || p_search_name || '%')
  ORDER BY ((entry->>'expiry_date')::date - CURRENT_DATE) ASC, p.barcode
  LIMIT v_limit
  OFFSET v_offset;
END;
$$;


--
-- Name: get_all_products_master(); Type: FUNCTION; Schema: public; Owner: -
--

