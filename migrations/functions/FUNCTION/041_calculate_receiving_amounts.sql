CREATE FUNCTION public.calculate_receiving_amounts() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Calculate total_return_amount
    NEW.total_return_amount := 
        COALESCE(NEW.expired_return_amount, 0) +
        COALESCE(NEW.near_expiry_return_amount, 0) +
        COALESCE(NEW.over_stock_return_amount, 0) +
        COALESCE(NEW.damage_return_amount, 0);
    
    -- Calculate final_bill_amount (bill_amount - total_return_amount)
    NEW.final_bill_amount := NEW.bill_amount - NEW.total_return_amount;
    
    -- Ensure final amount is not negative
    IF NEW.final_bill_amount < 0 THEN
        NEW.final_bill_amount := 0;
    END IF;
    
    RETURN NEW;
END;
$$;


--
-- Name: calculate_return_totals(); Type: FUNCTION; Schema: public; Owner: -
--

