CREATE FUNCTION public.validate_bundle_offer_type() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_offer_type VARCHAR;
BEGIN
    -- Get the offer type
    SELECT type INTO v_offer_type FROM offers WHERE id = NEW.offer_id;
    
    IF v_offer_type IS NULL THEN
        RAISE EXCEPTION 'Offer with id % does not exist', NEW.offer_id;
    END IF;
    
    IF v_offer_type != 'bundle' THEN
        RAISE EXCEPTION 'Offer with id % must be of type "bundle" but is "%"', NEW.offer_id, v_offer_type;
    END IF;
    
    RETURN NEW;
END;
$$;


--
-- Name: validate_coupon_eligibility(character varying, character varying); Type: FUNCTION; Schema: public; Owner: -
--

