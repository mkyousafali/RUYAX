CREATE FUNCTION public.get_default_flyer_template() RETURNS TABLE(id uuid, name character varying, description text, first_page_image_url text, sub_page_image_urls text[], first_page_configuration jsonb, sub_page_configurations jsonb, metadata jsonb)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  RETURN QUERY
  SELECT 
    t.id,
    t.name,
    t.description,
    t.first_page_image_url,
    t.sub_page_image_urls,
    t.first_page_configuration,
    t.sub_page_configurations,
    t.metadata
  FROM flyer_templates t
  WHERE t.is_default = true 
    AND t.is_active = true 
    AND t.deleted_at IS NULL
  LIMIT 1;
END;
$$;


--
-- Name: get_delivery_fee_for_amount(numeric); Type: FUNCTION; Schema: public; Owner: -
--

