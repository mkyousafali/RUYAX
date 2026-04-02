CREATE FUNCTION public.get_customers_list() RETURNS TABLE(id uuid, name text, access_code text, whatsapp_number text, registration_status text, registration_notes text, approved_by uuid, approved_at timestamp with time zone, access_code_generated_at timestamp with time zone, last_login_at timestamp with time zone, created_at timestamp with time zone, updated_at timestamp with time zone, location1_name text, location1_url text, location1_lat double precision, location1_lng double precision, location2_name text, location2_url text, location2_lat double precision, location2_lng double precision, location3_name text, location3_url text, location3_lat double precision, location3_lng double precision, is_deleted boolean)
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
BEGIN
  RETURN QUERY
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
  ORDER BY
    CASE
      WHEN c.registration_status = 'pending' THEN 1
      WHEN c.registration_status = 'approved' THEN 2
      WHEN c.registration_status = 'rejected' THEN 3
      WHEN c.registration_status = 'suspended' THEN 4
      ELSE 5
    END,
    c.created_at DESC;
END;
$$;


--
-- Name: get_customers_list_paginated(text, text, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

