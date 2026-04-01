CREATE FUNCTION public.update_hr_checklist_operations_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$;


--
-- Name: update_hr_checklist_questions_timestamp(); Type: FUNCTION; Schema: public; Owner: -
--

