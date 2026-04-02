CREATE FUNCTION public.hash_password(password text, salt text) RETURNS text
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN crypt(password, salt);
END;
$$;


--
-- Name: import_sync_batch(text, jsonb); Type: FUNCTION; Schema: public; Owner: -
--

