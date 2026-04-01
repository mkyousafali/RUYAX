CREATE FUNCTION public.authenticate_customer_access_code(p_access_code text) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public', 'extensions'
    AS $$
DECLARE
    v_customer record;
    v_hashed_code text;
BEGIN
    v_hashed_code := encode(digest(p_access_code::bytea, 'sha256'), 'hex');

    SELECT id, name, whatsapp_number, registration_status
    INTO v_customer
    FROM public.customers
    WHERE access_code = v_hashed_code
    LIMIT 1;

    IF v_customer.id IS NULL THEN
        RETURN jsonb_build_object(
            'success', false,
            'error', 'Invalid access code. Please check and try again.'
        );
    END IF;

    IF v_customer.registration_status = 'deleted' THEN
        RETURN jsonb_build_object(
            'success', false,
            'error', 'ACCOUNT_DELETED',
            'message', 'This account has been deleted. Please register again.'
        );
    END IF;

    IF v_customer.registration_status != 'approved' THEN
        RETURN jsonb_build_object(
            'success', false,
            'error', 'Your account is pending approval. Please wait for admin confirmation.'
        );
    END IF;

    RETURN jsonb_build_object(
        'success', true,
        'customer_id', v_customer.id,
        'customer_name', v_customer.name,
        'whatsapp_number', v_customer.whatsapp_number,
        'registration_status', v_customer.registration_status
    );
END;
$$;


--
-- Name: auto_create_payment_schedule(); Type: FUNCTION; Schema: public; Owner: -
--

