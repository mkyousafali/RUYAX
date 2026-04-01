CREATE FUNCTION public.increment_page_visit_count(offer_id uuid) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  UPDATE view_offer
  SET page_visit_count = page_visit_count + 1
  WHERE id = offer_id;
END;
$$;


--
-- Name: increment_social_link_click(bigint, text); Type: FUNCTION; Schema: public; Owner: -
--

