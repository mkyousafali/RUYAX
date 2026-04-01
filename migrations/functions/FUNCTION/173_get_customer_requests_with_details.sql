CREATE FUNCTION public.get_customer_requests_with_details() RETURNS TABLE(id uuid, requester_user_id uuid, branch_id integer, target_user_id uuid, status text, items jsonb, notes text, created_at timestamp with time zone, updated_at timestamp with time zone, requester_name_en text, requester_name_ar text, target_name_en text, target_name_ar text, branch_name_en text, branch_name_ar text, branch_location_en text, branch_location_ar text)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        r.id,
        r.requester_user_id,
        r.branch_id,
        r.target_user_id,
        r.status,
        r.items,
        r.notes,
        r.created_at,
        r.updated_at,
        COALESCE(req.name_en, req.user_id::TEXT)::TEXT AS requester_name_en,
        COALESCE(req.name_ar, req.name_en, req.user_id::TEXT)::TEXT AS requester_name_ar,
        COALESCE(tgt.name_en, tgt.user_id::TEXT)::TEXT AS target_name_en,
        COALESCE(tgt.name_ar, tgt.name_en, tgt.user_id::TEXT)::TEXT AS target_name_ar,
        COALESCE(b.name_en, '')::TEXT AS branch_name_en,
        COALESCE(b.name_ar, b.name_en, '')::TEXT AS branch_name_ar,
        COALESCE(b.location_en, '')::TEXT AS branch_location_en,
        COALESCE(b.location_ar, b.location_en, '')::TEXT AS branch_location_ar
    FROM customer_product_requests r
    LEFT JOIN hr_employee_master req ON req.user_id = r.requester_user_id
    LEFT JOIN hr_employee_master tgt ON tgt.user_id = r.target_user_id
    LEFT JOIN branches b ON b.id = r.branch_id
    ORDER BY r.created_at DESC;
END;
$$;


--
-- Name: get_customers_list(); Type: FUNCTION; Schema: public; Owner: -
--

