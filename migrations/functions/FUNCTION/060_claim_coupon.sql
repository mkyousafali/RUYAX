CREATE FUNCTION public.claim_coupon(p_campaign_id uuid, p_mobile_number character varying, p_product_id uuid, p_branch_id bigint, p_user_id uuid) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_claim_id UUID;
  v_product_details JSONB;
  v_stock_remaining INTEGER;
  v_max_claims_per_customer INTEGER;
  v_current_claim_count INTEGER;
BEGIN
  -- Get max claims per customer for this campaign
  SELECT COALESCE(max_claims_per_customer, 1)
  INTO v_max_claims_per_customer
  FROM coupon_campaigns
  WHERE id = p_campaign_id;
  
  -- Count current claims
  SELECT COUNT(*)
  INTO v_current_claim_count
  FROM coupon_claims
  WHERE campaign_id = p_campaign_id
    AND customer_mobile = p_mobile_number;
  
  -- Check if reached maximum claims
  IF v_current_claim_count >= v_max_claims_per_customer THEN
    RETURN jsonb_build_object(
      'success', false,
      'error_message', 'Customer has already claimed ' || v_current_claim_count || ' time(s). Maximum allowed: ' || v_max_claims_per_customer
    );
  END IF;
  
  -- Check product stock
  SELECT stock_remaining INTO v_stock_remaining
  FROM coupon_products
  WHERE id = p_product_id
    AND is_active = true
    AND deleted_at IS NULL
  FOR UPDATE;
  
  IF v_stock_remaining IS NULL OR v_stock_remaining <= 0 THEN
    RETURN jsonb_build_object(
      'success', false,
      'error_message', 'Product is out of stock'
    );
  END IF;
  
  -- Insert claim record
  INSERT INTO coupon_claims (
    campaign_id,
    customer_mobile,
    product_id,
    branch_id,
    claimed_by_user,
    validity_date,
    status
  ) VALUES (
    p_campaign_id,
    p_mobile_number,
    p_product_id,
    p_branch_id,
    p_user_id,
    CURRENT_DATE,
    'claimed'
  )
  RETURNING id INTO v_claim_id;
  
  -- Decrement stock
  UPDATE coupon_products
  SET 
    stock_remaining = stock_remaining - 1,
    updated_at = now()
  WHERE id = p_product_id;
  
  -- Get product details for receipt
  SELECT jsonb_build_object(
    'product_id', id,
    'product_name_en', product_name_en,
    'product_name_ar', product_name_ar,
    'product_image_url', product_image_url,
    'original_price', original_price,
    'offer_price', offer_price,
    'special_barcode', special_barcode,
    'savings', (original_price - offer_price)
  )
  INTO v_product_details
  FROM coupon_products
  WHERE id = p_product_id;
  
  -- Return success with details
  RETURN jsonb_build_object(
    'success', true,
    'claim_id', v_claim_id,
    'product_details', v_product_details,
    'validity_date', CURRENT_DATE,
    'current_claims', v_current_claim_count + 1,
    'remaining_claims', v_max_claims_per_customer - v_current_claim_count - 1
  );
END;
$$;


--
-- Name: cleanup_expired_otps(); Type: FUNCTION; Schema: public; Owner: -
--

