CREATE FUNCTION public.validate_payment_methods(payment_methods text) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
    valid_methods TEXT[] := ARRAY['Cash on Delivery', 'Bank on Delivery', 'Cash Credit', 'Bank Credit'];
    method TEXT;
    methods TEXT[];
BEGIN
    IF payment_methods IS NULL OR LENGTH(TRIM(payment_methods)) = 0 THEN
        RETURN TRUE;
    END IF;
    
    -- Split comma-separated values
    methods := string_to_array(payment_methods, ',');
    
    -- Check each method
    FOREACH method IN ARRAY methods
    LOOP
        IF TRIM(method) != ANY(valid_methods) THEN
            RETURN FALSE;
        END IF;
    END LOOP;
    
    RETURN TRUE;
END;
$$;


--
-- Name: validate_product_offer(integer, uuid, integer); Type: FUNCTION; Schema: public; Owner: -
--

