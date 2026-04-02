CREATE FUNCTION public.sync_employee_with_hr(p_employee_id uuid) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    -- Update user information based on employee record
    UPDATE users u
    SET 
        updated_at = NOW()
    FROM hr_employees e
    WHERE u.employee_id = e.id
      AND e.id = p_employee_id;
    
    RETURN FOUND;
END;
$$;


--
-- Name: sync_erp_reference_for_receiving_record(uuid); Type: FUNCTION; Schema: public; Owner: -
--

