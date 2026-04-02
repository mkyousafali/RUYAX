CREATE FUNCTION public.get_break_security_code() RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
    v_seed text;
    v_epoch bigint;
    v_code text;
    v_ttl integer;
BEGIN
    SELECT seed INTO v_seed FROM break_security_seed WHERE id = 1;
    
    IF v_seed IS NULL THEN
        RETURN jsonb_build_object('error', 'No security seed configured');
    END IF;
    
    -- Current 10-second epoch
    v_epoch := floor(extract(epoch from now()) / 10)::bigint;
    
    -- Generate code: md5 of seed + epoch, take first 12 chars
    v_code := substring(md5(v_seed || v_epoch::text) from 1 for 12);
    
    -- Time remaining in this window (seconds)
    v_ttl := 10 - (extract(epoch from now())::integer % 10);
    
    RETURN jsonb_build_object(
        'code', v_code,
        'ttl', v_ttl,
        'epoch', v_epoch
    );
END;
$$;


--
-- Name: get_break_summary_all_employees(date, date, integer); Type: FUNCTION; Schema: public; Owner: -
--

