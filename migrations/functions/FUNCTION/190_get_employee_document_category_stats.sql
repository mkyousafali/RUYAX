CREATE FUNCTION public.get_employee_document_category_stats(emp_id uuid) RETURNS TABLE(category public.document_category_enum, count bigint, total_days integer, latest_date timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        d.document_category::document_category_enum,
        COUNT(*)::BIGINT,
        SUM(COALESCE(d.category_days, 0))::INTEGER,
        MAX(d.upload_date)
    FROM hr_employee_documents d
    WHERE d.employee_id = emp_id 
      AND d.is_active = true 
      AND d.document_category IS NOT NULL
    GROUP BY d.document_category;
END;
$$;


--
-- Name: get_employee_products(text, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

