CREATE FUNCTION public.get_employee_basic_hours(p_employee_id bigint) RETURNS numeric
    LANGUAGE plpgsql
    AS $$
DECLARE
    emp_basic_hours DECIMAL(4,2);
BEGIN
    SELECT basic_hours INTO emp_basic_hours
    FROM employee_basic_hours 
    WHERE employee_id = p_employee_id;
    
    -- Return employee-specific hours or default to 8.0
    RETURN COALESCE(emp_basic_hours, 8.0);
END;
$$;


--
-- Name: get_employee_basic_hours(uuid, date); Type: FUNCTION; Schema: public; Owner: -
--

