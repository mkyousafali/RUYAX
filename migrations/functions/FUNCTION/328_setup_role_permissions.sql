CREATE FUNCTION public.setup_role_permissions(p_role_code text, p_permissions jsonb DEFAULT '{"can_add": false, "can_edit": false, "can_view": true, "can_delete": false, "can_export": false}'::jsonb) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_role_id UUID;
    func_record RECORD;
    permissions_set INTEGER := 0;
BEGIN
    -- Get role ID
    SELECT id INTO v_role_id FROM user_roles WHERE role_code = p_role_code;
    
    IF v_role_id IS NULL THEN
        RAISE NOTICE 'Role % not found', p_role_code;
        RETURN 0;
    END IF;
    
    -- Set permissions for all active functions
    FOR func_record IN SELECT id FROM app_functions WHERE is_active = true LOOP
        INSERT INTO role_permissions (
            role_id, 
            function_id, 
            can_view, 
            can_add, 
            can_edit, 
            can_delete, 
            can_export
        ) VALUES (
            v_role_id, 
            func_record.id,
            COALESCE((p_permissions->>'can_view')::BOOLEAN, false),
            COALESCE((p_permissions->>'can_add')::BOOLEAN, false),
            COALESCE((p_permissions->>'can_edit')::BOOLEAN, false),
            COALESCE((p_permissions->>'can_delete')::BOOLEAN, false),
            COALESCE((p_permissions->>'can_export')::BOOLEAN, false)
        ) ON CONFLICT (role_id, function_id) DO UPDATE SET
            can_view = COALESCE((p_permissions->>'can_view')::BOOLEAN, false),
            can_add = COALESCE((p_permissions->>'can_add')::BOOLEAN, false),
            can_edit = COALESCE((p_permissions->>'can_edit')::BOOLEAN, false),
            can_delete = COALESCE((p_permissions->>'can_delete')::BOOLEAN, false),
            can_export = COALESCE((p_permissions->>'can_export')::BOOLEAN, false),
            updated_at = NOW();
        
        permissions_set := permissions_set + 1;
    END LOOP;
    
    RETURN permissions_set;
END;
$$;


--
-- Name: skip_visit(uuid, text); Type: FUNCTION; Schema: public; Owner: -
--

