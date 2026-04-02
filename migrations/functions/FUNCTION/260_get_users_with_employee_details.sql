CREATE FUNCTION public.get_users_with_employee_details() RETURNS TABLE(id uuid, username character varying, email character varying, role_type character varying, status character varying, employee_id uuid, employee_name character varying, employee_code character varying, employee_status character varying, department_name character varying, position_title character varying, branch_name character varying, created_at timestamp with time zone, updated_at timestamp with time zone)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        u.id,
        u.username,
        ''::VARCHAR as email,
        -- Use admin flags instead of role_type column
        CASE 
            WHEN u.is_master_admin THEN 'Master Admin'::VARCHAR
            WHEN u.is_admin THEN 'Admin'::VARCHAR
            ELSE 'User'::VARCHAR
        END as role_type,
        COALESCE(u.status::VARCHAR, 'active') as status,
        u.employee_id,
        COALESCE(e.name, u.username)::VARCHAR as employee_name,
        COALESCE(e.employee_id, '')::VARCHAR as employee_code,
        COALESCE(e.status, 'active')::VARCHAR as employee_status,
        COALESCE(d.department_name_en, 'No Department')::VARCHAR as department_name,
        COALESCE(p.position_title_en, 'No Position')::VARCHAR as position_title,
        COALESCE(b.name_en, 'No Branch')::VARCHAR as branch_name,
        u.created_at,
        u.updated_at
    FROM users u
    LEFT JOIN hr_employees e ON u.employee_id = e.id
    LEFT JOIN branches b ON u.branch_id = b.id
    LEFT JOIN hr_positions p ON u.position_id = p.id
    LEFT JOIN hr_departments d ON p.department_id = d.id
    WHERE u.status = 'active'
    ORDER BY u.created_at DESC;
END;
$$;


--
-- Name: get_variation_group_info(text); Type: FUNCTION; Schema: public; Owner: -
--

