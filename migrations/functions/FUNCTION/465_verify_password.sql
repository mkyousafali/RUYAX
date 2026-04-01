CREATE FUNCTION public.verify_password(input_username character varying, input_password character varying) RETURNS TABLE(user_id uuid, username character varying, email character varying, role_type character varying, is_valid boolean)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        u.id as user_id,
        u.username,
        u.email,
        -- Return derived role_type for backward compatibility
        CASE 
            WHEN u.is_master_admin = true THEN 'Master Admin'::character varying
            WHEN u.is_admin = true THEN 'Admin'::character varying
            ELSE 'User'::character varying
        END as role_type,
        (u.password_hash = crypt(input_password, u.password_hash)) as is_valid
    FROM users u
    WHERE u.username = input_username
      AND u.deleted_at IS NULL
    LIMIT 1;
END;
$$;


--
-- Name: verify_quick_access_code(character varying); Type: FUNCTION; Schema: public; Owner: -
--

