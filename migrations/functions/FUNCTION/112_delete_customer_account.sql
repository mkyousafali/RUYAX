CREATE FUNCTION public.delete_customer_account(p_customer_id uuid) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_customer record;
BEGIN
    -- Check if customer exists
    SELECT id, name, is_deleted
    INTO v_customer
    FROM public.customers
    WHERE id = p_customer_id;
    
    IF v_customer.id IS NULL THEN
        RETURN json_build_object(
            'success', false,
            'error', 'Customer not found'
        );
    END IF;
    
    IF v_customer.is_deleted = true THEN
        RETURN json_build_object(
            'success', false,
            'error', 'Account already deleted'
        );
    END IF;
    
    -- Soft delete: mark as deleted, clear access code so it can be reused
    UPDATE public.customers
    SET is_deleted = true,
        deleted_at = now(),
        access_code = NULL,
        registration_status = 'suspended',
        updated_at = now()
    WHERE id = p_customer_id;
    
    RETURN json_build_object(
        'success', true,
        'message', 'Account deleted successfully'
    );
END;
$$;


--
-- Name: delete_incident_cascade(text); Type: FUNCTION; Schema: public; Owner: -
--

