CREATE FUNCTION public.get_customers_list_paginated(p_search text DEFAULT ''::text, p_status text DEFAULT 'all'::text, p_limit integer DEFAULT 50, p_offset integer DEFAULT 0) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
  result json;
  total_count bigint;
  rows_data json;
BEGIN
  -- Get total count with filters
  SELECT count(*)
  INTO total_count
  FROM customers c
  WHERE
    (p_status = 'all' OR c.registration_status = p_status)
    AND (
      p_search = '' 
      OR c.name ILIKE '%' || p_search || '%'
      OR c.whatsapp_number ILIKE '%' || p_search || '%'
    );

  -- Get paginated rows
  SELECT json_agg(row_data)
  INTO rows_data
  FROM (
    SELECT
      c.id,
      c.name,
      c.access_code,
      c.whatsapp_number::text,
      c.registration_status,
      c.registration_notes,
      c.approved_by,
      c.approved_at,
      c.access_code_generated_at,
      c.last_login_at,
      c.created_at,
      c.updated_at,
      c.location1_name,
      c.location1_url,
      c.location1_lat,
      c.location1_lng,
      c.location2_name,
      c.location2_url,
      c.location2_lat,
      c.location2_lng,
      c.location3_name,
      c.location3_url,
      c.location3_lat,
      c.location3_lng,
      c.is_deleted
    FROM customers c
    WHERE
      (p_status = 'all' OR c.registration_status = p_status)
      AND (
        p_search = '' 
        OR c.name ILIKE '%' || p_search || '%'
        OR c.whatsapp_number ILIKE '%' || p_search || '%'
      )
    ORDER BY
      CASE
        WHEN c.registration_status = 'pending' THEN 1
        WHEN c.registration_status = 'approved' THEN 2
        WHEN c.registration_status = 'rejected' THEN 3
        WHEN c.registration_status = 'suspended' THEN 4
        ELSE 5
      END,
      c.created_at DESC
    LIMIT p_limit
    OFFSET p_offset
  ) row_data;

  -- Build result JSON
  result := json_build_object(
    'data', COALESCE(rows_data, '[]'::json),
    'total', total_count
  );

  RETURN result;
END;
$$;


--
-- Name: get_database_functions(); Type: FUNCTION; Schema: public; Owner: -
--

