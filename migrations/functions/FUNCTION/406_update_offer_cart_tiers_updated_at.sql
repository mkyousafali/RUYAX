CREATE FUNCTION public.update_offer_cart_tiers_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;


--
-- Name: update_offers_updated_at(); Type: FUNCTION; Schema: public; Owner: -
--

