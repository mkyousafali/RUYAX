CREATE FUNCTION public.create_system_admin(p_username text, p_password text, p_quick_access_code text DEFAULT NULL::text, p_role_type public.role_type_enum DEFAULT 'Master Admin'::public.role_type_enum, p_user_type public.user_type_enum DEFAULT 'global'::public.user_type_enum) RETURNS uuid
    LANGUAGE plpgsql
    AS $$
DECLARE
    password_salt TEXT;
    qr_salt TEXT;
    admin_user_id UUID;
    main_branch_id BIGINT;
    final_quick_code TEXT;
BEGIN
    -- Get main branch ID (or any branch)
    SELECT id INTO main_branch_id FROM branches WHERE is_main_branch = true LIMIT 1;
    IF main_branch_id IS NULL THEN
        SELECT id INTO main_branch_id FROM branches LIMIT 1;
    END IF;
    
    -- Generate salts
    password_salt := generate_salt();
    qr_salt := generate_salt();
    
    -- Use provided quick access code or generate unique one
    IF p_quick_access_code IS NOT NULL THEN
        -- Check if provided code is already in use
        IF EXISTS (SELECT 1 FROM users WHERE quick_access_code = p_quick_access_code) THEN
            RAISE EXCEPTION 'Quick access code % is already in use', p_quick_access_code;
        END IF;
        final_quick_code := p_quick_access_code;
    ELSE
        final_quick_code := generate_unique_quick_access_code();
    END IF;
    
    -- Insert the admin user
    INSERT INTO users (
        username, 
        password_hash, 
        salt,
        quick_access_code, 
        quick_access_salt,
        user_type,
        branch_id,
        role_type, 
        status,
        is_first_login,
        password_expires_at
    ) VALUES (
        p_username,
        hash_password(p_password, password_salt),
        password_salt,
        final_quick_code,
        hash_password(final_quick_code, qr_salt),
        p_user_type,
        main_branch_id,
        p_role_type,
        'active',
        true,
        NOW() + INTERVAL '90 days'
    ) RETURNING id INTO admin_user_id;
    
    RAISE NOTICE 'System admin user created with ID: %', admin_user_id;
    RAISE NOTICE 'Username: %, Role: %, Quick Access: %', p_username, p_role_type, final_quick_code;
    
    RETURN admin_user_id;
END;
$$;


--
-- Name: create_task(text, text, text, text, text, text, date, time without time zone, boolean, boolean, boolean, boolean, boolean); Type: FUNCTION; Schema: public; Owner: -
--

