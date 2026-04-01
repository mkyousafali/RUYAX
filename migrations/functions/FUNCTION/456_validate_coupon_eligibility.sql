CREATE FUNCTION public.validate_coupon_eligibility(p_campaign_code character varying, p_mobile_number character varying) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_campaign_id UUID;
  v_campaign_name VARCHAR;
  v_is_active BOOLEAN;
  v_validity_start TIMESTAMP WITH TIME ZONE;
  v_validity_end TIMESTAMP WITH TIME ZONE;
  v_max_claims_per_customer INTEGER;
  v_is_eligible BOOLEAN;
  v_current_claim_count INTEGER;
BEGIN
  -- Get campaign details
  SELECT 
    id, 
    campaign_name, 
    is_active,
    validity_start_date,
    validity_end_date,
    COALESCE(max_claims_per_customer, 1)
  INTO 
    v_campaign_id,
    v_campaign_name,
    v_is_active,
    v_validity_start,
    v_validity_end,
    v_max_claims_per_customer
  FROM coupon_campaigns
  WHERE campaign_code = p_campaign_code
    AND deleted_at IS NULL;
  
  -- Check if campaign exists
  IF v_campaign_id IS NULL THEN
    RETURN jsonb_build_object(
      'eligible', false,
      'error_message', 'Campaign code not found'
    );
  END IF;
  
  -- Check if campaign is active
  IF NOT v_is_active THEN
    RETURN jsonb_build_object(
      'eligible', false,
      'error_message', 'Campaign is not active'
    );
  END IF;
  
  -- Check if within validity period
  IF now() < v_validity_start OR now() > v_validity_end THEN
    RETURN jsonb_build_object(
      'eligible', false,
      'error_message', 'Campaign is not valid at this time'
    );
  END IF;
  
  -- Check if customer is in eligible list
  SELECT EXISTS(
    SELECT 1 
    FROM coupon_eligible_customers
    WHERE campaign_id = v_campaign_id
      AND mobile_number = p_mobile_number
  ) INTO v_is_eligible;
  
  IF NOT v_is_eligible THEN
    RETURN jsonb_build_object(
      'eligible', false,
      'error_message', 'Customer is not eligible for this campaign'
    );
  END IF;
  
  -- Count current claims
  SELECT COUNT(*)
  INTO v_current_claim_count
  FROM coupon_claims
  WHERE campaign_id = v_campaign_id
    AND customer_mobile = p_mobile_number;
  
  -- Check if reached maximum claims
  IF v_current_claim_count >= v_max_claims_per_customer THEN
    RETURN jsonb_build_object(
      'eligible', false,
      'already_claimed', true,
      'current_claims', v_current_claim_count,
      'max_claims', v_max_claims_per_customer,
      'error_message', 'Customer has reached the maximum number of claims (' || v_current_claim_count || '/' || v_max_claims_per_customer || ')'
    );
  END IF;
  
  -- All checks passed
  RETURN jsonb_build_object(
    'eligible', true,
    'campaign_id', v_campaign_id,
    'campaign_name', v_campaign_name,
    'already_claimed', false,
    'current_claims', v_current_claim_count,
    'max_claims', v_max_claims_per_customer,
    'remaining_claims', v_max_claims_per_customer - v_current_claim_count
  );
END;
$$;


--
-- Name: validate_flyer_template_configuration(jsonb); Type: FUNCTION; Schema: public; Owner: -
--

