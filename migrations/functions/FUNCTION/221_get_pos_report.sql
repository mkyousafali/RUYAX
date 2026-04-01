CREATE FUNCTION public.get_pos_report(p_date_from timestamp with time zone DEFAULT NULL::timestamp with time zone, p_date_to timestamp with time zone DEFAULT NULL::timestamp with time zone) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
  v_result jsonb;
BEGIN
  SELECT COALESCE(jsonb_agg(row_data ORDER BY (row_data->>'created_at') DESC), '[]'::jsonb)
  INTO v_result
  FROM (
    SELECT jsonb_build_object(
      'id', bo.id,
      'box_number', bo.box_number,
      'branch_id', bo.branch_id,
      'user_id', bo.user_id,
      'total_difference', COALESCE(
        (bo.complete_details->>'total_difference')::numeric,
        bo.total_difference,
        0
      ),
      'created_at', bo.created_at,
      'branch_name_en', COALESCE(b.name_en, b.name_ar, 'N/A'),
      'branch_name_ar', COALESCE(b.name_ar, b.name_en, 'N/A'),
      'branch_location_en', COALESCE(b.location_en, b.location_ar, 'N/A'),
      'branch_location_ar', COALESCE(b.location_ar, b.location_en, 'N/A'),
      'cashier_name_en', COALESCE(e.name_en, 'N/A'),
      'cashier_name_ar', COALESCE(e.name_ar, 'N/A'),
      'transfer_status', COALESCE(
        (SELECT pdt.status::text FROM pos_deduction_transfers pdt WHERE pdt.box_operation_id = bo.id ORDER BY pdt.created_at DESC LIMIT 1),
        'Not Transferred'
      )
    ) as row_data
    FROM box_operations bo
    LEFT JOIN branches b ON b.id = bo.branch_id
    LEFT JOIN hr_employee_master e ON e.user_id = bo.user_id
    WHERE bo.status = 'completed'
      AND (p_date_from IS NULL OR bo.created_at >= p_date_from)
      AND (p_date_to IS NULL OR bo.created_at <= p_date_to)
    ORDER BY bo.created_at DESC
  ) sub;

  RETURN v_result;
END;
$$;


--
-- Name: get_product_master_init_data(); Type: FUNCTION; Schema: public; Owner: -
--

