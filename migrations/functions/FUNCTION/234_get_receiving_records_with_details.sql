CREATE FUNCTION public.get_receiving_records_with_details(p_limit integer DEFAULT 500, p_offset integer DEFAULT 0, p_branch_id text DEFAULT NULL::text, p_vendor_search text DEFAULT NULL::text, p_pr_excel_filter text DEFAULT NULL::text, p_erp_ref_filter text DEFAULT NULL::text) RETURNS TABLE(id text, bill_number text, vendor_id text, branch_id text, bill_date date, bill_amount numeric, created_at timestamp with time zone, user_id text, original_bill_url text, erp_purchase_invoice_reference text, certificate_url text, due_date date, pr_excel_file_url text, final_bill_amount numeric, payment_method text, credit_period integer, bank_name text, iban text, branch_name_en text, branch_location_en text, vendor_name text, vat_number text, username text, user_display_name text, is_scheduled boolean, is_paid boolean, pr_excel_verified boolean, pr_excel_verified_by text, pr_excel_verified_date timestamp with time zone, total_count bigint)
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
    v_total BIGINT;
BEGIN
    -- Get total count with same filters (for pagination info)
    SELECT COUNT(*) INTO v_total
    FROM receiving_records r
    LEFT JOIN branches b ON b.id = r.branch_id
    LEFT JOIN vendors v ON v.erp_vendor_id = r.vendor_id AND v.branch_id = r.branch_id
    LEFT JOIN LATERAL (
        SELECT vps.pr_excel_verified
        FROM vendor_payment_schedule vps
        WHERE vps.receiving_record_id = r.id
        LIMIT 1
    ) ps_count ON true
    WHERE (p_branch_id IS NULL OR r.branch_id::TEXT = p_branch_id)
      AND (p_vendor_search IS NULL OR p_vendor_search = '' OR LOWER(v.vendor_name) LIKE '%' || LOWER(p_vendor_search) || '%')
      AND (p_pr_excel_filter IS NULL OR p_pr_excel_filter = '' 
           OR (p_pr_excel_filter = 'verified' AND COALESCE(ps_count.pr_excel_verified, false) = true)
           OR (p_pr_excel_filter = 'unverified' AND COALESCE(ps_count.pr_excel_verified, false) = false))
      AND (p_erp_ref_filter IS NULL OR p_erp_ref_filter = ''
           OR (p_erp_ref_filter = 'entered' AND r.erp_purchase_invoice_reference IS NOT NULL AND TRIM(r.erp_purchase_invoice_reference::TEXT) <> '')
           OR (p_erp_ref_filter = 'not_entered' AND (r.erp_purchase_invoice_reference IS NULL OR TRIM(r.erp_purchase_invoice_reference::TEXT) = '')));

    RETURN QUERY
    SELECT
        r.id::TEXT,
        r.bill_number::TEXT,
        r.vendor_id::TEXT,
        r.branch_id::TEXT,
        r.bill_date,
        r.bill_amount,
        r.created_at,
        r.user_id::TEXT,
        r.original_bill_url::TEXT,
        r.erp_purchase_invoice_reference::TEXT,
        r.certificate_url::TEXT,
        r.due_date,
        r.pr_excel_file_url::TEXT,
        r.final_bill_amount,
        r.payment_method::TEXT,
        r.credit_period,
        r.bank_name::TEXT,
        r.iban::TEXT,
        -- Branch
        COALESCE(b.name_en, 'N/A')::TEXT AS branch_name_en,
        COALESCE(b.location_en, '')::TEXT AS branch_location_en,
        -- Vendor (match by erp_vendor_id AND branch_id)
        COALESCE(v.vendor_name, 'N/A')::TEXT AS vendor_name,
        v.vat_number::TEXT,
        -- User
        COALESCE(u.username, '')::TEXT AS username,
        COALESCE(he.name, u.username, '')::TEXT AS user_display_name,
        -- Payment schedule
        (ps.receiving_record_id IS NOT NULL) AS is_scheduled,
        COALESCE(ps.is_paid, false) AS is_paid,
        COALESCE(ps.pr_excel_verified, false) AS pr_excel_verified,
        ps.pr_excel_verified_by::TEXT,
        ps.pr_excel_verified_date,
        -- Total count
        v_total AS total_count
    FROM receiving_records r
    LEFT JOIN branches b ON b.id = r.branch_id
    LEFT JOIN vendors v ON v.erp_vendor_id = r.vendor_id AND v.branch_id = r.branch_id
    LEFT JOIN users u ON u.id = r.user_id
    LEFT JOIN hr_employees he ON he.id = u.id
    LEFT JOIN LATERAL (
        SELECT 
            vps.receiving_record_id,
            vps.is_paid,
            vps.pr_excel_verified,
            vps.pr_excel_verified_by,
            vps.pr_excel_verified_date
        FROM vendor_payment_schedule vps
        WHERE vps.receiving_record_id = r.id
        LIMIT 1
    ) ps ON true
    WHERE (p_branch_id IS NULL OR r.branch_id::TEXT = p_branch_id)
      AND (p_vendor_search IS NULL OR p_vendor_search = '' OR LOWER(v.vendor_name) LIKE '%' || LOWER(p_vendor_search) || '%')
      AND (p_pr_excel_filter IS NULL OR p_pr_excel_filter = ''
           OR (p_pr_excel_filter = 'verified' AND COALESCE(ps.pr_excel_verified, false) = true)
           OR (p_pr_excel_filter = 'unverified' AND COALESCE(ps.pr_excel_verified, false) = false))
      AND (p_erp_ref_filter IS NULL OR p_erp_ref_filter = ''
           OR (p_erp_ref_filter = 'entered' AND r.erp_purchase_invoice_reference IS NOT NULL AND TRIM(r.erp_purchase_invoice_reference::TEXT) <> '')
           OR (p_erp_ref_filter = 'not_entered' AND (r.erp_purchase_invoice_reference IS NULL OR TRIM(r.erp_purchase_invoice_reference::TEXT) = '')))
    ORDER BY r.created_at DESC
    LIMIT p_limit
    OFFSET p_offset;
END;
$$;


--
-- Name: get_receiving_task_statistics(integer, date, date); Type: FUNCTION; Schema: public; Owner: -
--

