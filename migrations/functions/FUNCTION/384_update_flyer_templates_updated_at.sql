CREATE FUNCTION public.update_flyer_templates_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;


--
-- Name: update_hr_checklist_operations_timestamp(); Type: FUNCTION; Schema: public; Owner: -
--

