CREATE FUNCTION public.update_customer_app_media_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;


--
-- Name: update_customer_recovery_requests_updated_at(); Type: FUNCTION; Schema: public; Owner: -
--

