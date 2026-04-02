CREATE FUNCTION public.generate_order_number() RETURNS character varying
    LANGUAGE plpgsql
    AS $$
DECLARE
    new_order_number VARCHAR(50);
    counter INTEGER;
BEGIN
    -- Format: ORD-YYYYMMDD-XXXX
    SELECT COUNT(*) + 1 INTO counter
    FROM orders
    WHERE DATE(created_at) = CURRENT_DATE;
    
    new_order_number := 'ORD-' || TO_CHAR(CURRENT_DATE, 'YYYYMMDD') || '-' || LPAD(counter::TEXT, 4, '0');
    
    RETURN new_order_number;
END;
$$;


--
-- Name: FUNCTION generate_order_number(); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.generate_order_number() IS 'Generates unique order number in format ORD-YYYYMMDD-XXXX';


--
-- Name: generate_recurring_occurrences(integer, text); Type: FUNCTION; Schema: public; Owner: -
--

