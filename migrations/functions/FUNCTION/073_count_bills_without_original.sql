CREATE FUNCTION public.count_bills_without_original() RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
    no_original_count INTEGER;
BEGIN
    -- Count receiving records where original_bill_url is NULL or empty
    SELECT COUNT(*) INTO no_original_count
    FROM receiving_records rr
    WHERE rr.original_bill_url IS NULL 
    OR rr.original_bill_url = ''
    OR TRIM(rr.original_bill_url) = '';
    
    RETURN COALESCE(no_original_count, 0);
END;
$$;


--
-- Name: count_bills_without_original_by_branch(bigint); Type: FUNCTION; Schema: public; Owner: -
--

