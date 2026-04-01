CREATE FUNCTION public.update_hr_checklist_questions_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$;


--
-- Name: update_hr_checklists_timestamp(); Type: FUNCTION; Schema: public; Owner: -
--

