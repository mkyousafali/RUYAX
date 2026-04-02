CREATE FUNCTION public.update_purchase_vouchers_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$;


--
-- Name: update_push_subscriptions_updated_at(); Type: FUNCTION; Schema: public; Owner: -
--

