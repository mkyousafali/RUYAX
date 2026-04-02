CREATE FUNCTION public.request_access_code_resend(p_whatsapp_number text) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public', 'extensions'
    AS $$
DECLARE
    v_customer record;
    v_new_access_code text;
    v_hashed_new_code text;
    v_system_user_id uuid := 'e1fdaee2-97f0-4fc1-872f-9d99c6bd684b';
BEGIN
    SELECT id, name, access_code, registration_status, whatsapp_number
    INTO v_customer
    FROM public.customers
    WHERE whatsapp_number = p_whatsapp_number
       OR whatsapp_number = '+' || p_whatsapp_number
       OR regexp_replace(whatsapp_number, '[^0-9]', '', 'g') = regexp_replace(p_whatsapp_number, '[^0-9]', '', 'g')
    LIMIT 1;
    
    IF v_customer.id IS NULL THEN
        RETURN jsonb_build_object('success', false, 'error', 'not_found',
            'message', 'No account found with this WhatsApp number.');
    END IF;
    
    IF v_customer.registration_status != 'approved' THEN
        RETURN jsonb_build_object('success', false, 'error', 'not_approved',
            'message', 'Your account is not active. Please register again or contact support.');
    END IF;
    
    -- Generate NEW code (can't retrieve hashed one)
    v_new_access_code := generate_unique_customer_access_code();
    v_hashed_new_code := encode(digest(v_new_access_code::bytea, 'sha256'), 'hex');

    UPDATE public.customers
    SET access_code = v_hashed_new_code,
        access_code_generated_at = now(),
        updated_at = now()
    WHERE id = v_customer.id;

    INSERT INTO public.customer_access_code_history (
        customer_id, old_access_code, new_access_code,
        generated_by, reason, notes
    ) VALUES (
        v_customer.id, v_customer.access_code, v_hashed_new_code,
        v_system_user_id, 'customer_request', 'Customer requested code resend (new code generated)'
    );
    
    RETURN jsonb_build_object(
        'success', true,
        'customer_id', v_customer.id,
        'access_code', v_new_access_code,
        'whatsapp_number', v_customer.whatsapp_number,
        'customer_name', v_customer.name,
        'message', 'A new access code has been sent to your WhatsApp.'
    );
END;
$$;


--
-- Name: request_new_access_code(text); Type: FUNCTION; Schema: public; Owner: -
--

