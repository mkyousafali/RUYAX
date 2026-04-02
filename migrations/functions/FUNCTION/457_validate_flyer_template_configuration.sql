CREATE FUNCTION public.validate_flyer_template_configuration(config jsonb) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
  field JSONB;
  required_keys TEXT[] := ARRAY['id', 'number', 'x', 'y', 'width', 'height', 'fields'];
BEGIN
  -- Check if config is an array
  IF jsonb_typeof(config) != 'array' THEN
    RAISE EXCEPTION 'Configuration must be a JSON array';
  END IF;
  
  -- Validate each field
  FOR field IN SELECT * FROM jsonb_array_elements(config)
  LOOP
    -- Check required keys exist
    IF NOT (field ?& required_keys) THEN
      RAISE EXCEPTION 'Field missing required keys. Required: %', required_keys;
    END IF;
    
    -- Validate data types
    IF jsonb_typeof(field->'fields') != 'array' THEN
      RAISE EXCEPTION 'Field "fields" must be an array';
    END IF;
    
    -- Validate numeric ranges
    IF (field->>'width')::int <= 0 OR (field->>'height')::int <= 0 THEN
      RAISE EXCEPTION 'Field width and height must be positive';
    END IF;
  END LOOP;
  
  RETURN true;
END;
$$;


--
-- Name: validate_payment_methods(text); Type: FUNCTION; Schema: public; Owner: -
--

