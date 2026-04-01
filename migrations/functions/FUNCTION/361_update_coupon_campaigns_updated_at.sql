CREATE FUNCTION public.update_coupon_campaigns_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;


--
-- Name: update_coupon_products_updated_at(); Type: FUNCTION; Schema: public; Owner: -
--

