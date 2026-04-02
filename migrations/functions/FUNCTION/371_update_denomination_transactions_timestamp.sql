CREATE FUNCTION public.update_denomination_transactions_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$;


--
-- Name: update_denomination_updated_at(); Type: FUNCTION; Schema: public; Owner: -
--

