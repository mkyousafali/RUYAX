CREATE FUNCTION public.register_app_function(p_function_name text, p_function_code text, p_description text DEFAULT NULL::text, p_category text DEFAULT 'Application'::text, p_enabled boolean DEFAULT true) RETURNS uuid
    LANGUAGE plpgsql
    AS $$
DECLARE
    new_id UUID;
BEGIN
    -- Check if function already exists
    IF EXISTS (SELECT 1 FROM app_functions WHERE function_code = p_function_code) THEN
        -- Update existing function
        UPDATE app_functions 
        SET function_name = p_function_name,
            description = COALESCE(p_description, description),
            category = p_category,
            is_active = p_enabled,
            updated_at = CURRENT_TIMESTAMP
        WHERE function_code = p_function_code
        RETURNING id INTO new_id;
        
        RETURN new_id;
    ELSE
        -- Insert new function
        INSERT INTO app_functions (function_name, function_code, description, category, is_active)
        VALUES (p_function_name, p_function_code, p_description, p_category, p_enabled)
        RETURNING id INTO new_id;
        
        RETURN new_id;
    END IF;
END;
$$;


--
-- Name: register_push_subscription(uuid, character varying, text, text, text, character varying, character varying, text); Type: FUNCTION; Schema: public; Owner: -
--

