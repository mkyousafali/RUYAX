CREATE FUNCTION public.get_purchase_voucher_manager_data() RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
  result jsonb;
  not_issued_stats jsonb;
  issued_stats jsonb;
  closed_stats jsonb;
  book_summary_data jsonb;
  branches_data jsonb;
  users_data jsonb;
  employees_data jsonb;
BEGIN

  -- 1. Not Issued Stats: group by stock_location, value
  SELECT COALESCE(jsonb_agg(row_to_json(t)::jsonb), '[]'::jsonb)
  INTO not_issued_stats
  FROM (
    SELECT 
      COALESCE(stock_location::text, 'unassigned') as stock_location,
      value,
      count(*) as voucher_count,
      count(DISTINCT purchase_voucher_id) as book_count
    FROM purchase_voucher_items
    WHERE issue_type = 'not issued'
    GROUP BY COALESCE(stock_location::text, 'unassigned'), value
  ) t;

  -- 2. Issued Stats: group by stock_location, value, issue_type (excluding 'not issued')
  SELECT COALESCE(jsonb_agg(row_to_json(t)::jsonb), '[]'::jsonb)
  INTO issued_stats
  FROM (
    SELECT 
      COALESCE(stock_location::text, 'unassigned') as stock_location,
      value,
      COALESCE(issue_type, 'unknown') as issue_type,
      count(*) as voucher_count,
      count(DISTINCT purchase_voucher_id) as book_count
    FROM purchase_voucher_items
    WHERE issue_type != 'not issued'
    GROUP BY COALESCE(stock_location::text, 'unassigned'), value, COALESCE(issue_type, 'unknown')
  ) t;

  -- 3. Closed Stats: group by stock_location, value, issue_type (status = 'closed')
  SELECT COALESCE(jsonb_agg(row_to_json(t)::jsonb), '[]'::jsonb)
  INTO closed_stats
  FROM (
    SELECT 
      COALESCE(stock_location::text, 'unassigned') as stock_location,
      value,
      COALESCE(issue_type, 'unknown') as issue_type,
      count(*) as voucher_count,
      count(DISTINCT purchase_voucher_id) as book_count
    FROM purchase_voucher_items
    WHERE status = 'closed'
    GROUP BY COALESCE(stock_location::text, 'unassigned'), value, COALESCE(issue_type, 'unknown')
  ) t;

  -- 4. Book Summary: join purchase_vouchers with aggregated purchase_voucher_items
  SELECT COALESCE(jsonb_agg(row_to_json(t)::jsonb ORDER BY t.has_unassigned DESC, t.voucher_id ASC), '[]'::jsonb)
  INTO book_summary_data
  FROM (
    SELECT 
      pv.id as voucher_id,
      pv.book_number,
      pv.serial_start || ' - ' || pv.serial_end as serial_range,
      COALESCE(agg.total_count, 0) as total_count,
      COALESCE(agg.total_value, 0) as total_value,
      COALESCE(agg.stock_count, 0) as stock_count,
      COALESCE(agg.stocked_count, 0) as stocked_count,
      COALESCE(agg.issued_count, 0) as issued_count,
      COALESCE(agg.closed_count, 0) as closed_count,
      COALESCE(agg.stock_locations, '[]'::jsonb) as stock_locations,
      COALESCE(agg.stock_persons, '[]'::jsonb) as stock_persons,
      CASE WHEN COALESCE(agg.stock_locations, '[]'::jsonb) = '[]'::jsonb 
           OR COALESCE(agg.stock_persons, '[]'::jsonb) = '[]'::jsonb 
           THEN 1 ELSE 0 END as has_unassigned
    FROM purchase_vouchers pv
    LEFT JOIN (
      SELECT 
        purchase_voucher_id,
        count(*) as total_count,
        COALESCE(sum(value), 0) as total_value,
        count(*) FILTER (WHERE stock > 0) as stock_count,
        count(*) FILTER (WHERE status = 'stocked') as stocked_count,
        count(*) FILTER (WHERE status = 'issued') as issued_count,
        count(*) FILTER (WHERE status = 'closed') as closed_count,
        COALESCE(jsonb_agg(DISTINCT stock_location) FILTER (WHERE stock_location IS NOT NULL AND stock_location::text != ''), '[]'::jsonb) as stock_locations,
        COALESCE(jsonb_agg(DISTINCT stock_person) FILTER (WHERE stock_person IS NOT NULL AND stock_person::text != ''), '[]'::jsonb) as stock_persons
      FROM purchase_voucher_items
      GROUP BY purchase_voucher_id
    ) agg ON agg.purchase_voucher_id = pv.id
  ) t;

  -- 5. Branches lookup
  SELECT COALESCE(jsonb_agg(row_to_json(t)::jsonb), '[]'::jsonb)
  INTO branches_data
  FROM (
    SELECT id, name_en, location_en FROM branches ORDER BY name_en
  ) t;

  -- 6. Users lookup
  SELECT COALESCE(jsonb_agg(row_to_json(t)::jsonb), '[]'::jsonb)
  INTO users_data
  FROM (
    SELECT id, username, employee_id FROM users
  ) t;

  -- 7. Employees lookup
  SELECT COALESCE(jsonb_agg(row_to_json(t)::jsonb), '[]'::jsonb)
  INTO employees_data
  FROM (
    SELECT id, name FROM hr_employees
  ) t;

  -- Build final result
  result := jsonb_build_object(
    'not_issued_stats', not_issued_stats,
    'issued_stats', issued_stats,
    'closed_stats', closed_stats,
    'book_summary', book_summary_data,
    'branches', branches_data,
    'users', users_data,
    'employees', employees_data
  );

  RETURN result;
END;
$$;


--
-- Name: get_pv_stock_manager_data(); Type: FUNCTION; Schema: public; Owner: -
--

