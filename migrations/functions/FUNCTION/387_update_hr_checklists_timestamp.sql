CREATE FUNCTION public.update_hr_checklists_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$;


--
-- Name: update_hr_employee_master_timestamp(); Type: FUNCTION; Schema: public; Owner: -
--

