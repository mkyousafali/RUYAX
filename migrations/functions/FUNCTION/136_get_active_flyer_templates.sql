CREATE FUNCTION public.get_active_flyer_templates() RETURNS TABLE(id uuid, name character varying, description text, first_page_image_url text, sub_page_image_urls text[], first_page_configuration jsonb, sub_page_configurations jsonb, metadata jsonb, is_default boolean, category character varying, tags text[], usage_count integer, last_used_at timestamp with time zone, created_at timestamp with time zone)
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
    t.metadata,
    t.is_default,
    t.category,
    t.tags,
    t.usage_count,
    t.last_used_at,
    t.created_at
  FROM flyer_templates t
  WHERE t.is_active = true 
    AND t.deleted_at IS NULL
  ORDER BY 
    t.is_default DESC,
    t.usage_count DESC,
    t.created_at DESC;
END;
$$;


--
-- Name: get_active_offers_for_customer(uuid, integer, character varying); Type: FUNCTION; Schema: public; Owner: -
--

