CREATE FUNCTION public.increment_flyer_template_usage() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  UPDATE flyer_templates
  SET 
    usage_count = usage_count + 1,
    last_used_at = now()
  WHERE id = NEW.template_id;
  
  RETURN NEW;
END;
$$;


--
-- Name: increment_page_visit_count(uuid); Type: FUNCTION; Schema: public; Owner: -
--

