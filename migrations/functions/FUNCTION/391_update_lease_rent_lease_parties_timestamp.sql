CREATE FUNCTION public.update_lease_rent_lease_parties_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$;


--
-- Name: update_lease_rent_property_spaces_timestamp(); Type: FUNCTION; Schema: public; Owner: -
--

