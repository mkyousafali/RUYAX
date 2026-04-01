CREATE FUNCTION public.generate_campaign_code() RETURNS character varying
    LANGUAGE plpgsql
    AS $$
DECLARE
  new_code VARCHAR(8);
  code_exists BOOLEAN;
BEGIN
  LOOP
    -- Generate 8 character alphanumeric code
    new_code := upper(substring(md5(random()::text || clock_timestamp()::text) from 1 for 8));
    
    -- Check if code already exists
    SELECT EXISTS(SELECT 1 FROM coupon_campaigns WHERE campaign_code = new_code)
    INTO code_exists;
    
    EXIT WHEN NOT code_exists;
  END LOOP;
  
  RETURN new_code;
END;
$$;


--
-- Name: generate_clearance_certificate_tasks(uuid, text, text, text, text); Type: FUNCTION; Schema: public; Owner: -
--

