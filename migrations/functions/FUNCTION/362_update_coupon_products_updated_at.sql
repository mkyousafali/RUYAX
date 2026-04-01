CREATE FUNCTION public.update_coupon_products_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;


--
-- Name: update_customer_app_media_timestamp(); Type: FUNCTION; Schema: public; Owner: -
--

