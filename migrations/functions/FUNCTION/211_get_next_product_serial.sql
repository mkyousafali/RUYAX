CREATE FUNCTION public.get_next_product_serial() RETURNS text
    LANGUAGE plpgsql
    AS $_$
DECLARE
    next_number INTEGER;
    next_serial TEXT;
BEGIN
    -- Get the highest serial number
    SELECT COALESCE(
        MAX(CAST(SUBSTRING(product_serial FROM 3) AS INTEGER)),
        0
    ) + 1 INTO next_number
    FROM products
    WHERE product_serial ~ '^UR[0-9]+$';
    
    -- Format as UR0001, UR0002, etc.
    next_serial := 'UR' || LPAD(next_number::TEXT, 4, '0');
    
    RETURN next_serial;
END;
$_$;


--
-- Name: get_offer_products_data(integer); Type: FUNCTION; Schema: public; Owner: -
--

