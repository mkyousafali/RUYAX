CREATE FUNCTION public.update_denomination_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;


--
-- Name: update_departments_updated_at(); Type: FUNCTION; Schema: public; Owner: -
--

