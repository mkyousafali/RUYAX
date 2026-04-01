CREATE FUNCTION public.update_lease_rent_rent_parties_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$;


--
-- Name: update_levels_updated_at(); Type: FUNCTION; Schema: public; Owner: -
--

