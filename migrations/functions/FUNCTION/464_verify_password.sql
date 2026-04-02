CREATE FUNCTION public.verify_password(password text, hash text) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN hash = crypt(password, hash);
END;
$$;


--
-- Name: verify_password(character varying, character varying); Type: FUNCTION; Schema: public; Owner: -
--

