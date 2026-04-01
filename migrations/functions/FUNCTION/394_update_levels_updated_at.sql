CREATE FUNCTION public.update_levels_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;


--
-- Name: update_main_document_columns(); Type: FUNCTION; Schema: public; Owner: -
--

