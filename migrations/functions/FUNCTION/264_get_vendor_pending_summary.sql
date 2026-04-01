CREATE FUNCTION public.get_vendor_pending_summary() RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
  result jsonb;
  vps_paid numeric := 0;
  vps_unpaid numeric := 0;
  exp_paid numeric := 0;
  exp_unpaid numeric := 0;
  vendor_count integer := 0;
  vendors_arr jsonb;
  methods_arr jsonb;
BEGIN
  -- 1. Aggregate totals from vendor_payment_schedule
  SELECT
    COALESCE(SUM(CASE WHEN is_paid THEN final_bill_amount ELSE 0 END), 0),
    COALESCE(SUM(CASE WHEN NOT is_paid THEN final_bill_amount ELSE 0 END), 0)
  INTO vps_paid, vps_unpaid
  FROM vendor_payment_schedule;

  -- 2. Aggregate totals from expense_scheduler (vendor expenses only)
  SELECT
    COALESCE(SUM(CASE WHEN is_paid THEN amount ELSE 0 END), 0),
    COALESCE(SUM(CASE WHEN NOT is_paid THEN amount ELSE 0 END), 0)
  INTO exp_paid, exp_unpaid
  FROM expense_scheduler
  WHERE vendor_id IS NOT NULL;

  -- 3. Get distinct vendors from both tables
  WITH all_vendors AS (
    SELECT DISTINCT vendor_id::text AS vid, vendor_name AS vname
    FROM vendor_payment_schedule
    WHERE vendor_id IS NOT NULL AND vendor_name IS NOT NULL
    UNION
    SELECT DISTINCT vendor_id::text AS vid, vendor_name AS vname
    FROM expense_scheduler
    WHERE vendor_id IS NOT NULL AND vendor_name IS NOT NULL
  )
  SELECT
    COUNT(*),
    COALESCE(jsonb_agg(jsonb_build_object('vendor_id', vid, 'vendor_name', vname) ORDER BY vname), '[]'::jsonb)
  INTO vendor_count, vendors_arr
  FROM all_vendors;

  -- 4. Get distinct payment methods from both tables
  WITH all_methods AS (
    SELECT DISTINCT payment_method AS m
    FROM vendor_payment_schedule
    WHERE payment_method IS NOT NULL AND payment_method != ''
    UNION
    SELECT DISTINCT payment_method AS m
    FROM expense_scheduler
    WHERE payment_method IS NOT NULL AND payment_method != '' AND vendor_id IS NOT NULL
  )
  SELECT COALESCE(jsonb_agg(m ORDER BY m), '[]'::jsonb)
  INTO methods_arr
  FROM all_methods;

  -- 5. Build final result
  result := jsonb_build_object(
    'global_total_paid', vps_paid + exp_paid,
    'global_total_unpaid', vps_unpaid + exp_unpaid,
    'global_grand_total', vps_paid + exp_paid + vps_unpaid + exp_unpaid,
    'total_vendor_count', vendor_count,
    'vendors', vendors_arr,
    'payment_methods', methods_arr
  );

  RETURN result;
END;
$$;


--
-- Name: get_vendor_promissory_notes_summary(uuid); Type: FUNCTION; Schema: public; Owner: -
--

