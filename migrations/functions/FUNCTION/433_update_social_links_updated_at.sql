CREATE FUNCTION public.update_social_links_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$;


--
-- Name: update_special_shift_date_wise_timestamp(); Type: FUNCTION; Schema: public; Owner: -
--

