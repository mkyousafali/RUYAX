CREATE FUNCTION public.register_system_role(p_role_name text, p_role_code text, p_description text) RETURNS uuid
    LANGUAGE plpgsql
    AS $$
DECLARE
    new_role_id UUID;
BEGIN
    INSERT INTO user_roles (role_name, role_code, description, is_system_role)
    VALUES (p_role_name, p_role_code, p_description, true)
    ON CONFLICT (role_name) DO UPDATE SET
        role_code = p_role_code,
        description = p_description,
        updated_at = NOW()
    RETURNING id INTO new_role_id;
    
    RETURN new_role_id;
END;
$$;


--
-- Name: request_access_code_change(character varying, character varying); Type: FUNCTION; Schema: public; Owner: -
--

