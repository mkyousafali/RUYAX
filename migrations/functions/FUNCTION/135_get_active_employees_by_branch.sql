CREATE FUNCTION public.get_active_employees_by_branch(branch_uuid uuid) RETURNS TABLE(id uuid, employee_id character varying, first_name character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        e.id,
        e.employee_id,
        e.first_name
    FROM employees e
    WHERE e.branch_id = branch_uuid 
    AND e.status = 'active'
    ORDER BY e.first_name;
END;
$$;


--
-- Name: get_active_flyer_templates(); Type: FUNCTION; Schema: public; Owner: -
--

