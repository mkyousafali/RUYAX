CREATE FUNCTION public.create_customer_registration(p_name text, p_whatsapp_number text, p_branch_id uuid DEFAULT NULL::uuid) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public', 'extensions'
    AS $$
DECLARE
    v_customer_id uuid;
    v_access_code text;
    v_hashed_code text;
    v_formatted_number text;
    v_existing_customer record;
    v_system_user_id uuid := 'e1fdaee2-97f0-4fc1-872f-9d99c6bd684b';
BEGIN
    v_formatted_number := regexp_replace(p_whatsapp_number, '[^0-9]', '', 'g');
    IF length(v_formatted_number) = 9 THEN
        v_formatted_number := '966' || v_formatted_number;
    END IF;

    SELECT id, name, registration_status, access_code
    INTO v_existing_customer
    FROM public.customers
    WHERE regexp_replace(whatsapp_number, '[^0-9]', '', 'g') = v_formatted_number
       OR whatsapp_number = v_formatted_number
       OR whatsapp_number = '+' || v_formatted_number
    LIMIT 1;

    IF v_existing_customer.id IS NOT NULL THEN
        -- Pre-registered or deleted: upgrade to approved
        IF v_existing_customer.registration_status IN ('pre_registered', 'deleted') THEN
            v_access_code := generate_unique_customer_access_code();
            v_hashed_code := encode(digest(v_access_code::bytea, 'sha256'), 'hex');

            UPDATE public.customers
            SET name = p_name,
                access_code = v_hashed_code,
                access_code_generated_at = now(),
                registration_status = 'approved',
                updated_at = now()
            WHERE id = v_existing_customer.id
            RETURNING id INTO v_customer_id;

            INSERT INTO public.customer_access_code_history (
                customer_id, old_access_code, new_access_code,
                generated_by, reason, notes
            ) VALUES (
                v_customer_id, v_existing_customer.access_code, v_hashed_code,
                v_system_user_id,
                CASE WHEN v_existing_customer.registration_status = 'deleted'
                     THEN 're_registration'
                     ELSE 'pre_registered_upgrade'
                END,
                CASE WHEN v_existing_customer.registration_status = 'deleted'
                     THEN 'Re-registration after account deletion'
                     ELSE 'Pre-registered contact completed self-registration'
                END
            );

            RETURN jsonb_build_object(
                'success', true,
                'customer_id', v_customer_id,
                'access_code', v_access_code,
                'whatsapp_number', v_formatted_number,
                'customer_name', p_name,
                'message', 'Registration successful! Your access code has been sent to your WhatsApp.'
            );
        ELSE
            -- Already exists with active status
            RETURN jsonb_build_object(
                'success', false,
                'error', 'already_exists',
                'message', 'An account with this WhatsApp number already exists.',
                'customer_name', v_existing_customer.name,
                'registration_status', v_existing_customer.registration_status
            );
        END IF;
    END IF;

    -- Brand new customer
    v_access_code := generate_unique_customer_access_code();
    v_hashed_code := encode(digest(v_access_code::bytea, 'sha256'), 'hex');

    INSERT INTO public.customers (
        name, whatsapp_number, access_code, access_code_generated_at,
        registration_status, created_at, updated_at
    ) VALUES (
        p_name, v_formatted_number, v_hashed_code, now(),
        'approved', now(), now()
    )
    RETURNING id INTO v_customer_id;

    INSERT INTO public.customer_access_code_history (
        customer_id, new_access_code,
        generated_by, reason, notes
    ) VALUES (
        v_customer_id, v_hashed_code,
        v_system_user_id, 'initial_generation', 'Auto-generated during WhatsApp registration'
    );

    RETURN jsonb_build_object(
        'success', true,
        'customer_id', v_customer_id,
        'access_code', v_access_code,
        'whatsapp_number', v_formatted_number,
        'customer_name', p_name,
        'message', 'Registration successful! Your access code has been sent to your WhatsApp.'
    );
END;
$$;


--
-- Name: create_default_auto_schedule_config(bigint, time without time zone, time without time zone); Type: FUNCTION; Schema: public; Owner: -
--

