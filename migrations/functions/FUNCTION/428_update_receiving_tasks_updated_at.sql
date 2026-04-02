CREATE FUNCTION public.update_receiving_tasks_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$;


--
-- Name: update_receiving_user_defaults_timestamp(); Type: FUNCTION; Schema: public; Owner: -
--

