CREATE FUNCTION public.update_customer_recovery_requests_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$;


--
-- Name: update_customers_updated_at(); Type: FUNCTION; Schema: public; Owner: -
--

