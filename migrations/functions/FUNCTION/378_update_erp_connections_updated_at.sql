CREATE FUNCTION public.update_erp_connections_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;


--
-- Name: update_erp_daily_sales_updated_at(); Type: FUNCTION; Schema: public; Owner: -
--

