CREATE FUNCTION public.link_finger_transaction_to_employee(p_employee_code character varying, p_branch_id uuid) RETURNS uuid
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_employee_id UUID;
BEGIN
    -- Find employee by employee_code and branch
    SELECT e.id INTO v_employee_id
    FROM public.employees e
    WHERE e.employee_id = p_employee_code
    AND e.branch_id = p_branch_id
    AND e.status = 'active';
    
    RETURN v_employee_id;
END;
$$;


--
-- Name: log_offer_usage(integer, uuid, integer, numeric, numeric, numeric, jsonb); Type: FUNCTION; Schema: public; Owner: -
--

