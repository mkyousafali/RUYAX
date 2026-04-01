CREATE FUNCTION public.get_products_in_active_offers() RETURNS TABLE(product_id uuid, offer_id integer, offer_name_en text, offer_name_ar text)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
  RETURN QUERY
  SELECT 
    op.product_id,
    o.id AS offer_id,
    o.name_en AS offer_name_en,
    o.name_ar AS offer_name_ar
  FROM offer_products op
  INNER JOIN offers o ON op.offer_id = o.id
  WHERE o.is_active = true
    AND o.type = 'product'
    AND o.start_date <= NOW()
    AND o.end_date >= NOW();
END;
$$;


--
-- Name: FUNCTION get_products_in_active_offers(); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.get_products_in_active_offers() IS 'Get all products in active product offers for admin filtering';


--
-- Name: get_purchase_voucher_manager_data(); Type: FUNCTION; Schema: public; Owner: -
--

