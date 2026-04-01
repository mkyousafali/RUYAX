CREATE FUNCTION public.update_delivery_tiers_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$;


--
-- Name: update_denomination_transactions_timestamp(); Type: FUNCTION; Schema: public; Owner: -
--

