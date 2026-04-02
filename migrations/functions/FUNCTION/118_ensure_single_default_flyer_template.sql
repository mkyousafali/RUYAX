CREATE FUNCTION public.ensure_single_default_flyer_template() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF NEW.is_default = true THEN
    -- Unset all other default templates
    UPDATE flyer_templates 
    SET is_default = false 
    WHERE id != NEW.id 
      AND is_default = true 
      AND deleted_at IS NULL;
  END IF;
  RETURN NEW;
END;
$$;


--
-- Name: export_schema_ddl(); Type: FUNCTION; Schema: public; Owner: -
--

