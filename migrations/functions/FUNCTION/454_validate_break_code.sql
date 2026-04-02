CREATE FUNCTION public.validate_break_code(p_code text) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
    v_seed text;
    v_epoch bigint;
    v_current_code text;
    v_previous_code text;
BEGIN
    SELECT seed INTO v_seed FROM break_security_seed WHERE id = 1;
    
    IF v_seed IS NULL THEN
        RETURN false;
    END IF;
    
    v_epoch := floor(extract(epoch from now()) / 10)::bigint;
    
    -- Current 10-sec window code
    v_current_code := substring(md5(v_seed || v_epoch::text) from 1 for 12);
    
    -- Previous 10-sec window code (for network delay tolerance)
    v_previous_code := substring(md5(v_seed || (v_epoch - 1)::text) from 1 for 12);
    
    RETURN (p_code = v_current_code OR p_code = v_previous_code);
END;
$$;


--
-- Name: validate_bundle_offer_type(); Type: FUNCTION; Schema: public; Owner: -
--

