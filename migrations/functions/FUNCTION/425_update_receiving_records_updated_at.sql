CREATE FUNCTION public.update_receiving_records_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$;


--
-- Name: update_receiving_task_completion(uuid, character varying, boolean, text); Type: FUNCTION; Schema: public; Owner: -
--

