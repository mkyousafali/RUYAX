CREATE FUNCTION public.update_final_bill_amount_on_adjustment() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- Only recalculate if there are actual adjustments (discount, GRR, or PRI)
  -- This prevents the trigger from interfering with split payments
  IF (COALESCE(NEW.discount_amount, 0) > 0 OR 
      COALESCE(NEW.grr_amount, 0) > 0 OR 
      COALESCE(NEW.pri_amount, 0) > 0) THEN
    
    DECLARE
      base_amount DECIMAL(15, 2);
    BEGIN
      -- Determine the base amount to deduct from
      base_amount := COALESCE(NEW.original_final_amount, NEW.bill_amount);
      
      -- Calculate new final_bill_amount by deducting discount, GRR, and PRI amounts
      NEW.final_bill_amount := base_amount - 
        COALESCE(NEW.discount_amount, 0) - 
        COALESCE(NEW.grr_amount, 0) - 
        COALESCE(NEW.pri_amount, 0);
    END;
  END IF;
  
  RETURN NEW;
END;
$$;


--
-- Name: update_flyer_templates_updated_at(); Type: FUNCTION; Schema: public; Owner: -
--

