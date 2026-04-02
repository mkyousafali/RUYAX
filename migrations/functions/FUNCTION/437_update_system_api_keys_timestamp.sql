CREATE FUNCTION public.update_system_api_keys_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$;


--
-- Name: update_tax_categories_updated_at(); Type: FUNCTION; Schema: public; Owner: -
--

