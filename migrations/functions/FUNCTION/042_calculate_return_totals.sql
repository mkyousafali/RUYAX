CREATE FUNCTION public.calculate_return_totals() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- Calculate total return amount
  NEW.total_return_amount = COALESCE(NEW.expired_return_amount, 0) + 
                           COALESCE(NEW.near_expiry_return_amount, 0) + 
                           COALESCE(NEW.over_stock_return_amount, 0) + 
                           COALESCE(NEW.damage_return_amount, 0);
  
  -- Calculate final bill amount
  NEW.final_bill_amount = COALESCE(NEW.bill_amount, 0) - NEW.total_return_amount;
  
  RETURN NEW;
END;
$$;


--
-- Name: calculate_schedule_details(); Type: FUNCTION; Schema: public; Owner: -
--

