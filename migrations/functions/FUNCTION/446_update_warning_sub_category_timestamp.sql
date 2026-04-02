CREATE FUNCTION public.update_warning_sub_category_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$;


--
-- Name: update_warning_updated_at(); Type: FUNCTION; Schema: public; Owner: -
--

