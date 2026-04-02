CREATE FUNCTION public.bulk_import_customers(p_phone_numbers text[]) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_phone text;
    v_formatted text;
    v_inserted int := 0;
    v_skipped int := 0;
    v_total int := array_length(p_phone_numbers, 1);
    v_exists boolean;
BEGIN
    IF v_total IS NULL OR v_total = 0 THEN
        RETURN jsonb_build_object(
            'success', false,
            'error', 'No phone numbers provided'
        );
    END IF;

    FOREACH v_phone IN ARRAY p_phone_numbers
    LOOP
        -- Clean and format phone number
        v_formatted := regexp_replace(v_phone, '[^0-9]', '', 'g');
        
        -- Skip empty
        IF length(v_formatted) = 0 THEN
            v_skipped := v_skipped + 1;
            CONTINUE;
        END IF;
        
        -- Ensure 966 prefix
        IF length(v_formatted) = 9 THEN
            v_formatted := '966' || v_formatted;
        ELSIF length(v_formatted) = 10 AND v_formatted LIKE '0%' THEN
            v_formatted := '966' || substring(v_formatted from 2);
        END IF;
        
        -- Check if already exists (any format)
        SELECT EXISTS(
            SELECT 1 FROM public.customers
            WHERE regexp_replace(whatsapp_number, '[^0-9]', '', 'g') = v_formatted
               OR whatsapp_number = v_formatted
               OR whatsapp_number = '+' || v_formatted
        ) INTO v_exists;
        
        IF v_exists THEN
            v_skipped := v_skipped + 1;
            CONTINUE;
        END IF;
        
        -- Insert as pre_registered (no name, no access code)
        INSERT INTO public.customers (
            name, whatsapp_number, registration_status, created_at, updated_at
        ) VALUES (
            'Imported Customer', '+' || v_formatted, 'pre_registered', now(), now()
        );
        
        v_inserted := v_inserted + 1;
    END LOOP;

    RETURN jsonb_build_object(
        'success', true,
        'total', v_total,
        'inserted', v_inserted,
        'skipped', v_skipped,
        'message', v_inserted || ' customers imported, ' || v_skipped || ' skipped (duplicates or invalid)'
    );
END;
$$;


--
-- Name: bulk_toggle_customer_product(text[], boolean); Type: FUNCTION; Schema: public; Owner: -
--

