CREATE FUNCTION public.get_quick_access_stats() RETURNS TABLE(total_codes bigint, active_codes bigint, unused_codes bigint)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        COUNT(*)::BIGINT as total_codes,
        COUNT(CASE WHEN status = 'active' THEN 1 END)::BIGINT as active_codes,
        COUNT(CASE WHEN quick_access_code IS NOT NULL AND last_login_at IS NULL THEN 1 END)::BIGINT as unused_codes
    FROM users
    WHERE deleted_at IS NULL;
END;
$$;


--
-- Name: get_quick_expiry_report(integer); Type: FUNCTION; Schema: public; Owner: -
--

