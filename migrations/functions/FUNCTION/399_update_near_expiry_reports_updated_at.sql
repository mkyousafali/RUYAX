CREATE FUNCTION public.update_near_expiry_reports_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$;


--
-- Name: update_next_visit_date(uuid); Type: FUNCTION; Schema: public; Owner: -
--

