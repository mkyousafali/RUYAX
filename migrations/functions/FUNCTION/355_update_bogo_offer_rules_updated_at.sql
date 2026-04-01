CREATE FUNCTION public.update_bogo_offer_rules_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;


--
-- Name: update_box_operations_updated_at(); Type: FUNCTION; Schema: public; Owner: -
--

