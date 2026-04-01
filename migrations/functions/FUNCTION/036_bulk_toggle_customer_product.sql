CREATE FUNCTION public.bulk_toggle_customer_product(p_barcodes text[], p_value boolean) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
    v_count INTEGER;
BEGIN
    UPDATE products
    SET is_customer_product = p_value
    WHERE barcode = ANY(p_barcodes);

    GET DIAGNOSTICS v_count = ROW_COUNT;

    RETURN json_build_object(
        'success', true,
        'updated_count', v_count
    );
END;
$$;


--
-- Name: calculate_category_days(); Type: FUNCTION; Schema: public; Owner: -
--

