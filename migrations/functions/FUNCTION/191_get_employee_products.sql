CREATE FUNCTION public.get_employee_products(p_employee_id text, p_limit integer DEFAULT 1000, p_offset integer DEFAULT 0) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  v_result JSON;
BEGIN
  SELECT json_build_object(
    'products', COALESCE((
      SELECT json_agg(row_to_json(t))
      FROM (
        SELECT 
          barcode, 
          product_name_en, 
          product_name_ar, 
          parent_barcode,
          expiry_dates,
          managed_by
        FROM erp_synced_products
        WHERE managed_by @> ('[{"employee_id":"' || p_employee_id || '"}]')::jsonb
        ORDER BY product_name_en
        LIMIT p_limit
        OFFSET p_offset
      ) t
    ), '[]'::json),
    'total_count', (
      SELECT count(*)
      FROM erp_synced_products
      WHERE managed_by @> ('[{"employee_id":"' || p_employee_id || '"}]')::jsonb
    )
  ) INTO v_result;

  RETURN v_result;
END;
$$;


--
-- Name: get_employee_schedules(bigint, date, date); Type: FUNCTION; Schema: public; Owner: -
--

