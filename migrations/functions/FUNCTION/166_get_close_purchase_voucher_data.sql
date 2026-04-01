CREATE FUNCTION public.get_close_purchase_voucher_data() RETURNS jsonb
    LANGUAGE sql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
  SELECT jsonb_build_object(
    'vouchers', COALESCE((
      SELECT jsonb_agg(
        jsonb_build_object(
          'id', pvi.id,
          'purchase_voucher_id', pvi.purchase_voucher_id,
          'serial_number', pvi.serial_number,
          'value', pvi.value,
          'status', pvi.status,
          'issue_type', pvi.issue_type,
          'stock_location', pvi.stock_location,
          'stock_location_name', COALESCE(b.name_en || ' - ' || b.location_en, '-'),
          'issued_by', pvi.issued_by,
          'issued_by_name', COALESCE(eby.name_en, uby.username, '-'),
          'issued_to', pvi.issued_to,
          'issued_to_name', COALESCE(eto.name_en, uto.username, '-'),
          'issued_date', pvi.issued_date,
          'issue_remarks', pvi.issue_remarks,
          'approval_status', pvi.approval_status
        )
        ORDER BY pvi.issued_date DESC
      )
      FROM purchase_voucher_items pvi
      LEFT JOIN branches b ON b.id = pvi.stock_location
      LEFT JOIN users uby ON uby.id = pvi.issued_by
      LEFT JOIN hr_employee_master eby ON eby.id = uby.employee_id::text
      LEFT JOIN users uto ON uto.id = pvi.issued_to
      LEFT JOIN hr_employee_master eto ON eto.id = uto.employee_id::text
      WHERE pvi.status = 'issued' OR pvi.approval_status = 'pending'
    ), '[]'::jsonb),
    'branches', COALESCE((
      SELECT jsonb_agg(jsonb_build_object('id', id, 'name_en', name_en, 'location_en', location_en))
      FROM branches
    ), '[]'::jsonb),
    'expense_categories', COALESCE((
      SELECT jsonb_agg(jsonb_build_object('id', id, 'name_en', name_en, 'name_ar', name_ar, 'parent_category_id', parent_category_id))
      FROM expense_sub_categories WHERE is_active = true
    ), '[]'::jsonb)
  );
$$;


--
-- Name: get_closed_boxes(text, timestamp with time zone, timestamp with time zone, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

