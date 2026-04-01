CREATE FUNCTION public.get_closed_boxes(p_branch_id text DEFAULT 'all'::text, p_date_from timestamp with time zone DEFAULT NULL::timestamp with time zone, p_date_to timestamp with time zone DEFAULT NULL::timestamp with time zone, p_limit integer DEFAULT 50, p_offset integer DEFAULT 0) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
  v_total_count bigint;
  v_boxes jsonb;
BEGIN
  -- Get total count for the filtered set
  SELECT COUNT(*)
  INTO v_total_count
  FROM box_operations bo
  WHERE bo.status = 'completed'
    AND (p_branch_id = 'all' OR bo.branch_id = p_branch_id::int)
    AND (p_date_from IS NULL OR bo.updated_at >= p_date_from)
    AND (p_date_to IS NULL OR bo.updated_at <= p_date_to);

  -- Get boxes with their transfer status included
  SELECT COALESCE(jsonb_agg(row_data ORDER BY (row_data->>'updated_at') DESC), '[]'::jsonb)
  INTO v_boxes
  FROM (
    SELECT jsonb_build_object(
      'id', bo.id,
      'box_number', bo.box_number,
      'branch_id', bo.branch_id,
      'user_id', bo.user_id,
      'status', bo.status,
      'notes', bo.notes,
      'complete_details', bo.complete_details,
      'completed_by_name', bo.completed_by_name,
      'completed_by_user_id', bo.completed_by_user_id,
      'total_before', bo.total_before,
      'total_after', bo.total_after,
      'created_at', bo.created_at,
      'updated_at', bo.updated_at,
      'transfer_status', pdt.status::text,
      'transfer_key', CASE WHEN pdt.box_number IS NOT NULL 
        THEN pdt.box_number::text || '-' || pdt.branch_id::text || '-' || pdt.date_closed_box::text
        ELSE NULL END
    ) as row_data
    FROM box_operations bo
    LEFT JOIN pos_deduction_transfers pdt 
      ON pdt.box_operation_id = bo.id
    WHERE bo.status = 'completed'
      AND (p_branch_id = 'all' OR bo.branch_id = p_branch_id::int)
      AND (p_date_from IS NULL OR bo.updated_at >= p_date_from)
      AND (p_date_to IS NULL OR bo.updated_at <= p_date_to)
    ORDER BY bo.updated_at DESC
    LIMIT p_limit
    OFFSET p_offset
  ) sub;

  RETURN jsonb_build_object(
    'boxes', v_boxes,
    'total_count', v_total_count
  );
END;
$$;


--
-- Name: get_completed_receiving_tasks(); Type: FUNCTION; Schema: public; Owner: -
--

