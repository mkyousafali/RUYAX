CREATE FUNCTION public.has_order_management_access(user_id uuid) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM users u
        LEFT JOIN user_roles ur ON u.position_id::text = ur.role_code
        WHERE u.id = user_id
        AND (
            -- Use boolean flags instead of role_type
            u.is_admin = true 
            OR u.is_master_admin = true
            OR ur.role_code IN (
                'CEO',
                'OPERATIONS_MANAGER',
                'BRANCH_MANAGER',
                'CUSTOMER_SERVICE_SUPERVISOR',
                'NIGHT_SUPERVISORS',
                'IT_SYSTEMS_MANAGER'
            )
        )
    );
END;
$$;


--
-- Name: FUNCTION has_order_management_access(user_id uuid); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.has_order_management_access(user_id uuid) IS 'Check if user has management-level access to orders (Admin, Master Admin, CEO, Operations Manager, Branch Manager, Customer Service Supervisor, Night Supervisors, IT Systems Manager)';


--
-- Name: hash_password(text, text); Type: FUNCTION; Schema: public; Owner: -
--

