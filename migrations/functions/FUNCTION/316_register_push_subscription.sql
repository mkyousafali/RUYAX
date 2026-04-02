CREATE FUNCTION public.register_push_subscription(p_user_id uuid, p_device_id character varying, p_endpoint text, p_p256dh text, p_auth text, p_device_type character varying DEFAULT 'desktop'::character varying, p_browser_name character varying DEFAULT NULL::character varying, p_user_agent text DEFAULT NULL::text) RETURNS uuid
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    subscription_id UUID;
BEGIN
    -- Try to update existing subscription first
    UPDATE push_subscriptions 
    SET 
        endpoint = p_endpoint,
        p256dh = p_p256dh,
        auth = p_auth,
        device_type = p_device_type,
        browser_name = p_browser_name,
        user_agent = p_user_agent,
        is_active = true,
        last_seen = NOW(),
        updated_at = NOW()
    WHERE user_id = p_user_id AND device_id = p_device_id
    RETURNING id INTO subscription_id;
    
    -- If no existing subscription found, create new one
    IF subscription_id IS NULL THEN
        INSERT INTO push_subscriptions (
            user_id,
            device_id,
            endpoint,
            p256dh,
            auth,
            device_type,
            browser_name,
            user_agent,
            is_active,
            last_seen,
            created_at,
            updated_at
        ) VALUES (
            p_user_id,
            p_device_id,
            p_endpoint,
            p_p256dh,
            p_auth,
            p_device_type,
            p_browser_name,
            p_user_agent,
            true,
            NOW(),
            NOW(),
            NOW()
        ) RETURNING id INTO subscription_id;
    END IF;
    
    RETURN subscription_id;
END;
$$;


--
-- Name: register_system_role(text, text, text); Type: FUNCTION; Schema: public; Owner: -
--

