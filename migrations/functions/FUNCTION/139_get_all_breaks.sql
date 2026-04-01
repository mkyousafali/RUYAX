CREATE FUNCTION public.get_all_breaks(p_date_from date DEFAULT NULL::date, p_date_to date DEFAULT NULL::date, p_branch_id integer DEFAULT NULL::integer, p_status character varying DEFAULT NULL::character varying) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  v_result JSONB;
BEGIN
  SELECT COALESCE(jsonb_agg(row_to_json(t)::jsonb ORDER BY t.start_time DESC), '[]'::jsonb)
  INTO v_result
  FROM (
    SELECT
      br.id,
      br.employee_id,
      br.employee_name_en,
      br.employee_name_ar,
      br.branch_id,
      b.name_en as branch_name_en,
      b.name_ar as branch_name_ar,
      r.name_en as reason_en,
      r.name_ar as reason_ar,
      br.reason_note,
      br.start_time,
      br.end_time,
      br.duration_seconds,
      br.status
    FROM break_register br
    JOIN break_reasons r ON r.id = br.reason_id
    LEFT JOIN branches b ON b.id = br.branch_id
    WHERE (p_date_from IS NULL OR br.start_time::DATE >= p_date_from)
      AND (p_date_to IS NULL OR br.start_time::DATE <= p_date_to)
      AND (p_branch_id IS NULL OR br.branch_id = p_branch_id)
      AND (p_status IS NULL OR br.status = p_status)
    ORDER BY br.start_time DESC
    LIMIT 500
  ) t;

  RETURN jsonb_build_object('breaks', v_result);
END;
$$;


--
-- Name: get_all_delivery_tiers(); Type: FUNCTION; Schema: public; Owner: -
--

