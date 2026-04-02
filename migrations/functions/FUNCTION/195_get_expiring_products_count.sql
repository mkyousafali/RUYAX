CREATE FUNCTION public.get_expiring_products_count(p_employee_id text) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  v_branch_id INTEGER;
  v_count INTEGER := 0;
BEGIN
  -- Get employee's current branch
  SELECT current_branch_id INTO v_branch_id
  FROM hr_employee_master
  WHERE id = p_employee_id;

  IF v_branch_id IS NULL THEN
    RETURN jsonb_build_object('count', 0);
  END IF;

  -- Count products managed by this employee where expiry for their branch is < 15 days from now
  SELECT COUNT(DISTINCT p.barcode)
  INTO v_count
  FROM erp_synced_products p,
       LATERAL jsonb_array_elements(COALESCE(p.expiry_dates, '[]'::jsonb)) AS ed
  WHERE p.managed_by @> ('[{"employee_id":"' || p_employee_id || '"}]')::jsonb
    AND (ed->>'branch_id')::INTEGER = v_branch_id
    AND (ed->>'expiry_date') IS NOT NULL
    AND (ed->>'expiry_date')::DATE >= CURRENT_DATE
    AND (ed->>'expiry_date')::DATE < (CURRENT_DATE + INTERVAL '15 days');

  RETURN jsonb_build_object('count', v_count);
END;
$$;


--
-- Name: get_file_extension(text); Type: FUNCTION; Schema: public; Owner: -
--

