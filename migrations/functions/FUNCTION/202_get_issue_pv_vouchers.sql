CREATE FUNCTION public.get_issue_pv_vouchers(p_pv_id text DEFAULT NULL::text, p_serial_number bigint DEFAULT NULL::bigint) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
  result jsonb;
BEGIN
  IF p_pv_id IS NULL AND p_serial_number IS NULL THEN
    RETURN '[]'::jsonb;
  END IF;

  SELECT COALESCE(jsonb_agg(row_to_json(t)), '[]'::jsonb)
  INTO result
  FROM (
    SELECT
      pvi.id,
      pvi.purchase_voucher_id,
      pvi.serial_number,
      pvi.value,
      pvi.stock,
      pvi.status,
      pvi.issue_type,
      pvi.stock_location,
      pvi.stock_person,
      COALESCE(b.name_en || ' - ' || b.location_en, '') as stock_location_name,
      COALESCE(
        u.username || ' - ' || emp.name_en,
        u.username,
        ''
      ) as stock_person_name
    FROM purchase_voucher_items pvi
    LEFT JOIN branches b ON b.id = pvi.stock_location
    LEFT JOIN users u ON u.id = pvi.stock_person
    LEFT JOIN hr_employee_master emp ON emp.id = u.employee_id::text
    WHERE pvi.issue_type = 'not issued'
      AND (p_pv_id IS NULL OR pvi.purchase_voucher_id = p_pv_id)
      AND (p_serial_number IS NULL OR pvi.serial_number = p_serial_number)
    ORDER BY pvi.serial_number
  ) t;

  RETURN result;
END;
$$;


--
-- Name: get_latest_frontend_build(); Type: FUNCTION; Schema: public; Owner: -
--

