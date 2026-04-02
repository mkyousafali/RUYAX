CREATE FUNCTION public.generate_unique_customer_access_code() RETURNS text
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_access_code text;
    code_exists boolean;
    attempts integer := 0;
    max_attempts integer := 100;
BEGIN
    LOOP
        v_access_code := LPAD(FLOOR(random() * 1000000)::text, 6, '0');
        SELECT EXISTS(
            SELECT 1 FROM public.customers c
            WHERE c.access_code = encode(extensions.digest(v_access_code::bytea, 'sha256'), 'hex')
        ) INTO code_exists;
        IF NOT code_exists THEN
            RETURN v_access_code;
        END IF;
        attempts := attempts + 1;
        IF attempts >= max_attempts THEN
            RAISE EXCEPTION 'Unable to generate unique access code after % attempts', max_attempts;
        END IF;
    END LOOP;
END;
$$;


--
-- Name: generate_unique_quick_access_code(); Type: FUNCTION; Schema: public; Owner: -
--

