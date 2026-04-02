CREATE FUNCTION public.get_or_create_app_function(p_function_code text, p_function_name text DEFAULT NULL::text, p_description text DEFAULT NULL::text, p_category text DEFAULT 'Application'::text) RETURNS uuid
    LANGUAGE plpgsql
    AS $$
DECLARE
    function_id UUID;
BEGIN
    -- Try to get existing function
    SELECT id INTO function_id 
    FROM app_functions 
    WHERE function_code = p_function_code;
    
    -- If not found, create it
    IF function_id IS NULL THEN
        function_id := register_app_function(
            COALESCE(p_function_name, initcap(replace(p_function_code, '_', ' '))),
            p_function_code,
            p_description,
            p_category
        );
    END IF;
    
    RETURN function_id;
END;
$$;


--
-- Name: get_overdue_tasks_without_reminders(); Type: FUNCTION; Schema: public; Owner: -
--

