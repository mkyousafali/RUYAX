CREATE FUNCTION public.get_all_users() RETURNS TABLE(id uuid, username character varying, email character varying, role_type character varying, status character varying, employee_id uuid, created_at timestamp with time zone, updated_at timestamp with time zone)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        u.id,
        u.username,
        u.email,
        -- Use admin flags instead of role_type column
        CASE 
            WHEN u.is_master_admin THEN 'Master Admin'::VARCHAR
            WHEN u.is_admin THEN 'Admin'::VARCHAR
            ELSE 'User'::VARCHAR
        END as role_type,
        'active'::VARCHAR as status,
        u.employee_id,
        u.created_at,
        u.updated_at
    FROM users u
    WHERE u.deleted_at IS NULL
    ORDER BY u.created_at DESC;
END;
$$;


--
-- Name: get_analytics_log_tables(); Type: FUNCTION; Schema: public; Owner: -
--

