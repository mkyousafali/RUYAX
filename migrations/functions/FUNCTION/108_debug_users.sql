CREATE FUNCTION public.debug_users() RETURNS TABLE(user_id uuid, username character varying, status character varying, employee_id uuid, branch_id bigint, position_id uuid)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        u.id as user_id,
        u.username,
        u.status::VARCHAR,
        u.employee_id,
        u.branch_id,
        u.position_id
    FROM users u
    ORDER BY u.created_at DESC;
END;
$$;


--
-- Name: decrement_voucher_stock(numeric, integer); Type: FUNCTION; Schema: public; Owner: -
--

