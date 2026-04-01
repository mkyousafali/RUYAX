CREATE FUNCTION public.get_report_party_paid_totals(p_party_type text) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN (
        SELECT COALESCE(json_object_agg(party_id, total_paid), '{}'::json)
        FROM (
            SELECT party_id, SUM(amount)::numeric as total_paid
            FROM lease_rent_payment_entries
            WHERE party_type = p_party_type
            GROUP BY party_id
        ) sub
    );
END;
$$;


--
-- Name: get_server_disk_usage(); Type: FUNCTION; Schema: public; Owner: -
--

