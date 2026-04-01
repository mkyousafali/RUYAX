CREATE FUNCTION public.decrement_voucher_stock(voucher_value numeric, decrement_amount integer DEFAULT 1) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    UPDATE purchase_voucher_stock
    SET quantity = quantity - decrement_amount,
        updated_at = NOW()
    WHERE value = voucher_value
      AND quantity >= decrement_amount;
    
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Insufficient stock for voucher value %', voucher_value;
    END IF;
END;
$$;


--
-- Name: delete_app_icon(text); Type: FUNCTION; Schema: public; Owner: -
--

