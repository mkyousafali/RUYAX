CREATE FUNCTION public.get_bt_requests_with_details() RETURNS TABLE(id uuid, requester_user_id uuid, from_branch_id integer, to_branch_id integer, target_user_id uuid, status character varying, items jsonb, document_url text, created_at timestamp with time zone, updated_at timestamp with time zone, requester_name_en text, requester_name_ar text, target_name_en text, target_name_ar text, from_branch_name_en text, from_branch_name_ar text, from_branch_location_en text, from_branch_location_ar text, to_branch_name_en text, to_branch_name_ar text, to_branch_location_en text, to_branch_location_ar text)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        r.id,
        r.requester_user_id,
        r.from_branch_id,
        r.to_branch_id,
        r.target_user_id,
        r.status,
        r.items,
        r.document_url,
        r.created_at,
        r.updated_at,
        COALESCE(req.name_en, req.user_id::TEXT)::TEXT AS requester_name_en,
        COALESCE(req.name_ar, req.name_en, req.user_id::TEXT)::TEXT AS requester_name_ar,
        COALESCE(tgt.name_en, tgt.user_id::TEXT)::TEXT AS target_name_en,
        COALESCE(tgt.name_ar, tgt.name_en, tgt.user_id::TEXT)::TEXT AS target_name_ar,
        COALESCE(fb.name_en, '')::TEXT AS from_branch_name_en,
        COALESCE(fb.name_ar, fb.name_en, '')::TEXT AS from_branch_name_ar,
        COALESCE(fb.location_en, '')::TEXT AS from_branch_location_en,
        COALESCE(fb.location_ar, fb.location_en, '')::TEXT AS from_branch_location_ar,
        COALESCE(tb.name_en, '')::TEXT AS to_branch_name_en,
        COALESCE(tb.name_ar, tb.name_en, '')::TEXT AS to_branch_name_ar,
        COALESCE(tb.location_en, '')::TEXT AS to_branch_location_en,
        COALESCE(tb.location_ar, tb.location_en, '')::TEXT AS to_branch_location_ar
    FROM product_request_bt r
    LEFT JOIN hr_employee_master req ON req.user_id = r.requester_user_id
    LEFT JOIN hr_employee_master tgt ON tgt.user_id = r.target_user_id
    LEFT JOIN branches fb ON fb.id = r.from_branch_id
    LEFT JOIN branches tb ON tb.id = r.to_branch_id
    ORDER BY r.created_at DESC;
END;
$$;


--
-- Name: get_bucket_files(text); Type: FUNCTION; Schema: public; Owner: -
--

