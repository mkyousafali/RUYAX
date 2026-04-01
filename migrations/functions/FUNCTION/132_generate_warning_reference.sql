CREATE FUNCTION public.generate_warning_reference() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.warning_reference IS NULL OR NEW.warning_reference = '' THEN
        NEW.warning_reference = 'WRN-' || TO_CHAR(NEW.created_at, 'YYYYMMDD') || '-' || LPAD(nextval('warning_ref_seq')::text, 4, '0');
    END IF;
    RETURN NEW;
END;
$$;


--
-- Name: get_active_break(uuid); Type: FUNCTION; Schema: public; Owner: -
--

