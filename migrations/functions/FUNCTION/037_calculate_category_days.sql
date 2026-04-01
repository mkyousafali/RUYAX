CREATE FUNCTION public.calculate_category_days() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Auto-calculate days for leave categories
    IF NEW.document_category IN ('sick_leave', 'special_leave', 'annual_leave') 
       AND NEW.category_start_date IS NOT NULL 
       AND NEW.category_end_date IS NOT NULL THEN
        NEW.category_days := NEW.category_end_date - NEW.category_start_date + 1;
    END IF;
    
    RETURN NEW;
END;
$$;


--
-- Name: calculate_flyer_product_profit(); Type: FUNCTION; Schema: public; Owner: -
--

