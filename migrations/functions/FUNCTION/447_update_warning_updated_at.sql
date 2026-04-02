CREATE FUNCTION public.update_warning_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$;


--
-- Name: update_warning_violation_timestamp(); Type: FUNCTION; Schema: public; Owner: -
--

