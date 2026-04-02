CREATE FUNCTION public.get_pv_stock_voucher_items(p_offset integer DEFAULT 0, p_limit integer DEFAULT 2000) RETURNS jsonb
    LANGUAGE sql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
  SELECT jsonb_build_object(
    'total_count', (SELECT count(*) FROM purchase_voucher_items),
    'items', COALESCE((
      SELECT jsonb_agg(row_data)
      FROM (
        SELECT jsonb_build_object(
          'id', pvi.id,
          'purchase_voucher_id', pvi.purchase_voucher_id,
          'serial_number', pvi.serial_number,
          'value', pvi.value,
          'stock', pvi.stock,
          'status', pvi.status,
          'issue_type', pvi.issue_type,
          'stock_location', pvi.stock_location,
          'stock_person', pvi.stock_person,
          'stock_location_name', COALESCE(b.name_en, '-'),
          'stock_person_name', COALESCE(e.name_en, u.username, '-')
        ) as row_data
        FROM purchase_voucher_items pvi
        LEFT JOIN branches b ON b.id = pvi.stock_location
        LEFT JOIN users u ON u.id = pvi.stock_person
        LEFT JOIN hr_employee_master e ON e.id = u.employee_id::text
        ORDER BY pvi.purchase_voucher_id, pvi.serial_number
        LIMIT p_limit OFFSET p_offset
      ) sub
    ), '[]'::jsonb)
  );
$$;


--
-- Name: get_quick_access_stats(); Type: FUNCTION; Schema: public; Owner: -
--

