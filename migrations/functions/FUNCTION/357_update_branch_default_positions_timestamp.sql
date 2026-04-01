CREATE FUNCTION public.update_branch_default_positions_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$;


--
-- Name: update_branch_delivery_receivers_updated_at(); Type: FUNCTION; Schema: public; Owner: -
--

