CREATE FUNCTION public.sync_app_functions_from_components(component_metadata jsonb) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
    component JSONB;
    function_record JSONB;
    result_count INTEGER := 0;
    result_text TEXT := '';
BEGIN
    -- Loop through each component in the metadata
    FOR component IN SELECT jsonb_array_elements(component_metadata->'components')
    LOOP
        -- Loop through functions in each component
        FOR function_record IN SELECT jsonb_array_elements(component->'functions')
        LOOP
            -- Register each function
            PERFORM register_app_function(
                function_record->>'name',
                function_record->>'code',
                function_record->>'description',
                COALESCE(function_record->>'category', component->>'category', 'Application')
            );
            
            result_count := result_count + 1;
        END LOOP;
    END LOOP;
    
    result_text := format('Synchronized %s app functions from component metadata', result_count);
    RETURN result_text;
END;
$$;


--
-- Name: sync_employee_with_hr(uuid); Type: FUNCTION; Schema: public; Owner: -
--

