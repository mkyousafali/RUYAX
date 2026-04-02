CREATE FUNCTION public.soft_delete_flyer_template(template_id uuid) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  is_default_template BOOLEAN;
BEGIN
  -- Check if it's the default template
  SELECT is_default INTO is_default_template
  FROM flyer_templates
  WHERE id = template_id;
  
  -- Prevent deletion of default template
  IF is_default_template = true THEN
    RAISE EXCEPTION 'Cannot delete the default template. Please set another template as default first.';
  END IF;
  
  -- Soft delete
  UPDATE flyer_templates
  SET 
    deleted_at = now(),
    is_active = false
  WHERE id = template_id
    AND deleted_at IS NULL;
  
  RETURN FOUND;
END;
$$;


--
-- Name: start_break(uuid, integer, text); Type: FUNCTION; Schema: public; Owner: -
--

