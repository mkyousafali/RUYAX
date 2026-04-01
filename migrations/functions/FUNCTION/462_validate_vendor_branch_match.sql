CREATE FUNCTION public.validate_vendor_branch_match() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Check if vendor belongs to the selected branch or is unassigned
    IF NOT EXISTS (
        SELECT 1 FROM vendors 
        WHERE erp_vendor_id = NEW.vendor_id 
        AND (branch_id = NEW.branch_id OR branch_id IS NULL)
    ) THEN
        RAISE EXCEPTION 'Vendor % does not belong to branch % or is not assigned to any branch', 
            NEW.vendor_id, NEW.branch_id;
    END IF;
    
    RETURN NEW;
END;
$$;


--
-- Name: FUNCTION validate_vendor_branch_match(); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.validate_vendor_branch_match() IS 'Validates that vendor belongs to the branch specified in receiving record';


--
-- Name: verify_otp_and_change_access_code(character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: -
--

