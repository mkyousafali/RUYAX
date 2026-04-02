CREATE FUNCTION public.update_notification_queue_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$;


--
-- Name: update_notification_read_count(); Type: FUNCTION; Schema: public; Owner: -
--

