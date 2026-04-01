CREATE FUNCTION public.count_bills_without_pr_excel_by_branch(branch_id_param bigint DEFAULT NULL::bigint) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    result_count INTEGER;
BEGIN
    IF branch_id_param IS NULL THEN
        -- If no branch specified, return all
        SELECT COUNT(*) INTO result_count
        FROM receiving_records
        WHERE pr_excel_file_url IS NULL OR pr_excel_file_url = '';
    ELSE
        -- Count for specific branch
        SELECT COUNT(*) INTO result_count
        FROM receiving_records
        WHERE (pr_excel_file_url IS NULL OR pr_excel_file_url = '')
        AND branch_id = branch_id_param;
    END IF;
    
    RETURN COALESCE(result_count, 0);
END;
$$;


--
-- Name: FUNCTION count_bills_without_pr_excel_by_branch(branch_id_param bigint); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.count_bills_without_pr_excel_by_branch(branch_id_param bigint) IS 'Counts receiving records without PR Excel file, optionally filtered by branch';


--
-- Name: count_completed_receiving_tasks(); Type: FUNCTION; Schema: public; Owner: -
--

