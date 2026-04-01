CREATE FUNCTION public.increment_view_button_count(offer_id uuid) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  UPDATE view_offer
  SET view_button_count = view_button_count + 1
  WHERE id = offer_id;
END;
$$;


--
-- Name: insert_order_items(jsonb); Type: FUNCTION; Schema: public; Owner: -
--

