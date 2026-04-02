CREATE FUNCTION public.calculate_flyer_product_profit() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- Calculate profit amount
  NEW.profit := NEW.sale_price - NEW.cost;
  
  -- Calculate profit percentage
  IF NEW.cost > 0 THEN
    NEW.profit_percentage := ((NEW.sale_price - NEW.cost) / NEW.cost) * 100;
  ELSE
    NEW.profit_percentage := 0;
  END IF;
  
  RETURN NEW;
END;
$$;


--
-- Name: calculate_next_visit_date(text, text, text, integer, integer, date, date); Type: FUNCTION; Schema: public; Owner: -
--

