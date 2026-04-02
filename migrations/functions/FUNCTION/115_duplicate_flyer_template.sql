CREATE FUNCTION public.duplicate_flyer_template(template_id uuid, new_name character varying, user_id uuid DEFAULT NULL::uuid) RETURNS uuid
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  new_template_id UUID;
  template_record RECORD;
BEGIN
  -- Get the original template
  SELECT * INTO template_record
  FROM flyer_templates
  WHERE id = template_id
    AND deleted_at IS NULL;
  
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Template not found';
  END IF;
  
  -- Create duplicate
  INSERT INTO flyer_templates (
    name,
    description,
    first_page_image_url,
    sub_page_image_urls,
    first_page_configuration,
    sub_page_configurations,
    metadata,
    is_active,
    is_default,
    category,
    tags,
    created_by,
    updated_by
  ) VALUES (
    new_name,
    'Copy of: ' || COALESCE(template_record.description, template_record.name),
    template_record.first_page_image_url,
    template_record.sub_page_image_urls,
    template_record.first_page_configuration,
    template_record.sub_page_configurations,
    template_record.metadata,
    true,
    false, -- Duplicates are never default
    template_record.category,
    template_record.tags,
    user_id,
    user_id
  )
  RETURNING id INTO new_template_id;
  
  RETURN new_template_id;
END;
$$;


--
-- Name: end_break(uuid); Type: FUNCTION; Schema: public; Owner: -
--

