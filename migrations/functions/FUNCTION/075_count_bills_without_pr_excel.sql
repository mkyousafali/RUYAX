CREATE FUNCTION public.count_bills_without_pr_excel() RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN (
        SELECT COUNT(*)
        FROM receiving_records
        WHERE pr_excel_file_url IS NULL 
           OR pr_excel_file_url = ''
    );
END;
$$;


--
-- Name: count_bills_without_pr_excel_by_branch(bigint); Type: FUNCTION; Schema: public; Owner: -
--

