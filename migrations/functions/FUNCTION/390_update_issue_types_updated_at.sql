CREATE FUNCTION public.update_issue_types_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$;


--
-- Name: update_lease_rent_lease_parties_timestamp(); Type: FUNCTION; Schema: public; Owner: -
--

