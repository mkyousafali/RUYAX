CREATE FUNCTION public.get_pv_stock_manager_data() RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
  result jsonb;
BEGIN
  SELECT jsonb_build_object(
    'book_summary', COALESCE((
      SELECT jsonb_agg(to_jsonb(bs.*) ORDER BY bs.has_unassigned DESC, bs.voucher_id ASC)
      FROM (
        SELECT 
          pv.id AS voucher_id,
          pv.book_number,
          pv.serial_start || ' - ' || pv.serial_end AS serial_range,
          COUNT(pvi.id)::int AS total_count,
          COALESCE(SUM(pvi.value), 0)::numeric AS total_value,
          COUNT(CASE WHEN pvi.stock > 0 THEN 1 END)::int AS stock_count,
          COUNT(CASE WHEN pvi.status = 'stocked' THEN 1 END)::int AS stocked_count,
          COUNT(CASE WHEN pvi.status = 'issued' THEN 1 END)::int AS issued_count,
          COUNT(CASE WHEN pvi.status = 'closed' THEN 1 END)::int AS closed_count,
          COALESCE(
            (SELECT jsonb_agg(DISTINCT sl) FROM unnest(array_agg(DISTINCT pvi.stock_location)) sl WHERE sl IS NOT NULL),
            '[]'::jsonb
          ) AS stock_locations,
          COALESCE(
            (SELECT jsonb_agg(DISTINCT sp) FROM unnest(array_agg(DISTINCT pvi.stock_person)) sp WHERE sp IS NOT NULL),
            '[]'::jsonb
          ) AS stock_persons,
          CASE WHEN bool_or(pvi.stock_location IS NULL OR pvi.stock_person IS NULL) THEN 1 ELSE 0 END AS has_unassigned
        FROM purchase_vouchers pv
        LEFT JOIN purchase_voucher_items pvi ON pvi.purchase_voucher_id = pv.id
        GROUP BY pv.id, pv.book_number, pv.serial_start, pv.serial_end
      ) bs
    ), '[]'::jsonb),
    'branches', COALESCE((
      SELECT jsonb_agg(jsonb_build_object('id', b.id, 'name_en', b.name_en, 'location_en', b.location_en))
      FROM branches b
    ), '[]'::jsonb),
    'users', COALESCE((
      SELECT jsonb_agg(jsonb_build_object('id', u.id, 'username', u.username, 'employee_id', u.employee_id))
      FROM users u
    ), '[]'::jsonb),
    'employees', COALESCE((
      SELECT jsonb_agg(jsonb_build_object('id', e.id, 'name', e.name))
      FROM hr_employees e
    ), '[]'::jsonb)
  ) INTO result;

  RETURN result;
END;
$$;


--
-- Name: get_pv_stock_voucher_items(); Type: FUNCTION; Schema: public; Owner: -
--

