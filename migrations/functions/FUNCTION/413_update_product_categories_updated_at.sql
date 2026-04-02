CREATE FUNCTION public.update_product_categories_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;


--
-- Name: update_product_request_bt_timestamp(); Type: FUNCTION; Schema: public; Owner: -
--

