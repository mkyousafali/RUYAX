CREATE FUNCTION public.get_pv_stock_voucher_items() RETURNS jsonb
    LANGUAGE sql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
  SELECT jsonb_build_object(
    'items', COALESCE((
      SELECT jsonb_agg(
        jsonb_build_object(
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
        )
        ORDER BY pvi.purchase_voucher_id, pvi.serial_number
      )
      FROM purchase_voucher_items pvi
      LEFT JOIN branches b ON b.id = pvi.stock_location
      LEFT JOIN users u ON u.id = pvi.stock_person
      LEFT JOIN hr_employee_master e ON e.id = u.employee_id::text
    ), '[]'::jsonb)
  );
$$;


--
-- Name: get_pv_stock_voucher_items(integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

