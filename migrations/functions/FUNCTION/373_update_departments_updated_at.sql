CREATE FUNCTION public.update_departments_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;


--
-- Name: update_desktop_themes_timestamp(); Type: FUNCTION; Schema: public; Owner: -
--

