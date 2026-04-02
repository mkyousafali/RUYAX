CREATE FUNCTION public.update_deadline_datetime() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.deadline_date IS NOT NULL THEN
        NEW.deadline_datetime = (NEW.deadline_date || ' ' || COALESCE(NEW.deadline_time::text, '23:59:59'))::timestamp with time zone;
    ELSE
        NEW.deadline_datetime = NULL;
    END IF;
    RETURN NEW;
END;
$$;


--
-- Name: update_delivery_tiers_timestamp(); Type: FUNCTION; Schema: public; Owner: -
--

