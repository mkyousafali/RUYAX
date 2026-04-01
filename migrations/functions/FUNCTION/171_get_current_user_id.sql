CREATE FUNCTION public.get_current_user_id() RETURNS uuid
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  RETURN current_setting('app.current_user_id', true)::UUID;
EXCEPTION
  WHEN OTHERS THEN
    RETURN NULL;
END;
$$;


--
-- Name: get_customer_products_with_offers(text, text); Type: FUNCTION; Schema: public; Owner: -
--

