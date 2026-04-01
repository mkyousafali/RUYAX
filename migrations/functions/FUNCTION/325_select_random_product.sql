CREATE FUNCTION public.select_random_product(p_campaign_id uuid) RETURNS TABLE(id uuid, product_name_en character varying, product_name_ar character varying, product_image_url text, original_price numeric, offer_price numeric, special_barcode character varying, stock_remaining integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT 
    p.id,
    p.product_name_en,
    p.product_name_ar,
    p.product_image_url,
    p.original_price,
    p.offer_price,
    p.special_barcode,
    p.stock_remaining
  FROM coupon_products p
  WHERE p.campaign_id = p_campaign_id
    AND p.is_active = true
    AND p.stock_remaining > 0
    AND p.deleted_at IS NULL
  ORDER BY RANDOM()
  LIMIT 1
  FOR UPDATE SKIP LOCKED;
END;
$$;


--
-- Name: send_order_notification(uuid, text, text, text, text, uuid, uuid); Type: FUNCTION; Schema: public; Owner: -
--

