CREATE FUNCTION public.get_day_offs_with_details(p_date_from date, p_date_to date) RETURNS TABLE(id text, employee_id text, employee_id_number text, employee_name_en text, employee_name_ar text, employee_email text, employee_whatsapp text, branch_id text, branch_name_en text, branch_name_ar text, branch_location_en text, branch_location_ar text, nationality_id text, nationality_name_en text, nationality_name_ar text, sponsorship_status text, employment_status text, day_off_date date, approval_status text, reason_en text, reason_ar text, document_url text, description text, is_deductible_on_salary boolean, approval_requested_at timestamp with time zone, day_off_reason_id text, approver_name_en text, approver_name_ar text)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        d.id::TEXT,
        d.employee_id::TEXT,
        COALESCE(e.id_number, '')::TEXT AS employee_id_number,
        COALESCE(e.name_en, 'N/A')::TEXT AS employee_name_en,
        COALESCE(e.name_ar, 'N/A')::TEXT AS employee_name_ar,
        COALESCE(e.email, '')::TEXT AS employee_email,
        COALESCE(e.whatsapp_number, '')::TEXT AS employee_whatsapp,
        e.current_branch_id::TEXT AS branch_id,
        COALESCE(b.name_en, 'N/A')::TEXT AS branch_name_en,
        COALESCE(b.name_ar, 'N/A')::TEXT AS branch_name_ar,
        COALESCE(b.location_en, '')::TEXT AS branch_location_en,
        COALESCE(b.location_ar, '')::TEXT AS branch_location_ar,
        e.nationality_id::TEXT,
        COALESCE(n.name_en, 'N/A')::TEXT AS nationality_name_en,
        COALESCE(n.name_ar, 'N/A')::TEXT AS nationality_name_ar,
        e.sponsorship_status::TEXT,
        e.employment_status::TEXT,
        d.day_off_date,
        COALESCE(d.approval_status, 'pending')::TEXT AS approval_status,
        COALESCE(r.reason_en, 'N/A')::TEXT AS reason_en,
        COALESCE(r.reason_ar, 'N/A')::TEXT AS reason_ar,
        d.document_url::TEXT,
        d.description::TEXT,
        COALESCE(d.is_deductible_on_salary, false) AS is_deductible_on_salary,
        d.approval_requested_at,
        d.day_off_reason_id::TEXT,
        COALESCE(a.name_en, '')::TEXT AS approver_name_en,
        COALESCE(a.name_ar, '')::TEXT AS approver_name_ar
    FROM day_off d
    LEFT JOIN hr_employee_master e ON e.id = d.employee_id
    LEFT JOIN branches b ON b.id = e.current_branch_id
    LEFT JOIN nationalities n ON n.id = e.nationality_id
    LEFT JOIN day_off_reasons r ON r.id = d.day_off_reason_id
    LEFT JOIN hr_employee_master a ON a.user_id = d.approval_approved_by
    WHERE d.day_off_date >= p_date_from
      AND d.day_off_date <= p_date_to
    ORDER BY d.day_off_date DESC;
END;
$$;


--
-- Name: get_default_flyer_template(); Type: FUNCTION; Schema: public; Owner: -
--

