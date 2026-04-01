CREATE FUNCTION public.get_employee_basic_hours(p_employee_id uuid, p_date date DEFAULT CURRENT_DATE) RETURNS numeric
    LANGUAGE plpgsql
    AS $$
DECLARE
    basic_hours DECIMAL(4,2);
BEGIN
    SELECT ebh.basic_hours_per_day
    INTO basic_hours
    FROM employee_basic_hours ebh
    WHERE ebh.employee_id = p_employee_id
      AND ebh.is_active = true
      AND p_date >= ebh.effective_from
      AND (ebh.effective_to IS NULL OR p_date <= ebh.effective_to)
    ORDER BY ebh.effective_from DESC
    LIMIT 1;
    
    RETURN COALESCE(basic_hours, 8.0); -- Default to 8 hours if not configured
END;
$$;


--
-- Name: get_employee_document_category_stats(uuid); Type: FUNCTION; Schema: public; Owner: -
--

