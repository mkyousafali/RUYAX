CREATE FUNCTION public.update_bank_reconciliations_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$;


--
-- Name: update_bogo_offer_rules_updated_at(); Type: FUNCTION; Schema: public; Owner: -
--

