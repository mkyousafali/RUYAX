CREATE FUNCTION public.update_receiving_task_templates_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$;


--
-- Name: update_receiving_tasks_updated_at(); Type: FUNCTION; Schema: public; Owner: -
--

