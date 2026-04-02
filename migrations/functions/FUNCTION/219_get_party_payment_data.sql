CREATE FUNCTION public.get_party_payment_data(p_party_type text, p_party_id uuid) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN json_build_object(
        'changes', (
            SELECT COALESCE(json_agg(sub), '[]'::json)
            FROM (
                SELECT * FROM lease_rent_special_changes
                WHERE party_type = p_party_type AND party_id = p_party_id
                ORDER BY effective_from ASC
            ) sub
        ),
        'entries', (
            SELECT COALESCE(json_agg(sub), '[]'::json)
            FROM (
                SELECT * FROM lease_rent_payment_entries
                WHERE party_type = p_party_type AND party_id = p_party_id
                ORDER BY created_at ASC
            ) sub
        )
    );
END;
$$;


--
-- Name: get_po_requests_with_details(); Type: FUNCTION; Schema: public; Owner: -
--

