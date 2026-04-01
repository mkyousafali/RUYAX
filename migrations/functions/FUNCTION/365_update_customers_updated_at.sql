CREATE FUNCTION public.update_customers_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$;


--
-- Name: update_day_off_reasons_timestamp(); Type: FUNCTION; Schema: public; Owner: -
--

