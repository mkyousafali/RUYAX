CREATE FUNCTION public.refresh_user_roles_from_positions() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    roles_updated INTEGER := 0;
BEGIN
    -- Insert new roles from positions that don't exist yet
    INSERT INTO user_roles (role_name, role_code, description, is_system_role)
    SELECT 
        hp.position_title_en,
        UPPER(REPLACE(REPLACE(hp.position_title_en, ' ', '_'), '/', '_')),
        CONCAT('Access level for ', hp.position_title_en, ' position'),
        false
    FROM hr_positions hp
    WHERE hp.position_title_en IS NOT NULL
    AND NOT EXISTS (
        SELECT 1 FROM user_roles ur 
        WHERE ur.role_name = hp.position_title_en
    );
    
    GET DIAGNOSTICS roles_updated = ROW_COUNT;
    
    -- Update existing roles to ensure they're active
    UPDATE user_roles 
    SET is_active = true, updated_at = NOW()
    WHERE role_name IN (
        SELECT position_title_en 
        FROM hr_positions 
        WHERE position_title_en IS NOT NULL
    )
    AND is_system_role = false;
    
    RETURN roles_updated;
END;
$$;


--
-- Name: register_app_function(text, text, text, text, boolean); Type: FUNCTION; Schema: public; Owner: -
--

