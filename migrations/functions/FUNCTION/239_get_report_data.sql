CREATE FUNCTION public.get_report_data(p_party_type text, p_party_ids uuid[]) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN json_build_object(
        'entries', (
            SELECT COALESCE(json_agg(sub), '[]'::json)
            FROM (
                SELECT * FROM lease_rent_payment_entries
                WHERE party_type = p_party_type AND party_id = ANY(p_party_ids)
                ORDER BY created_at ASC
            ) sub
        ),
        'changes', (
            SELECT COALESCE(json_agg(sub), '[]'::json)
            FROM (
                SELECT * FROM lease_rent_special_changes
                WHERE party_type = p_party_type AND party_id = ANY(p_party_ids)
                ORDER BY created_at DESC
            ) sub
        )
    );
END;
$$;


--
-- Name: get_report_party_paid_totals(text); Type: FUNCTION; Schema: public; Owner: -
--

