CREATE FUNCTION public.is_quick_access_code_available(p_quick_access_code text) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
BEGIN
    -- Validate format first
    IF LENGTH(p_quick_access_code) != 6 OR p_quick_access_code !~ '^[0-9]{6}$' THEN
        RETURN false;
    END IF;
    
    -- Check if code exists
    RETURN NOT EXISTS (SELECT 1 FROM users WHERE quick_access_code = p_quick_access_code);
END;
$_$;


--
-- Name: is_quick_access_code_available(character varying); Type: FUNCTION; Schema: public; Owner: -
--

