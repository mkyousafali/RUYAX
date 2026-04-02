CREATE FUNCTION public.generate_unique_quick_access_code() RETURNS character varying
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
  v_code VARCHAR(6);
BEGIN
  LOOP
    v_code := LPAD(FLOOR(RANDOM() * 1000000)::TEXT, 6, '0');
    EXIT WHEN NOT EXISTS (
      SELECT 1 FROM users
      WHERE extensions.crypt(v_code, quick_access_code) = quick_access_code
    );
  END LOOP;
  RETURN v_code;
END;
$$;


--
-- Name: generate_warning_reference(); Type: FUNCTION; Schema: public; Owner: -
--

