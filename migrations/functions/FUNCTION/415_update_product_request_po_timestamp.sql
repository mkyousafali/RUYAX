CREATE FUNCTION public.update_product_request_po_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$;


--
-- Name: update_product_request_st_timestamp(); Type: FUNCTION; Schema: public; Owner: -
--

