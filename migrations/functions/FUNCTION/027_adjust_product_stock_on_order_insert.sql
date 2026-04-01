CREATE FUNCTION public.adjust_product_stock_on_order_insert() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    current_quantity INTEGER;
BEGIN
    -- Validate that product_id exists
    IF NEW.product_id IS NULL THEN
        RAISE EXCEPTION 'product_id is required';
    END IF;

    -- Get current stock
    SELECT current_stock INTO current_quantity 
    FROM products 
    WHERE id = NEW.product_id;

    -- If product not found, raise error
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Product with id % does not exist', NEW.product_id;
    END IF;

    -- Decrease stock
    UPDATE products 
    SET current_stock = current_stock - NEW.quantity,
        updated_at = NOW()
    WHERE id = NEW.product_id;

    RAISE NOTICE 'Product % stock decreased by %. New stock: %', 
        NEW.product_id, NEW.quantity, (current_quantity - NEW.quantity);

    RETURN NEW;
END;
$$;


--
-- Name: approve_customer_account(uuid, text, text, uuid); Type: FUNCTION; Schema: public; Owner: -
--

