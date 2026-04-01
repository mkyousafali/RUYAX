CREATE FUNCTION public.generate_salt() RETURNS text
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN gen_salt('bf', 8);
END;
$$;


--
-- Name: generate_unique_customer_access_code(); Type: FUNCTION; Schema: public; Owner: -
--

